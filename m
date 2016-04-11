From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/10] devicetree: Add Trusted Computing Group to
 vendor-prefix.txt
Date: Mon, 11 Apr 2016 15:06:00 -0500
Message-ID: <20160411200600.GA23902@rob-hp-laptop>
References: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
 <1460323386-16892-9-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460323386-16892-9-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, jean-luc.blanc-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Apr 10, 2016 at 11:23:04PM +0200, Christophe Ricard wrote:
> Add missing vendor to vendor-prefix.txt.
> 
> Trusted Computing Group design common specifications for
> TPM (Trusted Platform Module) vendors.
> TCG designates a TPM answering to a public specification.

Not sure this should be a vendor prefix. Does TCG actually make h/w?

> 
> Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 6c3d970..717bae9 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -230,6 +230,7 @@ stericsson	ST-Ericsson
>  synology	Synology, Inc.
>  tbs	TBS Technologies
>  tcl	Toby Churchill Ltd.
> +tcg	Trusted Computing Group
>  technologic	Technologic Systems
>  thine	THine Electronics, Inc.
>  ti	Texas Instruments
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
