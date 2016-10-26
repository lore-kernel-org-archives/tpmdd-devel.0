From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Allow tpm_tis to be bound using
	DT
Date: Wed, 26 Oct 2016 13:55:27 +0300
Message-ID: <20161026105527.cd6hcn37vmboshue@intel.com>
References: <20161025232331.GA20339@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161025232331.GA20339-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Oct 25, 2016 at 05:23:31PM -0600, Jason Gunthorpe wrote:
> This provides an open firwmare driver binding for tpm_tis. OF
> is useful on arches where ACPI/PNP is not used.
> 
> The tcg,tpm_tis-mmio register map interface is specified by the TCG.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  .../bindings/security/tpm/tpm_tis_mmio.txt         | 22 ++++++++++++++++++++++

I'll do a proper review later on but should this change be a separate
commit or not?

/Jarkko

>  drivers/char/tpm/Kconfig                           |  2 +-
>  drivers/char/tpm/tpm_tis.c                         | 11 +++++++++++
>  3 files changed, 34 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
> 
> A bunch of work was done previously on how the tis driver probes and
> binds, so DT enablement is now trivial.
> 
> diff --git a/Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt b/Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
> new file mode 100644
> index 000000000000..67661f6a27cd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
> @@ -0,0 +1,22 @@
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
> +- compatible: should specify the actual hardware chip followed by the
> +  generic interface name "tcg,tpm_tis-spi";
> +- reg: The location of the MMIO registers, should be at least 0x5000 bytes
> +- interrupt: An optional interrupt indicating command completion.
> +
> +Example:
> +
> +	tpm_tis@90000 {
> +				compatible = "atmel,at97sc3204", "tcg,tpm_tis-mmio";
> +				reg = <0x90000 0x5000>;
> +			};
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index 9faa0b1e7766..277186d3b668 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -32,7 +32,7 @@ config TCG_TIS_CORE
>  
>  config TCG_TIS
>  	tristate "TPM Interface Specification 1.2 Interface / TPM 2.0 FIFO Interface"
> -	depends on X86
> +	depends on X86 || OF
>  	select TCG_TIS_CORE
>  	---help---
>  	  If you have a TPM security chip that is compliant with the
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index eaf5730d79eb..5a63fafaca69 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -28,6 +28,8 @@
>  #include <linux/wait.h>
>  #include <linux/acpi.h>
>  #include <linux/freezer.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  #include "tpm.h"
>  #include "tpm_tis_core.h"
>  
> @@ -354,12 +356,21 @@ static int tpm_tis_plat_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id tis_of_platform_match[] = {
> +	{.compatible = "tcg,tpm_tis-mmio"},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, tis_of_platform_match);
> +#endif
> +
>  static struct platform_driver tis_drv = {
>  	.probe = tpm_tis_plat_probe,
>  	.remove = tpm_tis_plat_remove,
>  	.driver = {
>  		.name		= "tpm_tis",
>  		.pm		= &tpm_tis_pm,
> +		.of_match_table = of_match_ptr(tis_of_platform_match),
>  	},
>  };
>  
> -- 
> 2.1.4
> 

------------------------------------------------------------------------------
The Command Line: Reinvented for Modern Developers
Did the resurgence of CLI tooling catch you by surprise?
Reconnect with the command line and become more productive. 
Learn the new .NET and ASP.NET CLI. Get your free copy!
http://sdm.link/telerik
