From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Fri, 13 Jan 2017 11:20:47 -0800
Message-ID: <1484335247.2527.28.camel@HansenPartnership.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
         <20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
         <20170112183919.GA12836@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112183919.GA12836@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-01-12 at 11:39 -0700, Jason Gunthorpe wrote:
> On Thu, Jan 12, 2017 at 07:46:08PM +0200, Jarkko Sakkinen wrote:
> 
> >  struct tpm_chip {
> > -	struct device dev;
> > -	struct cdev cdev;
> > +	struct device dev, devrm;
> 
> Hum.. devrm adds a new kref but doesn't do anything with the release
> function, so that is going to use after free, ie here:
> 
> > 	put_device(&chip->dev);
> > +	put_device(&chip->devrm);
> > 	return ERR_PTR(rc);
> 
> And other places.
> 
> One solution is to get_device(chip->dev) after
> device_initialize(dev->rm) and add a devrm->dev.release function to
> do put_device(chip->dev)

Actually, no, the devrm is a completely lifetime managed device as part
of the chip structure.  once you've done a device_del on it, it can be
kfreed because it's no longer visible to anything else.  The fix is
simply not to do the put.

With that and the other errors, here's a v3

James

---

>From 572cbf2ac64df040be084182d750f55df836a759 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 3 Jan 2017 09:07:32 -0800
Subject: [PATCH 5/5] tpm2: expose resource manager via a device link
 /dev/tpms<n>

Currently the Resource Manager (RM) is not exposed to userspace.  Make
this exposure via a separate device, which can now be opened multiple
times because each read/write transaction goes separately via the RM.

Concurrency is protected by the chip->tpm_mutex for each read/write
transaction separately.  The TPM is cleared of all transient objects
by the time the mutex is dropped, so there should be no interference
between the kernel and userspace.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/char/tpm/Makefile        |  2 +-
 drivers/char/tpm/tpm-chip.c      | 53 ++++++++++++++++++++++++++++++++--
 drivers/char/tpm/tpm-interface.c | 13 +++++++--
 drivers/char/tpm/tpm.h           |  6 ++--
 drivers/char/tpm/tpms-dev.c      | 62 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 128 insertions(+), 8 deletions(-)
 create mode 100644 drivers/char/tpm/tpms-dev.c

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
index 993b9ae..4548df0 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -33,6 +33,7 @@ DEFINE_IDR(dev_nums_idr);
 static DEFINE_MUTEX(idr_lock);
 
 struct class *tpm_class;
+struct class *tpm_rm_class;
 dev_t tpm_devt;
 
 /**
@@ -168,27 +169,40 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->dev_num = rc;
 
 	device_initialize(&chip->dev);
+	device_initialize(&chip->devrm);
 
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
 
+	chip->devrm.parent = pdev;
+	chip->devrm.class = tpm_rm_class;
+
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
+	chip->devrm.devt =
+		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
+
 	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
 	if (rc)
 		goto out;
+	rc = dev_set_name(&chip->devrm, "tpms%d", chip->dev_num);
+	if (rc)
+		goto out;
 
 	if (!pdev)
 		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
 
 	cdev_init(&chip->cdev, &tpm_fops);
+	cdev_init(&chip->cdevrm, &tpm_rm_fops);
 	chip->cdev.owner = THIS_MODULE;
+	chip->cdevrm.owner = THIS_MODULE;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
+	chip->cdevrm.kobj.parent = &chip->devrm.kobj;
 
 	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!chip->work_space.context_buf) {
@@ -244,7 +258,7 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
-		return rc;
+		goto err_1;
 	}
 
 	rc = device_add(&chip->dev);
@@ -254,16 +268,44 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
-		cdev_del(&chip->cdev);
-		return rc;
+		goto err_2;
+	}
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = cdev_add(&chip->cdevrm, chip->devrm.devt, 1);
+	if (rc) {
+		dev_err(&chip->dev,
+			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
+			dev_name(&chip->devrm), MAJOR(chip->devrm.devt),
+			MINOR(chip->devrm.devt), rc);
+
+		goto err_3;
 	}
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = device_add(&chip->devrm);
+	if (rc) {
+		dev_err(&chip->dev,
+			"unable to device_register() %s, major %d, minor %d, err=%d\n",
+			dev_name(&chip->devrm), MAJOR(chip->devrm.devt),
+			MINOR(chip->devrm.devt), rc);
+
+		goto err_4;
+	}
 	/* Make the chip available. */
 	mutex_lock(&idr_lock);
 	idr_replace(&dev_nums_idr, chip, chip->dev_num);
 	mutex_unlock(&idr_lock);
 
 	return rc;
+ err_4:
+	cdev_del(&chip->cdevrm);
+ err_3:
+	device_del(&chip->dev);
+ err_2:
+	cdev_del(&chip->cdev);
+ err_1:
+	return rc;
 }
 
 static void tpm_del_char_device(struct tpm_chip *chip)
@@ -271,6 +313,11 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 	cdev_del(&chip->cdev);
 	device_del(&chip->dev);
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		cdev_del(&chip->cdevrm);
+		device_del(&chip->devrm);
+	}
+
 	/* Make the chip unavailable. */
 	mutex_lock(&idr_lock);
 	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 65fcd04c..f5c9355 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1197,9 +1197,17 @@ static int __init tpm_init(void)
 		return PTR_ERR(tpm_class);
 	}
 
-	rc = alloc_chrdev_region(&tpm_devt, 0, TPM_NUM_DEVICES, "tpm");
+	tpm_rm_class = class_create(THIS_MODULE, "tpms");
+	if (IS_ERR(tpm_rm_class)) {
+		pr_err("couldn't create tpmrm class\n");
+		class_destroy(tpm_class);
+		return PTR_ERR(tpm_rm_class);
+	}
+
+	rc = alloc_chrdev_region(&tpm_devt, 0, 2*TPM_NUM_DEVICES, "tpm");
 	if (rc < 0) {
 		pr_err("tpm: failed to allocate char dev region\n");
+		class_destroy(tpm_rm_class);
 		class_destroy(tpm_class);
 		return rc;
 	}
@@ -1211,7 +1219,8 @@ static void __exit tpm_exit(void)
 {
 	idr_destroy(&dev_nums_idr);
 	class_destroy(tpm_class);
-	unregister_chrdev_region(tpm_devt, TPM_NUM_DEVICES);
+	class_destroy(tpm_rm_class);
+	unregister_chrdev_region(tpm_devt, 2*TPM_NUM_DEVICES);
 }
 
 subsys_initcall(tpm_init);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 0e93b93..61422e6 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -172,8 +172,8 @@ struct tpm_chip_seqops {
 };
 
 struct tpm_chip {
-	struct device dev;
-	struct cdev cdev;
+	struct device dev, devrm;
+	struct cdev cdev, cdevrm;
 
 	/* A driver callback under ops cannot be run unless ops_sem is held
 	 * (sometimes implicitly, eg for the sysfs code). ops becomes null
@@ -510,8 +510,10 @@ static inline void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value)
 }
 
 extern struct class *tpm_class;
+extern struct class *tpm_rm_class;
 extern dev_t tpm_devt;
 extern const struct file_operations tpm_fops;
+extern const struct file_operations tpm_rm_fops;
 extern struct idr dev_nums_idr;
 
 enum tpm_transmit_flags {
diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
new file mode 100644
index 0000000..c10b308
--- /dev/null
+++ b/drivers/char/tpm/tpms-dev.c
@@ -0,0 +1,62 @@
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
+	chip = container_of(inode->i_cdev, struct tpm_chip, cdevrm);
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
+const struct file_operations tpm_rm_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = tpms_open,
+	.read = tpm_common_read,
+	.write = tpms_write,
+	.release = tpms_release,
+};
+
-- 
2.6.6
