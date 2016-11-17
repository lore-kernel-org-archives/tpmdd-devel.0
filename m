From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's
	event log
Date: Thu, 17 Nov 2016 13:25:54 -0500
Message-ID: <c6e84bc7-151c-e698-e269-0ef1ebf3897b@linux.vnet.ibm.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116153731.pmmnxiai7ouuj6qf@intel.com>
	<3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
	<65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
	<20161116200759.GA19593@obsidianresearch.com>
	<ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
	<20161117181006.GA26039@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161117181006.GA26039-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 11/17/2016 01:10 PM, Jason Gunthorpe wrote:
> 1;2802;0cOn Thu, Nov 17, 2016 at 07:35:05AM -0500, Stefan Berger wrote:
>> I ran the vtpm driver test suite (with -j32) a few times at that patch and
>> it didn't crash. It crashes severely with later patches applied. Here's the
>> current experimental patch that fixes these problems:
> I can't see how setting owner has any bearing on this.. I also don't
> see why it should ever fail at all... It would be great to get a root
> cause here - could it be memory corruption????
>
> Getting a really bad feeling from this  :(
>
>> iff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
>> index 0cb43ef..a73295a 100644
>> +++ b/drivers/char/tpm/tpm_acpi.c
>> @@ -56,6 +56,9 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
>>
>>       log = &chip->log;
>>
>> +    if (!chip->acpi_dev_handle)
>> +        return 0;
>> +
>>
>> // So ACPI is not supported on this device, but ACPI support is compiled in.
>> I am returning 0 here, assuming it's not an OF device and the corresponding
>> OF function need not be called (see below).
> Return -ENODEV
>
>> +    if (!(chip->flags & TPM_CHIP_FLAG_VIRTUAL))
>> +        rc = tpm_read_log_of(chip);
>>
>> // I am not sure how to handle this case, in case we get here, which would
>> only be on an OF device (following 'return 0;' above), but we don't want to
>> attempt to read the log there, either. I think the most straight-forward way
>> would be to gate this whole function with a flag that only the vtpm proxy
>> driver has: TPM_CHIP_FLAG_NO_FIRMWARE_LOG.
> OF is already fine, it checks chip->dev.parent->of_node so it will
> exit properly for vtpm, no need for this.

In the case of x86, tpm_read_log_of() is a stub return -ENODEV, which in 
turn fails the whole device:

http://git.infradead.org/users/jjs/linux-tpmdd.git/blob/4d388433e85f8257f5a9344a7acf6f499ba2b29e:/drivers/char/tpm/tpm_eventlog.h#l87


http://git.infradead.org/users/jjs/linux-tpmdd.git/blob/4d388433e85f8257f5a9344a7acf6f499ba2b29e:/drivers/char/tpm/tpm-chip.c#l348

So we must not run into that or handle -ENODEV differently or return a 
different error code in the stub function.

I think the OF log reading code will also need to check for 
chip->dev.parent being NULL.

Further, I had the impression that the error unwinding following -ENODEV 
has an issue related to sysfs.

     Stefan
>
> Jason
>


------------------------------------------------------------------------------
