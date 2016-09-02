From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 3/4] tpm_crb: refine the naming of constants
Date: Fri,  2 Sep 2016 22:34:19 +0300
Message-ID: <1472844861-24599-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1472844861-24599-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1472844861-24599-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Renamed CRB protocol specific constants to match the TCG PC Client
Platform TPM Profile (PTP) Specification and driver status constants
to be explicit that they are driver specific.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 358c475..c8b0d91 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -34,14 +34,14 @@ enum crb_defaults {
 	CRB_ACPI_START_INDEX = 1,
 };
 
-enum crb_ca_request {
-	CRB_CA_REQ_GO_IDLE	= BIT(0),
-	CRB_CA_REQ_CMD_READY	= BIT(1),
+enum crb_ctrl_req {
+	CRB_CTRL_REQ_GO_IDLE	= BIT(0),
+	CRB_CTRL_REQ_CMD_READY	= BIT(1),
 };
 
-enum crb_ca_status {
-	CRB_CA_STS_ERROR	= BIT(0),
-	CRB_CA_STS_TPM_IDLE	= BIT(1),
+enum crb_ctrl_sts {
+	CRB_CTRL_STS_ERROR	= BIT(0),
+	CRB_CTRL_STS_TPM_IDLE	= BIT(1),
 };
 
 enum crb_start {
@@ -67,7 +67,7 @@ struct crb_control_area {
 } __packed;
 
 enum crb_status {
-	CRB_STS_COMPLETE	= BIT(0),
+	CRB_DRV_STS_COMPLETE	= BIT(0),
 };
 
 enum crb_flags {
@@ -92,7 +92,7 @@ static u8 crb_status(struct tpm_chip *chip)
 
 	if ((ioread32(&priv->cca->start) & CRB_START_INVOKE) !=
 	    CRB_START_INVOKE)
-		sts |= CRB_STS_COMPLETE;
+		sts |= CRB_DRV_STS_COMPLETE;
 
 	return sts;
 }
@@ -106,7 +106,7 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	if (count < 6)
 		return -EIO;
 
-	if (ioread32(&priv->cca->sts) & CRB_CA_STS_ERROR)
+	if (ioread32(&priv->cca->sts) & CRB_CTRL_STS_ERROR)
 		return -EIO;
 
 	memcpy_fromio(buf, priv->rsp, 6);
@@ -194,8 +194,8 @@ static const struct tpm_class_ops tpm_crb = {
 	.send = crb_send,
 	.cancel = crb_cancel,
 	.req_canceled = crb_req_canceled,
-	.req_complete_mask = CRB_STS_COMPLETE,
-	.req_complete_val = CRB_STS_COMPLETE,
+	.req_complete_mask = CRB_DRV_STS_COMPLETE,
+	.req_complete_val = CRB_DRV_STS_COMPLETE,
 };
 
 static int crb_init(struct acpi_device *device, struct crb_priv *priv)
-- 
2.7.4


------------------------------------------------------------------------------
