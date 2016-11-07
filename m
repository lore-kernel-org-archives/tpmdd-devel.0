From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3] tpm_tis: Allow tpm_tis to be bound
	using DT
Date: Mon, 7 Nov 2016 15:43:22 -0800
Message-ID: <20161107234322.7likboml23tbfqvb@intel.com>
References: <1478558671-13256-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1478558671-13256-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 07, 2016 at 03:44:31PM -0700, Jason Gunthorpe wrote:
> This provides an open firwmare driver binding for tpm_tis. OF
> is useful on arches where ACPI/PNP is not used.
> 
> The tcg,tpm-tis-mmio register map interface is specified by the TCG.
> 
> Reviewed-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  .../bindings/security/tpm/tpm_tis_mmio.txt         | 25 ++++++++++++++++++++++
>  drivers/char/tpm/Kconfig                           |  2 +-
>  drivers/char/tpm/tpm_tis.c                         | 11 ++++++++++
>  3 files changed, 37 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
> 
> diff --git a/Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt b/Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
> new file mode 100644
> index 000000000000..41d740545189
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
> @@ -0,0 +1,25 @@
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
> +- interrupt-parent/interrupts: An optional interrupt indicating command completion.
> +
> +Example:
> +
> +	tpm_tis@90000 {
> +				compatible = "atmel,at97sc3204", "tcg,tpm-tis-mmio";
> +				reg = <0x90000 0x5000>;
> +				interrupt-parent = <&EIC0>;
> +				interrupts = <1 2>;
> +	};
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
> index eaf5730d79eb..0127af130cb1 100644
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
> +	{.compatible = "tcg,tpm-tis-mmio"},
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
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
