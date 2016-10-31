From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] tpm_tis: Allow tpm_tis to be bound
	using DT
Date: Sun, 30 Oct 2016 23:26:18 -0500
Message-ID: <20161031042618.natoswnyn7z4ixxb@rob-hp-laptop>
References: <20161026170437.GB13461@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161026170437.GB13461-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 26, 2016 at 11:04:37AM -0600, Jason Gunthorpe wrote:
> This provides an open firwmare driver binding for tpm_tis. OF
> is useful on arches where ACPI/PNP is not used.
> 
> The tcg,tpm-tis-mmio register map interface is specified by the TCG.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  .../bindings/security/tpm/tpm_tis_mmio.txt         | 23 ++++++++++++++++++++++
>  drivers/char/tpm/Kconfig                           |  2 +-
>  drivers/char/tpm/tpm_tis.c                         | 11 +++++++++++
>  3 files changed, 35 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
> 
> v2 (from Mark)
>  - Change name to tpm-tis-mmio (and fix c&p spi)
>  - Include some valid chip names
> 
> diff --git a/Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt b/Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
> new file mode 100644
> index 000000000000..f9a853165cd0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
> @@ -0,0 +1,23 @@
> +Trusted Computing Group MMIO Trusted Platform Module
> +
> +The TCG defines multi vendor standard for accessing a TPM chip, this
> +is the standard protocol defined to access the TPM via MMIO. Typically
> +this interface will be implemented over Intel's LPC bus.
> +
> +Refer to the 'TCG PC Client Specific TPM Interface Specification (TIS)' TCG
> +publication for the specification.
> +
> +Required properties:
> +
> +- compatible: should contain a string below for the chip, followed by
> +              "tcg,tpm-tis-mmio". Valid chip strings are:
> +	          * "atmel,at97sc3204"
> +- reg: The location of the MMIO registers, should be at least 0x5000 bytes
> +- interrupt: An optional intzerrupt indicating command completion.

s/interrupt/interrupts/

> +
> +Example:
> +
> +	tpm_tis@90000 {
> +				compatible = "atmel,at97sc3204", "tcg,tpm-tis-mmio";
> +				reg = <0x90000 0x5000>;

Missing the required interrupts property.

> +			};

The indentation here is off, otherwise:

Rob

------------------------------------------------------------------------------
The Command Line: Reinvented for Modern Developers
Did the resurgence of CLI tooling catch you by surprise?
Reconnect with the command line and become more productive. 
Learn the new .NET and ASP.NET CLI. Get your free copy!
http://sdm.link/telerik
