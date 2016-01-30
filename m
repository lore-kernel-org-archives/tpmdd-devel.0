From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix rollback when adding char dev fails
Date: Fri, 29 Jan 2016 16:28:14 -0800
Message-ID: <1454113694-7997-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Fixed rollback and gave better names to the functions (more
self-documenting, less confusing).

Fixes: d972b0523f ("tpm: fix call order in tpm-chip.c")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm-chip.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 45cc39a..1a9dcee 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -140,7 +140,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
-static int tpm_dev_add_device(struct tpm_chip *chip)
+static int tpm_add_char_device(struct tpm_chip *chip)
 {
 	int rc;
 
@@ -151,7 +151,6 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 			chip->devname, MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
-		device_unregister(&chip->dev);
 		return rc;
 	}
 
@@ -162,13 +161,14 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 			chip->devname, MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
+		cdev_del(&chip->cdev);
 		return rc;
 	}
 
 	return rc;
 }
 
-static void tpm_dev_del_device(struct tpm_chip *chip)
+static void tpm_del_char_device(struct tpm_chip *chip)
 {
 	cdev_del(&chip->cdev);
 	device_unregister(&chip->dev);
@@ -222,7 +222,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 
 	tpm_add_ppi(chip);
 
-	rc = tpm_dev_add_device(chip);
+	rc = tpm_add_char_device(chip);
 	if (rc)
 		goto out_err;
 
@@ -274,6 +274,6 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 		sysfs_remove_link(&chip->pdev->kobj, "ppi");
 
 	tpm1_chip_unregister(chip);
-	tpm_dev_del_device(chip);
+	tpm_del_char_device(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_unregister);
-- 
2.7.0
