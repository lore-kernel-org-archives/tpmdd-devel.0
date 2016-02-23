From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 09/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Tue, 23 Feb 2016 20:36:15 +0200
Message-ID: <20160223183615.GA4409@intel.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-10-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160223102211.GA9474@intel.com>
	<201602231210.u1NCAD6D017196@d01av03.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602231210.u1NCAD6D017196-CUdSWdNILC7ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 23, 2016 at 07:09:44AM -0500, Stefan Berger wrote:
>    Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/23/2016
>    05:22:11 AM:
>
>    > > +struct vtpm_dev {
>    > > +   struct tpm_chip *chip;
>    > > +
>    > > +   u32 flags;                   /* public API flags */
>    > > +
>    > > +   long state;
>    > > +#define STATE_OPENED_BIT        0
>    > > +#define STATE_WAIT_RESPONSE_BIT 1    /* waiting for emulator to
>    > give response */
>    >
>    > I'd prefer something like this before declaring the struct:
>    >
>    > enum vtpm_dev_states {
>    >    VTPM_DEV_OPENED         = BIT(0),
>    >    VTPM_DEV_WAITING_FOR_RESPONSE   = BIT(1),
>    > };
>    >
>    > This whole use of set/clear_bit macros when you don't have variable
>    > number of bits just makes code less transparent.
> 
>    Though read-modify-writes with the bit ops are atomic and need no spinlock
>    protection to avoid concurrency mess. Now we would need a spinlock for
>    such ops.

Sounds messy. You should refer to flags inside buf_lock like you
otherwise do.

>    I'll let Jason respond to it whether it's the difference between spinlock
>    and mutex or just no locking at all. If no locking, I'd be inclined to
>    work with two buffers, one for requests and one for responses.

You have to switch to mutex because copy_to_user and copy_from_user can
sleep. How would you handle mutual exclusion without any locking (two
concurrent read calls)?

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
