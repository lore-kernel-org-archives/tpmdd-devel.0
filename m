From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: Add sysfs interface to show TPM hardware version
Date: Mon, 13 Mar 2017 13:48:52 +0200
Message-ID: <20170313114852.kmfequmchxi3jams@intel.com>
References: <1489382517-9078-1-git-send-email-Meng.Li@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489382517-9078-1-git-send-email-Meng.Li@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Meng.Li@windriver.com
Cc: linux-kernel@vger.kernel.org, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 13, 2017 at 01:21:57PM +0800, Meng.Li@windriver.com wrote:
> From: Limeng <Meng.Li@windriver.com>
> 
> So far, there is not a sysfs interface for user space code to
> check the TPM hardware version(TPM1.x or TPM2). So, add a
> file named description in /sys/class/tpm/tpmX/ to show it.
> 
> Signed-off-by: Meng Li <Meng.Li@windriver.com>
> ---
>  drivers/char/tpm/tpm-chip.c |   85 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index c406343..da2cd69 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c

tpm-sysfs.c Probably makes sense to rename legacy group there as tpm1_

> @@ -36,6 +36,83 @@
>  dev_t tpm_devt;
>  
>  /**
> + * show_description - sysfs interface for checking current TPM hardware version.
> + * @dev:	pointer to tpm chip device
> + * @attr:	unused
> + * @buf:	char buffer to be filled with TPM hardware version info
> + *
> + * Provides sysfs interface for showing current TPM hardware version.
> + */
> +static ssize_t show_description(struct device *dev,
> +		struct device_attribute *attr, char *buf)

family

> +{
> +	struct tpm_chip *chip = (struct tpm_chip *)container_of(dev,struct tpm_chip,dev);
> +	int ret;
> +
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		ret = sprintf(buf, "TPM 2.0");
> +	else
> +		ret = sprintf(buf, "TPM 1.x");
> +
> +	return ret;
> +}
> +
> +/**
> + * store_description - interface for manually setting data.
> + * @dev:	unused
> + * @attr:	unused
> + * @buf:	unused
> + * @count:	unused
> + *
> + * There is not any process in this function, reserve for feature.
> + */
> +static ssize_t store_description(struct device *dev, struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	return count;
> +}

What is this??

> +
> +static struct device_attribute tpm_attrs[] = {
> +	__ATTR(description, S_IRUGO | S_IWUSR, show_description, store_description),
> +};
> +
> +/**
> + * tpm_create_sysfs - Create tpm sysfs interface.
> + * @dev:	pointer to tpm chip device
> + *
> + * Create sysfs interface for checking current TPM hardware version.
> + */
> +static int tpm_create_sysfs(struct device *dev)
> +{
> +	int r, t;
> +
> +	for (t = 0; t < ARRAY_SIZE(tpm_attrs); t++) {
> +		r = device_create_file(dev, &tpm_attrs[t]);
> +		if (r) {
> +			dev_err(dev, "failed to create sysfs file\n");
> +			return r;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * tpm_remove_sysfs - Remove tpm sysfs interface.
> + * @dev:	pointer to tpm chip device
> + *
> + * Remove sysfs interface for checking current TPM hardware version.
> + */
> +static void tpm_remove_sysfs(struct device *dev)
> +{
> +	int  t;
> +
> +	for (t = 0; t < ARRAY_SIZE(tpm_attrs); t++) {
> +		device_remove_file(dev, &tpm_attrs[t]);
> +	}
> +}
> +
> +/**
>   * tpm_try_get_ops() - Get a ref to the tpm_chip
>   * @chip: Chip to ref
>   *
> @@ -363,6 +440,13 @@ int tpm_chip_register(struct tpm_chip *chip)
>  		return rc;
>  	}
>  
> +	rc = tpm_create_sysfs(&chip->dev);
> +	if (rc) {
> +		tpm_del_legacy_sysfs(chip);
> +		tpm_chip_unregister(chip);
> +		return rc;
> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_chip_register);
> @@ -382,6 +466,7 @@ int tpm_chip_register(struct tpm_chip *chip)
>   */
>  void tpm_chip_unregister(struct tpm_chip *chip)
>  {
> +	tpm_remove_sysfs(&chip->dev);
>  	tpm_del_legacy_sysfs(chip);
>  	tpm_bios_log_teardown(chip);
>  	tpm_del_char_device(chip);
> -- 
> 1.7.9.5

You should put the attributes to chip->groups instead of racy creation
of them.

/Jarkko
