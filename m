From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 4/6] tpm: split out tpm-dev.c into tpm-dev.c
	and tpm-common-dev.c
Date: Wed,  8 Feb 2017 13:07:06 +0200
Message-ID: <20170208110713.14070-5-jarkko.sakkinen@linux.intel.com>
References: <20170208110713.14070-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170208110713.14070-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Signed-off-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
---
 drivers/char/tpm/Makefile         |   2 +-
 drivers/char/tpm/tpm-dev-common.c | 148 ++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-dev.c        | 143 ++++--------------------------------
 drivers/char/tpm/tpm-dev.h        |  27 +++++++
 4 files changed, 190 insertions(+), 130 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev-common.c
 create mode 100644 drivers/char/tpm/tpm-dev.h

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 8f07fcf..10e5827 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -3,7 +3,7 @@
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
-	 tpm1_eventlog.o tpm2_eventlog.o tpm2-space.o
+	 tpm-dev-common.o tpm1_eventlog.o tpm2_eventlog.o tpm2-space.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
 tpm-$(CONFIG_OF) += tpm_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
new file mode 100644
index 0000000..610638a
--- /dev/null
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -0,0 +1,148 @@
+/*
+ * Copyright (C) 2004 IBM Corporation
+ * Authors:
+ * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ * Dave Safford <safford-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ * Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ * Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * Copyright (C) 2013 Obsidian Research Corp
+ * Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
+ *
+ * Device file system interface to the TPM
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include "tpm.h"
+#include "tpm-dev.h"
+
+static void user_reader_timeout(unsigned long ptr)
+{
+	struct file_priv *priv = (struct file_priv *)ptr;
+
+	pr_warn("TPM user space timeout is deprecated (pid=%d)\n",
+		task_tgid_nr(current));
+
+	schedule_work(&priv->work);
+}
+
+static void timeout_work(struct work_struct *work)
+{
+	struct file_priv *priv = container_of(work, struct file_priv, work);
+
+	mutex_lock(&priv->buffer_mutex);
+	atomic_set(&priv->data_pending, 0);
+	memset(priv->data_buffer, 0, sizeof(priv->data_buffer));
+	mutex_unlock(&priv->buffer_mutex);
+}
+
+void tpm_common_open(struct file *file, struct tpm_chip *chip,
+		     struct file_priv *priv)
+{
+	priv->chip = chip;
+	atomic_set(&priv->data_pending, 0);
+	mutex_init(&priv->buffer_mutex);
+	setup_timer(&priv->user_read_timer, user_reader_timeout,
+			(unsigned long)priv);
+	INIT_WORK(&priv->work, timeout_work);
+
+	file->private_data = priv;
+}
+
+ssize_t tpm_common_read(struct file *file, char __user *buf,
+			size_t size, loff_t *off)
+{
+	struct file_priv *priv = file->private_data;
+	ssize_t ret_size;
+	ssize_t orig_ret_size;
+	int rc;
+
+	del_singleshot_timer_sync(&priv->user_read_timer);
+	flush_work(&priv->work);
+	ret_size = atomic_read(&priv->data_pending);
+	if (ret_size > 0) {	/* relay data */
+		orig_ret_size = ret_size;
+		if (size < ret_size)
+			ret_size = size;
+
+		mutex_lock(&priv->buffer_mutex);
+		rc = copy_to_user(buf, priv->data_buffer, ret_size);
+		memset(priv->data_buffer, 0, orig_ret_size);
+		if (rc)
+			ret_size = -EFAULT;
+
+		mutex_unlock(&priv->buffer_mutex);
+	}
+
+	atomic_set(&priv->data_pending, 0);
+
+	return ret_size;
+}
+
+ssize_t tpm_common_write(struct file *file, const char __user *buf,
+			 size_t size, loff_t *off, struct tpm_space *space)
+{
+	struct file_priv *priv = file->private_data;
+	size_t in_size = size;
+	ssize_t out_size;
+
+	/* Cannot perform a write until the read has cleared either via
+	 * tpm_read or a user_read_timer timeout. This also prevents split
+	 * buffered writes from blocking here.
+	 */
+	if (atomic_read(&priv->data_pending) != 0)
+		return -EBUSY;
+
+	if (in_size > TPM_BUFSIZE)
+		return -E2BIG;
+
+	mutex_lock(&priv->buffer_mutex);
+
+	if (copy_from_user
+	    (priv->data_buffer, (void __user *) buf, in_size)) {
+		mutex_unlock(&priv->buffer_mutex);
+		return -EFAULT;
+	}
+
+	/* atomic tpm command send and result receive. We only hold the ops
+	 * lock during this period so that the tpm can be unregistered even if
+	 * the char dev is held open.
+	 */
+	if (tpm_try_get_ops(priv->chip)) {
+		mutex_unlock(&priv->buffer_mutex);
+		return -EPIPE;
+	}
+	out_size = tpm_transmit(priv->chip, space, priv->data_buffer,
+				sizeof(priv->data_buffer), 0);
+
+	tpm_put_ops(priv->chip);
+	if (out_size < 0) {
+		mutex_unlock(&priv->buffer_mutex);
+		return out_size;
+	}
+
+	atomic_set(&priv->data_pending, out_size);
+	mutex_unlock(&priv->buffer_mutex);
+
+	/* Set a timeout by which the reader must come claim the result */
+	mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
+
+	return in_size;
+}
+
+/*
+ * Called on file close
+ */
+void tpm_common_release(struct file *file, struct file_priv *priv)
+{
+	del_singleshot_timer_sync(&priv->user_read_timer);
+	flush_work(&priv->work);
+	file->private_data = NULL;
+	atomic_set(&priv->data_pending, 0);
+}
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 414553b..ebd74ab 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -18,48 +18,15 @@
  *
  */
 #include <linux/slab.h>
-#include <linux/uaccess.h>
-#include "tpm.h"
-
-struct file_priv {
-	struct tpm_chip *chip;
-
-	/* Data passed to and from the tpm via the read/write calls */
-	atomic_t data_pending;
-	struct mutex buffer_mutex;
-
-	struct timer_list user_read_timer;      /* user needs to claim result */
-	struct work_struct work;
-
-	u8 data_buffer[TPM_BUFSIZE];
-};
-
-static void user_reader_timeout(unsigned long ptr)
-{
-	struct file_priv *priv = (struct file_priv *)ptr;
-
-	pr_warn("TPM user space timeout is deprecated (pid=%d)\n",
-		task_tgid_nr(current));
-
-	schedule_work(&priv->work);
-}
-
-static void timeout_work(struct work_struct *work)
-{
-	struct file_priv *priv = container_of(work, struct file_priv, work);
-
-	mutex_lock(&priv->buffer_mutex);
-	atomic_set(&priv->data_pending, 0);
-	memset(priv->data_buffer, 0, sizeof(priv->data_buffer));
-	mutex_unlock(&priv->buffer_mutex);
-}
+#include "tpm-dev.h"
 
 static int tpm_open(struct inode *inode, struct file *file)
 {
-	struct tpm_chip *chip =
-		container_of(inode->i_cdev, struct tpm_chip, cdev);
+	struct tpm_chip *chip;
 	struct file_priv *priv;
 
+	chip = container_of(inode->i_cdev, struct tpm_chip, cdev);
+
 	/* It's assured that the chip will be opened just once,
 	 * by the check of is_open variable, which is protected
 	 * by driver_lock. */
@@ -69,100 +36,22 @@ static int tpm_open(struct inode *inode, struct file *file)
 	}
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv == NULL) {
-		clear_bit(0, &chip->is_open);
-		return -ENOMEM;
-	}
+	if (priv == NULL)
+		goto out;
 
-	priv->chip = chip;
-	atomic_set(&priv->data_pending, 0);
-	mutex_init(&priv->buffer_mutex);
-	setup_timer(&priv->user_read_timer, user_reader_timeout,
-			(unsigned long)priv);
-	INIT_WORK(&priv->work, timeout_work);
+	tpm_common_open(file, chip, priv);
 
-	file->private_data = priv;
 	return 0;
-}
-
-static ssize_t tpm_read(struct file *file, char __user *buf,
-			size_t size, loff_t *off)
-{
-	struct file_priv *priv = file->private_data;
-	ssize_t ret_size;
-	int rc;
 
-	del_singleshot_timer_sync(&priv->user_read_timer);
-	flush_work(&priv->work);
-	ret_size = atomic_read(&priv->data_pending);
-	if (ret_size > 0) {	/* relay data */
-		ssize_t orig_ret_size = ret_size;
-		if (size < ret_size)
-			ret_size = size;
-
-		mutex_lock(&priv->buffer_mutex);
-		rc = copy_to_user(buf, priv->data_buffer, ret_size);
-		memset(priv->data_buffer, 0, orig_ret_size);
-		if (rc)
-			ret_size = -EFAULT;
-
-		mutex_unlock(&priv->buffer_mutex);
-	}
-
-	atomic_set(&priv->data_pending, 0);
-
-	return ret_size;
+ out:
+	clear_bit(0, &chip->is_open);
+	return -ENOMEM;
 }
 
 static ssize_t tpm_write(struct file *file, const char __user *buf,
 			 size_t size, loff_t *off)
 {
-	struct file_priv *priv = file->private_data;
-	size_t in_size = size;
-	ssize_t out_size;
-
-	/* cannot perform a write until the read has cleared
-	   either via tpm_read or a user_read_timer timeout.
-	   This also prevents splitted buffered writes from blocking here.
-	*/
-	if (atomic_read(&priv->data_pending) != 0)
-		return -EBUSY;
-
-	if (in_size > TPM_BUFSIZE)
-		return -E2BIG;
-
-	mutex_lock(&priv->buffer_mutex);
-
-	if (copy_from_user
-	    (priv->data_buffer, (void __user *) buf, in_size)) {
-		mutex_unlock(&priv->buffer_mutex);
-		return -EFAULT;
-	}
-
-	/* atomic tpm command send and result receive. We only hold the ops
-	 * lock during this period so that the tpm can be unregistered even if
-	 * the char dev is held open.
-	 */
-	if (tpm_try_get_ops(priv->chip)) {
-		mutex_unlock(&priv->buffer_mutex);
-		return -EPIPE;
-	}
-	out_size = tpm_transmit(priv->chip, NULL, priv->data_buffer,
-				sizeof(priv->data_buffer), 0);
-
-	tpm_put_ops(priv->chip);
-	if (out_size < 0) {
-		mutex_unlock(&priv->buffer_mutex);
-		return out_size;
-	}
-
-	atomic_set(&priv->data_pending, out_size);
-	mutex_unlock(&priv->buffer_mutex);
-
-	/* Set a timeout by which the reader must come claim the result */
-	mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
-
-	return in_size;
+	return tpm_common_write(file, buf, size, off, NULL);
 }
 
 /*
@@ -172,12 +61,10 @@ static int tpm_release(struct inode *inode, struct file *file)
 {
 	struct file_priv *priv = file->private_data;
 
-	del_singleshot_timer_sync(&priv->user_read_timer);
-	flush_work(&priv->work);
-	file->private_data = NULL;
-	atomic_set(&priv->data_pending, 0);
+	tpm_common_release(file, priv);
 	clear_bit(0, &priv->chip->is_open);
 	kfree(priv);
+
 	return 0;
 }
 
@@ -185,9 +72,7 @@ const struct file_operations tpm_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.open = tpm_open,
-	.read = tpm_read,
+	.read = tpm_common_read,
 	.write = tpm_write,
 	.release = tpm_release,
 };
-
-
diff --git a/drivers/char/tpm/tpm-dev.h b/drivers/char/tpm/tpm-dev.h
new file mode 100644
index 0000000..ff15cf7
--- /dev/null
+++ b/drivers/char/tpm/tpm-dev.h
@@ -0,0 +1,27 @@
+#ifndef _TPM_DEV_H
+#define _TPM_DEV_H
+
+#include "tpm.h"
+
+struct file_priv {
+	struct tpm_chip *chip;
+
+	/* Data passed to and from the tpm via the read/write calls */
+	atomic_t data_pending;
+	struct mutex buffer_mutex;
+
+	struct timer_list user_read_timer;      /* user needs to claim result */
+	struct work_struct work;
+
+	u8 data_buffer[TPM_BUFSIZE];
+};
+
+void tpm_common_open(struct file *file, struct tpm_chip *chip,
+		     struct file_priv *priv);
+ssize_t tpm_common_read(struct file *file, char __user *buf,
+			size_t size, loff_t *off);
+ssize_t tpm_common_write(struct file *file, const char __user *buf,
+			 size_t size, loff_t *off, struct tpm_space *space);
+void tpm_common_release(struct file *file, struct file_priv *priv);
+
+#endif
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
