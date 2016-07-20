From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/2] tpm: devicetree: document properties for cr50
Date: Wed, 20 Jul 2016 14:03:03 -0500
Message-ID: <20160720190303.GA5620@rob-hp-laptop>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
 <cover.1468985673.git.apronin@chromium.org>
 <5274cc806888a709c639e701dad894543885b2c9.1468985673.git.apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5274cc806888a709c639e701dad894543885b2c9.1468985673.git.apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Christophe Ricard <christophe.ricard@gmail.com>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 19, 2016 at 08:41:24PM -0700, Andrey Pronin wrote:
> Add TPM2.0 PTP FIFO compatible SPI interface for chips with Cr50
> firmware. Several timing-related properties that may differ from
> one firmware version to another are added to devicetree.
> Document these properties.
> 
> Signed-off-by: Andrey Pronin <apronin@chromium.org>
> ---
>  .../devicetree/bindings/security/tpm/cr50_spi.txt  | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> 
> diff --git a/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> new file mode 100644
> index 0000000..f212b6b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> @@ -0,0 +1,32 @@
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
> +Optional properties:
> +- access-delay-ms: Required delay between subsequent transactions on SPI.

As I mentioned, there may be common properties. It doesn't seem you 
looked, so I did:

- spi-rx-delay-us  - (optional) Microsecond delay after a read transfer.
- spi-tx-delay-us  - (optional) Microsecond delay after a write transfer.

Seems to me setting one or both of these should work for you.

> +- sleep-delay-ms: Time after the last SPI activity, after which the chip
> +  may go to sleep.
> +- wake-start-delay-ms: Time after initiating wake up before the chip is
> +  ready to accept commands over SPI.

I also asked why these 2 can't be hard-coded in the driver?

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
> +
> +                access-delay-ms = <2>;
> +                sleep-delay-ms = <1000>;
> +                wake-start-delay-ms = <60>;
> +        };
> +};
> -- 
> 2.6.6
> 
