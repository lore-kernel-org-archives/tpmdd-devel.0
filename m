From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH 3/3] tpm: Get rid of devname
Date: Fri, 12 Feb 2016 17:04:31 -0700
Message-ID: <1455321871-28296-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Stefan Berger <stefanb@us.ibm.com>, Peter Huewe <peterhuewe@gmx.de>
List-Id: tpmdd-devel@lists.sourceforge.net

Now that we have a proper struct device just use dev_name() to
access this value instead of keeping two copies.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm-chip.c        | 17 +++++++++++------
 drivers/char/tpm/tpm.h             |  1 -
 drivers/char/tpm/tpm_eventlog.c    |  2 +-
 drivers/char/tpm/tpm_eventlog.h    |  2 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c |  2 +-
 drivers/char/tpm/tpm_tis.c         |  2 +-
 6 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index b1364bf62492..caa52a6110ec 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -90,6 +90,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 				 const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
+	int err;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -112,8 +113,6 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 
 	set_bit(chip->dev_num, dev_mask);
 
-	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
-
 	dev_set_drvdata(dev, chip);
 
 	chip->dev.class = tpm_class;
@@ -128,7 +127,9 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	dev_set_name(&chip->dev, "%s", chip->devname);
+	err = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
+	if (err)
+		goto out;
 
 	device_initialize(&chip->dev);
 
@@ -137,6 +138,10 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
 	return chip;
+
+out:
+	put_device(&chip->dev);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
@@ -148,7 +153,7 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 	if (rc) {
 		dev_err(&chip->dev,
 			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
-			chip->devname, MAJOR(chip->dev.devt),
+			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
 		device_unregister(&chip->dev);
@@ -159,7 +164,7 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 	if (rc) {
 		dev_err(&chip->dev,
 			"unable to device_register() %s, major %d, minor %d, err=%d\n",
-			chip->devname, MAJOR(chip->dev.devt),
+			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
 		return rc;
@@ -185,7 +190,7 @@ static int tpm1_chip_register(struct tpm_chip *chip)
 	if (rc)
 		return rc;
 
-	chip->bios_dir = tpm_bios_log_setup(chip->devname);
+	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 371f75f4d2a7..a53fc699027b 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -181,7 +181,6 @@ struct tpm_chip {
 	unsigned int flags;
 
 	int dev_num;		/* /dev/tpm# */
-	char devname[7];
 	unsigned long is_open;	/* only one allowed */
 	int time_expired;
 
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index bd72fb04225e..49e50976efc8 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -397,7 +397,7 @@ static int is_bad(void *p)
 	return 0;
 }
 
-struct dentry **tpm_bios_log_setup(char *name)
+struct dentry **tpm_bios_log_setup(const char *name)
 {
 	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
 
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 267bfbd1b7bb..f072a1a1d5cc 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -77,7 +77,7 @@ int read_log(struct tpm_bios_log *log);
 
 #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
 	defined(CONFIG_ACPI)
-extern struct dentry **tpm_bios_log_setup(char *);
+extern struct dentry **tpm_bios_log_setup(const char *name);
 extern void tpm_bios_log_teardown(struct dentry **);
 #else
 static inline struct dentry **tpm_bios_log_setup(char *name)
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 8fb378f502e4..6dd74d114fb3 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -560,7 +560,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 		rc = devm_request_irq(dev, chip->vendor.irq,
 				      i2c_nuvoton_int_handler,
 				      IRQF_TRIGGER_LOW,
-				      chip->devname,
+				      dev_name(&chip->dev),
 				      chip);
 		if (rc) {
 			dev_err(dev, "%s() Unable to request irq: %d for use\n",
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index f15466b7fb78..0cd57371b755 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -610,7 +610,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	u8 original_int_vec;
 
 	if (devm_request_irq(chip->dev.parent, irq, tis_int_handler, flags,
-			     chip->devname, chip) != 0) {
+			     dev_name(&chip->dev), chip) != 0) {
 		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
 			 irq);
 		return -1;
-- 
2.1.4
