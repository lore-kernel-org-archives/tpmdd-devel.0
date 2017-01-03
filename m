From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Mon, 02 Jan 2017 21:26:58 -0800
Message-ID: <1483421218.19261.4.camel@linux.vnet.ibm.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
         <1483374980.2458.13.camel@HansenPartnership.com>
         <20170102193320.trawto65nkjccbao@intel.com>
         <1483393248.2458.32.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1483393248.2458.32.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-02 at 13:40 -0800, James Bottomley wrote:
> On Mon, 2017-01-02 at 21:33 +0200, Jarkko Sakkinen wrote:
> > On Mon, Jan 02, 2017 at 08:36:20AM -0800, James Bottomley wrote:
> > > On Mon, 2017-01-02 at 15:22 +0200, Jarkko Sakkinen wrote:
> > > > This patch set adds support for TPM spaces that provide a 
> > > > context for isolating and swapping transient objects. This 
> > > > patch set does not yet include support for isolating policy and 
> > > > HMAC sessions but it is trivial to add once the basic approach 
> > > > is settled (and that's why I created an RFC patch set).
> > > 
> > > The approach looks fine to me.  The only basic query I have is 
> > > about the default: shouldn't it be with resource manager on 
> > > rather than off?  I can't really think of a use case that wants 
> > > the RM off (even if you're running your own, having another 
> > > doesn't hurt anything, and it's still required to share with in
> > > -kernel uses).
> > 
> > This is a valid question and here's a longish explanation.
> > 
> > In TPM2_GetCapability and maybe couple of other commands you can 
> > get handles in the response body. I do not want to have special 
> > cases in the kernel for response bodies because there is no a 
> > generic way to do the substitution. What's worse, new commands in 
> > the standard future revisions could have such commands requiring 
> > special cases. In addition, vendor specific commans could have 
> > handles in the response bodies.
> 
> OK, in general I buy this ... what you're effectively saying is that 
> we need a non-RM interface for certain management type commands.
> 
> However, let me expand a bit on why I'm fretting about the non-RM use
> case.  Right at the moment, we have a single TPM device which you use
> for access to the kernel TPM.  The current tss2 just makes direct use
> of this, meaning it has to have 0666 permissions.  This means that 
> any local user can simply DoS the TPM by running us out of transient
> resources if they don't activate the RM.  If they get a connection
> always via the RM, this isn't a worry.  Perhaps the best way of 
> fixing this is to expose two separate device nodes: one raw to the 
> TPM which we could keep at 0600 and one with an always RM connection 
> which we can set to 0666.  That would mean that access to the non-RM 
> connection is either root only or governed by a system set ACL.

OK, so I put a patch together that does this (see below). It all works
nicely (with a udev script that sets the resource manager device to
0666):

jejb@jarvis:~> ls -l /dev/tpm*
crw------- 1 root root  10,   224 Jan  2 20:54 /dev/tpm0
crw-rw-rw- 1 root root 246, 65536 Jan  2 20:54 /dev/tpm0rm

I've modified the tss to connect to /dev/tpm0rm by default and it all
seems to work.

The patch applies on top of your tabrm branch, by the way.

James

---

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index ac4c05f..25b8d30 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -33,6 +33,7 @@ DEFINE_IDR(dev_nums_idr);
 static DEFINE_MUTEX(idr_lock);
 
 struct class *tpm_class;
+struct class *tpm_rm_class;
 dev_t tpm_devt;
 
 /**
@@ -169,27 +170,39 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
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
 
+	chip->devrm.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
+
 	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
 	if (rc)
 		goto out;
+	rc = dev_set_name(&chip->devrm, "tpm%drm", chip->dev_num);
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
 
 	chip->tr_buf.data = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (!chip->tr_buf.data) {
@@ -208,6 +221,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 
 out:
 	put_device(&chip->dev);
+	put_device(&chip->devrm);
 	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_alloc);
@@ -252,7 +266,7 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 			dev_name(&chip->dev), MAJOR(chip->dev.devt),
 			MINOR(chip->dev.devt), rc);
 
-		return rc;
+		goto err_1;
 	}
 
 	rc = device_add(&chip->dev);
@@ -262,16 +276,44 @@ static int tpm_add_char_device(struct tpm_chip *chip)
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
@@ -279,6 +321,11 @@ static void tpm_del_char_device(struct tpm_chip *chip)
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
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 139638b..bed29f9 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -54,23 +54,28 @@ static void timeout_work(struct work_struct *work)
 	mutex_unlock(&priv->buffer_mutex);
 }
 
-static int tpm_open(struct inode *inode, struct file *file)
+static int tpm_open_internal(struct inode *inode, struct file *file, bool is_rm)
 {
-	struct tpm_chip *chip =
-		container_of(inode->i_cdev, struct tpm_chip, cdev);
+	struct tpm_chip *chip;
 	struct file_priv *priv;
 
+	if (is_rm)
+		chip = container_of(inode->i_cdev, struct tpm_chip, cdevrm);
+	else
+		chip = container_of(inode->i_cdev, struct tpm_chip, cdev);
+
 	/* It's assured that the chip will be opened just once,
 	 * by the check of is_open variable, which is protected
 	 * by driver_lock. */
-	if (test_and_set_bit(0, &chip->is_open)) {
+	if (!is_rm && test_and_set_bit(0, &chip->is_open)) {
 		dev_dbg(&chip->dev, "Another process owns this TPM\n");
 		return -EBUSY;
 	}
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv == NULL) {
-		clear_bit(0, &chip->is_open);
+		if (!is_rm)
+			clear_bit(0, &chip->is_open);
 		return -ENOMEM;
 	}
 
@@ -82,9 +87,27 @@ static int tpm_open(struct inode *inode, struct file *file)
 	INIT_WORK(&priv->work, timeout_work);
 
 	file->private_data = priv;
+
+	if (is_rm) {
+		priv->space.context_buf =  kzalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!priv->space.context_buf)
+			return -ENOMEM;
+		priv->has_space = true;
+	}
+
 	return 0;
 }
 
+static int tpm_open(struct inode *inode, struct file *file)
+{
+	return tpm_open_internal(inode, file, false);
+}
+
+static int tpm_rm_open(struct inode *inode, struct file *file)
+{
+	return tpm_open_internal(inode, file, true);
+}
+
 static ssize_t tpm_read(struct file *file, char __user *buf,
 			size_t size, loff_t *off)
 {
@@ -169,65 +192,6 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 	return in_size;
 }
 
-/**
- * tpm_ioc_new_space - handler for %SGX_IOC_NEW_SPACE ioctl
- *
- * Creates a new TPM space that can hold a set of transient objects. The space
- * is isolated with virtual handles that are mapped into physical handles by the
- * driver.
- */
-static long tpm_ioc_new_space(struct file *file, unsigned int ioctl,
-			      unsigned long arg)
-{
-	struct file_priv *priv = file->private_data;
-	struct tpm_chip *chip = priv->chip;
-	int rc = 0;
-
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
-		return -EOPNOTSUPP;
-
-	mutex_lock(&priv->buffer_mutex);
-
-	if (priv->has_space) {
-		rc = -EBUSY;
-		goto out;
-	}
-
-	priv->space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!priv->space.context_buf) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	/* The TPM device can be opened again as this file has been moved to a
-	 * TPM handle space.
-	 */
-	priv->has_space = true;
-	clear_bit(0, &chip->is_open);
-out:
-	mutex_unlock(&priv->buffer_mutex);
-	return rc;
-}
-
-static long tpm_ioctl(struct file *file, unsigned int ioctl,
-		      unsigned long arg)
-{
-	switch (ioctl) {
-	case TPM_IOC_NEW_SPACE:
-		return tpm_ioc_new_space(file, ioctl, arg);
-	default:
-		return -ENOIOCTLCMD;
-	}
-}
-
-#ifdef CONFIG_COMPAT
-static long tpm_compat_ioctl(struct file *file, unsigned int ioctl,
-			     unsigned long arg)
-{
-	return tpm_ioctl(file, ioctl, arg);
-}
-#endif
-
 /*
  * Called on file close
  */
@@ -247,7 +211,8 @@ static int tpm_release(struct inode *inode, struct file *file)
 	flush_work(&priv->work);
 	file->private_data = NULL;
 	atomic_set(&priv->data_pending, 0);
-	clear_bit(0, &priv->chip->is_open);
+	if (!priv->has_space)
+		clear_bit(0, &priv->chip->is_open);
 	kfree(priv);
 	return 0;
 }
@@ -258,10 +223,15 @@ const struct file_operations tpm_fops = {
 	.open = tpm_open,
 	.read = tpm_read,
 	.write = tpm_write,
-	.unlocked_ioctl = tpm_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = tpm_compat_ioctl,
-#endif
+	.release = tpm_release,
+};
+
+const struct file_operations tpm_rm_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = tpm_rm_open,
+	.read = tpm_read,
+	.write = tpm_write,
 	.release = tpm_release,
 };
 
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index a1ae57e..c1829de 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1194,9 +1194,17 @@ static int __init tpm_init(void)
 		return PTR_ERR(tpm_class);
 	}
 
-	rc = alloc_chrdev_region(&tpm_devt, 0, TPM_NUM_DEVICES, "tpm");
+	tpm_rm_class = class_create(THIS_MODULE, "tpmrm");
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
@@ -1208,7 +1216,8 @@ static void __exit tpm_exit(void)
 {
 	idr_destroy(&dev_nums_idr);
 	class_destroy(tpm_class);
-	unregister_chrdev_region(tpm_devt, TPM_NUM_DEVICES);
+	class_destroy(tpm_rm_class);
+	unregister_chrdev_region(tpm_devt, 2*TPM_NUM_DEVICES);
 }
 
 subsys_initcall(tpm_init);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index c6171e5..890fb6b 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -186,8 +186,8 @@ struct tpm_buf {
 };
 
 struct tpm_chip {
-	struct device dev;
-	struct cdev cdev;
+	struct device dev, devrm;
+	struct cdev cdev, cdevrm;
 
 	/* A driver callback under ops cannot be run unless ops_sem is held
 	 * (sometimes implicitly, eg for the sysfs code). ops becomes null
@@ -493,8 +493,10 @@ static inline void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value)
 }
 
 extern struct class *tpm_class;
+extern struct class *tpm_rm_class;
 extern dev_t tpm_devt;
 extern const struct file_operations tpm_fops;
+extern const struct file_operations tpm_rm_fops;
 extern struct idr dev_nums_idr;
 
 enum tpm_transmit_flags {

