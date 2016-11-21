From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: Do not print an error message when
 doing TPM auto startup
Date: Mon, 21 Nov 2016 22:42:11 +0200
Message-ID: <20161121204211.iuwi2embugn4f74v@intel.com>
References: <20161121183109.GA18088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161121183109.GA18088-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 21, 2016 at 11:31:09AM -0700, Jason Gunthorpe wrote:
> This is a regression when this code was reworked and made the error
> print unconditional. The original code deliberately suppressed printing
> of the first error message so it could quietly sense
> TPM_ERR_INVALID_POSTINIT.
> 
> Fixes: a502feb67b47 ("tpm: Clean up reading of timeout and duration capabilities")
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks for spotting this out. I'll apply this tomorrow (i.e. not
tonight) as it does not endager stability in anyway as I test the
other fixes.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index a2688ac2b48f3c..c90f4f6d7871be 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -523,8 +523,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  		return 0;
>  	}
>  
> -	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> -			"attempting to determine the timeouts");
> +	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL);
>  	if (rc == TPM_ERR_INVALID_POSTINIT) {
>  		/* The TPM is not started, we are the first to talk to it.
>  		   Execute a startup command. */
> @@ -535,8 +534,12 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
>  				"attempting to determine the timeouts");
>  	}
> -	if (rc)
> +	if (rc) {
> +		dev_err(&chip->dev,
> +			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
> +			rc);
>  		return rc;
> +	}
>  
>  	old_timeout[0] = be32_to_cpu(cap.timeout.a);
>  	old_timeout[1] = be32_to_cpu(cap.timeout.b);
> -- 
> 2.1.4

------------------------------------------------------------------------------
