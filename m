From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ioctl API for vTPM driver
Date: Mon, 7 Mar 2016 15:40:58 -0700
Message-ID: <20160307224058.GA7738@obsidianresearch.com>
References: <20160306120537.GA22702@intel.com>
	<20160306121103.GA23480@intel.com>
	<20160306122816.GA24077@intel.com>
	<201603070040.u270eq7U019952@d01av03.pok.ibm.com>
	<20160307203206.GA4303@obsidianresearch.com>
	<201603072115.u27LFcMK001519@d01av01.pok.ibm.com>
	<20160307213453.GA4630@obsidianresearch.com>
	<201603072224.u27MOBJO007812@d01av02.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201603072224.u27MOBJO007812-prK0F/7GlgzImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Mon, Mar 07, 2016 at 05:24:03PM -0500, Stefan Berger wrote:

>    It's found in more then 300 files using that errno...
>    [1]http://lxr.free-electrons.com/ident?i=ENOTSUPP

No idea if those leak to user space or not, but ENOTSUPP is not
exposed to user space:

grep -r 524 /usr/include/bits*

So there is nothing a user space app can do with it.

Jason

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://makebettercode.com/inteldaal-eval
