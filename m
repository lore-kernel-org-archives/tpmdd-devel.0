From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH v6 1/2] tpm: implement TPM 2.0 capability to
 get active PCR banks
Date: Thu, 26 Jan 2017 07:23:15 -0500
Message-ID: <fbd04459-2f98-8769-415e-9327dec73bd2@linux.vnet.ibm.com>
References: <1484931913-24909-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1484931913-24909-2-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1484931913-24909-2-git-send-email-nayna@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/20/2017 12:05 PM, Nayna Jain wrote:
> This patch implements the TPM 2.0 capability TPM_CAP_PCRS to
> retrieve the active PCR banks from the TPM. This is needed
> to enable extending all active banks as recommended by TPM 2.0
> TCG Specification.
>
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>   drivers/char/tpm/tpm.h      |  5 ++++
>   drivers/char/tpm/tpm2-cmd.c | 59 +++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 64 insertions(+)
>
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 1ae9768..c291f19 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -97,6 +97,7 @@ enum tpm2_return_codes {
>   };
>
>   enum tpm2_algorithms {
> +	TPM2_ALG_ERROR		= 0x0000,
>   	TPM2_ALG_SHA1		= 0x0004,
>   	TPM2_ALG_KEYEDHASH	= 0x0008,
>   	TPM2_ALG_SHA256		= 0x000B,
> @@ -127,6 +128,7 @@ enum tpm2_permanent_handles {
>   };
>
>   enum tpm2_capabilities {
> +	TPM2_CAP_PCRS		= 5,
>   	TPM2_CAP_TPM_PROPERTIES = 6,
>   };
>
> @@ -187,6 +189,8 @@ struct tpm_chip {
>
>   	const struct attribute_group *groups[3];
>   	unsigned int groups_cnt;
> +
> +	u16 active_banks[7];
>   #ifdef CONFIG_ACPI
>   	acpi_handle acpi_dev_handle;
>   	char ppi_version[TPM_PPI_VERSION_LEN + 1];
> @@ -545,4 +549,5 @@ int tpm2_auto_startup(struct tpm_chip *chip);
>   void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
>   unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
>   int tpm2_probe(struct tpm_chip *chip);
> +ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip);
>   #endif
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 6eda239..0e000a3 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -998,3 +998,62 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>   		rc = -ENODEV;
>   	return rc;
>   }
> +
> +struct tpm2_pcr_selection {
> +	__be16  hash_alg;
> +	u8  size_of_select;
> +	u8  pcr_select[3];
> +} __packed;
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
> +	struct tpm2_pcr_selection pcr_selection;
> +	struct tpm_buf buf;
> +	void *marker;
> +	unsigned int count = 0;
> +	int rc;
> +	int i;
> +
> +	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
> +	if (rc)
> +		return rc;
> +
> +	tpm_buf_append_u32(&buf, TPM2_CAP_PCRS);
> +	tpm_buf_append_u32(&buf, 0);
> +	tpm_buf_append_u32(&buf, 1);
> +
> +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0,
> +			      "get tpm pcr allocation");
> +	if (rc < 0)
> +		goto out;
> +
> +	count = be32_to_cpup(
> +		(__be32 *)&buf.data[TPM_HEADER_SIZE + 5]);
> +
> +	if (count > ARRAY_SIZE(chip->active_banks)) {
> +		rc = -ENODEV;
> +		goto out;
> +	}
> +
> +	marker = &buf.data[TPM_HEADER_SIZE + 9];

Now that we are checking access to the returned buffer, we should do an 
additional check here:

end = &buf.data[TPM_HEADER_SIZE + rc];


> +	for (i = 0; i < count; i++) {

if (marker + sizeof(pcr_selection) >= end) {
   rc = -EFAULT;
   goto out;
}


> +		memcpy(&pcr_selection, marker, sizeof(pcr_selection));
> +		chip->active_banks[i] = be16_to_cpu(pcr_selection.hash_alg);
> +		marker = marker + sizeof(struct tpm2_pcr_selection);
> +	}
> +
> +out:
> +	if (count < ARRAY_SIZE(chip->active_banks))

if (rc < 0 || count < ARRAY_SIZE(...))


I can send a separate patch for this. Let me know.

> +		chip->active_banks[count] = TPM2_ALG_ERROR;
> +
> +	tpm_buf_destroy(&buf);
> +
> +	return rc;
> +}


