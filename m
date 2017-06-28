From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/2] tpm: use tpm2_pcr_read() in tpm2_do_selftest()
Date: Thu, 29 Jun 2017 01:19:35 +0300
Message-ID: <20170628221935.joqqxrohskhq3kj6@linux.intel.com>
References: <20170623134157.30399-1-roberto.sassu@huawei.com>
 <20170623134157.30399-3-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170623134157.30399-3-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jun 23, 2017 at 03:41:57PM +0200, Roberto Sassu wrote:
> tpm2_do_selftest() performs a PCR read during the TPM initialization phase.
> This patch replaces the PCR read code with a call to tpm2_pcr_read().
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm2-cmd.c | 31 +------------------------------
>  1 file changed, 1 insertion(+), 30 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index fdce77d..2d6ee0c 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -35,13 +35,6 @@ struct tpm2_self_test_in {
>  	u8	full_test;
>  } __packed;
>  
> -struct tpm2_pcr_read_in {
> -	__be32	pcr_selects_cnt;
> -	__be16	hash_alg;
> -	u8	pcr_select_size;
> -	u8	pcr_select[TPM2_PCR_SELECT_MIN];
> -} __packed;
> -
>  struct tpm2_get_tpm_pt_in {
>  	__be32	cap_id;
>  	__be32	property_id;
> @@ -68,7 +61,6 @@ struct tpm2_get_random_out {
>  union tpm2_cmd_params {
>  	struct	tpm2_startup_in		startup_in;
>  	struct	tpm2_self_test_in	selftest_in;
> -	struct	tpm2_pcr_read_in	pcrread_in;
>  	struct	tpm2_get_tpm_pt_in	get_tpm_pt_in;
>  	struct	tpm2_get_tpm_pt_out	get_tpm_pt_out;
>  	struct	tpm2_get_random_in	getrandom_in;
> @@ -215,16 +207,6 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
>  	TPM_UNDEFINED		/* 18f */
>  };
>  
> -#define TPM2_PCR_READ_IN_SIZE \
> -	(sizeof(struct tpm_input_header) + \
> -	 sizeof(struct tpm2_pcr_read_in))
> -
> -static const struct tpm_input_header tpm2_pcrread_header = {
> -	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> -	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
> -	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
> -};
> -
>  struct tpm2_pcr_read_out {
>  	__be32	update_cnt;
>  	__be32	pcr_selects_cnt;
> @@ -928,7 +910,6 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>  	unsigned int loops;
>  	unsigned int delay_msec = 100;
>  	unsigned long duration;
> -	struct tpm2_cmd cmd;
>  	int i;
>  
>  	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
> @@ -941,20 +922,10 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>  
>  	for (i = 0; i < loops; i++) {
>  		/* Attempt to read a PCR value */
> -		cmd.header.in = tpm2_pcrread_header;
> -		cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
> -		cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
> -		cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
> -		cmd.params.pcrread_in.pcr_select[0] = 0x01;
> -		cmd.params.pcrread_in.pcr_select[1] = 0x00;
> -		cmd.params.pcrread_in.pcr_select[2] = 0x00;
> -
> -		rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
> -				      NULL);
> +		rc = tpm2_pcr_read(chip, 0, NULL);
>  		if (rc < 0)
>  			break;
>  
> -		rc = be32_to_cpu(cmd.header.out.return_code);
>  		if (rc != TPM2_RC_TESTING)
>  			break;
>  
> -- 
> 2.9.3
> 
