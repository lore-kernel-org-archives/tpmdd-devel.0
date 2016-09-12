From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/4] tmp/tpm_crb: implement runtime pm for
	tpm_crb
Date: Mon, 12 Sep 2016 11:55:01 +0300
Message-ID: <1473670501-29281-5-git-send-email-tomas.winkler@intel.com>
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

Utilize runtime_pm for driving tpm crb idle states.
The framework calls cmd_ready from the pm_runtime_resume handler
and go idle from the pm_runtime_suspend handler.
The TPM framework should wake the device before transmit and receive.
In case the runtime_pm framework is not enabled, the device will be in
ready state.

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
V2 new in the series 
 drivers/char/tpm/tpm-interface.c |  5 +++++
 drivers/char/tpm/tpm_crb.c       | 37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index fd863ff30f79..9ccad3a9875f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -29,6 +29,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/pm_runtime.h>
 
 #include "tpm.h"
 #include "tpm_eventlog.h"
@@ -353,6 +354,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_lock(&chip->tpm_mutex);
 
+	pm_runtime_get_sync(chip->dev.parent);
+
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
 		dev_err(&chip->dev,
@@ -394,6 +397,8 @@ out_recv:
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
+	pm_runtime_put_sync(chip->dev.parent);
+
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_unlock(&chip->tpm_mutex);
 	return rc;
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 524f34b5371e..5b4c1f6246ed 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -19,6 +19,7 @@
 #include <linux/highmem.h>
 #include <linux/rculist.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 #include "tpm.h"
 
 #define ACPI_SIG_TPM2 "TPM2"
@@ -145,8 +146,6 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
-
 static u8 crb_status(struct tpm_chip *chip)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
@@ -429,9 +428,16 @@ static int crb_acpi_add(struct acpi_device *device)
 	if (rc)
 		return rc;
 
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	rc = tpm_chip_register(chip);
-	if (rc)
+	if (rc) {
 		crb_go_idle(dev, priv);
+		pm_runtime_disable(dev);
+	}
+
+	pm_runtime_put(dev);
 
 	return rc;
 }
@@ -443,9 +449,34 @@ static int crb_acpi_remove(struct acpi_device *device)
 
 	tpm_chip_unregister(chip);
 
+	pm_runtime_disable(dev);
+
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int crb_pm_runtime_suspend(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+
+	return crb_go_idle(dev, priv);
+}
+
+static int crb_pm_runtime_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
+
+	return crb_cmd_ready(dev, priv);
+}
+#endif /* CONFIG_PM */
+
+static const struct dev_pm_ops crb_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(tpm_pm_suspend, tpm_pm_resume)
+	SET_RUNTIME_PM_OPS(crb_pm_runtime_suspend, crb_pm_runtime_resume, NULL)
+};
+
 static struct acpi_device_id crb_device_ids[] = {
 	{"MSFT0101", 0},
 	{"", 0},
-- 
2.7.4


------------------------------------------------------------------------------
