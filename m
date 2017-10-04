From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/3] tpm: retrieve digest size of unknown algorithms with
 PCR read
Date: Wed, 4 Oct 2017 14:12:00 +0300
Message-ID: <20171004111200.45fx2vhkjo5jydnj@linux.intel.com>
References: <20170925111950.21511-1-roberto.sassu@huawei.com>
 <20170925111950.21511-3-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170925111950.21511-3-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 25, 2017 at 01:19:49PM +0200, Roberto Sassu wrote:
> PCRs can be extended by providing the TPM algorithm identifier and
> the digest. To correctly build the command buffer, the digest size
> must be known.

Remove the first paragraph. It does not any bring light on what the
commit does and/or why the code change is made. In short, by reading
this paragraph I did not learn anything about the commit.

> The TPM driver cannot determine the digest size if the provided
> TPM algorithm is not mapped to any crypto algorithm. In this case,
> the PCR bank is not extended and could be used by attackers to protect
> measurements made by themselves, which do not reflect the true status
> of the platform.

You are talking about "mapping" without any context. There is a static
mapping inside the driver from crypto IDs to TPM algorithm IDs inside
the driver implementation. You should just say it.

Writing commit messages is very easy. Just write what you are doing and
why you are doing it :-) Do not write anything else.

> To avoid this situation, the digest size of unknown algorithms is
> determined at TPM initialization time with a PCR read, and stored
> in the tpm_chip structure. The array of algorithms (active_banks)
> has been replaced with an array of active_pcr_bank_info, a new structure
> containing both the TPM algorithm identifier and the digest size.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  drivers/char/tpm/tpm-interface.c |  4 +--
>  drivers/char/tpm/tpm.h           |  2 +-
>  drivers/char/tpm/tpm2-cmd.c      | 55 ++++++++++++++++++++++++++++++++--------
>  include/linux/tpm.h              |  5 ++++
>  4 files changed, 52 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 1d6729b..2c3d973 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -914,8 +914,8 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  		memset(digest_list, 0, sizeof(digest_list));
>  
>  		for (i = 0; i < ARRAY_SIZE(chip->active_banks) &&
> -			    chip->active_banks[i] != TPM2_ALG_ERROR; i++) {
> -			digest_list[i].alg_id = chip->active_banks[i];
> +		     chip->active_banks[i].alg_id != TPM2_ALG_ERROR; i++) {
> +			digest_list[i].alg_id = chip->active_banks[i].alg_id;
>  			memcpy(digest_list[i].digest, hash, TPM_DIGEST_SIZE);
>  			count++;
>  		}
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 2d5466a..fb94bd2 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -225,7 +225,7 @@ struct tpm_chip {
>  	const struct attribute_group *groups[3];
>  	unsigned int groups_cnt;
>  
> -	u16 active_banks[7];
> +	struct active_bank_info active_banks[7];
>  #ifdef CONFIG_ACPI
>  	acpi_handle acpi_dev_handle;
>  	char ppi_version[TPM_PPI_VERSION_LEN + 1];
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 0cad0f6..b1356be 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -291,7 +291,6 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
>  	struct tpm2_null_auth_area auth_area;
>  	int rc;
>  	int i;
> -	int j;
>  
>  	if (count > ARRAY_SIZE(chip->active_banks))
>  		return -EINVAL;
> @@ -313,14 +312,10 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
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
> +		/* digests[i].alg_id == chip->active_banks[i].alg_id */

This comment should be removed.

> +		tpm_buf_append_u16(&buf, digests[i].alg_id);
> +		tpm_buf_append(&buf, (const unsigned char *)&digests[i].digest,
> +			       chip->active_banks[i].digest_size);
>  	}
>  
>  	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, 0,
> @@ -943,6 +938,39 @@ int tpm2_probe(struct tpm_chip *chip)
>  }
>  EXPORT_SYMBOL_GPL(tpm2_probe);
>  
> +static int tpm2_init_active_bank_info(struct tpm_chip *chip, u16 alg_id,
> +				      struct active_bank_info *active_bank)
> +{
> +	struct tpm_buf buf;
> +	struct tpm2_pcr_read_out *out;
> +	int rc, i;

One declaration per line.

> +
> +	active_bank->alg_id = alg_id;
> +
> +	for (i = 0; i < ARRAY_SIZE(tpm2_hash_map); i++) {
> +		enum hash_algo crypto_algo = tpm2_hash_map[i].crypto_id;
> +
> +		if (active_bank->alg_id != tpm2_hash_map[i].tpm_id)
> +			continue;
> +
> +		active_bank->digest_size = hash_digest_size[crypto_algo];
> +		return 0;
> +	}
> +
> +	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_PCR_READ);
> +	if (rc)
> +		return rc;
> +
> +	rc = tpm2_pcr_read_common(chip, 0, alg_id, &buf, NULL);
> +	if (rc == 0) {

if (!rc) {

> +		out = (struct tpm2_pcr_read_out *)&buf.data[TPM_HEADER_SIZE];
> +		active_bank->digest_size = be16_to_cpu(out->digest_size);
> +	}
> +
> +	tpm_buf_destroy(&buf);
> +	return 0;
> +}
> +
>  struct tpm2_pcr_selection {
>  	__be16  hash_alg;
>  	u8  size_of_select;
> @@ -997,7 +1025,12 @@ static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
>  		}
>  
>  		memcpy(&pcr_selection, marker, sizeof(pcr_selection));
> -		chip->active_banks[i] = be16_to_cpu(pcr_selection.hash_alg);
> +		rc =  tpm2_init_active_bank_info(chip,
> +					be16_to_cpu(pcr_selection.hash_alg),
> +					&chip->active_banks[i]);
> +		if (rc)
> +			break;
> +
>  		sizeof_pcr_selection = sizeof(pcr_selection.hash_alg) +
>  			sizeof(pcr_selection.size_of_select) +
>  			pcr_selection.size_of_select;
> @@ -1006,7 +1039,7 @@ static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
>  
>  out:
>  	if (i < ARRAY_SIZE(chip->active_banks))
> -		chip->active_banks[i] = TPM2_ALG_ERROR;
> +		chip->active_banks[i].alg_id = TPM2_ALG_ERROR;
>  
>  	tpm_buf_destroy(&buf);
>  
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 5a090f5..3ecce21 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -52,6 +52,11 @@ struct tpm_class_ops {
>  	void (*relinquish_locality)(struct tpm_chip *chip, int loc);
>  };
>  
> +struct active_bank_info {
> +	u16 alg_id;
> +	u16 digest_size;
> +};

"tpm_" prefix is missing.

> +
>  #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
>  
>  extern int tpm_is_tpm2(u32 chip_num);
> -- 
> 2.9.3
> 

/Jarkko
