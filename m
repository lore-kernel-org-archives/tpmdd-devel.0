From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Tue, 4 Oct 2016 08:26:51 +0300
Message-ID: <20161004052651.GB10572@intel.com>
References: <1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001120125.GC8664@intel.com>
	<20161001165436.GB13462@obsidianresearch.com>
	<20161001193239.GA3862@intel.com>
	<20161002212551.GB25872@obsidianresearch.com>
	<20161003122013.GA9990@intel.com> <20161003123523.GC9990@intel.com>
	<20161003163516.GB6801@obsidianresearch.com>
	<20161003202230.GA14624@intel.com>
	<20161003211129.GA26880@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161003211129.GA26880-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Mon, Oct 03, 2016 at 03:11:29PM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 03, 2016 at 11:22:30PM +0300, Jarkko Sakkinen wrote:
> 
> > > Sort of, the typical race is broadly
> > > 
> > >     CPU0                           CPU1
> > > 
> > > fops->open()
> > >                                 securityfs_remove()
> > > 				kref_put(chip)
> > > 				kfree(chip)
> > > kref_get(data->chip.kref)
> > 
> > I see. So could this be reproduced by:
> > 
> > 1. Open binary_measurements.
> > 2. rmmod tpm_tis
> > 3. Read contents of binary_measurements.
> 
> No, but that method shows the bug I pointed out in my email to Nayna
> where the fops stuff is not getting a kref on the chip.
> 
> You need to actually race open and securityfs_remove to see the
> kref_get() loose its race and then use-after-free.

So you are worried that get_device() might come when the chip is already
gone?

> > Yeah, I get it. These securityfs files are nasty in a way compared to
> > sysfs attributes that they are not connected to the device hierachy.
> 
> Well, it is not so bad, it is just missing the fence on removal that
> sysfs has, or the kref tracking that cdev has. Sadly this is a typical
> error within the fops stuff, I've seen it in many places.

Do you think that this should be fixed above the driver i.e. add fencing
to the securityfs code itself?

> > Rather than finding a perfect solution in the code I think a better
> > angle would be find ways to test and reproduce possible races, which
> > you already started in your response.
> 
> That would be very hard to do, racing two calls like that is
> quite difficult in any sort of automatic way, AFAIK.

I wonder if SPI has similar file to 'remove' that PCI devices have
(checking from the documentation later on).

> > Right now we basically don't have any good acceptance criteria to make
> > any changes to securityfs stuff. Yes, you can do the analysis (and
> > should) but human mind is weak sometimes :)
> 
> Since it is unlikely and not caused by our subsystem I'm inclined to
> just leave a comment (that we expect securityfs_remove to fence) and
> you can send a note to James to see what they think.

Agreed.

> Jason

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
