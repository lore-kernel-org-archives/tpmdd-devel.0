From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm/tpm_crb: Access locality for non-ACPI and non-SMC
 start method
Date: Tue, 22 Aug 2017 20:39:56 +0300
Message-ID: <20170822173956.zpqe4scdnv7plrhj@linux.intel.com>
References: <1503029736-591-1-git-send-email-anjiandi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503029736-591-1-git-send-email-anjiandi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiandi An <anjiandi@codeaurora.org>
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 17, 2017 at 11:15:36PM -0500, Jiandi An wrote:
> For ARM64, the locality is handled by Trust Zone in FW.
> The layout does not have crb_regs_head.  It is hitting
> the following line.
> dev_warn(dev, FW_BUG "Bad ACPI memory layout");
> 
> Current code excludes CRB_FL_ACPI_START and when
> CRB_FL_CRB_SMC_START is added around the same time
> locality support is added, it should also be excluded.
> 
> For goIdle and cmdReady where code was excluding
> CRB_FL_ACPI_START only (do nothing for ACPI start method),
> CRB_FL_CRB_SMC_START was also excluded as ARM64 SMC start
> method does not have TPM_CRB_CTRL_REQ.
> Change if confition to white list instead of black list.
> 
> Signed-off-by: Jiandi An <anjiandi@codeaurora.org>
> ---
>  drivers/char/tpm/tpm_crb.c | 35 ++++++++++++++++-------------------
>  1 file changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 8f0a98d..cbfdbdde 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -128,18 +128,16 @@ struct tpm2_crb_smc {
>   * Anyhow, we do not wait here as a consequent CMD_READY request
>   * will be handled correctly even if idle was not completed.
>   *
> - * The function does nothing for devices with ACPI-start method.
> + * The function does nothing for devices with ACPI-start method
> + * or SMC-start method.
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
> +	if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0)
> +		iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
> +		/* we don't really care when this settles */

It's *exactly* the same condition expessed in different form.


>  
>  	return 0;
>  }
> @@ -174,23 +172,22 @@ static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
>   * The device should respond within TIMEOUT_C.
>   *
>   * The function does nothing for devices with ACPI-start method
> + * or SMC-start method.
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
> +	if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0) {
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
> @@ -458,7 +455,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  	 * the control area, as one nice sane region except for some older
>  	 * stuff that puts the control area outside the ACPI IO region.
>  	 */
> -	if (!(priv->flags & CRB_FL_ACPI_START)) {
> +	if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0) {
>  		if (buf->control_address == io_res.start +
>  		    sizeof(*priv->regs_h))
>  			priv->regs_h = priv->iobase;
> -- 
> Jiandi An
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
> 

NAK

/Jarkko
