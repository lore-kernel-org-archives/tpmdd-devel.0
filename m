From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/3] tpm: cmd_ready command can be issued only after granting locality
Date: Tue, 23 Jan 2018 13:27:29 +0200
Message-ID: <20180123112731.3687-1-tomas.winkler@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>, tpmdd-devel@lists.sourceforge.net, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The correct sequence is to first request locality and only after
that perform cmd_ready  handshake, otherwise the hardware will drop
the subsequent message as from the device point of view the cmd_ready
handshake wasn't performed. Symmetrically locality has to be relinquished
only after going idle handshake has completed, this requires that
go_idle has to poll for the completion.

The issue is only visible on devices that support multiple localities.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/char/tpm/tpm-interface.c | 12 ++---
 drivers/char/tpm/tpm_crb.c       | 95 ++++++++++++++++++++++++++--------------
 2 files changed, 70 insertions(+), 37 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 76df4fbcf089..197fda39aab5 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -422,8 +422,6 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_lock(&chip->tpm_mutex);
 
-	if (chip->dev.parent)
-		pm_runtime_get_sync(chip->dev.parent);
 
 	if (chip->ops->clk_enable != NULL)
 		chip->ops->clk_enable(chip, true);
@@ -439,6 +437,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 		chip->locality = rc;
 	}
 
+	if (chip->dev.parent)
+		pm_runtime_get_sync(chip->dev.parent);
+
 	rc = tpm2_prepare_space(chip, space, ordinal, buf);
 	if (rc)
 		goto out;
@@ -499,17 +500,18 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	rc = tpm2_commit_space(chip, space, ordinal, buf, &len);
 
 out:
+	if (chip->dev.parent)
+		pm_runtime_put_sync(chip->dev.parent);
+
 	if (need_locality && chip->ops->relinquish_locality) {
 		chip->ops->relinquish_locality(chip, chip->locality);
 		chip->locality = -1;
 	}
+
 out_no_locality:
 	if (chip->ops->clk_enable != NULL)
 		chip->ops->clk_enable(chip, false);
 
-	if (chip->dev.parent)
-		pm_runtime_put_sync(chip->dev.parent);
-
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_unlock(&chip->tpm_mutex);
 	return rc ? rc : len;
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 7b3c2a8aa9de..d174919c446d 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -112,6 +112,25 @@ struct tpm2_crb_smc {
 	u32 smc_func_id;
 };
 
+static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
+				unsigned long timeout)
+{
+	ktime_t start;
+	ktime_t stop;
+
+	start = ktime_get();
+	stop = ktime_add(start, ms_to_ktime(timeout));
+
+	do {
+		if ((ioread32(reg) & mask) == value)
+			return true;
+
+		usleep_range(50, 100);
+	} while (ktime_before(ktime_get(), stop));
+
+	return ((ioread32(reg) & mask) == value);
+}
+
 /**
  * crb_go_idle - request tpm crb device to go the idle state
  *
@@ -128,7 +147,7 @@ struct tpm2_crb_smc {
  *
  * Return: 0 always
  */
-static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
+static int crb_go_idle(struct device *dev, struct crb_priv *priv)
 {
 	if ((priv->sm == ACPI_TPM2_START_METHOD) ||
 	    (priv->sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD) ||
@@ -136,30 +155,17 @@ static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
 		return 0;
 
 	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
-	/* we don't really care when this settles */
 
+	if (!crb_wait_for_reg_32(&priv->regs_t->ctrl_req,
+				 CRB_CTRL_REQ_GO_IDLE/* mask */,
+				 0, /* value */
+				 TPM2_TIMEOUT_C)) {
+		dev_warn(dev, "goIdle timed out\n");
+		return -ETIME;
+	}
 	return 0;
 }
 
-static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
-				unsigned long timeout)
-{
-	ktime_t start;
-	ktime_t stop;
-
-	start = ktime_get();
-	stop = ktime_add(start, ms_to_ktime(timeout));
-
-	do {
-		if ((ioread32(reg) & mask) == value)
-			return true;
-
-		usleep_range(50, 100);
-	} while (ktime_before(ktime_get(), stop));
-
-	return false;
-}
-
 /**
  * crb_cmd_ready - request tpm crb device to enter ready state
  *
@@ -175,8 +181,7 @@ static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
  *
  * Return: 0 on success -ETIME on timeout;
  */
-static int __maybe_unused crb_cmd_ready(struct device *dev,
-					struct crb_priv *priv)
+static int crb_cmd_ready(struct device *dev, struct crb_priv *priv)
 {
 	if ((priv->sm == ACPI_TPM2_START_METHOD) ||
 	    (priv->sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD) ||
@@ -195,11 +200,11 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
 	return 0;
 }
 
-static int crb_request_locality(struct tpm_chip *chip, int loc)
+static int __crb_request_locality(struct device *dev,
+				  struct crb_priv *priv, int loc)
 {
-	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
 	u32 value = CRB_LOC_STATE_LOC_ASSIGNED |
-		CRB_LOC_STATE_TPM_REG_VALID_STS;
+		    CRB_LOC_STATE_TPM_REG_VALID_STS;
 
 	if (!priv->regs_h)
 		return 0;
@@ -207,23 +212,36 @@ static int crb_request_locality(struct tpm_chip *chip, int loc)
 	iowrite32(CRB_LOC_CTRL_REQUEST_ACCESS, &priv->regs_h->loc_ctrl);
 	if (!crb_wait_for_reg_32(&priv->regs_h->loc_state, value, value,
 				 TPM2_TIMEOUT_C)) {
-		dev_warn(&chip->dev, "TPM_LOC_STATE_x.requestAccess timed out\n");
+		dev_warn(dev, "TPM_LOC_STATE_x.requestAccess timed out\n");
 		return -ETIME;
 	}
 
 	return 0;
 }
 
-static void crb_relinquish_locality(struct tpm_chip *chip, int loc)
+static int crb_request_locality(struct tpm_chip *chip, int loc)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
 
+	return __crb_request_locality(&chip->dev, priv, loc);
+}
+
+static void __crb_relinquish_locality(struct device *dev,
+				      struct crb_priv *priv, int loc)
+{
 	if (!priv->regs_h)
 		return;
 
 	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs_h->loc_ctrl);
 }
 
+static void crb_relinquish_locality(struct tpm_chip *chip, int loc)
+{
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+
+	__crb_relinquish_locality(&chip->dev, priv, loc);
+}
+
 static u8 crb_status(struct tpm_chip *chip)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
@@ -475,6 +493,10 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 			dev_warn(dev, FW_BUG "Bad ACPI memory layout");
 	}
 
+	ret = __crb_request_locality(dev, priv, 0);
+	if (ret)
+		return ret;
+
 	priv->regs_t = crb_map_res(dev, priv, &io_res, buf->control_address,
 				   sizeof(struct crb_regs_tail));
 	if (IS_ERR(priv->regs_t))
@@ -531,6 +553,8 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 
 	crb_go_idle(dev, priv);
 
+	__crb_relinquish_locality(dev, priv, 0);
+
 	return ret;
 }
 
@@ -588,10 +612,14 @@ static int crb_acpi_add(struct acpi_device *device)
 	chip->acpi_dev_handle = device->handle;
 	chip->flags = TPM_CHIP_FLAG_TPM2;
 
-	rc  = crb_cmd_ready(dev, priv);
+	rc = __crb_request_locality(dev, priv, 0);
 	if (rc)
 		return rc;
 
+	rc  = crb_cmd_ready(dev, priv);
+	if (rc)
+		goto out;
+
 	pm_runtime_get_noresume(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
@@ -601,12 +629,15 @@ static int crb_acpi_add(struct acpi_device *device)
 		crb_go_idle(dev, priv);
 		pm_runtime_put_noidle(dev);
 		pm_runtime_disable(dev);
-		return rc;
+		goto out;
 	}
 
-	pm_runtime_put(dev);
+	pm_runtime_put_sync(dev);
 
-	return 0;
+out:
+	__crb_relinquish_locality(dev, priv, 0);
+
+	return rc;
 }
 
 static int crb_acpi_remove(struct acpi_device *device)
-- 
2.14.3

