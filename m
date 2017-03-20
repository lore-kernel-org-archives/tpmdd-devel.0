From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] tpm/tpm_crb: mark PM functions as __maybe_unused
Date: Mon, 20 Mar 2017 10:17:19 +0100
Message-ID: <20170320091755.1043811-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Winkler, Tomas" <tomas.winkler@intel.com>, Jerry Snitselaar <jsnitsel@redhat.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

When CONFIG_PM_SLEEP is disabled, we get a warning about unused functions:

drivers/char/tpm/tpm_crb.c:551:12: error: 'crb_pm_resume' defined but not used [-Werror=unused-function]
drivers/char/tpm/tpm_crb.c:540:12: error: 'crb_pm_suspend' defined but not used [-Werror=unused-function]

We could solve this with more sophistated #ifdefs, but a simpler and safer
way is to just mark them as __maybe_unused.

Fixes: 848efcfb560c ("tpm/tpm_crb: enter the low power state upon device suspend")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/tpm/tpm_crb.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 1dfc37e33c02..15f1118982a6 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -519,8 +519,7 @@ static int crb_acpi_remove(struct acpi_device *device)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int crb_pm_runtime_suspend(struct device *dev)
+static __maybe_unused int crb_pm_runtime_suspend(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
@@ -528,7 +527,7 @@ static int crb_pm_runtime_suspend(struct device *dev)
 	return crb_go_idle(dev, priv);
 }
 
-static int crb_pm_runtime_resume(struct device *dev)
+static __maybe_unused int crb_pm_runtime_resume(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
@@ -536,7 +535,7 @@ static int crb_pm_runtime_resume(struct device *dev)
 	return crb_cmd_ready(dev, priv);
 }
 
-static int crb_pm_suspend(struct device *dev)
+static __maybe_unused int crb_pm_suspend(struct device *dev)
 {
 	int ret;
 
@@ -547,7 +546,7 @@ static int crb_pm_suspend(struct device *dev)
 	return crb_pm_runtime_suspend(dev);
 }
 
-static int crb_pm_resume(struct device *dev)
+static __maybe_unused int crb_pm_resume(struct device *dev)
 {
 	int ret;
 
@@ -558,8 +557,6 @@ static int crb_pm_resume(struct device *dev)
 	return tpm_pm_resume(dev);
 }
 
-#endif /* CONFIG_PM */
-
 static const struct dev_pm_ops crb_pm = {
 	SET_SYSTEM_SLEEP_PM_OPS(crb_pm_suspend, crb_pm_resume)
 	SET_RUNTIME_PM_OPS(crb_pm_runtime_suspend, crb_pm_runtime_resume, NULL)
-- 
2.9.0
