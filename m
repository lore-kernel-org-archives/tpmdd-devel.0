From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm_crb: request and relinquish locality 0
Date: Sat, 11 Mar 2017 01:58:00 +0200
Message-ID: <20170310235802.30765-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>, gang.wei@intel.com, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Added two new callbacks to struct tpm_class_ops:

- request_locality
- relinquish_locality

These are called before sending and receiving data from the TPM.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c |  9 +++++++++
 drivers/char/tpm/tpm_crb.c       | 41 +++++++++++++++++++++++++++++++++++++++-
 include/linux/tpm.h              |  3 ++-
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index bd2128e..ae6aafa 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -369,6 +369,12 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	if (chip->dev.parent)
 		pm_runtime_get_sync(chip->dev.parent);
 
+	if (chip->ops->request_locality)  {
+		rc = chip->ops->request_locality(chip);
+		if (rc)
+			goto out;
+	}
+
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
 		dev_err(&chip->dev,
@@ -410,6 +416,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
+	if (chip->ops->relinquish_locality)
+		chip->ops->relinquish_locality(chip);
+
 	if (chip->dev.parent)
 		pm_runtime_put_sync(chip->dev.parent);
 
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 3245618..89dc8a176 100644
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
@@ -172,6 +181,35 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
 	return 0;
 }
 
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
+		return -ETIME;
+	}
+
+	return 0;
+}
+
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
@@ -198,7 +236,6 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	memcpy_fromio(buf, priv->rsp, 6);
 	expected = be32_to_cpup((__be32 *) &buf[2]);
-
 	if (expected > count)
 		return -EIO;
 
@@ -279,6 +316,8 @@ static const struct tpm_class_ops tpm_crb = {
 	.send = crb_send,
 	.cancel = crb_cancel,
 	.req_canceled = crb_req_canceled,
+	.request_locality = crb_request_locality,
+	.relinquish_locality = crb_relinquish_locality,
 	.req_complete_mask = CRB_DRV_STS_COMPLETE,
 	.req_complete_val = CRB_DRV_STS_COMPLETE,
 };
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index da158f0..0ac6ea6 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -48,7 +48,8 @@ struct tpm_class_ops {
 	u8 (*status) (struct tpm_chip *chip);
 	bool (*update_timeouts)(struct tpm_chip *chip,
 				unsigned long *timeout_cap);
-
+	int (*request_locality)(struct tpm_chip *chip);
+	void (*relinquish_locality)(struct tpm_chip *chip);
 };
 
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
-- 
2.9.3

