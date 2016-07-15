From: Guenter Roeck <groeck@google.com>
Subject: Re: [PATCH 1/2] tpm: devicetree: document properties for cr50
Date: Thu, 14 Jul 2016 21:05:53 -0700
Message-ID: <CABXOdTcVcZ10c6uShN2AXUZfOuK=FESeo73Assi0sziMZJ_+Fw@mail.gmail.com>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org> <1468549218-19215-2-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468549218-19215-2-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>, Guenter Roeck <groeck@chromium.org>, smbarber@chromium.org, Douglas Anderson <dianders@chromium.org>, devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 7:20 PM, Andrey Pronin <apronin@chromium.org> wrote:
> Add TPM2.0-compatible interface to Cr50. Document its properties
> in devicetree.
>
> Signed-off-by: Andrey Pronin <apronin@chromium.org>
> ---
>  .../devicetree/bindings/security/tpm/cr50_spi.txt  | 30 ++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
>
> diff --git a/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> new file mode 100644
> index 0000000..1b05e51
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> @@ -0,0 +1,30 @@
> +* Cr50 Chip on SPI.
> +
> +TCG PTP FIFO Compliant Interface to Cr50 on SPI bus.
> +
> +Required properties:
> +- compatible: Should be "google,cr50_spi".

google,cr50, maybe ? The "_spi" seems redundant.

Also, I agree with comments from others - the term cr50 really needs
an explanation (Google thinks that it is a motor bike, a scanner, or a
coffee roaster).

Thanks,
Guenter

> +- spi-max-frequency: Maximum SPI frequency.
> +
> +Optional properties:
> +- access-delay-msec: Required delay between subsequent transactions on SPI.
> +- sleep-delay-msec: Time after the last SPI activity, after which the chip
> +  may go to sleep.
> +- wake-start-delay-msec: Time after initiating wake up before the chip is
> +  ready to accept commands over SPI.
> +
> +Example:
> +
> +&spi0 {
> +        status = "okay";
> +
> +        cr50@0 {
> +                compatible = "google,cr50_spi";
> +                reg = <0>;
> +                spi-max-frequency = <800000>;
> +
> +                access-delay-msec = <2>;
> +                sleep-delay-msec = <1000>;
> +                wake-start-delay-msec = <60>;
> +        };
> +};
> --
> 2.6.6
>
