From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm: Hold the kref during
	tpm_chip_find_get
Date: Sat, 13 Feb 2016 23:50:08 -0700
Message-ID: <20160214065008.GC9551@obsidianresearch.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1455321871-28296-2-git-send-email-jgunthorpe@obsidianresearch.com>
	<20160214045512.GA7777@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160214045512.GA7777-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Feb 14, 2016 at 06:55:12AM +0200, Jarkko Sakkinen wrote:
> On Fri, Feb 12, 2016 at 05:04:29PM -0700, Jason Gunthorpe wrote:
> > This was missed during the struct device conversion, we
> > need to hold a kref on the chip to make sure it isn't freed.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> I'm bit confused about this patch. What is the regression if this
> needs

The patch is simply totally broken, the placement of the get_device is
wrong:

> > @@ -53,6 +53,8 @@ struct tpm_chip *tpm_chip_find_get(int chip_num)
> >  			chip = pos;
> >  			break;
> >  		}
> > +
> > +		get_device(&chip->dev);

It needs to be moved up two lines before the break, into the if
statement.

As for the urgency - today the tpm core relies on module locking to
try and prevent tpm_chip_unregister from racing with stuff like the
above. That is totally broken in modern kernels, but it is what the
core tries to do. Within that framework the get/put are not needed
because of the module locking.

The only time these additional get/put do anything is when we are
racing with tpm_unregister, but if we are racing with unregister then
there are much bigger problems and things will crash anyhow.

So, this patch is just a tiny step.

The revised version of this patch with the rw_sem attempts to address
the complete race.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
