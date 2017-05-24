From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 3/3] tpm: vtpm_proxy: Prevent userspace from sending
 driver command
Date: Wed, 24 May 2017 15:22:11 -0700
Message-ID: <20170524222211.bweuzimsy2vm2lym@intel.com>
References: <1495661981-27249-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1495661981-27249-4-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495661981-27249-4-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 24, 2017 at 05:39:41PM -0400, Stefan Berger wrote:
> To prevent userspace from sending the TPM driver command to set
> the locality, we need to check every command that is sent from
> user space. To distinguish user space commands from internally
> sent commands we introduce an additional state flag
> STATE_DRIVER_COMMAND that is set while the driver sends this
> command. Similar to the TPM 2 space commands we return an error
> code when this command is detected.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm_vtpm_proxy.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
> index 66024bf..1d877cc 100644
> --- a/drivers/char/tpm/tpm_vtpm_proxy.c
> +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
> @@ -43,6 +43,7 @@ struct proxy_dev {
>  #define STATE_OPENED_FLAG        BIT(0)
>  #define STATE_WAIT_RESPONSE_FLAG BIT(1)  /* waiting for emulator response */
>  #define STATE_REGISTERED_FLAG	 BIT(2)
> +#define STATE_DRIVER_COMMAND     BIT(3)  /* sending a driver specific command */
>  
>  	size_t req_len;              /* length of queued TPM request */
>  	size_t resp_len;             /* length of queued TPM response */
> @@ -299,6 +300,28 @@ static int vtpm_proxy_tpm_op_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  	return len;
>  }
>  
> +static int vtpm_proxy_is_driver_command(struct tpm_chip *chip,
> +					u8 *buf, size_t count)
> +{
> +	struct tpm_input_header *hdr = (struct tpm_input_header *)buf;
> +
> +	if (count < sizeof(struct tpm_input_header))
> +		return 0;
> +
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +		switch (be32_to_cpu(hdr->ordinal)) {
> +		case TPM2_CC_SET_LOCALITY:
> +			return 1;
> +		}
> +	} else {
> +		switch (be32_to_cpu(hdr->ordinal)) {
> +		case TPM_ORD_SET_LOCALITY:
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Called when core TPM driver forwards TPM requests to 'server side'.
>   *
> @@ -321,6 +344,10 @@ static int vtpm_proxy_tpm_op_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  		return -EIO;
>  	}
>  
> +	if (!(proxy_dev->state & STATE_DRIVER_COMMAND) &&
> +	    vtpm_proxy_is_driver_command(chip, buf, count))
> +		return -EFAULT;
> +
>  	mutex_lock(&proxy_dev->buf_lock);
>  
>  	if (!(proxy_dev->state & STATE_OPENED_FLAG)) {
> @@ -376,6 +403,7 @@ static int vtpm_proxy_request_locality(struct tpm_chip *chip, int locality)
>  	struct tpm_buf buf;
>  	int rc;
>  	const struct tpm_output_header *header;
> +	struct proxy_dev *proxy_dev = dev_get_drvdata(&chip->dev);
>  
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS,
> @@ -387,9 +415,14 @@ static int vtpm_proxy_request_locality(struct tpm_chip *chip, int locality)
>  		return rc;
>  	tpm_buf_append_u8(&buf, locality);
>  
> +	proxy_dev->state |= STATE_DRIVER_COMMAND;
> +
>  	rc = tpm_transmit_cmd(chip, NULL, buf.data, tpm_buf_length(&buf), 0,
>  			      TPM_TRANSMIT_UNLOCKED | TPM_TRANSMIT_RAW,
>  			      "attempting to set locality");
> +
> +	proxy_dev->state &= ~STATE_DRIVER_COMMAND;
> +
>  	if (rc < 0) {
>  		locality = rc;
>  		goto out;
> -- 
> 2.4.3
> 

Otherwise fine except for the redundant code.

/Jarkko
