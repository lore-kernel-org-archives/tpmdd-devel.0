From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Allow tpm_tis to be bound using DT
Date: Wed, 26 Oct 2016 17:05:06 +0100
Message-ID: <20161026160506.GA23322@leverpostej>
References: <20161025232331.GA20339@obsidianresearch.com>
 <20161026112351.GH19965@leverpostej>
 <20161026160153.GA24898@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161026160153.GA24898-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 26, 2016 at 10:01:53AM -0600, Jason Gunthorpe wrote:
> On Wed, Oct 26, 2016 at 12:25:51PM +0100, Mark Rutland wrote:
> 
> > > +Required properties:
> > > +
> > > +- compatible: should specify the actual hardware chip followed by the
> > > +  generic interface name "tcg,tpm_tis-spi";
> > 
> > Please use '-' in comaptible strings rather than '_'.
> 
> Erk, there is also a typo spi vs mmio.

Urgh; missed that too.

> Note that the SPI patches were already Ack'd by DT so there is now
> precedent:
> 
> Documentation/devicetree/bindings/security/tpm/tpm_tis_spi.txt:    "tcg,tpm_tis-spi"

Urgh, that should not have gone in as-is.

> Do you still want to change? 

Regardless of the bad example in the SPI case, this should use a dash.

> Should we change spi too?

That was in v4.8, so it's too late to change it now.

> > Please also describe chip strings, even if those aren't use by the
> > driver, e.g.
> 
> Sure, I can give one or two, but the list will not be exhaustive,
> there are many different TPM chips that adhere to this standard.

Just the one from the example for now is fine; we can add new ones as we
add DTs that use them.

Thanks,
Mark.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
