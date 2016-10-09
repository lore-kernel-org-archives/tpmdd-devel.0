From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 4/8] tpm: redefine read_log() to handle
 ACPI/OF at runtime
Date: Sun, 9 Oct 2016 16:59:15 +0530
Message-ID: <57FA2A0B.7060404@linux.vnet.ibm.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-5-git-send-email-nayna@linux.vnet.ibm.com>
	<20160930190511.GC9595@intel.com> <57F6B647.1070206@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <57F6B647.1070206-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 10/07/2016 02:08 AM, Nayna wrote:
>
>
> On 10/01/2016 12:35 AM, Jarkko Sakkinen wrote:
>> On Wed, Sep 28, 2016 at 04:34:38AM -0400, Nayna Jain wrote:
>>> Currently, read_log() has two implementations: one for ACPI platforms
>>> and the other for OF platforms. The proper one is selected at compile
>>> time using Kconfig and #ifdef in the Makefile, which is not the
>>> recommended approach.
>>>
>>> This patch removes the #ifdef in the Makefile by defining a single
>>> read_log() method, which checks for ACPI/OF event log properties at
>>> runtime.
>>>
>>> Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>> ---
>>>    drivers/char/tpm/Makefile       | 14 ++++----------
>>>    drivers/char/tpm/tpm_acpi.c     |  9 ++-------
>>>    drivers/char/tpm/tpm_eventlog.c | 18 ++++++++++++++++++
>>>    drivers/char/tpm/tpm_eventlog.h | 22 +++++++++++++---------
>>>    drivers/char/tpm/tpm_of.c       |  8 ++------
>>>    5 files changed, 39 insertions(+), 32 deletions(-)
>>>
>>> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
>>> index a385fb8..a05b1eb 100644
>>> --- a/drivers/char/tpm/Makefile
>>> +++ b/drivers/char/tpm/Makefile
>>> @@ -2,16 +2,10 @@
>>>    # Makefile for the kernel tpm device drivers.
>>>    #
>>>    obj-$(CONFIG_TCG_TPM) += tpm.o
>>> -tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
>>> -tpm-$(CONFIG_ACPI) += tpm_ppi.o
>>> -
>>> -ifdef CONFIG_ACPI
>>> -	tpm-y += tpm_eventlog.o tpm_acpi.o
>>> -else
>>> -ifdef CONFIG_TCG_IBMVTPM
>>> -	tpm-y += tpm_eventlog.o tpm_of.o
>>> -endif
>>> -endif
>>> +tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
>>> +		tpm_eventlog.o
>>> +tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
>>> +tpm-$(CONFIG_OF) += tpm_of.o
>>>    obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
>>>    obj-$(CONFIG_TCG_TIS) += tpm_tis.o
>>>    obj-$(CONFIG_TCG_TIS_SPI) += tpm_tis_spi.o
>>> diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
>>> index 4d6c2d7..859bdba 100644
>>> --- a/drivers/char/tpm/tpm_acpi.c
>>> +++ b/drivers/char/tpm/tpm_acpi.c
>>> @@ -6,6 +6,7 @@
>>>     *	Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>>     *	Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
>>>     *	Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>> + *	Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>     *
>>>     * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
>>>     *
>>> @@ -45,7 +46,7 @@ struct acpi_tcpa {
>>>    };
>>>
>>>    /* read binary bios log */
>>> -int read_log(struct tpm_chip *chip)
>>> +int read_log_acpi(struct tpm_chip *chip)
>>>    {
>>>    	struct acpi_tcpa *buff;
>>>    	acpi_status status;
>>> @@ -54,12 +55,6 @@ int read_log(struct tpm_chip *chip)
>>>    	struct tpm_bios_log *log;
>>>
>>>    	log = &chip->log;
>>> -	if (log->bios_event_log != NULL) {
>>> -		printk(KERN_ERR
>>> -		       "%s: ERROR - Eventlog already initialized\n",
>>> -		       __func__);
>>> -		return -EFAULT;
>>> -	}
>>>
>>>    	/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
>>>    	status = acpi_get_table(ACPI_SIG_TCPA, 1,
>>> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
>>> index a8cd4a1..c327089 100644
>>> --- a/drivers/char/tpm/tpm_eventlog.c
>>> +++ b/drivers/char/tpm/tpm_eventlog.c
>>> @@ -346,6 +346,24 @@ static int is_bad(void *p)
>>>    	return 0;
>>>    }
>>>
>>> +int read_log(struct tpm_chip *chip)
>>> +{
>>> +	int rc;
>>> +
>>> +	if (chip->log.bios_event_log != NULL) {
>>> +		dev_dbg(&chip->dev, "%s: ERROR - Eventlog already initialized\n",
>>> +			__func__);
>>> +		return -EFAULT;
>>> +	}
>>> +
>>> +	rc = read_log_acpi(chip);
>>> +	if ((rc == 0) || (rc == -ENOMEM))
>>> +		return rc;
>>> +	rc = read_log_of(chip);
>>> +	return rc;
>>> +
>>> +}
>>
>> I'm wondering if it is a better idea to leverage tpm_class_ops? This
>> would be kind of cool idea to implement this because then the decision
>> to support event log could be leveraged to the driver level.
>
> Can you please explain me this bit more ?
>
> For eg, when we say driver level.. does that mean to the level of tis,
> nuvoton ?
>
> And what type of decision ? I mean like decision to create securityfs
> setup for userspace to read eventlog ? or there are other things ?
>

Jarkko, can you please also help me to understand here more ?

Thanks & Regards,
   - Nayna

>>
>> If the event_log pointer is NULL, then event log is not supported.
>
> Yeah, sure will fix this.
>
> Thanks & Regards,
>       - Nayna
>>
>> /Jarkko
>>
>
>
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
