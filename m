From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix byte order related arithmetic inconsistency in
 tpm_getcap()
Date: Tue, 9 May 2017 17:13:53 +0300
Message-ID: <20170509141353.klo7lilef4qiqfoc@intel.com>
References: <20170507175002.9558-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170507175002.9558-1-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, May 07, 2017 at 08:50:02PM +0300, Jarkko Sakkinen wrote:
> You should not do arithmetic with __be32 or __le32 types because
> sometimes it results incorrect results. Calculations must be done only
> with integers that are in in the CPU byte order. This commit migrates
> tpm_getcap() to struct tpm_buf in order to sort out these issues.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> Now this should work as Robertos patches move byte order conversion
> where it should be. Sadly I'm out of reach to my Dell E6400 laptop
> that I use for TPM 1.2 testing.
>  drivers/char/tpm/tpm-interface.c | 30 ++++++++++++++++--------------
>  drivers/char/tpm/tpm.h           | 13 -------------
>  2 files changed, 16 insertions(+), 27 deletions(-)

I've now tested this with TPM 1.2. Any complains?

/Jarkko

> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 4ed08ab4d2a8..7436422458c7 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -552,31 +552,33 @@ static const struct tpm_input_header tpm_getcap_header = {
>  ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  		   const char *desc, size_t min_cap_length)
>  {
> -	struct tpm_cmd_t tpm_cmd;
> +	struct tpm_buf buf;
>  	int rc;
>  
> -	tpm_cmd.header.in = tpm_getcap_header;
> +	rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND, TPM_ORD_GET_CAP);
> +	if (rc)
> +		return rc;
> +
>  	if (subcap_id == TPM_CAP_VERSION_1_1 ||
>  	    subcap_id == TPM_CAP_VERSION_1_2) {
> -		tpm_cmd.params.getcap_in.cap = cpu_to_be32(subcap_id);
> -		/*subcap field not necessary */
> -		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(0);
> -		tpm_cmd.header.in.length -= cpu_to_be32(sizeof(__be32));
> +		tpm_buf_append_u32(&buf, subcap_id);
> +		tpm_buf_append_u32(&buf, 0);
>  	} else {
>  		if (subcap_id == TPM_CAP_FLAG_PERM ||
>  		    subcap_id == TPM_CAP_FLAG_VOL)
> -			tpm_cmd.params.getcap_in.cap =
> -				cpu_to_be32(TPM_CAP_FLAG);
> +			tpm_buf_append_u32(&buf, TPM_CAP_FLAG);
>  		else
> -			tpm_cmd.params.getcap_in.cap =
> -				cpu_to_be32(TPM_CAP_PROP);
> -		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> -		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
> +			tpm_buf_append_u32(&buf, TPM_CAP_PROP);
> +
> +		tpm_buf_append_u32(&buf, 4);
> +		tpm_buf_append_u32(&buf, subcap_id);
>  	}
> -	rc = tpm_transmit_cmd(chip, NULL, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> +	rc = tpm_transmit_cmd(chip, NULL, buf.data, TPM_INTERNAL_RESULT_SIZE,
>  			      min_cap_length, 0, desc);
>  	if (!rc)
> -		*cap = tpm_cmd.params.getcap_out.cap;
> +		*cap = *(cap_t *)&buf.data[TPM_HEADER_SIZE + 4];
> +
> +	tpm_buf_destroy(&buf);
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_getcap);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index e81d8c7acb39..dd1173427fb2 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -339,17 +339,6 @@ enum tpm_sub_capabilities {
>  	TPM_CAP_PROP_TIS_DURATION = 0x120,
>  };
>  
> -struct	tpm_getcap_params_in {
> -	__be32	cap;
> -	__be32	subcap_size;
> -	__be32	subcap;
> -} __packed;
> -
> -struct	tpm_getcap_params_out {
> -	__be32	cap_size;
> -	cap_t	cap;
> -} __packed;
> -
>  struct	tpm_readpubek_params_out {
>  	u8	algorithm[4];
>  	u8	encscheme[2];
> @@ -399,10 +388,8 @@ struct tpm_startup_in {
>  } __packed;
>  
>  typedef union {
> -	struct	tpm_getcap_params_out getcap_out;
>  	struct	tpm_readpubek_params_out readpubek_out;
>  	u8	readpubek_out_buffer[sizeof(struct tpm_readpubek_params_out)];
> -	struct	tpm_getcap_params_in getcap_in;
>  	struct	tpm_pcrread_in	pcrread_in;
>  	struct	tpm_pcrread_out	pcrread_out;
>  	struct	tpm_pcrextend_in pcrextend_in;
> -- 
> 2.11.0
> 
