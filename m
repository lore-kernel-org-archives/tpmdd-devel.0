From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 06/11] tpm: Replace device
	number	bitmap with IDR
Date: Thu, 10 Mar 2016 18:40:21 +0200
Message-ID: <20160310164021.GB4863@intel.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1457545170-30120-7-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160310132156.GA16320@intel.com>
	<201603101622.u2AGMCv3031274@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201603101622.u2AGMCv3031274-8DuMPbUlb4HImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Thu, Mar 10, 2016 at 11:26:38AM -0500, Stefan Berger wrote:
>    Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/10/2016
>    08:21:56 AM:
> 
>    > From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>    > To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>    > Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>    > Date: 03/10/2016 08:22 AM
>    > Subject: Re: [tpmdd-devel] [PATCH v6 06/11] tpm: Replace device
>    > number bitmap with IDR
>    >
>    > Hi Stefan
>    >
>    > On Wed, Mar 09, 2016 at 12:39:25PM -0500, Stefan Berger wrote:
>    > > Replace the device number bitmap with IDR. Extend the number of
>    devices we
>    > > can create to 64k.
>    > > Since an IDR allows us to associate a pointer with an ID, we use this
>    now
>    > > to rewrite tpm_chip_find_get() to simply look up the chip pointer by
>    the
>    > > given device ID.
>    > >
>    > > Protect the IDR calls with a mutex.
>    >
>    > Could you make a separate patch set of first six patches and CC them to
>    > linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org and linux-security-module-u79uwXL29TaiAVqoAR/hOA@public.gmane.org
> 
>    I'd rather post v7 of the whole series so that we don't have too many
>    different series flying around. I can add a comment into the cover letter
>    to request particular care for patches 1 to 6 or 7?

Makes sense! It doesn't prevent me merging the 'head' of the series :)

>       Stefan

/Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
