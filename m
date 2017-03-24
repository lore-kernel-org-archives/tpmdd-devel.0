From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4] tpm_crb: request and relinquish
	locality 0
Date: Fri, 24 Mar 2017 12:19:22 +0200
Message-ID: <20170324101922.mw7vzgesckp26wro@intel.com>
References: <20170324101032.13496-1-jarkko.sakkinen@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170324101032.13496-1-jarkko.sakkinen-X3B1VOXEql0@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-X3B1VOXEql0@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 24, 2017 at 12:10:30PM +0200, Jarkko Sakkinen wrote:
> This commit adds support for requesting and relinquishing locality 0 in
> tpm_crb for the course of command transmission.
> 
> In order to achieve this, two new callbacks are added to struct
> tpm_class_ops:
> 
> - request_locality
> - relinquish_locality
> 
> With CRB interface you first set either requestAccess or relinquish bit
> from TPM_LOC_CTRL_x register and then wait for locAssigned and
> tpmRegValidSts bits to be set in the TPM_LOC_STATE_x register.
> 
> The reason why were are doing this is to make sure that the driver
> will work properly with Intel TXT that uses locality 2. There's no
> explicit guarantee that it would relinquish this locality. In more
> general sense this commit enables tpm_crb to be a well behaving
> citizen in a multi locality environment.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
> v2:
> - TPM driver level calllbacks
> v3:
> - Call ops->relinquish_locality only if ops->request_locality has been
>   successful.
> - Do not reserve locality in nested tpm_transmit calls.
> - Check for tpmRegValidSts to make sure that the value in TPM_LOC_STATE_x is
>   stable.
> v4:
> - Removed tpm_tis_core changes. It needs to be done separately. It will be
>   postponed to 4.13.
> - Store locality to struct tpm_chip while active.
>  drivers/char/tpm/tpm-chip.c      |  1 +
>  drivers/char/tpm/tpm-interface.c | 13 +++++++++++++
>  drivers/char/tpm/tpm.h           |  3 +++
>  drivers/char/tpm/tpm_crb.c       | 41 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/tpm.h              |  3 ++-
>  5 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index aade699..a321bd5 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -231,6 +231,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  		goto out;
>  	}
>  
> +	chip->locality = -1;
>  	return chip;
>  
>  out:
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 95c6f98..1815666 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -384,6 +384,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>  	ssize_t len = 0;
>  	u32 count, ordinal;
>  	unsigned long stop;
> +	bool need_locality = chip->locality == -1;

This must be set *after* taking the mutex. Otherwise, I think this
should be fine now.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
