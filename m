From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v4 2/2] tpm/tpm_crb: Enable TPM CRB
	interface for ARM64
Date: Fri, 24 Mar 2017 16:22:59 -0500
Message-ID: <58D58E33.5090305@codeaurora.org>
References: <1490349345-26910-1-git-send-email-anjiandi@codeaurora.org>
	<1490349345-26910-3-git-send-email-anjiandi@codeaurora.org>
	<20170324174559.usyjoxnrkedxtrd3@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170324174559.usyjoxnrkedxtrd3-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 03/24/17 12:45, Jarkko Sakkinen wrote:
> On Fri, Mar 24, 2017 at 04:55:45AM -0500, Jiandi An wrote:
>> This enables TPM Command Response Buffer interface driver for
>> ARM64 and implements an ARM specific TPM CRB start method that
>> invokes a Secure Monitor Call (SMC) to request the TrustZone
>> Firmware to execute or cancel a TPM 2.0 command.
>>
>> In ARM, TrustZone security extensions enable a secure software
>> environment with Secure Monitor mode.  A Secure Monitor Call
>> (SMC) is used to enter the Secure Monitor mode and perform a
>> Secure Monitor service to communicate with TrustZone firmware
>> which has control over the TPM hardware.
>>
>> Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>
> LGTM
>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> How this can be tested / do you know anyone who could test your
> change? I can test that it doesn't break x86.
>
> /Jarkko

Thanks for the review Jarkko.  I'm including Shanker Donthineni
(shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org) that has ARM64 platform that could test
on the ARM64 side.

- Jiandi

>
>> ---
>>   drivers/char/tpm/Kconfig   |  2 +-
>>   drivers/char/tpm/tpm_crb.c | 67 ++++++++++++++++++++++++++++++++++++++++++++--
>>   2 files changed, 66 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
>> index d520ac5..a3035220 100644
>> --- a/drivers/char/tpm/Kconfig
>> +++ b/drivers/char/tpm/Kconfig
>> @@ -136,7 +136,7 @@ config TCG_XEN
>>
>>   config TCG_CRB
>>   	tristate "TPM 2.0 CRB Interface"
>> -	depends on X86 && ACPI
>> +	depends on ACPI
>>   	---help---
>>   	  If you have a TPM security chip that is compliant with the
>>   	  TCG CRB 2.0 TPM specification say Yes and it will be accessible
>> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
>> index 9f31609..a9773fa 100644
>> --- a/drivers/char/tpm/tpm_crb.c
>> +++ b/drivers/char/tpm/tpm_crb.c
>> @@ -20,6 +20,9 @@
>>   #include <linux/rculist.h>
>>   #include <linux/module.h>
>>   #include <linux/pm_runtime.h>
>> +#ifdef CONFIG_ARM64
>> +#include <linux/arm-smccc.h>
>> +#endif
>>   #include "tpm.h"
>>
>>   #define ACPI_SIG_TPM2 "TPM2"
>> @@ -83,6 +86,7 @@ enum crb_status {
>>   enum crb_flags {
>>   	CRB_FL_ACPI_START	= BIT(0),
>>   	CRB_FL_CRB_START	= BIT(1),
>> +	CRB_FL_CRB_SMC_START	= BIT(2),
>>   };
>>
>>   struct crb_priv {
>> @@ -93,6 +97,15 @@ struct crb_priv {
>>   	u8 __iomem *cmd;
>>   	u8 __iomem *rsp;
>>   	u32 cmd_size;
>> +	u32 smc_func_id;
>> +};
>> +
>> +struct tpm2_crb_smc {
>> +	u32 interrupt;
>> +	u8 interrupt_flags;
>> +	u8 op_flags;
>> +	u16 reserved2;
>> +	u32 smc_func_id;
>>   };
>>
>>   /**
>> @@ -112,7 +125,8 @@ struct crb_priv {
>>    */
>>   static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
>>   {
>> -	if (priv->flags & CRB_FL_ACPI_START)
>> +	if ((priv->flags & CRB_FL_ACPI_START) ||
>> +	    (priv->flags & CRB_FL_CRB_SMC_START))
>>   		return 0;
>>
>>   	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
>> @@ -157,7 +171,8 @@ static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
>>   static int __maybe_unused crb_cmd_ready(struct device *dev,
>>   					struct crb_priv *priv)
>>   {
>> -	if (priv->flags & CRB_FL_ACPI_START)
>> +	if ((priv->flags & CRB_FL_ACPI_START) ||
>> +	    (priv->flags & CRB_FL_CRB_SMC_START))
>>   		return 0;
>>
>>   	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
>> @@ -223,6 +238,34 @@ static int crb_do_acpi_start(struct tpm_chip *chip)
>>   	return rc;
>>   }
>>
>> +#ifdef CONFIG_ARM64
>> +/*
>> + * This is a TPM Command Response Buffer start method that invokes a
>> + * Secure Monitor Call to requrest the firmware to execute or cancel
>> + * a TPM 2.0 command.
>> + */
>> +static int tpm_crb_smc_start(struct device *dev, unsigned long func_id)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	arm_smccc_smc(func_id, 0, 0, 0, 0, 0, 0, 0, &res);
>> +	if (res.a0 != 0) {
>> +		dev_err(dev,
>> +			FW_BUG "tpm_crb_smc_start() returns res.a0 = 0x%lx\n",
>> +			res.a0);
>> +		return -EIO;
>> +	}
>> +
>> +	return 0;
>> +}
>> +#else
>> +static int tpm_crb_smc_start(struct device *dev, unsigned long func_id)
>> +{
>> +	dev_err(dev, FW_BUG "tpm_crb: incorrect start method\n");
>> +	return -EINVAL;
>> +}
>> +#endif
>> +
>>   static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>>   {
>>   	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>> @@ -250,6 +293,11 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>>   	if (priv->flags & CRB_FL_ACPI_START)
>>   		rc = crb_do_acpi_start(chip);
>>
>> +	if (priv->flags & CRB_FL_CRB_SMC_START) {
>> +		iowrite32(CRB_START_INVOKE, &priv->regs_t->ctrl_start);
>> +		rc = tpm_crb_smc_start(&chip->dev, priv->smc_func_id);
>> +	}
>> +
>>   	return rc;
>>   }
>>
>> @@ -442,6 +490,7 @@ static int crb_acpi_add(struct acpi_device *device)
>>   	struct crb_priv *priv;
>>   	struct tpm_chip *chip;
>>   	struct device *dev = &device->dev;
>> +	struct tpm2_crb_smc *crb_smc;
>>   	acpi_status status;
>>   	u32 sm;
>>   	int rc;
>> @@ -474,6 +523,20 @@ static int crb_acpi_add(struct acpi_device *device)
>>   	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
>>   		priv->flags |= CRB_FL_ACPI_START;
>>
>> +	if (sm == ACPI_TPM2_COMMAND_BUFFER_WITH_SMC) {
>> +		if (buf->header.length < (sizeof(*buf) + sizeof(*crb_smc))) {
>> +			dev_err(dev,
>> +				FW_BUG "TPM2 ACPI table has wrong size %u for start method type %d\n",
>> +				buf->header.length,
>> +				ACPI_TPM2_COMMAND_BUFFER_WITH_SMC);
>> +			return -EINVAL;
>> +		}
>> +		crb_smc = ACPI_ADD_PTR(struct tpm2_crb_smc, buf,
>> +				       ACPI_TPM2_START_METHOD_PARAMETER_OFFSET);
>> +		priv->smc_func_id = crb_smc->smc_func_id;
>> +		priv->flags |= CRB_FL_CRB_SMC_START;
>> +	}
>> +
>>   	rc = crb_map_io(device, priv, buf);
>>   	if (rc)
>>   		return rc;
>> --
>> Jiandi An
>> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
>> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
>>


-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a
Linux Foundation Collaborative Project.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
