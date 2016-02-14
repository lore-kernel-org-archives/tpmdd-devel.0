From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm: Get rid of chip->pdev
Date: Sun, 14 Feb 2016 10:03:20 +0200
Message-ID: <20160214080320.GC11156@intel.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1455321871-28296-3-git-send-email-jgunthorpe@obsidianresearch.com>
	<201602130037.u1D0bDEN029756@d01av04.pok.ibm.com>
	<20160213011130.GA2547@obsidianresearch.com>
	<201602130128.u1D1S2Xn006955@d01av05.pok.ibm.com>
	<20160213033320.GA27869@obsidianresearch.com>
	<20160214052414.GB8065@intel.com>
	<20160214065724.GD9551@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160214065724.GD9551-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Feb 13, 2016 at 11:57:24PM -0700, Jason Gunthorpe wrote:
> On Sun, Feb 14, 2016 at 07:24:14AM +0200, Jarkko Sakkinen wrote:
> > > This should take care of it for all drivers including vtpm.
> > > 
> > > https://github.com/jgunthorpe/linux/commits/for-jarkko
> > > 
> > > At the very least this turns silent use after free into a null pointer
> > > oops.
> > > 
> > > We should also discuss if we want to continue to have the driver
> > > module locked while /dev/tpmX is open, that is no longer needed for
> > > corectness.
> > 
> > I'm happy the patch that was sent before although I didn't give it
> > Reviewed-by because it had couple of style errors. If those two
> > style errors are the *only* issues I can fix up them.
> 
> This patch replaces the get/put_device patch entirely, if Stefan is
> happy with it we can just go ahead in this direction for 4.6
> 
> There was also a 0day build error on the devname patch, so the whole
> series will be reposted.

Perfect, thank you.

> Jason

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
