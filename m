From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3] vTPM: fix missing error handling for suspend operation
Date: Tue, 5 Apr 2016 18:23:07 +0300
Message-ID: <20160405152307.GA20516@intel.com>
References: <1459816186-7220-1-git-send-email-honclo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459816186-7220-1-git-send-email-honclo@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hon Ching(Vicky) Lo" <honclo@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <PeterHuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 04, 2016 at 08:29:46PM -0400, Hon Ching(Vicky) Lo wrote:
> ibmvtpm_send_crq in tpm_ibmvtpm_suspend returns errors in a more
> granular level than what the existing code does, according to the
> PAPR standard.  This patch adds the missing CRQ transport event
> code checks to ensure the appropriate actions are taken, in the
> case that ibmvtpm_send_crq returns H_CLOSED.

What are the transport events really? The commit message does not
provide any information. What are the appropriate actions? Please refine
the commit message.

The code quality is just depressing to be frank. I think I already
commented the loop-construction earlier. Please use a proper loop
construction and get rid of your goto-statement mess.

This is so much all over the place in this patch that I'll say this only
once here: please remove u8-casts that you use together with constant
values. They are not mandatory.

BTW, does this patch pass checkpatch.pl?

> Signed-off-by: Hon Ching(Vicky) Lo <honclo@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm_ibmvtpm.c |   43 ++++++++++++++++++++++++++++++++++++---
>  drivers/char/tpm/tpm_ibmvtpm.h |    7 ++++++
>  2 files changed, 46 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> index 3e6a226..ea2a970 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -335,17 +335,46 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
>  	struct ibmvtpm_crq crq;
>  	u64 *buf = (u64 *) &crq;
>  	int rc = 0;
> +	int counter = 0;
> +	int sig;
>  
> -	crq.valid = (u8)IBMVTPM_VALID_CMD;
> -	crq.msg = (u8)VTPM_PREPARE_TO_SUSPEND;
> +suspend:
> +	crq_initialized = 0;
> +	crq.valid = (u8) IBMVTPM_VALID_CMD;
> +	crq.msg = (u8) VTPM_PREPARE_TO_SUSPEND;
>  
>  	rc = ibmvtpm_send_crq(ibmvtpm->vdev, cpu_to_be64(buf[0]),
>  			      cpu_to_be64(buf[1]));
> +
> +	if ((rc == H_CLOSED) && (crq.valid == (u8) VALID_TRANSPORT_EVENT)) {
> +		if (crq.msg == (u8) PARTNER_PARTITION_FAILED) {
> +			dev_err(ibmvtpm->dev,
> +				"vtpm has terminated fatally; reboot to reinstate a trusted state.\n");
> +		}
> +
> +		if ((crq.msg == (u8) PARTNER_PARTITION_DEREG_CRQ)
> +		    && (counter < 1)) {
> +			counter++;
> +
> +			/* The vtpm is in the process of being reloaded by
> +			 * firmware and has de-registered CRQ.  The client
> +			 * must wait for the CRQ INITIALIZATION message and
> +			 * respond and must resubmit suspend message.
> +			 */
> +			sig =
> +			    wait_event_interruptible(ibmvtpm->wq,
> +						     crq_initialized == 1);
> +			if (sig)
> +				return -EINTR;
> +			goto suspend;
> +		}
> +	}
> +
>  	if (rc != H_SUCCESS)
> -		dev_err(ibmvtpm->dev,
> -			"tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> +		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_suspend failed rc=%d\n", rc);

Zero value change.

>  
>  	return rc;
> +

Extra newline.

>  }
>  
>  /**
> @@ -477,6 +506,9 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
>  		case INIT_CRQ_COMP_RES:
>  			dev_info(ibmvtpm->dev,
>  				 "CRQ initialization completed\n");
> +			/* in case vtpm is being reloaded */
> +			crq_initialized = 1;
> +			wake_up_interruptible(&ibmvtpm->wq);
>  			return;
>  		default:
>  			dev_err(ibmvtpm->dev, "Unknown crq message type: %d\n", crq->msg);
> @@ -517,6 +549,9 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
>  			ibmvtpm->res_len = be16_to_cpu(crq->len);
>  			wake_up_interruptible(&ibmvtpm->wq);
>  			return;
> +		case VTPM_PREPARE_TO_SUSPEND_RES:
> +			dev_info(ibmvtpm->dev, "Prepare to Suspend Response\n");
> +			return;

Is this really necessary? If so, why?

>  		default:
>  			return;
>  		}
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.h b/drivers/char/tpm/tpm_ibmvtpm.h
> index 6af9289..ed5fd5f 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.h
> +++ b/drivers/char/tpm/tpm_ibmvtpm.h
> @@ -73,4 +73,11 @@ struct ibmvtpm_dev {
>  #define VTPM_PREPARE_TO_SUSPEND			0x04
>  #define VTPM_PREPARE_TO_SUSPEND_RES		(0x04 | VTPM_MSG_RES)
>  
> +/* vTPM CRQ Transport Event codes */
> +#define VALID_TRANSPORT_EVENT		0xFF
> +#define PARTNER_PARTITION_FAILED	0x01
> +#define PARTNER_PARTITION_DEREG_CRQ	0x02
> +
> +int crq_initialized;
> +
>  #endif
> -- 
> 1.7.1
> 

/Jarkko
