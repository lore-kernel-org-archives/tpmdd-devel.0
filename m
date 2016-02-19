From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 07/11] tpm: Replace device number bitmap
	with IDR
Date: Fri, 19 Feb 2016 07:42:04 -0500
Message-ID: <1455885728-10315-8-git-send-email-stefanb@linux.vnet.ibm.com>
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

Replace the device number bitmap with IDR. Extend the number of devices we
can create to 64k.
Since an IDR allows us to associate a pointer with an ID, we use this now
to rewrite tpm_chip_find_get() to simply look up the chip pointer by the
given device ID.

Protect the IDR calls with a mutex.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c      | 81 +++++++++++++++++++++-------------------
 drivers/char/tpm/tpm-interface.c |  1 +
 drivers/char/tpm/tpm.h           |  5 +--
 3 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 2270e47..4fd36ba 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -29,9 +29,8 @@
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
-static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
-static LIST_HEAD(tpm_chip_list);
-static DEFINE_SPINLOCK(driver_lock);
+DEFINE_IDR(dev_nums_idr);
+static DEFINE_MUTEX(idr_lock);
 
 struct class *tpm_class;
 dev_t tpm_devt;
@@ -88,18 +87,27 @@ EXPORT_SYMBOL_GPL(tpm_put_ops);
   */
 struct tpm_chip *tpm_chip_find_get(int chip_num)
 {
-	struct tpm_chip *pos, *chip = NULL;
+	struct tpm_chip *chip;
+	int chip_next, chip_prev;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
-		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
-			continue;
+	if (chip_num == TPM_ANY_NUM)
+		chip_next = 0;
+
+	mutex_lock(&idr_lock);
+
+	do {
+		if (chip_num == TPM_ANY_NUM) {
+			chip_prev = chip_next;
+			chip = idr_get_next(&dev_nums_idr, &chip_next);
+		} else
+			chip = idr_find_slowpath(&dev_nums_idr, chip_num);
+
+		if (chip && !tpm_try_get_ops(chip))
+			break;
+	} while (chip_num == TPM_ANY_NUM && chip_prev != chip_next);
+
+	mutex_unlock(&idr_lock);
 
-		if (!tpm_try_get_ops(pos))
-			chip = pos;
-		break;
-	}
-	rcu_read_unlock();
 	return chip;
 }
 
@@ -113,9 +121,10 @@ static void tpm_dev_release(struct device *dev)
 {
 	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
 
-	spin_lock(&driver_lock);
-	clear_bit(chip->dev_num, dev_mask);
-	spin_unlock(&driver_lock);
+	mutex_lock(&idr_lock);
+	idr_remove(&dev_nums_idr, chip->dev_num);
+	mutex_unlock(&idr_lock);
+
 	kfree(chip);
 }
 
@@ -141,19 +150,16 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 
 	init_rwsem(&chip->ops_sem);
 	mutex_init(&chip->tpm_mutex);
-	INIT_LIST_HEAD(&chip->list);
-
-	spin_lock(&driver_lock);
-	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
-	if (chip->dev_num < TPM_NUM_DEVICES)
-		set_bit(chip->dev_num, dev_mask);
-	spin_unlock(&driver_lock);
 
-	if (chip->dev_num >= TPM_NUM_DEVICES) {
+	mutex_lock(&idr_lock);
+	err = idr_alloc(&dev_nums_idr, NULL, 0, TPM_NUM_DEVICES, GFP_KERNEL);
+	mutex_unlock(&idr_lock);
+	if (err < 0) {
 		dev_err(dev, "No available tpm device numbers\n");
 		kfree(chip);
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(err);
 	}
+	chip->dev_num = err;
 
 	chip->ops = ops;
 
@@ -247,12 +253,6 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 static void tpm_dev_del_device(struct tpm_chip *chip)
 {
 	cdev_del(&chip->cdev);
-
-	/* Make the driver uncallable. */
-	down_write(&chip->ops_sem);
-	chip->ops = NULL;
-	up_write(&chip->ops_sem);
-
 	device_del(&chip->dev);
 }
 
@@ -312,9 +312,9 @@ int tpm_chip_register(struct tpm_chip *chip)
 		goto out_err;
 
 	/* Make the chip available. */
-	spin_lock(&driver_lock);
-	list_add_tail_rcu(&chip->list, &tpm_chip_list);
-	spin_unlock(&driver_lock);
+	mutex_lock(&idr_lock);
+	idr_replace(&dev_nums_idr, chip, chip->dev_num);
+	mutex_unlock(&idr_lock);
 
 	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
 
@@ -349,10 +349,15 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	if (!(chip->flags & TPM_CHIP_FLAG_REGISTERED))
 		return;
 
-	spin_lock(&driver_lock);
-	list_del_rcu(&chip->list);
-	spin_unlock(&driver_lock);
-	synchronize_rcu();
+	/* Make the driver uncallable. */
+	down_write(&chip->ops_sem);
+	chip->ops = NULL;
+	up_write(&chip->ops_sem);
+
+	/* hide the chip now */
+	mutex_lock(&idr_lock);
+	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
+	mutex_unlock(&idr_lock);
 
 	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
 		sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1dfe2ce..f2ae217 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1121,6 +1121,7 @@ static int __init tpm_init(void)
 
 static void __exit tpm_exit(void)
 {
+	idr_destroy(&dev_nums_idr);
 	class_destroy(tpm_class);
 	unregister_chrdev_region(tpm_devt, TPM_NUM_DEVICES);
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 25efe8f..2ca5fb4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -34,7 +34,7 @@
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
 	TPM_BUFSIZE = 4096,
-	TPM_NUM_DEVICES = 256,
+	TPM_NUM_DEVICES = 65536,
 	TPM_RETRY = 50,		/* 5 seconds */
 };
 
@@ -199,8 +199,6 @@ struct tpm_chip {
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
 #endif /* CONFIG_ACPI */
-
-	struct list_head list;
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
@@ -496,6 +494,7 @@ static inline void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value)
 extern struct class *tpm_class;
 extern dev_t tpm_devt;
 extern const struct file_operations tpm_fops;
+extern struct idr dev_nums_idr;
 
 ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
