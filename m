From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/4] tpm: kdoc cleanup
Date: Thu, 24 Nov 2016 15:19:17 +0200
Message-ID: <20161124131917.rjg7nsz6j4xqkssc@intel.com>
References: <1479895454-15076-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479895454-15076-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 23, 2016 at 12:04:10PM +0200, Tomas Winkler wrote:
> Cleanup tpm in-code documentation.
> 
> Tomas Winkler (4):
>   tpm: add kdoc for tpm_transmit and tpm_transmit_cmd
>   tpm/tpm2-chip: fix kdoc errors
>   tmp: use pdev for parent device in tpm_chip_alloc
>   tpm/vtpm: fix kdoc warnings

Sorry I my previous comments were meant to this series. I looked them up
from patchwork and replied to wrong series

> 
>  drivers/char/tpm/tpm-chip.c       |   8 +--
>  drivers/char/tpm/tpm-interface.c  |  33 ++++++++++--
>  drivers/char/tpm/tpm2-cmd.c       | 105 +++++++++++++++++++++-----------------
>  drivers/char/tpm/tpm_ibmvtpm.c    |  51 +++++++++---------
>  drivers/char/tpm/tpm_vtpm_proxy.c |  48 ++++++++++++-----
>  5 files changed, 150 insertions(+), 95 deletions(-)
> 
> -- 
> 2.7.4
> 

/Jarkko

------------------------------------------------------------------------------
