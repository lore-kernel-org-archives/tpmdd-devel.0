From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: resource sanity fails on ioremap
Date: Thu, 4 Feb 2016 20:05:00 -0800
Message-ID: <20160205040500.GA7708@intel.com>
References: <20160203233701.GA10585@intel.com>
	<20160204234947.GA20269@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160204234947.GA20269-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Thu, Feb 04, 2016 at 04:49:47PM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 03, 2016 at 03:37:01PM -0800, Jarkko Sakkinen wrote:
> > Hi
> > 
> > I've been investigating this bug:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=111511
> > 
> > In all the machines that I've tried tpm_crb this does not occur on 4.4
> > kernel and still the ioremapped buffers do interleave. It looks as if
> > something that is not tpm_crb added that memory area to iomem_resource
> > because 4.4 driver uses ioremap_nocache() and does not add anything to
> > the resource tree.
> 
> The error says the BIOS set the ACPI resource for MSFT0101:00 to
> 0xfed40000-0xfed4087f and then proceeded to say that the region
> 0xfed40040-0xfed4103f is one of the additional TPM resources.
> 
> Is this right?
> 
>         priv->cca = crb_access(dev, priv, buf->control_address, 0x1000);
> 
> Where did 0x1000 come from?
> 
> Why not sizeof(crb_control_area) ?

4.4 does not use devm_ioremap_resource(). That is why this is
confusing. If that was the kernel from my master branch, then this
would make sense.

> Jason

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
