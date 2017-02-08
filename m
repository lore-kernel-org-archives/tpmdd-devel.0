From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm xen: drop unneeded chip variable
Date: Wed, 8 Feb 2017 15:02:41 +0200
Message-ID: <20170208130241.lj7gixi7vhbkfqih@intel.com>
References: <1486330777-11341-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486330777-11341-1-git-send-email-Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Feb 05, 2017 at 10:39:37PM +0100, Julia Lawall wrote:
> The call that used chip was dropped in 1f0f30e404b3.  Drop the
> leftover declaration and initialization.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> 
> ---
>  drivers/char/tpm/xen-tpmfront.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
> index 5aaa268..656e8af 100644
> --- a/drivers/char/tpm/xen-tpmfront.c
> +++ b/drivers/char/tpm/xen-tpmfront.c
> @@ -289,7 +289,6 @@ static int tpmfront_probe(struct xenbus_device *dev,
>  		const struct xenbus_device_id *id)
>  {
>  	struct tpm_private *priv;
> -	struct tpm_chip *chip;
>  	int rv;
>  
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> @@ -306,7 +305,6 @@ static int tpmfront_probe(struct xenbus_device *dev,
>  
>  	rv = setup_ring(dev, priv);
>  	if (rv) {
> -		chip = dev_get_drvdata(&dev->dev);
>  		ring_free(priv);
>  		return rv;
>  	}
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
