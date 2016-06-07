From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 3/3] tpm, tpm_crb: runtime power management
Date: Wed,  8 Jun 2016 02:02:02 +0300
Message-ID: <1465340522-1112-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1465340522-1112-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465340522-1112-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The register TPM_CRB_CTRL_REQ_0 contains bits goIdle and cmdReady for
invoking the chip to suspend and resume. This commit implements runtime
PM for tpm_crb by using these bits.

The legacy ACPI start (SMI + DMA) based devices do not support these
bits. Thus this functionality only is enabled only for CRB start (MMIO)
based devices.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c |  3 ++
 drivers/char/tpm/tpm_crb.c       | 62 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 2 deletions(-)

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
index ca2cad9..71cc7cd 100644
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
@@ -68,6 +68,8 @@ struct crb_control_area {
 
 enum crb_status {
 	CRB_STS_COMPLETE	= BIT(0),
+	CRB_STS_READY		= BIT(1),
+	CRB_STS_IDLE		= BIT(2),
 };
 
 enum crb_flags {
@@ -81,9 +83,52 @@ struct crb_priv {
 	struct crb_control_area __iomem *cca;
 	u8 __iomem *cmd;
 	u8 __iomem *rsp;
+	wait_queue_head_t idle_queue;
 };
 
-static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
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
+
+	iowrite32(cpu_to_le32(req | CRB_CA_REQ_GO_IDLE), &priv->cca->req);
+
+	if (wait_for_tpm_stat(chip, CRB_STS_IDLE, chip->timeout_c,
+			      &priv->idle_queue, false))
+		dev_warn(&chip->dev, "idle timed out\n");
+
+	return 0;
+}
+
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
+
+	if (wait_for_tpm_stat(chip, CRB_STS_READY, chip->timeout_c,
+			      &priv->idle_queue, false))
+		dev_warn(&chip->dev, "wake timed out\n");
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
@@ -94,6 +139,14 @@ static u8 crb_status(struct tpm_chip *chip)
 	    CRB_START_INVOKE)
 		sts |= CRB_STS_COMPLETE;
 
+	if ((ioread32(&priv->cca->req) & CRB_CA_REQ_CMD_READY) !=
+	    CRB_CA_REQ_CMD_READY)
+		sts |= CRB_STS_READY;
+
+	if ((ioread32(&priv->cca->req) & CRB_CA_REQ_GO_IDLE) !=
+	    CRB_CA_REQ_GO_IDLE)
+		sts |= CRB_STS_IDLE;
+
 	return sts;
 }
 
@@ -206,6 +259,8 @@ static int crb_init(struct acpi_device *device, struct crb_priv *priv)
 	if (IS_ERR(chip))
 		return PTR_ERR(chip);
 
+	pm_runtime_set_active(&device->dev);
+	pm_runtime_enable(&device->dev);
 	dev_set_drvdata(&chip->dev, priv);
 	chip->acpi_dev_handle = device->handle;
 	chip->flags = TPM_CHIP_FLAG_TPM2;
@@ -348,6 +403,8 @@ static int crb_acpi_add(struct acpi_device *device)
 	    !strcmp(acpi_device_hid(device), "MSFT0101"))
 		priv->flags |= CRB_FL_CRB_START;
 
+	init_waitqueue_head(&priv->idle_queue);
+
 	if (sm == ACPI_TPM2_START_METHOD ||
 	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
 		priv->flags |= CRB_FL_ACPI_START;
@@ -366,6 +423,7 @@ static int crb_acpi_remove(struct acpi_device *device)
 
 	tpm_chip_unregister(chip);
 
+	pm_runtime_disable(dev);
 	return 0;
 }
 
-- 
2.7.4
