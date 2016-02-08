From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 2/5] Implement driver for supporting
	multiple emulated TPMs
Date: Mon,  8 Feb 2016 14:27:05 -0500
Message-ID: <1454959628-30582-3-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1454959628-30582-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

This patch implements a driver for supporting multiple emulated TPMs in a
system.

The driver implements a device /dev/vtpmx that is used to created
a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
is accessed using a file descriptor returned by an ioctl.
The device /dev/tpmX is the usual TPM device created by the core TPM
driver. Applications or kernel subsystems can send TPM commands to it
and the corresponding server-side file descriptor receives these
commands and delivers them to an emulated TPM. The device /dev/tpmX can
be moved into a container and appear there as /dev/tpm0.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Kconfig    |  10 +
 drivers/char/tpm/Makefile   |   1 +
 drivers/char/tpm/tpm-vtpm.c | 606 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h      |   2 +
 include/uapi/linux/Kbuild   |   1 +
 include/uapi/linux/vtpm.h   |  38 +++
 6 files changed, 658 insertions(+)
 create mode 100644 drivers/char/tpm/tpm-vtpm.c
 create mode 100644 include/uapi/linux/vtpm.h

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 3b84a8b..4c4e843 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -122,5 +122,15 @@ config TCG_CRB
 	  from within Linux.  To compile this driver as a module, choose
 	  M here; the module will be called tpm_crb.
 
+config TCG_VTPM
+	tristate "VTPM Interface"
+	depends on TCG_TPM
+	---help---
+	  This driver supports an emulated TPM (vTPM) running in userspace.
+	  A device /dev/vtpmx is provided that creates a device pair
+	  /dev/vtpmX and a server-side file descriptor on which the vTPM
+	  can receive commands.
+
+
 source "drivers/char/tpm/st33zp24/Kconfig"
 endif # TCG_TPM
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 56e8f1f..d947db2 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
 obj-$(CONFIG_TCG_TIS_ST33ZP24) += st33zp24/
 obj-$(CONFIG_TCG_XEN) += xen-tpmfront.o
 obj-$(CONFIG_TCG_CRB) += tpm_crb.o
+obj-$(CONFIG_TCG_VTPM) += tpm-vtpm.o
diff --git a/drivers/char/tpm/tpm-vtpm.c b/drivers/char/tpm/tpm-vtpm.c
new file mode 100644
index 0000000..6ee1e44
--- /dev/null
+++ b/drivers/char/tpm/tpm-vtpm.c
@@ -0,0 +1,606 @@
+/*
+ * Copyright (C) 2015, 2016 IBM Corporation
+ *
+ * Author: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+ *
+ * Device driver for vTPM.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+#include <linux/miscdevice.h>
+#include <linux/vtpm.h>
+#include <linux/file.h>
+#include <linux/anon_inodes.h>
+#include <linux/poll.h>
+#include <linux/compat.h>
+
+#include "tpm.h"
+
+#define VTPM_NUM_DEVICES TPM_NUM_DEVICES
+
+struct vtpm_dev {
+	struct device dev;
+
+	struct tpm_chip *chip;
+
+	u32 flags;                   /* public API flags */
+
+	int dev_num;
+
+	long state;
+#define STATE_OPENED_BIT   0
+
+	spinlock_t buf_lock;         /* lock for buffers */
+
+	wait_queue_head_t wq;
+
+	size_t req_len;              /* length of queued TPM request */
+	u8 req_buf[TPM_BUFSIZE];     /* request buffer */
+
+	size_t resp_len;             /* length of queued TPM response */
+	u8 resp_buf[TPM_BUFSIZE];    /* response buffer */
+
+	struct list_head list;
+};
+
+static DECLARE_BITMAP(dev_mask, VTPM_NUM_DEVICES);
+static LIST_HEAD(vtpm_list);
+static DEFINE_SPINLOCK(driver_lock);
+
+static struct class *vtpm_class;
+
+static void vtpm_delete_device_pair(struct vtpm_dev *vtpm_dev);
+
+/*
+ * Functions related to 'server side'
+ */
+
+/**
+ * vtpm_fops_read - Read TPM commands on 'server side'
+ *
+ * Return value:
+ *	Number of bytes read or negative error code
+ */
+static ssize_t vtpm_fops_read(struct file *filp, char __user *buf,
+			      size_t count, loff_t *off)
+{
+	struct vtpm_dev *vtpm_dev = filp->private_data;
+	size_t len;
+	int sig, rc;
+
+	sig = wait_event_interruptible(vtpm_dev->wq, vtpm_dev->req_len != 0);
+	if (sig)
+		return -EINTR;
+
+	len = vtpm_dev->req_len;
+
+	if (count < len) {
+		dev_err(&vtpm_dev->dev,
+			"Invalid size in recv: count=%zd, req_len=%zd\n",
+			count, len);
+		return -EIO;
+	}
+
+	spin_lock(&vtpm_dev->buf_lock);
+
+	rc = copy_to_user(buf, vtpm_dev->req_buf, len);
+	memset(vtpm_dev->req_buf, 0, len);
+	vtpm_dev->req_len = 0;
+
+	spin_unlock(&vtpm_dev->buf_lock);
+
+	if (rc)
+		return -EFAULT;
+
+	return len;
+}
+
+/**
+ * vtpm_fops_write - Write TPM responses on 'server side'
+ *
+ * Return value:
+ *	Number of bytes read or negative error value
+ */
+static ssize_t vtpm_fops_write(struct file *filp, const char __user *buf,
+			       size_t count, loff_t *off)
+{
+	struct vtpm_dev *vtpm_dev = filp->private_data;
+
+	if (count > sizeof(vtpm_dev->resp_buf))
+		return -EIO;
+
+	spin_lock(&vtpm_dev->buf_lock);
+
+	vtpm_dev->req_len = 0;
+
+	if (copy_from_user(vtpm_dev->resp_buf, buf, count)) {
+		spin_unlock(&vtpm_dev->buf_lock);
+		return -EFAULT;
+	}
+
+	vtpm_dev->resp_len = count;
+
+	spin_unlock(&vtpm_dev->buf_lock);
+
+	wake_up_interruptible(&vtpm_dev->wq);
+
+	return count;
+}
+
+/*
+ * vtpm_fops_poll: Poll status on 'server side'
+ *
+ * Return value:
+ *      Poll flags
+ */
+static unsigned int vtpm_fops_poll(struct file *filp, poll_table *wait)
+{
+	struct vtpm_dev *vtpm_dev = filp->private_data;
+	unsigned ret;
+
+	poll_wait(filp, &vtpm_dev->wq, wait);
+
+	ret = POLLOUT;
+	if (vtpm_dev->req_len)
+		ret |= POLLIN | POLLRDNORM;
+
+	return ret;
+}
+
+/*
+ * vtpm_fops_open - Open vTPM device on 'server side'
+ *
+ * Called when setting up the anonymous file descriptor
+ */
+static void vtpm_fops_open(struct file *filp)
+{
+	struct vtpm_dev *vtpm_dev = filp->private_data;
+
+	set_bit(STATE_OPENED_BIT, &vtpm_dev->state);
+}
+
+/**
+ * vtpm_fops_undo_open - counter-part to vtpm_fops_open
+ *
+ * Call to undo vtpm_fops_open
+ */
+static void vtpm_fops_undo_open(struct vtpm_dev *vtpm_dev)
+{
+	clear_bit(STATE_OPENED_BIT, &vtpm_dev->state);
+
+	/* no more TPM responses -- wake up anyone waiting for them */
+	wake_up_interruptible(&vtpm_dev->wq);
+}
+
+/*
+ * vtpm_fops_release: Close 'server side'
+ *
+ * Return value:
+ *      Always returns 0.
+ */
+static int vtpm_fops_release(struct inode *inode, struct file *filp)
+{
+	struct vtpm_dev *vtpm_dev = filp->private_data;
+
+	filp->private_data = NULL;
+
+	vtpm_delete_device_pair(vtpm_dev);
+
+	return 0;
+}
+
+static const struct file_operations vtpm_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.read = vtpm_fops_read,
+	.write = vtpm_fops_write,
+	.poll = vtpm_fops_poll,
+	.release = vtpm_fops_release,
+};
+
+/*
+ * Functions invoked by the core TPM driver to send TPM commands to
+ * 'server side' and receive responses from there.
+ */
+
+/*
+ * Called when core TPM driver reads TPM responses from 'server side'
+ *
+ * Return value:
+ *      Number of TPM response bytes read, negative error value otherwise
+ */
+static int vtpm_tpm_op_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct vtpm_dev *vtpm_dev = chip->priv;
+	int sig;
+	size_t len;
+
+	if (!vtpm_dev)
+		return -EIO;
+
+	/* wait for response or responder gone */
+	sig = wait_event_interruptible(vtpm_dev->wq,
+		(vtpm_dev->resp_len != 0
+		|| !test_bit(STATE_OPENED_BIT, &vtpm_dev->state)));
+	if (sig)
+		return -EINTR;
+
+	/* process gone ? */
+	if (!test_bit(STATE_OPENED_BIT, &vtpm_dev->state))
+		return -EIO;
+
+	len = vtpm_dev->resp_len;
+	if (count < len) {
+		dev_err(&vtpm_dev->dev,
+			"Invalid size in recv: count=%zd, resp_len=%zd\n",
+			count, len);
+		return -EIO;
+	}
+
+	spin_lock(&vtpm_dev->buf_lock);
+
+	memcpy(buf, vtpm_dev->resp_buf, len);
+	vtpm_dev->resp_len = 0;
+
+	spin_unlock(&vtpm_dev->buf_lock);
+
+	return len;
+}
+
+/*
+ * Called when core TPM driver forwards TPM requests to 'server side'.
+ *
+ * Return value:
+ *      0 in case of success, negative error value otherwise.
+ */
+static int vtpm_tpm_op_send(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct vtpm_dev *vtpm_dev = chip->priv;
+	int rc = 0;
+
+	if (!vtpm_dev)
+		return -EIO;
+
+	if (!test_bit(STATE_OPENED_BIT, &vtpm_dev->state))
+		return -EINVAL;
+
+	if (count > sizeof(vtpm_dev->req_buf)) {
+		dev_err(&vtpm_dev->dev,
+			"Invalid size in send: count=%zd, buffer size=%zd\n",
+			count, sizeof(vtpm_dev->req_buf));
+		return -EIO;
+	}
+
+	spin_lock(&vtpm_dev->buf_lock);
+
+	vtpm_dev->resp_len = 0;
+
+	vtpm_dev->req_len = count;
+	memcpy(vtpm_dev->req_buf, buf, count);
+
+	spin_unlock(&vtpm_dev->buf_lock);
+
+	wake_up_interruptible(&vtpm_dev->wq);
+
+	return rc;
+}
+
+static void vtpm_tpm_op_cancel(struct tpm_chip *chip)
+{
+	/* not supported */
+}
+
+static u8 vtpm_tpm_op_status(struct tpm_chip *chip)
+{
+	return 0;
+}
+
+static bool vtpm_tpm_req_canceled(struct tpm_chip  *chip, u8 status)
+{
+	return (status == 0);
+}
+
+static const struct tpm_class_ops vtpm_tpm_ops = {
+	.recv = vtpm_tpm_op_recv,
+	.send = vtpm_tpm_op_send,
+	.cancel = vtpm_tpm_op_cancel,
+	.status = vtpm_tpm_op_status,
+	.req_complete_mask = 0,
+	.req_complete_val = 0,
+	.req_canceled = vtpm_tpm_req_canceled,
+};
+
+/*
+ * Code related to creation and deletion of device pairs
+ */
+static void vtpm_dev_release(struct device *dev)
+{
+	struct vtpm_dev *vtpm_dev = container_of(dev, struct vtpm_dev, dev);
+
+	spin_lock(&driver_lock);
+	clear_bit(vtpm_dev->dev_num, dev_mask);
+	spin_unlock(&driver_lock);
+
+	kfree(vtpm_dev);
+}
+
+static struct device_driver vtpm_driver = {
+	.name = "tpm-vtpm",
+	.owner = THIS_MODULE,
+};
+
+struct vtpm_dev *vtpm_create_vtpm_dev(void)
+{
+	struct vtpm_dev *vtpm_dev;
+	int err;
+
+	vtpm_dev = kzalloc(sizeof(*vtpm_dev), GFP_KERNEL);
+	if (vtpm_dev == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	init_waitqueue_head(&vtpm_dev->wq);
+	spin_lock_init(&vtpm_dev->buf_lock);
+
+	spin_lock(&driver_lock);
+	vtpm_dev->dev_num = find_first_zero_bit(dev_mask, VTPM_NUM_DEVICES);
+
+	if (vtpm_dev->dev_num >= VTPM_NUM_DEVICES) {
+		spin_unlock(&driver_lock);
+		kfree(vtpm_dev);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* device is needed for core TPM driver */
+	vtpm_dev->dev.class = vtpm_class;
+	vtpm_dev->dev.release = vtpm_dev_release;
+	vtpm_dev->dev.driver = &vtpm_driver;
+	dev_set_name(&vtpm_dev->dev, "vtpms%d", vtpm_dev->dev_num);
+
+	err = device_register(&vtpm_dev->dev); /* does get_device */
+	if (err) {
+		spin_unlock(&driver_lock);
+		kfree(vtpm_dev);
+		return ERR_PTR(err);
+	}
+
+	set_bit(vtpm_dev->dev_num, dev_mask);
+
+	spin_unlock(&driver_lock);
+
+	return vtpm_dev;
+}
+
+/*
+ * Undo what has been done in vtpm_create_vtpm_dev
+ */
+void vtpm_delete_vtpm_dev(struct vtpm_dev *vtpm_dev)
+{
+	device_unregister(&vtpm_dev->dev); /* does put_device */
+}
+
+/*
+ * Create a /dev/tpm%d and 'server side' file descriptor pair
+ *
+ * Return value:
+ *      Returns file pointer on success, an error value otherwise
+ */
+static struct file *vtpm_create_device_pair(
+				       struct vtpm_new_pair *vtpm_new_pair)
+{
+	struct vtpm_dev *vtpm_dev;
+	int rc, fd;
+	struct file *file;
+	struct tpm_chip *chip;
+
+	vtpm_dev = vtpm_create_vtpm_dev();
+	if (IS_ERR(vtpm_dev))
+		return ERR_CAST(vtpm_dev);
+
+	vtpm_dev->flags = vtpm_new_pair->flags;
+
+	/* setup an anonymous file for the server-side */
+	fd = get_unused_fd_flags(O_RDWR);
+	if (fd < 0) {
+		rc = fd;
+		goto err_delete_vtpm_dev;
+	}
+
+	file = anon_inode_getfile("[vtpms]", &vtpm_fops, vtpm_dev, O_RDWR);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+		goto err_put_unused_fd;
+	}
+
+	spin_lock(&driver_lock);
+	list_add_rcu(&vtpm_dev->list, &vtpm_list);
+	spin_unlock(&driver_lock);
+
+	/* from now on we can unwind with put_unused_fd() + fput() */
+	/* simulate an open() on the server side */
+	vtpm_fops_open(file);
+
+	chip = tpmm_chip_alloc(&vtpm_dev->dev, &vtpm_tpm_ops);
+	if (IS_ERR(chip)) {
+		rc = PTR_ERR(chip);
+		goto err_vtpm_fput;
+	}
+
+	chip->priv = vtpm_dev;
+
+	if (vtpm_dev->flags & VTPM_FLAG_TPM2)
+		chip->flags |= TPM_CHIP_FLAG_TPM2;
+
+	rc = tpm_chip_register(chip);
+	if (rc) {
+		tpm_chip_free(chip);
+		goto err_vtpm_fput;
+	}
+	vtpm_dev->chip = chip;
+
+	vtpm_new_pair->fd = fd;
+	vtpm_new_pair->major = MAJOR(vtpm_dev->chip->dev.devt);
+	vtpm_new_pair->minor = MINOR(vtpm_dev->chip->dev.devt);
+	vtpm_new_pair->tpm_dev_num = vtpm_dev->chip->dev_num;
+
+	return file;
+
+err_vtpm_fput:
+	put_unused_fd(fd);
+	fput(file);
+
+	return ERR_PTR(rc);
+
+err_put_unused_fd:
+	put_unused_fd(fd);
+
+err_delete_vtpm_dev:
+	vtpm_delete_vtpm_dev(vtpm_dev);
+
+	return ERR_PTR(rc);
+}
+
+/*
+ * Counter part to vtpm_create_device_pair.
+ */
+static void vtpm_delete_device_pair(struct vtpm_dev *vtpm_dev)
+{
+	spin_lock(&driver_lock);
+	list_del_rcu(&vtpm_dev->list);
+	spin_unlock(&driver_lock);
+
+	synchronize_rcu();
+
+	if (vtpm_dev->chip)
+		tpm_chip_unregister(vtpm_dev->chip);
+
+	vtpm_fops_undo_open(vtpm_dev);
+
+	vtpm_delete_vtpm_dev(vtpm_dev);
+}
+
+/*
+ * Code related to the control device /dev/vtpmx
+ */
+
+/*
+ * vtpmx_fops_ioctl: ioctl on /dev/vtpmx
+ *
+ * Return value:
+ *      Returns 0 on success, a negative error code otherwise.
+ */
+static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
+			    unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct vtpm_new_pair *vtpm_new_pair_p;
+	struct vtpm_new_pair vtpm_new_pair;
+	struct file *file;
+
+	switch (ioctl) {
+	case VTPM_NEW_DEV:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		vtpm_new_pair_p = argp;
+		if (copy_from_user(&vtpm_new_pair, vtpm_new_pair_p,
+				   sizeof(vtpm_new_pair)))
+			return -EFAULT;
+		file = vtpm_create_device_pair(&vtpm_new_pair);
+		if (IS_ERR(file))
+			return PTR_ERR(file);
+		if (copy_to_user(vtpm_new_pair_p, &vtpm_new_pair,
+				 sizeof(vtpm_new_pair))) {
+			put_unused_fd(vtpm_new_pair.fd);
+			fput(file);
+			return -EFAULT;
+		}
+
+		fd_install(vtpm_new_pair.fd, file);
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+static long vtpmx_fops_compat_ioctl(struct file *f, unsigned int ioctl,
+				    unsigned long arg)
+{
+	return vtpmx_fops_ioctl(f, ioctl, (unsigned long)compat_ptr(arg));
+}
+#endif
+
+static const struct file_operations vtpmx_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = vtpmx_fops_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = vtpmx_fops_compat_ioctl,
+#endif
+	.llseek = noop_llseek,
+};
+
+static struct miscdevice vtpmx_miscdev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "vtpmx",
+	.fops = &vtpmx_fops,
+};
+
+static int vtpmx_init(void)
+{
+	return misc_register(&vtpmx_miscdev);
+}
+
+static void vtpmx_cleanup(void)
+{
+	misc_deregister(&vtpmx_miscdev);
+}
+
+static int __init vtpm_module_init(void)
+{
+	int rc;
+
+	vtpm_class = class_create(THIS_MODULE, "vtpm");
+	if (IS_ERR(vtpm_class)) {
+		pr_err("couldn't create vtpm class\n");
+		return PTR_ERR(vtpm_class);
+	}
+
+	rc = vtpmx_init();
+	if (rc) {
+		pr_err("couldn't create vtpmx device\n");
+		goto err_vtpmx;
+	}
+
+	return 0;
+
+err_vtpmx:
+	class_destroy(vtpm_class);
+
+	return rc;
+}
+
+static void __exit vtpm_module_exit(void)
+{
+	vtpmx_cleanup();
+	class_destroy(vtpm_class);
+}
+
+module_init(vtpm_module_init);
+module_exit(vtpm_module_exit);
+
+MODULE_AUTHOR("Stefan Berger (stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)");
+MODULE_DESCRIPTION("vTPM Driver");
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 440a167..2fb59f8 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -197,6 +197,8 @@ struct tpm_chip {
 #endif /* CONFIG_ACPI */
 
 	struct list_head list;
+
+	void *priv;
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index c2e5d6c..c194d61 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -449,6 +449,7 @@ header-y += virtio_scsi.h
 header-y += virtio_types.h
 header-y += vm_sockets.h
 header-y += vt.h
+header-y += vtpm.h
 header-y += wait.h
 header-y += wanrouter.h
 header-y += watchdog.h
diff --git a/include/uapi/linux/vtpm.h b/include/uapi/linux/vtpm.h
new file mode 100644
index 0000000..aef8733
--- /dev/null
+++ b/include/uapi/linux/vtpm.h
@@ -0,0 +1,38 @@
+/*
+ * Definitions for the VTPM interface
+ * Copyright (c) 2015, 2016, IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef _UAPI_LINUX_VTPM_H
+#define _UAPI_LINUX_VTPM_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/* ioctls */
+
+struct vtpm_new_pair {
+	__u32 flags;         /* input */
+	__u32 tpm_dev_num;   /* output */
+	__u32 fd;            /* output */
+	__u32 major;         /* output */
+	__u32 minor;         /* output */
+};
+
+/* above flags */
+#define VTPM_FLAG_TPM2           1  /* emulator is TPM 2 */
+
+#define VTPM_TPM 0xa0
+
+#define VTPM_NEW_DEV         _IOW(VTPM_TPM, 0x00, struct vtpm_new_pair)
+
+#endif /* _UAPI_LINUX_VTPM_H */
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
