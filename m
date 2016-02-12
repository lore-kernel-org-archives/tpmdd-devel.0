From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 11:34:15 -0700
Message-ID: <20160212183415.GA4289@obsidianresearch.com>
References: <201602111534.u1BFYvRs019573@d01av03.pok.ibm.com>
	<20160211181208.GA6285@obsidianresearch.com>
	<201602111911.u1BJB2nK017410@d01av03.pok.ibm.com>
	<20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120356.u1C3usEe002034@d03av04.boulder.ibm.com>
	<201602121813.u1CIDu4O015272@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602121813.u1CIDu4O015272-4ZtxiNBBw+3ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 12, 2016 at 01:13:39PM -0500, Stefan Berger wrote:
>    Stefan Berger/Watson/IBM@IBMUS wrote on 02/11/2016 10:56:47 PM:
>    >
>    > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/11/
>    > 2016 06:56:11 PM:
>    >
>    >
>    > >
>    > > On Thu, Feb 11, 2016 at 05:26:24PM -0500, Stefan Berger wrote:
>    > >
>    > > >    > What is the point of tpmm_chip_dev?
>    > > >    So that the usage model of the chip is the same. We get this
>    in the
>    > > >    tpm-vtpm.c with tpm_alloc_chip + tpmm_chip_dev while all
>    others can
>    > > >    call tpmm_chip_alloc, which combines the two.
>    > >
>    > > No need, just don't use devm in vtpm, that is even better. The
>    > > standard devm idiom is a with and without version.
>    >
>    > Updated the branch. Are you going to upstream your patch? Otherwise
>    > I would just add your Signed-off-by to it if that's ok ?
>    >
>    > [1]https://github.com/stefanberger/linux/tree/vtpm-driver.v3
>    I converted tpm-chip.c to use IDA as well.
>    A test for 4096 vTPM instances:
>    for ((i = 0; i < 4096; i++)); do ./vtpmctrl & done

Yeah, that looks good, thanks for doing this

Do other places using ida for this still limit the number of char
devices? It feels strange to pre allocate so many, but I don't know
off hand a solution.

Please also get rid of tpm_chip_list, just use the ida lookup in
tpm_chip_find_get.

Use err here, dev_num really should be unsigned:

+	chip->dev_num = ida_simple_get(&dev_nums_ida, 0, TPM_NUM_DEVICES, GFP_KERNEL);
+	if (chip->dev_num < 0) {

And use something like this to deal with the size of devname:

>From afc11daa8d0762c4ad0315b762bf1eab95e46ee2 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Fri, 12 Feb 2016 11:32:37 -0700
Subject: [PATCH] tpm: Get rid of devname

Now that we have a proper struct device just use dev_name() to
access this value instead of keeping two copies.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c        | 17 +++++++++++------
 drivers/char/tpm/tpm.h             |  1 -
 drivers/char/tpm/tpm_eventlog.c    |  2 +-
 drivers/char/tpm/tpm_eventlog.h    |  2 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c |  2 +-
 drivers/char/tpm/tpm_tis.c         |  2 +-
 6 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 8134003b023c..c07e397bfddd 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -88,6 +88,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 				const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
+	int err;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -111,8 +112,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	set_bit(chip->dev_num, dev_mask);
 	device_initialize(&chip->dev);
 
-	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
-
 	chip->pdev = dev;
 
 	chip->dev.class = tpm_class;
@@ -127,12 +126,18 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	dev_set_name(&chip->dev, "%s", chip->devname);
+	err = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
+	if (err)
+		goto out;
 
 	cdev_init(&chip->cdev, &tpm_fops);
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
 	return chip;
+
+out:
+	device_put(&chip->dev);
+	return PTR_ERR(err);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_alloc);
 
@@ -174,7 +179,7 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 	if (rc) {
 		dev_err(&chip->dev,
 			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
-			chip->devname, MAJOR(chip->dev.devt),
+			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
 		device_unregister(&chip->dev);
@@ -185,7 +190,7 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 	if (rc) {
 		dev_err(&chip->dev,
 			"unable to device_register() %s, major %d, minor %d, err=%d\n",
-			chip->devname, MAJOR(chip->dev.devt),
+			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
 		return rc;
@@ -211,7 +216,7 @@ static int tpm1_chip_register(struct tpm_chip *chip)
 	if (rc)
 		return rc;
 
-	chip->bios_dir = tpm_bios_log_setup(chip->devname);
+	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 3a5452f09b96..d51ac7f0da01 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -174,7 +174,6 @@ struct tpm_chip {
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
index 847f1597fe9b..02f2b35ad753 100644
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
index 12aa96a69b6c..39bc0e908e38 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -578,7 +578,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	u8 original_int_vec;
 
 	if (devm_request_irq(chip->pdev, irq, tis_int_handler, flags,
-			     chip->devname, chip) != 0) {
+			     dev_name(&chip->dev), chip) != 0) {
 		dev_info(chip->pdev, "Unable to request irq: %d for probe\n",
 			 irq);
 		return -1;
-- 
2.1.4


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
