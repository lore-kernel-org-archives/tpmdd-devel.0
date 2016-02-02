From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: fix rollback/cleanup before
 tpm_chip_register()
Date: Tue, 2 Feb 2016 16:13:53 -0700
Message-ID: <20160202231353.GA32711@obsidianresearch.com>
References: <1454205942-13033-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454205942-13033-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Jan 30, 2016 at 06:05:42PM -0800, Jarkko Sakkinen wrote:
> The release-callback is not used before the device is attached to the
> device hierarchy. This caused resources not to cleanup properly if the
> device driver initialization failed before tpm_chip_register().

This commentary is not right, the release callback is callable
immediately after device_initialize returns, it will be called by the
last put_device().

> - * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
> - * @dev: device to which the chip is associated
> + * tpmm_chip_alloc() - allocate and initialize a TPM chip
> + * @pdev: the platform device who is the parent of the chip

? A platform device is not required, just something in a state that
can handle devm.

> +	/* Associate character device with the platform device only after
> +	 * it is properly initialized.
> +	 */
> +	dev_set_drvdata(pdev, chip);
> +	devm_add_action(pdev, (void (*)(void *)) tpm_dev_release,
> &chip->dev);

No, a release function can never be called naked. The action needs
to do put_device, which is the error unwind for device_initialize().

> @@ -162,7 +165,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  			MINOR(chip->dev.devt), rc);
>  
>  		cdev_del(&chip->cdev);
> -		return rc;
> +	} else {
> +		devm_remove_action(chip->dev.parent,
> +				   (void (*)(void *)) tpm_dev_release,
> +				   &chip->dev);

This is in the wrong place, the devm should be canceled only if
tpm_chip_register returns success, at that point the caller's contract
is to guarentee a call to tpm_chip_unregister, and
tpm_chip_unregister does the put_device that calls the release
function.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
