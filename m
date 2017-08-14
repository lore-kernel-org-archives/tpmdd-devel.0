From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm/tpm_crb: Access locality for only CRB_START method
Date: Mon, 14 Aug 2017 13:09:28 +0300
Message-ID: <20170814100928.7vv3mhd5xpknamnw@linux.intel.com>
References: <1502587369-24436-1-git-send-email-anjiandi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502587369-24436-1-git-send-email-anjiandi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiandi An <anjiandi@codeaurora.org>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Aug 12, 2017 at 08:22:49PM -0500, Jiandi An wrote:
> For ARM64, the locality is handled by Trust Zone in FW.
> The layout does not have crb_regs_head.  It is hitting
> the following line.
> dev_warn(dev, FW_BUG "Bad ACPI memory layout");
> 
> Current code excludes CRB_FL_ACPI_START and when
> CRB_FL_CRB_SMC_START is added around the same time
> locality support is added, it should also be excluded.
> Change the if condition to be only for CRB_FL_CRB_START.
> 
> For goIdle and cmdReady where code was excluding
> CRB_FL_ACPI_START only (do nothing for ACPI start method),
> CRB_FL_CRB_SMC_START was also excluded as ARM64 SMC start
> method does not have TPM_CRB_CTRL_REQ.
> Change the if condition to be only for CRB_FL_CRB_START
> in crb_go_idle() and crb_cmd_ready().
> 
> Signed-off-by: Jiandi An <anjiandi@codeaurora.org>
> ---
> v2
> Changed if condition to CRB_FL_CRB_START for go idle
> and crb_cmd_ready per maintainer's comment.

What about platforms with firmware bug that they report only requiring
ACPI start but actually also require CRB start.

if (sm == ACPI_TPM2_START_METHOD ||
    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
	priv->flags |= CRB_FL_ACPI_START;

I've encountered a platform that reports to require start method 2 (ACPI
start) while it actually requires start method 8.

That's why we have this nasty workaround:

/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
 * report only ACPI start but in practice seems to require both
 * ACPI start and CRB start.
 */
if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
    !strcmp(acpi_device_hid(device), "MSFT0101"))
	priv->flags |= CRB_FL_CRB_START;

Also, since start method 8 exist in the spec, it is a legit config.

> 
>  drivers/char/tpm/tpm_crb.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 8f0a98d..7a6735d 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -128,18 +128,16 @@ struct tpm2_crb_smc {
>   * Anyhow, we do not wait here as a consequent CMD_READY request
>   * will be handled correctly even if idle was not completed.
>   *
> - * The function does nothing for devices with ACPI-start method.
> + * The function does nothing for devices with ACPI-start method
> + * and SMC-start method.
>   *
>   * Return: 0 always
>   */
>  static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
>  {
> -	if ((priv->flags & CRB_FL_ACPI_START) ||
> -	    (priv->flags & CRB_FL_CRB_SMC_START))
> -		return 0;
> -
> -	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
> -	/* we don't really care when this settles */
> +	if (priv->flags & CRB_FL_CRB_START)
> +		iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
> +		/* we don't really care when this settles */
>  
>  	return 0;
>  }
> @@ -174,23 +172,23 @@ static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
>   * The device should respond within TIMEOUT_C.
>   *
>   * The function does nothing for devices with ACPI-start method
> + * and SMC-start method.
>   *
>   * Return: 0 on success -ETIME on timeout;
>   */
>  static int __maybe_unused crb_cmd_ready(struct device *dev,
>  					struct crb_priv *priv)
>  {
> -	if ((priv->flags & CRB_FL_ACPI_START) ||
> -	    (priv->flags & CRB_FL_CRB_SMC_START))
> -		return 0;
> -
> -	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
> -	if (!crb_wait_for_reg_32(&priv->regs_t->ctrl_req,
> -				 CRB_CTRL_REQ_CMD_READY /* mask */,
> -				 0, /* value */
> -				 TPM2_TIMEOUT_C)) {
> -		dev_warn(dev, "cmdReady timed out\n");
> -		return -ETIME;
> +	if (priv->flags & CRB_FL_CRB_START)
> +	{

The opening curly brace should be in the same line as the condition
statement.

> +		iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
> +		if (!crb_wait_for_reg_32(&priv->regs_t->ctrl_req,
> +					 CRB_CTRL_REQ_CMD_READY /* mask */,
> +					 0, /* value */
> +					 TPM2_TIMEOUT_C)) {
> +			dev_warn(dev, "cmdReady timed out\n");
> +			return -ETIME;
> +		}
>  	}
>  
>  	return 0;
> @@ -458,7 +456,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  	 * the control area, as one nice sane region except for some older
>  	 * stuff that puts the control area outside the ACPI IO region.
>  	 */
> -	if (!(priv->flags & CRB_FL_ACPI_START)) {
> +	if (priv->flags & CRB_FL_CRB_START) {
>  		if (buf->control_address == io_res.start +
>  		    sizeof(*priv->regs_h))
>  			priv->regs_h = priv->iobase;
> -- 
> Jiandi An
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
> 

/Jarkko
