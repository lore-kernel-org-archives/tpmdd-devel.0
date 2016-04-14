From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 12/12] tpm/tpm_tis_spi: Add support for spi phy
Date: Thu, 14 Apr 2016 11:39:11 -0500
Message-ID: <20160414163911.GA23351@rob-hp-laptop>
References: <1460577351-24632-1-git-send-email-christophe-h.ricard@st.com>
 <1460577351-24632-13-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460577351-24632-13-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, jean-luc.blanc-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Apr 13, 2016 at 09:55:51PM +0200, Christophe Ricard wrote:
> Spi protocol standardized by the TCG is now supported by most of TPM
> vendors.
> 
> It supports SPI Bit Protocol as describe in the TCG PTP
> specification (chapter 6.4.6 SPI Bit Protocol).
> 
> Irq mode is not supported.
> 
> Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> ---
>  .../bindings/security/tpm/tpm_tis_spi.txt          |  21 ++
>  drivers/char/tpm/Kconfig                           |  12 +
>  drivers/char/tpm/Makefile                          |   1 +
>  drivers/char/tpm/tpm_tis_spi.c                     | 242 +++++++++++++++++++++
>  4 files changed, 276 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm_tis_spi.txt
>  create mode 100644 drivers/char/tpm/tpm_tis_spi.c
> 
> diff --git a/Documentation/devicetree/bindings/security/tpm/tpm_tis_spi.txt b/Documentation/devicetree/bindings/security/tpm/tpm_tis_spi.txt
> new file mode 100644
> index 0000000..31f4dcd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/tpm_tis_spi.txt
> @@ -0,0 +1,21 @@
> +Required properties:
> +- compatible: Should be "st,st33htpm-spi" or "infineon,slb9670" or "tcg,tpm_tis-spi"

No underscores.

The tcg one is fine, but should not be without a specific device. So 
this should be something like this:

Should be one of:
		"st,st33htpm-spi"
		"infineon,slb9670"
	 Followed by "tcg,tpm_tis-spi"

> +- spi-max-frequency: Maximum SPI frequency (depends on TPMs).
> +
> +Optional SoC Specific Properties:
> +- pinctrl-names: Contains only one value - "default".
> +- pintctrl-0: Specifies the pin control groups used for this controller.
> +
> +Example (for ARM-based BeagleBoard xM with TPM_TIS on SPI4):
> +
> +&mcspi4 {
> +
> +        status = "okay";
> +
> +        tpm_tis@0 {
> +
> +                compatible = "tcg,tpm_tis-spi";
> +
> +                spi-max-frequency = <10000000>;
> +        };
> +};
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
