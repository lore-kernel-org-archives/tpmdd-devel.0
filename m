From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 1/2] tpm: devicetree: document properties for cr50
Date: Tue, 9 Aug 2016 13:08:24 +0300
Message-ID: <20160809100824.GB13566@intel.com>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
 <1469757314-116169-2-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469757314-116169-2-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 28, 2016 at 06:55:13PM -0700, Andrey Pronin wrote:
> Add TPM2.0 PTP FIFO compatible SPI interface for chips with Cr50
> firmware.
> 
> Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  .../devicetree/bindings/security/tpm/cr50_spi.txt   | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> 
> diff --git a/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> new file mode 100644
> index 0000000..2fbebd3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> @@ -0,0 +1,21 @@
> +* H1 Secure Microcontroller with Cr50 Firmware on SPI Bus.
> +
> +H1 Secure Microcontroller running Cr50 firmware provides several
> +functions, including TPM-like functionality. It communicates over
> +SPI using the FIFO protocol described in the PTP Spec, section 6.
> +
> +Required properties:
> +- compatible: Should be "google,cr50".
> +- spi-max-frequency: Maximum SPI frequency.
> +
> +Example:
> +
> +&spi0 {
> +        status = "okay";
> +
> +        cr50@0 {
> +                compatible = "google,cr50";
> +                reg = <0>;
> +                spi-max-frequency = <800000>;
> +        };
> +};
> -- 
> 2.6.6
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
