From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] vTPM: fix missing error handling for suspend operation
Date: Fri, 4 Mar 2016 18:55:38 +0200
Message-ID: <20160304165537.GA13204@intel.com>
References: <1456899827-14365-1-git-send-email-honclo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456899827-14365-1-git-send-email-honclo@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hon Ching(Vicky) Lo" <honclo@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <PeterHuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Vicky Lo <honclo2014@gmail.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 02, 2016 at 01:23:47AM -0500, Hon Ching(Vicky) Lo wrote:
> ibmvtpm_send_crq in tpm_ibmvtpm_suspend returns errors in a more
> granular level than what the existing code does.  This patch adds
> the missing CRQ transport event code checks to ensure appropriate
> action taken, in the case that ibmvtpm_send_crq returns H_CLOSED.
> 
> Signed-off-by: Hon Ching(Vicky) Lo <honclo@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm_ibmvtpm.c |   58 +++++++++++++++++++++++++++++++++++++---
>  drivers/char/tpm/tpm_ibmvtpm.h |    9 ++++++
>  2 files changed, 63 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> index 3e6a226..5d984af 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -335,17 +335,61 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
>  	struct ibmvtpm_crq crq;
>  	u64 *buf = (u64 *) &crq;
>  	int rc = 0;
> +	int sig;
>  
> -	crq.valid = (u8)IBMVTPM_VALID_CMD;
> -	crq.msg = (u8)VTPM_PREPARE_TO_SUSPEND;
> +	crq_initialized = 0;
> +	crq.valid = (u8) IBMVTPM_VALID_CMD;
> +	crq.msg = (u8) VTPM_PREPARE_TO_SUSPEND;
>  
>  	rc = ibmvtpm_send_crq(ibmvtpm->vdev, cpu_to_be64(buf[0]),
>  			      cpu_to_be64(buf[1]));
> +
> +	if ((rc == H_CLOSED) && (crq.valid == (u8) VALID_TRANSPORT_EVENT)) {

What if rc == H_CLOSED and crq.valid != VALID_TRANSPORT_EVENT?

> +		if (crq.msg == (u8) PARTNER_PARTITION_SUSPENDED) {
> +			/* The "partner partition suspended" transport
> +			 * event disables the associated CRQ such that
> +			 * any H_SEND_CRQ hcall() to the associated CRQ
> +			 * returns H_Closed until CRQ has been explicitly
> +			 * enabled using the H_ENABLED_CRQ hcall.
> +			 */
> +			return H_SUCCESS;

I'm having trouble to understand when the suspend happens through this
route and when you just get H_SUCCESS from ibmvtpm_send_crq(). It
seems that there are two ways how suspend can happen.

I don't understand the big picture.

> +		} else if (crq.msg == (u8) PARTNER_PARTITION_FAILED) {
> +			dev_err(ibmvtpm->dev,
> +				"vtpm has terminated fatally; reboot to reinstate a trusted state.\n");
> +		} else if (crq.msg == (u8) PARTNER_PARTITION_DEREG_CRQ) {
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
> +
> +			if (suspend_again_count < 1) {
> +				suspend_again_count++;
> +				goto suspendagain;
> +			}
> +		} else
> +			;
> +	}
> +
>  	if (rc != H_SUCCESS)
> -		dev_err(ibmvtpm->dev,
> -			"tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> +		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_suspend failed rc=%d\n", rc);
>  
>  	return rc;
> +
> +suspendagain:
> +	rc = tpm_ibmvtpm_suspend(ibmvtpm->dev);
> +	suspend_again_count = 0;
> +
> +	if (rc != H_SUCCESS)
> +		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> +
> +	return rc;
> +

Get rid of this horrible looking tail recursion thing.

What the heck is suspend_again_count and why it can be module scope
variable? You could use a local variable instead if you would iterate
with a loop.

/Jarkko
