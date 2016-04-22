From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v11 2/4] tpm: Introduce TPM_CHIP_FLAG_VIRTUAL
Date: Fri, 22 Apr 2016 19:46:40 +0300
Message-ID: <20160422164640.GA22741@intel.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1461000376-2888-3-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461000376-2888-3-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 18, 2016 at 01:26:14PM -0400, Stefan Berger wrote:
> Introduce TPM_CHIP_FLAG_VIRTUAL to be used when the chip device has no
> parent device.
> 
> Prevent sysfs entries requiring a parent device from being created.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm-chip.c | 7 +++++--
>  drivers/char/tpm/tpm.h      | 1 +
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 7e2c9cf..a12db8e 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -181,6 +181,9 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
>  	if (rc)
>  		goto out;
>  
> +	if (!dev)
> +		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
> +
>  	cdev_init(&chip->cdev, &tpm_fops);
>  	chip->cdev.owner = THIS_MODULE;
>  	chip->cdev.kobj.parent = &chip->dev.kobj;
> @@ -297,7 +300,7 @@ static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
>  {
>  	struct attribute **i;
>  
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +	if (chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))
>  		return;
>  
>  	sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
> @@ -315,7 +318,7 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
>  	struct attribute **i;
>  	int rc;
>  
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +	if (chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))
>  		return 0;
>  
>  	rc = __compat_only_sysfs_link_entry_to_kobj(
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 508e8e0..ff4e53c 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -138,6 +138,7 @@ enum tpm_chip_flags {
>  	TPM_CHIP_FLAG_REGISTERED	= BIT(0),
>  	TPM_CHIP_FLAG_TPM2		= BIT(1),
>  	TPM_CHIP_FLAG_IRQ		= BIT(2),
> +	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
>  };
>  
>  struct tpm_chip {
> -- 
> 2.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
