From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/7] tpm/tpm_atmel: drop remaining
	'iobase' usage
Date: Tue, 29 Mar 2016 17:08:14 +0300
Message-ID: <20160329140814.GA12764@intel.com>
References: <1458975615-8095-1-git-send-email-christophe-h.ricard@st.com>
	<1458975615-8095-2-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458975615-8095-2-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Mar 26, 2016 at 08:00:09AM +0100, Christophe Ricard wrote:
> Remove some sporadic iobase

This description of this commit is total crap to be honest (saying
this with a polite tone but that's how it is). For me the commit meessage
is the most important part of the commit and the sentence above contains
exactly zero amount of information.

A proper commit message would have stated that this fixes the PPC64
builds that your earlier patch breaks. Have you tested that PPC64 builds
work now?

Actually what you should have *really* done would have updated your
older patch and put a remark into change log in the cover letter.

/Jarkko

> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_atmel.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel.h
> index c5618ea..7e37c16 100644
> --- a/drivers/char/tpm/tpm_atmel.h
> +++ b/drivers/char/tpm/tpm_atmel.h
> @@ -38,8 +38,8 @@ static inline struct tpm_atmel_priv *atmel_get_priv(struct tpm_chip *chip)
>  
>  #include <asm/prom.h>
>  
> -#define atmel_getb(chip, offset) readb(chip->vendor->iobase + offset);
> -#define atmel_putb(val, chip, offset) writeb(val, chip->vendor->iobase + offset)
> +#define atmel_getb(priv, offset) readb(priv->iobase + offset);
> +#define atmel_putb(val, priv, offset) writeb(val, priv->iobase + offset)
>  #define atmel_request_region request_mem_region
>  #define atmel_release_region release_mem_region
>  
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
