From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 06/11] tpm: Split out the devm stuff from
	tpmm_chip_alloc
Date: Fri, 19 Feb 2016 07:42:03 -0500
Message-ID: <1455885728-10315-7-git-send-email-stefanb@linux.vnet.ibm.com>
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

tpm_chip_alloc becomes a typical subsystem allocate call.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 57 +++++++++++++++++++++++++++++++--------------
 drivers/char/tpm/tpm.h      |  4 +++-
 2 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index fe15637..2270e47 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -120,17 +120,17 @@ static void tpm_dev_release(struct device *dev)
 }
 
 /**
- * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
- * @dev: device to which the chip is associated
+ * tpm_chip_alloc() - allocate a new struct tpm_chip instance
+ * @pdev: device to which the chip is associated
+ *        At this point pdev mst be initialized, but does not have to
+ *        be registered
  * @ops: struct tpm_class_ops instance
  *
  * Allocates a new struct tpm_chip instance and assigns a free
- * device number for it. Caller does not have to worry about
- * freeing the allocated resources. When the devices is removed
- * devres calls tpmm_chip_remove() to do the job.
+ * device number for it. Must be paired with put_device(&chip->dev).
  */
-struct tpm_chip *tpmm_chip_alloc(struct device *dev,
-				 const struct tpm_class_ops *ops)
+struct tpm_chip *tpm_chip_alloc(struct device *dev,
+				const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
 	int err;
@@ -143,10 +143,10 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
-	chip->ops = ops;
-
 	spin_lock(&driver_lock);
 	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
+	if (chip->dev_num < TPM_NUM_DEVICES)
+		set_bit(chip->dev_num, dev_mask);
 	spin_unlock(&driver_lock);
 
 	if (chip->dev_num >= TPM_NUM_DEVICES) {
@@ -155,9 +155,9 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	set_bit(chip->dev_num, dev_mask);
+	chip->ops = ops;
 
-	dev_set_drvdata(dev, chip);
+	device_initialize(&chip->dev);
 
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
@@ -175,23 +175,44 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	if (err)
 		goto out;
 
-	device_initialize(&chip->dev);
-
 	cdev_init(&chip->cdev, &tpm_fops);
 	chip->cdev.owner = dev->driver->owner;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
-	err = devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
+	return chip;
+
+out:
+	put_device(&chip->dev);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(tpm_chip_alloc);
+
+/**
+ * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
+ * @pdev: parent device to which the chip is associated
+ * @ops: struct tpm_class_ops instance
+ *
+ * Same as tpm_chip_alloc except devm is used to do the put_device
+ */
+struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
+				 const struct tpm_class_ops *ops)
+{
+	struct tpm_chip *chip;
+	int err;
+
+	chip = tpm_chip_alloc(pdev, ops);
+	if (IS_ERR(chip))
+		return chip;
+
+	err = devm_add_action(pdev, (void (*)(void *)) put_device, &chip->dev);
 	if (err) {
 		put_device(&chip->dev);
 		return ERR_PTR(err);
 	}
 
-	return chip;
+	dev_set_drvdata(pdev, chip);
 
-out:
-	put_device(&chip->dev);
-	return ERR_PTR(err);
+	return chip;
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 2a8373e..25efe8f 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -515,7 +515,9 @@ struct tpm_chip *tpm_chip_find_get(int chip_num);
 __must_check int tpm_try_get_ops(struct tpm_chip *chip);
 void tpm_put_ops(struct tpm_chip *chip);
 
-extern struct tpm_chip *tpmm_chip_alloc(struct device *dev,
+extern struct tpm_chip *tpm_chip_alloc(struct device *dev,
+				       const struct tpm_class_ops *ops);
+extern struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
 				       const struct tpm_class_ops *ops);
 extern int tpm_chip_register(struct tpm_chip *chip);
 extern void tpm_chip_unregister(struct tpm_chip *chip);
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
