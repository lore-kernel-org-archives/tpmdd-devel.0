From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] xen-tpmfront: correct return value check
 on xenbus_scanf()
Date: Thu, 7 Jul 2016 13:35:54 +0300
Message-ID: <20160707103554.GA13244@intel.com>
References: <577E291002000078000FBF18@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <577E291002000078000FBF18-rw/UEucdPrvD8XXLLHKrIiOjQekVJEpY@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Juergen Gross <JGross-IBi9RG/b67k@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 07, 2016 at 02:04:00AM -0600, Jan Beulich wrote:
> Only a positive return value indicates success.
> 
> Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/xen-tpmfront.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 4.7-rc6-xenbus_scanf.orig/drivers/char/tpm/xen-tpmfront.c
> +++ 4.7-rc6-xenbus_scanf/drivers/char/tpm/xen-tpmfront.c
> @@ -344,7 +344,7 @@ static void backend_changed(struct xenbu
>  			break;
>  
>  		if (xenbus_scanf(XBT_NIL, dev->otherend,
> -				"feature-protocol-v2", "%d", &val) < 0)
> +				"feature-protocol-v2", "%d", &val) <= 0)
>  			val = 0;
>  		if (!val) {
>  			xenbus_dev_fatal(dev, -EINVAL,
> 
> 
> 

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
