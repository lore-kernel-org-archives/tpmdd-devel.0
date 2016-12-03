From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 3/4] tmp: use pdev for parent device in tpm_chip_alloc
Date: Sat, 3 Dec 2016 17:35:30 +0200
Message-ID: <20161203153530.yk3ilrg74qwg2f7a@intel.com>
References: <1479895454-15076-1-git-send-email-tomas.winkler@intel.com>
 <1479895454-15076-4-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479895454-15076-4-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 23, 2016 at 12:04:13PM +0200, Tomas Winkler wrote:
> The tpm stack uses pdev name convention for the parent device.
> Fix that also in tpm_chip_alloc().

Usually I'm not too fond for minor style fixes but in this case it
improves the clarity.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> 
> Fixes: 3897cd9c8d1d ("tpm: Split out the devm stuff from tpmm_chip_alloc")'
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2: resend
>  drivers/char/tpm/tpm-chip.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 7a4869151d3b..eefdc809faf0 100644
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
