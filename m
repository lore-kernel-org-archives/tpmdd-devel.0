From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/4] tpm: check whether all digests have
 been provided for TPM 2.0 extend
Date: Wed, 5 Apr 2017 15:12:00 +0300
Message-ID: <20170405121200.rjbojlwchfw43ted@intel.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-2-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170329102452.32212-2-roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 29, 2017 at 12:24:49PM +0200, Roberto Sassu wrote:
> TCG mandates that all PCR banks must be extended during the same operation.
> tpm2_pcr_extend() will check whether all digests have been provided.
> 
> The check is necessary because tpm2_pcr_extend() will be called by a new
> function, allowing callers to provide a digest for each PCR bank.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

When can this happen?

/Jarkko

> ---
>  drivers/char/tpm/tpm2-cmd.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 881aea9..f4d534c 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -284,6 +284,26 @@ struct tpm2_null_auth_area {
>  	__be16  auth_size;
>  } __packed;
>  
> +static bool tpm2_digests_all_banks(struct tpm_chip *chip, u32 count,
> +				   struct tpm2_digest *digests)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < ARRAY_SIZE(chip->active_banks) &&
> +	     chip->active_banks[i] != TPM2_ALG_ERROR; i++) {
> +		for (j = 0; j < count; j++)
> +			if (digests[j].alg_id == chip->active_banks[i])
> +				break;
> +		if (j == count) {
> +			pr_err("missing TPM algorithm 0x%x\n",
> +			       chip->active_banks[i]);
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +

What if 'digests' contains the same 'alg_id' multiple times?

>  /**
>   * tpm2_pcr_extend() - extend a PCR value
>   *
> @@ -306,6 +326,9 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
>  	if (count > ARRAY_SIZE(chip->active_banks))
>  		return -EINVAL;
>  
> +	if (!tpm2_digests_all_banks(chip, count, digests))
> +		return -EINVAL;
> +
>  	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_PCR_EXTEND);
>  	if (rc)
>  		return rc;
> -- 
> 2.9.3
> 
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, Slashdot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
