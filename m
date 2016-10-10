From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Mon, 10 Oct 2016 07:23:33 +0530
Message-ID: <57FAF49D.7040009@linux.vnet.ibm.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161003171419.GE6801@obsidianresearch.com>
	<57F9C4C4.2070508@linux.vnet.ibm.com>
	<20161009232544.GC24139@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161009232544.GC24139-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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



On 10/10/2016 04:55 AM, Jason Gunthorpe wrote:
> On Sun, Oct 09, 2016 at 09:47:08AM +0530, Nayna wrote:
>
>>>> +	const struct tpm_securityfs_data *sfs_data =
>>>> +		(const struct tpm_securityfs_data *)inode->i_private;
>>>> +	const struct seq_operations *seqops = sfs_data->seqops;
>>>
>>> You need a get_device(&chip->dev) here, and the matching put_device in fops->release().
>>>
>>>> +		seq->private = sfs_data->log;
>>>
>>> So store the chip here
>
>> Sorry, I think I didn't understand the purpose of storing chip here.
>
> Since we need to do get_device in open() you need to do put_device
> in release()
>
> How will you reliably do put_device if you do not store chip in the
> seq_private?

We are storing tpm_securityfs_data in inode->private.
Currently, tpm_securityfs_data is

struct tpm_securityfs_data {
         struct tpm_bios_log *log;
         const struct seq_operations *seqops;
};

This, I am changing in new version to

struct tpm_securityfs_data {
         struct tpm_bios_log *chip;
         const struct seq_operations *seqops;
};

And we pass this as private data to i_node in tpm_bios_log_setup.

So, we are referring chip as i_node->i_private->chip.

And both open() and release() gets i_node as input parameter.

Thanks & Regards,
   - Nayna

>
> Jason
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
