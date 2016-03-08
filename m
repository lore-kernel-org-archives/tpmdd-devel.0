From: "Hon Ching(Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] vTPM: fix missing error handling for
	suspend operation
Date: Tue, 08 Mar 2016 17:54:38 -0500
Message-ID: <1457477678.800.7.camel@vtpm2014.ibm.com>
References: <1456899827-14365-1-git-send-email-honclo@linux.vnet.ibm.com>
	<20160304165537.GA13204@intel.com>
	<1457469855.30806.14.camel@vtpm2014.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1457469855.30806.14.camel-0wQ8x0XRVuT1ENwx4SLHqw@public.gmane.org>
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

> > > +		} else if (crq.msg == (u8) PARTNER_PARTITION_FAILED) {
> > > +			dev_err(ibmvtpm->dev,
> > > +				"vtpm has terminated fatally; reboot to reinstate a trusted state.\n");
> > > +		} else if (crq.msg == (u8) PARTNER_PARTITION_DEREG_CRQ) {
> > > +			/* The vtpm is in the process of being reloaded by
> > > +			 * firmware and has de-registered CRQ.  The client
> > > +			 * must wait for the CRQ INITIALIZATION message and
> > > +			 * respond and must resubmit suspend message.
> > > +			 */
> > > +			sig =
> > > +			    wait_event_interruptible(ibmvtpm->wq,
> > > +						     crq_initialized == 1);
> > > +			if (sig)
> > > +				return -EINTR;
> > > +
> > > +			if (suspend_again_count < 1) {
> > > +				suspend_again_count++;
> > > +				goto suspendagain;
> > > +			}
> > > +		} else
> > > +			;
> > > +	}
> > > +
> > >  	if (rc != H_SUCCESS)
> > > -		dev_err(ibmvtpm->dev,
> > > -			"tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> > > +		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> > >  
> > >  	return rc;
> > > +
> > > +suspendagain:
> > > +	rc = tpm_ibmvtpm_suspend(ibmvtpm->dev);
> > > +	suspend_again_count = 0;
> > > +
> > > +	if (rc != H_SUCCESS)
> > > +		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> > > +
> > > +	return rc;
> > > +
> > 
> > Get rid of this horrible looking tail recursion thing.
> > 
> > What the heck is suspend_again_count and why it can be module scope
> > variable? You could use a local variable instead if you would iterate
> > with a loop.
> > 
> > /Jarkko
> > 
> 
> The reason for the 'goto' statement and the suspend_again_count was to
> prevent the suspend function recurse again.  In the case if vtpm is in
> the process of being reloaded by firmware, we want to wait for the CRQ
> INITIALIZATION and resubmit suspend message i.e. recurse only once.
> 
Never mind..  I don't really save any repetitive code by using recursion
now.  I'll rework and resubmit the patch.


Thanks,
Vicky



------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://makebettercode.com/inteldaal-eval
