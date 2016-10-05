From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Wed, 5 Oct 2016 18:15:26 +0300
Message-ID: <20161005151526.GA9847@intel.com>
References: <20161002101755.GA25844@intel.com>
	<20161002102455.GA27464@intel.com>
	<20161002212126.GA25872@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
	<20161003124836.GE9990@intel.com>
	<20161004051946.GA10572@intel.com>
	<20161004164738.GA17149@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
	<20161004231057.GA20062@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F5084@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F5084-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
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

On Wed, Oct 05, 2016 at 07:48:59AM +0000, Winkler, Tomas wrote:
> > >
> > > > On Tue, Oct 04, 2016 at 08:19:46AM +0300, Jarkko Sakkinen wrote:
> > > >
> > > > > > Make the driver uncallable first. The worst race that can happen
> > > > > > is that open("/dev/tpm0", ...) returns -EPIPE. I do not consider
> > > > > > this fatal at all.
> > > > >
> > > > > No responses for this reasonable proposal so I'll show what I mean:
> > > >
> > > > How is this any better than what Thomas proposed? It seems much
> > > > worse to me since now we have even more stuff in the wrong order.
> > > >
> > > > There are three purposes to the ordering as it stands today
> > > >  1) To guarantee that tpm2_shutdown is the last command delivered to
> > > >     the TPM. When it is issued all other ways to access the device
> > > >     are hard fenced off.
> > >
> > > I'm not sure where are you taking this requirements from simple bit is
> > > just enough to make the HW inaccessible if the interface is designed
> > > right.
> > 
> > I'm having a hard time understanding the english in your email. (Jarkko do you
> > know what Tomas is talking about??)
> 
> Will try to do better. 

Jason, sorry your question slipped while going through the dicussion
:-)

I think I'll take the standpoint that I'll wait for the next version.

The important thing is to notice that runtime PM requires the device
to be "alive" and in the device hierarchy. It's a constraint...

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
