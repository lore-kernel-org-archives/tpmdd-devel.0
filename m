From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 2/7] tpm_tis: Disable interrupt auto
 probing on a per-device basis
Date: Mon, 4 Jan 2016 20:32:42 +0200
Message-ID: <20160104183242.GA16334@intel.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1450376600-6970-3-git-send-email-jgunthorpe@obsidianresearch.com>
	<20160103172040.GB4155@intel.com>
	<20160104182442.GC20016@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160104182442.GC20016-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Martin Wilck <Martin.Wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 04, 2016 at 11:24:42AM -0700, Jason Gunthorpe wrote:
> On Sun, Jan 03, 2016 at 07:20:40PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Dec 17, 2015 at 11:23:15AM -0700, Jason Gunthorpe wrote:
> > > Instead of clearing the global interrupts flag when any device
> > > does not have an interrupt just pass -1 through tpm_info.irq.
> > > 
> > > The only thing that asks for autoprobing is the force=1 path.
> > 
> > Sorry for my ignorance but what does this patch help? Why interrupts
> > flag is not enough?
> 
> It is wrong for a driver's probe function to change global state, and
> very wrong to change a module option.

I disagree about global state in some sense but module options should
stay static. That's much better argument.

> > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > Tested-by: Wilck, Martin <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
> > > Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > 
> > Did I already give Tested-by's for this series (I did for those that
> > went into v4.5 pull request)?
> 
> You said you tested the crb stuff, which is this series... Did you
> test something else?

Checked my emails. Right I did run my tests for this (both with FIFO
and CRB driver). It was bit "stormy" before Christmas with all kinds
of small patches so I wasn't sure.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

> Jason

/Jarkko

------------------------------------------------------------------------------
