From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 5/9] tpm: have event log use the tpm_chip
Date: Mon, 14 Nov 2016 15:44:02 -0800
Message-ID: <20161114234401.dkffb5gcvols4sgb@intel.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479117656-12403-6-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479117656-12403-6-git-send-email-nayna@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 14, 2016 at 05:00:52AM -0500, Nayna Jain wrote:
> Move the backing memory for the event log into tpm_chip and push
> the tpm_chip into read_log. This optimizes read_log processing by
> only doing it once and prepares things for the next patches in the
> series which require the tpm_chip to locate the event log via
> ACPI and OF handles instead of searching.
> 
> This is straightfoward except for the issue of passing a kref through
> i_private with securityfs. Since securityfs_remove does not have any
> removal fencing like sysfs we use the inode lock to safely get a
> kref on the tpm_chip.
> 
> Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm-chip.c     |  3 +-
>  drivers/char/tpm/tpm.h          | 11 ++++++
>  drivers/char/tpm/tpm_acpi.c     | 15 +++++--
>  drivers/char/tpm/tpm_eventlog.c | 88 ++++++++++++++++++++++++++---------------
>  drivers/char/tpm/tpm_eventlog.h |  2 +-
>  drivers/char/tpm/tpm_of.c       |  4 +-
>  6 files changed, 85 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 250a651..3f27753 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -127,6 +127,7 @@ static void tpm_dev_release(struct device *dev)
>  	idr_remove(&dev_nums_idr, chip->dev_num);
>  	mutex_unlock(&idr_lock);
>  
> +	kfree(chip->log.bios_event_log);
>  	kfree(chip);
>  }
>  
> @@ -345,7 +346,7 @@ int tpm_chip_register(struct tpm_chip *chip)
>  	tpm_sysfs_add_device(chip);
>  
>  	rc = tpm_bios_log_setup(chip);
> -	if (rc)
> +	if (rc == -ENODEV)
>  		return rc;
>  
>  	tpm_add_ppi(chip);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 9d69580..1ae9768 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -35,6 +35,8 @@
>  #include <linux/cdev.h>
>  #include <linux/highmem.h>
>  
> +#include "tpm_eventlog.h"
> +
>  enum tpm_const {
>  	TPM_MINOR = 224,	/* officially assigned */
>  	TPM_BUFSIZE = 4096,
> @@ -146,6 +148,11 @@ enum tpm_chip_flags {
>  	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= BIT(4),
>  };
>  
> +struct tpm_chip_seqops {
> +	struct tpm_chip *chip;
> +	const struct seq_operations *seqops;
> +};
> +
>  struct tpm_chip {
>  	struct device dev;
>  	struct cdev cdev;
> @@ -157,6 +164,10 @@ struct tpm_chip {
>  	struct rw_semaphore ops_sem;
>  	const struct tpm_class_ops *ops;
>  
> +	struct tpm_bios_log log;
> +	struct tpm_chip_seqops bin_log_seqops;
> +	struct tpm_chip_seqops ascii_log_seqops;
> +
>  	unsigned int flags;
>  
>  	int dev_num;		/* /dev/tpm# */
> diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
> index 565a947..01dfb35 100644
> --- a/drivers/char/tpm/tpm_acpi.c
> +++ b/drivers/char/tpm/tpm_acpi.c
> @@ -9,7 +9,7 @@
>   *
>   * Maintained by: <tpmdd-devel@lists.sourceforge.net>
>   *
> - * Access to the eventlog extended by the TCG BIOS of PC platform
> + * Access to the event log extended by the TCG BIOS of PC platform
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -45,13 +45,15 @@ struct acpi_tcpa {
>  };
>  
>  /* read binary bios log */
> -int read_log(struct tpm_bios_log *log)
> +int read_log(struct tpm_chip *chip)
>  {
>  	struct acpi_tcpa *buff;
>  	acpi_status status;
>  	void __iomem *virt;
>  	u64 len, start;
> +	struct tpm_bios_log *log;
>  
> +	log = &chip->log;
>  	if (log->bios_event_log != NULL) {
>  		printk(KERN_ERR
>  		       "%s: ERROR - Eventlog already initialized\n",
> @@ -97,13 +99,18 @@ int read_log(struct tpm_bios_log *log)
>  
>  	virt = acpi_os_map_iomem(start, len);
>  	if (!virt) {
> -		kfree(log->bios_event_log);
>  		printk("%s: ERROR - Unable to map memory\n", __func__);
> -		return -EIO;
> +		goto err;
>  	}
>  
>  	memcpy_fromio(log->bios_event_log, virt, len);
>  
>  	acpi_os_unmap_iomem(virt, len);
>  	return 0;
> +
> +err:
> +	kfree(log->bios_event_log);
> +	log->bios_event_log = NULL;
> +	return -EIO;
> +
>  }
> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
> index 57ac862..f8c42fe 100644
> --- a/drivers/char/tpm/tpm_eventlog.c
> +++ b/drivers/char/tpm/tpm_eventlog.c
> @@ -11,7 +11,7 @@
>   *
>   * Maintained by: <tpmdd-devel@lists.sourceforge.net>
>   *
> - * Access to the eventlog created by a system's firmware / BIOS
> + * Access to the event log created by a system's firmware / BIOS
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -73,7 +73,8 @@ static const char* tcpa_pc_event_id_strings[] = {
>  static void *tpm_bios_measurements_start(struct seq_file *m, loff_t *pos)
>  {
>  	loff_t i;
> -	struct tpm_bios_log *log = m->private;
> +	struct tpm_chip *chip = m->private;
> +	struct tpm_bios_log *log = &chip->log;
>  	void *addr = log->bios_event_log;
>  	void *limit = log->bios_event_log_end;
>  	struct tcpa_event *event;
> @@ -120,7 +121,8 @@ static void *tpm_bios_measurements_next(struct seq_file *m, void *v,
>  					loff_t *pos)
>  {
>  	struct tcpa_event *event = v;
> -	struct tpm_bios_log *log = m->private;
> +	struct tpm_chip *chip = m->private;
> +	struct tpm_bios_log *log = &chip->log;
>  	void *limit = log->bios_event_log_end;
>  	u32 converted_event_size;
>  	u32 converted_event_type;
> @@ -261,13 +263,10 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
>  static int tpm_bios_measurements_release(struct inode *inode,
>  					 struct file *file)
>  {
> -	struct seq_file *seq = file->private_data;
> -	struct tpm_bios_log *log = seq->private;
> +	struct seq_file *seq = (struct seq_file *)file->private_data;
> +	struct tpm_chip *chip = (struct tpm_chip *)seq->private;
>  
> -	if (log) {
> -		kfree(log->bios_event_log);
> -		kfree(log);
> -	}
> +	put_device(&chip->dev);
>  
>  	return seq_release(inode, file);
>  }
> @@ -323,33 +322,30 @@ static int tpm_bios_measurements_open(struct inode *inode,
>  					    struct file *file)
>  {
>  	int err;
> -	struct tpm_bios_log *log;
>  	struct seq_file *seq;
> -	const struct seq_operations *seqops =
> -		(const struct seq_operations *)inode->i_private;
> -
> -	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
> -	if (!log)
> -		return -ENOMEM;
> -
> -	if ((err = read_log(log)))
> -		goto out_free;
> +	struct tpm_chip_seqops *chip_seqops;
> +	const struct seq_operations *seqops;
> +	struct tpm_chip *chip;
> +
> +	inode_lock(inode);
> +	if (!inode->i_private) {
> +		inode_unlock(inode);
> +		return -ENODEV;
> +	}
> +	chip_seqops = (struct tpm_chip_seqops *)inode->i_private;
> +	seqops = chip_seqops->seqops;
> +	chip = chip_seqops->chip;
> +	get_device(&chip->dev);
> +	inode_unlock(inode);
>  
>  	/* now register seq file */
>  	err = seq_open(file, seqops);
>  	if (!err) {
>  		seq = file->private_data;
> -		seq->private = log;
> -	} else {
> -		goto out_free;
> +		seq->private = chip;
>  	}
>  
> -out:
>  	return err;
> -out_free:
> -	kfree(log->bios_event_log);
> -	kfree(log);
> -	goto out;
>  }
>  
>  static const struct file_operations tpm_bios_measurements_ops = {
> @@ -372,29 +368,47 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>  {
>  	const char *name = dev_name(&chip->dev);
>  	unsigned int cnt;
> +	int rc = 0;
>  
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		return 0;
>  
> +	rc = read_log(chip);
> +	/*
> +	 * read_log failure means event log is not supported except for ENOMEM.
> +	 */
> +	if (rc < 0) {
> +		if (rc == -ENOMEM)
> +			return -ENODEV;
> +		else
> +			return rc;
> +	}
> +
>  	cnt = 0;
>  	chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
>  	if (is_bad(chip->bios_dir[cnt]))
>  		goto err;
>  	cnt++;
>  
> +	chip->bin_log_seqops.chip = chip;
> +	chip->bin_log_seqops.seqops = &tpm_binary_b_measurements_seqops;
> +
>  	chip->bios_dir[cnt] =
>  	    securityfs_create_file("binary_bios_measurements",
>  				   0440, chip->bios_dir[0],
> -				   (void *)&tpm_binary_b_measurements_seqops,
> +				   (void *)&chip->bin_log_seqops,
>  				   &tpm_bios_measurements_ops);
>  	if (is_bad(chip->bios_dir[cnt]))
>  		goto err;
>  	cnt++;
>  
> +	chip->ascii_log_seqops.chip = chip;
> +	chip->ascii_log_seqops.seqops = &tpm_ascii_b_measurements_seqops;
> +
>  	chip->bios_dir[cnt] =
>  	    securityfs_create_file("ascii_bios_measurements",
>  				   0440, chip->bios_dir[0],
> -				   (void *)&tpm_ascii_b_measurements_seqops,
> +				   (void *)&chip->ascii_log_seqops,
>  				   &tpm_bios_measurements_ops);
>  	if (is_bad(chip->bios_dir[cnt]))
>  		goto err;
> @@ -411,7 +425,19 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>  void tpm_bios_log_teardown(struct tpm_chip *chip)
>  {
>  	int i;
> -
> -	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--)
> +	struct inode *inode;
> +
> +	/* securityfs_remove currently doesn't take care of handling sync
> +	 * between removal and opening of pseudo files. To handle this, a
> +	 * workaround is added by making i_private = NULL here during removal
> +	 * and to check it during open(), both within inode_lock()/unlock().
> +	 * This design ensures that open() either safely gets kref or fails.
> +	 */
> +	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
> +		inode = d_inode(chip->bios_dir[i]);
> +		inode_lock(inode);
> +		inode->i_private = NULL;
> +		inode_unlock(inode);
>  		securityfs_remove(chip->bios_dir[i]);
> +	}
>  }
> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
> index fd3357e..6df2f8e 100644
> --- a/drivers/char/tpm/tpm_eventlog.h
> +++ b/drivers/char/tpm/tpm_eventlog.h
> @@ -73,7 +73,7 @@ enum tcpa_pc_event_ids {
>  	HOST_TABLE_OF_DEVICES,
>  };
>  
> -int read_log(struct tpm_bios_log *log);
> +int read_log(struct tpm_chip *chip);
>  
>  #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
>  	defined(CONFIG_ACPI)
> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
> index 570f30c..68d891a 100644
> --- a/drivers/char/tpm/tpm_of.c
> +++ b/drivers/char/tpm/tpm_of.c
> @@ -20,12 +20,14 @@
>  #include "tpm.h"
>  #include "tpm_eventlog.h"
>  
> -int read_log(struct tpm_bios_log *log)
> +int read_log(struct tpm_chip *chip)
>  {
>  	struct device_node *np;
>  	const u32 *sizep;
>  	const u64 *basep;
> +	struct tpm_bios_log *log;
>  
> +	log = &chip->log;
>  	if (log->bios_event_log != NULL) {
>  		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
>  		return -EFAULT;
> -- 
> 2.5.0
> 
