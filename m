From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 3/4 v2] tmp: use pdev for parent device in tpm_chip_alloc
Date: Thu, 24 Nov 2016 15:17:50 +0200
Message-ID: <20161124131750.24px2yoavtk4ipk7@intel.com>
References: <1479315821-27349-1-git-send-email-tomas.winkler@intel.com>
 <1479315821-27349-3-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479315821-27349-3-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 16, 2016 at 07:03:40PM +0200, Tomas Winkler wrote:
> The tpm stack uses pdev name convention for the parent device.
> Fix that also in tpm_chip_alloc().
> 
> Fixes: 3897cd9c8d1d ("tpm: Split out the devm stuff from tpmm_chip_alloc")'
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

You should CC patches by default also to linux-security-module. I don't
think for this particular series it is a major concern though.

/Jarkko


> ---
> Resend.
>  drivers/char/tpm/tpm-chip.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 3f27753d96aa..9e36a7f21a6e 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -141,7 +141,7 @@ static void tpm_dev_release(struct device *dev)
>   * Allocates a new struct tpm_chip instance and assigns a free
>   * device number for it. Must be paired with put_device(&chip->dev).
>   */
> -struct tpm_chip *tpm_chip_alloc(struct device *dev,
> +struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  				const struct tpm_class_ops *ops)
>  {
>  	struct tpm_chip *chip;
> @@ -160,7 +160,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
>  	rc = idr_alloc(&dev_nums_idr, NULL, 0, TPM_NUM_DEVICES, GFP_KERNEL);
>  	mutex_unlock(&idr_lock);
>  	if (rc < 0) {
> -		dev_err(dev, "No available tpm device numbers\n");
> +		dev_err(pdev, "No available tpm device numbers\n");
>  		kfree(chip);
>  		return ERR_PTR(rc);
>  	}
> @@ -170,7 +170,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
>  
>  	chip->dev.class = tpm_class;
>  	chip->dev.release = tpm_dev_release;
> -	chip->dev.parent = dev;
> +	chip->dev.parent = pdev;
>  	chip->dev.groups = chip->groups;
>  
>  	if (chip->dev_num == 0)
> @@ -182,7 +182,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
>  	if (rc)
>  		goto out;
>  
> -	if (!dev)
> +	if (!pdev)
>  		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
>  
>  	cdev_init(&chip->cdev, &tpm_fops);
> -- 
> 2.7.4
> 
