From: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 2/4] Allow to provide a name pattern of
	the device
Date: Thu, 14 Jan 2016 11:01:56 -0500
Message-ID: <1452787318-29610-3-git-send-email-stefanb@us.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1452787318-29610-1-git-send-email-stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Introduce tpmm_chip_alloc_pattern that takes an additional parameter
of the device's name pattern. All existing devices use "tpm%d".

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 28 ++++++++++++++++++++++++----
 drivers/char/tpm/tpm.h      |  6 +++++-
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index f2da376..d98fcd9 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -76,17 +76,20 @@ static void tpm_dev_release(struct device *dev)
 }
 
 /**
- * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
+ * tpmm_chip_alloc_pattern() - allocate a new struct tpm_chip instance
+ *   and use the given pattern for naming the device
  * @dev: device to which the chip is associated
  * @ops: struct tpm_class_ops instance
+ * @pattern: name pattern of the device
  *
  * Allocates a new struct tpm_chip instance and assigns a free
  * device number for it. Caller does not have to worry about
  * freeing the allocated resources. When the devices is removed
  * devres calls tpmm_chip_remove() to do the job.
  */
-struct tpm_chip *tpmm_chip_alloc(struct device *dev,
-				 const struct tpm_class_ops *ops)
+struct tpm_chip *tpmm_chip_alloc_pattern(struct device *dev,
+				         const struct tpm_class_ops *ops,
+				         const char *pattern)
 {
 	struct tpm_chip *chip;
 
@@ -111,7 +114,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 
 	set_bit(chip->dev_num, dev_mask);
 
-	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
+	scnprintf(chip->devname, sizeof(chip->devname), pattern, chip->dev_num);
 
 	chip->pdev = dev;
 
@@ -139,6 +142,23 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 
 	return chip;
 }
+EXPORT_SYMBOL_GPL(tpmm_chip_alloc_pattern);
+
+/**
+ * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
+ * @dev: device to which the chip is associated
+ * @ops: struct tpm_class_ops instance
+ *
+ * Allocates a new struct tpm_chip instance and assigns a free
+ * device number for it. Caller does not have to worry about
+ * freeing the allocated resources. When the devices is removed
+ * devres calls tpmm_chip_remove() to do the job.
+ */
+struct tpm_chip *tpmm_chip_alloc(struct device *dev,
+				 const struct tpm_class_ops *ops)
+{
+    return tpmm_chip_alloc_pattern(dev, ops, "tpm%d");
+}
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
 static int tpm_dev_add_device(struct tpm_chip *chip)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index dfa755b..c95b26e 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -181,7 +181,7 @@ struct tpm_chip {
 	unsigned int flags;
 
 	int dev_num;		/* /dev/tpm# */
-	char devname[7];
+	char devname[10];
 	unsigned long is_open;	/* only one allowed */
 	int time_expired;
 
@@ -517,6 +517,10 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 struct tpm_chip *tpm_chip_find_get(int chip_num);
 extern struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 				       const struct tpm_class_ops *ops);
+extern struct tpm_chip *tpmm_chip_alloc_pattern(
+				       struct device *dev,
+				       const struct tpm_class_ops *ops,
+				       const char *pattern);
 extern int tpm_chip_register(struct tpm_chip *chip);
 extern void tpm_chip_unregister(struct tpm_chip *chip);
 
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
