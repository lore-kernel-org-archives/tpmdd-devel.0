From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 2/3] tpm_crb: encapsulate
	crb_wait_for_reg_32
Date: Sat,  3 Dec 2016 19:52:12 +0200
Message-ID: <20161203175213.10210-3-jarkko.sakkinen@linux.intel.com>
References: <20161203175213.10210-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161203175213.10210-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Encapsulated crb_wait_for_reg32() so that state changes in other CRB
registers than TPM_CRB_CTRL_REQ_x can be waited.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 8d81b66..f986d02 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -121,6 +121,25 @@ static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
 	return 0;
 }
 
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
+	return false;
+}
+
 /**
  * crb_cmd_ready - request tpm crb device to enter ready state
  *
@@ -138,24 +157,14 @@ static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
 static int __maybe_unused crb_cmd_ready(struct device *dev,
 					struct crb_priv *priv)
 {
-	ktime_t stop, start;
-	u32 req;
-
 	if (priv->flags & CRB_FL_ACPI_START)
 		return 0;
 
 	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
-
-	start = ktime_get();
-	stop = ktime_add(start, ms_to_ktime(TPM2_TIMEOUT_C));
-	do {
-		req = ioread32(&priv->regs_t->ctrl_req);
-		if (!(req & CRB_CTRL_REQ_CMD_READY))
-			return 0;
-		usleep_range(50, 100);
-	} while (ktime_before(ktime_get(), stop));
-
-	if (ioread32(&priv->regs_t->ctrl_req) & CRB_CTRL_REQ_CMD_READY) {
+	if (!crb_wait_for_reg_32(&priv->regs_t->ctrl_req,
+				 CRB_CTRL_REQ_CMD_READY /* mask */,
+				 0, /* value */
+				 TPM2_TIMEOUT_C)) {
 		dev_warn(dev, "cmdReady timed out\n");
 		return -ETIME;
 	}
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
