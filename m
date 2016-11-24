From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 2/3] tpm: enhance read_log_of() to support Physical TPM
 event log
Date: Thu, 24 Nov 2016 13:23:51 +0530
Message-ID: <58369C8F.5000800@linux.vnet.ibm.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479922057-8752-3-git-send-email-nayna@linux.vnet.ibm.com>
 <20161123193700.GA13927@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161123193700.GA13927@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 11/24/2016 01:07 AM, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2016 at 12:27:36PM -0500, Nayna Jain wrote:
>>   	sizep = of_get_property(np, "linux,sml-size", NULL);
>> +	if (of_property_match_string(np, "compatible", "IBM,vtpm") < 0)
>> +		log_size = be32_to_cpup(sizep);
>> +	else
>> +		log_size = *sizep;
>> +
>
> Uh, no, sizep can be null at this point:

Oops !! Missed the basic. Will fix it. Sorry, and Thanks for noticing.

>
>>   	basep = of_get_property(np, "linux,sml-base", NULL);
>>   	if (sizep == NULL && basep == NULL)
>>   		return -ENODEV;
>>   	if (sizep == NULL || basep == NULL)
>>   		return -EIO;
>
> Move the if here.

Yeah..

>
>> -	if (*sizep == 0) {
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
>> +	if (of_property_match_string(np, "compatible", "IBM,vtpm") < 0)
>> +		memcpy(chip->log.bios_event_log, __va(be64_to_cpup(basep)),
>> +		       log_size);
>> +	else
>> +		memcpy(chip->log.bios_event_log, __va(*basep),
>> log_size);
>
> And move the conditional swap of basep up to be along side sizep as
> well (ie get rid of the second of_property_match_string)
>

Yeah.. true.. Will fix this also.

Thanks & Regards,
    - Nayna

> Jason
>

