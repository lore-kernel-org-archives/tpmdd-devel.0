From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 04/11] tpm: Provide strong locking for
	device removal
Date: Fri, 19 Feb 2016 07:42:01 -0500
Message-ID: <1455885728-10315-5-git-send-email-stefanb@linux.vnet.ibm.com>
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

Add a read/write semaphore around the ops function pointers so
ops can be set to null when the driver un-registers.

Previously the tpm core expected module locking to be enough to
ensure that tpm_unregister could not be called during certain times,
however that hasn't been sufficient for a long time.

Introduce a read/write semaphore around 'ops' so the core can set
it to null when unregistering. This provides a strong fence around
the driver callbacks, guaranteeing to the driver that no callbacks
are running or will run again.

For now the ops_lock is placed very high in the call stack, it could
be pushed down and made more granular in future if necessary.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c      | 71 ++++++++++++++++++++++++++++++++++++----
 drivers/char/tpm/tpm-dev.c       | 11 ++++++-
 drivers/char/tpm/tpm-interface.c | 18 +++++-----
 drivers/char/tpm/tpm-sysfs.c     |  5 +++
 drivers/char/tpm/tpm.h           | 14 +++++---
 5 files changed, 98 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 5df0149..0561400 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -36,10 +36,60 @@ static DEFINE_SPINLOCK(driver_lock);
 struct class *tpm_class;
 dev_t tpm_devt;
 
-/*
- * tpm_chip_find_get - return tpm_chip for a given chip number
- * @chip_num the device number for the chip
+/**
+ * tpm_try_get_ops() - Get a ref to the tpm_chip
+ * @chip: Chip to ref
+ *
+ * The caller must already have some kind of locking to ensure that chip is
+ * valid. This function will lock the chip so that the ops member can be
+ * accessed safely. The locking prevents tpm_chip_unregister from
+ * completing, so it should not be held for long periods.
+ *
+ * Returns -ERRNO if the chip could not be got.
  */
+int tpm_try_get_ops(struct tpm_chip *chip)
+{
+	int rc = -EIO;
+
+	get_device(&chip->dev);
+
+	down_read(&chip->ops_sem);
+	if (!chip->ops)
+		goto out_lock;
+
+	if (!try_module_get(chip->dev.parent->driver->owner))
+		goto out_lock;
+
+	return 0;
+out_lock:
+	up_read(&chip->ops_sem);
+	put_device(&chip->dev);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_try_get_ops);
+
+/**
+ * tpm_put_ops() - Release a ref to the tpm_chip
+ * @chip: Chip to put
+ *
+ * This is the opposite pair to tpm_try_get_ops(). After this returns chip may
+ * be kfree'd.
+ */
+void tpm_put_ops(struct tpm_chip *chip)
+{
+	module_put(chip->dev.parent->driver->owner);
+	up_read(&chip->ops_sem);
+	put_device(&chip->dev);
+}
+EXPORT_SYMBOL_GPL(tpm_put_ops);
+
+/**
+ * tpm_chip_find_get() - return tpm_chip for a given chip number
+ * @chip_num: id to find
+ *
+ * The return'd chip has been tpm_try_get_ops'd and must be released via
+ * tpm_put_ops
+  */
 struct tpm_chip *tpm_chip_find_get(int chip_num)
 {
 	struct tpm_chip *pos, *chip = NULL;
@@ -49,10 +99,9 @@ struct tpm_chip *tpm_chip_find_get(int chip_num)
 		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
 			continue;
 
-		if (try_module_get(pos->dev.parent->driver->owner)) {
+		if (!tpm_try_get_ops(pos))
 			chip = pos;
-			break;
-		}
+		break;
 	}
 	rcu_read_unlock();
 	return chip;
@@ -94,6 +143,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	if (chip == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	init_rwsem(&chip->ops_sem);
 	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
@@ -180,6 +230,12 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 static void tpm_dev_del_device(struct tpm_chip *chip)
 {
 	cdev_del(&chip->cdev);
+
+	/* Make the driver uncallable. */
+	down_write(&chip->ops_sem);
+	chip->ops = NULL;
+	up_write(&chip->ops_sem);
+
 	device_del(&chip->dev);
 }
 
@@ -218,6 +274,9 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
  * the device. As the last step this function adds the chip to the list of TPM
  * chips available for in-kernel use.
  *
+ * Once this function returns the driver call backs in 'op's will not be
+ * running and will no longer start.
+ *
  * This function should be only called after the chip initialization is
  * complete.
  */
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 4009765..f5d4521 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -136,9 +136,18 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 		return -EFAULT;
 	}
 
-	/* atomic tpm command send and result receive */
+	/* atomic tpm command send and result receive. We only hold the ops
+	 * lock during this period so that the tpm can be unregistered even if
+	 * the char dev is held open.
+	 */
+	if (tpm_try_get_ops(priv->chip)) {
+		mutex_unlock(&priv->buffer_mutex);
+		return -EPIPE;
+	}
 	out_size = tpm_transmit(priv->chip, priv->data_buffer,
 				sizeof(priv->data_buffer));
+
+	tpm_put_ops(priv->chip);
 	if (out_size < 0) {
 		mutex_unlock(&priv->buffer_mutex);
 		return out_size;
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 65dc7fd..1dfe2ce 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -683,7 +683,7 @@ int tpm_is_tpm2(u32 chip_num)
 
 	rc = (chip->flags & TPM_CHIP_FLAG_TPM2) != 0;
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 
 	return rc;
 }
@@ -712,7 +712,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
 		rc = tpm2_pcr_read(chip, pcr_idx, res_buf);
 	else
 		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_read);
@@ -747,7 +747,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
-		tpm_chip_put(chip);
+		tpm_put_ops(chip);
 		return rc;
 	}
 
@@ -757,7 +757,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
 			      "attempting extend a PCR value");
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
@@ -838,7 +838,7 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 
 	rc = tpm_transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_send);
@@ -1020,7 +1020,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		err = tpm2_get_random(chip, out, max);
-		tpm_chip_put(chip);
+		tpm_put_ops(chip);
 		return err;
 	}
 
@@ -1042,7 +1042,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		num_bytes -= recd;
 	} while (retries-- && total < max);
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return total ? total : -EIO;
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
@@ -1068,7 +1068,7 @@ int tpm_seal_trusted(u32 chip_num, struct trusted_key_payload *payload,
 
 	rc = tpm2_seal_trusted(chip, payload, options);
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_seal_trusted);
@@ -1094,7 +1094,7 @@ int tpm_unseal_trusted(u32 chip_num, struct trusted_key_payload *payload,
 
 	rc = tpm2_unseal_trusted(chip, payload, options);
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_unseal_trusted);
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index d93736a..34e7fc7 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -295,5 +295,10 @@ int tpm_sysfs_add_device(struct tpm_chip *chip)
 
 void tpm_sysfs_del_device(struct tpm_chip *chip)
 {
+	/* The sysfs routines rely on an implicit tpm_try_get_ops, this
+	 * function is called before ops is null'd and the sysfs core
+	 * synchronizes this removal so that no callbacks are running or can
+	 * run again
+	 */
 	sysfs_remove_group(&chip->dev.parent->kobj, &tpm_dev_group);
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 31d9a8e..2a8373e 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -174,7 +174,13 @@ struct tpm_chip {
 	struct device dev;
 	struct cdev cdev;
 
+	/* A driver callback under ops cannot be run unless ops_sem is held
+	 * (sometimes implicitly, eg for the sysfs code). ops becomes null
+	 * when the driver is unregistered, see tpm_try_get_ops.
+	 */
+	struct rw_semaphore ops_sem;
 	const struct tpm_class_ops *ops;
+
 	unsigned int flags;
 
 	int dev_num;		/* /dev/tpm# */
@@ -199,11 +205,6 @@ struct tpm_chip {
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
 
-static inline void tpm_chip_put(struct tpm_chip *chip)
-{
-	module_put(chip->dev.parent->driver->owner);
-}
-
 static inline int tpm_read_index(int base, int index)
 {
 	outb(index, base);
@@ -511,6 +512,9 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *, bool);
 
 struct tpm_chip *tpm_chip_find_get(int chip_num);
+__must_check int tpm_try_get_ops(struct tpm_chip *chip);
+void tpm_put_ops(struct tpm_chip *chip);
+
 extern struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 				       const struct tpm_class_ops *ops);
 extern int tpm_chip_register(struct tpm_chip *chip);
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
