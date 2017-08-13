From: Jiandi An <anjiandi@codeaurora.org>
Subject: [PATCH v2] tpm/tpm_crb: Access locality for only CRB_START method
Date: Sat, 12 Aug 2017 20:22:49 -0500
Message-ID: <1502587369-24436-1-git-send-email-anjiandi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, anjiandi@codeaurora.org
List-Id: tpmdd-devel@lists.sourceforge.net

For ARM64, the locality is handled by Trust Zone in FW.
The layout does not have crb_regs_head.  It is hitting
the following line.
dev_warn(dev, FW_BUG "Bad ACPI memory layout");

Current code excludes CRB_FL_ACPI_START and when
CRB_FL_CRB_SMC_START is added around the same time
locality support is added, it should also be excluded.
Change the if condition to be only for CRB_FL_CRB_START.

For goIdle and cmdReady where code was excluding
CRB_FL_ACPI_START only (do nothing for ACPI start method),
CRB_FL_CRB_SMC_START was also excluded as ARM64 SMC start
method does not have TPM_CRB_CTRL_REQ.
Change the if condition to be only for CRB_FL_CRB_START
in crb_go_idle() and crb_cmd_ready().

Signed-off-by: Jiandi An <anjiandi@codeaurora.org>
---
v2
Changed if condition to CRB_FL_CRB_START for go idle
and crb_cmd_ready per maintainer's comment.

 drivers/char/tpm/tpm_crb.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 8f0a98d..7a6735d 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -128,18 +128,16 @@ struct tpm2_crb_smc {
  * Anyhow, we do not wait here as a consequent CMD_READY request
  * will be handled correctly even if idle was not completed.
  *
- * The function does nothing for devices with ACPI-start method.
+ * The function does nothing for devices with ACPI-start method
+ * and SMC-start method.
  *
  * Return: 0 always
  */
 static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
 {
-	if ((priv->flags & CRB_FL_ACPI_START) ||
-	    (priv->flags & CRB_FL_CRB_SMC_START))
-		return 0;
-
-	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
-	/* we don't really care when this settles */
+	if (priv->flags & CRB_FL_CRB_START)
+		iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
+		/* we don't really care when this settles */
 
 	return 0;
 }
@@ -174,23 +172,23 @@ static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
  * The device should respond within TIMEOUT_C.
  *
  * The function does nothing for devices with ACPI-start method
+ * and SMC-start method.
  *
  * Return: 0 on success -ETIME on timeout;
  */
 static int __maybe_unused crb_cmd_ready(struct device *dev,
 					struct crb_priv *priv)
 {
-	if ((priv->flags & CRB_FL_ACPI_START) ||
-	    (priv->flags & CRB_FL_CRB_SMC_START))
-		return 0;
-
-	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
-	if (!crb_wait_for_reg_32(&priv->regs_t->ctrl_req,
-				 CRB_CTRL_REQ_CMD_READY /* mask */,
-				 0, /* value */
-				 TPM2_TIMEOUT_C)) {
-		dev_warn(dev, "cmdReady timed out\n");
-		return -ETIME;
+	if (priv->flags & CRB_FL_CRB_START)
+	{
+		iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
+		if (!crb_wait_for_reg_32(&priv->regs_t->ctrl_req,
+					 CRB_CTRL_REQ_CMD_READY /* mask */,
+					 0, /* value */
+					 TPM2_TIMEOUT_C)) {
+			dev_warn(dev, "cmdReady timed out\n");
+			return -ETIME;
+		}
 	}
 
 	return 0;
@@ -458,7 +456,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	 * the control area, as one nice sane region except for some older
 	 * stuff that puts the control area outside the ACPI IO region.
 	 */
-	if (!(priv->flags & CRB_FL_ACPI_START)) {
+	if (priv->flags & CRB_FL_CRB_START) {
 		if (buf->control_address == io_res.start +
 		    sizeof(*priv->regs_h))
 			priv->regs_h = priv->iobase;
-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
