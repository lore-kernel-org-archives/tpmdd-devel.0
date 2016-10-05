From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Wed, 5 Oct 2016 11:10:14 +0300
Message-ID: <20161005081014.GA15794@intel.com>
References: <20161001165436.GB13462@obsidianresearch.com>
	<20161001193239.GA3862@intel.com>
	<20161002212551.GB25872@obsidianresearch.com>
	<20161003122013.GA9990@intel.com> <20161003123523.GC9990@intel.com>
	<20161003163516.GB6801@obsidianresearch.com>
	<20161003202230.GA14624@intel.com>
	<20161003211129.GA26880@obsidianresearch.com>
	<20161004052651.GB10572@intel.com>
	<20161004171231.GB17149@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161004171231.GB17149-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Tue, Oct 04, 2016 at 11:12:31AM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 04, 2016 at 08:26:51AM +0300, Jarkko Sakkinen wrote:
> > On Mon, Oct 03, 2016 at 03:11:29PM -0600, Jason Gunthorpe wrote:
> > > On Mon, Oct 03, 2016 at 11:22:30PM +0300, Jarkko Sakkinen wrote:
> > > 
> > > > > Sort of, the typical race is broadly
> > > > > 
> > > > >     CPU0                           CPU1
> > > > > 
> > > > > fops->open()
> > > > >                                 securityfs_remove()
> > > > > 				kref_put(chip)
> > > > > 				kfree(chip)
> > > > > kref_get(data->chip.kref)
> 
> > > You need to actually race open and securityfs_remove to see the
> > > kref_get() loose its race and then use-after-free.
> > 
> > So you are worried that get_device() might come when the chip is already
> > gone?
> 
> Yes, I'm worried that securityfs_remove doesn not guarentee that
> all threads running open() have completed and that no new threads can
> start an open(). If that is guarenteed then we are fine once the
> get_device is added.
> 
> There might be some tricky thing guaranteeing that but I haven't found
> it..

Great, thanks for time and patience explaining. This will help me a lot
to properly review the next revisions of this series.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
