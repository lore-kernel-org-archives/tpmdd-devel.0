From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] tpm/tpm_crb: implement tpm crb idle state
Date: Wed,  7 Sep 2016 14:32:31 +0300
Message-ID: <1473247953-24617-2-git-send-email-tomas.winkler@intel.com>
References: <1473247953-24617-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1473247953-24617-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady for
SW to indicate that the device can enter or should exit the idle state.

The legacy ACPI-start (SMI + DMA) based devices do not support these
bits and the idle state management is not exposed to the host SW.
Thus, this functionality only is enabled only for a CRB start (MMIO)
based devices.

We introduce two new callbacks for command ready and go idle for TPM CRB
device which are called across TPM transactions.

Based on Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> oringal patch
'tpm_crb: implement power tpm crb power management'

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 21 +++++++++++
 drivers/char/tpm/tpm_crb.c       | 77 ++++++++++++++++++++++++++++++++++++++++
 include/linux/tpm.h              |  3 +-
 3 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index fd863ff30f79..c78dca5ce7a6 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -327,6 +327,20 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
+static inline int tpm_go_idle(struct tpm_chip *chip)
+{
+	if (!chip->ops->idle)
+		return 0;
+	return chip->ops->idle(chip);
+}
+
+static inline int tpm_cmd_ready(struct tpm_chip *chip)
+{
+	if (!chip->ops->ready)
+		return 0;
+	return chip->ops->ready(chip);
+}
+
 /*
  * Internal kernel interface to transmit TPM commands
  */
@@ -353,6 +367,10 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_lock(&chip->tpm_mutex);
 
+	rc = tpm_cmd_ready(chip);
+	if (rc)
+		goto out;
+
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
 		dev_err(&chip->dev,
@@ -394,8 +412,11 @@ out_recv:
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
+	tpm_go_idle(chip);
+
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_unlock(&chip->tpm_mutex);
+
 	return rc;
 }
 
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 82a3ccd52a3a..98a7fdfe9936 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -83,6 +83,81 @@ struct crb_priv {
 	u8 __iomem *rsp;
 };
 
+/**
+ * __crb_go_idle - write CRB_CTRL_REQ_GO_IDLE to TPM_CRB_CTRL_REQ
+ *    The device should respond within TIMEOUT_C by clearing the bit.
+ *    Anyhow, we do not wait here as a consequent CMD_READY request
+ *    will be handled correctly even if idle was not completed.
+ *
+ * @dev: tpm device
+ * @priv: crb private context
+ *
+ * Return:  0 always
+ */
+static int __crb_go_idle(struct device *dev, struct crb_priv *priv)
+{
+	if (priv->flags & CRB_FL_ACPI_START)
+		return 0;
+	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->cca->req);
+	/* we don't really care when this settles */
+
+	return 0;
+}
+
+static int crb_go_idle(struct tpm_chip *chip)
+{
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+
+	return __crb_go_idle(&chip->dev, priv);
+}
+
+/**
+ * __crb_cmd_ready - write CRB_CTRL_REQ_CMD_READY to TPM_CRB_CTRL_REQ
+ *      and poll till the device acknowledge it by clearing the bit.
+ *      The device should respond within TIMEOUT_C.
+ *
+ *      The function does nothing for devices with ACPI-start method
+ *
+ * @dev: tpm device
+ * @priv: crb private context
+ *
+ * Return:  0 on success -ETIME on timeout;
+ */
+static int __crb_cmd_ready(struct device *dev, struct crb_priv *priv)
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
+		usleep_range(500, 1000);
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
+static int crb_cmd_ready(struct tpm_chip *chip)
+{
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+
+	return __crb_cmd_ready(&chip->dev, priv);
+}
+
 static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
 
 static u8 crb_status(struct tpm_chip *chip)
@@ -193,6 +268,8 @@ static const struct tpm_class_ops tpm_crb = {
 	.recv = crb_recv,
 	.send = crb_send,
 	.cancel = crb_cancel,
+	.ready = crb_cmd_ready,
+	.idle = crb_go_idle,
 	.req_canceled = crb_req_canceled,
 	.req_complete_mask = CRB_DRV_STS_COMPLETE,
 	.req_complete_val = CRB_DRV_STS_COMPLETE,
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index da158f06e0b2..1ed9ff6a5d48 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -48,7 +48,8 @@ struct tpm_class_ops {
 	u8 (*status) (struct tpm_chip *chip);
 	bool (*update_timeouts)(struct tpm_chip *chip,
 				unsigned long *timeout_cap);
-
+	int (*idle)(struct tpm_chip *chip);
+	int (*ready)(struct tpm_chip *chip);
 };
 
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
-- 
2.7.4


------------------------------------------------------------------------------
