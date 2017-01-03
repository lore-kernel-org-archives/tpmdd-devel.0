From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] tpm: implement TPM 2.0 capability
 to get active PCR banks
Date: Tue, 3 Jan 2017 20:52:36 +0200
Message-ID: <20170103185236.g4a4wu66ivmtoqad@intel.com>
References: <1483124550-9529-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1483124550-9529-2-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483124550-9529-2-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Dec 30, 2016 at 02:02:29PM -0500, Nayna Jain wrote:
> This patch implements the TPM 2.0 capability TPM_CAP_PCRS to
> retrieve the active PCR banks from the TPM. This is needed
> to enable extending all active banks as recommended by TPM 2.0
> TCG Specification.
> 
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/char/tpm/tpm.h      |  5 +++
>  drivers/char/tpm/tpm2-cmd.c | 79 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 1ae9768..3d8121e 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -43,6 +43,7 @@ enum tpm_const {
>  	TPM_NUM_DEVICES = 65536,
>  	TPM_RETRY = 50,		/* 5 seconds */
>  	TPM_NUM_EVENT_LOG_FILES = 3,
> +	TPM2_MAX_PCR_BANKS = 7,

Remove and use ARRAY_SIZE().

>  };
>  
>  enum tpm_timeout {
> @@ -127,6 +128,7 @@ enum tpm2_permanent_handles {
>  };
>  
>  enum tpm2_capabilities {
> +	TPM2_CAP_PCRS		= 5,
>  	TPM2_CAP_TPM_PROPERTIES = 6,
>  };
>  
> @@ -187,6 +189,8 @@ struct tpm_chip {
>  
>  	const struct attribute_group *groups[3];
>  	unsigned int groups_cnt;
> +
> +	enum tpm2_algorithms active_banks[TPM2_MAX_PCR_BANKS];

u16

>  #ifdef CONFIG_ACPI
>  	acpi_handle acpi_dev_handle;
>  	char ppi_version[TPM_PPI_VERSION_LEN + 1];
> @@ -545,4 +549,5 @@ int tpm2_auto_startup(struct tpm_chip *chip);
>  void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
>  unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
>  int tpm2_probe(struct tpm_chip *chip);
> +ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip);
>  #endif
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 6eda239..dd03fd8 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -83,6 +83,25 @@ struct tpm2_get_tpm_pt_out {
>  	__be32	value;
>  } __packed;
>  
> +struct tpm2_tpms_pcr_selection {
> +	__be16  hash_alg;
> +	u8  size_of_select;
> +	u8  pcr_select[3];
> +} __packed;
> +
> +struct tpm2_getcap_in {
> +	__be32	cap_id;
> +	__be32	property_id;
> +	__be32	property_cnt;
> +} __packed;
> +
> +struct tpm2_getcap_out {
> +	u8	more_data;
> +	__be32  subcap_id;
> +	__be32  count;
> +	char	cap_data[0];
> +} __packed;
> +

Use tpm_buf and remove tpm2_getcap_in.
Remove tpm2_getcap_out.
Remove alignment.

>  struct tpm2_get_random_in {
>  	__be16	size;
>  } __packed;
> @@ -100,6 +119,8 @@ union tpm2_cmd_params {
>  	struct	tpm2_pcr_extend_in	pcrextend_in;
>  	struct	tpm2_get_tpm_pt_in	get_tpm_pt_in;
>  	struct	tpm2_get_tpm_pt_out	get_tpm_pt_out;
> +	struct	tpm2_getcap_in		getcap_in;
> +	struct	tpm2_getcap_out		getcap_out;

Do not put anything into this union. It is deprecated.

>  	struct	tpm2_get_random_in	getrandom_in;
>  	struct	tpm2_get_random_out	getrandom_out;
>  };
> @@ -993,8 +1014,66 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>  		}
>  	}
>  
> +	rc = tpm2_get_pcr_allocation(chip);
> +
>  out:
>  	if (rc > 0)
>  		rc = -ENODEV;
>  	return rc;
>  }
> +
> +#define TPM2_GETCAP_IN_SIZE \
> +	(sizeof(struct tpm_input_header) + sizeof(struct tpm2_getcap_in))
> +
> +static const struct tpm_input_header tpm2_getcap_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(TPM2_GETCAP_IN_SIZE),
> +	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
> +};
> +
> +/**
> + * tpm2_get_pcr_allocation() - get TPM active PCR banks.
> + *
> + * @chip: TPM chip to use.
> + *
> + * Return: Same as with tpm_transmit_cmd.
> + */
> +ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
> +{
> +	struct tpm2_cmd cmd;
> +	struct tpm2_tpms_pcr_selection pcr_selection;
> +	void *marker;
> +	unsigned int count = 0;
> +	int rc;
> +	int i;
> +
> +	cmd.header.in = tpm2_getcap_header;
> +	cmd.params.getcap_in.cap_id = cpu_to_be32(TPM2_CAP_PCRS);
> +	cmd.params.getcap_in.property_id = cpu_to_be32(0);
> +	cmd.params.getcap_in.property_cnt = cpu_to_be32(1);
> +
> +	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
> +			      "get tpm pcr allocation");
> +	if (rc < 0)
> +		goto out;
> +
> +	count = be32_to_cpu(cmd.params.getcap_out.count);
> +	if (count > TPM2_MAX_PCR_BANKS) {
> +		dev_err(&chip->dev,
> +			"%s: Error: Invalid active PCR banks count\n",

"Error:" is redundant.

> +			__func__);
> +		return -ENODEV;
> +	}
> +
> +	marker = &cmd.params.getcap_out.cap_data;
> +	for (i = 0; i < count; i++) {
> +		memcpy(&pcr_selection, marker, sizeof(pcr_selection));
> +		chip->active_banks[i] = be16_to_cpu(pcr_selection.hash_alg);
> +		marker = marker + sizeof(struct tpm2_tpms_pcr_selection);
> +	}
> +
> +out:
> +	if (count < TPM2_MAX_PCR_BANKS)
> +		chip->active_banks[count] = 0;
> +	return rc;
> +}
> -- 
> 2.5.0

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
