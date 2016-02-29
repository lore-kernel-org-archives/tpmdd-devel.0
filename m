From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 02/10] tpm: Get rid of devname
Date: Mon, 29 Feb 2016 12:29:48 -0500
Message-ID: <1456766996-9300-3-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1456766996-9300-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Now that we have a proper struct device just use dev_name() to
access this value instead of keeping two copies.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c        | 18 +++++++++++-------
 drivers/char/tpm/tpm.h             |  1 -
 drivers/char/tpm/tpm_eventlog.c    |  2 +-
 drivers/char/tpm/tpm_eventlog.h    |  2 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c |  2 +-
 drivers/char/tpm/tpm_tis.c         |  2 +-
 6 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 12829dd..c21d81c 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -111,7 +111,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 
 	set_bit(chip->dev_num, dev_mask);
 
-	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
+	device_initialize(&chip->dev);
 
 	dev_set_drvdata(dev, chip);
 
@@ -127,9 +127,9 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	dev_set_name(&chip->dev, "%s", chip->devname);
-
-	device_initialize(&chip->dev);
+	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
+	if (rc)
+		goto out;
 
 	cdev_init(&chip->cdev, &tpm_fops);
 	chip->cdev.owner = dev->driver->owner;
@@ -142,6 +142,10 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	}
 
 	return chip;
+
+out:
+	put_device(&chip->dev);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
@@ -153,7 +157,7 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 	if (rc) {
 		dev_err(&chip->dev,
 			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
-			chip->devname, MAJOR(chip->dev.devt),
+			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
 		return rc;
@@ -163,7 +167,7 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 	if (rc) {
 		dev_err(&chip->dev,
 			"unable to device_register() %s, major %d, minor %d, err=%d\n",
-			chip->devname, MAJOR(chip->dev.devt),
+			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
 		cdev_del(&chip->cdev);
@@ -190,7 +194,7 @@ static int tpm1_chip_register(struct tpm_chip *chip)
 	if (rc)
 		return rc;
 
-	chip->bios_dir = tpm_bios_log_setup(chip->devname);
+	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 9c9be6c..5d33ba5 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -174,7 +174,6 @@ struct tpm_chip {
 	unsigned int flags;
 
 	int dev_num;		/* /dev/tpm# */
-	char devname[7];
 	unsigned long is_open;	/* only one allowed */
 	int time_expired;
 
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index 4e6940a..e722886 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -403,7 +403,7 @@ static int is_bad(void *p)
 	return 0;
 }
 
-struct dentry **tpm_bios_log_setup(char *name)
+struct dentry **tpm_bios_log_setup(const char *name)
 {
 	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
 
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 267bfbd..cc9672f 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -77,7 +77,7 @@ int read_log(struct tpm_bios_log *log);
 
 #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
 	defined(CONFIG_ACPI)
-extern struct dentry **tpm_bios_log_setup(char *);
+extern struct dentry **tpm_bios_log_setup(const char *);
 extern void tpm_bios_log_teardown(struct dentry **);
 #else
 static inline struct dentry **tpm_bios_log_setup(char *name)
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index a1e1474..d61d43f 100644
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
index 0a9aee9..eed3bf5 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -577,7 +577,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	u8 original_int_vec;
 
 	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
-			     chip->devname, chip) != 0) {
+			     dev_name(&chip->dev), chip) != 0) {
 		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
 			 irq);
 		return -1;
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
