From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: return -ENODEV if np is not set
Date: Tue, 15 Nov 2016 09:33:53 -0800
Message-ID: <20161115173353.cnslmlqvwsp73wt3@intel.com>
References: <20161115132722.6963-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161115132722.6963-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 15, 2016 at 01:27:22PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> device_node np contains a garbage value from the stack and it
> is only set if chip->dev.parent->of_node is not null.  Thus the
> check for a null np won't spot a garbage value of np from the
> stack if chip->dev.parent->of_node is null and if np contains
> an garbage non-null value.
> 
> I believe the correct fix is to return -ENODEV if and only if
> chip->dev.parent->of_node is null.
> 
> Found with static analysis by CoverityScan, CID 1377755
> 
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm_of.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
> index 3af829f..1426590 100644
> --- a/drivers/char/tpm/tpm_of.c
> +++ b/drivers/char/tpm/tpm_of.c
> @@ -31,7 +31,7 @@ int read_log_of(struct tpm_chip *chip)
>  	log = &chip->log;
>  	if (chip->dev.parent->of_node)
>  		np = chip->dev.parent->of_node;
> -	if (!np)
> +	else
>  		return -ENODEV;
>  
>  	sizep = of_get_property(np, "linux,sml-size", NULL);
> -- 
> 2.10.2
> 

------------------------------------------------------------------------------
