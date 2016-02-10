From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Wed, 10 Feb 2016 09:28:09 -0700
Message-ID: <20160210162809.GB20730@obsidianresearch.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
	<201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
	<20160210035620.GB7161@intel.com>
	<201602100515.u1A5FpFi002736@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602100515.u1A5FpFi002736-nNA/7dmquNI+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Wed, Feb 10, 2016 at 12:15:44AM -0500, Stefan Berger wrote:
>    Redid that now.
>     https://github.com/stefanberger/linux/commit/83019eaab2cf5eb33f2665efdf9d2a117ed703b2

Yeah, I think you've got that now.

Just a few other random commments..

This isn't great:

	vtpm_dev->dev_num = find_first_zero_bit(dev_mask, VTPM_NUM_DEVICES);

We shouldn't artificially limit the number of devices if
virtualization is the target. Use an idr, or figure out how to get rid
of it. Since it is only used here:

    dev_set_name(&vtpm_dev->dev, "vtpms%d", vtpm_dev->dev_num);

Maybe it could be adjusted to use chip->dev_num instead.

This:
	INIT_WORK(&vtpm_dev->work, vtpm_dev_work);
should be near the kzalloc

Drop the 1 line functions (vtpm_dev_work_start, vtpm_delete_vtpm_dev,

Use u32's here:

	u8 req_buf[TPM_BUFSIZE];     /* request buffer */

and related to ensure the buffer is sensibly aligned

Don't log on user space inputs, use debug or something:

		dev_err(&vtpm_dev->dev,
			"Invalid size in recv: count=%zd, req_len=%zd\n",
			count, len);

This:

	vtpm_dev_work_stop(vtpm_dev);

Doesn't kill a running work thread - more synchronization is needed
for that corner case

Make sure that devm is working for your specific case when this
happens:

 err:
	/* did not register chip */
	vtpm_dev->chip = NULL;

Instrument the core, devm should free the tpm chip when user space
closes the fd. If not the core needs to provide a non-devm alloc for
this driver. (easy)

This spin lock:

	spin_lock(&driver_lock);
	vtpm_dev->dev_num = find_first_zero_bit(dev_mask, VTPM_NUM_DEVICES);
	[..]
		err = device_register(&vtpm_dev->dev); /* does get_device */
	spin_unlock(&driver_lock);

I'm not comfortable with how big a region that is. If you keep
dev_mask, then only lock around the dev_mask manipulation not other
stuff. Relock to undo

fops_write should fail if op_recv isn't waiting for a buffer.

Looks pretty good really

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
