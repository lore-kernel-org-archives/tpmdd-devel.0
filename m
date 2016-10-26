From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Allow tpm_tis to be bound using DT
Date: Wed, 26 Oct 2016 10:05:05 -0600
Message-ID: <20161026160505.GC24898@obsidianresearch.com>
References: <20161025232331.GA20339@obsidianresearch.com>
 <20161026105527.cd6hcn37vmboshue@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161026105527.cd6hcn37vmboshue-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 26, 2016 at 01:55:27PM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 25, 2016 at 05:23:31PM -0600, Jason Gunthorpe wrote:
> > This provides an open firwmare driver binding for tpm_tis. OF
> > is useful on arches where ACPI/PNP is not used.
> > 
> > The tcg,tpm_tis-mmio register map interface is specified by the TCG.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >  .../bindings/security/tpm/tpm_tis_mmio.txt         | 22 ++++++++++++++++++++++
> 
> I'll do a proper review later on but should this change be a separate
> commit or not?

I've understood it is OK for tiny source patches, large ones should be
split. In either case they both go through your tree together. The DT
mailing list just does not want to be spammed...

Jason
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
