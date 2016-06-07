From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 3/4] tpm: Allow TPM chip drivers to
 override reported command durations
Date: Tue, 7 Jun 2016 11:32:35 -0600
Message-ID: <20160607173235.GA4486@obsidianresearch.com>
References: <1465270649-22498-1-git-send-email-eswierk@skyportsystems.com>
	<1465270649-22498-4-git-send-email-eswierk@skyportsystems.com>
	<20160607141526.GG3855@intel.com>
	<CAO_EM_k5pqxqZ2fFzDBhPK_WoZ_nj3qE18EKROUKvp3KxnK__Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAO_EM_k5pqxqZ2fFzDBhPK_WoZ_nj3qE18EKROUKvp3KxnK__Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jun 07, 2016 at 07:25:24AM -0700, Ed Swierk wrote:
> I followed the example of the existing update_timeouts callback, which
> is also used only by tpm_tis.

The callback is because only TIS has the did_vid stuff which is needed
to key the adjustment. Other interfaces do not have that information.

This was an ugly historical mistake:

> >> -     /* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
> >> -      * value wrong and apparently reports msecs rather than usecs. So we
> >> -      * fix up the resulting too-small TPM_SHORT value to make things work.
> >> -      * We also scale the TPM_MEDIUM and -_LONG values by 1000.
> >> -      */
> >> -     if (chip->vendor.duration[TPM_SHORT] < (HZ / 100)) {
> >> -             chip->vendor.duration[TPM_SHORT] = HZ;
> >> -             chip->vendor.duration[TPM_MEDIUM] *= 1000;
> >> -             chip->vendor.duration[TPM_LONG] *= 1000;
> >> -             chip->vendor.duration_adjusted = true;

It should have been did/vid key'd as well, not heuristic.

Can the existing update_timeouts be broadened to do both adjustments,
or do they really need to be at different times?

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
