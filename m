From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Tue, 19 Jan 2016 16:51:07 -0700
Message-ID: <20160119235107.GA4307@obsidianresearch.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452787318-29610-4-git-send-email-stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 14, 2016 at 11:01:57AM -0500, Stefan Berger wrote:
> +	pdev = platform_device_register_simple("tpm_vtpm", vtpm_dev->dev_num,
> +					       NULL, 0);

This seems strange, something like this should not be creating
platform_devices.

tpm's cannot be attached to platform_devices outside their probe
functions, I just fixed that bug in tpm_tis.

Attach the tpm to a device on the vtpm_class? Do it through a callback
that takes care of devm? IIRC there is one but the name escapes me now
:)

> +	vtpm_dev->chip = tpmm_chip_alloc_pattern(vtpm_dev->pdev,
> +				&vtpm_tpm_ops,
> +				VTPM_DEV_PREFIX_CLIENT"%d");

I agree with Jarkko I don't see why these deserve special names..

Presumably some namespace magic can be used to make them show up as
tpm0 in a container?

> +	vtpm_dev->chip->flags |= TPM_CHIP_FLAG_NO_SYSFS | TPM_CHIP_FLAG_NO_LOG;

Why no sysfs files?

> +	switch (ioctl) {
> +	case VTPM_NEW_DEV:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +		vtpm_new_pair_p = argp;
> +		if (copy_from_user(&vtpm_new_pair, vtpm_new_pair_p,
> +				   sizeof(vtpm_new_pair)))
> +			return -EFAULT;
> +		vtpm_dev = vtpm_create_device_pair(&vtpm_new_pair);
> +		if (IS_ERR(vtpm_dev))
> +			return PTR_ERR(vtpm_dev);
> +		if (copy_to_user(vtpm_new_pair_p, &vtpm_new_pair,
> +				 sizeof(vtpm_new_pair)))
> +			return -EFAULT;

Another way to handle this is to return the FD for the server side of
the new TPM here and then route accesses from the /dev/tpmX side to
that FD. Avoid the extra char device. There is some kernel
infrasturcture that helpd do this (anon fd or something, IIRC)

For this usage that might make more sense than trying to copy the ptmx
scheme, which is like that for other reasons..

> +	case VTPM_DEL_DEV:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;

Then del becomes close() on the special fd

> +	case VTPM_GET_VTPMDEV:

And this wouldn't be needed

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
