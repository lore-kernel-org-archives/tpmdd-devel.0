From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 16:19:12 -0700
Message-ID: <20160212231912.GA7034@obsidianresearch.com>
References: <201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120353.u1C3rYif023135@d01av05.pok.ibm.com>
	<20160212184051.GB4289@obsidianresearch.com>
	<201602122031.u1CKVIOp028400@d03av03.boulder.ibm.com>
	<20160212203956.GB10540@obsidianresearch.com>
	<201602122044.u1CKiMbR023495@d03av03.boulder.ibm.com>
	<20160212211538.GA20737@obsidianresearch.com>
	<201602122223.u1CMNJXl023711@d01av01.pok.ibm.com>
	<201602122247.u1CMlFni023527@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602122247.u1CMlFni023527-2xHzGjyANq4+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Fri, Feb 12, 2016 at 05:47:11PM -0500, Stefan Berger wrote:

>    Also I am zeroing tpm_chip and vtpm_dev structures before the free.
>    Nothing bad happens in any combination of device opening / closing
>    tests I did.

That won't help detect use after free.

You won't be able to find this with open/close testing, a RPC has to
be done on /dev/tpmX at the right time, and even if there is some
tricky reason why cdev works, kapi doesn't have any protection.

Try this, lets make the user-after-free into a
null-pointer-deref. Much easier to spot.

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -305,6 +305,8 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 		sysfs_remove_link(&chip->pdev->kobj, "ppi");
 
 	tpm1_chip_unregister(chip);
+	chip->priv = NULL;
+	chip->ops = NULL;
 	tpm_dev_del_device(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_unregister);

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
