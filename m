From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Allow tpm_tis to be bound using DT
Date: Wed, 26 Oct 2016 17:16:04 +0100
Message-ID: <20161026161604.GB23322@leverpostej>
References: <20161025232331.GA20339@obsidianresearch.com>
 <20161026105527.cd6hcn37vmboshue@intel.com>
 <20161026160505.GC24898@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161026160505.GC24898-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 26, 2016 at 10:05:05AM -0600, Jason Gunthorpe wrote:
> On Wed, Oct 26, 2016 at 01:55:27PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Oct 25, 2016 at 05:23:31PM -0600, Jason Gunthorpe wrote:
> > > This provides an open firwmare driver binding for tpm_tis. OF
> > > is useful on arches where ACPI/PNP is not used.
> > > 
> > > The tcg,tpm_tis-mmio register map interface is specified by the TCG.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > >  .../bindings/security/tpm/tpm_tis_mmio.txt         | 22 ++++++++++++++++++++++
> > 
> > I'll do a proper review later on but should this change be a separate
> > commit or not?
> 
> I've understood it is OK for tiny source patches, large ones should be
> split. In either case they both go through your tree together. The DT
> mailing list just does not want to be spammed...

In general we ask that binding modifications are in a separate patch,
earlier in the series (see [1]), but in cases where the additions are
small, we're not too bothered.

As for why, it's about making it easier to spot the parts we need to act
on. We still would like to see the entire series (and ask that we're
cc'd [1]), as this can be useful context for review, and there are often
mismatches between the documented binding and code that we may spot.

Thanks,
Mark.

[1] Documentation/devicetree/bindings/submitting-patches.txt
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
