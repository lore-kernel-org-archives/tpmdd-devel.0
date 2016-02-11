From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: resource sanity fails on ioremap
Date: Thu, 11 Feb 2016 08:39:37 +0200
Message-ID: <20160211063936.GA9307@intel.com>
References: <20160203233701.GA10585@intel.com>
	<20160204234947.GA20269@obsidianresearch.com>
	<20160205040500.GA7708@intel.com>
	<20160205050850.GA23820@obsidianresearch.com>
	<20160205164704.GA8112@intel.com>
	<20160205174258.GA29116@obsidianresearch.com>
	<20160205192857.GA23523@intel.com>
	<20160210122227.GA31734@intel.com>
	<20160210124216.GA18392@intel.com>
	<20160210160238.GA20730@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160210160238.GA20730-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: jethro-LmnypSVwBK6EVqv0pETR8A@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 10, 2016 at 09:02:38AM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 10, 2016 at 02:42:16PM +0200, Jarkko Sakkinen wrote:
> 
> > So would the right thing to do change it request size of the control
> > area structure (in the call site of crb_map_res)?
> 
> I'm guessing so, where did the 0x1000 fixed size come from? If it is
> just made up then surely use sizeof() instead

To be honest it came from my false understanding that ioremap() should
map in page granularity. I've only used it before doing tpm_crb in that
granularity.

> Jason

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
