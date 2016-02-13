From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm: Get rid of chip->pdev
Date: Fri, 12 Feb 2016 20:33:20 -0700
Message-ID: <20160213033320.GA27869@obsidianresearch.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1455321871-28296-3-git-send-email-jgunthorpe@obsidianresearch.com>
	<201602130037.u1D0bDEN029756@d01av04.pok.ibm.com>
	<20160213011130.GA2547@obsidianresearch.com>
	<201602130128.u1D1S2Xn006955@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602130128.u1D1S2Xn006955-8DuMPbUlb4HImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 12, 2016 at 08:31:21PM -0500, Stefan Berger wrote:
> > I'll send you something else that might work for vtpm...'
> 
> The vtpm driver will introduce chip->priv, which will point to vtpm_dev. For
> this reason we need to hold a reference to the vtpm_dev->dev in the
> front end.

This should take care of it for all drivers including vtpm.

https://github.com/jgunthorpe/linux/commits/for-jarkko

At the very least this turns silent use after free into a null pointer
oops.

We should also discuss if we want to continue to have the driver
module locked while /dev/tpmX is open, that is no longer needed for
corectness.

>From 52c5710ff585e936687e57ca5e267e82e334ebc5 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Fri, 12 Feb 2016 20:29:53 -0700
Subject: [PATCH 3/3] tpm: Provide strong locking for device removal

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
 drivers/char/tpm/tpm-chip.c      | 72 ++++++++++++++++++++++++++++++++++++----
 drivers/char/tpm/tpm-dev.c       | 10 +++++-
 drivers/char/tpm/tpm-interface.c | 18 +++++-----
 drivers/char/tpm/tpm-sysfs.c     |  5 +++
 drivers/char/tpm/tpm.h           | 14 +++++---
 5 files changed, 98 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index df4132e8b982..647fdf327537 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -36,9 +36,59 @@ static DEFINE_SPINLOCK(driver_lock);
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
+ */
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
  */
 struct tpm_chip *tpm_chip_find_get(int chip_num)
 {
@@ -49,10 +99,10 @@ struct tpm_chip *tpm_chip_find_get(int chip_num)
 		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
 			continue;
 
-		if (try_module_get(pos->dev.parent->driver->owner)) {
+		/* rcu prevents chip from being free'd */
+		if (!tpm_try_get_ops(pos))
 			chip = pos;
-			break;
-		}
+		break;
 	}
 	rcu_read_unlock();
 	return chip;
@@ -95,6 +145,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	mutex_init(&chip->tpm_mutex);
+	init_rwsem(&chip->ops_sem);
 	INIT_LIST_HEAD(&chip->list);
 
 	chip->ops = ops;
@@ -174,6 +225,12 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
 static void tpm_dev_del_device(struct tpm_chip *chip)
 {
 	cdev_del(&chip->cdev);
+
+	/* Make the driver uncallable. */
+	down_write(&chip->ops_sem);
+	chip->ops = NULL;
+	up_write(&chip->ops_sem);
+
 	device_unregister(&chip->dev);
 }
 
@@ -259,6 +316,9 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
  * Takes the chip first away from the list of available TPM chips and then
  * cleans up all the resources reserved by tpm_chip_register().
  *
+ * Once this function returns the driver call backs in 'op's will not be
+ * running and will no longer start.
+ *
  * NOTE: This function should be only called before deinitializing chip
  * resources.
  */
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 4009765c14fd..1474f8b8297b 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -136,9 +136,17 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
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
+	tpm_put_ops(priv->chip);
 	if (out_size < 0) {
 		mutex_unlock(&priv->buffer_mutex);
 		return out_size;
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 483f86ff6a0a..49bdab5509b2 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -700,7 +700,7 @@ int tpm_is_tpm2(u32 chip_num)
 
 	rc = (chip->flags & TPM_CHIP_FLAG_TPM2) != 0;
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 
 	return rc;
 }
@@ -729,7 +729,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
 		rc = tpm2_pcr_read(chip, pcr_idx, res_buf);
 	else
 		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_read);
@@ -764,7 +764,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
-		tpm_chip_put(chip);
+		tpm_put_ops(chip);
 		return rc;
 	}
 
@@ -774,7 +774,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
 			      "attempting extend a PCR value");
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
@@ -855,7 +855,7 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 
 	rc = tpm_transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_send);
@@ -1037,7 +1037,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		err = tpm2_get_random(chip, out, max);
-		tpm_chip_put(chip);
+		tpm_put_ops(chip);
 		return err;
 	}
 
@@ -1059,7 +1059,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		num_bytes -= recd;
 	} while (retries-- && total < max);
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return total ? total : -EIO;
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
@@ -1085,7 +1085,7 @@ int tpm_seal_trusted(u32 chip_num, struct trusted_key_payload *payload,
 
 	rc = tpm2_seal_trusted(chip, payload, options);
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_seal_trusted);
@@ -1111,7 +1111,7 @@ int tpm_unseal_trusted(u32 chip_num, struct trusted_key_payload *payload,
 
 	rc = tpm2_unseal_trusted(chip, payload, options);
 
-	tpm_chip_put(chip);
+	tpm_put_ops(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_unseal_trusted);
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index d93736aa2703..34e7fc7e590c 100644
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
index 1e097350ce79..026695ae44ca 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -177,7 +177,13 @@ struct tpm_chip {
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
@@ -202,11 +208,6 @@ struct tpm_chip {
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
 
-static inline void tpm_chip_put(struct tpm_chip *chip)
-{
-	module_put(chip->dev.parent->driver->owner);
-}
-
 static inline int tpm_read_index(int base, int index)
 {
 	outb(index, base);
@@ -514,6 +515,9 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *, bool);
 
 struct tpm_chip *tpm_chip_find_get(int chip_num);
+__must_check int tpm_try_get_ops(struct tpm_chip *chip);
+void tpm_put_ops(struct tpm_chip *chip);
+
 extern struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 				       const struct tpm_class_ops *ops);
 extern int tpm_chip_register(struct tpm_chip *chip);
-- 
1.9.1


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
