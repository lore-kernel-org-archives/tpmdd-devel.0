From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Mon, 3 Oct 2016 11:30:28 -0600
Message-ID: <20161003173028.GF6801@obsidianresearch.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
	<20161002101755.GA25844@intel.com>
	<20161002102455.GA27464@intel.com>
	<20161002212126.GA25872@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
	<20161003160008.GE5722@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F474C@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F474C-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 03, 2016 at 05:16:18PM +0000, Winkler, Tomas wrote:

> > > Please be more specific regarding flows you think will be wrong with
> > > this patch, you must agree that the current code is broken even w/o
> > > runtime pm.
> > 
> > No, I don't agree. Accessing dev->name is OK after the device_del.
> 
> But you cannot assume that just dev->name is accessed and and
> runtime_pm breaks this assumption..

It was built around that assumption.

Our chip methods have been built to not require the device to be
registered. We call many of them before we even do device
registration, for instance.

The pm patches can't break that. What is the actual problem anyhow?

> > What devicde_del does is fence off all sorts of ways to access the device, eg
> > sysfs files, bus registrations, etc, etc. That absolutely must be done before
> > calling tpm_suspend.
> 
> But tpm2_shutdown is acceded via tpm_chip , we cannot call
> device_del before, this is just wrong from the Linux device mode
> perspective, we have to use other means to close the access to the
> device.

device_del is the means to close access - that it what it does -
unregister the device from the system. The tpm_chip must be
operational independent of a *registered* device. chip methods can
only assume that the device is *initialized*

This is a basic pattern followed by other subsystems.

This is why it is OK to look at dev->name, but not okay to muck with
other stuff under a chip method.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
