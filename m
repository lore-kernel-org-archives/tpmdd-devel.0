From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH] tpm: use test_bit() to check TPM2 flag in eventlog and
 sysfs code
Date: Tue, 22 Nov 2016 14:32:00 +0530
Message-ID: <58340988.9000700@linux.vnet.ibm.com>
References: <1479715431-11983-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20161121195508.6urrvuhmlt2oo5d7@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161121195508.6urrvuhmlt2oo5d7@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 11/22/2016 01:25 AM, Jarkko Sakkinen wrote:
> On Mon, Nov 21, 2016 at 03:03:51AM -0500, Nayna Jain wrote:
>> There is change done to introduce atomic bitops to set and test
>> chip->flags.
>> This patch fixes tpm_bios_log_setup() and tpm_sysfs_add_device()
>> to use test_bit() to check for TPM_CHIP_FLAG_TPM2 flag.
>>
>> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
>
> I'm bit lost of the purpose of this patch.

I was using tabrm branch which has changes related to using bitops for 
chip->flags, but it was failing for TPM2 check in tpm_bios_log_setup() 
with the existing way of checking. Replacing existing one with 
test_bit() check makes it work. Same in case of tpm_sysfs_add_device().

Thanks & Regards,
   - Nayna

>
> /Jarkko
>
>> ---
>>   drivers/char/tpm/tpm-sysfs.c    | 2 +-
>>   drivers/char/tpm/tpm_eventlog.c | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
>> index 82298e51..9a37c26 100644
>> --- a/drivers/char/tpm/tpm-sysfs.c
>> +++ b/drivers/char/tpm/tpm-sysfs.c
>> @@ -284,7 +284,7 @@ static const struct attribute_group tpm_dev_group = {
>>
>>   void tpm_sysfs_add_device(struct tpm_chip *chip)
>>   {
>> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> +	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
>>   		return;
>>
>>   	/* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
>> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
>> index ebec4ac..dede2ec 100644
>> --- a/drivers/char/tpm/tpm_eventlog.c
>> +++ b/drivers/char/tpm/tpm_eventlog.c
>> @@ -391,7 +391,7 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>>   	unsigned int cnt;
>>   	int rc = 0;
>>
>> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> +	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
>>   		return 0;
>>
>>   	rc = tpm_read_log(chip);
>> --
>> 2.5.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

