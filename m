From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm/tpm_crb: implement tpm crb idle
 state
Date: Wed, 7 Sep 2016 21:14:35 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542CBABC@hasmsx108.ger.corp.intel.com>
References: <1473247953-24617-1-git-send-email-tomas.winkler@intel.com>
	<1473247953-24617-2-git-send-email-tomas.winkler@intel.com>
	<20160907161548.GA4791@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160907161548.GA4791-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> On Wed, Sep 07, 2016 at 02:32:31PM +0300, Tomas Winkler wrote:
> > The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady for
> > SW to indicate that the device can enter or should exit the idle state.
> >
> > The legacy ACPI-start (SMI + DMA) based devices do not support these
> > bits and the idle state management is not exposed to the host SW.
> > Thus, this functionality only is enabled only for a CRB start (MMIO)
> > based devices.
> >
> > We introduce two new callbacks for command ready and go idle for TPM
> > CRB device which are called across TPM transactions.
> 
> Jarkko and I have been talking about higher level locking (eg to sequence a
> series of operations) it might make more sense to move the power
> management up to that layer. 

I'm not sure this has much benefit, this would be much more error prone and
would be unnecessary more complicated than just protecting the low API in one place.

>No sense in going to idle mode if we know
> another command is about to come.

Yes you are right, this is of course one thing that comes immediately to mind, 
and this is indeed implemented in the FW already and also what would autosuspend feature 
in runtime_pm provide in via  SW ....  if we would use it.  
So shortly from the functional point this is covered, the idle state is not trashed. 

> Are you sure this shouldn't be linked into some kind of core kernel pm
> scheme? Why is this different from the existing pm stuff?
>
Yes, of course I've considered runtime_pm but I've pulled from using it for now 
is that it has many side effects that need to be mapped first, second because of the HW bug 
we cannot safely detect if the device is in idle state so some more complicated book keeping 
would have to be implemented. Last we need a simple solution to backport.
 
> > +static int __crb_go_idle(struct device *dev, struct crb_priv *priv) {
> > +static int crb_go_idle(struct tpm_chip *chip) {
> > +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> > +
> > +	return __crb_go_idle(&chip->dev, priv);
> 
> Hurm, these ugly wrappers should probably be part of the next patch, since
> that is what needs them.

You are right it missing a bit context if you're looking into single patch, but the paradigm is used widely in the kernel.
If this blocks this patch from merging I will move the code.
Thanks
Tomas


------------------------------------------------------------------------------
