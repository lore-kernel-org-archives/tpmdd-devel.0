From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 2/2] tpm: enhance TPM 2.0 PCR extend to
 support multiple banks
Date: Tue, 24 Jan 2017 18:34:54 +0530
Message-ID: <588750F6.8070801@linux.vnet.ibm.com>
References: <1484931913-24909-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1484931913-24909-3-git-send-email-nayna@linux.vnet.ibm.com>
	<20170123151907.ki2bqt5dlmbvl2ol@intel.com>
	<5886324C.1090005@linux.vnet.ibm.com>
	<20170124115937.s6folc7x4nxgxuv6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170124115937.s6folc7x4nxgxuv6-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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



On 01/24/2017 05:29 PM, Jarkko Sakkinen wrote:
> On Mon, Jan 23, 2017 at 10:11:48PM +0530, Nayna wrote:
>>
>>
>> On 01/23/2017 08:49 PM, Jarkko Sakkinen wrote:
>>> On Fri, Jan 20, 2017 at 12:05:13PM -0500, Nayna Jain wrote:
>>>> The current TPM 2.0 device driver extends only the SHA1 PCR bank
>>>> but the TCG Specification[1] recommends extending all active PCR
>>>> banks, to prevent malicious users from setting unused PCR banks with
>>>> fake measurements and quoting them.
>>>>
>>>> The existing in-kernel interface(tpm_pcr_extend()) expects only a
>>>> SHA1 digest.  To extend all active PCR banks with differing
>>>> digest sizes, the SHA1 digest is padded with trailing 0's as needed.
>>>>
>>>> This patch reuses the defined digest sizes from the crypto subsystem,
>>>> adding a dependency on CRYPTO_HASH_INFO module.
>>>>
>>>> [1] TPM 2.0 Specification referred here is "TCG PC Client Specific
>>>> Platform Firmware Profile for TPM 2.0"
>>>>
>>>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>>> ---
>>>>    drivers/char/tpm/Kconfig         |  1 +
>>>>    drivers/char/tpm/tpm-interface.c | 15 ++++++-
>>>>    drivers/char/tpm/tpm.h           |  3 +-
>>>>    drivers/char/tpm/tpm2-cmd.c      | 91 +++++++++++++++++++++-------------------
>>>>    drivers/char/tpm/tpm_eventlog.h  |  7 ++++
>>>>    5 files changed, 73 insertions(+), 44 deletions(-)
>>>>
>>>> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
>>>> index 277186d..af985cc 100644
>>>> --- a/drivers/char/tpm/Kconfig
>>>> +++ b/drivers/char/tpm/Kconfig
>>>> @@ -6,6 +6,7 @@ menuconfig TCG_TPM
>>>>    	tristate "TPM Hardware Support"
>>>>    	depends on HAS_IOMEM
>>>>    	select SECURITYFS
>>>> +	select CRYPTO_HASH_INFO
>>>>    	---help---
>>>>    	  If you have a TPM security chip in your system, which
>>>>    	  implements the Trusted Computing Group's specification,
>>>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>>>> index a3461cb..cf959c3 100644
>>>> --- a/drivers/char/tpm/tpm-interface.c
>>>> +++ b/drivers/char/tpm/tpm-interface.c
>>>> @@ -772,13 +772,26 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>>>>    	struct tpm_cmd_t cmd;
>>>>    	int rc;
>>>>    	struct tpm_chip *chip;
>>>> +	int max_active_banks = ARRAY_SIZE(chip->active_banks);
>>>> +	struct tpm2_digest digest_list[max_active_banks];
>>>> +	u32 count = 0;
>>>> +	int i;
>>>>
>>>>    	chip = tpm_chip_find_get(chip_num);
>>>>    	if (chip == NULL)
>>>>    		return -ENODEV;
>>>>
>>>>    	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>>>> -		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
>>>> +		memset(digest_list, 0, sizeof(digest_list));
>>>> +
>>>> +		for (i = 0; (chip->active_banks[i] != TPM2_ALG_ERROR) &&
>>>> +		     (i < max_active_banks); i++) {
>>>> +			digest_list[i].alg_id = chip->active_banks[i];
>>>> +			memcpy(digest_list[i].digest, hash, TPM_DIGEST_SIZE);
>>>> +			count++;
>>>> +		}
>>>> +
>>>> +		rc = tpm2_pcr_extend(chip, pcr_idx, count, digest_list);
>>>>    		tpm_put_ops(chip);
>>>>    		return rc;
>>>>    	}
>>>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>>>> index c291f19..07a0677 100644
>>>> --- a/drivers/char/tpm/tpm.h
>>>> +++ b/drivers/char/tpm/tpm.h
>>>> @@ -534,7 +534,8 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
>>>>    #endif
>>>>
>>>>    int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
>>>> -int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
>>>> +int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
>>>> +		    struct tpm2_digest *digests);
>>>>    int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
>>>>    int tpm2_seal_trusted(struct tpm_chip *chip,
>>>>    		      struct trusted_key_payload *payload,
>>>> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
>>>> index 0e000a3..d78adb8 100644
>>>> --- a/drivers/char/tpm/tpm2-cmd.c
>>>> +++ b/drivers/char/tpm/tpm2-cmd.c
>>>> @@ -53,22 +53,6 @@ struct tpm2_pcr_read_out {
>>>>    	u8	digest[TPM_DIGEST_SIZE];
>>>>    } __packed;
>>>>
>>>> -struct tpm2_null_auth_area {
>>>> -	__be32			handle;
>>>> -	__be16			nonce_size;
>>>> -	u8			attributes;
>>>> -	__be16			auth_size;
>>>> -} __packed;
>>>> -
>>>> -struct tpm2_pcr_extend_in {
>>>> -	__be32				pcr_idx;
>>>> -	__be32				auth_area_size;
>>>> -	struct tpm2_null_auth_area	auth_area;
>>>> -	__be32				digest_cnt;
>>>> -	__be16				hash_alg;
>>>> -	u8				digest[TPM_DIGEST_SIZE];
>>>> -} __packed;
>>>> -
>>>>    struct tpm2_get_tpm_pt_in {
>>>>    	__be32	cap_id;
>>>>    	__be32	property_id;
>>>> @@ -97,7 +81,6 @@ union tpm2_cmd_params {
>>>>    	struct	tpm2_self_test_in	selftest_in;
>>>>    	struct	tpm2_pcr_read_in	pcrread_in;
>>>>    	struct	tpm2_pcr_read_out	pcrread_out;
>>>> -	struct	tpm2_pcr_extend_in	pcrextend_in;
>>>>    	struct	tpm2_get_tpm_pt_in	get_tpm_pt_in;
>>>>    	struct	tpm2_get_tpm_pt_out	get_tpm_pt_out;
>>>>    	struct	tpm2_get_random_in	getrandom_in;
>>>> @@ -290,46 +273,68 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>>>>    	return rc;
>>>>    }
>>>>
>>>> -#define TPM2_GET_PCREXTEND_IN_SIZE \
>>>> -	(sizeof(struct tpm_input_header) + \
>>>> -	 sizeof(struct tpm2_pcr_extend_in))
>>>> -
>>>> -static const struct tpm_input_header tpm2_pcrextend_header = {
>>>> -	.tag = cpu_to_be16(TPM2_ST_SESSIONS),
>>>> -	.length = cpu_to_be32(TPM2_GET_PCREXTEND_IN_SIZE),
>>>> -	.ordinal = cpu_to_be32(TPM2_CC_PCR_EXTEND)
>>>> -};
>>>> +struct tpm2_null_auth_area {
>>>> +	__be32  handle;
>>>> +	__be16  nonce_size;
>>>> +	u8  attributes;
>>>> +	__be16  auth_size;
>>>> +} __packed;
>>>>
>>>>    /**
>>>>     * tpm2_pcr_extend() - extend a PCR value
>>>>     *
>>>>     * @chip:	TPM chip to use.
>>>>     * @pcr_idx:	index of the PCR.
>>>> - * @hash:	hash value to use for the extend operation.
>>>> + * @count:	number of digests passed.
>>>> + * @digests:	list of pcr banks and corresponding digest values to extend.
>>>>     *
>>>>     * Return: Same as with tpm_transmit_cmd.
>>>>     */
>>>> -int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
>>>> +int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
>>>> +		    struct tpm2_digest *digests)
>>>>    {
>>>> -	struct tpm2_cmd cmd;
>>>> +	struct tpm_buf buf;
>>>> +	struct tpm2_null_auth_area auth_area;
>>>>    	int rc;
>>>> +	int i;
>>>> +	int j;
>>>> +
>>>> +	if (count > ARRAY_SIZE(chip->active_banks))
>>>> +		return -EINVAL;
>>>>
>>>> -	cmd.header.in = tpm2_pcrextend_header;
>>>> -	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
>>>> -	cmd.params.pcrextend_in.auth_area_size =
>>>> -		cpu_to_be32(sizeof(struct tpm2_null_auth_area));
>>>> -	cmd.params.pcrextend_in.auth_area.handle =
>>>> -		cpu_to_be32(TPM2_RS_PW);
>>>> -	cmd.params.pcrextend_in.auth_area.nonce_size = 0;
>>>> -	cmd.params.pcrextend_in.auth_area.attributes = 0;
>>>> -	cmd.params.pcrextend_in.auth_area.auth_size = 0;
>>>> -	cmd.params.pcrextend_in.digest_cnt = cpu_to_be32(1);
>>>> -	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
>>>> -	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
>>>> +	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_PCR_EXTEND);
>>>> +	if (rc)
>>>> +		return rc;
>>>>
>>>> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
>>>> +	tpm_buf_append_u32(&buf, pcr_idx);
>>>> +
>>>> +	auth_area.handle = cpu_to_be32(TPM2_RS_PW);
>>>> +	auth_area.nonce_size = 0;
>>>> +	auth_area.attributes = 0;
>>>> +	auth_area.auth_size = 0;
>>>> +
>>>> +	tpm_buf_append_u32(&buf, sizeof(struct tpm2_null_auth_area));
>>>> +	tpm_buf_append(&buf, (const unsigned char *)&auth_area,
>>>> +		       sizeof(auth_area));
>>>> +	tpm_buf_append_u32(&buf, count);
>>>> +
>>>> +	for (i = 0; i < count; i++) {
>>>> +		for (j = 0; j < ARRAY_SIZE(tpm2_hash_map); j++) {
>>>> +			if (digests[i].alg_id != tpm2_hash_map[j].tpm_id)
>>>> +				continue;
>>>> +
>>>> +			tpm_buf_append_u16(&buf, digests[i].alg_id);
>>>> +			tpm_buf_append(&buf, (const unsigned char
>>>> +					      *)&digests[i].digest,
>>>> +				hash_digest_size[tpm2_hash_map[j].crypto_id]);
>>>> +		}
>>>> +	}
>>>> +
>>>> +	rc = tpm_transmit_cmd(chip, buf.data, tpm_buf_length(&buf), 0,
>>>>    			      "attempting extend a PCR value");
>>>>
>>>> +	tpm_buf_destroy(&buf);
>>>> +
>>>>    	return rc;
>>>>    }
>>>>
>>>> @@ -993,6 +998,8 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>>>>    		}
>>>>    	}
>>>>
>>>> +	rc = tpm2_get_pcr_allocation(chip);
>>>> +
>>>>    out:
>>>>    	if (rc > 0)
>>>>    		rc = -ENODEV;
>>>> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
>>>> index 1660d74..b5ae372 100644
>>>> --- a/drivers/char/tpm/tpm_eventlog.h
>>>> +++ b/drivers/char/tpm/tpm_eventlog.h
>>>> @@ -2,6 +2,8 @@
>>>>    #ifndef __TPM_EVENTLOG_H__
>>>>    #define __TPM_EVENTLOG_H__
>>>>
>>>> +#include <crypto/hash_info.h>
>>>> +
>>>>    #define TCG_EVENT_NAME_LEN_MAX	255
>>>>    #define MAX_TEXT_EVENT		1000	/* Max event string length */
>>>>    #define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
>>>> @@ -73,6 +75,11 @@ enum tcpa_pc_event_ids {
>>>>    	HOST_TABLE_OF_DEVICES,
>>>>    };
>>>>
>>>> +struct tpm2_digest {
>>>> +	u16 alg_id;
>>>> +	u8 digest[SHA512_DIGEST_SIZE];
>>>> +} __packed;
>>>
>>> Shouldn't this be in tpm.h?
>>
>> This is a struct common for TPM 2.0 extend and eventlog structure i.e
>> struct tcg_pcr_event2.
>> And so I preferred to place it here.
>>
>
> If it is common, why is it in tpm_eventlog.h and not in tpm.h?

Hmm, the way I took it was that all event log structs are in 
tpm_eventlog.h. So, I have defined all structs related to event log into 
tpm_eventlog.h, including this one.

Also, currently, tpm_eventlog.h has no dependency on tpm.h, but tpm.h 
does include tpm_eventlog.h.

Hmm.. is it an issue to have it in tpm_eventlog.h ?

Thanks & Regards,
    - Nayna

>
>> Thanks & Regards,
>>    - Nayna
>
> /Jarkko
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
