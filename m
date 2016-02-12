From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 14:15:38 -0700
Message-ID: <20160212211538.GA20737@obsidianresearch.com>
References: <20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120353.u1C3rYif023135@d01av05.pok.ibm.com>
	<20160212184051.GB4289@obsidianresearch.com>
	<201602122031.u1CKVIOp028400@d03av03.boulder.ibm.com>
	<20160212203956.GB10540@obsidianresearch.com>
	<201602122044.u1CKiMbR023495@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602122044.u1CKiMbR023495-MijUUJkLaQs+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Fri, Feb 12, 2016 at 03:44:14PM -0500, Stefan Berger wrote:
>    What I observed is that both tpm_chip and vtpm_dev structures are freed
>    once the last one of two sides (/dev/tpmX or server side file
>    descriptor) closes.

Hmmm...

I don't see how that can happen. Looking at the tpm cdev, it is
continues to exist even after tpm_unregister returns (cdev_del does
not force close existing opens). Certainly the kAPI (ie
tpm_chip_find_get) will continue to use the chip without blocking
tpm_unregister.

I see no mechanism for the cdev/kAPI to continue to hold a kref on the
vtpm struct.

The obvious one would be because the vtpm struct is a parent of the
chip, but that kref is let go during device_del.

So, we have a situation where tpm_unregister can return, release the
kref on the vtpm and still have outstanding users, which will result
in a use after-free.

[BTW, your lastest vtpm on github still has a problem with error
 unwind. Move the put_device(&vtpm_dev->chip->dev);  from
 vtpm_delete_vtpm_dev() and put it in vtpm_dev_release() with a NULL
 test.

 The put_device is missing after the tpm_chip_unregister call, the
 above is the safest way to fix it.
 
 This is why you shouldn't wrapper put_device, anything but naked
 put_device is probably wrong]

[Also, err_kfree should not exist in vtpm_create_vtpm_dev, always
 put_device after device_initialize returns, the comment near the device_add
 is wrong, it is using the get_device done implicitly by
 device_initialize]

[Don't forget to error check dev_set_name]

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
