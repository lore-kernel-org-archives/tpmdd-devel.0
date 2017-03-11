From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC,v2] tpm_crb: request and relinquish locality 0
Date: Sat, 11 Mar 2017 12:55:43 +0200
Message-ID: <20170311105543.gkj46ktz6kup3bu5@intel.com>
References: <20170311105339.19486-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170311105339.19486-1-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>, gang.wei@intel.com, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Mar 11, 2017 at 12:53:36PM +0200, Jarkko Sakkinen wrote:
> Added two new callbacks to struct tpm_class_ops:
> 
> - request_locality
> - relinquish_locality
> 
> These are called before sending and receiving data from the TPM.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> This not yet v2 of this patch. I'm checking that this is what needs to be done
> for tpm_tis_core before I go through testing etc. Thank you.

And apparently I did not amend tpm-interface.c change :( Anyway, I'm
merely sanity checking that I'm doing the right thing.

/Jarkko

>  drivers/char/tpm/tpm-interface.c |  9 +++++++++
>  drivers/char/tpm/tpm_crb.c       | 41 +++++++++++++++++++++++++++++++++++++++-
>  drivers/char/tpm/tpm_tis_core.c  | 10 +++-------
>  include/linux/tpm.h              |  3 ++-
>  4 files changed, 54 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index e38c792..036843e 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -407,6 +407,12 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>  	if (chip->dev.parent)
>  		pm_runtime_get_sync(chip->dev.parent);
>  
> +	if (chip->ops->request_locality)  {
> +		rc = chip->ops->request_locality(chip);
> +		if (rc)
> +			goto out;
> +	}
> +
>  	rc = tpm2_prepare_space(chip, space, ordinal, buf);
>  	if (rc)
>  		goto out;
> @@ -466,6 +472,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>  	rc = tpm2_commit_space(chip, space, ordinal, buf, &len);
>  
>  out:
> +	if (chip->ops->relinquish_locality)
> +		chip->ops->relinquish_locality(chip);
> +
>  	if (chip->dev.parent)
>  		pm_runtime_put_sync(chip->dev.parent);
>  
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 3245618..15b22a0 100644
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
> @@ -172,6 +181,35 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
>  	return 0;
>  }
>  
> +static int crb_request_locality(struct tpm_chip *chip, int loc)
> +{
> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> +
> +	if (!priv->regs_h)
> +		return 0;
> +
> +	iowrite32(CRB_LOC_CTRL_REQUEST_ACCESS, &priv->regs_h->loc_ctrl);
> +	if (!crb_wait_for_reg_32(&priv->regs_h->loc_state,
> +				 CRB_LOC_STATE_LOC_ASSIGNED, /* mask */
> +				 CRB_LOC_STATE_LOC_ASSIGNED, /* value */
> +				 TPM2_TIMEOUT_C)) {
> +		dev_warn(&chip->dev, "TPM_LOC_STATE_x.requestAccess timed out\n");
> +		return -ETIME;
> +	}
> +
> +	return 0;
> +}
> +
> +static void crb_relinquish_locality(struct tpm_chip *chip, int loc, bool force)
> +{
> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> +
> +	if (!priv->regs_h)
> +		return;
> +
> +	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs_h->loc_ctrl);
> +}
> +
>  static u8 crb_status(struct tpm_chip *chip)
>  {
>  	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> @@ -198,7 +236,6 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  	memcpy_fromio(buf, priv->rsp, 6);
>  	expected = be32_to_cpup((__be32 *) &buf[2]);
> -
>  	if (expected > count)
>  		return -EIO;
>  
> @@ -279,6 +316,8 @@ static const struct tpm_class_ops tpm_crb = {
>  	.send = crb_send,
>  	.cancel = crb_cancel,
>  	.req_canceled = crb_req_canceled,
> +	.request_locality = crb_request_locality,
> +	.relinquish_locality = crb_relinquish_locality,
>  	.req_complete_mask = CRB_DRV_STS_COMPLETE,
>  	.req_complete_val = CRB_DRV_STS_COMPLETE,
>  };
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index fc0e9a2..505e9c5 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -73,7 +73,7 @@ static int check_locality(struct tpm_chip *chip, int l)
>  	return -1;
>  }
>  
> -static void release_locality(struct tpm_chip *chip, int l, int force)
> +static void release_locality(struct tpm_chip *chip, int l, bool force)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
>  	int rc;
> @@ -252,7 +252,6 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  out:
>  	tpm_tis_ready(chip);
> -	release_locality(chip, priv->locality, 0);
>  	return size;
>  }
>  
> @@ -268,9 +267,6 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  	size_t count = 0;
>  	bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
>  
> -	if (request_locality(chip, 0) < 0)
> -		return -EBUSY;
> -
>  	status = tpm_tis_status(chip);
>  	if ((status & TPM_STS_COMMAND_READY) == 0) {
>  		tpm_tis_ready(chip);
> @@ -329,7 +325,6 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  
>  out_err:
>  	tpm_tis_ready(chip);
> -	release_locality(chip, priv->locality, 0);
>  	return rc;
>  }
>  
> @@ -390,7 +385,6 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
>  	return len;
>  out_err:
>  	tpm_tis_ready(chip);
> -	release_locality(chip, priv->locality, 0);
>  	return rc;
>  }
>  
> @@ -681,6 +675,8 @@ static const struct tpm_class_ops tpm_tis = {
>  	.send = tpm_tis_send,
>  	.cancel = tpm_tis_ready,
>  	.update_timeouts = tpm_tis_update_timeouts,
> +	.request_locality = request_locality,
> +	.relinquish_locality = release_locality,
>  	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
>  	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
>  	.req_canceled = tpm_tis_req_canceled,
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index da158f0..65e05f9 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -48,7 +48,8 @@ struct tpm_class_ops {
>  	u8 (*status) (struct tpm_chip *chip);
>  	bool (*update_timeouts)(struct tpm_chip *chip,
>  				unsigned long *timeout_cap);
> -
> +	int (*request_locality)(struct tpm_chip *chip, int loc);
> +	void (*relinquish_locality)(struct tpm_chip *chip, int loc, bool force);
>  };
>  
>  #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
> -- 
> 2.9.3
> 
