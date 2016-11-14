From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: drop chip->is_open and
	chip->duration_adjusted
Date: Mon, 14 Nov 2016 15:44:58 -0800
Message-ID: <20161114234500.24839-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Use atomic bitops for chip->flags so that we do not need chip->is_open
and chip->duration_adjusted anymore.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c |  6 +++---
 drivers/char/tpm/tpm-chip.c          | 14 ++++++++------
 drivers/char/tpm/tpm-dev.c           |  9 +++------
 drivers/char/tpm/tpm-interface.c     | 30 +++++++++++++++---------------
 drivers/char/tpm/tpm-sysfs.c         |  2 +-
 drivers/char/tpm/tpm.h               | 14 +++++++-------
 drivers/char/tpm/tpm2-cmd.c          |  2 +-
 drivers/char/tpm/tpm_crb.c           |  2 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c   |  8 ++++----
 drivers/char/tpm/tpm_tis_core.c      | 26 +++++++++++++-------------
 drivers/char/tpm/tpm_vtpm_proxy.c    |  2 +-
 11 files changed, 57 insertions(+), 58 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 6f060c7..14734a0 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -267,7 +267,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 
 	stop = jiffies + timeout;
 
-	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
+	if (test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags)) {
 		cur_intrs = tpm_dev->intrs;
 		clear_interruption(tpm_dev);
 		enable_irq(tpm_dev->irq);
@@ -429,7 +429,7 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 	if (ret < 0)
 		goto out_err;
 
-	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
+	if (test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags)) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 
 		ret = wait_for_stat(chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
@@ -586,7 +586,7 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
 			goto _tpm_clean_answer;
 
 		tpm_dev->irq = irq;
-		chip->flags |= TPM_CHIP_FLAG_IRQ;
+		set_bit(TPM_CHIP_FLAG_IRQ, &chip->flags);
 
 		disable_irq_nosync(tpm_dev->irq);
 	}
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 3f27753..04819e1 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -183,7 +183,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 		goto out;
 
 	if (!dev)
-		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
+		set_bit(TPM_CHIP_FLAG_VIRTUAL, &chip->flags);
 
 	cdev_init(&chip->cdev, &tpm_fops);
 	chip->cdev.owner = THIS_MODULE;
@@ -271,7 +271,7 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 
 	/* Make the driver uncallable. */
 	down_write(&chip->ops_sem);
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
 	chip->ops = NULL;
 	up_write(&chip->ops_sem);
@@ -281,7 +281,8 @@ static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
 {
 	struct attribute **i;
 
-	if (chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags) ||
+	    test_bit(TPM_CHIP_FLAG_VIRTUAL, &chip->flags))
 		return;
 
 	sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
@@ -299,8 +300,9 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 	struct attribute **i;
 	int rc;
 
-	if (chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))
-		return 0;
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags) ||
+	    test_bit(TPM_CHIP_FLAG_VIRTUAL, &chip->flags))
+		return;
 
 	rc = __compat_only_sysfs_link_entry_to_kobj(
 		    &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
@@ -335,7 +337,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 	int rc;
 
 	if (chip->ops->flags & TPM_OPS_AUTO_STARTUP) {
-		if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
 			rc = tpm2_auto_startup(chip);
 		else
 			rc = tpm1_auto_startup(chip);
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 912ad30..3738c38 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -57,17 +57,14 @@ static int tpm_open(struct inode *inode, struct file *file)
 		container_of(inode->i_cdev, struct tpm_chip, cdev);
 	struct file_priv *priv;
 
-	/* It's assured that the chip will be opened just once,
-	 * by the check of is_open variable, which is protected
-	 * by driver_lock. */
-	if (test_and_set_bit(0, &chip->is_open)) {
+	if (test_and_set_bit(TPM_CHIP_FLAG_IS_OPEN, &chip->flags)) {
 		dev_dbg(&chip->dev, "Another process owns this TPM\n");
 		return -EBUSY;
 	}
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv == NULL) {
-		clear_bit(0, &chip->is_open);
+		clear_bit(TPM_CHIP_FLAG_IS_OPEN, &chip->flags);
 		return -ENOMEM;
 	}
 
@@ -173,7 +170,7 @@ static int tpm_release(struct inode *inode, struct file *file)
 	flush_work(&priv->work);
 	file->private_data = NULL;
 	atomic_set(&priv->data_pending, 0);
-	clear_bit(0, &priv->chip->is_open);
+	clear_bit(TPM_CHIP_FLAG_IS_OPEN, &priv->chip->flags);
 	kfree(priv);
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index a2688ac..6426be7 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -367,10 +367,10 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 		goto out;
 	}
 
-	if (chip->flags & TPM_CHIP_FLAG_IRQ)
+	if (test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags))
 		goto out_recv;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
 		stop = jiffies + tpm2_calc_ordinal_duration(chip, ordinal);
 	else
 		stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
@@ -503,10 +503,10 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	unsigned long old_timeout[4];
 	ssize_t rc;
 
-	if (chip->flags & TPM_CHIP_FLAG_HAVE_TIMEOUTS)
+	if (test_bit(TPM_CHIP_FLAG_HAVE_TIMEOUTS, &chip->flags))
 		return 0;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags)) {
 		/* Fixed timeouts for TPM2 */
 		chip->timeout_a = msecs_to_jiffies(TPM2_TIMEOUT_A);
 		chip->timeout_b = msecs_to_jiffies(TPM2_TIMEOUT_B);
@@ -519,7 +519,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		chip->duration[TPM_LONG] =
 		    msecs_to_jiffies(TPM2_DURATION_LONG);
 
-		chip->flags |= TPM_CHIP_FLAG_HAVE_TIMEOUTS;
+		set_bit(TPM_CHIP_FLAG_HAVE_TIMEOUTS, &chip->flags);
 		return 0;
 	}
 
@@ -600,11 +600,11 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		chip->duration[TPM_SHORT] = HZ;
 		chip->duration[TPM_MEDIUM] *= 1000;
 		chip->duration[TPM_LONG] *= 1000;
-		chip->duration_adjusted = true;
+		set_bit(TPM_CHIP_FLAG_DURATION_ADJUSTED, &chip->flags);
 		dev_info(&chip->dev, "Adjusting TPM timeout parameters.");
 	}
 
-	chip->flags |= TPM_CHIP_FLAG_HAVE_TIMEOUTS;
+	set_bit(TPM_CHIP_FLAG_HAVE_TIMEOUTS, &chip->flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_get_timeouts);
@@ -676,7 +676,7 @@ int tpm_is_tpm2(u32 chip_num)
 	if (chip == NULL)
 		return -ENODEV;
 
-	rc = (chip->flags & TPM_CHIP_FLAG_TPM2) != 0;
+	rc = (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags)) != 0;
 
 	tpm_put_ops(chip);
 
@@ -703,7 +703,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
 	chip = tpm_chip_find_get(chip_num);
 	if (chip == NULL)
 		return -ENODEV;
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
 		rc = tpm2_pcr_read(chip, pcr_idx, res_buf);
 	else
 		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
@@ -740,7 +740,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	if (chip == NULL)
 		return -ENODEV;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags)) {
 		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
 		tpm_put_ops(chip);
 		return rc;
@@ -890,7 +890,7 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 
 	stop = jiffies + timeout;
 
-	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
+	if (test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags)) {
 again:
 		timeout = stop - jiffies;
 		if ((long)timeout <= 0)
@@ -944,7 +944,7 @@ int tpm_pm_suspend(struct device *dev)
 	if (chip == NULL)
 		return -ENODEV;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags)) {
 		tpm2_shutdown(chip, TPM2_SU_STATE);
 		return 0;
 	}
@@ -1036,7 +1036,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 	if (chip == NULL)
 		return -ENODEV;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags)) {
 		err = tpm2_get_random(chip, out, max);
 		tpm_put_ops(chip);
 		return err;
@@ -1081,7 +1081,7 @@ int tpm_seal_trusted(u32 chip_num, struct trusted_key_payload *payload,
 	int rc;
 
 	chip = tpm_chip_find_get(chip_num);
-	if (chip == NULL || !(chip->flags & TPM_CHIP_FLAG_TPM2))
+	if (chip == NULL || !(test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags)))
 		return -ENODEV;
 
 	rc = tpm2_seal_trusted(chip, payload, options);
@@ -1107,7 +1107,7 @@ int tpm_unseal_trusted(u32 chip_num, struct trusted_key_payload *payload,
 	int rc;
 
 	chip = tpm_chip_find_get(chip_num);
-	if (chip == NULL || !(chip->flags & TPM_CHIP_FLAG_TPM2))
+	if (chip == NULL || !(test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags)))
 		return -ENODEV;
 
 	rc = tpm2_unseal_trusted(chip, payload, options);
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 848ad65..21b3fde 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -244,7 +244,7 @@ static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
 		       jiffies_to_usecs(chip->duration[TPM_SHORT]),
 		       jiffies_to_usecs(chip->duration[TPM_MEDIUM]),
 		       jiffies_to_usecs(chip->duration[TPM_LONG]),
-		       chip->duration_adjusted
+		       test_bit(TPM_CHIP_FLAG_DURATION_ADJUSTED, &chip->flags)
 		       ? "adjusted" : "original");
 }
 static DEVICE_ATTR_RO(durations);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 1ae9768..a1fadfa 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -142,10 +142,12 @@ enum tpm2_startup_types {
 #define TPM_PPI_VERSION_LEN		3
 
 enum tpm_chip_flags {
-	TPM_CHIP_FLAG_TPM2		= BIT(1),
-	TPM_CHIP_FLAG_IRQ		= BIT(2),
-	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
-	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= BIT(4),
+	TPM_CHIP_FLAG_IS_OPEN		= 0,
+	TPM_CHIP_FLAG_TPM2		= 1,
+	TPM_CHIP_FLAG_IRQ		= 2,
+	TPM_CHIP_FLAG_VIRTUAL		= 3,
+	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= 4,
+	TPM_CHIP_FLAG_DURATION_ADJUSTED	= 5,
 };
 
 struct tpm_chip_seqops {
@@ -168,10 +170,9 @@ struct tpm_chip {
 	struct tpm_chip_seqops bin_log_seqops;
 	struct tpm_chip_seqops ascii_log_seqops;
 
-	unsigned int flags;
+	unsigned long flags;
 
 	int dev_num;		/* /dev/tpm# */
-	unsigned long is_open;	/* only one allowed */
 
 	struct mutex tpm_mutex;	/* tpm is processing */
 
@@ -181,7 +182,6 @@ struct tpm_chip {
 	unsigned long timeout_d; /* jiffies */
 	bool timeout_adjusted;
 	unsigned long duration[3]; /* jiffies */
-	bool duration_adjusted;
 
 	struct dentry *bios_dir[TPM_NUM_EVENT_LOG_FILES];
 
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index da5b782..7abe8a0 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -946,7 +946,7 @@ int tpm2_probe(struct tpm_chip *chip)
 		return rc;
 
 	if (be16_to_cpu(cmd.header.out.tag) == TPM2_ST_NO_SESSIONS)
-		chip->flags |= TPM_CHIP_FLAG_TPM2;
+		set_bit(TPM_CHIP_FLAG_TPM2, &chip->flags);
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 65040d7..e37ebaa 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -429,7 +429,7 @@ static int crb_acpi_add(struct acpi_device *device)
 
 	dev_set_drvdata(&chip->dev, priv);
 	chip->acpi_dev_handle = device->handle;
-	chip->flags = TPM_CHIP_FLAG_TPM2;
+	set_bit(TPM_CHIP_FLAG_TPM2, &chip->flags);
 
 	rc  = crb_cmd_ready(dev, priv);
 	if (rc)
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index e3a9155..f4e25b5 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -180,7 +180,7 @@ static bool i2c_nuvoton_check_status(struct tpm_chip *chip, u8 mask, u8 value)
 static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
 				     u32 timeout, wait_queue_head_t *queue)
 {
-	if ((chip->flags & TPM_CHIP_FLAG_IRQ) && queue) {
+	if ((test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags)) && queue) {
 		s32 rc;
 		struct priv_data *priv = dev_get_drvdata(&chip->dev);
 		unsigned int cur_intrs = priv->intrs;
@@ -552,10 +552,10 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 
 		of_id = of_match_device(dev->driver->of_match_table, dev);
 		if (of_id && of_id->data == OF_IS_TPM2)
-			chip->flags |= TPM_CHIP_FLAG_TPM2;
+			set_bit(TPM_CHIP_FLAG_TPM2, &chip->flags);
 	} else
 		if (id->driver_data == I2C_IS_TPM2)
-			chip->flags |= TPM_CHIP_FLAG_TPM2;
+			set_bit(TPM_CHIP_FLAG_TPM2, &chip->flags);
 
 	init_waitqueue_head(&priv->read_queue);
 
@@ -585,7 +585,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 				__func__, priv->irq);
 			priv->irq = 0;
 		} else {
-			chip->flags |= TPM_CHIP_FLAG_IRQ;
+			set_bit(TPM_CHIP_FLAG_IRQ, &chip->flags);
 			/* Clear any pending interrupt */
 			i2c_nuvoton_ready(chip);
 			/* - wait for TPM_STS==0xA0 (stsValid, commandReady) */
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 7993678..e6af2a0 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -105,7 +105,7 @@ static int request_locality(struct tpm_chip *chip, int l)
 
 	stop = jiffies + chip->timeout_a;
 
-	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
+	if (test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags)) {
 again:
 		timeout = stop - jiffies;
 		if ((long)timeout <= 0)
@@ -346,7 +346,7 @@ static void disable_interrupts(struct tpm_chip *chip)
 
 	devm_free_irq(chip->dev.parent, priv->irq, chip);
 	priv->irq = 0;
-	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
+	clear_bit(TPM_CHIP_FLAG_IRQ, &chip->flags);
 }
 
 /*
@@ -370,10 +370,10 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 	if (rc < 0)
 		goto out_err;
 
-	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
+	if (test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags)) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 
-		if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
 			dur = tpm2_calc_ordinal_duration(chip, ordinal);
 		else
 			dur = tpm_calc_ordinal_duration(chip, ordinal);
@@ -397,16 +397,16 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	int rc, irq;
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	if (!(chip->flags & TPM_CHIP_FLAG_IRQ) || priv->irq_tested)
+	if (!(test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags)) || priv->irq_tested)
 		return tpm_tis_send_main(chip, buf, len);
 
 	/* Verify receipt of the expected IRQ */
 	irq = priv->irq;
 	priv->irq = 0;
-	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
+	clear_bit(TPM_CHIP_FLAG_IRQ, &chip->flags);
 	rc = tpm_tis_send_main(chip, buf, len);
 	priv->irq = irq;
-	chip->flags |= TPM_CHIP_FLAG_IRQ;
+	set_bit(TPM_CHIP_FLAG_IRQ, &chip->flags);
 	if (!priv->irq_tested)
 		msleep(1);
 	if (!priv->irq_tested)
@@ -549,7 +549,7 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 	u32 cap2;
 	cap_t cap;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
 		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
 	else
 		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
@@ -611,7 +611,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	/* tpm_tis_send will either confirm the interrupt is working or it
 	 * will call disable_irq which undoes all of the above.
 	 */
-	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
+	if (!(test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags))) {
 		rc = tpm_tis_write8(priv, original_int_vec,
 				TPM_INT_VECTOR(priv->locality));
 		if (rc < 0)
@@ -737,7 +737,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		goto out_err;
 
 	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
-		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
+		 (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags)) ? "2.0" : "1.2",
 		 vendor >> 16, rid);
 
 	if (!(priv->flags & TPM_TIS_ITPM_POSSIBLE)) {
@@ -794,7 +794,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);
-			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
+			if (!(test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags)))
 				dev_err(&chip->dev, FW_BUG
 					"TPM interrupt not working, polling instead\n");
 		} else {
@@ -839,7 +839,7 @@ int tpm_tis_resume(struct device *dev)
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	int ret;
 
-	if (chip->flags & TPM_CHIP_FLAG_IRQ)
+	if (test_bit(TPM_CHIP_FLAG_IRQ, &chip->flags))
 		tpm_tis_reenable_interrupts(chip);
 
 	ret = tpm_pm_resume(dev);
@@ -849,7 +849,7 @@ int tpm_tis_resume(struct device *dev)
 	/* TPM 1.2 requires self-test on resume. This function actually returns
 	 * an error code but for unknown reason it isn't handled.
 	 */
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+	if (!(test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags)))
 		tpm_do_selftest(chip);
 
 	return 0;
diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 3d6f6ca..b0cb284 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -482,7 +482,7 @@ static struct file *vtpm_proxy_create_device(
 	vtpm_proxy_fops_open(file);
 
 	if (proxy_dev->flags & VTPM_PROXY_FLAG_TPM2)
-		proxy_dev->chip->flags |= TPM_CHIP_FLAG_TPM2;
+		set_bit(TPM_CHIP_FLAG_TPM2, &proxy_dev->chip->flags);
 
 	vtpm_proxy_work_start(proxy_dev);
 
-- 
2.9.3


------------------------------------------------------------------------------
