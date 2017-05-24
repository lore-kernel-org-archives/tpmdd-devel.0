From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v5 2/2] tpm: vtpm_proxy: Implement request_locality
 function.
Date: Wed, 24 May 2017 12:27:26 -0700
Message-ID: <20170524192726.qsxrfjamy2khef37@intel.com>
References: <1494867105-30722-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1494867105-30722-3-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170520124018.d2wmhnb6mwmlkgtz@intel.com>
 <3b83ee0e-a20f-3a96-6f25-9c7a2aa68fbd@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3b83ee0e-a20f-3a96-6f25-9c7a2aa68fbd@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, May 22, 2017 at 10:29:24AM -0400, Stefan Berger wrote:
> On 05/20/2017 08:40 AM, Jarkko Sakkinen wrote:
> > On Mon, May 15, 2017 at 12:51:45PM -0400, Stefan Berger wrote:
> > > Implement the request_locality function. To set the locality on the
> > > backend we define vendor-specific TPM 1.2 and TPM 2 ordinals and send
> > > a command to the backend to set the locality for the next commands.
> > > 
> > > To avoid recursing into requesting the locality, we set the
> > > TPM_TRASNMIT_RAW flag when calling tpm_trasnmit_cmd. To avoid recursing
> > > into TPM 2 space related commands, we set the space parameter to NULL.
> > > 
> > > Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > > ---
> > >   drivers/char/tpm/tpm-interface.c  |  1 +
> > >   drivers/char/tpm/tpm_vtpm_proxy.c | 36 ++++++++++++++++++++++++++++++++++++
> > >   include/uapi/linux/vtpm_proxy.h   |  4 ++++
> > >   3 files changed, 41 insertions(+)
> > > 
> > > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > > index 2eacda2..876d45f 100644
> > > --- a/drivers/char/tpm/tpm-interface.c
> > > +++ b/drivers/char/tpm/tpm-interface.c
> > > @@ -537,6 +537,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
> > >   	return 0;
> > >   }
> > > +EXPORT_SYMBOL_GPL(tpm_transmit_cmd);
> > >   #define TPM_DIGEST_SIZE 20
> > >   #define TPM_RET_CODE_IDX 6
> > > diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
> > > index 751059d..66024bf 100644
> > > --- a/drivers/char/tpm/tpm_vtpm_proxy.c
> > > +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
> > > @@ -371,6 +371,41 @@ static bool vtpm_proxy_tpm_req_canceled(struct tpm_chip  *chip, u8 status)
> > >   	return ret;
> > >   }
> > > +static int vtpm_proxy_request_locality(struct tpm_chip *chip, int locality)
> > > +{
> > > +	struct tpm_buf buf;
> > > +	int rc;
> > > +	const struct tpm_output_header *header;
> > > +
> > > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > > +		rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS,
> > > +				  TPM2_CC_SET_LOCALITY);
> > > +	else
> > > +		rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND,
> > > +				  TPM_ORD_SET_LOCALITY);
> > > +	if (rc)
> > > +		return rc;
> > > +	tpm_buf_append_u8(&buf, locality);
> > > +
> > > +	rc = tpm_transmit_cmd(chip, NULL, buf.data, tpm_buf_length(&buf), 0,
> > > +			      TPM_TRANSMIT_UNLOCKED | TPM_TRANSMIT_RAW,
> > > +			      "attempting to set locality");
> > > +	if (rc < 0) {
> > > +		locality = rc;
> > > +		goto out;
> > > +	}
> > > +
> > > +	header = (const struct tpm_output_header *)buf.data;
> > > +	rc = be32_to_cpu(header->return_code);
> > > +	if (rc)
> > > +		locality = -1;
> > > +
> > > +out:
> > > +	tpm_buf_destroy(&buf);
> > > +
> > > +	return locality;
> > > +}
> > > +
> > This looks good.
> > 
> > >   static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
> > >   	.flags = TPM_OPS_AUTO_STARTUP,
> > >   	.recv = vtpm_proxy_tpm_op_recv,
> > > @@ -380,6 +415,7 @@ static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
> > >   	.req_complete_mask = VTPM_PROXY_REQ_COMPLETE_FLAG,
> > >   	.req_complete_val = VTPM_PROXY_REQ_COMPLETE_FLAG,
> > >   	.req_canceled = vtpm_proxy_tpm_req_canceled,
> > > +	.request_locality = vtpm_proxy_request_locality,
> > >   };
> > >   /*
> > > diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
> > > index a69e991..58ac73c 100644
> > > --- a/include/uapi/linux/vtpm_proxy.h
> > > +++ b/include/uapi/linux/vtpm_proxy.h
> > > @@ -46,4 +46,8 @@ struct vtpm_proxy_new_dev {
> > >   #define VTPM_PROXY_IOC_NEW_DEV	_IOWR(0xa1, 0x00, struct vtpm_proxy_new_dev)
> > > +/* vendor specific commands to set locality */
> > > +#define TPM2_CC_SET_LOCALITY	0x20001000
> > > +#define TPM_ORD_SET_LOCALITY	0x20001000
> > > +
> > Maybe we should just have VTPM_CC_SET_LOCALITY? No reason to have TPM
> > version specific constant names. I wonder what would be the best range
> > for these CCs.  Maybe 0xF0xxxxxxxx would be better?
> 
> I am not sure about that.
> 
> > 
> > These are not changes that require a new patch set version but we they
> > need to be discussed before merging these changes.
> 
> Unfortunately there is one more patch needed. We now need to restrict that
> this particular driver command can only be sent from inside the driver and
> never via any of the TPM devices (/dev/vtpm%d or /dev/tpmrm%d). That patch
> could then either return an error code if tried or return an error message.
> In the case of the TPM 2 spaces commands an error code is returned if a
> command isn't known. We could just do that instead of returning a full TPM
> error message. Here's the patch that would do that.
> 
> 
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
> diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c
> b/drivers/char/tpm/tpm_vtpm_proxy.c
> index 66024bf..d25c361 100644
> --- a/drivers/char/tpm/tpm_vtpm_proxy.c
> +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
> @@ -43,6 +43,7 @@ struct proxy_dev {
>  #define STATE_OPENED_FLAG        BIT(0)
>  #define STATE_WAIT_RESPONSE_FLAG BIT(1)  /* waiting for emulator response
> */
>  #define STATE_REGISTERED_FLAG     BIT(2)
> +#define STATE_DRIVER_COMMAND     BIT(3)  /* sending a driver specific
> command */
> 
>      size_t req_len;              /* length of queued TPM request */
>      size_t resp_len;             /* length of queued TPM response */
> @@ -299,6 +300,28 @@ static int vtpm_proxy_tpm_op_recv(struct tpm_chip
> *chip, u8 *buf, size_t count)
>      return len;
>  }
> 
> +static int vtpm_proxy_is_driver_command(struct tpm_chip *chip,
> +                    u8 *buf, size_t count)
> +{
> +    struct tpm_input_header *hdr = (struct tpm_input_header*)buf;
> +
> +    if (count < sizeof(struct tpm_input_header))
> +        return 0;
> +
> +    if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +        switch (be32_to_cpu(hdr->ordinal)) {
> +        case TPM2_CC_SET_LOCALITY:
> +            return 1;
> +        }
> +    } else {
> +        switch (be32_to_cpu(hdr->ordinal)) {
> +        case TPM_ORD_SET_LOCALITY:
> +            return 1;
> +        }
> +    }
> +    return 0;
> +}
> +
>  /*
>   * Called when core TPM driver forwards TPM requests to 'server side'.
>   *
> @@ -321,6 +344,10 @@ static int vtpm_proxy_tpm_op_send(struct tpm_chip
> *chip, u8 *buf, size_t count)
>          return -EIO;
>      }
> 
> +    if (!(proxy_dev->state & STATE_DRIVER_COMMAND) &&
> +        vtpm_proxy_is_driver_command(chip, buf, count))
> +        return -EFAULT;
> +
>      mutex_lock(&proxy_dev->buf_lock);
> 
>      if (!(proxy_dev->state & STATE_OPENED_FLAG)) {
> @@ -376,6 +403,7 @@ static int vtpm_proxy_request_locality(struct tpm_chip
> *chip, int locality)
>      struct tpm_buf buf;
>      int rc;
>      const struct tpm_output_header *header;
> +    struct proxy_dev *proxy_dev = dev_get_drvdata(&chip->dev);
> 
>      if (chip->flags & TPM_CHIP_FLAG_TPM2)
>          rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS,
> @@ -387,9 +415,14 @@ static int vtpm_proxy_request_locality(struct tpm_chip
> *chip, int locality)
>          return rc;
>      tpm_buf_append_u8(&buf, locality);
> 
> +    proxy_dev->state |= STATE_DRIVER_COMMAND;
> +
>      rc = tpm_transmit_cmd(chip, NULL, buf.data, tpm_buf_length(&buf), 0,
>                    TPM_TRANSMIT_UNLOCKED | TPM_TRANSMIT_RAW,
>                    "attempting to set locality");
> +
> +    proxy_dev->state &= ~STATE_DRIVER_COMMAND;
> +
>      if (rc < 0) {
>          locality = rc;
>          goto out;
> -- 
> 2.4.3
> 
> 
> > 
> > >   #endif /* _UAPI_LINUX_VTPM_PROXY_H */
> > > -- 
> > > 2.4.3
> > > 
> > /Jarkko
> > 
> 

Please bump one more patch set version. Thanks.

/Jarkko
