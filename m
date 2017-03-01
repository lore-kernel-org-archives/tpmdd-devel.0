From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: do not suspend/resume if power stays
 on
Date: Wed, 1 Mar 2017 16:18:36 -0700
Message-ID: <20170301231836.GE2820@obsidianresearch.com>
References: <20170301115116.19696-1-enric.balletbo@collabora.com>
	<20170301135429.GF28874@leverpostej>
	<20170301184333.GA12197@obsidianresearch.com>
	<CAPz6YkX=X+mZZRaiYrFGE0qyX1QC=wnXaA-PfvSozwfDM37h1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPz6YkX=X+mZZRaiYrFGE0qyX1QC=wnXaA-PfvSozwfDM37h1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 01, 2017 at 02:39:09PM -0800, Sonny Rao wrote:

> > We recently added global suspend/resume callbacks to the TPM
> > core. Those call backs do not power off the TPM, they just prepare its
> > internal state to loose power to the chip. Skipping that process on
> > hardware that does not power-off the TPM makes sense to me.
> >
> > But, Sonny, perhaps this should be a global flag in tpm_chip, not a
> > per-interface-driver override?
> 
> It's a property of the board design not the chip -- maybe I'm
> misunderstanding?

I mean do not add the code to handle this to tpm_i2c_infineon.c but in
the common chip code instead.

tpm_i2c_infineon.c should only parse DT properties that are relavent
to the bus that delivers commands to the TPM, things that apply to how
a TPM chip operates should be handled in the core code because they
apply to any command transport bus.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
