From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Mon, 3 Oct 2016 17:30:31 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F4775@hasmsx108.ger.corp.intel.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
	<20161002101755.GA25844@intel.com> <20161002102455.GA27464@intel.com>
	<20161002212126.GA25872@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F46C1@hasmsx108.ger.corp.intel.com>
	<20161003124225.GD9990@intel.com>
	<20161003160308.GA6801@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161003160308.GA6801-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> 
> On Mon, Oct 03, 2016 at 03:42:25PM +0300, Jarkko Sakkinen wrote:
> 
> > > I've looked to the registration code and it indeed has few more
> > > issues
> 
> ?
> 
> > > Maybe TPM_CHIP_FLAG_REGISTERED can be used for sealing the access to
> > > the device during deregistration, current usage is void.
> 
> This is done via chip->ops = NULL and the rwlock scheme.
I'm not this is the best choice, kind of unusual in the subsystems.  
> 
> > Good catch BTW. This flag has gone quite obsolote.
> 
> I think all the drivers have been updated at this point so we can probably get
> rid of it entirely.

I would actually keep it for the tpm2_shutdown exception, not sure this can be handled by ops  = NULL and rwlock.


Thanks
Tomas

> 
> Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
