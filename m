From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 15:46:42 -0700
Message-ID: <20160212224642.GA4781@obsidianresearch.com>
References: <20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120353.u1C3rYif023135@d01av05.pok.ibm.com>
	<20160212184051.GB4289@obsidianresearch.com>
	<201602122031.u1CKVIOp028400@d03av03.boulder.ibm.com>
	<20160212203956.GB10540@obsidianresearch.com>
	<201602122044.u1CKiMbR023495@d03av03.boulder.ibm.com>
	<20160212211538.GA20737@obsidianresearch.com>
	<201602122223.u1CMNKL2004615@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602122223.u1CMNKL2004615-nNA/7dmquNI+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Fri, Feb 12, 2016 at 05:23:16PM -0500, Stefan Berger wrote:

>    > I don't see how that can happen. Looking at the tpm cdev, it is

>    Well, following my tests, it does happen.

How are you testing for use-after-free bugs? Did you test the kapi
interface? Did you get it in *exactly* the right configuration to
cause this?

>    > So, we have a situation where tpm_unregister can return, release the
>    > kref on the vtpm and still have outstanding users, which will result
>    > in a use after-free.

>    Maybe you should give it a try ... I don't see these problems and any
>    change seems like ill-fixing it. What will be accessed after
>    tpm_unregister? The only case we have tpm_unregister is here:

>    static void vtpm_delete_device_pair(structvtpm_dev *vtpm_dev)
>    {
>            tpm_chip_unregister(vtpm_dev->chip);
>            vtpm_fops_undo_open(vtpm_dev);
>            vtpm_delete_vtpm_dev(vtpm_dev);
>    }

>    followed by:

>    static inline voidvtpm_delete_vtpm_dev(struct vtpm_dev *vtpm_dev)
>    {
>            put_device(&vtpm_dev->chip->dev); /* frees chip */
>            device_unregister(&vtpm_dev->dev); /* does put_device */
>    }

>    I don't see a problem with that.

device_unregister will put_device(vtpmt_dev) which will kfree it since
no refs are left.

tpm_chip is still alive because the cdev/kapi are still holding a ref
on it.

The cdev/kapi can still call vtpm_tpm_op_send which will then deref
chip->priv which is the free'd vtpm_dev.

Any attempt to test for this scenario is very likely to hit the
STATE_OPENED_BIT test and exit without crashing. However that is just
a user-after free getting lucky. Testing is not a substitute for
proper analysis.

Show me an analysis of what in cdev/kapi is holding the kref on
vtpm_dev if you still think this can't happen.

As I said, the only kref the tpm core takes on vtpm_dev is dropped
by tpm_chip_unregister.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
