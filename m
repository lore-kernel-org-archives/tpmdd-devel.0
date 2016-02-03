From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix rollback/cleanup before
 tpm_chip_register()
Date: Wed, 3 Feb 2016 08:02:35 -0800
Message-ID: <20160203160235.GA15567@intel.com>
References: <1454205942-13033-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160202231353.GA32711@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160202231353.GA32711-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Tue, Feb 02, 2016 at 04:13:53PM -0700, Jason Gunthorpe wrote:
> On Sat, Jan 30, 2016 at 06:05:42PM -0800, Jarkko Sakkinen wrote:
> > The release-callback is not used before the device is attached to the
> > device hierarchy. This caused resources not to cleanup properly if the
> > device driver initialization failed before tpm_chip_register().
> 
> This commentary is not right, the release callback is callable
> immediately after device_initialize returns, it will be called by the
> last put_device().

Ah, right.

> > - * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
> > - * @dev: device to which the chip is associated
> > + * tpmm_chip_alloc() - allocate and initialize a TPM chip
> > + * @pdev: the platform device who is the parent of the chip
> 
> ? A platform device is not required, just something in a state that
> can handle devm.

Platform device in a generic sense like like ACPI or PNP device or
something else. How would you call it instead? I want to call the
parameter something else than 'dev' solely for readability.

Would s/the platform device/the parent device/ be better?

> > +	/* Associate character device with the platform device only after
> > +	 * it is properly initialized.
> > +	 */
> > +	dev_set_drvdata(pdev, chip);
> > +	devm_add_action(pdev, (void (*)(void *)) tpm_dev_release,
> > &chip->dev);
> 
> No, a release function can never be called naked. The action needs
> to do put_device, which is the error unwind for device_initialize().

Got it (already from your first comment)!

What does "called naked" even mean? I just don't understand the
english here and want to be sure that I understand what you are saying
and not make false assumptions.


> > @@ -162,7 +165,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> >  			MINOR(chip->dev.devt), rc);
> >  
> >  		cdev_del(&chip->cdev);
> > -		return rc;
> > +	} else {
> > +		devm_remove_action(chip->dev.parent,
> > +				   (void (*)(void *)) tpm_dev_release,
> > +				   &chip->dev);
> 
> This is in the wrong place, the devm should be canceled only if
> tpm_chip_register returns success, at that point the caller's contract
> is to guarentee a call to tpm_chip_unregister, and
> tpm_chip_unregister does the put_device that calls the release
> function.

rc == 0 at that point i.e. success. I don't see the problem here.

> Jason

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
