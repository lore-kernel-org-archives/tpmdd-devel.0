From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: resource sanity fails on ioremap
Date: Fri, 5 Feb 2016 10:42:58 -0700
Message-ID: <20160205174258.GA29116@obsidianresearch.com>
References: <20160203233701.GA10585@intel.com>
	<20160204234947.GA20269@obsidianresearch.com>
	<20160205040500.GA7708@intel.com>
	<20160205050850.GA23820@obsidianresearch.com>
	<20160205164704.GA8112@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160205164704.GA8112-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jethro-LmnypSVwBK6EVqv0pETR8A@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 05, 2016 at 08:47:04AM -0800, Jarkko Sakkinen wrote:

> Right, thanks for the explanation and I'm able to reproduce it on my own
> work laptop now:
> 
> [    0.708272] resource sanity check: requesting [mem
> 0xfed10000-0xfed15fff], which spans more than pnp 00:01 [mem
> 0xfed10000-0xfed13fff]
> [    0.708302]  [<ffffffff8108548a>] ? iomem_map_sanity_check+0xba/0xd0
> 
> Luckily we have this fixed (in two commits) in 4.5.

We do? I don't recall seeing a commit that changes the 0x1000

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
