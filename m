From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Thu, 6 Oct 2016 14:12:05 -0600
Message-ID: <20161006201205.GB12085@obsidianresearch.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001120125.GC8664@intel.com>
	<20161001165436.GB13462@obsidianresearch.com>
	<20161001193239.GA3862@intel.com>
	<20161002212551.GB25872@obsidianresearch.com>
	<20161003122013.GA9990@intel.com> <20161003123523.GC9990@intel.com>
	<20161003163516.GB6801@obsidianresearch.com>
	<57F6ACF7.6000408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57F6ACF7.6000408-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Fri, Oct 07, 2016 at 01:28:47AM +0530, Nayna wrote:
> >fops->open()
> >                                 securityfs_remove()
> >				kref_put(chip)
> >				kfree(chip)
> >kref_get(data->chip.kref)
> 
> I didn't understand which kref_get() are we referring here. I mean is it
> expected to happen somewhere during eventlog parsing, or exactly which code
> path ?

This is the missing get_device() I pointed out. Without a kref there
is nothing stopping the chip, data and log from being kfree'd.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
