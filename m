From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Mon, 3 Oct 2016 10:35:16 -0600
Message-ID: <20161003163516.GB6801@obsidianresearch.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001120125.GC8664@intel.com>
	<20161001165436.GB13462@obsidianresearch.com>
	<20161001193239.GA3862@intel.com>
	<20161002212551.GB25872@obsidianresearch.com>
	<20161003122013.GA9990@intel.com> <20161003123523.GC9990@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161003123523.GC9990-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Mon, Oct 03, 2016 at 03:35:23PM +0300, Jarkko Sakkinen wrote:

> > > The scheme you suggested is also way off the mark for how fops works,
> > > fops->close has no relation to the needed duration for 'data', the
> > > duration is related to securityfs_remove.
> > 
> > Right, the above would not work because it's not linked to
> > securityfs_remove by any means.
> > 
 
> You have to provide something factors more concrete. Otherwise,
> I'm inclined to accept the approach in Naynas patch. It's an
> improvement.

I said I haven't checked the patch yet to see if the lifetime model
for 'data' with securityfs is correct. Only that it matches the only
other user of this feature..

I looked more carefully, and I still can't find the right sort of
locking in securityfs_remove..

> > Are you trying to say that after securityfs_remove() there might be a
> > "grace period" when user space could still see the files visible and
> > open them?

Sort of, the typical race is broadly

    CPU0                           CPU1

fops->open()
                                securityfs_remove()
				kref_put(chip)
				kfree(chip)
kref_get(data->chip.kref)

This race should always be analyzed when working with user files.

We deal with this situation in the other user interface:
- cdev uses 'chip->cdev.kobj.parent = &chip->dev.kobj;' and the cdev
  core handles get/put of the chip at the proper time
- sysfs uses kernfs_drain which guarentees nothing is running in any
  callback before returning

I suspect securityfs_remove is defective in this regard. Eg debugfs is
built on the same libfs scheme as securityfs and it incorporates the
mechanism around 'debugfs_use_file_start/etc' to provide sensible
removal fencing.

I don't know if there is a simple fix, so mabye the best thing is to
just leave it be with a comment saying it securityfs_remove probably
races with fops->open(), and that should be fixed inside securityfs
not tpm.

The file operations are also missing '.owner = THIS_MODULE' which is
bad as well.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
