From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [Linux-ima-devel] [PATCH v2 3/5] tpm: pass multiple digests to
 tpm_pcr_extend()
Date: Tue, 30 May 2017 09:28:58 +0200
Message-ID: <97c6930e-8b4d-9578-e210-68987e4d7503@huawei.com>
References: <20170505142152.29795-1-roberto.sassu@huawei.com>
 <20170505142152.29795-4-roberto.sassu@huawei.com>
 <1496114943.3841.480.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1496114943.3841.480.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 5/30/2017 5:29 AM, Mimi Zohar wrote:
> On Fri, 2017-05-05 at 16:21 +0200, Roberto Sassu wrote:
>> The tpm_pcr_extend() definition has been modified to take an array of
>> tpm2_digest structures, and the size of the array as arguments.
>>
>> The function now checks if callers provided a digests for each active
>> PCR bank (or a SHA1 digest for TPM 1.2), to follow the recomendation from
>> the TCG specifications. See commit c1f92b4b04ad ("tpm: enhance TPM 2.0
>> PCR extend to support multiple banks"). All banks should be extended
>> because unused banks could be used by an attacker to hide the true
>> integrity status of the platform.
>>
>> The only allowed exception to the rule above is to pass a SHA1 digest.
>> It has been introduced to maintain compatibility with applications that
>> expect to interact with a TPM 1.2, and provide only a SHA1 digest.
>> In this case, the behavior of tpm_pcr_extend() is unchanged and
>> remaining PCR banks are extended with that digest, padded with zeros.
>>
>> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
>> ---
>> v2
>>
>> - tpm_pcr_extend() arguments checked by tpm_pcr_check_input()
>> - modified parameters of tpm_pcr_extend()
>>
>>  drivers/char/tpm/tpm-interface.c | 76 +++++++++++++++++++++++++++++++++++++---
>>  drivers/char/tpm/tpm.h           |  6 ----
>>  include/linux/tpm.h              | 11 ++++--
>>  3 files changed, 80 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>> index aac703e..4b08b02 100644
>> --- a/drivers/char/tpm/tpm-interface.c
>> +++ b/drivers/char/tpm/tpm-interface.c
>> @@ -867,6 +867,55 @@ static int tpm1_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash,
>>  }
>>
>>  /**
>> + * tpm_pcr_check_input - check digests argument
>> + *
>> + * Return values:
>> + *       1: input correct
>> + *       0: fill digests with SHA1 digest padded with zeros
>> + * -EINVAL: input incorrect
>> + */
>> +static int tpm_pcr_check_input(struct tpm_chip *chip, int count,
>> +			       struct tpm2_digest *digests)
>> +{
>> +	bool sha1_only;
>> +	int found = 0, not_found = 0;
>> +	int i, j;
>> +
>> +	if (count <= 0 || digests == NULL)
>> +		return -EINVAL;
>> +
>> +	sha1_only = (count == 1 && digests[0].alg_id == TPM2_ALG_SHA1);
>> +
>> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
>> +		return sha1_only ? 1 : -EINVAL;
>> +
>> +	if (sha1_only)
>> +		return 0;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(chip->active_banks) &&
>> +	     chip->active_banks[i] != TPM2_ALG_ERROR; i++) {
>> +		for (j = 0; j < count; j++) {
>> +			if (digests[j].alg_id == chip->active_banks[i]) {
>> +				found++;
>> +				break;
>> +			}
>> +		}
>> +
>> +		if (j == count) {
>> +			dev_dbg(&chip->dev, "%s: missing algorithm 0x%X\n",
>> +				__func__, chip->active_banks[i]);
>> +			not_found++;
>> +		}
>> +	}
>> +
>> +	if (not_found == 0 && found != count)
>> +		dev_dbg(&chip->dev,
>> +			"%s: duplicate or unsupported algorithm\n", __func__);
>> +
>> +	return (not_found == 0 && found == count) ? 1 : -EINVAL;
>> +}
>> +
>> +/**
>>   * tpm_pcr_extend - extend pcr value with hash
>>   * @chip_num:	tpm idx # or AN&
>>   * @pcr_idx:	pcr idx to extend
>> @@ -876,29 +925,46 @@ static int tpm1_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash,
>>   * isn't, protect against the chip disappearing, by incrementing
>>   * the module usage count.
>>   */
>> -int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>> +int tpm_pcr_extend(u32 chip_num, int pcr_idx, int count,
>> +		   struct tpm2_digest *digests)
>>  {
>>  	int rc;
>>  	struct tpm_chip *chip;
>>  	struct tpm2_digest digest_list[ARRAY_SIZE(chip->active_banks)];
>> -	u32 count = 0;
>> +	struct tpm2_digest *digests_ptr = digests;
>> +	u32 filled_count = 0;
>> +	u8 *hash;
>>  	int i;
>>
>>  	chip = tpm_chip_find_get(chip_num);
>>  	if (chip == NULL)
>>  		return -ENODEV;
>>
>> -	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>> +	rc = tpm_pcr_check_input(chip, count, digests);
>> +	if (rc < 0) {
>> +		dev_dbg(&chip->dev, "%s: invalid arguments\n", __func__);
>> +		tpm_put_ops(chip);
>
> This rejects the TPM extend, if ANY of the algorithms are unknown.
> Suppose that the standards were updated, TPM vendors add support for
> the new algorithm, but the kernel has not been updated to reflect the
> new algorithms supported.  As the measurement hash already been added
> to the IMA measurement list, verifying the measurement list against a
> TPM quote will fail, not just for the unknown algorithm, but for all
> algorithms.  Something is very broken with this approach.

The alternative is to extend remaining banks with a digest,
for example the first passed by the caller. I will modify
the patch, if everyone agrees on that.

Roberto


>
> Mimi
>
>> +		return rc;
>> +	}
>> +
>> +	hash = digests[0].digest;
>> +
>> +	if (!rc) {
>>  		memset(digest_list, 0, sizeof(digest_list));
>>
>>  		for (i = 0; i < ARRAY_SIZE(chip->active_banks) &&
>>  			    chip->active_banks[i] != TPM2_ALG_ERROR; i++) {
>>  			digest_list[i].alg_id = chip->active_banks[i];
>>  			memcpy(digest_list[i].digest, hash, TPM_DIGEST_SIZE);
>> -			count++;
>> +			filled_count++;
>>  		}
>>
>> -		rc = tpm2_pcr_extend(chip, pcr_idx, count, digest_list);
>> +		digests_ptr = digest_list;
>> +		count = filled_count;
>> +	}
>> +
>> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>> +		rc = tpm2_pcr_extend(chip, pcr_idx, count, digests_ptr);
>>  		tpm_put_ops(chip);
>>  		return rc;
>>  	}
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index b22bc25..6d775c4 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -34,7 +34,6 @@
>>  #include <linux/acpi.h>
>>  #include <linux/cdev.h>
>>  #include <linux/highmem.h>
>> -#include <crypto/hash_info.h>
>>
>>  enum tpm_const {
>>  	TPM_MINOR = 224,	/* officially assigned */
>> @@ -405,11 +404,6 @@ struct tpm_cmd_t {
>>  	tpm_cmd_params	params;
>>  } __packed;
>>
>> -struct tpm2_digest {
>> -	u16 alg_id;
>> -	u8 digest[SHA512_DIGEST_SIZE];
>> -} __packed;
>> -
>>  /* A string buffer type for constructing TPM commands. This is based on the
>>   * ideas of string buffer code in security/keys/trusted.h but is heap based
>>   * in order to keep the stack usage minimal.
>> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
>> index 9ecd12c..5c5a600 100644
>> --- a/include/linux/tpm.h
>> +++ b/include/linux/tpm.h
>> @@ -36,6 +36,11 @@ struct tpm_chip;
>>  struct trusted_key_payload;
>>  struct trusted_key_options;
>>
>> +struct tpm2_digest {
>> +	u16 alg_id;
>> +	u8 digest[SHA512_DIGEST_SIZE];
>> +} __packed;
>> +
>>  enum TPM_OPS_FLAGS {
>>  	TPM_OPS_AUTO_STARTUP = BIT(0),
>>  };
>> @@ -70,7 +75,8 @@ struct tpm_class_ops {
>>
>>  extern int tpm_is_tpm2(u32 chip_num);
>>  extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
>> -extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
>> +extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, int count,
>> +			  struct tpm2_digest *digests);
>>  extern int tpm_pcr_algorithms(u32 chip_num, int count,
>>  			      enum tpm2_algorithms *algorithms);
>>  extern enum hash_algo tpm_pcr_algo_to_crypto(enum tpm2_algorithms tpm_id);
>> @@ -91,7 +97,8 @@ static inline int tpm_is_tpm2(u32 chip_num)
>>  static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
>>  	return -ENODEV;
>>  }
>> -static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
>> +static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, int count,
>> +				 struct tpm2_digest *digests) {
>>  	return -ENODEV;
>>  }
>>  static inline int tpm_pcr_algorithms(u32 chip_num, int count,
>
