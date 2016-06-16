From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: use devm_add_action_or_reset
Date: Thu, 16 Jun 2016 22:28:23 +0200
Message-ID: <20160616202823.GE1414@intel.com>
References: <1465740329-4699-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465740329-4699-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Jun 12, 2016 at 03:05:29PM +0100, Sudip Mukherjee wrote:
> If devm_add_action() fails we are explicitly calling put_device() to
> free the resources allocated. Lets use the helper
> devm_add_action_or_reset() and return directly in case of error, as we
> know that the cleanup function has been already called by the helper if
> there was any error.
> 
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm-chip.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 1965dc7..5a2f043 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -213,11 +213,11 @@ struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
>  	if (IS_ERR(chip))
>  		return chip;
>  
> -	rc = devm_add_action(pdev, (void (*)(void *)) put_device, &chip->dev);
> -	if (rc) {
> -		put_device(&chip->dev);
> +	rc = devm_add_action_or_reset(pdev,
> +				      (void (*)(void *)) put_device,
> +				      &chip->dev);
> +	if (rc)
>  		return ERR_PTR(rc);
> -	}
>  
>  	dev_set_drvdata(pdev, chip);
>  
> -- 
> 1.9.1
> 
