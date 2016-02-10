From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Wed, 10 Feb 2016 15:23:13 -0700
Message-ID: <20160210222313.GA7047@obsidianresearch.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
	<201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
	<20160210035620.GB7161@intel.com>
	<201602100515.u1A5FpFi002736@d03av02.boulder.ibm.com>
	<20160210162809.GB20730@obsidianresearch.com>
	<201602102145.u1ALjSAs001597@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602102145.u1ALjSAs001597-2xHzGjyANq4+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

>    > We shouldn't artificially limit the number of devices if
>    > virtualization is the target. Use an idr, or figure out how to get rid
>    > of it. Since it is only used here:
>    >
>    >     dev_set_name(&vtpm_dev->dev, "vtpms%d", vtpm_dev->dev_num);
>    >
>    > Maybe it could be adjusted to use chip->dev_num instead.

>    The chip->dev_num comes back from tpmm_chip_alloc() which is called
>    with the device as a parameter. That's the device we're trying to

Hm, that is only needed for devm, could also do the tpm/tpmm split and
avoid needing a registered dev.

>    create. So it seems we need to have two independency ways to generate
>    unique device names. My suggestion would have been to increase the
>    bitmap to the maximum size of the minor numbers but that's 20 bits,
>    1Mb. This would need to be done for both sides.

No way

>    I don't know how idr applies here from what I read in an article.
>    [2]https://lwn.net/Articles/103209/

Most subsystems will use a idr to map the index number back to their
private number. idr efficiently allocates these numbers. Eg look at
how drivers/rtc/class.c uses the ida_ functions.

BTW, get rid of vtpm_list - it seems totally unusued.


>    >
>    > Drop the 1 line functions (vtpm_dev_work_start, vtpm_delete_vtpm_dev,
>    We have these function pairs here:
>    vtpm_dev_work_start
>    vtpm_dev_work_stop
>    and
>    vtpm_create_vtpm_dev
>    vtpm_delete_vtpm_dev
>    Can we just keep them as pairs with the one function undoing what the
>    other one has done. I prefix the one-liners with a 'static inline' and
>    let the compiler optimize the code.

I don't care that much either way.. But these sorts of obfuscating
wrappers are not really in line with good kernel practices.

Especially if they can only legally be called from one place. Ie the
work cleanup can only be properly called from fops release..


>    > Use u32's here:
>    >
>    >    u8 req_buf[TPM_BUFSIZE];     /* request buffer */
>    >
>    > and related to ensure the buffer is sensibly aligned
>    May I ask why use u32's for a byte buffer? I am not sure what alignment
>    we need here. 4 byte boundary for maximum memcpy performance?

Yes, it is nice to see the alignment guarenteed if memcpy is the
primary use of this memory. It almost always happens naturally..

>    > Doesn't kill a running work thread - more synchronization is needed
>    > for that corner case
>    Do you mean another test for STATE_OPEN bit is needed before it enters
>    the wait_event_interruptible in the code below?

No, just use a typical kernel idiom:

            clear_bit(STATE_OPENED, &vtpm_dev->state);
            wake_up_interruptible(&vtpm_dev->wq);
	    flush_workqueue(&vtpm_dev->work);

And it would be typical/desirable to see that open coded in the
one and only cleanup routine. That is what I usually look for when
looking at work queues.

I can't rember off hand if you need locking around dev->state to make
the above work, IIRC the bit ops are special.

Don't use work_busy in production code.

>    >
>    > fops_write should fail if op_recv isn't waiting for a buffer.
>    So we introduce another state flag whether we are in receiving or
>    sending mode ? Return -EBADF in the case of an unexpected write() ?
>    Though -EBADF indicates "fd is not a valid file descriptor or is not
>    open for writing." So return -EIO?

Probably yeah, pick an error code makes sense. EIO is probably OK, but
maybe shift the 'STATE_OPEN' code to EPIPE or something.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
