From: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 3/4] Implement driver for supporting
	multiple emulated TPMs
Date: Thu, 14 Jan 2016 11:01:57 -0500
Message-ID: <1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
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

This patch implements a driver for supporting multiple emulated TPMs in a
system. An emulated TPM can for example be used by a Linux container or
later on by namespace-enabled IMA running inside a container.

The driver implements a device /dev/vtpmx that is only used to created
device pairs /dev/vtpmcX (e.g., /dev/vtpmc10) and /dev/vtpmsY
(e.g., /dev/vtpms11) using ioctls. The device /dev/vtpmcX is the usual TPM
device created by the core TPM driver. Applications or kernel subsystems
can send TPM commands to it and the corresponding /dev/vtpmY receives these
commands and delivers them to an emulated TPM. The device /dev/vtpmcX can
be moved into a container and appear there as /dev/tpm0.

Life-cycle management is implemented by ioctls of /dev/vtpmx for creating and
destroying them. The ioctl for creating a device pair returns the names of the
created devices so that applications know which devices to use. Other ioctls
help to find the corresponding 'other' device given the device name of one.

Signed-off-by; Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Kconfig    |  10 +
 drivers/char/tpm/Makefile   |   1 +
 drivers/char/tpm/tpm-vtpm.c | 855 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-vtpm.h |  58 +++
 include/uapi/linux/Kbuild   |   1 +
 include/uapi/linux/vtpm.h   |  52 +++
 6 files changed, 977 insertions(+)
 create mode 100644 drivers/char/tpm/tpm-vtpm.c
 create mode 100644 drivers/char/tpm/tpm-vtpm.h
 create mode 100644 include/uapi/linux/vtpm.h

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 3b84a8b..d38b169 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -122,5 +122,15 @@ config TCG_CRB
 	  from within Linux.  To compile this driver as a module, choose
 	  M here; the module will be called tpm_crb.
 
+config TCG_VTPM
+	tristate "VTPM Interface"
+	depends on TCG_TPM
+	---help---
+	  This driver supports a vTPM running in userspace that receives
+	  request from /dev/vtpmsX. The requests are sent through a
+	  corrsponding /dev/tpmcY. The /dev/vtpmsX and /dev/tpmcY pair
+	  can be created dyanmically through ioctls of /dev/vtpmx.
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
index 0000000..dc6f7f6
--- /dev/null
+++ b/drivers/char/tpm/tpm-vtpm.c
@@ -0,0 +1,855 @@
+/*
+ * Copyright (C) 2015 IBM Corporation
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
+#include <linux/poll.h>
+#include <asm/compat.h>
+
+#include "tpm-vtpm.h"
+
+static DECLARE_BITMAP(dev_mask, VTPM_NUM_DEVICES);
+static LIST_HEAD(vtpm_list);
+static DEFINE_SPINLOCK(driver_lock);
+
+static struct class *vtpm_class;
+static dev_t vtpm_devt;
+
+static int _vtpm_delete_device_pair(struct vtpm_dev *vtpm_dev);
+static void free_vtpm_dev(struct kref *kref);
+
+static void vtpm_dev_get(struct vtpm_dev *vtpm_dev)
+{
+	kref_get(&vtpm_dev->kref);
+}
+
+static void vtpm_dev_put(struct vtpm_dev *vtpm_dev)
+{
+	if (vtpm_dev)
+		kref_put(&vtpm_dev->kref, free_vtpm_dev);
+}
+
+static struct vtpm_dev *vtpm_dev_get_by_chip(struct tpm_chip *chip)
+{
+	struct vtpm_dev *pos, *vtpm_dev = NULL;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pos, &vtpm_list, list) {
+		if (pos->chip == chip) {
+			vtpm_dev = pos;
+			vtpm_dev_get(vtpm_dev);
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+
+	return vtpm_dev;
+}
+
+static struct vtpm_dev *vtpm_dev_get_by_vtpm_devnum(u32 dev_num)
+{
+	struct vtpm_dev *pos, *vtpm_dev = NULL;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pos, &vtpm_list, list) {
+		if (pos->dev_num == dev_num) {
+			vtpm_dev = pos;
+			vtpm_dev_get(vtpm_dev);
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+
+	return vtpm_dev;
+}
+
+static struct vtpm_dev *vtpm_dev_get_by_tpm_devnum(u32 dev_num)
+{
+	struct vtpm_dev *pos, *vtpm_dev = NULL;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pos, &vtpm_list, list) {
+		if (pos->chip->dev_num == dev_num) {
+			vtpm_dev = pos;
+			vtpm_dev_get(vtpm_dev);
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+
+	return vtpm_dev;
+}
+
+/*
+ * Functions related to /dev/vtpms%d
+ */
+
+/**
+ * vtpm_fops_read - Read TPM commands from /dev/vtpms%d
+ *
+ * Return value:
+ *	Number of bytes read or negative error code
+ */
+static ssize_t vtpm_fops_read(struct file *filp, char __user *buf,
+			      size_t count, loff_t *off)
+{
+	struct file_priv *priv = filp->private_data;
+	struct vtpm_dev *vtpm_dev = priv->vtpm_dev;
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
+ * vtpm_fops_write - Write TPM responses to /dev/vtpms%d
+ *
+ * Return value:
+ *	Number of bytes read or negative error value
+ */
+static ssize_t vtpm_fops_write(struct file *filp, const char __user *buf,
+			       size_t count, loff_t *off)
+{
+	struct file_priv *priv = filp->private_data;
+	struct vtpm_dev *vtpm_dev = priv->vtpm_dev;
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
+ * vtpm_fops_poll: Poll status of /dev/vtpms%d
+ *
+ * Return value:
+ *      Poll flags
+ */
+static unsigned int vtpm_fops_poll(struct file *filp, poll_table *wait)
+{
+	struct file_priv *priv = filp->private_data;
+	struct vtpm_dev *vtpm_dev = priv->vtpm_dev;
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
+/**
+ * vtpm_fops_open - Open vTPM device /dev/vtpms%d
+ *
+ * Return value:
+ *	0 on success, error code otherwise
+ */
+static int vtpm_fops_open(struct inode *inode, struct file *filp)
+{
+	struct vtpm_dev *vtpm_dev =
+		container_of(inode->i_cdev, struct vtpm_dev, cdev);
+	struct file_priv *priv;
+
+	if (test_and_set_bit(STATE_OPENED_BIT, &vtpm_dev->state)) {
+		dev_dbg(vtpm_dev->pdev,
+		        "Another process owns this vTPM device\n");
+		return -EBUSY;
+	}
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL) {
+		clear_bit(STATE_OPENED_BIT, &vtpm_dev->state);
+		return -ENOMEM;
+	}
+
+	priv->vtpm_dev = vtpm_dev;
+
+	get_device(vtpm_dev->pdev);
+
+	filp->private_data = priv;
+
+	return 0;
+}
+
+/*
+ * vtpm_fops_release: Close /dev/vtpms%d
+ *
+ * If device pair is not in use anymore and flags permit, delete
+ * the device pair.
+ *
+ * Return value:
+ *      Always returns 0.
+ */
+static int vtpm_fops_release(struct inode *inode, struct file *filp)
+{
+	struct file_priv *priv = filp->private_data;
+	struct vtpm_dev *vtpm_dev = priv->vtpm_dev;
+
+	filp->private_data = NULL;
+	put_device(vtpm_dev->pdev);
+	kfree(priv);
+
+	if (!(vtpm_dev->flags & VTPM_FLAG_KEEP_DEVPAIR)) {
+		/*
+		 * device still marked as open; this prevents others from
+		 * opening it while we try to delete it
+		 */
+		if (_vtpm_delete_device_pair(vtpm_dev) == 0) {
+			/* vtpm_dev gone */
+			return 0;
+		}
+	}
+
+	clear_bit(STATE_OPENED_BIT, &vtpm_dev->state);
+	/* won't generate reponses anymore */
+	wake_up_interruptible(&vtpm_dev->wq);
+
+	return 0;
+}
+
+static const struct file_operations vtpm_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = vtpm_fops_open,
+	.read = vtpm_fops_read,
+	.write = vtpm_fops_write,
+	.poll = vtpm_fops_poll,
+	.release = vtpm_fops_release,
+};
+
+/*
+ * Functions invoked by the core TPM driver to send TPM commands to
+ * /dev/vtpms%d and receive responses from there.
+ */
+
+/*
+ * Called when core TPM driver reads TPM responses from /dev/vtpms%d.
+ *
+ * Return value:
+ *      Number of TPM response bytes read, negative error value otherwise
+ */
+static int vtpm_tpm_op_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct vtpm_dev *vtpm_dev = vtpm_dev_get_by_chip(chip);
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
+	if (sig) {
+		len = -EINTR;
+		goto err_exit;
+	}
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
+		len = -EIO;
+		goto err_exit;
+	}
+
+	spin_lock(&vtpm_dev->buf_lock);
+
+	memcpy(buf, vtpm_dev->resp_buf, len);
+	vtpm_dev->resp_len = 0;
+
+	spin_unlock(&vtpm_dev->buf_lock);
+
+err_exit:
+	vtpm_dev_put(vtpm_dev);
+
+	return len;
+}
+
+/*
+ * Called when core TPM driver forwards TPM requests to /dev/vtpms%d.
+ *
+ * Return value:
+ *      0 in case of success, negative error value otherwise.
+ */
+static int vtpm_tpm_op_send(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct vtpm_dev *vtpm_dev = vtpm_dev_get_by_chip(chip);
+	int rc = 0;
+
+	if (!vtpm_dev)
+		return -EIO;
+
+	if (!test_bit(STATE_OPENED_BIT, &vtpm_dev->state)) {
+		rc = -EINVAL;
+		goto err_exit;
+	}
+
+	if (count > sizeof(vtpm_dev->req_buf)) {
+		dev_err(&vtpm_dev->dev,
+			"Invalid size in send: count=%zd, buffer size=%zd\n",
+			count, sizeof(vtpm_dev->req_buf));
+		rc = -EIO;
+		goto err_exit;
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
+err_exit:
+	vtpm_dev_put(vtpm_dev);
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
+
+static void vtpm_dev_release(struct device *dev)
+{
+	struct vtpm_dev *vtpm_dev = container_of(dev, struct vtpm_dev, dev);
+
+	vtpm_dev_put(vtpm_dev);
+}
+
+static void free_vtpm_dev(struct kref *kref)
+{
+	struct vtpm_dev *vtpm_dev = container_of(kref, struct vtpm_dev, kref);
+
+	spin_lock(&driver_lock);
+	clear_bit(vtpm_dev->dev_num, dev_mask);
+	spin_unlock(&driver_lock);
+
+	kfree(vtpm_dev);
+}
+
+struct vtpm_dev *vtpm_create_vtpm_dev(struct platform_device **ppdev)
+{
+	struct vtpm_dev *vtpm_dev;
+	struct platform_device *pdev;
+	struct device *dev;
+
+	vtpm_dev = kzalloc(sizeof(*vtpm_dev), GFP_KERNEL);
+	if (vtpm_dev == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&vtpm_dev->kref);
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
+	pdev = platform_device_register_simple("tpm_vtpm", vtpm_dev->dev_num,
+					       NULL, 0);
+	if (IS_ERR(pdev)) {
+		spin_unlock(&driver_lock);
+		kfree(vtpm_dev);
+		return ERR_PTR(PTR_ERR(pdev));
+	}
+	*ppdev = pdev;
+
+	set_bit(vtpm_dev->dev_num, dev_mask);
+	spin_unlock(&driver_lock);
+
+	dev = &pdev->dev;
+
+	scnprintf(vtpm_dev->devname, sizeof(vtpm_dev->devname),
+		  VTPM_DEV_PREFIX_SERVER"%d", vtpm_dev->dev_num);
+
+	vtpm_dev->pdev = dev;
+
+	dev_set_drvdata(dev, vtpm_dev);
+
+	vtpm_dev->dev.class = vtpm_class;
+	vtpm_dev->dev.release = vtpm_dev_release;
+	vtpm_dev->dev.parent = vtpm_dev->pdev;
+
+	vtpm_dev->dev.devt = MKDEV(MAJOR(vtpm_devt),vtpm_dev->dev_num);
+
+	dev_set_name(&vtpm_dev->dev, "%s", vtpm_dev->devname);
+
+	device_initialize(&vtpm_dev->dev);
+
+	cdev_init(&vtpm_dev->cdev, &vtpm_fops);
+	vtpm_dev->cdev.owner = vtpm_dev->pdev->driver->owner;
+	vtpm_dev->cdev.kobj.parent = &vtpm_dev->dev.kobj;
+
+	return vtpm_dev;
+}
+
+/*
+ * Create a /dev/vtpms%d and /dev/vtpms%d device pair.
+ *
+ * Return value:
+ *      Returns vtpm_dev pointer on success, an error value otherwise
+ */
+static struct vtpm_dev *vtpm_create_device_pair(
+                                       struct vtpm_new_pair *vtpm_new_pair)
+{
+	struct vtpm_dev *vtpm_dev;
+	struct platform_device *pdev = NULL;
+	int rc;
+
+	vtpm_dev = vtpm_create_vtpm_dev(&pdev);
+	if (IS_ERR(vtpm_dev))
+		return vtpm_dev;
+
+	vtpm_dev->flags = vtpm_new_pair->flags;
+
+	rc = device_add(&vtpm_dev->dev);
+	if (rc) {
+		kfree(vtpm_dev);
+		vtpm_dev = NULL;
+		goto err_device_add;
+	}
+
+	rc = cdev_add(&vtpm_dev->cdev, vtpm_dev->dev.devt, 1);
+	if (rc)
+		goto err_cdev_add;
+
+	vtpm_dev->chip = tpmm_chip_alloc_pattern(vtpm_dev->pdev,
+				&vtpm_tpm_ops,
+				VTPM_DEV_PREFIX_CLIENT"%d");
+	if (IS_ERR(vtpm_dev->chip)) {
+		rc = PTR_ERR(vtpm_dev->chip);
+		goto err_chip_alloc;
+	}
+
+	if (vtpm_dev->flags & VTPM_FLAG_TPM2)
+		vtpm_dev->chip->flags |= TPM_CHIP_FLAG_TPM2;
+
+	vtpm_dev->chip->flags |= TPM_CHIP_FLAG_NO_SYSFS | TPM_CHIP_FLAG_NO_LOG;
+
+	rc = tpm_chip_register(vtpm_dev->chip);
+	if (rc)
+		goto err_chip_register;
+
+	spin_lock(&driver_lock);
+	list_add_rcu(&vtpm_dev->list, &vtpm_list);
+	spin_unlock(&driver_lock);
+
+	vtpm_new_pair->tpm_dev_num = vtpm_dev->chip->dev_num;
+	vtpm_new_pair->vtpm_dev_num = vtpm_dev->dev_num;
+
+	return vtpm_dev;
+
+err_chip_register:
+err_chip_alloc:
+	cdev_del(&vtpm_dev->cdev);
+
+err_cdev_add:
+	device_unregister(&vtpm_dev->dev);
+
+err_device_add:
+	platform_device_unregister(pdev);
+
+	return ERR_PTR(rc);
+}
+
+/*
+ * Delete a /dev/vtpmc%d and /dev/vtpms%d device pair without checking
+ * whether it is still in use.
+ */
+static int _vtpm_delete_device_pair(struct vtpm_dev *vtpm_dev)
+{
+	struct device *dev = vtpm_dev->pdev;
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+
+	tpm_chip_unregister(vtpm_dev->chip);
+
+	cdev_del(&vtpm_dev->cdev);
+	device_unregister(&vtpm_dev->dev);
+
+	platform_device_unregister(pdev);
+
+	spin_lock(&driver_lock);
+	list_del_rcu(&vtpm_dev->list);
+	spin_unlock(&driver_lock);
+
+	return 0;
+}
+
+/*
+ * Delete a /dev/vtpmc%d and /dev/vtpms%d device pair.
+ *
+ * Return value:
+ *      Returns 0 on success, -EBUSY of the device pair is still in use
+ */
+static int vtpm_delete_device_pair(struct vtpm_dev *vtpm_dev)
+{
+	if (test_bit(STATE_OPENED_BIT, &vtpm_dev->state)) {
+		dev_dbg(vtpm_dev->pdev, "Device is busy\n");
+		return -EBUSY;
+	}
+
+	return _vtpm_delete_device_pair(vtpm_dev);
+}
+
+/*
+ * Delete all /dev/tpm%d and /dev/vtpm%d device pairs.
+ * This function is only to be called when the module is removed and
+ * we are sure that there are no more users of any device.
+ */
+static int vtpm_delete_device_pairs(void)
+{
+	struct vtpm_dev *vtpm_dev;
+	int rc = 0;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(vtpm_dev, &vtpm_list, list) {
+		rc = vtpm_delete_device_pair(vtpm_dev);
+		if (rc)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	return rc;
+}
+
+static int vtpm_probe(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver vtpm_drv = {
+	.probe = vtpm_probe,
+	.driver = {
+		.name = "tpm_vtpm",
+	},
+};
+
+static int vtpm_init(void)
+{
+	return platform_driver_register(&vtpm_drv);
+}
+
+/*
+ * Called for module removal; no more module users
+ */
+static void vtpm_cleanup(void)
+{
+	vtpm_delete_device_pairs();
+	platform_driver_unregister(&vtpm_drv);
+}
+
+/*
+ * Code related to /dev/vtpmx
+ */
+
+struct vtpmx_dev {
+	struct device dev;
+	struct device *pdev;
+	struct cdev cdev;
+};
+
+/*
+ * vtpmx_fops_ioctl: ioctl on /dev/vtpmx
+ *
+ * Return value:
+ *      Returns 0 on success, -EINVAL or -EFAULT otherwise.
+ */
+static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
+			    unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct vtpm_new_pair *vtpm_new_pair_p;
+	struct vtpm_new_pair vtpm_new_pair;
+	struct vtpm_pair *vtpm_pair_p;
+	struct vtpm_pair vtpm_pair;
+	struct vtpm_dev *vtpm_dev;
+	int rc = 0;
+
+	switch (ioctl) {
+	case VTPM_NEW_DEV:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		vtpm_new_pair_p = argp;
+		if (copy_from_user(&vtpm_new_pair, vtpm_new_pair_p,
+				   sizeof(vtpm_new_pair)))
+			return -EFAULT;
+		vtpm_dev = vtpm_create_device_pair(&vtpm_new_pair);
+		if (IS_ERR(vtpm_dev))
+			return PTR_ERR(vtpm_dev);
+		if (copy_to_user(vtpm_new_pair_p, &vtpm_new_pair,
+				 sizeof(vtpm_new_pair)))
+			return -EFAULT;
+		return 0;
+
+	case VTPM_DEL_DEV:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		vtpm_pair_p = argp;
+		if (copy_from_user(&vtpm_pair, vtpm_pair_p, sizeof(vtpm_pair)))
+			return -EFAULT;
+
+		if (vtpm_pair.tpm_dev_num != VTPM_DEV_NUM_INVALID) {
+			vtpm_dev =
+			    vtpm_dev_get_by_tpm_devnum(vtpm_pair.tpm_dev_num);
+			if (!vtpm_dev || vtpm_delete_device_pair(vtpm_dev) < 0)
+				rc = -EINVAL;
+			vtpm_dev_put(vtpm_dev);
+			return rc;
+		}
+
+		if (vtpm_pair.vtpm_dev_num != VTPM_DEV_NUM_INVALID) {
+			vtpm_dev =
+			    vtpm_dev_get_by_vtpm_devnum(vtpm_pair.vtpm_dev_num);
+			if (!vtpm_dev || vtpm_delete_device_pair(vtpm_dev) < 0)
+				rc = -EINVAL;
+			vtpm_dev_put(vtpm_dev);
+			return rc;
+		}
+		return -EINVAL;
+
+	case VTPM_GET_VTPMDEV:
+		vtpm_pair_p = argp;
+		if (copy_from_user(&vtpm_pair, vtpm_pair_p, sizeof(vtpm_pair)))
+			return -EFAULT;
+
+		if (vtpm_pair.tpm_dev_num != VTPM_DEV_NUM_INVALID) {
+			vtpm_dev =
+			    vtpm_dev_get_by_tpm_devnum(vtpm_pair.tpm_dev_num);
+			if (!vtpm_dev)
+				return -EINVAL;
+
+			vtpm_pair.vtpm_dev_num = vtpm_dev->dev_num;
+
+			if (copy_to_user(vtpm_pair_p, &vtpm_pair,
+					 sizeof(vtpm_pair)))
+				rc = -EFAULT;
+			vtpm_dev_put(vtpm_dev);
+			return rc;
+		}
+		return -EINVAL;
+
+	case VTPM_GET_TPMDEV:
+		vtpm_pair_p = argp;
+		if (copy_from_user(&vtpm_pair, vtpm_pair_p, sizeof(vtpm_pair)))
+			return -EFAULT;
+
+		if (vtpm_pair.vtpm_dev_num != VTPM_DEV_NUM_INVALID) {
+			vtpm_dev =
+			    vtpm_dev_get_by_vtpm_devnum(vtpm_pair.vtpm_dev_num);
+			if (!vtpm_dev)
+				return -EINVAL;
+
+			vtpm_pair.tpm_dev_num = vtpm_dev->chip->dev_num;
+
+			if (copy_to_user(vtpm_pair_p, &vtpm_pair,
+					 sizeof(vtpm_pair)))
+				rc = -EFAULT;
+			vtpm_dev_put(vtpm_dev);
+			return rc;
+		}
+		return -EINVAL;
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
+	rc = alloc_chrdev_region(&vtpm_devt, 0, VTPM_NUM_DEVICES, "vtpm");
+	if (rc < 0) {
+		pr_err("failed to allocate char dev region\n");
+		goto err_alloc_reg;
+	}
+
+	rc = vtpmx_init();
+	if (rc) {
+		pr_err("couldn't create vtpmx device\n");
+		goto err_vtpmx;
+	}
+
+	rc = vtpm_init();
+	if (rc) {
+		pr_err("couldn't init vtpm layer\n");
+		goto err_vtpm;
+	}
+
+	return 0;
+
+err_vtpm:
+	vtpmx_cleanup();
+
+err_vtpmx:
+	unregister_chrdev_region(vtpm_devt, VTPM_NUM_DEVICES);
+
+err_alloc_reg:
+	class_destroy(vtpm_class);
+
+	return rc;
+}
+
+static void __exit vtpm_module_exit(void)
+{
+	vtpm_cleanup();
+	vtpmx_cleanup();
+	unregister_chrdev_region(vtpm_devt, VTPM_NUM_DEVICES);
+	class_destroy(vtpm_class);
+}
+
+subsys_initcall(vtpm_module_init);
+module_exit(vtpm_module_exit);
+
+MODULE_AUTHOR("Stefan Berger (stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)");
+MODULE_DESCRIPTION("vTPM Driver");
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm-vtpm.h b/drivers/char/tpm/tpm-vtpm.h
new file mode 100644
index 0000000..8649867
--- /dev/null
+++ b/drivers/char/tpm/tpm-vtpm.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2015 IBM Corporation
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
+#ifndef __TPM_VTPM_H
+#define __TPM_VTPM_H
+
+#include "tpm.h"
+
+#define VTPM_NUM_DEVICES TPM_NUM_DEVICES
+
+struct vtpm_dev {
+        struct kref kref;
+
+        struct device *pdev;
+        struct device dev;
+        struct cdev cdev;
+
+        struct tpm_chip *chip;
+
+        u32 flags;
+
+        int dev_num;
+        char devname[VTPM_DEVNAME_MAX];
+
+        long state;
+#define STATE_OPENED_BIT   0
+
+        spinlock_t buf_lock;         /* lock for buffers */
+
+        wait_queue_head_t wq;
+
+        size_t req_len;              /* length of queued TPM request */
+        u8 req_buf[TPM_BUFSIZE];     /* request buffer */
+
+        size_t resp_len;             /* length of queued TPM response */
+        u8 resp_buf[TPM_BUFSIZE];    /* request buffer */
+
+        struct list_head list;
+};
+
+struct file_priv {
+        struct vtpm_dev *vtpm_dev;
+};
+
+#endif
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
index 0000000..460282b
--- /dev/null
+++ b/include/uapi/linux/vtpm.h
@@ -0,0 +1,52 @@
+/*
+ * Definitions for the VTPM interface
+ * Copyright (c) 2015, IBM Corporation
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
+#define VTPM_TPM 0xa0
+
+#define VTPM_DEVNAME_MAX   16
+
+#define VTPM_DEV_PREFIX_SERVER "vtpms"  /* server-side device name prefix */
+#define VTPM_DEV_PREFIX_CLIENT "vtpmc"  /* client-side device name prefix */
+
+#define VTPM_DEV_NUM_INVALID  ~0
+
+struct vtpm_new_pair {
+        __u32 flags;         /* input */
+        __u32 tpm_dev_num;   /* output */
+        __u32 vtpm_dev_num;  /* output */
+};
+
+struct vtpm_pair {
+        __u32 tpm_dev_num;   /* input or output */
+        __u32 vtpm_dev_num;  /* input or output */
+};
+
+/* above flags */
+#define VTPM_FLAG_TPM2           1  /* choose a TPM2; mainly for sysfs entries */
+#define VTPM_FLAG_KEEP_DEVPAIR   2  /* keep the device pair once vTPM closes */
+
+/* create new TPM device pair */
+#define VTPM_NEW_DEV         _IOW(VTPM_TPM, 0x00, struct vtpm_new_pair)
+#define VTPM_DEL_DEV         _IOW(VTPM_TPM, 0x01, struct vtpm_pair)
+#define VTPM_GET_TPMDEV      _IOW(VTPM_TPM, 0x02, struct vtpm_pair)
+#define VTPM_GET_VTPMDEV     _IOW(VTPM_TPM, 0x03, struct vtpm_pair)
+
+#endif /* _UAPI_LINUX_VTPM_H */
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
