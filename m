From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Fri, 7 Oct 2016 01:26:45 +0530
Message-ID: <57F6AC7D.9070507@linux.vnet.ibm.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001120125.GC8664@intel.com>
	<20161001165436.GB13462@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161001165436.GB13462-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 10/01/2016 10:24 PM, Jason Gunthorpe wrote:
> On Sat, Oct 01, 2016 at 03:01:25PM +0300, Jarkko Sakkinen wrote:
>
>>> +	struct tpm_securityfs_data bin_sfs_data;
>>> +	struct tpm_securityfs_data ascii_sfs_data;
>>
>> I think this is otherwise right but the struct name is very clunky.
>> First of all it doesn't own the data and IMHO now it kind of implies
>> of owning.
>
> These are passed in here:
>
>>>   	chip->bios_dir[chip->bios_dir_count] =
>>>   	    securityfs_create_file("ascii_bios_measurements",
>>>   				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
>>> -				   (void *)&tpm_ascii_b_measurments_seqops,
>>> +				   (void *)&chip->ascii_sfs_data,
>>>   				   &tpm_bios_measurements_ops);
>
> And the argument to securityfs_create_file is called 'data'..
>
> The key question with these patches is if all the locking is done
> right and we have the correct lifetime model now.
>
> Eg how much does securityfs_remove serialize and is the kref on the
> chip held for the duration of any fops. Can open() start after the
> kref is dropped, etc.

This is my understanding here:

        tpm_chip_register() --->bios log setup

fops->open()-->private data as "log"
seq->open()--->private data as "log"

        tpm_chip_unregister() ---> bios log teardown
                                   securityfs_remove()

Few things if I understood correctly:

- there is no kref increment during eventlog fops or seq_ops operations.
- fops and seq ops are parsing over memory buffer. fops->open() returns 
after giving the memory buffer(log) to seq->open(). And, seq ops on 
reading of log memory are not bound to any locks or krefs.
- once securityfs_remove() is done, there are no more files accessible 
to user to do open(). Which implies, there can't be any new open() after 
chip unregister, but existing open() might continue to work(this is I 
expecting for now).

However, I do see one issue as I am freeing log.bios_event_log during 
teardown(). which implies seq_ops might fail if there is no proper null 
checks for log.bios_event_log.

Also, now log is also part of tpm_chip, so once chip is deregistered and 
tpm_chip is free, log might also be freed, but then that implies that 
private "data" in fops->open() is no more valid anyway.

I do see there are issues with serializing, however, I am trying to 
understand that what type of solution are we looking for:

#1. Do we want securityfs_remove() to wait till all the opened eventlog 
files are closed().

OR

#2 Are we ok with securityfs_remove() being done and files are removed, 
but existing seq ops, eventlog parsing should continue to work till 
closed by user. That implies, we should not unknowingly nullify log 
pointers which are used by parser.

I took sometime to understand how is kref getting accessed for tpm_chip. 
And I tried tracing krefs. I have been looking at chip->dev.kobj.kref.. 
Please let me know if there is any other kref also.
And I found that currently eventlog is unassociated with tpm_chip as 
what everyone discussed. During fops-open(), there is no kref increment. 
But, do we want to make tpm_chip wait on eventlog files ? or are we fine 
with opened files accessible, but once closed they are not as files 
would be removed.

Please let me know if I am missing any internals.

Thanks & Regards,
    - Nayna

>
> Otherwise this scheme isn't good enough either :/
>
> I haven't looked in detail at that topic yet.. Maybe Nayna can explain
> what is expected here. Would be excellend to get someone from security to
> review this lifetime model.



>
> Jason
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
