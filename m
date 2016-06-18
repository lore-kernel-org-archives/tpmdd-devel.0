From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 3/3] tpm, tpm_crb: runtime power management
Date: Sat, 18 Jun 2016 17:10:28 +0200
Message-ID: <1466262628-25530-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1466262628-25530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1466262628-25530-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

The register TPM_CRB_CTRL_REQ_0 contains bits goIdle and cmdReady for
invoking the chip to suspend and resume. This commit implements runtime
PM for tpm_crb by using these bits.

The legacy ACPI start (SMI + DMA) based devices do not support these
bits. Thus this functionality only is enabled only for CRB start (MMIO)
based devices.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c |  3 +++
 drivers/char/tpm/tpm_crb.c       | 50 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 5e3c1b6..3b85648 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -29,6 +29,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/pm_runtime.h>
 
 #include "tpm.h"
 #include "tpm_eventlog.h"
@@ -350,6 +351,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		return -E2BIG;
 	}
 
+	pm_runtime_get_sync(chip->dev.parent);
 	mutex_lock(&chip->tpm_mutex);
 
 	rc = chip->ops->send(chip, (u8 *) buf, count);
@@ -394,6 +396,7 @@ out_recv:
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
 	mutex_unlock(&chip->tpm_mutex);
+	pm_runtime_put_sync(chip->dev.parent);
 	return rc;
 }
 
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 0c8ed7f..ef545eb 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -20,6 +20,7 @@
 #include <linux/rculist.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include "tpm.h"
 
 #define ACPI_SIG_TPM2 "TPM2"
@@ -41,7 +42,6 @@ enum crb_ca_request {
 
 enum crb_ca_status {
 	CRB_CA_STS_ERROR	= BIT(0),
-	CRB_CA_STS_TPM_IDLE	= BIT(1),
 };
 
 enum crb_start {
@@ -83,7 +83,50 @@ struct crb_priv {
 	u8 __iomem *rsp;
 };
 
-static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
+/* CONFIG_PM */
+static int __maybe_unused crb_runtime_suspend(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+	u32 req;
+
+	if (priv->flags & CRB_FL_ACPI_START)
+		return 0;
+
+	req = ioread32(&priv->cca->req);
+	iowrite32(cpu_to_le32(req | CRB_CA_REQ_GO_IDLE), &priv->cca->req);
+	msleep(chip->timeout_c);
+
+	if (ioread32(&priv->cca->req) & CRB_CA_REQ_GO_IDLE)
+		return -ETIME;
+
+	return 0;
+}
+
+/* CONFIG_PM */
+static int __maybe_unused crb_runtime_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+	u32 req;
+
+	if (priv->flags & CRB_FL_ACPI_START)
+		return 0;
+
+	req = ioread32(&priv->cca->req);
+	iowrite32(cpu_to_le32(req | CRB_CA_REQ_CMD_READY), &priv->cca->req);
+	msleep(chip->timeout_c);
+
+	if (ioread32(&priv->cca->req) & CRB_CA_REQ_CMD_READY)
+		return -ETIME;
+
+	return 0;
+}
+
+static const struct dev_pm_ops crb_pm = {
+	SET_RUNTIME_PM_OPS(crb_runtime_suspend, crb_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(tpm_pm_suspend, tpm_pm_resume)
+};
 
 static u8 crb_status(struct tpm_chip *chip)
 {
@@ -206,6 +249,8 @@ static int crb_init(struct acpi_device *device, struct crb_priv *priv)
 	if (IS_ERR(chip))
 		return PTR_ERR(chip);
 
+	pm_runtime_set_active(&device->dev);
+	pm_runtime_enable(&device->dev);
 	dev_set_drvdata(&chip->dev, priv);
 	chip->acpi_dev_handle = device->handle;
 	chip->flags = TPM_CHIP_FLAG_TPM2;
@@ -366,6 +411,7 @@ static int crb_acpi_remove(struct acpi_device *device)
 
 	tpm_chip_unregister(chip);
 
+	pm_runtime_disable(dev);
 	return 0;
 }
 
-- 
2.7.4


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://sdm.link/zohomanageengine
