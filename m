From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Wed, 19 Oct 2016 07:40:56 +0530
Message-ID: <5806D630.50602@linux.vnet.ibm.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001120125.GC8664@intel.com> <57FFD79F.7080405@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <57FFD79F.7080405-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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



On 10/14/2016 12:21 AM, Nayna wrote:
>
>
> On 10/01/2016 05:31 PM, Jarkko Sakkinen wrote:
>> On Wed, Sep 28, 2016 at 04:34:37AM -0400, Nayna Jain wrote:
>>> Currently, the securityfs pseudo files for obtaining the firmware
>>> event log are created whether the event log properties exist or not.
>>> This patch creates ascii and bios measurements pseudo files
>>> only if read_log() is successful.
>>
>> Re-reviewing this. The commit message should mention about preventing
>> a race condition.
>>
>> I think Jason was right. It makes code much more manageable with a
>> small price of memory consumption.
>>
>>> Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>> ---
>>>    drivers/char/tpm/tpm.h          |  6 +++++
>>>    drivers/char/tpm/tpm_acpi.c     | 12 +++++++---
>>>    drivers/char/tpm/tpm_eventlog.c | 53 +++++++++++++++++++----------------------
>>>    drivers/char/tpm/tpm_eventlog.h |  7 +++++-
>>>    drivers/char/tpm/tpm_of.c       |  4 +++-
>>>    5 files changed, 48 insertions(+), 34 deletions(-)
>>>
>>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>>> index b5866bb..68630cd 100644
>>> --- a/drivers/char/tpm/tpm.h
>>> +++ b/drivers/char/tpm/tpm.h
>>> @@ -35,6 +35,8 @@
>>>    #include <linux/cdev.h>
>>>    #include <linux/highmem.h>
>>>
>>> +#include "tpm_eventlog.h"
>>> +
>>>    enum tpm_const {
>>>    	TPM_MINOR = 224,	/* officially assigned */
>>>    	TPM_BUFSIZE = 4096,
>>> @@ -156,6 +158,10 @@ struct tpm_chip {
>>>    	struct rw_semaphore ops_sem;
>>>    	const struct tpm_class_ops *ops;
>>>
>>> +	struct tpm_bios_log log;
>>
>> struct tpm_bios_log should be renamed as struct tpm_event_log in some
>> commit of this patch set as tpm_bios_log is a misleading name.
>
> My understanding is that other event log functions are also named in
> consistent with tpm_bios_log naming.. for eg..
> tpm_bios_log_setup(/teardown), tpm_bios_measurements_open,etc. So,
> wanted to understand if idea is only to change the struct name to
> tpm_event_log ?
>
> Thanks & Regards,
>     - Nayna

I have not modified the tpm_bios_log naming in my new patch set for the 
above reason. But if we think that it is appropriate to change the data 
type (and functions ?) naming, I will post it as separate single patch.

Thanks & Regards,
    - Nayna

>
>>
>>> +	struct tpm_securityfs_data bin_sfs_data;
>>> +	struct tpm_securityfs_data ascii_sfs_data;
>>
>> I think this is otherwise right but the struct name is very clunky.
>> First of all it doesn't own the data and IMHO now it kind of implies
>> of owning.
>>
>> Maybe something like tpm_event_log_fd would a better name. It's a
>> description of the event log file essentially.
>>
>>> +
>>>    	unsigned int flags;
>>>
>>>    	int dev_num;		/* /dev/tpm# */
>>> diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
>>> index 565a947..4d6c2d7 100644
>>> --- a/drivers/char/tpm/tpm_acpi.c
>>> +++ b/drivers/char/tpm/tpm_acpi.c
>>> @@ -45,13 +45,15 @@ struct acpi_tcpa {
>>>    };
>>>
>>>    /* read binary bios log */
>>> -int read_log(struct tpm_bios_log *log)
>>> +int read_log(struct tpm_chip *chip)
>>>    {
>>>    	struct acpi_tcpa *buff;
>>>    	acpi_status status;
>>>    	void __iomem *virt;
>>>    	u64 len, start;
>>> +	struct tpm_bios_log *log;
>>>
>>> +	log = &chip->log;
>>>    	if (log->bios_event_log != NULL) {
>>>    		printk(KERN_ERR
>>>    		       "%s: ERROR - Eventlog already initialized\n",
>>> @@ -97,13 +99,17 @@ int read_log(struct tpm_bios_log *log)
>>>
>>>    	virt = acpi_os_map_iomem(start, len);
>>>    	if (!virt) {
>>> -		kfree(log->bios_event_log);
>>>    		printk("%s: ERROR - Unable to map memory\n", __func__);
>>> -		return -EIO;
>>> +		goto err;
>>>    	}
>>>
>>>    	memcpy_fromio(log->bios_event_log, virt, len);
>>>
>>>    	acpi_os_unmap_iomem(virt, len);
>>>    	return 0;
>>> +
>>> +err:
>>> +	kfree(log->bios_event_log);
>>> +	return -EIO;
>>> +
>>>    }
>>> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
>>> index f1df782..a8cd4a1 100644
>>> --- a/drivers/char/tpm/tpm_eventlog.c
>>> +++ b/drivers/char/tpm/tpm_eventlog.c
>>> @@ -261,14 +261,6 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
>>>    static int tpm_bios_measurements_release(struct inode *inode,
>>>    					 struct file *file)
>>>    {
>>> -	struct seq_file *seq = file->private_data;
>>> -	struct tpm_bios_log *log = seq->private;
>>> -
>>> -	if (log) {
>>> -		kfree(log->bios_event_log);
>>> -		kfree(log);
>>> -	}
>>> -
>>>    	return seq_release(inode, file);
>>>    }
>>>
>>> @@ -323,34 +315,19 @@ static int tpm_bios_measurements_open(struct inode *inode,
>>>    					    struct file *file)
>>>    {
>>>    	int err;
>>> -	struct tpm_bios_log *log;
>>>    	struct seq_file *seq;
>>> -	const struct seq_operations *seqops =
>>> -		(const struct seq_operations *)inode->i_private;
>>> -
>>> -	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
>>> -	if (!log)
>>> -		return -ENOMEM;
>>> -
>>> -	err = read_log(log);
>>> -	if (err)
>>> -		goto out_free;
>>> +	const struct tpm_securityfs_data *sfs_data =
>>> +		(const struct tpm_securityfs_data *)inode->i_private;
>>> +	const struct seq_operations *seqops = sfs_data->seqops;
>>>
>>>    	/* now register seq file */
>>>    	err = seq_open(file, seqops);
>>>    	if (!err) {
>>>    		seq = file->private_data;
>>> -		seq->private = log;
>>> -	} else {
>>> -		goto out_free;
>>> +		seq->private = sfs_data->log;
>>>    	}
>>>
>>> -out:
>>>    	return err;
>>> -out_free:
>>> -	kfree(log->bios_event_log);
>>> -	kfree(log);
>>> -	goto out;
>>>    }
>>>
>>>    static const struct file_operations tpm_bios_measurements_ops = {
>>> @@ -372,6 +349,18 @@ static int is_bad(void *p)
>>>    int tpm_bios_log_setup(struct tpm_chip *chip)
>>>    {
>>>    	const char *name = dev_name(&chip->dev);
>>> +	int rc = 0;
>>> +
>>> +	rc = read_log(chip);
>>> +	/*
>>> +	 * read_log failure means event log is not supported except for ENOMEM
>>> +	 */
>>> +	if (rc < 0) {
>>> +		if (rc == -ENOMEM)
>>> +			return rc;
>>> +		else
>>> +			return 0;
>>> +	}
>>>
>>>    	chip->bios_dir_count = 0;
>>>    	chip->bios_dir[chip->bios_dir_count] =
>>> @@ -380,19 +369,24 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>>>    		goto err;
>>>    	chip->bios_dir_count++;
>>>
>>> +	chip->bin_sfs_data.log = &chip->log;
>>> +	chip->bin_sfs_data.seqops = &tpm_binary_b_measurments_seqops;
>>> +
>>>    	chip->bios_dir[chip->bios_dir_count] =
>>>    	    securityfs_create_file("binary_bios_measurements",
>>>    				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
>>> -				   (void *)&tpm_binary_b_measurments_seqops,
>>> +				   (void *)&chip->bin_sfs_data,
>>>    				   &tpm_bios_measurements_ops);
>>>    	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
>>>    		goto err;
>>>    	chip->bios_dir_count++;
>>>
>>> +	chip->ascii_sfs_data.log = &chip->log;
>>> +	chip->ascii_sfs_data.seqops =  &tpm_ascii_b_measurments_seqops;
>>>    	chip->bios_dir[chip->bios_dir_count] =
>>>    	    securityfs_create_file("ascii_bios_measurements",
>>>    				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
>>> -				   (void *)&tpm_ascii_b_measurments_seqops,
>>> +				   (void *)&chip->ascii_sfs_data,
>>>    				   &tpm_bios_measurements_ops);
>>>    	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
>>>    		goto err;
>>> @@ -413,4 +407,5 @@ void tpm_bios_log_teardown(struct tpm_chip *chip)
>>>    		securityfs_remove(chip->bios_dir[i-1]);
>>>    	chip->bios_dir_count = i;
>>>
>>> +	kfree(chip->log.bios_event_log);
>>>    }
>>> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
>>> index fd3357e..7ea066c 100644
>>> --- a/drivers/char/tpm/tpm_eventlog.h
>>> +++ b/drivers/char/tpm/tpm_eventlog.h
>>> @@ -22,6 +22,11 @@ struct tpm_bios_log {
>>>    	void *bios_event_log_end;
>>>    };
>>>
>>> +struct tpm_securityfs_data {
>>> +	struct tpm_bios_log *log;
>>> +	const struct seq_operations *seqops;
>>> +};
>>> +
>>>    struct tcpa_event {
>>>    	u32 pcr_index;
>>>    	u32 event_type;
>>> @@ -73,7 +78,7 @@ enum tcpa_pc_event_ids {
>>>    	HOST_TABLE_OF_DEVICES,
>>>    };
>>>
>>> -int read_log(struct tpm_bios_log *log);
>>> +int read_log(struct tpm_chip *chip);
>>>
>>>    #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
>>>    	defined(CONFIG_ACPI)
>>> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
>>> index 570f30c..68d891a 100644
>>> --- a/drivers/char/tpm/tpm_of.c
>>> +++ b/drivers/char/tpm/tpm_of.c
>>> @@ -20,12 +20,14 @@
>>>    #include "tpm.h"
>>>    #include "tpm_eventlog.h"
>>>
>>> -int read_log(struct tpm_bios_log *log)
>>> +int read_log(struct tpm_chip *chip)
>>>    {
>>>    	struct device_node *np;
>>>    	const u32 *sizep;
>>>    	const u64 *basep;
>>> +	struct tpm_bios_log *log;
>>>
>>> +	log = &chip->log;
>>>    	if (log->bios_event_log != NULL) {
>>>    		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
>>>    		return -EFAULT;
>>> --
>>> 2.5.0
>>>
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
