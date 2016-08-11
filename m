From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 0/3] TPM2.0: Added eventlog support for
 TPM2.0
Date: Thu, 11 Aug 2016 16:18:34 +0530
Message-ID: <57AC5802.1090109@linux.vnet.ibm.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160810113243.GF13929@intel.com> <20160810171900.GA11543@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160810171900.GA11543-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko/Jason,

Thanks for the review and sharing the perspective, I understand your 
point and will take care from next time.

I will include the feedbacks for code/commit msgs as suggested by both 
of you in next version of patch.

And I do have few questions before fixing the issues I didn't address in 
this patch. Quoting my thoughts with <nayna>

So, there were two feedbacks by Jason.

#1. And the next somewhat pre-existing issue is that we call
tpm_bios_log_setup even if we don't have access to a bios log.

Does the bios log ever change or is it static at boot? Can we move
read_log into the chip and do it once so we can tell if it worked
before creating security fs stuff??

<nayna>

So, by statement "if we don't have access to a bios log?".. Do you mean 
bios log is empty ? or has no properties to access the log.

Regarding bios log, so it is supposed to be written by each component in 
boot stack during boot.
As per moving read_log into the chip, do you mean something like as below ?

struct tpm_chip {
....
     struct tpm_bios_log *bios_log;
....
}

read_log(struct tpm_chip *chip)
{

  allocates to chip->bios_log->bios_event_log
  allocates to chip->bios_log->bios_event_log_end;

  return 0; // for success;

}

tpm_chip_register()
{
...
if (read_log(chip))
    tpm_bios_log_setup(chip);
...
}

And as per readlog is concerned, it just reads the start and max size of 
the log for both ACPI/OF. So, it is possible that readlog returns 
successfully giving start and max allocated size. but actual log size is 
zero. So, when we cat bios_measurements_file, it doesn't show anything. 
  And I think that is fine.

Please let me know if I missed something.

</nayna>

#2.
 >  #if defined(CONFIG_TCG_IBMVTPM) || 
defined(CONFIG_TCG_IBMVTPM_MODULE) || \
 > -	defined(CONFIG_ACPI)
 > -extern struct dentry **tpm_bios_log_setup(const char *);
 > -extern void tpm_bios_log_teardown(struct dentry **);
 > +	defined(CONFIG_ACPI) || defined(CONFIG_PPC64)
 > +extern struct dentry **tpm_bios_log_setup(struct tpm_chip *chip);
 > +extern void tpm_bios_log_teardown(struct tpm_chip *chip);

I'm really deeply unhappy about these ifdefs and the general scheme
that was used to force this special difference into the tpm core.

Please find another way to do it.

IMHO, 'read_log' should simply try ACPI and OF in sequence to find the
log.

<nayna> Can you help me to understand the reason for which it was done 
this way ?

Secondly, did you mean something like (just a sample psudocode)
read_log()
{
read_of_node;
if (read_of_node_fails)
	read_acpi_way
         if (read_acpi_succeeds)
            do acpi_way of reading for start of log and max log size.
	else
            return err;
do of_node way of reading for start of log and max log size
}

So, is it safe to assume that if there is no of_node property , that 
means it is ACPI ?

Thirdly, you also said that "We are trying to get rid of these extra 
externs.." So, was thinking how does fixing readlog will fix these 
externs, because even if readlog is called in tpm-chip, we still need to 
call tpm_bios_log_setup().

So, I guess you meant that inline ones will go away and thereby #ifdef, 
externs will still be there. right ? Please let me know if I am missing 
something. </nayna>

#3. Where you able to test this on IBM's 'vtpm' stuff as well?,

<nayna>This was for patch where I am directly using dev.of_node 
property. Sorry I missed to reply in previous response. And answer is 
"yes", I did test it. </nayna>

Jarrko, You also asked "
 >> BTW, how this can be tested?"

<nayna> So, it can be tested with system having TPM2.0 version of 
tpm/vtpm and its firmware writing eventlog following TCG Spec for TPM2.0.

Jarkko, Please let me know if it doesn't answer your question. </nayna>

Thanks & Regards,
    - Nayna


On 08/10/2016 10:49 PM, Jarkko Sakkinen wrote:
> On Wed, Aug 10, 2016 at 02:32:43PM +0300, Jarkko Sakkinen wrote:
>> On Tue, Aug 09, 2016 at 03:34:52PM -0400, Nayna Jain wrote:
>>> Overview:
>>> =========
>>>
>>> This patch adds support for enabling securityfs for TPM2.0, currently
>>> driver has eventlog support only for TPM1.2.
>>> The patch currently adds support for only binary_bios_measurements.
>>>
>>> The structure for TPM2.0 is compliant with TCG Spec for 2.0 family.
>>> Also , the reading of data has the assumption that writer would have
>>> followed TCG Spec and so everything is in little-endian.
>>>
>>> The tpm device driver code has been refactored to:
>>> * Identify the TPM version - 1.2 or 2.0
>>> * Calls corresponding compatible seq_ops for iterating over eventlog.
>>>
>>> Files Description:
>>> ===================
>>>
>>> * tpm-chip.c : Adds call to setup bios log for TPM2.0.
>>>
>>> * tpm2_of.c : Reads the device tree entries to find the location
>>> and size of event.
>>>
>>> * tpm_eventlog_init.c : Provides common initialization functions
>>>   between TPM2.0 and TPM1.2 to setup securityfs entries and seq_ops
>>>    iterator.  The functions has been moved from tpm_eventlog.c into this file.
>>>
>>>    * tpm_eventlog.c : Provides functions only specific to TPM1.2
>>>    version. Common initialization functions are moved to tpm_eventlog_init.c
>>>
>>>    * tpm2_eventlog.c : Provides functions specific only for TPM2.0
>>>    eventlog format.
>>>
>>>    * tpm2.h : Header file for TPM2.0 structures and functions.
>>
>> diffstat shows changed files. Your commit messages will give detailed
>> descriptions. Please remove this. Cover letter would be the right place
>> to tell about missing ACPI support.
>>
>> BTW, how this can be tested?
>
> As for ACPI you stated that
>
> "Reason being, I don't have much expertise of ACPI side as of now, and
> these changes will affect acpi,tpm,vtpm, all paths, so I would like to
> go slow and fix them as different patch later after better
> understanding."
>
> Don't get me wrong but that really is an unacceptable statement. It
> gives very strong evidence that you don't know what you are doing and
> the patches are not ready for public consumption.
>
> You have two better alternatives:
>
> 1. Do a little bit of research. You would have found that there's no
>     ACPI support for the event log defined by TCG at the moment.
> 2. Ask first. This is the right mailing list to do that.
>
> You do not have to implement ACPI support as part of the patch set but
> at least it would be good to research the constraints so that we can
> check that the implementation will be best for ACPI too.
>
> /Jarkko
>


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
