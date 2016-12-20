From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] tpm,
 tpm_crb: Handle 64-bit resource in crb_check_resource()
Date: Tue, 20 Dec 2016 00:19:27 -0600
Message-ID: <5858CD6F.5000909@codeaurora.org>
References: <1482121253-924-1-git-send-email-anjiandi@codeaurora.org>
	<20161219135624.2e7okpswnbqbvic7@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161219135624.2e7okpswnbqbvic7-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 12/19/16 07:56, Jarkko Sakkinen wrote:
> On Sun, Dec 18, 2016 at 10:20:53PM -0600, Jiandi An wrote:
>> crb_check_resource() in TPM CRB driver calls
>> acpi_dev_resource_memory() which only handles 32-bit resources.
>> Adding a call to acpi_dev_resource_address_space() in TPM CRB
>> driver which handles 64-bit resources.
>>
>> Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> 1. Is there a platform in existence where this change fixes a problem?
> 2. What is difference between "memory" and "address space" conceptually?
>    Just wondering why 32-bit stuff is "memory" and 64-bit stuff is
>    "address space". Could there be a one function that would work both
>    for 32-bit and 64-bit cases?
>    
> Yeah, I do not know this API too well. That's why I'm asking.
> 
> /Jarkko
> 
> 
> If this is the right thing it also needs to be done in tpm_tis.
> 
> I will point out that this driver only works with memory, so using a
> generic decoder without checking for IO maps may not be correct..
> 
> Jason
> 

Hi Jarkko and Jason,

Thanks for your comments.
I am a developer at Qualcomm and we are trying to enable TPM CRB driver
on ARM64 for Qualcomm Centriq 2400.  Spec changes to ACPI table for TPM 2.0
have been submitted and approved by TCG and are currently in the 60 day waiting
period for release.  I have a series of patches that do this TPM CRB driver
enablement for ARM64 that I'll be submitting.

But first, for our platform the control area buffer address is greater than 32-bit.
It is memory with no IO effects.  I ran into this issue first when I use
QWordMemory in ACPI ASL to describe the resource.  MemoryRangeType is specified as
AddressRangeMemory. 

The QWordMemory macro evaluates to a buffer which contains a 64-bit memory
resource descriptor, which describes a range of memory addresses.  It is
a QWord Address Space Descriptor.  acpi_dev_resource_address_space()
handles the 64-bit memory described using QWordMemory macro in ACPI ASL.

The Memory32Fixed macro evaluates to a buffer which contains a 32-bit memory
descriptor, which describes a fixed range of memory addresses.
acpi_dev_resource_memory() handles the 32-bit memory described using Memory32Fixed
in ACPI ASL.

I did not see a specific acpi_dev_resource_ service that handles 64-bit resource
address and doesn't use the generic acpi_decode_space() decoder.

I do have a question about having to specify _CRS method in ACPI ASL.
When I was doing early prototyping for this enablement work on ARM64 back
during the time with 4.5 kernel, it was before the introduction of the following
two patches:
commit 1bd047be37d95bf65a219f4931215f71878ac060
tpm_crb: Use devm_ioremap_resource
commit 51dd43dff74b0547ad844638f6910ca29c956819
tpm_tis: Use devm_ioremap_resource

The control area buffer is specified in the TPM2.0 static ACPI table.  TPM
CRB driver maps the control area address and reads out cmd and rsp buffer
addresses and maps them.  There is no requirement in the TCG TPM ACPI spec
for specifying _CRS to describe the control area buffer.  When I rebased
the early prototype for CRB driver ARM64 enablement to the latest kernel,
I hit this issue where I have to specify _CRS method.  So in _CRS method
I specify the same control area address that's in the TPM2.0 static ACPI table.

I see the _CRS requirement in the CRB driver is for resource synchronization
between the TIS and CRB drivers to support force mode in TIS. Could I get some
background on that so I could be more careful not breaking TIS while making
changes to CRB driver for ARM64 enablement?

Thanks in advance.

>> ---
>>  drivers/char/tpm/tpm_crb.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
>> index 717b6b4..86f355b 100644
>> --- a/drivers/char/tpm/tpm_crb.c
>> +++ b/drivers/char/tpm/tpm_crb.c
>> @@ -264,10 +264,12 @@ static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
>>  static int crb_check_resource(struct acpi_resource *ares, void *data)
>>  {
>>  	struct resource *io_res = data;
>> -	struct resource res;
>> +	struct resource_win win;
>> +	struct resource *res = &(win.res);
>>  
>> -	if (acpi_dev_resource_memory(ares, &res)) {
>> -		*io_res = res;
>> +	if (acpi_dev_resource_memory(ares, res) ||
>> +	    acpi_dev_resource_address_space(ares, &win)) {
>> +		*io_res = *res;
>>  		io_res->name = NULL;
>>  	}
>>  
>> -- 
>> Jiandi An
>> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
>> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
>>
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most 
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
> 


-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/intel
