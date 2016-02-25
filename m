From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 09/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Thu, 25 Feb 2016 15:17:32 +0200
Message-ID: <20160225131732.GA20860@intel.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-10-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222192741.GI22088@obsidianresearch.com>
	<201602230142.u1N1gSuF029481@d01av05.pok.ibm.com>
	<20160223021730.GD26177@obsidianresearch.com>
	<201602242306.u1ON6qGP030251@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602242306.u1ON6qGP030251-8DuMPbUlb4HImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Wed, Feb 24, 2016 at 06:10:42PM -0500, Stefan Berger wrote:
>    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016
>    09:17:30 PM:
> 
>    >
>    > On Mon, Feb 22, 2016 at 08:45:51PM -0500, Stefan Berger wrote:
>    >
>    > > Two things:
>    > > - the ioctl takes flags; should we return an error on flags that are
>    not
>    > > supported but set by userspace?
>    >
>    > Typically yes. Otherwise you cannot introduce new flags in
>    > future.
>    >
>    > > - the sysfs works but I wished we could give some control over
>    > whether it shows
>    > > any entries. Can we have a flag in the ioctl on whether to show
>    > these files in
>    > > sysfs?
>    >
>    > That is something to address in the future namespace patch series I
>    > expect you'll prepare..
> 
>    It may be a while until we get there ... nevertheless it may be worth some
>    thought already.
> 
>    So we have at least two choices for how to avoid data leakage via sysfs;
>    the problem is that sysfs shows all vtpm devices in all containers; the
>    good thing is that at least Docker (other mgmt. stacks probably also)
>    mount sysfs read-only into 'normal' containers, so that writing (even only
>    to cancel) isn't typically possible.
> 
>    1) allow user space to set a flag whether the sysfs entries are to be
>    registered; a typical container mgmt. stack would set the flag to avoid
>    data leakage between containers; no vtpm device with that flag set would
>    show anything via sysfs
> 
>    2) we know in which (user) namespace a /dev/tpm%d device is moved into
>    following an ioctl on the device where a process's PID is a parameter; we
>    could associate the process's (user) namespace with the chip and compare
>    the current_user_ns() with chip->user_ns and return an empty string if
>    they don't match; here the vtpm device owned by a particular (user)
>    namespace would then also show data in sysfs entries if accessed from the
>    right namespace; which sysfs entry to look at could be inferred from the
>    minor number on /dev/tpm0 inside the container

3) Do not show any existing sysfs attributes for containers. All but
   'ppi' are nonsense anyway or is there something that you couldn't read
   from /dev/tpm0? TPM 1.x user space tools could implement them by
   using the character device. It is not backwards compatibility break
   technically because existing code does not yet support vTPMs.

>       Stefan

How would you address measurement logs?

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
