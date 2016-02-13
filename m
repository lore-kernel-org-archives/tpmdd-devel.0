From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 2/3] tpm: Get rid of chip->pdev
Date: Fri, 12 Feb 2016 17:04:30 -0700
Message-ID: <1455321871-28296-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455321871-28296-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This is a hold over from before the struct device conversion.

- All prints should be using &chip->dev, which is the Linux
  standard. This changes prints to use tpm0 as the device name,
  not the PnP/etc ID.
- The few places involving sysfs/modules that really do need the
  parent just use chip->dev.parent instead
- We no longer need to get_device(pdev) in any places since it is no
  longer used by any of the code. The kref on the parent is held
  by the device core during device_add and dropped in device_del

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c         | 15 ++++++---------
 drivers/char/tpm/tpm-dev.c          |  4 +---
 drivers/char/tpm/tpm-interface.c    | 30 ++++++++++++++++--------------
 drivers/char/tpm/tpm-sysfs.c        |  6 +++---
 drivers/char/tpm/tpm.h              |  3 +--
 drivers/char/tpm/tpm2-cmd.c         |  8 ++++----
 drivers/char/tpm/tpm_atmel.c        | 14 +++++++-------
 drivers/char/tpm/tpm_i2c_atmel.c    | 16 ++++++++--------
 drivers/char/tpm/tpm_i2c_infineon.c |  6 +++---
 drivers/char/tpm/tpm_i2c_nuvoton.c  | 26 +++++++++++++-------------
 drivers/char/tpm/tpm_infineon.c     | 22 +++++++++++-----------
 drivers/char/tpm/tpm_nsc.c          | 20 ++++++++++----------
 drivers/char/tpm/tpm_tis.c          | 16 ++++++++--------
 13 files changed, 91 insertions(+), 95 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index ae2fed8a162b..b1364bf62492 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -49,7 +49,7 @@ struct tpm_chip *tpm_chip_find_get(int chip_num)
 		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
 			continue;
 
-		if (try_module_get(pos->pdev->driver->owner)) {
+		if (try_module_get(pos->dev.parent->driver->owner)) {
 			chip = pos;
 			break;
 		}
@@ -114,13 +114,11 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 
 	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
 
-	chip->pdev = dev;
-
 	dev_set_drvdata(dev, chip);
 
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
-	chip->dev.parent = chip->pdev;
+	chip->dev.parent = dev;
 #ifdef CONFIG_ACPI
 	chip->dev.groups = chip->groups;
 #endif
@@ -135,7 +133,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	device_initialize(&chip->dev);
 
 	cdev_init(&chip->cdev, &tpm_fops);
-	chip->cdev.owner = chip->pdev->driver->owner;
+	chip->cdev.owner = dev->driver->owner;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
 	return chip;
@@ -236,9 +234,8 @@ int tpm_chip_register(struct tpm_chip *chip)
 	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
 
 	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
-		rc = __compat_only_sysfs_link_entry_to_kobj(&chip->pdev->kobj,
-							    &chip->dev.kobj,
-							    "ppi");
+		rc = __compat_only_sysfs_link_entry_to_kobj(
+		    &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
 		if (rc && rc != -ENOENT) {
 			tpm_chip_unregister(chip);
 			return rc;
@@ -273,7 +270,7 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	synchronize_rcu();
 
 	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
-		sysfs_remove_link(&chip->pdev->kobj, "ppi");
+		sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
 
 	tpm1_chip_unregister(chip);
 	tpm_dev_del_device(chip);
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index de0337ebd658..4009765c14fd 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -61,7 +61,7 @@ static int tpm_open(struct inode *inode, struct file *file)
 	 * by the check of is_open variable, which is protected
 	 * by driver_lock. */
 	if (test_and_set_bit(0, &chip->is_open)) {
-		dev_dbg(chip->pdev, "Another process owns this TPM\n");
+		dev_dbg(&chip->dev, "Another process owns this TPM\n");
 		return -EBUSY;
 	}
 
@@ -79,7 +79,6 @@ static int tpm_open(struct inode *inode, struct file *file)
 	INIT_WORK(&priv->work, timeout_work);
 
 	file->private_data = priv;
-	get_device(chip->pdev);
 	return 0;
 }
 
@@ -166,7 +165,6 @@ static int tpm_release(struct inode *inode, struct file *file)
 	file->private_data = NULL;
 	atomic_set(&priv->data_pending, 0);
 	clear_bit(0, &priv->chip->is_open);
-	put_device(priv->chip->pdev);
 	kfree(priv);
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index e2fa89c88304..483f86ff6a0a 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -345,7 +345,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	if (count == 0)
 		return -ENODATA;
 	if (count > bufsiz) {
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"invalid count value %x %zx\n", count, bufsiz);
 		return -E2BIG;
 	}
@@ -354,7 +354,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"tpm_transmit: tpm_send: error %zd\n", rc);
 		goto out;
 	}
@@ -373,7 +373,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 			goto out_recv;
 
 		if (chip->ops->req_canceled(chip, status)) {
-			dev_err(chip->pdev, "Operation Canceled\n");
+			dev_err(&chip->dev, "Operation Canceled\n");
 			rc = -ECANCELED;
 			goto out;
 		}
@@ -383,14 +383,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	} while (time_before(jiffies, stop));
 
 	chip->ops->cancel(chip);
-	dev_err(chip->pdev, "Operation Timed out\n");
+	dev_err(&chip->dev, "Operation Timed out\n");
 	rc = -ETIME;
 	goto out;
 
 out_recv:
 	rc = chip->ops->recv(chip, (u8 *) buf, bufsiz);
 	if (rc < 0)
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
 	mutex_unlock(&chip->tpm_mutex);
@@ -416,7 +416,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd,
 
 	err = be32_to_cpu(header->return_code);
 	if (err != 0 && desc)
-		dev_err(chip->pdev, "A TPM error (%d) occurred %s\n", err,
+		dev_err(&chip->dev, "A TPM error (%d) occurred %s\n", err,
 			desc);
 
 	return err;
@@ -527,7 +527,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
 		   Execute a startup command. */
-		dev_info(chip->pdev, "Issuing TPM_STARTUP");
+		dev_info(&chip->dev, "Issuing TPM_STARTUP");
 		if (tpm_startup(chip, TPM_ST_CLEAR))
 			return rc;
 
@@ -539,7 +539,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 				  NULL);
 	}
 	if (rc) {
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
 			rc);
 		goto duration;
@@ -578,7 +578,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 
 	/* Report adjusted timeouts */
 	if (chip->vendor.timeout_adjusted) {
-		dev_info(chip->pdev,
+		dev_info(&chip->dev,
 			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->%luus D %lu->%luus\n",
 			 old_timeout[0], new_timeout[0],
 			 old_timeout[1], new_timeout[1],
@@ -625,7 +625,7 @@ duration:
 		chip->vendor.duration[TPM_MEDIUM] *= 1000;
 		chip->vendor.duration[TPM_LONG] *= 1000;
 		chip->vendor.duration_adjusted = true;
-		dev_info(chip->pdev, "Adjusting TPM timeout parameters.");
+		dev_info(&chip->dev, "Adjusting TPM timeout parameters.");
 	}
 	return 0;
 }
@@ -815,7 +815,9 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		 * around 300ms while the self test is ongoing, keep trying
 		 * until the self test duration expires. */
 		if (rc == -ETIME) {
-			dev_info(chip->pdev, HW_ERR "TPM command timed out during continue self test");
+			dev_info(
+			    &chip->dev, HW_ERR
+			    "TPM command timed out during continue self test");
 			msleep(delay_msec);
 			continue;
 		}
@@ -825,7 +827,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 
 		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
-			dev_info(chip->pdev,
+			dev_info(&chip->dev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);
 			/* TPM is disabled and/or deactivated; driver can
 			 * proceed and TPM does handle commands for
@@ -978,10 +980,10 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 	if (rc)
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"Error (%d) sending savestate before suspend\n", rc);
 	else if (try > 0)
-		dev_warn(chip->pdev, "TPM savestate took %dms\n",
+		dev_warn(&chip->dev, "TPM savestate took %dms\n",
 			 try * TPM_TIMEOUT_RETRY);
 
 	return rc;
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index ee66fd4673f3..d93736aa2703 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -284,16 +284,16 @@ static const struct attribute_group tpm_dev_group = {
 int tpm_sysfs_add_device(struct tpm_chip *chip)
 {
 	int err;
-	err = sysfs_create_group(&chip->pdev->kobj,
+	err = sysfs_create_group(&chip->dev.parent->kobj,
 				 &tpm_dev_group);
 
 	if (err)
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"failed to create sysfs attributes, %d\n", err);
 	return err;
 }
 
 void tpm_sysfs_del_device(struct tpm_chip *chip)
 {
-	sysfs_remove_group(&chip->pdev->kobj, &tpm_dev_group);
+	sysfs_remove_group(&chip->dev.parent->kobj, &tpm_dev_group);
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index f6ba79d91857..371f75f4d2a7 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -174,7 +174,6 @@ enum tpm_chip_flags {
 };
 
 struct tpm_chip {
-	struct device *pdev;	/* Device stuff */
 	struct device dev;
 	struct cdev cdev;
 
@@ -206,7 +205,7 @@ struct tpm_chip {
 
 static inline void tpm_chip_put(struct tpm_chip *chip)
 {
-	module_put(chip->pdev->driver->owner);
+	module_put(chip->dev.parent->driver->owner);
 	put_device(&chip->dev);
 }
 
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 45a634016f95..6eb8b74b2d38 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -597,7 +597,7 @@ static void tpm2_flush_context(struct tpm_chip *chip, u32 handle)
 
 	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_FLUSH_CONTEXT);
 	if (rc) {
-		dev_warn(chip->pdev, "0x%08x was not flushed, out of memory\n",
+		dev_warn(&chip->dev, "0x%08x was not flushed, out of memory\n",
 			 handle);
 		return;
 	}
@@ -606,7 +606,7 @@ static void tpm2_flush_context(struct tpm_chip *chip, u32 handle)
 
 	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "flushing context");
 	if (rc)
-		dev_warn(chip->pdev, "0x%08x was not flushed, rc=%d\n", handle,
+		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
 			 rc);
 
 	tpm_buf_destroy(&buf);
@@ -770,7 +770,7 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
 	 * except print the error code on a system failure.
 	 */
 	if (rc < 0)
-		dev_warn(chip->pdev, "transmit returned %d while stopping the TPM",
+		dev_warn(&chip->dev, "transmit returned %d while stopping the TPM",
 			 rc);
 }
 EXPORT_SYMBOL_GPL(tpm2_shutdown);
@@ -837,7 +837,7 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
 	 * immediately. This is a workaround for that.
 	 */
 	if (rc == TPM2_RC_TESTING) {
-		dev_warn(chip->pdev, "Got RC_TESTING, ignoring\n");
+		dev_warn(&chip->dev, "Got RC_TESTING, ignoring\n");
 		rc = 0;
 	}
 
diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index dfadad0916a1..a48a878f791d 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -49,7 +49,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	for (i = 0; i < 6; i++) {
 		status = ioread8(chip->vendor.iobase + 1);
 		if ((status & ATML_STATUS_DATA_AVAIL) == 0) {
-			dev_err(chip->pdev, "error reading header\n");
+			dev_err(&chip->dev, "error reading header\n");
 			return -EIO;
 		}
 		*buf++ = ioread8(chip->vendor.iobase);
@@ -60,12 +60,12 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	size = be32_to_cpu(*native_size);
 
 	if (count < size) {
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"Recv size(%d) less than available space\n", size);
 		for (; i < size; i++) {	/* clear the waiting data anyway */
 			status = ioread8(chip->vendor.iobase + 1);
 			if ((status & ATML_STATUS_DATA_AVAIL) == 0) {
-				dev_err(chip->pdev, "error reading data\n");
+				dev_err(&chip->dev, "error reading data\n");
 				return -EIO;
 			}
 		}
@@ -76,7 +76,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	for (; i < size; i++) {
 		status = ioread8(chip->vendor.iobase + 1);
 		if ((status & ATML_STATUS_DATA_AVAIL) == 0) {
-			dev_err(chip->pdev, "error reading data\n");
+			dev_err(&chip->dev, "error reading data\n");
 			return -EIO;
 		}
 		*buf++ = ioread8(chip->vendor.iobase);
@@ -86,7 +86,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	status = ioread8(chip->vendor.iobase + 1);
 
 	if (status & ATML_STATUS_DATA_AVAIL) {
-		dev_err(chip->pdev, "data available is stuck\n");
+		dev_err(&chip->dev, "data available is stuck\n");
 		return -EIO;
 	}
 
@@ -97,9 +97,9 @@ static int tpm_atml_send(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	int i;
 
-	dev_dbg(chip->pdev, "tpm_atml_send:\n");
+	dev_dbg(&chip->dev, "tpm_atml_send:\n");
 	for (i = 0; i < count; i++) {
-		dev_dbg(chip->pdev, "%d 0x%x(%d)\n",  i, buf[i], buf[i]);
+		dev_dbg(&chip->dev, "%d 0x%x(%d)\n",  i, buf[i], buf[i]);
  		iowrite8(buf[i], chip->vendor.iobase);
 	}
 
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 8dfb88b9739c..dd8f0eb3170a 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -52,7 +52,7 @@ struct priv_data {
 static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	struct priv_data *priv = chip->vendor.priv;
-	struct i2c_client *client = to_i2c_client(chip->pdev);
+	struct i2c_client *client = to_i2c_client(chip->dev.parent);
 	s32 status;
 
 	priv->len = 0;
@@ -62,7 +62,7 @@ static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
 
 	status = i2c_master_send(client, buf, len);
 
-	dev_dbg(chip->pdev,
+	dev_dbg(&chip->dev,
 		"%s(buf=%*ph len=%0zx) -> sts=%d\n", __func__,
 		(int)min_t(size_t, 64, len), buf, len, status);
 	return status;
@@ -71,7 +71,7 @@ static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
 static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct priv_data *priv = chip->vendor.priv;
-	struct i2c_client *client = to_i2c_client(chip->pdev);
+	struct i2c_client *client = to_i2c_client(chip->dev.parent);
 	struct tpm_output_header *hdr =
 		(struct tpm_output_header *)priv->buffer;
 	u32 expected_len;
@@ -88,7 +88,7 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		return -ENOMEM;
 
 	if (priv->len >= expected_len) {
-		dev_dbg(chip->pdev,
+		dev_dbg(&chip->dev,
 			"%s early(buf=%*ph count=%0zx) -> ret=%d\n", __func__,
 			(int)min_t(size_t, 64, expected_len), buf, count,
 			expected_len);
@@ -97,7 +97,7 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	}
 
 	rc = i2c_master_recv(client, buf, expected_len);
-	dev_dbg(chip->pdev,
+	dev_dbg(&chip->dev,
 		"%s reread(buf=%*ph count=%0zx) -> ret=%d\n", __func__,
 		(int)min_t(size_t, 64, expected_len), buf, count,
 		expected_len);
@@ -106,13 +106,13 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 static void i2c_atmel_cancel(struct tpm_chip *chip)
 {
-	dev_err(chip->pdev, "TPM operation cancellation was requested, but is not supported");
+	dev_err(&chip->dev, "TPM operation cancellation was requested, but is not supported");
 }
 
 static u8 i2c_atmel_read_status(struct tpm_chip *chip)
 {
 	struct priv_data *priv = chip->vendor.priv;
-	struct i2c_client *client = to_i2c_client(chip->pdev);
+	struct i2c_client *client = to_i2c_client(chip->dev.parent);
 	int rc;
 
 	/* The TPM fails the I2C read until it is ready, so we do the entire
@@ -125,7 +125,7 @@ static u8 i2c_atmel_read_status(struct tpm_chip *chip)
 	/* Once the TPM has completed the command the command remains readable
 	 * until another command is issued. */
 	rc = i2c_master_recv(client, priv->buffer, sizeof(priv->buffer));
-	dev_dbg(chip->pdev,
+	dev_dbg(&chip->dev,
 		"%s: sts=%d", __func__, rc);
 	if (rc <= 0)
 		return 0;
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 63d5d22e9e60..f2aa99e34b4b 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -446,7 +446,7 @@ static int tpm_tis_i2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	/* read first 10 bytes, including tag, paramsize, and result */
 	size = recv_data(chip, buf, TPM_HEADER_SIZE);
 	if (size < TPM_HEADER_SIZE) {
-		dev_err(chip->pdev, "Unable to read header\n");
+		dev_err(&chip->dev, "Unable to read header\n");
 		goto out;
 	}
 
@@ -459,14 +459,14 @@ static int tpm_tis_i2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	size += recv_data(chip, &buf[TPM_HEADER_SIZE],
 			  expected - TPM_HEADER_SIZE);
 	if (size < expected) {
-		dev_err(chip->pdev, "Unable to read remainder of result\n");
+		dev_err(&chip->dev, "Unable to read remainder of result\n");
 		size = -ETIME;
 		goto out;
 	}
 
 	wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, &status);
 	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
-		dev_err(chip->pdev, "Error left over data\n");
+		dev_err(&chip->dev, "Error left over data\n");
 		size = -EIO;
 		goto out;
 	}
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 847f1597fe9b..8fb378f502e4 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -96,13 +96,13 @@ static s32 i2c_nuvoton_write_buf(struct i2c_client *client, u8 offset, u8 size,
 /* read TPM_STS register */
 static u8 i2c_nuvoton_read_status(struct tpm_chip *chip)
 {
-	struct i2c_client *client = to_i2c_client(chip->pdev);
+	struct i2c_client *client = to_i2c_client(chip->dev.parent);
 	s32 status;
 	u8 data;
 
 	status = i2c_nuvoton_read_buf(client, TPM_STS, 1, &data);
 	if (status <= 0) {
-		dev_err(chip->pdev, "%s() error return %d\n", __func__,
+		dev_err(&chip->dev, "%s() error return %d\n", __func__,
 			status);
 		data = TPM_STS_ERR_VAL;
 	}
@@ -127,13 +127,13 @@ static s32 i2c_nuvoton_write_status(struct i2c_client *client, u8 data)
 /* write commandReady to TPM_STS register */
 static void i2c_nuvoton_ready(struct tpm_chip *chip)
 {
-	struct i2c_client *client = to_i2c_client(chip->pdev);
+	struct i2c_client *client = to_i2c_client(chip->dev.parent);
 	s32 status;
 
 	/* this causes the current command to be aborted */
 	status = i2c_nuvoton_write_status(client, TPM_STS_COMMAND_READY);
 	if (status < 0)
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"%s() fail to write TPM_STS.commandReady\n", __func__);
 }
 
@@ -212,7 +212,7 @@ static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
 				return 0;
 		} while (time_before(jiffies, stop));
 	}
-	dev_err(chip->pdev, "%s(%02x, %02x) -> timeout\n", __func__, mask,
+	dev_err(&chip->dev, "%s(%02x, %02x) -> timeout\n", __func__, mask,
 		value);
 	return -ETIMEDOUT;
 }
@@ -240,7 +240,7 @@ static int i2c_nuvoton_recv_data(struct i2c_client *client,
 					       &chip->vendor.read_queue) == 0) {
 		burst_count = i2c_nuvoton_get_burstcount(client, chip);
 		if (burst_count < 0) {
-			dev_err(chip->pdev,
+			dev_err(&chip->dev,
 				"%s() fail to read burstCount=%d\n", __func__,
 				burst_count);
 			return -EIO;
@@ -249,12 +249,12 @@ static int i2c_nuvoton_recv_data(struct i2c_client *client,
 		rc = i2c_nuvoton_read_buf(client, TPM_DATA_FIFO_R,
 					  bytes2read, &buf[size]);
 		if (rc < 0) {
-			dev_err(chip->pdev,
+			dev_err(&chip->dev,
 				"%s() fail on i2c_nuvoton_read_buf()=%d\n",
 				__func__, rc);
 			return -EIO;
 		}
-		dev_dbg(chip->pdev, "%s(%d):", __func__, bytes2read);
+		dev_dbg(&chip->dev, "%s(%d):", __func__, bytes2read);
 		size += bytes2read;
 	}
 
@@ -264,8 +264,8 @@ static int i2c_nuvoton_recv_data(struct i2c_client *client,
 /* Read TPM command results */
 static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
-	struct device *dev = chip->pdev;
-	struct i2c_client *client = to_i2c_client(dev);
+	struct device *dev = &chip->dev;
+	struct i2c_client *client = to_i2c_client(chip->dev.parent);
 	s32 rc;
 	int expected, status, burst_count, retries, size = 0;
 
@@ -334,7 +334,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		break;
 	}
 	i2c_nuvoton_ready(chip);
-	dev_dbg(chip->pdev, "%s() -> %d\n", __func__, size);
+	dev_dbg(&chip->dev, "%s() -> %d\n", __func__, size);
 	return size;
 }
 
@@ -347,8 +347,8 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
  */
 static int i2c_nuvoton_send(struct tpm_chip *chip, u8 *buf, size_t len)
 {
-	struct device *dev = chip->pdev;
-	struct i2c_client *client = to_i2c_client(dev);
+	struct device *dev = &chip->dev;
+	struct i2c_client *client = to_i2c_client(chip->dev.parent);
 	u32 ordinal;
 	size_t count = 0;
 	int burst_count, bytes2write, retries, rc = -EIO;
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index 6c488e635fdd..e3cf9f3545c5 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -195,9 +195,9 @@ static int wait(struct tpm_chip *chip, int wait_for_bit)
 	}
 	if (i == TPM_MAX_TRIES) {	/* timeout occurs */
 		if (wait_for_bit == STAT_XFE)
-			dev_err(chip->pdev, "Timeout in wait(STAT_XFE)\n");
+			dev_err(&chip->dev, "Timeout in wait(STAT_XFE)\n");
 		if (wait_for_bit == STAT_RDA)
-			dev_err(chip->pdev, "Timeout in wait(STAT_RDA)\n");
+			dev_err(&chip->dev, "Timeout in wait(STAT_RDA)\n");
 		return -EIO;
 	}
 	return 0;
@@ -220,7 +220,7 @@ static void wait_and_send(struct tpm_chip *chip, u8 sendbyte)
 static void tpm_wtx(struct tpm_chip *chip)
 {
 	number_of_wtx++;
-	dev_info(chip->pdev, "Granting WTX (%02d / %02d)\n",
+	dev_info(&chip->dev, "Granting WTX (%02d / %02d)\n",
 		 number_of_wtx, TPM_MAX_WTX_PACKAGES);
 	wait_and_send(chip, TPM_VL_VER);
 	wait_and_send(chip, TPM_CTRL_WTX);
@@ -231,7 +231,7 @@ static void tpm_wtx(struct tpm_chip *chip)
 
 static void tpm_wtx_abort(struct tpm_chip *chip)
 {
-	dev_info(chip->pdev, "Aborting WTX\n");
+	dev_info(&chip->dev, "Aborting WTX\n");
 	wait_and_send(chip, TPM_VL_VER);
 	wait_and_send(chip, TPM_CTRL_WTX_ABORT);
 	wait_and_send(chip, 0x00);
@@ -257,7 +257,7 @@ recv_begin:
 	}
 
 	if (buf[0] != TPM_VL_VER) {
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"Wrong transport protocol implementation!\n");
 		return -EIO;
 	}
@@ -272,7 +272,7 @@ recv_begin:
 		}
 
 		if ((size == 0x6D00) && (buf[1] == 0x80)) {
-			dev_err(chip->pdev, "Error handling on vendor layer!\n");
+			dev_err(&chip->dev, "Error handling on vendor layer!\n");
 			return -EIO;
 		}
 
@@ -284,7 +284,7 @@ recv_begin:
 	}
 
 	if (buf[1] == TPM_CTRL_WTX) {
-		dev_info(chip->pdev, "WTX-package received\n");
+		dev_info(&chip->dev, "WTX-package received\n");
 		if (number_of_wtx < TPM_MAX_WTX_PACKAGES) {
 			tpm_wtx(chip);
 			goto recv_begin;
@@ -295,14 +295,14 @@ recv_begin:
 	}
 
 	if (buf[1] == TPM_CTRL_WTX_ABORT_ACK) {
-		dev_info(chip->pdev, "WTX-abort acknowledged\n");
+		dev_info(&chip->dev, "WTX-abort acknowledged\n");
 		return size;
 	}
 
 	if (buf[1] == TPM_CTRL_ERROR) {
-		dev_err(chip->pdev, "ERROR-package received:\n");
+		dev_err(&chip->dev, "ERROR-package received:\n");
 		if (buf[4] == TPM_INF_NAK)
-			dev_err(chip->pdev,
+			dev_err(&chip->dev,
 				"-> Negative acknowledgement"
 				" - retransmit command!\n");
 		return -EIO;
@@ -321,7 +321,7 @@ static int tpm_inf_send(struct tpm_chip *chip, u8 * buf, size_t count)
 
 	ret = empty_fifo(chip, 1);
 	if (ret) {
-		dev_err(chip->pdev, "Timeout while clearing FIFO\n");
+		dev_err(&chip->dev, "Timeout while clearing FIFO\n");
 		return -EIO;
 	}
 
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 289389ecef84..766370bed60c 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -113,7 +113,7 @@ static int nsc_wait_for_ready(struct tpm_chip *chip)
 	}
 	while (time_before(jiffies, stop));
 
-	dev_info(chip->pdev, "wait for ready failed\n");
+	dev_info(&chip->dev, "wait for ready failed\n");
 	return -EBUSY;
 }
 
@@ -129,12 +129,12 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 		return -EIO;
 
 	if (wait_for_stat(chip, NSC_STATUS_F0, NSC_STATUS_F0, &data) < 0) {
-		dev_err(chip->pdev, "F0 timeout\n");
+		dev_err(&chip->dev, "F0 timeout\n");
 		return -EIO;
 	}
 	if ((data =
 	     inb(chip->vendor.base + NSC_DATA)) != NSC_COMMAND_NORMAL) {
-		dev_err(chip->pdev, "not in normal mode (0x%x)\n",
+		dev_err(&chip->dev, "not in normal mode (0x%x)\n",
 			data);
 		return -EIO;
 	}
@@ -143,7 +143,7 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 	for (p = buffer; p < &buffer[count]; p++) {
 		if (wait_for_stat
 		    (chip, NSC_STATUS_OBF, NSC_STATUS_OBF, &data) < 0) {
-			dev_err(chip->pdev,
+			dev_err(&chip->dev,
 				"OBF timeout (while reading data)\n");
 			return -EIO;
 		}
@@ -154,11 +154,11 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 
 	if ((data & NSC_STATUS_F0) == 0 &&
 	(wait_for_stat(chip, NSC_STATUS_F0, NSC_STATUS_F0, &data) < 0)) {
-		dev_err(chip->pdev, "F0 not set\n");
+		dev_err(&chip->dev, "F0 not set\n");
 		return -EIO;
 	}
 	if ((data = inb(chip->vendor.base + NSC_DATA)) != NSC_COMMAND_EOC) {
-		dev_err(chip->pdev,
+		dev_err(&chip->dev,
 			"expected end of command(0x%x)\n", data);
 		return -EIO;
 	}
@@ -189,19 +189,19 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
 		return -EIO;
 
 	if (wait_for_stat(chip, NSC_STATUS_IBF, 0, &data) < 0) {
-		dev_err(chip->pdev, "IBF timeout\n");
+		dev_err(&chip->dev, "IBF timeout\n");
 		return -EIO;
 	}
 
 	outb(NSC_COMMAND_NORMAL, chip->vendor.base + NSC_COMMAND);
 	if (wait_for_stat(chip, NSC_STATUS_IBR, NSC_STATUS_IBR, &data) < 0) {
-		dev_err(chip->pdev, "IBR timeout\n");
+		dev_err(&chip->dev, "IBR timeout\n");
 		return -EIO;
 	}
 
 	for (i = 0; i < count; i++) {
 		if (wait_for_stat(chip, NSC_STATUS_IBF, 0, &data) < 0) {
-			dev_err(chip->pdev,
+			dev_err(&chip->dev,
 				"IBF timeout (while writing data)\n");
 			return -EIO;
 		}
@@ -209,7 +209,7 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
 	}
 
 	if (wait_for_stat(chip, NSC_STATUS_IBF, 0, &data) < 0) {
-		dev_err(chip->pdev, "IBF timeout\n");
+		dev_err(&chip->dev, "IBF timeout\n");
 		return -EIO;
 	}
 	outb(NSC_COMMAND_EOC, chip->vendor.base + NSC_COMMAND);
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 8a3509cb10da..f15466b7fb78 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -293,7 +293,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	/* read first 10 bytes, including tag, paramsize, and result */
 	if ((size =
 	     recv_data(chip, buf, TPM_HEADER_SIZE)) < TPM_HEADER_SIZE) {
-		dev_err(chip->pdev, "Unable to read header\n");
+		dev_err(&chip->dev, "Unable to read header\n");
 		goto out;
 	}
 
@@ -306,7 +306,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	if ((size +=
 	     recv_data(chip, &buf[TPM_HEADER_SIZE],
 		       expected - TPM_HEADER_SIZE)) < expected) {
-		dev_err(chip->pdev, "Unable to read remainder of result\n");
+		dev_err(&chip->dev, "Unable to read remainder of result\n");
 		size = -ETIME;
 		goto out;
 	}
@@ -315,7 +315,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 			  &chip->vendor.int_queue, false);
 	status = tpm_tis_status(chip);
 	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
-		dev_err(chip->pdev, "Error left over data\n");
+		dev_err(&chip->dev, "Error left over data\n");
 		size = -EIO;
 		goto out;
 	}
@@ -401,7 +401,7 @@ static void disable_interrupts(struct tpm_chip *chip)
 	iowrite32(intmask,
 		  chip->vendor.iobase +
 		  TPM_INT_ENABLE(chip->vendor.locality));
-	devm_free_irq(chip->pdev, chip->vendor.irq, chip);
+	devm_free_irq(&chip->dev, chip->vendor.irq, chip);
 	chip->vendor.irq = 0;
 }
 
@@ -530,7 +530,7 @@ static int probe_itpm(struct tpm_chip *chip)
 
 	rc = tpm_tis_send_data(chip, cmd_getticks, len);
 	if (rc == 0) {
-		dev_info(chip->pdev, "Detected an iTPM.\n");
+		dev_info(&chip->dev, "Detected an iTPM.\n");
 		rc = 1;
 	} else
 		rc = -EFAULT;
@@ -609,9 +609,9 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	struct priv_data *priv = chip->vendor.priv;
 	u8 original_int_vec;
 
-	if (devm_request_irq(chip->pdev, irq, tis_int_handler, flags,
+	if (devm_request_irq(chip->dev.parent, irq, tis_int_handler, flags,
 			     chip->devname, chip) != 0) {
-		dev_info(chip->pdev, "Unable to request irq: %d for probe\n",
+		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
 			 irq);
 		return -1;
 	}
@@ -812,7 +812,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 tpm_info->irq);
 			if (!chip->vendor.irq)
-				dev_err(chip->pdev, FW_BUG
+				dev_err(&chip->dev, FW_BUG
 					"TPM interrupt not working, polling instead\n");
 		} else
 			tpm_tis_probe_irq(chip, intmask);
-- 
2.1.4


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
