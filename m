From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC v3 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Thu, 19 Jan 2017 12:42:26 +0200
Message-ID: <20170119104226.jghpe7qw654bjrxl@intel.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
	<20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170116131215.28930-6-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

I've forgot to put out my review comments about this patch. Please send
me an updated patch and I'll include it to v4. You can choose to send it
also privately because it will go to public review anyway through the
patch set.

I could fix these myself (because they are cosmetic stuff) but I simply
don't have the time at my hand and you are the author so...

Please include also the fixup to remove that leftover put_device. Thank
you.

On Mon, Jan 16, 2017 at 03:12:11PM +0200, Jarkko Sakkinen wrote:
> From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> 
> Currently the Resource Manager (RM) is not exposed to userspace.  Make
> this exposure via a separate device, which can now be opened multiple
> times because each read/write transaction goes separately via the RM.
> 
> Concurrency is protected by the chip->tpm_mutex for each read/write
> transaction separately.  The TPM is cleared of all transient objects
> by the time the mutex is dropped, so there should be no interference
> between the kernel and userspace.
> 
> Signed-off-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

TPM spaces are not exposed to the user space, which are a tool to
implement a resource manager. This commit message should be rewritten.

> ---
>  drivers/char/tpm/Makefile        |  2 +-
>  drivers/char/tpm/tpm-chip.c      | 72 ++++++++++++++++++++++++++++++++++++++--
>  drivers/char/tpm/tpm-interface.c | 13 ++++++--
>  drivers/char/tpm/tpm.h           |  6 ++--
>  drivers/char/tpm/tpms-dev.c      | 62 ++++++++++++++++++++++++++++++++++
>  5 files changed, 147 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/char/tpm/tpms-dev.c
> 
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 13ff5da..e50d768 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -3,7 +3,7 @@
>  #
>  obj-$(CONFIG_TCG_TPM) += tpm.o
>  tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
> -	 tpm_eventlog.o tpm2-space.o tpm-dev-common.o
> +	 tpm_eventlog.o tpm2-space.o tpm-dev-common.o tpms-dev.o
>  tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
>  tpm-$(CONFIG_OF) += tpm_of.o
>  obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 993b9ae..5ae3050 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -33,6 +33,7 @@ DEFINE_IDR(dev_nums_idr);
>  static DEFINE_MUTEX(idr_lock);
>  
>  struct class *tpm_class;
> +struct class *tpm_rm_class;

tpms_class

>  dev_t tpm_devt;
>  
>  /**
> @@ -132,6 +133,14 @@ static void tpm_dev_release(struct device *dev)
>  	kfree(chip);
>  }
>  
> +static void tpm_devrm_release(struct device *dev)

tpms_release

> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devrm);
> +
> +	/* release the master device reference */
> +	put_device(&chip->dev);
> +}
> +
>  /**
>   * tpm_chip_alloc() - allocate a new struct tpm_chip instance
>   * @pdev: device to which the chip is associated
> @@ -168,27 +177,46 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	chip->dev_num = rc;
>  
>  	device_initialize(&chip->dev);
> +	device_initialize(&chip->devrm);

chip->devs (well you probably get the iea, not going to comment every
possible instance)

>  
>  	chip->dev.class = tpm_class;
>  	chip->dev.release = tpm_dev_release;
>  	chip->dev.parent = pdev;
>  	chip->dev.groups = chip->groups;
>  
> +	chip->devrm.parent = pdev;
> +	chip->devrm.class = tpm_rm_class;
> +	chip->devrm.release = tpm_devrm_release;
> +	/* get extra reference on main device to hold on
> +	 * behalf of devrm.  This holds the chip structure
> +	 * while cdevrm is in use.  The corresponding put
> +	 * is in the tpm_devrm_release */
> +	get_device(&chip->dev);
> +
>  	if (chip->dev_num == 0)
>  		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
>  	else
>  		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
>  
> +	chip->devrm.devt =
> +		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> +
>  	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
>  	if (rc)
>  		goto out;
> +	rc = dev_set_name(&chip->devrm, "tpms%d", chip->dev_num);
> +	if (rc)
> +		goto out;
>  
>  	if (!pdev)
>  		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
>  
>  	cdev_init(&chip->cdev, &tpm_fops);
> +	cdev_init(&chip->cdevrm, &tpm_rm_fops);
>  	chip->cdev.owner = THIS_MODULE;
> +	chip->cdevrm.owner = THIS_MODULE;
>  	chip->cdev.kobj.parent = &chip->dev.kobj;
> +	chip->cdevrm.kobj.parent = &chip->devrm.kobj;
>  
>  	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!chip->work_space.context_buf) {
> @@ -199,7 +227,9 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	return chip;
>  
>  out:
> +	put_device(&chip->devrm);
>  	put_device(&chip->dev);
> +	put_device(&chip->devrm);
>  	return ERR_PTR(rc);
>  }
>  EXPORT_SYMBOL_GPL(tpm_chip_alloc);
> @@ -244,7 +274,7 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  			dev_name(&chip->dev), MAJOR(chip->dev.devt),
>  			MINOR(chip->dev.devt), rc);
>  
> -		return rc;
> +		goto err_1;
>  	}
>  
>  	rc = device_add(&chip->dev);
> @@ -254,16 +284,44 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  			dev_name(&chip->dev), MAJOR(chip->dev.devt),
>  			MINOR(chip->dev.devt), rc);
>  
> -		cdev_del(&chip->cdev);
> -		return rc;
> +		goto err_2;
> +	}
> +
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		rc = cdev_add(&chip->cdevrm, chip->devrm.devt, 1);
> +	if (rc) {
> +		dev_err(&chip->dev,
> +			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
> +			dev_name(&chip->devrm), MAJOR(chip->devrm.devt),
> +			MINOR(chip->devrm.devt), rc);
> +
> +		goto err_3;
>  	}
>  
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		rc = device_add(&chip->devrm);
> +	if (rc) {
> +		dev_err(&chip->dev,
> +			"unable to device_register() %s, major %d, minor %d, err=%d\n",
> +			dev_name(&chip->devrm), MAJOR(chip->devrm.devt),
> +			MINOR(chip->devrm.devt), rc);
> +
> +		goto err_4;
> +	}
>  	/* Make the chip available. */
>  	mutex_lock(&idr_lock);
>  	idr_replace(&dev_nums_idr, chip, chip->dev_num);
>  	mutex_unlock(&idr_lock);
>  
>  	return rc;
> + err_4:
> +	cdev_del(&chip->cdevrm);
> + err_3:
> +	device_del(&chip->dev);
> + err_2:
> +	cdev_del(&chip->cdev);
> + err_1:
> +	return rc;
>  }
>  
>  static void tpm_del_char_device(struct tpm_chip *chip)
> @@ -271,6 +329,11 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>  	cdev_del(&chip->cdev);
>  	device_del(&chip->dev);
>  
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +		cdev_del(&chip->cdevrm);
> +		device_del(&chip->devrm);
> +	}
> +
>  	/* Make the chip unavailable. */
>  	mutex_lock(&idr_lock);
>  	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
> @@ -282,6 +345,9 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
>  	chip->ops = NULL;
>  	up_write(&chip->ops_sem);
> +	/* will release the devrm reference to the chip->dev unless
> +	 * something has cdevrm open */
> +	put_device(&chip->devrm);
>  }
>  
>  static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index ae85aab..40bf022 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -1218,9 +1218,17 @@ static int __init tpm_init(void)
>  		return PTR_ERR(tpm_class);
>  	}
>  
> -	rc = alloc_chrdev_region(&tpm_devt, 0, TPM_NUM_DEVICES, "tpm");
> +	tpm_rm_class = class_create(THIS_MODULE, "tpms");
> +	if (IS_ERR(tpm_rm_class)) {
> +		pr_err("couldn't create tpmrm class\n");
> +		class_destroy(tpm_class);
> +		return PTR_ERR(tpm_rm_class);
> +	}
> +
> +	rc = alloc_chrdev_region(&tpm_devt, 0, 2*TPM_NUM_DEVICES, "tpm");
>  	if (rc < 0) {
>  		pr_err("tpm: failed to allocate char dev region\n");
> +		class_destroy(tpm_rm_class);
>  		class_destroy(tpm_class);
>  		return rc;
>  	}
> @@ -1232,7 +1240,8 @@ static void __exit tpm_exit(void)
>  {
>  	idr_destroy(&dev_nums_idr);
>  	class_destroy(tpm_class);
> -	unregister_chrdev_region(tpm_devt, TPM_NUM_DEVICES);
> +	class_destroy(tpm_rm_class);
> +	unregister_chrdev_region(tpm_devt, 2*TPM_NUM_DEVICES);
>  }
>  
>  subsys_initcall(tpm_init);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 45d997f..3346c48 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -173,8 +173,8 @@ struct tpm_chip_seqops {
>  };
>  
>  struct tpm_chip {
> -	struct device dev;
> -	struct cdev cdev;
> +	struct device dev, devrm;
> +	struct cdev cdev, cdevrm;

Again cosmetic stuff (or more like nitpicking) but I would like have one
declaration per line.

>  	/* A driver callback under ops cannot be run unless ops_sem is held
>  	 * (sometimes implicitly, eg for the sysfs code). ops becomes null
> @@ -511,8 +511,10 @@ static inline void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value)
>  }
>  
>  extern struct class *tpm_class;
> +extern struct class *tpm_rm_class;
>  extern dev_t tpm_devt;
>  extern const struct file_operations tpm_fops;
> +extern const struct file_operations tpm_rm_fops;
>  extern struct idr dev_nums_idr;
>  
>  enum tpm_transmit_flags {
> diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
> new file mode 100644
> index 0000000..c10b308
> --- /dev/null
> +++ b/drivers/char/tpm/tpms-dev.c
> @@ -0,0 +1,62 @@
> +/*
> + * Copyright (C) 2017 James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
> + *
> + * GPLv2
> + */
> +#include <linux/slab.h>
> +#include "tpm-dev.h"
> +
> +struct tpms_priv {
> +	struct file_priv priv;
> +	struct tpm_space space;
> +};
> +
> +static int tpms_open(struct inode *inode, struct file *file)
> +{
> +	struct tpm_chip *chip;
> +	struct tpms_priv *priv;
> +
> +	chip = container_of(inode->i_cdev, struct tpm_chip, cdevrm);
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (priv == NULL)
> +		return -ENOMEM;
> +	priv->space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (priv->space.context_buf == NULL) {
> +		kfree(priv);
> +		return -ENOMEM;
> +	}
> +
> +	tpm_common_open(file, chip, &priv->priv);
> +
> +	return 0;
> +}
> +
> +static int tpms_release(struct inode *inode, struct file *file)
> +{
> +	struct file_priv *fpriv = file->private_data;
> +	struct tpms_priv *priv = container_of(fpriv, struct tpms_priv, priv);
> +
> +	tpm_common_release(file, fpriv);
> +	kfree(priv);
> +
> +	return 0;
> +}
> +
> +ssize_t tpms_write(struct file *file, const char __user *buf,
> +		   size_t size, loff_t *off)
> +{
> +	struct file_priv *fpriv = file->private_data;
> +	struct tpms_priv *priv = container_of(fpriv, struct tpms_priv, priv);
> +
> +	return tpm_common_write(file, buf, size, off, &priv->space);
> +}
> +
> +const struct file_operations tpm_rm_fops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.open = tpms_open,
> +	.read = tpm_common_read,
> +	.write = tpms_write,
> +	.release = tpms_release,
> +};
> +
> -- 
> 2.9.3
> 

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
