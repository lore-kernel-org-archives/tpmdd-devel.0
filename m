From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v3 5/5] tpm2: expose resource manager
 via    a device link /dev/tpms<n>
Date: Thu, 19 Jan 2017 07:19:40 -0500
Message-ID: <1484828380.3140.11.camel@HansenPartnership.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
         <20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
         <1484751663.2717.10.camel@HansenPartnership.com>
         <20170119104922.vhgz4rxw6yzdrxqt@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Wc1RXwIfrFIpUnWvd2CS"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170119104922.vhgz4rxw6yzdrxqt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net


--=-Wc1RXwIfrFIpUnWvd2CS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2017-01-19 at 12:49 +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 18, 2017 at 10:01:03AM -0500, James Bottomley wrote:
> > On Mon, 2017-01-16 at 15:12 +0200, Jarkko Sakkinen wrote:
> > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > 
> > > Currently the Resource Manager (RM) is not exposed to userspace. 
> > >  Make this exposure via a separate device, which can now be 
> > > opened multiple times because each read/write transaction goes 
> > > separately via the RM.
> > > 
> > > Concurrency is protected by the chip->tpm_mutex for each 
> > > read/write transaction separately.  The TPM is cleared of all 
> > > transient objects by the time the mutex is dropped, so there 
> > > should be no interference between the kernel and userspace.
> > 
> > There's actually a missing kfree of context_buf on the tpms_release
> > path as well.  This patch fixes it up.
> 
> Can you send me a fresh version of the whole patch so that I can 
> include to v4 that includes also changes that I requested in my 
> recent comments + all the fixes?

Sure, I think the attached is basically it

James

--=-Wc1RXwIfrFIpUnWvd2CS
Content-Type: application/mbox; name="tmp.mail"
Content-Description: 
Content-Disposition: inline; filename="tmp.mail"
Content-Transfer-Encoding: 7bit

>From 630fb927cbecf81e9861224396c927ab4963ba1e Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 3 Jan 2017 09:07:32 -0800
Subject: [PATCH] tpm2: expose spaces via a device link /dev/tpms<n>

Currently the tpm spaces are not exposed to userspace.  Make this
exposure via a separate device, which can now be opened multiple times
because each read/write transaction goes separately via the space.

Concurrency is protected by the chip->tpm_mutex for each read/write
transaction separately.  The TPM is cleared of all transient objects
by the time the mutex is dropped, so there should be no interference
between the kernel and userspace.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 13ff5da..e50d768 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -3,7 +3,7 @@
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
-	 tpm_eventlog.o tpm2-space.o tpm-dev-common.o
+	 tpm_eventlog.o tpm2-space.o tpm-dev-common.o tpms-dev.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
 tpm-$(CONFIG_OF) += tpm_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 993b9ae..ed4f887 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -33,6 +33,7 @@ DEFINE_IDR(dev_nums_idr);
 static DEFINE_MUTEX(idr_lock);
 
 struct class *tpm_class;
+struct class *tpms_class;
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
@@ -168,27 +177,46 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->dev_num = rc;
 
 	device_initialize(&chip->dev);
+	device_initialize(&chip->devs);
 
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
 
+	chip->devs.parent = pdev;
+	chip->devs.class = tpms_class;
+	chip->devs.release = tpm_devs_release;
+	/* get extra reference on main device to hold on
+	 * behalf of devs.  This holds the chip structure
+	 * while cdevs is in use.  The corresponding put
+	 * is in the tpm_devs_release */
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
+	rc = dev_set_name(&chip->devs, "tpms%d", chip->dev_num);
+	if (rc)
+		goto out;
 
 	if (!pdev)
 		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
 
 	cdev_init(&chip->cdev, &tpm_fops);
+	cdev_init(&chip->cdevs, &tpms_fops);
 	chip->cdev.owner = THIS_MODULE;
+	chip->cdevs.owner = THIS_MODULE;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
+	chip->cdevs.kobj.parent = &chip->devs.kobj;
 
 	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!chip->work_space.context_buf) {
@@ -199,6 +227,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	return chip;
 
 out:
+	put_device(&chip->devs);
 	put_device(&chip->dev);
 	return ERR_PTR(rc);
 }
@@ -244,7 +273,7 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
-		return rc;
+		goto err_1;
 	}
 
 	rc = device_add(&chip->dev);
@@ -254,16 +283,44 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
-		cdev_del(&chip->cdev);
-		return rc;
+		goto err_2;
+	}
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = cdev_add(&chip->cdevs, chip->devs.devt, 1);
+	if (rc) {
+		dev_err(&chip->dev,
+			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
+			dev_name(&chip->devs), MAJOR(chip->devs.devt),
+			MINOR(chip->devs.devt), rc);
+
+		goto err_3;
 	}
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = device_add(&chip->devs);
+	if (rc) {
+		dev_err(&chip->dev,
+			"unable to device_register() %s, major %d, minor %d, err=%d\n",
+			dev_name(&chip->devs), MAJOR(chip->devs.devt),
+			MINOR(chip->devs.devt), rc);
+
+		goto err_4;
+	}
 	/* Make the chip available. */
 	mutex_lock(&idr_lock);
 	idr_replace(&dev_nums_idr, chip, chip->dev_num);
 	mutex_unlock(&idr_lock);
 
 	return rc;
+ err_4:
+	cdev_del(&chip->cdevs);
+ err_3:
+	device_del(&chip->dev);
+ err_2:
+	cdev_del(&chip->cdev);
+ err_1:
+	return rc;
 }
 
 static void tpm_del_char_device(struct tpm_chip *chip)
@@ -271,6 +328,11 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 	cdev_del(&chip->cdev);
 	device_del(&chip->dev);
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		cdev_del(&chip->cdevs);
+		device_del(&chip->devs);
+	}
+
 	/* Make the chip unavailable. */
 	mutex_lock(&idr_lock);
 	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
@@ -282,6 +344,9 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
 	chip->ops = NULL;
 	up_write(&chip->ops_sem);
+	/* will release the devs reference to the chip->dev unless
+	 * something has cdevs open */
+	put_device(&chip->devs);
 }
 
 static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index ae85aab..2725f04 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1218,9 +1218,17 @@ static int __init tpm_init(void)
 		return PTR_ERR(tpm_class);
 	}
 
-	rc = alloc_chrdev_region(&tpm_devt, 0, TPM_NUM_DEVICES, "tpm");
+	tpms_class = class_create(THIS_MODULE, "tpms");
+	if (IS_ERR(tpms_class)) {
+		pr_err("couldn't create tpms class\n");
+		class_destroy(tpm_class);
+		return PTR_ERR(tpms_class);
+	}
+
+	rc = alloc_chrdev_region(&tpm_devt, 0, 2*TPM_NUM_DEVICES, "tpm");
 	if (rc < 0) {
 		pr_err("tpm: failed to allocate char dev region\n");
+		class_destroy(tpms_class);
 		class_destroy(tpm_class);
 		return rc;
 	}
@@ -1232,7 +1240,8 @@ static void __exit tpm_exit(void)
 {
 	idr_destroy(&dev_nums_idr);
 	class_destroy(tpm_class);
-	unregister_chrdev_region(tpm_devt, TPM_NUM_DEVICES);
+	class_destroy(tpms_class);
+	unregister_chrdev_region(tpm_devt, 2*TPM_NUM_DEVICES);
 }
 
 subsys_initcall(tpm_init);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 45d997f..ae3a9c7 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -174,7 +174,9 @@ struct tpm_chip_seqops {
 
 struct tpm_chip {
 	struct device dev;
+	struct device devs;
 	struct cdev cdev;
+	struct cdev cdevs;
 
 	/* A driver callback under ops cannot be run unless ops_sem is held
 	 * (sometimes implicitly, eg for the sysfs code). ops becomes null
@@ -511,8 +513,10 @@ static inline void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value)
 }
 
 extern struct class *tpm_class;
+extern struct class *tpms_class;
 extern dev_t tpm_devt;
 extern const struct file_operations tpm_fops;
+extern const struct file_operations tpms_fops;
 extern struct idr dev_nums_idr;
 
 enum tpm_transmit_flags {
diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
new file mode 100644
index 0000000..faf6f5a
--- /dev/null
+++ b/drivers/char/tpm/tpms-dev.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright (C) 2017 James.Bottomley@HansenPartnership.com
+ *
+ * GPLv2
+ */
+#include <linux/slab.h>
+#include "tpm-dev.h"
+
+struct tpms_priv {
+	struct file_priv priv;
+	struct tpm_space space;
+};
+
+static int tpms_open(struct inode *inode, struct file *file)
+{
+	struct tpm_chip *chip;
+	struct tpms_priv *priv;
+
+	chip = container_of(inode->i_cdev, struct tpm_chip, cdevs);
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL)
+		return -ENOMEM;
+	priv->space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (priv->space.context_buf == NULL) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+
+	tpm_common_open(file, chip, &priv->priv);
+
+	return 0;
+}
+
+static int tpms_release(struct inode *inode, struct file *file)
+{
+	struct file_priv *fpriv = file->private_data;
+	struct tpms_priv *priv = container_of(fpriv, struct tpms_priv, priv);
+
+	tpm_common_release(file, fpriv);
+	kfree(priv->space.context_buf);
+	kfree(priv);
+
+	return 0;
+}
+
+ssize_t tpms_write(struct file *file, const char __user *buf,
+		   size_t size, loff_t *off)
+{
+	struct file_priv *fpriv = file->private_data;
+	struct tpms_priv *priv = container_of(fpriv, struct tpms_priv, priv);
+
+	return tpm_common_write(file, buf, size, off, &priv->space);
+}
+
+const struct file_operations tpms_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = tpms_open,
+	.read = tpm_common_read,
+	.write = tpms_write,
+	.release = tpms_release,
+};
+

--=-Wc1RXwIfrFIpUnWvd2CS--
