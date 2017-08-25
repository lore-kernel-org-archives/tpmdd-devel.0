From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RESEND 1/3] tpm-chip: Move idr_replace calls to
 appropriate places
Date: Fri, 25 Aug 2017 20:25:46 +0300
Message-ID: <20170825172546.f4bl2wh7tgbyjx2n@linux.intel.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-2-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170824083714.10016-2-Alexander.Steffen@infineon.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexander Steffen <Alexander.Steffen@infineon.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 24, 2017 at 10:37:12AM +0200, Alexander Steffen wrote:
> According to the comments, adding/removing the chip from the list should be
> the first/last action in (un)register. But currently it is done in a
> subfunction in the middle of the process. Moving the code from the
> subfunctions to the appropriate places within (un)register ensures that the
> code matches the comments.
> 
> Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
> ---
>  drivers/char/tpm/tpm-chip.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 67ec9d3..a353b7a 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -327,11 +327,6 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  		}
>  	}
>  
> -	/* Make the chip available. */
> -	mutex_lock(&idr_lock);
> -	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> -	mutex_unlock(&idr_lock);
> -
>  	return rc;
>  }
>  
> @@ -339,11 +334,6 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>  {
>  	cdev_device_del(&chip->cdev, &chip->dev);
>  
> -	/* Make the chip unavailable. */
> -	mutex_lock(&idr_lock);
> -	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
> -	mutex_unlock(&idr_lock);
> -
>  	/* Make the driver uncallable. */
>  	down_write(&chip->ops_sem);
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> @@ -438,6 +428,11 @@ int tpm_chip_register(struct tpm_chip *chip)
>  		return rc;
>  	}
>  
> +	/* Make the chip available. */
> +	mutex_lock(&idr_lock);
> +	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> +	mutex_unlock(&idr_lock);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_chip_register);
> @@ -457,6 +452,11 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
>   */
>  void tpm_chip_unregister(struct tpm_chip *chip)
>  {
> +	/* Make the chip unavailable. */
> +	mutex_lock(&idr_lock);
> +	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
> +	mutex_unlock(&idr_lock);
> +
>  	tpm_del_legacy_sysfs(chip);
>  	tpm_bios_log_teardown(chip);
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -- 

This is unnecessary and questionable code shuffling in a very critical
places of the driver code where race conditions are easily introduced.

If you don't have a better reason to do this, I'm not going to take
this. I also fail to see the connection to the patch set as whole.

/Jarkko
