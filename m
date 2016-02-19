From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 03/11] tpm: Get rid of devname
Date: Fri, 19 Feb 2016 07:42:00 -0500
Message-ID: <1455885728-10315-4-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455885728-10315-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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
---
 drivers/char/tpm/tpm-chip.c        | 16 ++++++++++------
 drivers/char/tpm/tpm.h             |  1 -
 drivers/char/tpm/tpm_eventlog.c    |  2 +-
 drivers/char/tpm/tpm_eventlog.h    |  2 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c |  2 +-
 drivers/char/tpm/tpm_tis.c         |  4 ++--
 6 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 5ed9bed..5df0149 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -111,8 +111,6 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 
 	set_bit(chip->dev_num, dev_mask);
 
-	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
-
 	dev_set_drvdata(dev, chip);
 
 	chip->dev.class = tpm_class;
@@ -127,7 +125,9 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	dev_set_name(&chip->dev, "%s", chip->devname);
+	err = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
+	if (err)
+		goto out;
 
 	device_initialize(&chip->dev);
 
@@ -142,6 +142,10 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	}
 
 	return chip;
+
+out:
+	put_device(&chip->dev);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
@@ -153,7 +157,7 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 	if (rc) {
 		dev_err(&chip->dev,
 			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
-			chip->devname, MAJOR(chip->dev.devt),
+			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
 		device_unregister(&chip->dev);
@@ -164,7 +168,7 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 	if (rc) {
 		dev_err(&chip->dev,
 			"unable to device_register() %s, major %d, minor %d, err=%d\n",
-			chip->devname, MAJOR(chip->dev.devt),
+			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
 		return rc;
@@ -190,7 +194,7 @@ static int tpm1_chip_register(struct tpm_chip *chip)
 	if (rc)
 		return rc;
 
-	chip->bios_dir = tpm_bios_log_setup(chip->devname);
+	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 1ce6547..31d9a8e 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -178,7 +178,6 @@ struct tpm_chip {
 	unsigned int flags;
 
 	int dev_num;		/* /dev/tpm# */
-	char devname[7];
 	unsigned long is_open;	/* only one allowed */
 	int time_expired;
 
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index bd72fb0..49e5097 100644
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
index 0b5fc41..37f3d44 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -765,7 +765,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 				 TPM_INT_VECTOR(chip->vendor.locality));
 			if (devm_request_irq
 			    (dev, i, tis_int_probe, IRQF_SHARED,
-			     chip->devname, chip) != 0) {
+			     dev_name(&chip->dev), chip) != 0) {
 				dev_info(&chip->dev,
 					 "Unable to request irq: %d for probe\n",
 					 i);
@@ -817,7 +817,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 			 TPM_INT_VECTOR(chip->vendor.locality));
 		if (devm_request_irq
 		    (dev, chip->vendor.irq, tis_int_handler, IRQF_SHARED,
-		     chip->devname, chip) != 0) {
+		     dev_name(&chip->dev), chip) != 0) {
 			dev_info(&chip->dev,
 				 "Unable to request irq: %d for use\n",
 				 chip->vendor.irq);
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
