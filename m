From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Sun, 2 Oct 2016 13:17:55 +0300
Message-ID: <20161002101755.GA25844@intel.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475393971-12715-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Oct 02, 2016 at 10:39:31AM +0300, Tomas Winkler wrote:
> In tpm_del_char_device device_del is called
> prior to tpm2_shutdown where it is still used.
> 
> Fortunately, so far chip->dev was used only for printouts
> int tpm2_shutdown flow, hence system didn't crash. But with
> the introduction of runtime power management it will result in
> shutting down the parent device while it still in use.
> 
> Fixes: 20e0152393b41 ("tpm: fix crash in tpm_tis deinitialization")
> Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm-chip.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index e5950131bd90..b1cb0aae8e66 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -261,7 +261,6 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  static void tpm_del_char_device(struct tpm_chip *chip)
>  {
>  	cdev_del(&chip->cdev);
> -	device_del(&chip->dev);
>  
>  	/* Make the chip unavailable. */
>  	mutex_lock(&idr_lock);
> @@ -274,6 +273,8 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
>  	chip->ops = NULL;
>  	up_write(&chip->ops_sem);
> +
> +	device_del(&chip->dev);
>  }
>  
>  static int tpm1_chip_register(struct tpm_chip *chip)
> -- 
> 2.7.4
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
