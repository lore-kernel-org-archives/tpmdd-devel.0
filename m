From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm,
	tpm_infineon: remove useless snprintf() calls
Date: Wed, 24 May 2017 14:52:59 -0700
Message-ID: <20170524215259.xkaqrnhcb44jpyd5@intel.com>
References: <20170524212916.9106-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170524212916.9106-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 24, 2017 at 02:29:16PM -0700, Jarkko Sakkinen wrote:
> The memory copy from rodata to stack is useless.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

I already applied this, reviewed-by would be nice for this one but given
how obvious this change is, it is not mandatory. I take my chances on
this one as a maitainer.

/Jarkko

> ---
>  drivers/char/tpm/tpm_infineon.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
> index e3cf9f3545c5..3b1b9f9322d5 100644
> --- a/drivers/char/tpm/tpm_infineon.c
> +++ b/drivers/char/tpm/tpm_infineon.c
> @@ -397,7 +397,7 @@ static int tpm_inf_pnp_probe(struct pnp_dev *dev,
>  	int vendorid[2];
>  	int version[2];
>  	int productid[2];
> -	char chipname[20];
> +	const char *chipname;
>  	struct tpm_chip *chip;
>  
>  	/* read IO-ports through PnP */
> @@ -488,13 +488,13 @@ static int tpm_inf_pnp_probe(struct pnp_dev *dev,
>  
>  	switch ((productid[0] << 8) | productid[1]) {
>  	case 6:
> -		snprintf(chipname, sizeof(chipname), " (SLD 9630 TT 1.1)");
> +		chipname = " (SLD 9630 TT 1.1)";
>  		break;
>  	case 11:
> -		snprintf(chipname, sizeof(chipname), " (SLB 9635 TT 1.2)");
> +		chipname = " (SLB 9635 TT 1.2)";
>  		break;
>  	default:
> -		snprintf(chipname, sizeof(chipname), " (unknown chip)");
> +		chipname = " (unknown chip)";
>  		break;
>  	}
>  
> -- 
> 2.11.0
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
