From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 1/2] tpm: enhance read_log_of() to
 support Physical TPM event log
Date: Tue, 29 Nov 2016 15:07:53 +0530
Message-ID: <583D4C71.9070201@linux.vnet.ibm.com>
References: <1480164339-26409-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1480164339-26409-2-git-send-email-nayna@linux.vnet.ibm.com>
	<20161126161522.umra77n3yqbpwn5u@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161126161522.umra77n3yqbpwn5u-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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



On 11/26/2016 09:45 PM, Jarkko Sakkinen wrote:
> On Sat, Nov 26, 2016 at 07:45:38AM -0500, Nayna Jain wrote:
>> Physical TPMs use Open Firmware Device Tree bindings that are similar
>> to the IBM Power virtual TPM to support event log. However, these
>> properties store the values in different endianness for Physical
>> and Virtual TPM.
>>
>> This patch fixes the endianness issue by doing appropriate conversion
>> based on Physical or Virtual TPM.
>>
>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   drivers/char/tpm/tpm_of.c | 27 +++++++++++++++++++++++----
>>   1 file changed, 23 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
>> index 7dee42d7..4b0d5e6 100644
>> --- a/drivers/char/tpm/tpm_of.c
>> +++ b/drivers/char/tpm/tpm_of.c
>> @@ -27,6 +27,8 @@ int tpm_read_log_of(struct tpm_chip *chip)
>>   	const u32 *sizep;
>>   	const u64 *basep;
>>   	struct tpm_bios_log *log;
>> +	u32 log_size;
>> +	u64 log_base;
>
> Maybe just base and size?

Hmm.. okay to keep names short, I can change to base/size. And since 
they are used within log function, probably it is implicit that, these 
refer to Log  base address and size.

>
>>
>>   	log = &chip->log;
>>   	if (chip->dev.parent && chip->dev.parent->of_node)
>> @@ -41,18 +43,35 @@ int tpm_read_log_of(struct tpm_chip *chip)
>>   	if (sizep == NULL || basep == NULL)
>>   		return -EIO;
>>
>> -	if (*sizep == 0) {
>> +	/*
>> +	 * For both vtpm/tpm, firmware has log addr and log size in big
>> +	 * endian format. But in case of vtpm, there is a method called
>> +	 * sml-handover which is run during kernel init even before
>> +	 * device tree is setup. This sml-handover function takes care
>> +	 * of endianness and writes to sml-base and sml-size in little
>> +	 * endian format. For this reason, vtpm doesn't need conversion
>> +	 * but physical tpm needs the conversion.
>> +	 */
>> +	if (of_property_match_string(np, "compatible", "IBM,vtpm") < 0) {
>> +		log_size = be32_to_cpup(sizep);
>> +		log_base = be64_to_cpup(basep);
>> +	} else {
>> +		log_size = *sizep;
>> +		log_base = *basep;
>> +	}
>> +
>> +	if (log_size == 0) {
>>   		dev_warn(&chip->dev, "%s: Event log area empty\n", __func__);
>>   		return -EIO;
>>   	}
>>
>> -	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
>> +	log->bios_event_log = kmalloc(log_size, GFP_KERNEL);
>>   	if (!log->bios_event_log)
>>   		return -ENOMEM;
>>
>> -	log->bios_event_log_end = log->bios_event_log + *sizep;
>> +	log->bios_event_log_end = log->bios_event_log + log_size;
>>
>> -	memcpy(log->bios_event_log, __va(*basep), *sizep);
>> +	memcpy(chip->log.bios_event_log, __va(log_base), log_size);
>
> Why did you change the first parameter?

Hmm.. yeah..shouldn't be.  Sorry, I think while redoing, I mixed up with 
my previous versions. Will change it.
Thanks for noticing it.

Thanks & Regards,
    - Nayna

>
>>
>>   	return 0;
>>   }
>> --
>> 2.5.0
>>
>
> /Jarkko
>


------------------------------------------------------------------------------
