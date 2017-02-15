From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: Fix expected number of response bytes of TPM1.2 PCR
 Extend
Date: Wed, 15 Feb 2017 20:09:03 +0200
Message-ID: <20170215180903.3simazptqnlhbqi6@intel.com>
References: <1487177783-15687-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487177783-15687-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, james.l.morris@oracle.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 15, 2017 at 11:56:23AM -0500, Stefan Berger wrote:
> The TPM1.2 PCR Extend operation only returns 20 bytes in the body,
> which is the size of the PCR state.
> 
> This fixes a problem where IMA gets errors with every PCR Extend.
> 
> Fixes: c659af78eb7b ("tpm: Check size of response before accessing data")
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> Acked-by: Mimi Zohar <zohar@us.ibm.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 6e368ee..bd2128e 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -767,7 +767,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
>  
>  #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
>  #define EXTEND_PCR_RESULT_SIZE 34
> -#define EXTEND_PCR_RESULT_BODY_SIZE 24
> +#define EXTEND_PCR_RESULT_BODY_SIZE 20
>  static const struct tpm_input_header pcrextend_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(34),
> -- 
> 2.4.3
> 
