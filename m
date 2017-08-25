From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RESEND 2/3] tpm-chip: Return TPM error
 codes from auto_startup functions
Date: Fri, 25 Aug 2017 20:06:07 +0300
Message-ID: <20170825170607.wfnr5y5zres2n42r@linux.intel.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-3-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824083714.10016-3-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 24, 2017 at 10:37:13AM +0200, Alexander Steffen wrote:
> The auto_startup functions for TPM1 and TPM2 convert all TPM error codes to
> ENODEV on exit. But since there is only one caller for those functions,
> this code can be consolidated within the caller. Additionally, this allows
> the caller to distinguish between a TPM being present (but returning error
> responses for some commands) and no TPM being present (or the TPM
> malfunctioning completely).
> 
> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-chip.c      | 4 +++-
>  drivers/char/tpm/tpm-interface.c | 6 ++----
>  drivers/char/tpm/tpm2-cmd.c      | 5 ++---
>  3 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index a353b7a..f20fcb7 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -404,8 +404,10 @@ int tpm_chip_register(struct tpm_chip *chip)
>  			rc = tpm2_auto_startup(chip);
>  		else
>  			rc = tpm1_auto_startup(chip);
> -		if (rc)
> +		if (rc < 0)
>  			return rc;
> +		else if (rc > 0)
> +			return -ENODEV;

So what good this change makes in the end? I'm not sure I'm following.

>  	}
>  
>  	tpm_sysfs_add_device(chip);
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 78fb41d..fe11f2a 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -1000,7 +1000,8 @@ EXPORT_SYMBOL_GPL(tpm_do_selftest);
>   *                     sequence
>   * @chip: TPM chip to use
>   *
> - * Returns 0 on success, < 0 in case of fatal error.
> + * Returns 0 on success, < 0 in case of fatal error or a value > 0 representing
> + * a TPM error code.
>   */

A nitpick.

According to https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
you ought to use "Return:" keyword ;-)

I would favor here:

  "Return: same as with tpm_transmit_cmd()"

>  int tpm1_auto_startup(struct tpm_chip *chip)
>  {
> @@ -1015,10 +1016,7 @@ int tpm1_auto_startup(struct tpm_chip *chip)
>  		goto out;
>  	}
>  
> -	return rc;
>  out:
> -	if (rc > 0)
> -		rc = -ENODEV;
>  	return rc;
>  }
>  
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index e1a41b7..54a3123 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -1074,7 +1074,8 @@ static int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip)
>   *                     sequence
>   * @chip: TPM chip to use
>   *
> - * Returns 0 on success, < 0 in case of fatal error.
> + * Returns 0 on success, < 0 in case of fatal error or a value > 0 representing
> + * a TPM error code.
>   */
>  int tpm2_auto_startup(struct tpm_chip *chip)
>  {
> @@ -1109,8 +1110,6 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>  	rc = tpm2_get_cc_attrs_tbl(chip);
>  
>  out:
> -	if (rc > 0)
> -		rc = -ENODEV;
>  	return rc;
>  }
>  
> -- 
> 2.7.4
> 

At this point I can only see aero improvement how the driver works and a
very minor clean up.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
