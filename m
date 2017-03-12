From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] tpm: do not suspend/resume if power stays on
Date: Sun, 12 Mar 2017 09:33:12 -0500
Message-ID: <20170312143312.hrkzl76ztwsay2lw@rob-hp-laptop>
References: <20170303160959.27422-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170303160959.27422-1-enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 03, 2017 at 05:09:59PM +0100, Enric Balletbo i Serra wrote:
> From: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 
> The suspend/resume behavior of the TPM can be controlled by setting
> "powered-while-suspended" in the DTS. This is useful for the cases
> when hardware does not power-off the TPM.
> 
> Signed-off-by: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> ---
> Changes since v2:
>  Jarkko Sakkinen
>   - Add a new TPM_CHIP_FLAG_ALWAYS_POWERED flag instead of using a boolean variable.
>   - Remove a trailing newline.
> Changes since v1:
>  Jason Gunthorpe :
>   - Move the code to handle suspend/resume in the common chip code.
> 
>  Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt | 6 ++++++

I would say this shouldn't be TPM specific, but looks like we already 
have a dts with this, so:

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

>  drivers/char/tpm/tpm-interface.c                           | 3 +++
>  drivers/char/tpm/tpm.h                                     | 1 +
>  drivers/char/tpm/tpm_of.c                                  | 3 +++
>  4 files changed, 13 insertions(+)
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
