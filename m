From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Thu, 11 Feb 2016 12:48:10 -0700
Message-ID: <20160211194810.GA24211@obsidianresearch.com>
References: <20160210035620.GB7161@intel.com>
	<201602100515.u1A5FpFi002736@d03av02.boulder.ibm.com>
	<20160210162809.GB20730@obsidianresearch.com>
	<201602102145.u1ALjSAs001597@d03av04.boulder.ibm.com>
	<20160210222313.GA7047@obsidianresearch.com>
	<201602110038.u1B0cuE0030670@d03av05.boulder.ibm.com>
	<20160211070426.GB9307@intel.com>
	<201602111534.u1BFYvRs019573@d01av03.pok.ibm.com>
	<20160211181208.GA6285@obsidianresearch.com>
	<201602111911.u1BJB2nK017410@d01av03.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602111911.u1BJB2nK017410-CUdSWdNILC7ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Thu, Feb 11, 2016 at 02:10:56PM -0500, Stefan Berger wrote:

>    > Make sense. Don't change the names all the drivers would have to be
>    > churn'd. tpm_chip_alloc, tpmm_chip_alloc.
>    >
>    That's right:
>    struct tpm_chip *tpmm_chip_alloc(struct device *dev,
>                                     const struct tpm_class_ops *ops)
>    {
>            struct tpm_chip *chip;
>            chip = tpm_chip_alloc(ops);
>            if (IS_ERR(chip))
>                    return chip;
>            tpmm_chip_dev(chip, dev);

No, just call the one devm_ function here (Based this work on top of
Jarkko's patch that adds the devm function)

>    > It is probably OK just to use put_device(&chip->dev), tpm_chip_put is
>    > already taken for something else. Don't call it free, it isn't free.
>    tpm_chip_free undoes what tpm_chip_alloc did.

No, once a chip is created we want the kref to be functional, that
means it can only ever be free'd by put_device. Do not create a
tpm_chip_free.

>     * Allocates a new struct tpm_chip instance and assigns a free
>     * device number for it.
>     */
>    struct tpm_chip *tpm_chip_alloc(const struct tpm_class_ops *ops)
>    {
>            struct tpm_chip *chip;
>            chip = kzalloc(sizeof(*chip), GFP_KERNEL);
>            if (chip == NULL)
>                    return ERR_PTR(-ENOMEM);

I see, why you got confused - don't try and remove device_initialize,
it doesn't care about the parent pointer.

Move the dev_set_drvdata into tpmm_chip_alloc
Move the cdev.owner to before cdev_add

A tpm_chip should never be in a state where the kref doesn't work.

Something like this [be careful merging this on top of Jarkko's final
patch adding the devm call].

pdev could even be passed as null for tpm_chip_alloc, as long as it is
properly set before registration, but I'd probably init you vtpm
device, then alloc the chip copy the id, then register the vtpm.

>From 4b1b31c351f838d608644660eb178b4c1f92bb7c Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Thu, 11 Feb 2016 12:45:48 -0700
Subject: [PATCH] tpm: Split out the devm stuff from tpmm_chip_alloc

tpm_chip_alloc becomes a typical subsystem allocate call.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 46 +++++++++++++++++++++++++++++++++++----------
 drivers/char/tpm/tpm.h      |  2 ++
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 999cbd9b388c..8134003b023c 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -77,15 +77,15 @@ static void tpm_dev_release(struct device *dev)
 /**
  * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
  * @dev: device to which the chip is associated
+ *       At this point pdev must be initalized, but does not have to be
+ *       registered.
  * @ops: struct tpm_class_ops instance
  *
  * Allocates a new struct tpm_chip instance and assigns a free
- * device number for it. Caller does not have to worry about
- * freeing the allocated resources. When the devices is removed
- * devres calls tpmm_chip_remove() to do the job.
+ * device number for it. Must be pair'd with put_device(&chip->dev).
  */
-struct tpm_chip *tpmm_chip_alloc(struct device *dev,
-				 const struct tpm_class_ops *ops)
+struct tpm_chip *tpm_chip_alloc(struct device *dev,
+				const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
 
@@ -109,13 +109,12 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	}
 
 	set_bit(chip->dev_num, dev_mask);
+	device_initialize(&chip->dev);
 
 	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
 
 	chip->pdev = dev;
 
-	dev_set_drvdata(dev, chip);
-
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = chip->pdev;
@@ -130,20 +129,47 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 
 	dev_set_name(&chip->dev, "%s", chip->devname);
 
-	device_initialize(&chip->dev);
-
 	cdev_init(&chip->cdev, &tpm_fops);
-	chip->cdev.owner = chip->pdev->driver->owner;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
 	return chip;
 }
+EXPORT_SYMBOL_GPL(tpm_chip_alloc);
+
+/**
+ * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
+ * @dev: device to which the chip is associated
+ *       Must be fully registered and able to handle devm.
+ * @ops: struct tpm_class_ops instance
+ *
+ * Same as tpm_chip_alloc except devm is used to do the put_device
+ */
+struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
+				 const struct tpm_class_ops *ops)
+{
+	struct tpm_chip *chip;
+	int rc;
+
+	chip = tpm_chip_alloc(pdev, ops);
+	if (IS_ERR(chip))
+		return chip;
+	rc = devm_add_action(pdev, (void (*)(void *)) put_device, &chip->dev);
+	if (rc) {
+		put_device(&chip->dev);
+		return ERR_PTR(rc);
+	}
+
+	dev_set_drvdata(pdev, chip);
+
+	return chip;
+}
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
 static int tpm_dev_add_device(struct tpm_chip *chip)
 {
 	int rc;
 
+	chip->cdev.owner = chip->pdev->driver->owner;
 	rc = cdev_add(&chip->cdev, chip->dev.devt, 1);
 	if (rc) {
 		dev_err(&chip->dev,
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 2fd5ee2ed7ad..3a5452f09b96 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -508,6 +508,8 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *, bool);
 
 struct tpm_chip *tpm_chip_find_get(int chip_num);
+extern struct tpm_chip *tpm_chip_alloc(struct device *dev,
+				       const struct tpm_class_ops *ops);
 extern struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 				       const struct tpm_class_ops *ops);
 extern int tpm_chip_register(struct tpm_chip *chip);
-- 
2.1.4


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
