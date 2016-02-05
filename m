From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: resource sanity fails on ioremap
Date: Fri, 5 Feb 2016 08:47:04 -0800
Message-ID: <20160205164704.GA8112@intel.com>
References: <20160203233701.GA10585@intel.com>
	<20160204234947.GA20269@obsidianresearch.com>
	<20160205040500.GA7708@intel.com>
	<20160205050850.GA23820@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160205050850.GA23820-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Thu, Feb 04, 2016 at 10:08:50PM -0700, Jason Gunthorpe wrote:
> On Thu, Feb 04, 2016 at 08:05:00PM -0800, Jarkko Sakkinen wrote:
> 
> > 4.4 does not use devm_ioremap_resource(). That is why this is
> > confusing. If that was the kernel from my master branch, then this
> > would make sense.
> 
> It makes sense, the MSFT resource is created by the kernel when it
> parses the ACPI tables.
> 
> devm_ioremap_resource creates a child resource of the above owned by
> the driver.
> 
> Eg, a PCI example:
> 
> $ cat /proc/iomem
>     d0000000-d0003fff : 0000:06:00.0
>           d0000000-d0003fff : r8169
> 
> 0000:06:00.0 is created by parsing the BAR, it always exists,
> equivalent to the MSFT resource
> 
> r8169 is created when the driver attaches to it, and serves to lock
> the memory range from other drivers.
> 
> tpm_crb works the same.
> 
> ioremap complains if a mapping crosses any resource boundary, not
> just driver created resources.

Right, thanks for the explanation and I'm able to reproduce it on my own
work laptop now:

[    0.708272] resource sanity check: requesting [mem
0xfed10000-0xfed15fff], which spans more than pnp 00:01 [mem
0xfed10000-0xfed13fff]
[    0.708302]  [<ffffffff8108548a>] ? iomem_map_sanity_check+0xba/0xd0

Luckily we have this fixed (in two commits) in 4.5.

> Jason

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
