From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Wed, 5 Oct 2016 20:07:48 -0600
Message-ID: <20161006020748.GA17479@obsidianresearch.com>
References: <20161003124836.GE9990@intel.com>
	<20161004051946.GA10572@intel.com>
	<20161004164738.GA17149@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
	<20161004231057.GA20062@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F5084@hasmsx108.ger.corp.intel.com>
	<20161005171132.GE18636@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F54E9@hasmsx108.ger.corp.intel.com>
	<20161005211656.GA20920@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F561B@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F561B-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
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

On Thu, Oct 06, 2016 at 12:43:13AM +0000, Winkler, Tomas wrote:

> > You keep asserting that, but it just isn't true at all.
> 
> Okay, let's rephrase, that calling device_del before tpm_transmit is not sane when using runtime_pm.

Maybe, but I haven't heard an explanation from you why that is the case,
and I haven't found one on my own..

> > Sure, but that relationship only maters if something does a PM call on the
> > chip->dev, and AFAIK, nothing does that.
> > 
> > Do you know differently?
> 
> You've pasted that code in in the previous mail, parent is involved on device remove.

I pasted the code to show it didn't seem possible to hit it because
irq_safe should not be true for chip->dev. You never explained how
this code can run.

> > You pointed at something that isn't even run and said it is the source of the
> > problem.. You really need to set up here and explain exactly what is
> > happening.
> 
> Sorry, lost you here.

You haven't done a good job explaining the problem in detail beyond some general
blame toward PM.

> > > > Even if that pm_runtime_put is happening, why doesn't the
> > > >
> > > > +    pm_runtime_get_sync(chip->dev.parent);
> > > >
> > > > The runtime_pm patch adds to tpm_transmit take care of bringing the
> > > > device back?
> > >
> > > Unfortunately not because, because it gets out of sync and what is
> > > actually happening is that idle callback is called and device is put
> > > to idle between send and receive.
> > 
> > What? As far as I understand this PM stuff, I would call that a very serious bug.
> 
> Maybe, but then you have to find what a bug,  currently it looks
> like wrong usage of the device.

Yes, you actually have to find and explain the bug to fix it.

You still haven't explained at all why device_del on the child causes
pm_runtime_get_sync() on the parent to malfunction. There is certainly
seems to be nothing intrinsic about the PM core that would cause that.

*That* is the really critical bit of explanation that is missing.

Until you can provide it there is no reason to continue discussing.

> > If a PM transition during transmit_cmd causes the TPM to abort/fail command
> > execution then it *MUST* be prevented. Period.
> 
> Or, we can call device_del after tpm2_shutdown. 

What? You haven't even established root cause, how do you know this
bug won't manifest in other cases? It could very well be some kind of
generic race-bug triggered by the proximity of device_del and
pm_runtime_get_sync. Or a HW bug of some kind..

> I will send you the actual trace, anyhow I've respin the original
> version with go_idle and cmd_ready handlers, this is contra
> productive, the time is just not right.

I'm deeply skeptical about all your patches if you can't root-cause
identify why the existing implementation isn't working.

But, you can sort out with Jarkko what to do with crb.

As long at the rest of the drivers and the core subsystem are not
broken by the device_del change. Jarkko - can you confirm you will
drop that patch?

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
