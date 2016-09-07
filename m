From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm/tpm_crb: implement tpm crb idle
 state
Date: Wed, 7 Sep 2016 22:17:22 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542CBB41@hasmsx108.ger.corp.intel.com>
References: <1473247953-24617-1-git-send-email-tomas.winkler@intel.com>
	<1473247953-24617-2-git-send-email-tomas.winkler@intel.com>
	<20160907161548.GA4791@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542CBABC@hasmsx108.ger.corp.intel.com>
	<20160907215502.GB29666@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160907215502.GB29666-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, September 08, 2016 00:55
> To: Winkler, Tomas <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Jarkko Sakkinen
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Subject: Re: [tpmdd-devel] [PATCH 1/3] tpm/tpm_crb: implement tpm crb
> idle state
> 
> On Wed, Sep 07, 2016 at 09:14:35PM +0000, Winkler, Tomas wrote:
> 
> > > Jarkko and I have been talking about higher level locking (eg to
> > > sequence a series of operations) it might make more sense to move
> > > the power management up to that layer.
> >
> > I'm not sure this has much benefit, this would be much more error
> > prone and would be unnecessary more complicated than just protecting
> the low API in one place.
> 
> Well, we will have the API, so it shouldn't be much risk. I guess it can change
> later

Maybe I don't understand where are you heading here, anyhow  I don't see siginficat benefit using ready/idle
at more then one place if the hysteresis is working anyway.

> 
> > Yes, of course I've considered runtime_pm but I've pulled from using
> > it for now is that it has many side effects that need to be mapped
> > first, second because of the HW bug we cannot safely detect if the
> > device is in idle state so some more complicated book keeping would
> > have to be implemented. Last we need a simple solution to backport.
> 
> So are you going to send a runtime_pm patch too? What is the downside to
> the idle state that requires it to be controlled by the host and not internally?
> 
> > > > +static int __crb_go_idle(struct device *dev, struct crb_priv
> > > > +*priv) { static int crb_go_idle(struct tpm_chip *chip) {
> > > > +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> > > > +
> > > > +	return __crb_go_idle(&chip->dev, priv);
> > >
> > > Hurm, these ugly wrappers should probably be part of the next patch,
> > > since that is what needs them.
> >
> > You are right it missing a bit context if you're looking into single
> > patch, but the paradigm is used widely in the kernel.
> 
> The widely used paradigm has the wrapper actually do something useful, eg
> lock/unlock. This does nothing useful until you realize it is needed because
> you don't have a chip yet in crb_map_io due to the work around. Which begs
> the question if this is even the right approach at all, or should be chip be
> allocated sooner (as tpm_tis does)..

Okay, not a bad idea, will require a bit more code movement. 

I think there is a memory leak in tpm_tis on the error path; maybe a missing call to dev_put, not sure I had just quick look.

> So I'd rather see it in the next patch, and I'd rather not see it at all, move the
> chip allocation up instead..
> 
> Jason

------------------------------------------------------------------------------
