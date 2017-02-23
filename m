From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] tpm: Use the right clean up after cdev_add
	completes
Date: Thu, 23 Feb 2017 14:19:14 -0700
Message-ID: <20170223211914.GA12752@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Once cdev_add is done the device node is visible to user space and
could have been opened. Thus we have to go through the locking
process in tpm_del_char_device if device_add fails.

Fixes: 2c91ce8523a ("tpm: fix the rollback in tpm_chip_register()")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

static function moved to avoid a prototype

This was noticed while reviewing the cdev patchset from Logan

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index a77262d31911a1..c82acf0a6e7353 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -226,6 +226,26 @@ struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
+static void tpm_del_char_device(struct tpm_chip *chip, bool with_device)
+{
+	cdev_del(&chip->cdev);
+	if (with_device) {
+		device_del(&chip->dev);
+
+		/* Make the chip unavailable. */
+		mutex_lock(&idr_lock);
+		idr_replace(&dev_nums_idr, NULL, chip->dev_num);
+		mutex_unlock(&idr_lock);
+	}
+
+	/* Make the driver uncallable. */
+	down_write(&chip->ops_sem);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_shutdown(chip, TPM2_SU_CLEAR);
+	chip->ops = NULL;
+	up_write(&chip->ops_sem);
+}
+
 static int tpm_add_char_device(struct tpm_chip *chip)
 {
 	int rc;
@@ -246,8 +266,7 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 			"unable to device_register() %s, major %d, minor %d, err=%d\n",
 			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
-
-		cdev_del(&chip->cdev);
+		tpm_del_char_device(chip, false);
 		return rc;
 	}
 
@@ -259,24 +278,6 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 	return rc;
 }
 
-static void tpm_del_char_device(struct tpm_chip *chip)
-{
-	cdev_del(&chip->cdev);
-	device_del(&chip->dev);
-
-	/* Make the chip unavailable. */
-	mutex_lock(&idr_lock);
-	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
-	mutex_unlock(&idr_lock);
-
-	/* Make the driver uncallable. */
-	down_write(&chip->ops_sem);
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		tpm2_shutdown(chip, TPM2_SU_CLEAR);
-	chip->ops = NULL;
-	up_write(&chip->ops_sem);
-}
-
 static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
 {
 	struct attribute **i;
@@ -384,6 +385,6 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 {
 	tpm_del_legacy_sysfs(chip);
 	tpm_bios_log_teardown(chip);
-	tpm_del_char_device(chip);
+	tpm_del_char_device(chip, true);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_unregister);
-- 
2.7.4

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
