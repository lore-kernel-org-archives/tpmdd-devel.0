From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] char: tpm: remove unnecessary NULL check
Date: Wed, 14 Jun 2017 11:46:09 +0200
Message-ID: <20170614094609.yop3p25riqzop6ft@intel.com>
References: <20170613180319.ezszgevmgwno2v5u@intel.com>
	<20170613195542.GA5677@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170613195542.GA5677@embeddedgus>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jun 13, 2017 at 02:55:42PM -0500, Gustavo A. R. Silva wrote:
> Remove unnecessary NULL check.
> Pointer _chip_ cannot be NULL in this instance.
> 
> Addresses-Coverity-ID: 1397646
> Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_atmel.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
> index 0d322ab..66a1452 100644
> --- a/drivers/char/tpm/tpm_atmel.c
> +++ b/drivers/char/tpm/tpm_atmel.c
> @@ -144,13 +144,11 @@ static void atml_plat_remove(void)
>  	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
>  	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
>  
> -	if (chip) {
> -		tpm_chip_unregister(chip);
> -		if (priv->have_region)
> -			atmel_release_region(priv->base, priv->region_size);
> -		atmel_put_base_addr(priv->iobase);
> -		platform_device_unregister(pdev);
> -	}
> +	tpm_chip_unregister(chip);
> +	if (priv->have_region)
> +		atmel_release_region(priv->base, priv->region_size);
> +	atmel_put_base_addr(priv->iobase);
> +	platform_device_unregister(pdev);
>  }
>  
>  static SIMPLE_DEV_PM_OPS(tpm_atml_pm, tpm_pm_suspend, tpm_pm_resume);
> -- 
> 2.5.0
> 

Thank you.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
