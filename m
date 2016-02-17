From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Tue, 16 Feb 2016 21:47:50 -0700
Message-ID: <20160217044750.GB25049@obsidianresearch.com>
References: <20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120356.u1C3usEe002034@d03av04.boulder.ibm.com>
	<201602121813.u1CIDu4O015272@d01av01.pok.ibm.com>
	<20160212183415.GA4289@obsidianresearch.com>
	<201602140637.u1E6baNX028563@d03av04.boulder.ibm.com>
	<201602161648.u1GGmdZv000468@d01av03.pok.ibm.com>
	<20160216180028.GA4967@obsidianresearch.com>
	<201602161927.u1GJRJL6016216@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602161927.u1GJRJL6016216-4ZtxiNBBw+3ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Tue, Feb 16, 2016 at 02:26:56PM -0500, Stefan Berger wrote:
> The re-ordering of the tpm_chip and vtpm_dev release actually solved that
> problem.

? You mean you don't see the lock up because there is no error unwind?

> [My feeling is, something outside of the vtpm driver doesn't unroll properly
> and locks up if there's lots of concurrency].

Hum, I'd be surprised if this is not caused by something outside tpm/vtpm..
It would be very nice to know, but perhaps not essential. I didn't see
anything obvious in vtpm either.

> > One other thing you can look at is ditching the vtpm struct
> > device. With the last patches I sent the tpm core would only need two
> > more lines to work with a null parent device, which would be even
> > simpler for vtpm.
> 
> Not having a parent device isn't really necessary, except for not having it
> appear in sysfs maybe?

Dropping the dummy parent out of vtpm makes it work a little more more
like the rest of the virtual stuff and slightly changes the sysfs
paths visble to user space. If this is the right way to go it would be
great to do that at the start. It wasn't worth bringing up before, but
now that I wrote the parent removal patch it is pretty trivial.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
