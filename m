From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] tpm/tpm_crb: Enable TPM CRB
	interface for ARM64
Date: Wed, 22 Mar 2017 08:12:41 +0200
Message-ID: <20170322061241.j7avdfpnehcbjg6j@intel.com>
References: <1489794193-17233-1-git-send-email-anjiandi@codeaurora.org>
	<1489794193-17233-3-git-send-email-anjiandi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489794193-17233-3-git-send-email-anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 17, 2017 at 06:43:13PM -0500, Jiandi An wrote:
> This enables TPM Command Response Buffer interface driver for
> ARM64 and implements an ARM specific TPM CRB start method that
> invokes a Secure Monitor Call (SMC) to request the TrustZone
> Firmware to execute or cancel a TPM 2.0 command.
> 
> In ARM, TrustZone security extensions enable a secure software
> environment with Secure Monitor mode.  A Secure Monitor Call
> (SMC) is used to enter the Secure Monitor mode and perform a
> Secure Monitor service to communicate with TrustZone firmware
> which has control over the TPM hardware.
> 
> Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Does not compile.

/Jarkko

> ---
>  drivers/char/tpm/Kconfig   |  2 +-
>  drivers/char/tpm/tpm_crb.c | 64 ++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 63 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index d520ac5..a3035220 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -136,7 +136,7 @@ config TCG_XEN
>  
>  config TCG_CRB
>  	tristate "TPM 2.0 CRB Interface"
> -	depends on X86 && ACPI
> +	depends on ACPI
>  	---help---
>  	  If you have a TPM security chip that is compliant with the
>  	  TCG CRB 2.0 TPM specification say Yes and it will be accessible
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index cb6fb13..f8a5470 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -20,6 +20,9 @@
>  #include <linux/rculist.h>
>  #include <linux/module.h>
>  #include <linux/pm_runtime.h>
> +#ifdef CONFIG_ARM64
> +#include <linux/arm-smccc.h>
> +#endif
>  #include "tpm.h"
>  
>  #define ACPI_SIG_TPM2 "TPM2"
> @@ -73,6 +76,7 @@ enum crb_status {
>  enum crb_flags {
>  	CRB_FL_ACPI_START	= BIT(0),
>  	CRB_FL_CRB_START	= BIT(1),
> +	CRB_FL_CRB_SMC_START	= BIT(2),
>  };
>  
>  struct crb_priv {
> @@ -82,6 +86,15 @@ struct crb_priv {
>  	u8 __iomem *cmd;
>  	u8 __iomem *rsp;
>  	u32 cmd_size;
> +	u32 smc_func_id;
> +};
> +
> +struct tpm2_crb_smc {
> +	u32 interrupt;
> +	u8 interrupt_flags;
> +	u8 op_flags;
> +	u16 reserved2;
> +	u32 smc_func_id;
>  };
>  
>  /**
> @@ -101,7 +114,8 @@ struct crb_priv {
>   */
>  static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
>  {
> -	if (priv->flags & CRB_FL_ACPI_START)
> +	if ((priv->flags & CRB_FL_ACPI_START) ||
> +	    (priv->flags & CRB_FL_CRB_SMC_START))
>  		return 0;
>  
>  	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->cca->req);
> @@ -129,7 +143,8 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
>  {
>  	ktime_t stop, start;
>  
> -	if (priv->flags & CRB_FL_ACPI_START)
> +	if ((priv->flags & CRB_FL_ACPI_START) ||
> +	    (priv->flags & CRB_FL_CRB_SMC_START))
>  		return 0;
>  
>  	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->cca->req);
> @@ -202,6 +217,33 @@ static int crb_do_acpi_start(struct tpm_chip *chip)
>  	return rc;
>  }
>  
> +#ifdef CONFIG_ARM64
> +/*
> + * This is a TPM Command Response Buffer start method that invokes a
> + * Secure Monitor Call to requrest the firmware to execute or cancel
> + * a TPM 2.0 command.
> + */
> +static inline int tpm_crb_smc_start(struct device *dev, unsigned long func_id)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(func_id, 0, 0, 0, 0, 0, 0, 0, &res);
> +	if (res.a0 != 0) {
> +		dev_err(dev, FW_BUG "tpm_crb_smc_start() returns res.a0 = 0x%lx\n",
> +			res.a0);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static inline int tpm_crb_smc_start(struct device *dev, unsigned long func_id)
> +{
> +	dev_err(dev, FW_BUG "tpm_crb: incorrect start method\n");
> +	return -EINVAL;
> +}
> +#endif
> +
>  static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
>  	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> @@ -229,6 +271,11 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  	if (priv->flags & CRB_FL_ACPI_START)
>  		rc = crb_do_acpi_start(chip);
>  
> +	if (priv->flags & CRB_FL_CRB_SMC_START) {
> +		iowrite32(CRB_START_INVOKE, &priv->cca->start);
> +		rc = tpm_crb_smc_start(&chip->dev, priv->smc_func_id);
> +	}
> +
>  	return rc;
>  }
>  
> @@ -409,6 +456,7 @@ static int crb_acpi_add(struct acpi_device *device)
>  	struct crb_priv *priv;
>  	struct tpm_chip *chip;
>  	struct device *dev = &device->dev;
> +	struct tpm2_crb_smc *crb_smc;
>  	acpi_status status;
>  	u32 sm;
>  	int rc;
> @@ -441,6 +489,18 @@ static int crb_acpi_add(struct acpi_device *device)
>  	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
>  		priv->flags |= CRB_FL_ACPI_START;
>  
> +	if (sm == ACPI_TPM2_COMMAND_BUFFER_WITH_SMC) {
> +		if (buf->header.length < (sizeof(*buf) + sizeof(*crb_smc))) {
> +			dev_err(dev, FW_BUG "TPM2 ACPI table has wrong size %u for start method type %d\n",
> +				buf->header.length, ACPI_TPM2_COMMAND_BUFFER_WITH_SMC);
> +			return -EINVAL;
> +		}
> +		crb_smc = (struct tpm2_crb_smc *) (((u8 *) buf) +
> +			  ACPI_TPM2_START_METHOD_PARAMETER_OFFSET);
> +		priv->smc_func_id = crb_smc->smc_func_id;
> +		priv->flags |= CRB_FL_CRB_SMC_START;
> +	}
> +
>  	rc = crb_map_io(device, priv, buf);
>  	if (rc)
>  		return rc;
> -- 
> Jiandi An
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
