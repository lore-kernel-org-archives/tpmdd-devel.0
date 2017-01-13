From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 1/2] tpm: implement TPM 2.0 capability
 to get active PCR banks
Date: Fri, 13 Jan 2017 12:54:12 +0530
Message-ID: <5878809C.8020408@linux.vnet.ibm.com>
References: <1484240290-4306-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1484240290-4306-2-git-send-email-nayna@linux.vnet.ibm.com>
	<20170112182507.w5lpzupqw4hwhtfn@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170112182507.w5lpzupqw4hwhtfn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 01/12/2017 11:55 PM, Jarkko Sakkinen wrote:
> On Thu, Jan 12, 2017 at 11:58:09AM -0500, Nayna Jain wrote:
>> This patch implements the TPM 2.0 capability TPM_CAP_PCRS to
>> retrieve the active PCR banks from the TPM. This is needed
>> to enable extending all active banks as recommended by TPM 2.0
>> TCG Specification.
>>
>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   drivers/char/tpm/tpm.h      |  4 +++
>>   drivers/char/tpm/tpm2-cmd.c | 59 +++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 63 insertions(+)
>>
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 1ae9768..dddd573 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -127,6 +127,7 @@ enum tpm2_permanent_handles {
>>   };
>>
>>   enum tpm2_capabilities {
>> +	TPM2_CAP_PCRS		= 5,
>>   	TPM2_CAP_TPM_PROPERTIES = 6,
>>   };
>>
>> @@ -187,6 +188,8 @@ struct tpm_chip {
>>
>>   	const struct attribute_group *groups[3];
>>   	unsigned int groups_cnt;
>> +
>> +	u16 active_banks[7];
>>   #ifdef CONFIG_ACPI
>>   	acpi_handle acpi_dev_handle;
>>   	char ppi_version[TPM_PPI_VERSION_LEN + 1];
>> @@ -545,4 +548,5 @@ int tpm2_auto_startup(struct tpm_chip *chip);
>>   void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
>>   unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
>>   int tpm2_probe(struct tpm_chip *chip);
>> +ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip);
>>   #endif
>> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
>> index 6eda239..87388921 100644
>> --- a/drivers/char/tpm/tpm2-cmd.c
>> +++ b/drivers/char/tpm/tpm2-cmd.c
>> @@ -83,6 +83,12 @@ struct tpm2_get_tpm_pt_out {
>>   	__be32	value;
>>   } __packed;
>>
>> +struct tpm2_tpms_pcr_selection {
>> +	__be16  hash_alg;
>> +	u8  size_of_select;
>> +	u8  pcr_select[3];
>> +} __packed;
>
> Please move this right before tpm2_get_pcr_allocation.
> Drop 'tpms_'.

Sure, will do this. But didn't understand why. I think all structs are 
defined in start of file..

Thanks & Regards,
    - Nayna

>
>> +
>>   struct tpm2_get_random_in {
>>   	__be16	size;
>>   } __packed;
>> @@ -993,8 +999,61 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>>   		}
>>   	}
>>
>> +	rc = tpm2_get_pcr_allocation(chip);
>> +
>
> Please have this call in the commit where you actually use it
> Does not make any sense here
>
>>   out:
>>   	if (rc > 0)
>>   		rc = -ENODEV;
>>   	return rc;
>>   }
>> +
>> +/**
>> + * tpm2_get_pcr_allocation() - get TPM active PCR banks.
>> + *
>> + * @chip: TPM chip to use.
>> + *
>> + * Return: Same as with tpm_transmit_cmd.
>> + */
>> +ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
>> +{
>> +	struct tpm2_tpms_pcr_selection pcr_selection;
>> +	struct tpm_buf buf;
>> +	void *marker;
>> +	unsigned int count = 0;
>> +	int rc;
>> +	int i;
>> +
>> +	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
>> +	if (rc)
>> +		return rc;
>> +
>> +	tpm_buf_append_u32(&buf, TPM2_CAP_PCRS);
>> +	tpm_buf_append_u32(&buf, 0);
>> +	tpm_buf_append_u32(&buf, 1);
>> +
>> +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0,
>> +			      "get tpm pcr allocation");
>> +	if (rc < 0)
>> +		goto out;
>> +
>> +	count = be32_to_cpup(
>> +		(__be32 *) &buf.data[TPM_HEADER_SIZE + 5]);
>
> Please do not add a space after cast. This has been an issue in your
> previous patches too so try to do it right next time.
>
>> +
>> +	if (count > ARRAY_SIZE(chip->active_banks))
>> +		return -ENODEV;
>> +
>> +	marker = &buf.data[TPM_HEADER_SIZE + 9];
>> +	for (i = 0; i < count; i++) {
>> +		memcpy(&pcr_selection, marker, sizeof(pcr_selection));
>> +		chip->active_banks[i] = be16_to_cpu(pcr_selection.hash_alg);
>> +		marker = marker + sizeof(struct tpm2_tpms_pcr_selection);
>> +	}
>> +
>> +out:
>> +	if (count < ARRAY_SIZE(chip->active_banks))
>> +		chip->active_banks[count] = 0;
>> +
>> +	tpm_buf_destroy(&buf);
>> +
>> +	return rc;
>> +}
>> --
>> 2.5.0
>>
>
> /Jarkko
>


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
