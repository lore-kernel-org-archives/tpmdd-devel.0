From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/2] tpm/tpm-interface: place kdoc just above
 tpm_pcr_extend
Date: Wed, 2 Nov 2016 04:02:20 -0600
Message-ID: <20161102100220.v2nlbf767sticcp7@intel.com>
References: <1477962314-26763-1-git-send-email-tomas.winkler@intel.com>
 <1477962314-26763-2-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477962314-26763-2-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 01, 2016 at 03:05:13AM +0200, Tomas Winkler wrote:
> Place kdoc just above tpm_pcr_extend so it can be parsed
> correctly.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index cb0e57ee053d..d496a6b26a45 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -731,6 +731,14 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
>  }
>  EXPORT_SYMBOL_GPL(tpm_pcr_read);
>  
> +#define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
> +#define EXTEND_PCR_RESULT_SIZE 34
> +static const struct tpm_input_header pcrextend_header = {
> +	.tag = TPM_TAG_RQU_COMMAND,
> +	.length = cpu_to_be32(34),
> +	.ordinal = TPM_ORD_PCR_EXTEND
> +};
> +
>  /**
>   * tpm_pcr_extend - extend pcr value with hash
>   * @chip_num:	tpm idx # or AN&
> @@ -741,14 +749,6 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
>   * isn't, protect against the chip disappearing, by incrementing
>   * the module usage count.
>   */
> -#define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
> -#define EXTEND_PCR_RESULT_SIZE 34
> -static const struct tpm_input_header pcrextend_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> -	.length = cpu_to_be32(34),
> -	.ordinal = TPM_ORD_PCR_EXTEND
> -};
> -
>  int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  {
>  	struct tpm_cmd_t cmd;
> -- 
> 2.7.4
> 
