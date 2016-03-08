From: "Hon Ching(Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] vTPM: fix missing error handling for
	suspend operation
Date: Tue, 08 Mar 2016 15:44:15 -0500
Message-ID: <1457469855.30806.14.camel@vtpm2014.ibm.com>
References: <1456899827-14365-1-git-send-email-honclo@linux.vnet.ibm.com>
	<20160304165537.GA13204@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160304165537.GA13204-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2016-03-04 at 18:55 +0200, Jarkko Sakkinen wrote:
> On Wed, Mar 02, 2016 at 01:23:47AM -0500, Hon Ching(Vicky) Lo wrote:
> > ibmvtpm_send_crq in tpm_ibmvtpm_suspend returns errors in a more
> > granular level than what the existing code does.  This patch adds
> > the missing CRQ transport event code checks to ensure appropriate
> > action taken, in the case that ibmvtpm_send_crq returns H_CLOSED.
> > 
> > Signed-off-by: Hon Ching(Vicky) Lo <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm_ibmvtpm.c |   58 +++++++++++++++++++++++++++++++++++++---
> >  drivers/char/tpm/tpm_ibmvtpm.h |    9 ++++++
> >  2 files changed, 63 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> > index 3e6a226..5d984af 100644
> > --- a/drivers/char/tpm/tpm_ibmvtpm.c
> > +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> > @@ -335,17 +335,61 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
> >  	struct ibmvtpm_crq crq;
> >  	u64 *buf = (u64 *) &crq;
> >  	int rc = 0;
> > +	int sig;
> >  
> > -	crq.valid = (u8)IBMVTPM_VALID_CMD;
> > -	crq.msg = (u8)VTPM_PREPARE_TO_SUSPEND;
> > +	crq_initialized = 0;
> > +	crq.valid = (u8) IBMVTPM_VALID_CMD;
> > +	crq.msg = (u8) VTPM_PREPARE_TO_SUSPEND;
> >  
> >  	rc = ibmvtpm_send_crq(ibmvtpm->vdev, cpu_to_be64(buf[0]),
> >  			      cpu_to_be64(buf[1]));
> > +
> > +	if ((rc == H_CLOSED) && (crq.valid == (u8) VALID_TRANSPORT_EVENT)) {
> 
> What if rc == H_CLOSED and crq.valid != VALID_TRANSPORT_EVENT?

If that's the case, the function will return rc as the execution will
skip this if block.  

> 
> > +		if (crq.msg == (u8) PARTNER_PARTITION_SUSPENDED) {
> > +			/* The "partner partition suspended" transport
> > +			 * event disables the associated CRQ such that
> > +			 * any H_SEND_CRQ hcall() to the associated CRQ
> > +			 * returns H_Closed until CRQ has been explicitly
> > +			 * enabled using the H_ENABLED_CRQ hcall.
> > +			 */
> > +			return H_SUCCESS;
> 
> I'm having trouble to understand when the suspend happens through this
> route and when you just get H_SUCCESS from ibmvtpm_send_crq(). It
> seems that there are two ways how suspend can happen.
> 
> I don't understand the big picture.

You're right.  This is not a valid case.  As I revisited it, I realized
that "partner partition suspended" transport event was handled in the 
rtas calls; vtpm doesn't have to take that into account.  I'll get rid
of this if-block.

So, upon receiving H_CLOSED only the following two events are expected
to be handled: 1) vtpm has terminated fatally. 2) partner partition
preregistered CRQ.


> > +		} else if (crq.msg == (u8) PARTNER_PARTITION_FAILED) {
> > +			dev_err(ibmvtpm->dev,
> > +				"vtpm has terminated fatally; reboot to reinstate a trusted state.\n");
> > +		} else if (crq.msg == (u8) PARTNER_PARTITION_DEREG_CRQ) {
> > +			/* The vtpm is in the process of being reloaded by
> > +			 * firmware and has de-registered CRQ.  The client
> > +			 * must wait for the CRQ INITIALIZATION message and
> > +			 * respond and must resubmit suspend message.
> > +			 */
> > +			sig =
> > +			    wait_event_interruptible(ibmvtpm->wq,
> > +						     crq_initialized == 1);
> > +			if (sig)
> > +				return -EINTR;
> > +
> > +			if (suspend_again_count < 1) {
> > +				suspend_again_count++;
> > +				goto suspendagain;
> > +			}
> > +		} else
> > +			;
> > +	}
> > +
> >  	if (rc != H_SUCCESS)
> > -		dev_err(ibmvtpm->dev,
> > -			"tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> > +		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> >  
> >  	return rc;
> > +
> > +suspendagain:
> > +	rc = tpm_ibmvtpm_suspend(ibmvtpm->dev);
> > +	suspend_again_count = 0;
> > +
> > +	if (rc != H_SUCCESS)
> > +		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> > +
> > +	return rc;
> > +
> 
> Get rid of this horrible looking tail recursion thing.
> 
> What the heck is suspend_again_count and why it can be module scope
> variable? You could use a local variable instead if you would iterate
> with a loop.
> 

The reason for the 'goto' statement and the suspend_again_count was to
prevent the suspend function recurse again.  In the case if vtpm is in
the process of being reloaded by firmware, we want to wait for the CRQ
INITIALIZATION and resubmit suspend message i.e. recurse only once.



> /Jarkko
> 



------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://makebettercode.com/inteldaal-eval
