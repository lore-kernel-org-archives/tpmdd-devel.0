From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] tpm: fix a sparse error in tpm-interface.c
Date: Tue, 31 Jan 2017 11:10:41 -0800
Message-ID: <1485889841.3199.57.camel@HansenPartnership.com>
References: <20170131180742.28460-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170131180742.28460-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-01-31 at 20:07 +0200, Jarkko Sakkinen wrote:
> drivers/char/tpm//tpm-interface.c:492:42: warning: bad assignment (
> -=)
> to restricted __be32
> 
> Fixes: 0883743825e3 ("TPM: sysfs functions consolidation")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm
> -interface.c
> index 423938e..746bc54 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -489,7 +489,7 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32
> subcap_id, cap_t *cap,
>  		tpm_cmd.params.getcap_in.cap =
> cpu_to_be32(subcap_id);
>  		/*subcap field not necessary */
>  		tpm_cmd.params.getcap_in.subcap_size =
> cpu_to_be32(0);
> -		tpm_cmd.header.in.length -=
> cpu_to_be32(sizeof(__be32));
> +		tpm_cmd.header.in.length = cpu_to_be32(18);

using bare numbers here without comment isn't really best practice. 
 What about setting header.in.length in both legs of the if() to either

tpm_cmd.header.in.length = cpu_to_be32(HEADER_SIZE + sizeof(struct tpm_getcap_params_in))

or 

/* setting subcap_size to zero allows us to elimnate the subcap field */
tpm_cmd.header.in.length = cpu_to_be32(HEADER_SIZE + sizeof(struct tpm_getcap_params_in) - sizeof(tpm_cmd.params.getcap_in.subcap))



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
