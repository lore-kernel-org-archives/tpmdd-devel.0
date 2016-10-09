From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 3/3] tpm_crb: request and
	relinquish	locality 0
Date: Sun, 9 Oct 2016 06:35:28 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F6C98@hasmsx108.ger.corp.intel.com>
References: <1475972112-2819-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1475972112-2819-4-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1475972112-2819-4-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



> 
> Request and relinquish locality for the driver use in order to be a better citizen
> in a multi locality environment like with TXT as it uses locality 2.	

> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_crb.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c index
> ffd3a6c..9e07cf3 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -34,6 +34,15 @@ enum crb_defaults {
>  	CRB_ACPI_START_INDEX = 1,
>  };
> 
> +enum crb_loc_ctrl {
> +	CRB_LOC_CTRL_REQUEST_ACCESS	= BIT(0),
> +	CRB_LOC_CTRL_RELINQUISH		= BIT(1),
> +};
> +
> +enum crb_loc_state {
> +	CRB_LOC_STATE_LOC_ASSIGNED	= BIT(1),
> +};
> +
>  enum crb_ctrl_req {
>  	CRB_CTRL_REQ_CMD_READY	= BIT(0),
>  	CRB_CTRL_REQ_GO_IDLE	= BIT(1),
> @@ -98,12 +107,8 @@ struct crb_priv {
>   * @dev:  crb device
>   * @priv: crb private data
>   *
> - * Write CRB_CTRL_REQ_GO_IDLE to TPM_CRB_CTRL_REQ
> - * The device should respond within TIMEOUT_C by clearing the bit.
> - * Anyhow, we do not wait here as a consequent CMD_READY request
> - * will be handled correctly even if idle was not completed.
> - *
> - * The function does nothing for devices with ACPI-start method.
> + * Put device to the idle state and relinquish locality. The function
> + does
> + * nothing for devices with the ACPI-start method.
>   *
>   * Return: 0 always
>   */
> @@ -112,6 +117,7 @@ static int __maybe_unused crb_go_idle(struct device
> *dev, struct crb_priv *priv)
>  	if (priv->flags & CRB_FL_ACPI_START)
>  		return 0;
> 
> +	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs->loc_ctrl);


Please don't mix different functionalities in one function 
Also those functions are called from runtime pm, this has nothing to do with the power management 

>  	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs->ctrl_req);
>  	/* we don't really care when this settles */
> 
> @@ -143,11 +149,8 @@ static bool crb_wait_for_reg_32(u32 __iomem *reg,
> u32 mask, u32 value,
>   * @dev:  crb device
>   * @priv: crb private data
>   *
> - * Write CRB_CTRL_REQ_CMD_READY to TPM_CRB_CTRL_REQ
> - * and poll till the device acknowledge it by clearing the bit.
> - * The device should respond within TIMEOUT_C.
> - *
> - * The function does nothing for devices with ACPI-start method
> + * Try to wake up the device and request locality. The function does
> + nothing
> + * for devices with the ACPI-start method.
>   *
>   * Return: 0 on success -ETIME on timeout;
>   */
> @@ -162,7 +165,16 @@ static int __maybe_unused crb_cmd_ready(struct
> device *dev,
>  				 CRB_CTRL_REQ_CMD_READY /* mask */,
>  				 0, /* value */
>  				 TPM2_TIMEOUT_C)) {
> -		dev_warn(dev, "cmdReady timed out\n");
> +		dev_warn(dev, "TPM_CRB_CTRL_REQ_x.cmdReady timed
> out\n");
> +		return -ETIME;
> +	}
> +
> +	iowrite32(CRB_LOC_CTRL_REQUEST_ACCESS, &priv->regs->loc_ctrl);
> +	if (!crb_wait_for_reg_32(&priv->regs->loc_state,
> +				 CRB_LOC_STATE_LOC_ASSIGNED, /* mask */
> +				 CRB_LOC_STATE_LOC_ASSIGNED, /* value */
> +				 TPM2_TIMEOUT_C)) {
> +		dev_warn(dev, "TPM_LOC_STATE_x.requestAccess timed
> out\n");
Same here

>  		return -ETIME;
>  	}
> 
> --


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
