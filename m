From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's
	event log
Date: Fri, 18 Nov 2016 09:15:32 -0500
Message-ID: <77bf7806-5007-feb4-e4a0-fc94775a5271@linux.vnet.ibm.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116153731.pmmnxiai7ouuj6qf@intel.com>
	<3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
	<65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
	<20161116200759.GA19593@obsidianresearch.com>
	<ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
	<20161117203743.odzdpwwynzlqyt5m@intel.com>
	<abef96f0-97e3-22e6-c63b-4be5622b4fc2@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <abef96f0-97e3-22e6-c63b-4be5622b4fc2-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 11/18/2016 09:11 AM, Stefan Berger wrote:
> On 11/17/2016 03:37 PM, Jarkko Sakkinen wrote:
>> On Thu, Nov 17, 2016 at 07:35:05AM -0500, Stefan Berger wrote:
>>> On 11/16/2016 03:07 PM, Jason Gunthorpe wrote:
>>>> On Wed, Nov 16, 2016 at 12:07:23PM -0500, Stefan Berger wrote:
>>>>> The culprit seems to be 'tpm: fix the missing .owner in
>>>>> tpm_bios_measurements_ops'
>>>> That is unlikely, it is probably the patch before which calls read_log
>>>> unconditionally now. That suggests the crashing is a little random..
>>> I ran the vtpm driver test suite (with -j32) a few times at that 
>>> patch and
>>> it didn't crash. It crashes severely with later patches applied. 
>>> Here's the
>>> current experimental patch that fixes these problems:
>>>
>>> iff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
>>> index 0cb43ef..a73295a 100644
>>> --- a/drivers/char/tpm/tpm_acpi.c
>>> +++ b/drivers/char/tpm/tpm_acpi.c
>>> @@ -56,6 +56,9 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
>>>
>>>       log = &chip->log;
>>>
>>> +    if (!chip->acpi_dev_handle)
>>> +        return 0;
>>> +
>> If there is a problem in the TPM driver, this does not fix the
>> problem. It will mask the problem. Maybe there's an ACPI regression
>> in the rc tree?
>
> Following the path from here :
>
> http://lxr.free-electrons.com/source/drivers/acpi/acpica/tbxface.c#L282
>
> acpi_get_table_with_size -> acpi_tb_validate_table -> 
> acpi_tb_acquire_table
>
> I see acpi_os_map_memory being called in acpi_tb_acquire_table but not 
> the corresponding acpi_os_unmap_memory...
>

And to add to this: the call to acpi_get_table() in tpm_acpi.c alone is 
causing the crash. I am fairly sure that it has something to do with the 
memory mapping call above not being matched by an unmapping call.


>     Stefan
>
>
>>
>> This is a funky situation because those lines need to be there but
>> I do not want them before it is root caused that it is not a TPM
>> bug.
>>
>> /Jarkko
>>
>


------------------------------------------------------------------------------
