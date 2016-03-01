From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 04/10] tpm: Get rid of module locking
Date: Tue, 1 Mar 2016 07:18:54 +0200
Message-ID: <20160301051854.GA6456@intel.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1456766996-9300-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229203550.GB26296@intel.com>
	<201602292050.u1TKo2CC012799@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602292050.u1TKo2CC012799-4ZtxiNBBw+3ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Mon, Feb 29, 2016 at 03:49:55PM -0500, Stefan Berger wrote:
>    Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/29/2016
>    03:35:50 PM:
> 
>    > On Mon, Feb 29, 2016 at 12:29:50PM -0500, Stefan Berger wrote:
>    > > Now that the tpm core has strong locking around 'ops' it is possible
>    > > to remove a TPM driver, module and all, even while user space still
>    > > has things like /dev/tpmX open. For consistency and simplicity, drop
>    > > the module locking entirely.
>    >
>    > I don't understand why the user visible behavior of /dev/tpmX should
>    > be changed if there are no life and death reasons to do it. Do you
>    > think that this patch is absolutely crucial for the feature
>    > implemented?
> 
>    This changes the module counter on the hardware / backend driver and not
>    other user visible behavior from what I can tell. It's certainly/hopefully
>    not a life-and-death thing, though I am wondering whether it's be applied
>    sooner or later anyway for cleanup reasons following the preceding patch
>    providing 'strong locking'.

OK, I just your and Jasons reply and will head soon to apply the series
to my master branch (being there still give space to move with locking
if needed).

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
