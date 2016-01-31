From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: fix rollback/cleanup before
	tpm_chip_register()
Date: Sat, 30 Jan 2016 18:05:42 -0800
Message-ID: <1454205942-13033-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The release-callback is not used before the device is attached to the
device hierarchy. This caused resources not to cleanup properly if the
device driver initialization failed before tpm_chip_register().

This patch fixes the issue by adding the cleanup function to the devres
list of the platform device in tpmm_chip_alloc().

Fixes: 313d21eeab ("tpm: device class for tpm")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/char/tpm/tpm-chip.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 1a9dcee..cf2b351 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -75,16 +75,15 @@ static void tpm_dev_release(struct device *dev)
 }
 
 /**
- * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
- * @dev: device to which the chip is associated
+ * tpmm_chip_alloc() - allocate and initialize a TPM chip
+ * @pdev: the platform device who is the parent of the chip
  * @ops: struct tpm_class_ops instance
  *
- * Allocates a new struct tpm_chip instance and assigns a free
- * device number for it. Caller does not have to worry about
- * freeing the allocated resources. When the devices is removed
- * devres calls tpmm_chip_remove() to do the job.
+ * Allocates a new struct tpm_chip instance, prepares the character device and
+ * assigns a free device number for it. The memory is freed automatically when
+ * the platform device is detached.
  */
-struct tpm_chip *tpmm_chip_alloc(struct device *dev,
+struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
 				 const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
@@ -103,7 +102,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	spin_unlock(&driver_lock);
 
 	if (chip->dev_num >= TPM_NUM_DEVICES) {
-		dev_err(dev, "No available tpm device numbers\n");
+		dev_err(pdev, "No available tpm device numbers\n");
 		kfree(chip);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -112,9 +111,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 
 	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
 
-	chip->pdev = dev;
-
-	dev_set_drvdata(dev, chip);
+	chip->pdev = pdev;
 
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
@@ -136,6 +133,12 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	chip->cdev.owner = chip->pdev->driver->owner;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
+	/* Associate character device with the platform device only after
+	 * it is properly initialized.
+	 */
+	dev_set_drvdata(pdev, chip);
+	devm_add_action(pdev, (void (*)(void *)) tpm_dev_release, &chip->dev);
+
 	return chip;
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
@@ -162,7 +165,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 			MINOR(chip->dev.devt), rc);
 
 		cdev_del(&chip->cdev);
-		return rc;
+	} else {
+		devm_remove_action(chip->dev.parent,
+				   (void (*)(void *)) tpm_dev_release,
+				   &chip->dev);
 	}
 
 	return rc;
@@ -202,15 +208,14 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
 }
 
 /*
- * tpm_chip_register() - create a character device for the TPM chip
- * @chip: TPM chip to use.
+ * tpm_chip_register() - add a TPM chip to the device hierarchy
+ * @chip: the TPM chip to be added
  *
- * Creates a character device for the TPM chip and adds sysfs attributes for
- * the device. As the last step this function adds the chip to the list of TPM
- * chips available for in-kernel use.
+ * Adds a TPM chip to the device hierarchy and makes it available to for
+ * in-kernel use.
  *
- * This function should be only called after the chip initialization is
- * complete.
+ * This function should be called only after the device driver is otherwise
+ * initialized because it will become available for client access.
  */
 int tpm_chip_register(struct tpm_chip *chip)
 {
-- 
2.7.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
