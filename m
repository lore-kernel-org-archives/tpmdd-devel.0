From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/4] tpm/tpm_crb: implement tpm crb idle
	state
Date: Mon, 12 Sep 2016 11:54:58 +0300
Message-ID: <1473670501-29281-2-git-send-email-tomas.winkler@intel.com>
References: <1473670501-29281-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1473670501-29281-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady for
SW to indicate that the device can enter or should exit the idle state.

The legacy ACPI-start (SMI + DMA) based devices do not support these
bits and the idle state management is not exposed to the host SW.
Thus, this functionality only is enabled only for a CRB start (MMIO)
based devices.

Based on Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
oringal patch:
'tpm_crb: implement power tpm crb power management'

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
V2: do not export the functions via tpm ops

 drivers/char/tpm/tpm_crb.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 6e9d1bca712f..49023ac3dea1 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -83,6 +83,68 @@ struct crb_priv {
 	u32 cmd_size;
 };
 
+/**
+ * crb_go_idle - write CRB_CTRL_REQ_GO_IDLE to TPM_CRB_CTRL_REQ
+ *    The device should respond within TIMEOUT_C by clearing the bit.
+ *    Anyhow, we do not wait here as a consequent CMD_READY request
+ *    will be handled correctly even if idle was not completed.
+ *
+ * @dev:  crb device
+ * @priv: crb private data
+ * Return:  0 always
+ */
+static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
+{
+	if (priv->flags & CRB_FL_ACPI_START)
+		return 0;
+
+	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->cca->req);
+	/* we don't really care when this settles */
+
+	return 0;
+}
+
+/**
+ * crb_cmd_ready - write CRB_CTRL_REQ_CMD_READY to TPM_CRB_CTRL_REQ
+ *      and poll till the device acknowledge it by clearing the bit.
+ *      The device should respond within TIMEOUT_C.
+ *
+ *      The function does nothing for devices with ACPI-start method
+ *
+ * @dev:  crb device
+ * @priv: crb private data
+ *
+ * Return:  0 on success -ETIME on timeout;
+ */
+static int __maybe_unused crb_cmd_ready(struct device *dev,
+					struct crb_priv *priv)
+{
+	ktime_t stop, start;
+
+	if (priv->flags & CRB_FL_ACPI_START)
+		return 0;
+
+	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->cca->req);
+
+	start = ktime_get();
+	stop = ktime_add(start, ms_to_ktime(TPM2_TIMEOUT_C));
+	do {
+		if (!(ioread32(&priv->cca->req) & CRB_CTRL_REQ_CMD_READY)) {
+			dev_dbg(dev, "cmdReady in %lld usecs\n",
+				ktime_to_us(ktime_sub(ktime_get(), start)));
+			return 0;
+		}
+		usleep_range(50, 100);
+	} while (ktime_before(ktime_get(), stop));
+
+	if (ioread32(&priv->cca->req) & CRB_CTRL_REQ_CMD_READY) {
+		dev_warn(dev, "cmdReady timed out\n");
+		return -ETIME;
+	}
+
+	return 0;
+}
+
 static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
 
 static u8 crb_status(struct tpm_chip *chip)
-- 
2.7.4


------------------------------------------------------------------------------
