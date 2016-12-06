From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 2/2] tpm: add securityfs support for
 TPM 2.0 firmware event log
Date: Tue, 6 Dec 2016 15:53:17 +0530
Message-ID: <58469195.2070202@linux.vnet.ibm.com>
References: <1480164339-26409-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1480164339-26409-3-git-send-email-nayna@linux.vnet.ibm.com>
	<20161126154755.56goahgkjf5n67ay@intel.com>
	<583F0554.1030107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <583F0554.1030107-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 11/30/2016 10:29 PM, Nayna wrote:
>
>
> On 11/26/2016 09:17 PM, Jarkko Sakkinen wrote:
>> On Sat, Nov 26, 2016 at 07:45:39AM -0500, Nayna Jain wrote:
>>> Unlike the device driver support for TPM 1.2, the TPM 2.0 does
>>> not support the securityfs pseudo files for displaying the
>>> firmware event log.
>>>
>>> This patch enables support for providing the TPM 2.0 event log in
>>> binary form. TPM 2.0 event log supports a crypto agile format that
>>> records multiple digests, which is different from TPM 1.2. This
>>> patch enables the tpm_bios_log_setup for TPM 2.0  and adds the
>>> event log parser which understand the TPM 2.0 crypto agile format.
>>>
>>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

>>> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
>>> index 1660d74..7e33b90 100644
>>> --- a/drivers/char/tpm/tpm_eventlog.h
>>> +++ b/drivers/char/tpm/tpm_eventlog.h
>>> @@ -5,6 +5,9 @@
>>>    #define TCG_EVENT_NAME_LEN_MAX	255
>>>    #define MAX_TEXT_EVENT		1000	/* Max event string length */
>>>    #define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
>>> +#define HASH_COUNT		3
>>> +#define MAX_TPM_LOG_MSG		128
>>> +#define MAX_DIGEST_SIZE		64
>>
>> Where have been the values for these constants derived? You should
>> anyway prefix them with TPM_.
>
> HASH_COUNT is to represent multiple active banks at a time, where SHA1
> and SHA256 are the ones, I kept it 3 with assumption of SHA384/SHA512.
> And with that, I kept MAX_DIGEST_SIZE as 64.
>
> MAX_TPM_LOG_MSG was an assumption by me. I think TCG Spec says max value
> can be 1MB.
>
> I would actually like to know the views on this.

I would like to know your and Jason views on the above given reasoning 
related to how values for these constants are derived.

Thanks & Regards,
    - Nayna

>
>>
>>>    #ifdef CONFIG_PPC64
>>>    #define do_endian_conversion(x) be32_to_cpu(x)
>>> @@ -73,6 +76,73 @@ enum tcpa_pc_event_ids {
>>>    	HOST_TABLE_OF_DEVICES,
>>>    };
>>>
>>> +/*
>>> + * All the structures related to TPM 2.0 Event Log are taken from TCG EFIi
>>> + * Protocol * Specification, Family "2.0". Document is available on link
>>> + * http://www.trustedcomputinggroup.org/tcg-efi-protocol-specification/
>>> + * Information is also available on TCG PC Client Platform Firmware Profile
>>> + * Specification, Family "2.0"
>>> + * Detailed digest structures for TPM 2.0 are defined in document
>>> + * Trusted Platform Module Library Part 2: Structures, Family "2.0".
>>> + */
>>> +
>>> +/* TPM 2.0 Event log header algorithm spec. */
>>> +struct tcg_efi_specid_event_algs {
>>> +	u16     alg_id;
>>> +	u16     digest_size;
>>> +} __packed;
>>> +
>>> +/* TPM 2.0 Event log header data. */
>>> +struct tcg_efi_specid_event {
>>> +	u8      signature[16];
>>> +	u32     platform_class;
>>> +	u8      spec_version_minor;
>>> +	u8      spec_version_major;
>>> +	u8      spec_errata;
>>> +	u8      uintnsize;
>>> +	u32     num_algs;
>>> +	struct tcg_efi_specid_event_algs   digest_sizes[HASH_COUNT];
>>> +	u8      vendor_info_size;
>>> +	u8      vendor_info[0];
>>> +} __packed;
>>> +
>>> +/* TPM 2.0 Event Log Header. */
>>> +struct tcg_pcr_event {
>>> +	u32     pcr_idx;
>>> +	u32     event_type;
>>> +	u8      digest[20];
>>> +	u32     event_size;
>>> +	u8      event[MAX_TPM_LOG_MSG];
>>> +} __packed;
>>> +
>>> +/* TPM 2.0 Crypto agile algorithm and respective digest. */
>>> +struct tpmt_ha {
>>> +	u16     alg_id;
>>> +	u8      digest[MAX_DIGEST_SIZE];
>>> +} __packed;
>>> +
>>> +/* TPM 2.0 Crypto agile digests list. */
>>> +struct tpml_digest_values {
>>> +	u32     count;
>>> +	struct tpmt_ha  digests[HASH_COUNT];
>>> +} __packed;
>>> +
>>> +/* TPM 2.0 Event field structure. */
>>> +struct tcg_event_field {
>>> +	u32     event_size;
>>> +	u8      event[MAX_TPM_LOG_MSG];
>>> +} __packed;
>>> +
>>> +/* TPM 2.0 Crypto agile log entry format. */
>>> +struct tcg_pcr_event2 {
>>> +	u32     pcr_idx;
>>> +	u32     event_type;
>>> +	struct tpml_digest_values digests;
>>> +	struct tcg_event_field  event;
>>> +} __packed;
>>
>> Your alignment is broken. You sometimes align and sometimes do not.
>>
>> For struct fields it does not make sense align fields at all since it
>> does not "scale". It is done in some places in the driver but for new
>> code it is absolutely disallowed. Thus, the right way to fix this is to
>> remove all the aligment.
>>
>> For enums it does make sense and improves readability.
>
> Ok. I didn't change anything in this from previous version, not sure now
> why it looks different. Will verify that.
> I remembered your feedback for my first version. So, now I don't have
> any alignment done for full struct, but have field a tab away from the type.
>
> Thanks & Regards,
>      - Nayna
>>> +
>>> +extern const struct seq_operations tpm2_binary_b_measurements_seqops;
>>> +
>>>    #if defined(CONFIG_ACPI)
>>>    int tpm_read_log_acpi(struct tpm_chip *chip);
>>>    #else
>>> --
>>> 2.5.0
>>
>> /Jarkko
>>
>
>
> ------------------------------------------------------------------------------
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/xeonphi
