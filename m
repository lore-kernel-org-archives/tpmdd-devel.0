From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix the cleanup of struct tpm_chip
Date: Fri, 12 Feb 2016 05:35:44 +0200
Message-ID: <20160212033543.GA6098@intel.com>
References: <1454988630-27942-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160211193415.GA24465@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160211193415.GA24465-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 11, 2016 at 12:34:15PM -0700, Jason Gunthorpe wrote:
> On Tue, Feb 09, 2016 at 05:30:30AM +0200, Jarkko Sakkinen wrote:
> > If the initialization fails before tpm_chip_register(), put_device()
> > will be not called, which causes release callback not to be called.
> > This patch fixes the issue by adding put_device() to devres list of
> > the parent device.
> > 
> > Fixes: 313d21eeab ("tpm: device class for tpm")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >  drivers/char/tpm/tpm-chip.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index 1a9dcee..ea904d1 100644
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -136,6 +136,8 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
> >  	chip->cdev.owner = chip->pdev->driver->owner;
> >  	chip->cdev.kobj.parent = &chip->dev.kobj;
> >  
> > +	devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
> > +
> 
> Erm, don't forget the error handling here.
> 
> Something like this:
> 
> 	rc = devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
> 	if (rc) {
> 		put_device(&chip->dev);
> 		return ERR_PTR(rc);
> 	}

I'll implement that as a separate commit since it is already in pull
request. Thanks.

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
