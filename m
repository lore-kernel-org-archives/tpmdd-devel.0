From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 3/7] tpm: Validate the eventlog access
 before tpm_bios_log_setup
Date: Fri, 9 Sep 2016 22:54:25 +0530
Message-ID: <57D2F049.4040707@linux.vnet.ibm.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1472532619-22170-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830175213.GC6373@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160830175213.GC6373-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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



On 08/30/2016 11:22 PM, Jason Gunthorpe wrote:
> On Tue, Aug 30, 2016 at 12:50:15AM -0400, Nayna Jain wrote:
>> @@ -382,6 +370,8 @@ int tpm_chip_register(struct tpm_chip *chip)
>>   		return rc;
>>   	}
>>
>> +	tpm_bios_log_setup(chip);
>
> Surely this can fail, right? At least if the security fs setup fails
> this should propogate that error.

What action we want to take if it fails to do bios_log_setup ?
I have done all other fixes, just am not sure that if we propogate this 
error, then will it mean that tpm_chip_register (where this function is 
called) should fail ? or it is just an error logging on failure of 
bios_log_setup.

>
> That is a mistake in an earlier patch now that I think about it..

>>
>>   	/* malloc EventLog space */
>> -	log->bios_event_log = kmalloc(len, GFP_KERNEL);
>> -	if (!log->bios_event_log) {
>> +	chip->log.bios_event_log = kmalloc(len, GFP_KERNEL);
>> +	if (!chip->log.bios_event_log) {
>>   		printk("%s: ERROR - Not enough  Memory for BIOS measurements\n",
>>   			__func__);
>
> Please delete all prints on kmalloc failure, maybe as another patch.
>
>>   		return -ENOMEM;
>>   	}
>>
>> -	log->bios_event_log_end = log->bios_event_log + len;
>> +	chip->log.bios_event_log_end = chip->log.bios_event_log + len;
>>
>>   	virt = acpi_os_map_iomem(start, len);
>>   	if (!virt) {
>> -		kfree(log->bios_event_log);
>> +		kfree(chip->log.bios_event_log);
>
> It would also be nice to see this written in the standard
> goto-unwind idiom.
>
>>   static const struct file_operations tpm_bios_measurements_ops = {
>> @@ -372,12 +352,18 @@ static int is_bad(void *p)
>>   void tpm_bios_log_setup(struct tpm_chip *chip)
>>   {
>>   	const char *name = dev_name(&chip->dev);
>> +	int rc = 0;
>> +
>> +	rc = read_log(chip);
>> +	if (rc < 0)
>> +		return;
>>
>>   	chip->bios_dir_count = 0;
>>   	chip->bios_dir[chip->bios_dir_count] = securityfs_create_dir(name,
>>   	NULL);
>>   	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
>>   		goto err;
>> +	chip->bios_dir[chip->bios_dir_count]->d_inode->i_private =
>>   	chip;
>
> Hum.
>
> So I don't know if this is right. You should get someone more familiar
> with securityfs to double check it. I see apparmorfs.c doing a similar
> approach, so that would be a good starting place to copy. Notice how
> it uses aa_get_(x)
>
> Still, I wonder if that is even right, is securityfs_remove() really a
> strong fence against open? I guess the inode locking is doing that?
>
> This also means that the file can remain held open in userspace
> *after* securityfs_remove returns, so the filp must hold a kref on the
> chip as well.
>
> At a minimum you need to do something like this:
>
> Create:
>
> chip->sfs_data_bin.chip = chip;
> chip->sfs_data_bin.ops = &tpm_binary_b_measurments_seqops;
> securityfs_create_file(...,&chip->sfs_data_bin)
>
> It must be done like that to be atomic with open, create two new
> members of chip to hold a struct to pass through as the private
> data. Do not use the dentry private.
>
> Open:
> chip = (struct tpm_chip *)inode->i_private;
> dev_get(&chip->dev);
> seq_open(..)
> seq->private = chip;
>
> Release:
> dev_put(&((struct tpm_chip *)seq->private)->dev);
>
> Teardown
>   the kfree needs to move to the chip release function.
>
>>   ifdef CONFIG_ACPI
>> -     tpm-y += tpm_eventlog.o tpm_acpi.o
>> +     tpm-y += tpm_acpi.o
>>   else
>> -ifdef CONFIG_TCG_IBMVTPM
>> -     tpm-y += tpm_eventlog.o tpm_of.o
>> +ifdef CONFIG_OF
>> +     tpm-y += tpm_of.o
>>   endif
>
> This is too early in the patch series. This change needs to go into
> 'Redefine the read_log method to check for ACPI/OF properties
> sequentially'
>
>> -#if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
>> -     defined(CONFIG_ACPI)
>
> Ditto
>
> Regarding Jarkko's comment,
>
> Yes, move the check for TPM2 into both of the read_log() - do not
> allow TPM2 to read the log until you patch the OF stuff to support the
> TPM2 log format.
>
> Jason
>


------------------------------------------------------------------------------
