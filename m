From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] tpm: do not suspend/resume if power stays on
Date: Wed, 1 Mar 2017 13:54:29 +0000
Message-ID: <20170301135429.GF28874@leverpostej>
References: <20170301115116.19696-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170301115116.19696-1-enric.balletbo@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Rob Herring <robh+dt@kernel.org>, Peter Huewe <peterhuewe@gmx.de>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Sonny Rao <sonnyrao@chromium.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 01, 2017 at 12:51:16PM +0100, Enric Balletbo i Serra wrote:
> From: Sonny Rao <sonnyrao@chromium.org>
> 
> The suspend/resume behavior of the TPM can be controlled
> by setting "powered-while-suspended" in the DTS.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> ---
>  Documentation/devicetree/bindings/tpm/tpm.txt | 25 +++++++++++++++++++++++++
>  drivers/char/tpm/tpm_i2c_infineon.c           | 25 ++++++++++++++++++++++++-
>  2 files changed, 49 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/tpm/tpm.txt
> 
> diff --git a/Documentation/devicetree/bindings/tpm/tpm.txt b/Documentation/devicetree/bindings/tpm/tpm.txt
> new file mode 100644
> index 0000000..af4de0d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/tpm/tpm.txt
> @@ -0,0 +1,25 @@
> +TPM (Trusted Platform Module)
> +
> +A TPM on the I2C bus is a child of the node for the bus.
> +
> +Required properties:
> +- compatible: should be "infineon,<chip>"
> +- reg: the I2C address
> +
> +Optional properties:
> +- powered-while-suspended: present when the TPM is left powered on between
> +  suspend and resume (makes the suspend/resume callbacks do nothing).

This reads like configuration rather than a HW property.

Why do you want this property?

Thanks,
Mark.
