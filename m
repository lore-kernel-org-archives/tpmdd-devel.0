From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_crb: check for bad response size
Date: Sat, 11 Mar 2017 10:48:06 +0200
Message-ID: <20170311084806.dkl6w3gjuwawlau4@intel.com>
References: <20170311004604.4442-1-jsnitsel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170311004604.4442-1-jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 10, 2017 at 05:46:04PM -0700, Jerry Snitselaar wrote:
> Make sure size of response buffer is at least 6 bytes, or
> we will underflow and pass large size_t to memcpy_fromio().
> This was encountered while testing earlier version of
> locality patchset.
> 
> Fixes: 30fc8d138e912 ("tpm: TPM 2.0 CRB Interface")
> Signed-off-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm_crb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 89dc8a176ff1..cda4f312d1c9 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -236,7 +236,7 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  	memcpy_fromio(buf, priv->rsp, 6);
>  	expected = be32_to_cpup((__be32 *) &buf[2]);
> -	if (expected > count)
> +	if (expected > count || expected < 6)
>  		return -EIO;
>  
>  	memcpy_fromio(&buf[6], &priv->rsp[6], expected - 6);
> -- 
> 2.11.0.258.ge05806da9
> 

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
