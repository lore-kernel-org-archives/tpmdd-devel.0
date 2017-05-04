From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 3/3] tpm: move TPM 1.2 code of tpm_pcr_extend() to
 tpm1_pcr_extend()
Date: Thu, 4 May 2017 13:07:52 +0300
Message-ID: <20170504100752.2gzzwgzxvy6lsgk5@intel.com>
References: <20170503161911.17606-1-roberto.sassu@huawei.com>
 <20170503161911.17606-4-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170503161911.17606-4-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 03, 2017 at 06:19:11PM +0200, Roberto Sassu wrote:
> In preparation of the modifications to tpm_pcr_extend(), which will
> allow callers to supply a digest for each PCR bank of a TPM 2.0,
> the TPM 1.2 specific code has been moved to tpm1_pcr_extend().
> 
> tpm1_pcr_extend() uses tpm_buf_init() to prepare the command buffer,
> which offers protection against buffer overflow. It is called by
> tpm_pcr_extend() and tpm_pm_suspend().
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Please rebase this to the latest tree. It does not apply cleanly.
No need to send two other patches.

Use --subject-prefix="PATCH v2, RESEND" as tag.

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 41 +++++++++++++++++++++++-----------------
>  1 file changed, 24 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index a8351dd..0277b99 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -774,6 +774,25 @@ static const struct tpm_input_header pcrextend_header = {
>  	.ordinal = cpu_to_be32(TPM_ORD_PCR_EXTEND)
>  };
>  
> +static int tpm1_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash,
> +			   char *log_msg)
> +{
> +	struct tpm_buf buf;
> +	int rc;
> +
> +	rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND, TPM_ORD_PCR_EXTEND);
> +	if (rc)
> +		return rc;
> +
> +	tpm_buf_append_u32(&buf, pcr_idx);
> +	tpm_buf_append(&buf, hash, TPM_DIGEST_SIZE);
> +
> +	rc = tpm_transmit_cmd(chip, buf.data, EXTEND_PCR_RESULT_SIZE,
> +			      EXTEND_PCR_RESULT_BODY_SIZE, 0, log_msg);
> +	tpm_buf_destroy(&buf);
> +	return rc;
> +}
> +
>  /**
>   * tpm_pcr_extend - extend pcr value with hash
>   * @chip_num:	tpm idx # or AN&
> @@ -786,7 +805,6 @@ static const struct tpm_input_header pcrextend_header = {
>   */
>  int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  {
> -	struct tpm_cmd_t cmd;
>  	int rc;
>  	struct tpm_chip *chip;
>  	struct tpm2_digest digest_list[ARRAY_SIZE(chip->active_banks)];
> @@ -812,13 +830,8 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  		return rc;
>  	}
>  
> -	cmd.header.in = pcrextend_header;
> -	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
> -	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
> -	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
> -			      EXTEND_PCR_RESULT_BODY_SIZE, 0,
> -			      "attempting extend a PCR value");
> -
> +	rc = tpm1_pcr_extend(chip, pcr_idx, hash,
> +			     "attempting extend a PCR value");
>  	tpm_put_ops(chip);
>  	return rc;
>  }
> @@ -1017,15 +1030,9 @@ int tpm_pm_suspend(struct device *dev)
>  	}
>  
>  	/* for buggy tpm, flush pcrs with extend to selected dummy */
> -	if (tpm_suspend_pcr) {
> -		cmd.header.in = pcrextend_header;
> -		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
> -		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
> -		       TPM_DIGEST_SIZE);
> -		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
> -				     EXTEND_PCR_RESULT_BODY_SIZE, 0,
> -				      "extending dummy pcr before suspend");
> -	}
> +	if (tpm_suspend_pcr)
> +		rc = tpm1_pcr_extend(chip, tpm_suspend_pcr, dummy_hash,
> +				     "extending dummy pcr before suspend");
>  
>  	/* now do the actual savestate */
>  	for (try = 0; try < TPM_RETRY; try++) {
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
