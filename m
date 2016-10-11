From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 3/3] tpm_crb: request and relinquish locality 0
Date: Tue, 11 Oct 2016 12:23:06 +0300
Message-ID: <1476177787-15003-5-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1476177787-15003-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1476177787-15003-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Request and relinquish locality for the driver use in order to be
a better citizen in a multi locality environment like TXT. The
locality is requested and relinquished as part of going into and
waking up from idle.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 45f53c2..69debe1 100644
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
@@ -101,12 +110,8 @@ struct crb_priv {
  * @dev:  crb device
  * @priv: crb private data
  *
- * Write CRB_CTRL_REQ_GO_IDLE to TPM_CRB_CTRL_REQ
- * The device should respond within TIMEOUT_C by clearing the bit.
- * Anyhow, we do not wait here as a consequent CMD_READY request
- * will be handled correctly even if idle was not completed.
- *
- * The function does nothing for devices with ACPI-start method.
+ * Put device to the idle state and relinquish locality. The function does
+ * nothing for devices with the ACPI-start method.
  *
  * Return: 0 always
  */
@@ -115,6 +120,7 @@ static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
 	if (priv->flags & CRB_FL_ACPI_START)
 		return 0;
 
+	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs_h->loc_ctrl);
 	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
 	/* we don't really care when this settles */
 
@@ -146,11 +152,8 @@ static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
  * @dev:  crb device
  * @priv: crb private data
  *
- * Write CRB_CTRL_REQ_CMD_READY to TPM_CRB_CTRL_REQ
- * and poll till the device acknowledge it by clearing the bit.
- * The device should respond within TIMEOUT_C.
- *
- * The function does nothing for devices with ACPI-start method
+ * Try to wake up the device and request locality. The function does nothing
+ * for devices with the ACPI-start method.
  *
  * Return: 0 on success -ETIME on timeout;
  */
@@ -165,7 +168,16 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
 				 CRB_CTRL_REQ_CMD_READY /* mask */,
 				 0, /* value */
 				 TPM2_TIMEOUT_C)) {
-		dev_warn(dev, "cmdReady timed out\n");
+		dev_warn(dev, "TPM_CRB_CTRL_REQ_x.cmdReady timed out\n");
+		return -ETIME;
+	}
+
+	iowrite32(CRB_LOC_CTRL_REQUEST_ACCESS, &priv->regs_h->loc_ctrl);
+	if (!crb_wait_for_reg_32(&priv->regs_h->loc_state,
+				 CRB_LOC_STATE_LOC_ASSIGNED, /* mask */
+				 CRB_LOC_STATE_LOC_ASSIGNED, /* value */
+				 TPM2_TIMEOUT_C)) {
+		dev_warn(dev, "TPM_LOC_STATE_x.requestAccess timed out\n");
 		return -ETIME;
 	}
 
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
