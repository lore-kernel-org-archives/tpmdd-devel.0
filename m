From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] tpm: add optional max xfer size
	check
Date: Wed, 20 Jul 2016 18:10:06 +0300
Message-ID: <20160720151006.GA7285@intel.com>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
	<cover.1468981325.git.apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1468981325.git.apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 19, 2016 at 07:34:18PM -0700, Andrey Pronin wrote:
> This patchset introduces an optional maximum transfer size that can
> be specified by a tpm driver. Setting the max_xfer_size helps to catch
> the cases when burstcnt is incorrectly reported by the device (e.g. >64
> for spi - happened in practice) and gracefully handle such situations.

Acknowledged but I won't review these before the second week of August.

I've been active for early this week to give the feedback for the queued
patch sets and make sure that we deliver a solid 4.8 release.

Back to the vacation...

/Jarkko

> v2: removed unnecessary accessors in tpm_tis_core.h, fixed style
> 
> Andrey Pronin (2):
>   tpm_tis_core: add optional max xfer size check
>   tpm_tis_spi: add max xfer size
> 
>  drivers/char/tpm/tpm_tis_core.c | 18 ++++++++++++++++--
>  drivers/char/tpm/tpm_tis_core.h |  1 +
>  drivers/char/tpm/tpm_tis_spi.c  |  1 +
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> -- 
> 2.6.6
> 

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
