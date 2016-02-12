From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 11:40:51 -0700
Message-ID: <20160212184051.GB4289@obsidianresearch.com>
References: <20160211070426.GB9307@intel.com>
	<201602111534.u1BFYvRs019573@d01av03.pok.ibm.com>
	<20160211181208.GA6285@obsidianresearch.com>
	<201602111911.u1BJB2nK017410@d01av03.pok.ibm.com>
	<20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120353.u1C3rYif023135@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602120353.u1C3rYif023135-8DuMPbUlb4HImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Thu, Feb 11, 2016 at 10:56:47PM -0500, Stefan Berger wrote:
>    Updated the branch. Are you going to upstream your patch? Otherwise I
>    would just add your Signed-off-by to it if that's ok ?

Yes, sorry about that. Just add it to your series with your
tested-by/reviewed-by. It will need some rebasing to go on top of
Jarkko's final patch that adds the devm_ (just delete it from
tpm_alloc and use my version for tpmm_alloc)

The other thing that has come to my mind is device removal. Right now
the tpm core is still fairly broken in that regard, and we have
largely got away with ignoring that because drviers are rarely
removed.

However, you are adding something that actually requires removal to
work and be race free, so we'll also have to fix core removal :(

The basic approach I'd suggest would be the same as what the rtc
subsystem does.

Add a mutex around 'chip->ops' and every place that
uses ops has to hold the lock.

Upon removal grab the mutex and null ops.

Every place that graps the lock for ops has to check for null. Null
means the device is being destroyed and the call must fail.

Make changes to tpm_chip_find_get to check for null, and make it do
put_device. Reconsider the use of module locking there, not sure it
makes any sense to do that if we have proper safe removal support.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
