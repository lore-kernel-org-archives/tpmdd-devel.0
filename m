From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 3/3] tpm_crb: request and relinquish
	locality 0
Date: Wed,  7 Dec 2016 13:50:00 +0200
Message-ID: <20161207115001.18332-4-jarkko.sakkinen@linux.intel.com>
References: <20161207115001.18332-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161207115001.18332-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Request and relinquish locality for the driver use in order to be a
better citizen in a multi locality environment like TXT.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 73 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 853bd7b..96f661a 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -34,6 +34,15 @@ enum crb_defaults {
 	CRB_ACPI_START_INDEX = 1,
 };
 
+enum crb_loc_ctrl {
+	CRB_LOC_CTRL_REQUEST_ACCESS	= BIT(0),
+	CRB_LOC_CTRL_RELINQUISH		= BIT(1),
+};
+
+enum crb_loc_state {
+	CRB_LOC_STATE_LOC_ASSIGNED	= BIT(1),
+};
+
 enum crb_ctrl_req {
 	CRB_CTRL_REQ_CMD_READY	= BIT(0),
 	CRB_CTRL_REQ_GO_IDLE	= BIT(1),
@@ -165,13 +174,42 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
 				 CRB_CTRL_REQ_CMD_READY /* mask */,
 				 0, /* value */
 				 TPM2_TIMEOUT_C)) {
-		dev_warn(dev, "cmdReady timed out\n");
+		dev_warn(dev, "TPM_CRB_CTRL_REQ_x.cmdReady timed out\n");
+		return -ETIME;
+	}
+
+	return 0;
+}
+
+static int crb_request_locality(struct tpm_chip *chip)
+{
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+
+	if (!priv->regs_h)
+		return 0;
+
+	iowrite32(CRB_LOC_CTRL_REQUEST_ACCESS, &priv->regs_h->loc_ctrl);
+	if (!crb_wait_for_reg_32(&priv->regs_h->loc_state,
+				 CRB_LOC_STATE_LOC_ASSIGNED, /* mask */
+				 CRB_LOC_STATE_LOC_ASSIGNED, /* value */
+				 TPM2_TIMEOUT_C)) {
+		dev_warn(&chip->dev, "TPM_LOC_STATE_x.requestAccess timed out\n");
 		return -ETIME;
 	}
 
 	return 0;
 }
 
+static void crb_relinquish_locality(struct tpm_chip *chip)
+{
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+
+	if (!priv->regs_h)
+		return;
+
+	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs_h->loc_ctrl);
+}
+
 static u8 crb_status(struct tpm_chip *chip)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
@@ -188,23 +226,33 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
 	unsigned int expected;
+	int rc;
 
 	/* sanity check */
 	if (count < 6)
 		return -EIO;
 
-	if (ioread32(&priv->regs_t->ctrl_sts) & CRB_CTRL_STS_ERROR)
-		return -EIO;
+	rc = crb_request_locality(chip);
+	if (rc)
+		return rc;
+
+	if (ioread32(&priv->regs_t->ctrl_sts) & CRB_CTRL_STS_ERROR) {
+		rc = -EIO;
+		goto out;
+	}
 
 	memcpy_fromio(buf, priv->rsp, 6);
 	expected = be32_to_cpup((__be32 *) &buf[2]);
-
-	if (expected > count)
-		return -EIO;
+	if (expected > count) {
+		rc = -EIO;
+		goto out;
+	}
 
 	memcpy_fromio(&buf[6], &priv->rsp[6], expected - 6);
 
-	return expected;
+out:
+	crb_relinquish_locality(chip);
+	return rc ? rc : expected;
 }
 
 static int crb_do_acpi_start(struct tpm_chip *chip)
@@ -227,7 +275,11 @@ static int crb_do_acpi_start(struct tpm_chip *chip)
 static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
-	int rc = 0;
+	int rc;
+
+	rc = crb_request_locality(chip);
+	if (rc)
+		return rc;
 
 	/* Zero the cancel register so that the next command will not get
 	 * canceled.
@@ -237,7 +289,8 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	if (len > priv->cmd_size) {
 		dev_err(&chip->dev, "invalid command count value %zd %d\n",
 			len, priv->cmd_size);
-		return -E2BIG;
+		rc = -E2BIG;
+		goto out;
 	}
 
 	memcpy_toio(priv->cmd, buf, len);
@@ -251,6 +304,8 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	if (priv->flags & CRB_FL_ACPI_START)
 		rc = crb_do_acpi_start(chip);
 
+out:
+	crb_relinquish_locality(chip);
 	return rc;
 }
 
-- 
2.9.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/xeonphi
