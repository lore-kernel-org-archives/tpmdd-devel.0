From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 0/3] tpm/tpm_crb: implement power
	management.
Date: Wed, 7 Sep 2016 18:19:53 +0300
Message-ID: <20160907151953.GA10254@intel.com>
References: <1473247953-24617-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473247953-24617-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 07, 2016 at 02:32:30PM +0300, Tomas Winkler wrote:
> The overall platform ability to enter a low power state is also
> conditioned on the ability of a tpm device to go to idle state.
> This series should provide this feature. 
> 
> Unfortunately, there is a HW bug on Intel PTT devices on Skylake,
> Kabylake, and Broxton devices, where certain registers lost retention
> during TPM idle state. Hence this implementation takes this into
> consideration and implement the feature based only on access to
> registers that retain their state. This still conforms to the spec
> and should be correct also on non Intle devices.
> 
> This path series should be applied on top of the series:
> 'Small fixes and cleanups for tpm_crb'

Thanks Tomas. I'll head on to testing tomorrow.

> Tomas Winkler (3):
>   tpm/tpm_crb: implement tpm crb idle state
>   tmp/tpm_crb: fix Intel PTT hw bug during idle state
>   tpm/tpm_crb: cache cmd_size register value.
> 
>  drivers/char/tpm/tpm-interface.c |  21 +++++++
>  drivers/char/tpm/tpm_crb.c       | 124 ++++++++++++++++++++++++++++++++++-----
>  include/linux/tpm.h              |   3 +-
>  3 files changed, 132 insertions(+), 16 deletions(-)
> 
> -- 
> 2.7.4

/Jarkko

------------------------------------------------------------------------------
