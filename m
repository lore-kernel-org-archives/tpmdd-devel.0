From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/2] tpm: use tpm_buf functions in tpm2_pcr_read()
Date: Thu, 29 Jun 2017 01:18:58 +0300
Message-ID: <20170628221858.65mybzp6tyzh27g7@linux.intel.com>
References: <20170623134157.30399-1-roberto.sassu@huawei.com>
 <20170623134157.30399-2-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170623134157.30399-2-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jun 23, 2017 at 03:41:56PM +0200, Roberto Sassu wrote:
> tpm2_pcr_read() now builds the PCR read command buffer with tpm_buf
> functions. This solution is preferred to using a tpm2_cmd structure,
> as tpm_buf functions provide protection against buffer overflow.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

> ---
>  drivers/char/tpm/tpm2-cmd.c | 60 ++++++++++++++++++++++-----------------------
>  1 file changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 3a99643..fdce77d 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -42,17 +42,6 @@ struct tpm2_pcr_read_in {
>  	u8	pcr_select[TPM2_PCR_SELECT_MIN];
>  } __packed;
>  
> -struct tpm2_pcr_read_out {
> -	__be32	update_cnt;
> -	__be32	pcr_selects_cnt;
> -	__be16	hash_alg;
> -	u8	pcr_select_size;
> -	u8	pcr_select[TPM2_PCR_SELECT_MIN];
> -	__be32	digests_cnt;
> -	__be16	digest_size;
> -	u8	digest[TPM_DIGEST_SIZE];
> -} __packed;
> -
>  struct tpm2_get_tpm_pt_in {
>  	__be32	cap_id;
>  	__be32	property_id;
> @@ -80,7 +69,6 @@ union tpm2_cmd_params {
>  	struct	tpm2_startup_in		startup_in;
>  	struct	tpm2_self_test_in	selftest_in;
>  	struct	tpm2_pcr_read_in	pcrread_in;
> -	struct	tpm2_pcr_read_out	pcrread_out;
>  	struct	tpm2_get_tpm_pt_in	get_tpm_pt_in;
>  	struct	tpm2_get_tpm_pt_out	get_tpm_pt_out;
>  	struct	tpm2_get_random_in	getrandom_in;
> @@ -231,15 +219,23 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
>  	(sizeof(struct tpm_input_header) + \
>  	 sizeof(struct tpm2_pcr_read_in))
>  
> -#define TPM2_PCR_READ_RESP_BODY_SIZE \
> -	 sizeof(struct tpm2_pcr_read_out)
> -
>  static const struct tpm_input_header tpm2_pcrread_header = {
>  	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
>  	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
>  	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
>  };
>  
> +struct tpm2_pcr_read_out {
> +	__be32	update_cnt;
> +	__be32	pcr_selects_cnt;
> +	__be16	hash_alg;
> +	u8	pcr_select_size;
> +	u8	pcr_select[TPM2_PCR_SELECT_MIN];
> +	__be32	digests_cnt;
> +	__be16	digest_size;
> +	u8	digest[];
> +} __packed;
> +
>  /**
>   * tpm2_pcr_read() - read a PCR value
>   * @chip:	TPM chip to use.
> @@ -251,29 +247,33 @@ static const struct tpm_input_header tpm2_pcrread_header = {
>  int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  {
>  	int rc;
> -	struct tpm2_cmd cmd;
> -	u8 *buf;
> +	struct tpm_buf buf;
> +	struct tpm2_pcr_read_out *out;
> +	u8 pcr_select[TPM2_PCR_SELECT_MIN] = {0};
>  
>  	if (pcr_idx >= TPM2_PLATFORM_PCR)
>  		return -EINVAL;
>  
> -	cmd.header.in = tpm2_pcrread_header;
> -	cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
> -	cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
> -	cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
> +	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_PCR_READ);
> +	if (rc)
> +		return rc;
>  
> -	memset(cmd.params.pcrread_in.pcr_select, 0,
> -	       sizeof(cmd.params.pcrread_in.pcr_select));
> -	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
> +	pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
>  
> -	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
> -			      TPM2_PCR_READ_RESP_BODY_SIZE,
> -			      0, "attempting to read a pcr value");
> -	if (rc == 0) {
> -		buf = cmd.params.pcrread_out.digest;
> -		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
> +	tpm_buf_append_u32(&buf, 1);
> +	tpm_buf_append_u16(&buf, TPM2_ALG_SHA1);
> +	tpm_buf_append_u8(&buf, TPM2_PCR_SELECT_MIN);
> +	tpm_buf_append(&buf, (const unsigned char *)pcr_select,
> +		       sizeof(pcr_select));
> +
> +	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, 0,
> +			res_buf ? "attempting to read a pcr value" : NULL);
> +	if (rc == 0 && res_buf) {
> +		out = (struct tpm2_pcr_read_out *)&buf.data[TPM_HEADER_SIZE];
> +		memcpy(res_buf, out->digest, SHA1_DIGEST_SIZE);
>  	}
>  
> +	tpm_buf_destroy(&buf);
>  	return rc;
>  }
>  
> -- 
> 2.9.3
> 
