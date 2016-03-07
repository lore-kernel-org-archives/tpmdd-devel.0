From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ioctl API for vTPM driver
Date: Mon, 7 Mar 2016 14:34:53 -0700
Message-ID: <20160307213453.GA4630@obsidianresearch.com>
References: <20160306120537.GA22702@intel.com>
	<20160306121103.GA23480@intel.com>
	<20160306122816.GA24077@intel.com>
	<201603070040.u270eq7U019952@d01av03.pok.ibm.com>
	<20160307203206.GA4303@obsidianresearch.com>
	<201603072115.u27LFcMK001519@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201603072115.u27LFcMK001519-4ZtxiNBBw+3ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Mon, Mar 07, 2016 at 04:12:45PM -0500, Stefan Berger wrote:
>    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 03/07/2016
>    03:32:06 PM:
>    >
>    > On Sun, Mar 06, 2016 at 07:40:40PM -0500, Stefan Berger wrote:
>    >
>    > >    If you have suggestions or comments, let me know.
>    > >    I adjusted the code to reflect the ENOSYS (previously EINVAL) in
>    case
>    > >    of unsupported flags or unsupported ioctls.
>    >
>    > Please don't use ENOSYS, the desire is that is only used by
>    > systemcalls.

>    Ok, found alternatives: ENOTSUPP for the flag ENOIOCTLCMD for the
>    unsupported ioctl ?

ENOIOCTLCMD might be OK, just make sure it gets converted to ENOTTY:

390  * Is it an unrecognized ioctl? The correct returns are either
391  * ENOTTY (final) or ENOIOCTLCMD ("I don't know this one, try a
392  * fallback"). ENOIOCTLCMD gets turned into ENOTTY by the ioctl
393  * code before returning.

ENOTSUPP is for NFS internal use only, can't be exported to user
space.

Try EOPNOTSUPP

Jason

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://makebettercode.com/inteldaal-eval
