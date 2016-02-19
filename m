From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v3 01/11] tpm: fix the cleanup of struct tpm_chip
Date: Fri, 19 Feb 2016 07:41:58 -0500
Message-ID: <1455885728-10315-2-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

If the initialization fails before tpm_chip_register(), put_device()
will be not called, which causes release callback not to be called.
This patch fixes the issue by adding put_device() to devres list of
the parent device.

Fixes: 313d21eeab ("tpm: device class for tpm")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm-chip.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 45cc39a..ab32437 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -88,6 +88,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 				 const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
+	int err;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -136,6 +137,12 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	chip->cdev.owner = chip->pdev->driver->owner;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
+	err = devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
+	if (err) {
+		put_device(&chip->dev);
+		return ERR_PTR(err);
+	}
+
 	return chip;
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
@@ -171,7 +178,7 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 static void tpm_dev_del_device(struct tpm_chip *chip)
 {
 	cdev_del(&chip->cdev);
-	device_unregister(&chip->dev);
+	device_del(&chip->dev);
 }
 
 static int tpm1_chip_register(struct tpm_chip *chip)
-- 
2.4.3
