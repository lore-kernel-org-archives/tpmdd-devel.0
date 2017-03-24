From: Jarkko Sakkinen <jarkko.sakkinen-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v4] tpm_crb: request and relinquish locality 0
Date: Fri, 24 Mar 2017 12:10:30 +0200
Message-ID: <20170324101032.13496-1-jarkko.sakkinen@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Jarkko Sakkinen <jarkko.sakkinen-X3B1VOXEql0@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This commit adds support for requesting and relinquishing locality 0 in
tpm_crb for the course of command transmission.

In order to achieve this, two new callbacks are added to struct
tpm_class_ops:

- request_locality
- relinquish_locality

With CRB interface you first set either requestAccess or relinquish bit
from TPM_LOC_CTRL_x register and then wait for locAssigned and
tpmRegValidSts bits to be set in the TPM_LOC_STATE_x register.

The reason why were are doing this is to make sure that the driver
will work properly with Intel TXT that uses locality 2. There's no
explicit guarantee that it would relinquish this locality. In more
general sense this commit enables tpm_crb to be a well behaving
citizen in a multi locality environment.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
v2:
- TPM driver level calllbacks
v3:
- Call ops->relinquish_locality only if ops->request_locality has been
  successful.
- Do not reserve locality in nested tpm_transmit calls.
- Check for tpmRegValidSts to make sure that the value in TPM_LOC_STATE_x is
  stable.
v4:
- Removed tpm_tis_core changes. It needs to be done separately. It will be
  postponed to 4.13.
- Store locality to struct tpm_chip while active.
 drivers/char/tpm/tpm-chip.c      |  1 +
 drivers/char/tpm/tpm-interface.c | 13 +++++++++++++
 drivers/char/tpm/tpm.h           |  3 +++
 drivers/char/tpm/tpm_crb.c       | 41 ++++++++++++++++++++++++++++++++++++++++
 include/linux/tpm.h              |  3 ++-
 5 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index aade699..a321bd5 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -231,6 +231,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 		goto out;
 	}
 
+	chip->locality = -1;
 	return chip;
 
 out:
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 95c6f98..1815666 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -384,6 +384,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	ssize_t len = 0;
 	u32 count, ordinal;
 	unsigned long stop;
+	bool need_locality = chip->locality == -1;
 
 	if (!tpm_validate_command(chip, buf, bufsiz))
 		return -EINVAL;
@@ -407,6 +408,13 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	if (chip->dev.parent)
 		pm_runtime_get_sync(chip->dev.parent);
 
+	if (need_locality && chip->ops->request_locality)  {
+		rc = chip->ops->request_locality(chip, 0);
+		if (rc < 0)
+			goto out_no_locality;
+		chip->locality = rc;
+	}
+
 	rc = tpm2_prepare_space(chip, space, ordinal, buf);
 	if (rc)
 		goto out;
@@ -466,6 +474,11 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	rc = tpm2_commit_space(chip, space, ordinal, buf, &len);
 
 out:
+	if (need_locality && chip->ops->relinquish_locality) {
+		chip->ops->relinquish_locality(chip, 0);
+		chip->locality = -1;
+	}
+out_no_locality:
 	if (chip->dev.parent)
 		pm_runtime_put_sync(chip->dev.parent);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 5eacb3f..4b4c8de 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -228,6 +228,9 @@ struct tpm_chip {
 	struct tpm_space work_space;
 	u32 nr_commands;
 	u32 *cc_attrs_tbl;
+
+	/* active locality */
+	int locality;
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 9f31609..d91e47d 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -34,6 +34,16 @@ enum crb_defaults {
 	CRB_ACPI_START_INDEX = 1,
 };
 
+enum crb_loc_ctrl {
+	CRB_LOC_CTRL_REQUEST_ACCESS	= BIT(0),
+	CRB_LOC_CTRL_RELINQUISH		= BIT(1),
+};
+
+enum crb_loc_state {
+	CRB_LOC_STATE_LOC_ASSIGNED	= BIT(1),
+	CRB_LOC_STATE_TPM_REG_VALID_STS	= BIT(7),
+};
+
 enum crb_ctrl_req {
 	CRB_CTRL_REQ_CMD_READY	= BIT(0),
 	CRB_CTRL_REQ_GO_IDLE	= BIT(1),
@@ -172,6 +182,35 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
 	return 0;
 }
 
+static int crb_request_locality(struct tpm_chip *chip, int loc)
+{
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+	u32 value = CRB_LOC_STATE_LOC_ASSIGNED |
+		CRB_LOC_STATE_TPM_REG_VALID_STS;
+
+	if (!priv->regs_h)
+		return 0;
+
+	iowrite32(CRB_LOC_CTRL_REQUEST_ACCESS, &priv->regs_h->loc_ctrl);
+	if (!crb_wait_for_reg_32(&priv->regs_h->loc_state, value, value,
+				 TPM2_TIMEOUT_C)) {
+		dev_warn(&chip->dev, "TPM_LOC_STATE_x.requestAccess timed out\n");
+		return -ETIME;
+	}
+
+	return 0;
+}
+
+static void crb_relinquish_locality(struct tpm_chip *chip, int loc)
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
@@ -278,6 +317,8 @@ static const struct tpm_class_ops tpm_crb = {
 	.send = crb_send,
 	.cancel = crb_cancel,
 	.req_canceled = crb_req_canceled,
+	.request_locality = crb_request_locality,
+	.relinquish_locality = crb_relinquish_locality,
 	.req_complete_mask = CRB_DRV_STS_COMPLETE,
 	.req_complete_val = CRB_DRV_STS_COMPLETE,
 };
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index da158f0..5a090f5 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -48,7 +48,8 @@ struct tpm_class_ops {
 	u8 (*status) (struct tpm_chip *chip);
 	bool (*update_timeouts)(struct tpm_chip *chip,
 				unsigned long *timeout_cap);
-
+	int (*request_locality)(struct tpm_chip *chip, int loc);
+	void (*relinquish_locality)(struct tpm_chip *chip, int loc);
 };
 
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
