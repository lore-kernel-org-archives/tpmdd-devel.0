From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] Add "shutdown" to "struct class".
Date: Mon, 15 May 2017 20:49:16 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B641D90DB@hasmsx108.ger.corp.intel.com>
References: <20170515173438.13420-1-joshz@google.com>
	<CAHSjozBLBUpSzxrRsfnO49Thf9__MHdOmUdsX+5ST55=T2BWLA@mail.gmail.com>
	<20170515174533.GB6229@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170515174533.GB6229-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, May 15, 2017 20:46
> To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Winkler, Tomas <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Jarkko
> Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>; tpmdd-
> devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Subject: Re: [PATCH v3] Add "shutdown" to "struct class".
> 
> On Mon, May 15, 2017 at 10:39:08AM -0700, Josh Zimmerman wrote:
> > (Continuing thread from patch v1)
> > > > On Sat, May 13, 2017 at 12:43:11PM +0000, Winkler, Tomas wrote:
> > > > > > The TPM class has some common shutdown code that must be
> > > > > > executed for all drivers. This adds some needed functionality
> > > > > > for that
> > > > >
> > > > > The issue with this is, that on some platforms the only storage
> > > > > can be eMMC and TPM is using it,. It has to be ensured that the
> > > > > storage device won't go down before TPM2_shutdown is called.
> > > > > And there is no direct device hierarchy to ensure an orderly
> shutdown.
> > > >
> > > > Something will have to use the new device links stuff to define
> > > > that dependency, but that seems unrelated to this patch?
> > >
> > >
> > > Yep, it's not directly related to this specific patch, this is more relevant
> particularly to TPM2_shutdown.
> >
> > Jason, do you want me to do that in my patch on the tpmdd-devel list?
> > If so, mind giving me a documentation pointer or two? I'm not familiar
> > with this area.
> 
> No.. Ordering power management events is something someone with
> knowledge of the specific emmc platform is going to have to tackle..
> It isn't really a core problem, platform specific code will have to setup the
> needed device links to order power management properly..

eMMC is just an example, that can be other storage device (ufs, nvme) and some type of abstraction of underlying storage
dependency would be required. I just wanted to put it on the table, not sure it has to be solved in this round.
Tomas




> 
> Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
