From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 3/4] tpm/tpm_crb: open code the crb_init into acpi_add
Date: Thu, 15 Sep 2016 09:24:49 +0300
Message-ID: <20160915062449.GC12289@intel.com>
References: <1473685461-6540-1-git-send-email-tomas.winkler@intel.com>
 <1473685461-6540-4-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473685461-6540-4-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 12, 2016 at 04:04:20PM +0300, Tomas Winkler wrote:
> This is preparation step for implementing tpm crb
> runtime pm. We need to have tpm chip allocated
> and populated before we access the runtime handlers.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Use pm_runtime_put().

Tested-by: Jarkko Sakkinen <jarkko.sakkinn@linux.intel.com>

> ---
> V2: new in the series
> V3: resend
>  drivers/char/tpm/tpm_crb.c | 26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index e945177cf2c8..b0c0e2c9022b 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -265,21 +265,6 @@ static const struct tpm_class_ops tpm_crb = {
>  	.req_complete_val = CRB_DRV_STS_COMPLETE,
>  };
>  
> -static int crb_init(struct acpi_device *device, struct crb_priv *priv)
> -{
> -	struct tpm_chip *chip;
> -
> -	chip = tpmm_chip_alloc(&device->dev, &tpm_crb);
> -	if (IS_ERR(chip))
> -		return PTR_ERR(chip);
> -
> -	dev_set_drvdata(&chip->dev, priv);
> -	chip->acpi_dev_handle = device->handle;
> -	chip->flags = TPM_CHIP_FLAG_TPM2;
> -
> -	return tpm_chip_register(chip);
> -}
> -
>  static int crb_check_resource(struct acpi_resource *ares, void *data)
>  {
>  	struct resource *io_res = data;
> @@ -401,6 +386,7 @@ static int crb_acpi_add(struct acpi_device *device)
>  {
>  	struct acpi_table_tpm2 *buf;
>  	struct crb_priv *priv;
> +	struct tpm_chip *chip;
>  	struct device *dev = &device->dev;
>  	acpi_status status;
>  	u32 sm;
> @@ -438,11 +424,19 @@ static int crb_acpi_add(struct acpi_device *device)
>  	if (rc)
>  		return rc;
>  
> +	chip = tpmm_chip_alloc(dev, &tpm_crb);
> +	if (IS_ERR(chip))
> +		return PTR_ERR(chip);
> +
> +	dev_set_drvdata(&chip->dev, priv);
> +	chip->acpi_dev_handle = device->handle;
> +	chip->flags = TPM_CHIP_FLAG_TPM2;
> +
>  	rc  = crb_cmd_ready(dev, priv);
>  	if (rc)
>  		return rc;
>  
> -	rc = crb_init(device, priv);
> +	rc = tpm_chip_register(chip);
>  	if (rc)
>  		crb_go_idle(dev, priv);
>  
> -- 
> 2.7.4
> 
