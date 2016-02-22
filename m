From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 03/11] tpm: Get rid of devname
Date: Mon, 22 Feb 2016 21:42:02 +0200
Message-ID: <20160222194202.GC32667@intel.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-4-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222181929.GB22088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160222181929.GB22088-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Feb 22, 2016 at 11:19:29AM -0700, Jason Gunthorpe wrote:
> On Fri, Feb 19, 2016 at 07:42:00AM -0500, Stefan Berger wrote:
> >  
> > -	dev_set_name(&chip->dev, "%s", chip->devname);
> > +	err = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
> > +	if (err)
> > +		goto out;
> >  
> >  	device_initialize(&chip->dev);
> >  
> > @@ -142,6 +142,10 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
> >  	}
> >  
> >  	return chip;
> > +
> > +out:
> > +	put_device(&chip->dev);
> > +	return ERR_PTR(err);
> 
> Oops, something went wrong here in all the rebasing - dev_set_name has
> to be after devince_initialize.

Why dev_set_name() cannot be called before device_initialize(). I see
many drivers call it before device_register() like RTC driver just as
an example:

http://lxr.free-electrons.com/source/drivers/rtc/class.c?v4.4#L226

If the call order is wrong, shouldn't fix for the call order be a
separate patch?

> Jason

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
