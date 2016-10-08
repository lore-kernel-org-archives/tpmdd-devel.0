From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 1/4] tpm/tpm_crb: implement tpm crb idle
	state
Date: Sat,  8 Oct 2016 14:59:36 +0300
Message-ID: <1475927979-23484-2-git-send-email-tomas.winkler@intel.com>
References: <1475927979-23484-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1475927979-23484-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady for
SW to indicate that the device can enter or should exit the idle state.

The legacy ACPI-start (SMI + DMA) based devices do not support these
bits and the idle state management is not exposed to the host SW.
Thus, this functionality only is enabled only for a CRB start (MMIO)
based devices.

Based on Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
original patch:
'tpm_crb: implement power tpm crb power management'

To keep the implementation local to the hw we don't use wait_for_tpm_stat
for polling the TPM_CRB_CTRL_REQ.

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
V2: do not export the functions via tpm ops
V3: fix lower case corruption; adjust function documentation
V4: resend

 drivers/char/tpm/tpm_crb.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index a7c870af916c..0f3b3f3d12d3 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -83,6 +83,76 @@ struct crb_priv {
 	u32 cmd_size;
 };
 
+/**
+ * crb_go_idle - request tpm crb device to go the idle state
+ *
+ * @dev:  crb device
+ * @priv: crb private data
+ *
+ * Write CRB_CTRL_REQ_GO_IDLE to TPM_CRB_CTRL_REQ
+ * The device should respond within TIMEOUT_C by clearing the bit.
+ * Anyhow, we do not wait here as a consequent CMD_READY request
+ * will be handled correctly even if idle was not completed.
+ *
+ * The function does nothing for devices with ACPI-start method.
+ *
+ * Return: 0 always
+ */
+static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
+{
+	if (priv->flags & CRB_FL_ACPI_START)
+		return 0;
+
+	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->cca->req);
+	/* we don't really care when this settles */
+	dev_dbg(dev, "goIdle\n");
+
+	return 0;
+}
+
+/**
+ * crb_cmd_ready - request tpm crb device to enter ready state
+ *
+ * @dev:  crb device
+ * @priv: crb private data
+ *
+ * Write CRB_CTRL_REQ_CMD_READY to TPM_CRB_CTRL_REQ
+ * and poll till the device acknowledge it by clearing the bit.
+ * The device should respond within TIMEOUT_C.
+ *
+ * The function does nothing for devices with ACPI-start method
+ *
+ * Return: 0 on success -ETIME on timeout;
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
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
