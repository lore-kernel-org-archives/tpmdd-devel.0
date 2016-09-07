From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm/tpm_crb: implement tpm crb idle
 state
Date: Wed, 7 Sep 2016 15:55:02 -0600
Message-ID: <20160907215502.GB29666@obsidianresearch.com>
References: <1473247953-24617-1-git-send-email-tomas.winkler@intel.com>
	<1473247953-24617-2-git-send-email-tomas.winkler@intel.com>
	<20160907161548.GA4791@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542CBABC@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542CBABC-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 07, 2016 at 09:14:35PM +0000, Winkler, Tomas wrote:

> > Jarkko and I have been talking about higher level locking (eg to sequence a
> > series of operations) it might make more sense to move the power
> > management up to that layer. 
> 
> I'm not sure this has much benefit, this would be much more error prone and
> would be unnecessary more complicated than just protecting the low API in one place.

Well, we will have the API, so it shouldn't be much risk. I guess it
can change later

> Yes, of course I've considered runtime_pm but I've pulled from using
> it for now is that it has many side effects that need to be mapped
> first, second because of the HW bug we cannot safely detect if the
> device is in idle state so some more complicated book keeping would
> have to be implemented. Last we need a simple solution to backport.

So are you going to send a runtime_pm patch too? What is the downside
to the idle state that requires it to be controlled by the host and
not internally?

> > > +static int __crb_go_idle(struct device *dev, struct crb_priv *priv) {
> > > +static int crb_go_idle(struct tpm_chip *chip) {
> > > +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> > > +
> > > +	return __crb_go_idle(&chip->dev, priv);
> > 
> > Hurm, these ugly wrappers should probably be part of the next patch, since
> > that is what needs them.
> 
> You are right it missing a bit context if you're looking into single
> patch, but the paradigm is used widely in the kernel.

The widely used paradigm has the wrapper actually do something useful,
eg lock/unlock. This does nothing useful until you realize it is
needed because you don't have a chip yet in crb_map_io due to the work
around. Which begs the question if this is even the right approach at all,
or should be chip be allocated sooner (as tpm_tis does)..

So I'd rather see it in the next patch, and I'd rather not see it at
all, move the chip allocation up instead..

Jason

------------------------------------------------------------------------------
