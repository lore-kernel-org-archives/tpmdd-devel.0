From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Thu, 6 Oct 2016 14:10:47 -0600
Message-ID: <20161006201047.GA12085@obsidianresearch.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001120125.GC8664@intel.com>
	<20161001165436.GB13462@obsidianresearch.com>
	<57F6AC7D.9070507@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57F6AC7D.9070507-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Oct 07, 2016 at 01:26:45AM +0530, Nayna wrote:

> - there is no kref increment during eventlog fops or seq_ops operations.
> - fops and seq ops are parsing over memory buffer. fops->open() returns
> after giving the memory buffer(log) to seq->open(). And, seq ops on reading
> of log memory are not bound to any locks or krefs.

I sent a email about this, you are missing a get_device(chip) in open.
(see entry Jason Gunthorpe - Oct. 3, 2016, 5:14 p.m.
 https://patchwork.kernel.org/patch/9353259/ )

> - once securityfs_remove() is done, there are no more files accessible to
> user to do open(). Which implies, there can't be any new open() after chip
> unregister, but existing open() might continue to work(this is I expecting
> for now).

Right..

> However, I do see one issue as I am freeing log.bios_event_log during
> teardown().

Correct, I thought I pointed that out last round, that kfree must be
moved to tpm_dev_release

> which implies seq_ops might fail if there is no proper null
> checks for log.bios_event_log.

No, hold the chip mutex between fops->open() -> release() which will
ensure that the log memory continues exists.

> #1. Do we want securityfs_remove() to wait till all the opened eventlog
> files are closed().

That is not simple, or necessary..

> #2 Are we ok with securityfs_remove() being done and files are removed, but
> existing seq ops, eventlog parsing should continue to work till closed by
> user. That implies, we should not unknowingly nullify log pointers which are
> used by parser.

This is simpler, moving the kfree to tpm_dev_release and holding the
chip kref for the lifetime of the filp is easy and safe.

> I took sometime to understand how is kref getting accessed for tpm_chip. And
> I tried tracing krefs. I have been looking at
> chip->dev.kobj.kref.. Please

Right, it used with get_device/put_device

The model to go for is that open() acquires a get_device() kref on
the chip and that kref is held for the duration of the lifetime of the
filp.

The log and data members of chip must remain allocated and unchanged until
tpm_dev_release.

Try something like the algorithm I gave in 'Jason Gunthorpe - Oct. 4,
2016, 5:12 p.m.' to solve the remove/open race for now with a big fat
comment.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
