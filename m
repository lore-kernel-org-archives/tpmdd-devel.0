From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 3/4] tpm: introduce tpm_pcr_algorithms()
Date: Wed, 5 Apr 2017 15:13:31 +0300
Message-ID: <20170405121331.w5njxsf3nrztvlzb@intel.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-4-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170329102452.32212-4-roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

On Wed, Mar 29, 2017 at 12:24:51PM +0200, Roberto Sassu wrote:
> Return the algorithms supported by the TPM. The limit
> (TPM_ACTIVE_BANKS_MAX) has been exported to include/linux/tpm.h.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Why is this needed?

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 39 +++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm.h           |  2 +-
>  include/linux/tpm.h              |  8 ++++++++
>  3 files changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 0b6cb87..44e7c99 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -876,6 +876,45 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  EXPORT_SYMBOL_GPL(tpm_pcr_extend);
>  
>  /**
> + * tpm_pcr_algorithms - get TPM IDs of active PCR banks algorithms
> + * @chip_num:	tpm idx # or ANY
> + * @algorithms: array of TPM IDs
> + * @algo_num: size of array
> + *
> + * Returns < 0 on error, and the number of active PCR banks on success.
> + */
> +int tpm_pcr_algorithms(u32 chip_num, u32 count,
> +		       enum tpm2_algorithms *algorithms)
> +{
> +	struct tpm_chip *chip;
> +	int rc = -ENODEV;
> +	int i;
> +
> +	chip = tpm_chip_find_get(chip_num);
> +	if (chip == NULL)
> +		return rc;
> +
> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
> +		goto out;
> +
> +	for (i = 0; i < ARRAY_SIZE(chip->active_banks) &&
> +	     chip->active_banks[i] != TPM2_ALG_ERROR; i++) {
> +		if (i >= count) {
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +
> +		algorithms[i] = chip->active_banks[i];
> +	}
> +
> +	rc = i;
> +out:
> +	tpm_put_ops(chip);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(tpm_pcr_algorithms);
> +
> +/**
>   * tpm_do_selftest - have the TPM continue its selftest and wait until it
>   *                   can receive further commands
>   * @chip: TPM chip to use
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index e20f3ae..f15279b 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -183,7 +183,7 @@ struct tpm_chip {
>  	const struct attribute_group *groups[3];
>  	unsigned int groups_cnt;
>  
> -	u16 active_banks[7];
> +	u16 active_banks[TPM_ACTIVE_BANKS_MAX];
>  #ifdef CONFIG_ACPI
>  	acpi_handle acpi_dev_handle;
>  	char ppi_version[TPM_PPI_VERSION_LEN + 1];
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 14b4a42..6552e43 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -23,6 +23,7 @@
>  #define __LINUX_TPM_H__
>  
>  #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
> +#define TPM_ACTIVE_BANKS_MAX 7	/* Max num of active banks for TPM 2.0 */
>  
>  /*
>   * Chip num is this value or a valid tpm idx
> @@ -69,6 +70,8 @@ extern enum tpm2_algorithms tpm2_pcr_algo_from_crypto(enum hash_algo crypto_id);
>  extern int tpm_is_tpm2(u32 chip_num);
>  extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
>  extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
> +extern int tpm_pcr_algorithms(u32 chip_num, u32 count,
> +			      enum tpm2_algorithms *algorithms);
>  extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
>  extern int tpm_get_random(u32 chip_num, u8 *data, size_t max);
>  extern int tpm_seal_trusted(u32 chip_num,
> @@ -97,6 +100,11 @@ static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
>  static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
>  	return -ENODEV;
>  }
> +static inline int tpm_pcr_algorithms(u32 chip_num, u32 count,
> +				     enum tpm2_algorithms *algorithms)
> +{
> +	return -ENODEV;
> +}
>  static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
>  	return -ENODEV;
>  }
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

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
