From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v7 05/10] tpm: Split out the devm stuff from
	tpmm_chip_alloc
Date: Fri, 11 Mar 2016 21:51:00 -0500
Message-ID: <1457751065-11507-6-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1457751065-11507-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1457751065-11507-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

tpm_chip_alloc becomes a typical subsystem allocate call.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Tested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 49 ++++++++++++++++++++++++++++++++-------------
 drivers/char/tpm/tpm.h      |  4 +++-
 2 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 6636728..5880377 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -121,17 +121,17 @@ static void tpm_dev_release(struct device *dev)
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
 	int rc;
@@ -160,8 +160,6 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 
 	device_initialize(&chip->dev);
 
-	dev_set_drvdata(dev, chip);
-
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = dev;
@@ -182,17 +180,40 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	chip->cdev.owner = THIS_MODULE;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
-	rc = devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
+	return chip;
+
+out:
+	put_device(&chip->dev);
+	return ERR_PTR(rc);
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
+	int rc;
+
+	chip = tpm_chip_alloc(pdev, ops);
+	if (IS_ERR(chip))
+		return chip;
+
+	rc = devm_add_action(pdev, (void (*)(void *)) put_device, &chip->dev);
 	if (rc) {
 		put_device(&chip->dev);
 		return ERR_PTR(rc);
 	}
 
-	return chip;
+	dev_set_drvdata(pdev, chip);
 
-out:
-	put_device(&chip->dev);
-	return ERR_PTR(rc);
+	return chip;
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index c6376b1..5fcf788 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -511,7 +511,9 @@ struct tpm_chip *tpm_chip_find_get(int chip_num);
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
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
