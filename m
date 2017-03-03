From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 6/7] tpm: expose spaces via a device link
	/dev/tpmrm<n>
Date: Fri,  3 Mar 2017 17:19:07 +0200
Message-ID: <20170303151912.14752-7-jarkko.sakkinen@linux.intel.com>
References: <20170303151912.14752-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170303151912.14752-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Currently the tpm spaces are not exposed to userspace.  Make this
exposure via a separate device, which can now be opened multiple times
because each read/write transaction goes separately via the space.

Concurrency is protected by the chip->tpm_mutex for each read/write
transaction separately.  The TPM is cleared of all transient objects
by the time the mutex is dropped, so there should be no interference
between the kernel and userspace.

Signed-off-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/Makefile        |  3 +-
 drivers/char/tpm/tpm-chip.c      | 58 ++++++++++++++++++++++++++++++++++-
 drivers/char/tpm/tpm-interface.c | 13 ++++++--
 drivers/char/tpm/tpm.h           |  4 +++
 drivers/char/tpm/tpmrm-dev.c     | 65 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 139 insertions(+), 4 deletions(-)
 create mode 100644 drivers/char/tpm/tpmrm-dev.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 10e5827..23681f0 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -3,7 +3,8 @@
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
-	 tpm-dev-common.o tpm1_eventlog.o tpm2_eventlog.o tpm2-space.o
+	 tpm-dev-common.o tpmrm-dev.o tpm1_eventlog.o tpm2_eventlog.o \
+         tpm2-space.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
 tpm-$(CONFIG_OF) += tpm_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 364d92e..3db38f9 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -33,6 +33,7 @@ DEFINE_IDR(dev_nums_idr);
 static DEFINE_MUTEX(idr_lock);
 
 struct class *tpm_class;
+struct class *tpmrm_class;
 dev_t tpm_devt;
 
 /**
@@ -132,6 +133,14 @@ static void tpm_dev_release(struct device *dev)
 	kfree(chip);
 }
 
+static void tpm_devs_release(struct device *dev)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
+
+	/* release the master device reference */
+	put_device(&chip->dev);
+}
+
 /**
  * tpm_chip_alloc() - allocate a new struct tpm_chip instance
  * @pdev: device to which the chip is associated
@@ -168,27 +177,47 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->dev_num = rc;
 
 	device_initialize(&chip->dev);
+	device_initialize(&chip->devs);
 
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
 
+	chip->devs.parent = pdev;
+	chip->devs.class = tpmrm_class;
+	chip->devs.release = tpm_devs_release;
+	/* get extra reference on main device to hold on
+	 * behalf of devs.  This holds the chip structure
+	 * while cdevs is in use.  The corresponding put
+	 * is in the tpm_devs_release
+	 */
+	get_device(&chip->dev);
+
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
+	chip->devs.devt =
+		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
+
 	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
 	if (rc)
 		goto out;
+	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
+	if (rc)
+		goto out;
 
 	if (!pdev)
 		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
 
 	cdev_init(&chip->cdev, &tpm_fops);
+	cdev_init(&chip->cdevs, &tpmrm_fops);
 	chip->cdev.owner = THIS_MODULE;
+	chip->cdevs.owner = THIS_MODULE;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
+	chip->cdevs.kobj.parent = &chip->devs.kobj;
 
 	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!chip->work_space.context_buf) {
@@ -199,6 +228,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	return chip;
 
 out:
+	put_device(&chip->devs);
 	put_device(&chip->dev);
 	return ERR_PTR(rc);
 }
@@ -263,7 +293,6 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
 			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
-
 		return rc;
 	}
 
@@ -277,6 +306,29 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 		return rc;
 	}
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = cdev_add(&chip->cdevs, chip->devs.devt, 1);
+	if (rc) {
+		dev_err(&chip->dev,
+			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
+			dev_name(&chip->devs), MAJOR(chip->devs.devt),
+			MINOR(chip->devs.devt), rc);
+		tpm_del_char_device(chip, true);
+		return rc;
+	}
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = device_add(&chip->devs);
+	if (rc) {
+		dev_err(&chip->dev,
+			"unable to device_register() %s, major %d, minor %d, err=%d\n",
+			dev_name(&chip->devs), MAJOR(chip->devs.devt),
+			MINOR(chip->devs.devt), rc);
+		cdev_del(&chip->cdevs);
+		tpm_del_char_device(chip, true);
+		return rc;
+	}
+
 	/* Make the chip available. */
 	mutex_lock(&idr_lock);
 	idr_replace(&dev_nums_idr, chip, chip->dev_num);
@@ -392,6 +444,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 {
 	tpm_del_legacy_sysfs(chip);
 	tpm_bios_log_teardown(chip);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		cdev_del(&chip->cdevs);
+		device_del(&chip->devs);
+	}
 	tpm_del_char_device(chip, true);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_unregister);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index db5ffe9..e38c792 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1257,9 +1257,17 @@ static int __init tpm_init(void)
 		return PTR_ERR(tpm_class);
 	}
 
-	rc = alloc_chrdev_region(&tpm_devt, 0, TPM_NUM_DEVICES, "tpm");
+	tpmrm_class = class_create(THIS_MODULE, "tpmrm");
+	if (IS_ERR(tpmrm_class)) {
+		pr_err("couldn't create tpmrm class\n");
+		class_destroy(tpm_class);
+		return PTR_ERR(tpmrm_class);
+	}
+
+	rc = alloc_chrdev_region(&tpm_devt, 0, 2*TPM_NUM_DEVICES, "tpm");
 	if (rc < 0) {
 		pr_err("tpm: failed to allocate char dev region\n");
+		class_destroy(tpmrm_class);
 		class_destroy(tpm_class);
 		return rc;
 	}
@@ -1271,7 +1279,8 @@ static void __exit tpm_exit(void)
 {
 	idr_destroy(&dev_nums_idr);
 	class_destroy(tpm_class);
-	unregister_chrdev_region(tpm_devt, TPM_NUM_DEVICES);
+	class_destroy(tpmrm_class);
+	unregister_chrdev_region(tpm_devt, 2*TPM_NUM_DEVICES);
 }
 
 subsys_initcall(tpm_init);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 023fc02..16dd207 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -182,7 +182,9 @@ struct tpm_chip_seqops {
 
 struct tpm_chip {
 	struct device dev;
+	struct device devs;
 	struct cdev cdev;
+	struct cdev cdevs;
 
 	/* A driver callback under ops cannot be run unless ops_sem is held
 	 * (sometimes implicitly, eg for the sysfs code). ops becomes null
@@ -510,8 +512,10 @@ static inline void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value)
 }
 
 extern struct class *tpm_class;
+extern struct class *tpmrm_class;
 extern dev_t tpm_devt;
 extern const struct file_operations tpm_fops;
+extern const struct file_operations tpmrm_fops;
 extern struct idr dev_nums_idr;
 
 enum tpm_transmit_flags {
diff --git a/drivers/char/tpm/tpmrm-dev.c b/drivers/char/tpm/tpmrm-dev.c
new file mode 100644
index 0000000..630bddc
--- /dev/null
+++ b/drivers/char/tpm/tpmrm-dev.c
@@ -0,0 +1,65 @@
+/*
+ * Copyright (C) 2017 James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
+ *
+ * GPLv2
+ */
+#include <linux/slab.h>
+#include "tpm-dev.h"
+
+struct tpmrm_priv {
+	struct file_priv priv;
+	struct tpm_space space;
+};
+
+static int tpmrm_open(struct inode *inode, struct file *file)
+{
+	struct tpm_chip *chip;
+	struct tpmrm_priv *priv;
+	int rc;
+
+	chip = container_of(inode->i_cdev, struct tpm_chip, cdevs);
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL)
+		return -ENOMEM;
+
+	rc = tpm2_init_space(&priv->space);
+	if (rc) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+
+	tpm_common_open(file, chip, &priv->priv);
+
+	return 0;
+}
+
+static int tpmrm_release(struct inode *inode, struct file *file)
+{
+	struct file_priv *fpriv = file->private_data;
+	struct tpmrm_priv *priv = container_of(fpriv, struct tpmrm_priv, priv);
+
+	tpm_common_release(file, fpriv);
+	tpm2_del_space(&priv->space);
+	kfree(priv);
+
+	return 0;
+}
+
+ssize_t tpmrm_write(struct file *file, const char __user *buf,
+		   size_t size, loff_t *off)
+{
+	struct file_priv *fpriv = file->private_data;
+	struct tpmrm_priv *priv = container_of(fpriv, struct tpmrm_priv, priv);
+
+	return tpm_common_write(file, buf, size, off, &priv->space);
+}
+
+const struct file_operations tpmrm_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = tpmrm_open,
+	.read = tpm_common_read,
+	.write = tpmrm_write,
+	.release = tpmrm_release,
+};
+
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
