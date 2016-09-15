From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v4 1/4] tpm/tpm_crb: implement tpm crb idle state
Date: Thu, 15 Sep 2016 13:52:35 +0300
Message-ID: <20160915105235.GA22431@intel.com>
References: <1473924458-29062-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473924458-29062-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 15, 2016 at 10:27:38AM +0300, Tomas Winkler wrote:
> The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady for
> SW to indicate that the device can enter or should exit the idle state.
> 
> The legacy ACPI-start (SMI + DMA) based devices do not support these
> bits and the idle state management is not exposed to the host SW.
> Thus, this functionality only is enabled only for a CRB start (MMIO)
> based devices.
> 
> Based on Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> original patch:
> 'tpm_crb: implement power tpm crb power management'
> 
> To keep the implementation local to the hw we don't use wait_for_tpm_stat
> for polling the TPM_CRB_CTRL_REQ.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

What about callback names? I've been thinking to name them simply as
'runtime_suspend' and 'runtime_resume'. I can do renaming.

/Jarkko

> ---
> V2: do not export the functions via tpm ops
> V3: fix lower case corruption; adjust function documentation
> V4: comment on wait_for_tpm_stat.
> 
>  drivers/char/tpm/tpm_crb.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 6e9d1bca712f..b6923a8b3ff7 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -83,6 +83,75 @@ struct crb_priv {
>  	u32 cmd_size;
>  };
>  
> +/**
> + * crb_go_idle - request tpm crb device to go the idle state
> + *
> + * @dev:  crb device
> + * @priv: crb private data
> + *
> + * Write CRB_CTRL_REQ_GO_IDLE to TPM_CRB_CTRL_REQ
> + * The device should respond within TIMEOUT_C by clearing the bit.
> + * Anyhow, we do not wait here as a consequent CMD_READY request
> + * will be handled correctly even if idle was not completed.
> + *
> + * The function does nothing for devices with ACPI-start method.
> + *
> + * Return: 0 always
> + */
> +static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
> +{
> +	if (priv->flags & CRB_FL_ACPI_START)
> +		return 0;
> +
> +	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->cca->req);
> +	/* we don't really care when this settles */
> +
> +	return 0;
> +}
> +
> +/**
> + * crb_cmd_ready - request tpm crb device to enter ready state
> + *
> + * @dev:  crb device
> + * @priv: crb private data
> + *
> + * Write CRB_CTRL_REQ_CMD_READY to TPM_CRB_CTRL_REQ
> + * and poll till the device acknowledge it by clearing the bit.
> + * The device should respond within TIMEOUT_C.
> + *
> + * The function does nothing for devices with ACPI-start method
> + *
> + * Return: 0 on success -ETIME on timeout;
> + */
> +static int __maybe_unused crb_cmd_ready(struct device *dev,
> +					struct crb_priv *priv)
> +{
> +	ktime_t stop, start;
> +
> +	if (priv->flags & CRB_FL_ACPI_START)
> +		return 0;
> +
> +	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->cca->req);
> +
> +	start = ktime_get();
> +	stop = ktime_add(start, ms_to_ktime(TPM2_TIMEOUT_C));
> +	do {
> +		if (!(ioread32(&priv->cca->req) & CRB_CTRL_REQ_CMD_READY)) {
> +			dev_dbg(dev, "cmdReady in %lld usecs\n",
> +				ktime_to_us(ktime_sub(ktime_get(), start)));
> +			return 0;
> +		}
> +		usleep_range(50, 100);
> +	} while (ktime_before(ktime_get(), stop));
> +
> +	if (ioread32(&priv->cca->req) & CRB_CTRL_REQ_CMD_READY) {
> +		dev_warn(dev, "cmdReady timed out\n");
> +		return -ETIME;
> +	}
> +
> +	return 0;
> +}
> +
>  static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
>  
>  static u8 crb_status(struct tpm_chip *chip)
> -- 
> 2.7.4
> 
