From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Allow tpm_tis to be bound using DT
Date: Wed, 26 Oct 2016 10:01:53 -0600
Message-ID: <20161026160153.GA24898@obsidianresearch.com>
References: <20161025232331.GA20339@obsidianresearch.com>
 <20161026112351.GH19965@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161026112351.GH19965@leverpostej>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 26, 2016 at 12:25:51PM +0100, Mark Rutland wrote:

> > +Required properties:
> > +
> > +- compatible: should specify the actual hardware chip followed by the
> > +  generic interface name "tcg,tpm_tis-spi";
> 
> Please use '-' in comaptible strings rather than '_'.

Erk, there is also a typo spi vs mmio.

Note that the SPI patches were already Ack'd by DT so there is now
precedent:

Documentation/devicetree/bindings/security/tpm/tpm_tis_spi.txt:    "tcg,tpm_tis-spi"

Do you still want to change? Should we change spi too?

> Please also describe chip strings, even if those aren't use by the
> driver, e.g.

Sure, I can give one or two, but the list will not be exhaustive,
there are many different TPM chips that adhere to this standard.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
