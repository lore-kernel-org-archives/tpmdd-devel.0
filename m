From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Fri, 14 Oct 2016 00:23:13 +0530
Message-ID: <57FFD819.80902@linux.vnet.ibm.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161003171419.GE6801@obsidianresearch.com>
	<57F9C4C4.2070508@linux.vnet.ibm.com>
	<20161009232544.GC24139@obsidianresearch.com>
	<57FAF49D.7040009@linux.vnet.ibm.com>
	<20161010032113.GA26363@obsidianresearch.com>
	<57FB1551.9000806@linux.vnet.ibm.com>
	<20161011165143.GA6881@obsidianresearch.com>
	<57FD3949.9050302@linux.vnet.ibm.com>
	<20161011201558.GB21656@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161011201558.GB21656-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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



On 10/12/2016 01:45 AM, Jason Gunthorpe wrote:
> On Wed, Oct 12, 2016 at 12:41:05AM +0530, Nayna wrote:
>
>> Yeah, I actually tried this today.
>> And on call of securityfs_remove(), release() gets called for the
>> opened
>
> Are you saying securityfs_remove somehow causes a synchronous call to
> release? How does that come about?

Sorry, I realized , that I missed to answer this in previous response.
I think I misinterpreted the sequence and there is no release() call on 
securityfs_remove().. Sorry for the confusion.

Thanks & Regards,
    - Nayna

>
>> There are actually two private data:
>> inode->private
>> seq->private
>>
>> I understand inode->private is where we pass sfs_data has both chip and
>> seqops. This is the one being used in open(), release() and defined as NULL
>> in teardown().
>
>> But seq->private is used by seq_ops. And I am still not sure how passing
>> seq->private as chip can help.
>
>> I might be missing something basic, so can you please help me to understand
>> that.
>
> open does:
>
>   struct tpm_chip *chip = inode->i_private
>   get_device(&chip->dev);
>   seq = file->private_data;
>   seq->private = chip;
>
> release does:
>
>   struct seq_file *seq = file->private_data;
>   struct tpm_chip *chip = seq->private;
>   put_device(&chip->dev);
>
> seqops like tpm_bios_measurements_start do:
>
>   struct tpm_chip *chip = m->private;
>   struct tpm_bios_log *log = &chip->log;
>
> [locking, error handling, and other stuff elided]
>
> open is the only thing that ever looks a inode->i_private.
>
> open krefs's chip and stores it in seq->private
>
> seqop accessors use seq->private->log to access the log, the memory of
> which is guared by the kref.
>
> release drops the kref on chip and does not use inode->i_private
>
> Jason
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
