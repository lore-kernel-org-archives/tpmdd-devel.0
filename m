From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/4] tpm: introduce
 tpm2_pcr_algo_to_crypto() and tpm2_pcr_algo_from_crypto()
Date: Wed, 5 Apr 2017 15:12:56 +0300
Message-ID: <20170405121256.jyyj474dux5cb62m@intel.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-3-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170329102452.32212-3-roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

On Wed, Mar 29, 2017 at 12:24:50PM +0200, Roberto Sassu wrote:
> Introduce these functions to convert between TPM and crypto algorithm IDs.

Why is this needed?

/Jarkko

> 
> Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 51 ++++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm.h           | 11 ---------
>  drivers/char/tpm/tpm2-cmd.c      | 42 +++++++++------------------------
>  include/linux/tpm.h              | 22 +++++++++++++++++
>  4 files changed, 84 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index bd2128e..0b6cb87 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -328,6 +328,57 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
>  }
>  EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
>  
> +struct tpm2_hash {
> +	unsigned int crypto_id;
> +	unsigned int tpm_id;
> +};
> +
> +static struct tpm2_hash tpm2_hash_map[] = {
> +	{HASH_ALGO_SHA1, TPM2_ALG_SHA1},
> +	{HASH_ALGO_SHA256, TPM2_ALG_SHA256},
> +	{HASH_ALGO_SHA384, TPM2_ALG_SHA384},
> +	{HASH_ALGO_SHA512, TPM2_ALG_SHA512},
> +	{HASH_ALGO_SM3_256, TPM2_ALG_SM3_256},
> +};
> +
> +/**
> + * tpm2_pcr_algo_to_crypto() - convert from TPM ID to crypto ID
> + * @tpm_id:	TPM ID
> + *
> + * Return: crypto ID
> + */
> +enum hash_algo tpm2_pcr_algo_to_crypto(enum tpm2_algorithms tpm_id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tpm2_hash_map); i++) {
> +		if (tpm_id == tpm2_hash_map[i].tpm_id)
> +			return tpm2_hash_map[i].crypto_id;
> +	}
> +
> +	return HASH_ALGO__LAST;
> +}
> +EXPORT_SYMBOL_GPL(tpm2_pcr_algo_to_crypto);
> +
> +/**
> + * tpm2_pcr_algo_from_crypto() - convert from crypto ID to TPM ID
> + * @crypto_id:	crypto ID
> + *
> + * Return: TPM ID
> + */
> +enum tpm2_algorithms tpm2_pcr_algo_from_crypto(enum hash_algo crypto_id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tpm2_hash_map); i++) {
> +		if (crypto_id == tpm2_hash_map[i].crypto_id)
> +			return tpm2_hash_map[i].tpm_id;
> +	}
> +
> +	return TPM2_ALG_ERROR;
> +}
> +EXPORT_SYMBOL_GPL(tpm2_pcr_algo_from_crypto);
> +
>  /**
>   * tmp_transmit - Internal kernel interface to transmit TPM commands.
>   *
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 4937b56..e20f3ae 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -95,17 +95,6 @@ enum tpm2_return_codes {
>  	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
>  };
>  
> -enum tpm2_algorithms {
> -	TPM2_ALG_ERROR		= 0x0000,
> -	TPM2_ALG_SHA1		= 0x0004,
> -	TPM2_ALG_KEYEDHASH	= 0x0008,
> -	TPM2_ALG_SHA256		= 0x000B,
> -	TPM2_ALG_SHA384		= 0x000C,
> -	TPM2_ALG_SHA512		= 0x000D,
> -	TPM2_ALG_NULL		= 0x0010,
> -	TPM2_ALG_SM3_256	= 0x0012,
> -};
> -
>  enum tpm2_command_codes {
>  	TPM2_CC_FIRST		= 0x011F,
>  	TPM2_CC_SELF_TEST	= 0x0143,
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index f4d534c..e2ff95a 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -92,19 +92,6 @@ struct tpm2_cmd {
>  	union tpm2_cmd_params	params;
>  } __packed;
>  
> -struct tpm2_hash {
> -	unsigned int crypto_id;
> -	unsigned int tpm_id;
> -};
> -
> -static struct tpm2_hash tpm2_hash_map[] = {
> -	{HASH_ALGO_SHA1, TPM2_ALG_SHA1},
> -	{HASH_ALGO_SHA256, TPM2_ALG_SHA256},
> -	{HASH_ALGO_SHA384, TPM2_ALG_SHA384},
> -	{HASH_ALGO_SHA512, TPM2_ALG_SHA512},
> -	{HASH_ALGO_SM3_256, TPM2_ALG_SM3_256},
> -};
> -
>  /*
>   * Array with one entry per ordinal defining the maximum amount
>   * of time the chip could take to return the result. The values
> @@ -321,7 +308,6 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
>  	struct tpm2_null_auth_area auth_area;
>  	int rc;
>  	int i;
> -	int j;
>  
>  	if (count > ARRAY_SIZE(chip->active_banks))
>  		return -EINVAL;
> @@ -346,14 +332,15 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
>  	tpm_buf_append_u32(&buf, count);
>  
>  	for (i = 0; i < count; i++) {
> -		for (j = 0; j < ARRAY_SIZE(tpm2_hash_map); j++) {
> -			if (digests[i].alg_id != tpm2_hash_map[j].tpm_id)
> -				continue;
> -			tpm_buf_append_u16(&buf, digests[i].alg_id);
> -			tpm_buf_append(&buf, (const unsigned char
> -					      *)&digests[i].digest,
> -			       hash_digest_size[tpm2_hash_map[j].crypto_id]);
> -		}
> +		enum tpm2_algorithms tpm_id = digests[i].alg_id;
> +		enum hash_algo crypto_id = tpm2_pcr_algo_to_crypto(tpm_id);
> +
> +		if (crypto_id == HASH_ALGO__LAST)
> +			continue;
> +
> +		tpm_buf_append_u16(&buf, digests[i].alg_id);
> +		tpm_buf_append(&buf, (const unsigned char *)&digests[i].digest,
> +			       hash_digest_size[crypto_id]);
>  	}
>  
>  	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, 0,
> @@ -487,17 +474,10 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
>  	unsigned int blob_len;
>  	struct tpm_buf buf;
>  	u32 hash, rlength;
> -	int i;
>  	int rc;
>  
> -	for (i = 0; i < ARRAY_SIZE(tpm2_hash_map); i++) {
> -		if (options->hash == tpm2_hash_map[i].crypto_id) {
> -			hash = tpm2_hash_map[i].tpm_id;
> -			break;
> -		}
> -	}
> -
> -	if (i == ARRAY_SIZE(tpm2_hash_map))
> +	hash = tpm2_pcr_algo_from_crypto(options->hash);
> +	if (hash == TPM2_ALG_ERROR)
>  		return -EINVAL;
>  
>  	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index da158f0..14b4a42 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -37,6 +37,17 @@ enum TPM_OPS_FLAGS {
>  	TPM_OPS_AUTO_STARTUP = BIT(0),
>  };
>  
> +enum tpm2_algorithms {
> +	TPM2_ALG_ERROR		= 0x0000,
> +	TPM2_ALG_SHA1		= 0x0004,
> +	TPM2_ALG_KEYEDHASH	= 0x0008,
> +	TPM2_ALG_SHA256		= 0x000B,
> +	TPM2_ALG_SHA384		= 0x000C,
> +	TPM2_ALG_SHA512		= 0x000D,
> +	TPM2_ALG_NULL		= 0x0010,
> +	TPM2_ALG_SM3_256	= 0x0012,
> +};
> +
>  struct tpm_class_ops {
>  	unsigned int flags;
>  	const u8 req_complete_mask;
> @@ -53,6 +64,8 @@ struct tpm_class_ops {
>  
>  #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
>  
> +extern enum hash_algo tpm2_pcr_algo_to_crypto(enum tpm2_algorithms tpm_id);
> +extern enum tpm2_algorithms tpm2_pcr_algo_from_crypto(enum hash_algo crypto_id);
>  extern int tpm_is_tpm2(u32 chip_num);
>  extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
>  extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
> @@ -65,6 +78,15 @@ extern int tpm_unseal_trusted(u32 chip_num,
>  			      struct trusted_key_payload *payload,
>  			      struct trusted_key_options *options);
>  #else
> +static inline hash_algo tpm2_pcr_algo_to_crypto(enum tpm2_algorithms tpm_id)
> +{
> +	return -ENODEV;
> +}
> +static inline enum tpm2_algorithms tpm2_pcr_algo_from_crypto(
> +						enum hash_algo crypto_id);
> +{
> +	return -ENODEV;
> +}
>  static inline int tpm_is_tpm2(u32 chip_num)
>  {
>  	return -ENODEV;
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
