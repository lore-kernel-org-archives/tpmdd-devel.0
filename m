From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm,
 tpm_crb: fix control area resource mapping
Date: Fri, 29 Jan 2016 15:33:34 -0700
Message-ID: <20160129223334.GA14129@obsidianresearch.com>
References: <1454051639-15961-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160129204826.GA30177@obsidianresearch.com>
	<20160129222108.GA25327@intel.com>
	<20160129222654.GB25327@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160129222654.GB25327-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Fri, Jan 29, 2016 at 02:26:54PM -0800, Jarkko Sakkinen wrote:
> On Fri, Jan 29, 2016 at 02:21:08PM -0800, Jarkko Sakkinen wrote:
> > On Fri, Jan 29, 2016 at 01:48:27PM -0700, Jason Gunthorpe wrote:
> > > On Thu, Jan 28, 2016 at 11:13:59PM -0800, Jarkko Sakkinen wrote:
> > > 
> > > > -	struct resource tmp = {};
> > > > -
> > > > -	tmp.start = start;
> > > > -	tmp.end = start + size - 1;
> > > > -	tmp.flags = IORESOURCE_MEM;
> > > > +	struct resource new_res = {
> > > > +		.start	= start,
> > > > +		.end	= size - 1,
> > > 
> > > That isn't right.
> > 
> > Whoops. Good catch, I'll update it before pull request. Thanks!
> 
> github.com/jsakkine/linux-tpmdd/commit/5012960093774c49d81c612eb32f92cfa1f619bc
> 
> struct resource new_res = {
> 	.start	= start,
> 	.end	= start + size - 1,
> 	.flags	= IORESOURCE_MEM,
> };
> 
> Better?

Yes that looks ok

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
