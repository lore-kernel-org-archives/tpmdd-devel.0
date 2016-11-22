From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after tpm_bios_log_setup
Date: Tue, 22 Nov 2016 14:34:12 +0530
Message-ID: <58340A0C.3050706@linux.vnet.ibm.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20161118155249.sdxp2qfjfzfw4tzt@intel.com>
 <20161119182228.GA22775@obsidianresearch.com>
 <5831ED24.6070102@linux.vnet.ibm.com>
 <20161121171530.GB22237@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161121171530.GB22237@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 11/21/2016 10:45 PM, Jason Gunthorpe wrote:
> On Mon, Nov 21, 2016 at 12:06:20AM +0530, Nayna wrote:
>>>   	rc = tpm_bios_log_setup(chip);
>>> -	if (rc == -ENODEV)
>>> +	if (rc != 0 && rc != -ENODEV)
>>>   		return rc;
>>
>> This will return in case of -EFAULT as well, where the check is that log is
>> already initialized. Do we want to fail the probe here as well ?
>>
>> -EFAULT is returned from tpm_read_log() as below:
>
> That is fine, we should never read the log twice.
>
>>> index fb603a74cbd29e..2a15b866ac257a 100644
>>> +++ b/drivers/char/tpm/tpm_eventlog.c
>>> @@ -377,14 +377,21 @@ static int tpm_read_log(struct tpm_chip *chip)
>>>   	}
>>>
>>>   	rc = tpm_read_log_acpi(chip);
>>
>> This is to understand..
>> It can return -ENOMEM error here, contd below...
>>
>>> -	if ((rc == 0) || (rc == -ENOMEM))
>>> +	if (rc != -ENODEV)
>>>   		return rc;
>>>
>>> -	rc = tpm_read_log_of(chip);
>>> -
>>> -	return rc;
>>> +	return tpm_read_log_of(chip);
>>
>> So, in ACPI if -ENOMEM error is returned, it will continue to
>> tpm_read_log_of(chip), which will return -ENODEV. So, -ENOMEM error is now
>> masked with -ENODEV error.
>
> No, if acpi is -ENOMEM then 'if (rc != -ENODEV)' is true and it
> returns -ENOMEM.

Yeah, I missed it. Sorry.
>
>>>   	sizep = of_get_property(np, "linux,sml-size", NULL);
>>> -	if (sizep == NULL)
>>> +	basep = of_get_property(np, "linux,sml-base", NULL);
>>> +	if (sizep == NULL && basep == NULL)
>>> +		return -ENODEV;
>>> +	if (sizep == NULL || basep == NULL)
>>>   		return -EIO;
>>
>> To confirm my understanding,
>>
>> For -ENODEV, it means that both properties are not supported, so event log
>> is not supported.
>
> Yes
>
>> For -EIO , it means that event log is supported but there is some failure in
>> getting one of them, so should fail the probe.
>> Is my understanding right ?
>
> Yes

Thanks for explaining. Looks good now.

Thanks & Regards,
   - Nayna

>
> Jason
>

