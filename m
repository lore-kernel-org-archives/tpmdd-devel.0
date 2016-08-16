From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 0/3] TPM2.0: Added eventlog support for
 TPM2.0
Date: Tue, 16 Aug 2016 14:21:53 +0530
Message-ID: <57B2D429.8050508@linux.vnet.ibm.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160810113243.GF13929@intel.com> <20160810171900.GA11543@intel.com>
	<57AC5802.1090109@linux.vnet.ibm.com>
	<20160813025915.GC26929@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160813025915.GC26929-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

Hi Jason,

Thanks for your inputs.. Further responses inline.

On 08/13/2016 08:29 AM, Jason Gunthorpe wrote:
> On Thu, Aug 11, 2016 at 04:18:34PM +0530, Nayna wrote:
>>> #1. And the next somewhat pre-existing issue is that we call
>>> tpm_bios_log_setup even if we don't have access to a bios log.
>>>
>>> Does the bios log ever change or is it static at boot? Can we move
>>> read_log into the chip and do it once so we can tell if it worked
>>> before creating security fs stuff??
>>
>> <nayna>
>>
>> So, by statement "if we don't have access to a bios log?".. Do you mean bios
>> log is empty ? or has no properties to access the log.
>
> More along the lines we call down to tpm_of and it just exits if the
> properties do not exist. For instance my DT using TPM systems do not
> have a bios log.

Ok.

>
>> Regarding bios log, so it is supposed to be written by each component in
>> boot stack during boot.
>
> Only if the boot firmware supports this functionality and indicates it
> via DT attributes or ACPI. That is what we need to check earlier.
>
>> As per moving read_log into the chip, do you mean something like as below ?
>>
>> struct tpm_chip {
>> ....
>>      struct tpm_bios_log *bios_log;
>> ....
>> }
>>
>> read_log(struct tpm_chip *chip)
>> {
>>
>>   allocates to chip->bios_log->bios_event_log
>>   allocates to chip->bios_log->bios_event_log_end;
>>
>>   return 0; // for success;
>>
>> }
>>
>> tpm_chip_register()
>> {
>> ...
>> if (read_log(chip))
>>     tpm_bios_log_setup(chip);
>> ...
>> }
>
> Yes, exactly. The challenge will be to get the chip into the security
> file context, give that a try and we can probably help you. The
> locking and lifetime will probably be very subtle.

Sure, I have done this change now in my next patch, should be able to 
post soon.
>
>> And as per readlog is concerned, it just reads the start and max size of the
>> log for both ACPI/OF. So, it is possible that readlog returns successfully
>> giving start and max allocated size. but actual log size is zero. So, when
>> we cat bios_measurements_file, it doesn't show anything.  And I think that
>> is fine.
>
> That would be a firmware that says it support a log but generated an
> empty one, so that seems reasonble to report to user space.
>
>>
>> #2.
>>>   #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) ||
>> \
>>> -	defined(CONFIG_ACPI)
>>> -extern struct dentry **tpm_bios_log_setup(const char *);
>>> -extern void tpm_bios_log_teardown(struct dentry **);
>>> +	defined(CONFIG_ACPI) || defined(CONFIG_PPC64)
>>> +extern struct dentry **tpm_bios_log_setup(struct tpm_chip *chip);
>>> +extern void tpm_bios_log_teardown(struct tpm_chip *chip);
>>
>> I'm really deeply unhappy about these ifdefs and the general scheme
>> that was used to force this special difference into the tpm core.
>>
>> Please find another way to do it.
>>
>> IMHO, 'read_log' should simply try ACPI and OF in sequence to find the
>> log.
>>
>> <nayna> Can you help me to understand the reason for which it was done this
>> way ?
>
> When this was written the TPM subsystem was very old and lacked
> infrastructure to do this better, we have largely solved those
> problems, event log is the last large area that needs some attention..
>

Ok.

>> Secondly, did you mean something like (just a sample psudocode)
>> read_log()
>> {
>> read_of_node;
>> if (read_of_node_fails)
>> 	read_acpi_way
>>          if (read_acpi_succeeds)
>>             do acpi_way of reading for start of log and max log size.
>> 	else
>>             return err;
>> do of_node way of reading for start of log and max log size
>> }
>
> I would do more like:
>
> read_log_of(
> {
>    if (! chip->pdev->of_node .. has attribute)
>       return 0
>    .. return 1;
> }
>
> read_log()
> {
>    if ((res = read_log_of(chip)) != 0)
>       return res;
>    if ((res = read_log_acpi(chip)) != 0)
>       return res;
>    return 0;
> }

I tried the suggested approach and since ACPI specific functions won't 
be available for arch using CONFIG_OF, so the compilation fails and vice 
versa for CONFIG_ACPI..

Jason, for understanding.. can you explain the issue with existing 
design for read_log, where arch specific read_log is compiled based on 
CONFIG option.. And then, we can just change in Makefile.. where 
currently it is like

ifdef CONFIG_ACPI
        tpm-y += tpm_acpi.o
else
ifdef CONFIG_OF
        tpm-y += tpm_of.o
endif
endif


this can be changed to
tpm-$(CONFIG_ACPI) += tpm_acpi.o
tpm-$(CONFIG_OF) += tpm_of.o


Please let me know if I missed something.

Thanks & Regards,
    - Nayna

>
>> So, is it safe to assume that if there is no of_node property , that means
>> it is ACPI ?
>
> No, ACPI also reads a property from the ACPI table, the existance of
> that should be tested directly.
>
>> #3. Where you able to test this on IBM's 'vtpm' stuff as well?,
>>
>> <nayna>This was for patch where I am directly using dev.of_node property.
>> Sorry I missed to reply in previous response. And answer is "yes", I did
>> test it. </nayna>
>
> That is excellent
>
> Jason
>


------------------------------------------------------------------------------
