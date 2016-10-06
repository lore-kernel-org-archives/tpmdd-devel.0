From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Thu, 6 Oct 2016 19:46:21 +0300
Message-ID: <20161006164621.GA4794@intel.com>
References: <20161002102455.GA27464@intel.com>
	<20161002212126.GA25872@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
	<20161003124836.GE9990@intel.com>
	<20161004051946.GA10572@intel.com>
	<20161004164738.GA17149@obsidianresearch.com>
	<20161005100234.GA20851@intel.com>
	<20161005162741.GA18636@obsidianresearch.com>
	<20161006112357.GA10533@intel.com>
	<20161006162245.GF1224@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161006162245.GF1224-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 06, 2016 at 10:22:45AM -0600, Jason Gunthorpe wrote:
> On Thu, Oct 06, 2016 at 02:23:57PM +0300, Jarkko Sakkinen wrote:
> 
> > I think that they should be fenced then for the sake of consistency.
> > I do not see why sysfs code is privileged not to do fencing while other
> > peers have to do it.
> 
> Certainly the locking could be changed, but it would be nice to have a
> reason other than aesthetics.
> 
> sysfs is not unique, we also do not grab the rwlock lock during any
> commands executed as part of probe. There are basically two locking
> regimes - stuff that is proven to by synchronous with probe/remove
> (sysfs, probe cmds) and everything else (kapi, cdev)
> 
> Further, the current sysfs implementation is nice and sane: the file
> accesses cannot fail with ENODEV. That is a useful concrete property
> and I don't think we should change it without a good reason.

The last point is certainly legit. I think it even might deserve a
comment of its own in tpm_del_char_device.

I think I have a good idea now what to do. Hold on for RFC patch.

> Jason

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
