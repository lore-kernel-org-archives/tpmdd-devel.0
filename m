From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 2/3] tpm: move endianness conversion of ordinals to
 tpm_input_header
Date: Thu, 4 May 2017 20:34:52 +0300
Message-ID: <20170504173452.yuvomusyx2auewb4@intel.com>
References: <20170503161911.17606-1-roberto.sassu@huawei.com>
 <20170503161911.17606-3-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170503161911.17606-3-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 03, 2017 at 06:19:10PM +0200, Roberto Sassu wrote:
> Move CPU native value to big-endian conversion of ordinals to the
> tpm_input_header declarations.
> 
> With the previous and this patch it will now be possible to modify TPM 1.2
> functions to use tpm_buf_init(), which expects CPU native value for the
> tag and ordinal arguments.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviwed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
> v2
> - restored TPM_ORD_ definitions in tpm-interface.c and tpm-sysfs.c
> 
>  drivers/char/tpm/tpm-interface.c | 24 ++++++++++++------------
>  drivers/char/tpm/tpm-sysfs.c     |  4 ++--
>  2 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index a6bc0ba..a8351dd 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -468,13 +468,13 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf,
>  #define TPM_DIGEST_SIZE 20
>  #define TPM_RET_CODE_IDX 6
>  #define TPM_INTERNAL_RESULT_SIZE 200
> -#define TPM_ORD_GET_CAP cpu_to_be32(101)
> -#define TPM_ORD_GET_RANDOM cpu_to_be32(70)
> +#define TPM_ORD_GET_CAP 101
> +#define TPM_ORD_GET_RANDOM 70
>  
>  static const struct tpm_input_header tpm_getcap_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(22),
> -	.ordinal = TPM_ORD_GET_CAP
> +	.ordinal = cpu_to_be32(TPM_ORD_GET_CAP)
>  };
>  
>  ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
> @@ -509,14 +509,14 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  }
>  EXPORT_SYMBOL_GPL(tpm_getcap);
>  
> -#define TPM_ORD_STARTUP cpu_to_be32(153)
> +#define TPM_ORD_STARTUP 153
>  #define TPM_ST_CLEAR cpu_to_be16(1)
>  #define TPM_ST_STATE cpu_to_be16(2)
>  #define TPM_ST_DEACTIVATED cpu_to_be16(3)
>  static const struct tpm_input_header tpm_startup_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(12),
> -	.ordinal = TPM_ORD_STARTUP
> +	.ordinal = cpu_to_be32(TPM_ORD_STARTUP)
>  };
>  
>  static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
> @@ -687,13 +687,13 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
>  	return rc;
>  }
>  
> -#define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
> +#define TPM_ORDINAL_PCRREAD 21
>  #define READ_PCR_RESULT_SIZE 30
>  #define READ_PCR_RESULT_BODY_SIZE 20
>  static const struct tpm_input_header pcrread_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(14),
> -	.ordinal = TPM_ORDINAL_PCRREAD
> +	.ordinal = cpu_to_be32(TPM_ORDINAL_PCRREAD)
>  };
>  
>  int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
> @@ -765,13 +765,13 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
>  }
>  EXPORT_SYMBOL_GPL(tpm_pcr_read);
>  
> -#define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
> +#define TPM_ORD_PCR_EXTEND 20
>  #define EXTEND_PCR_RESULT_SIZE 34
>  #define EXTEND_PCR_RESULT_BODY_SIZE 20
>  static const struct tpm_input_header pcrextend_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(34),
> -	.ordinal = TPM_ORD_PCR_EXTEND
> +	.ordinal = cpu_to_be32(TPM_ORD_PCR_EXTEND)
>  };
>  
>  /**
> @@ -987,13 +987,13 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>  }
>  EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
>  
> -#define TPM_ORD_SAVESTATE cpu_to_be32(152)
> +#define TPM_ORD_SAVESTATE 152
>  #define SAVESTATE_RESULT_SIZE 10
>  
>  static const struct tpm_input_header savestate_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(10),
> -	.ordinal = TPM_ORD_SAVESTATE
> +	.ordinal = cpu_to_be32(TPM_ORD_SAVESTATE)
>  };
>  
>  /*
> @@ -1078,7 +1078,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
>  static const struct tpm_input_header tpm_getrandom_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(14),
> -	.ordinal = TPM_ORD_GET_RANDOM
> +	.ordinal = cpu_to_be32(TPM_ORD_GET_RANDOM)
>  };
>  
>  /**
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index a078b4d..c8cc0d5 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -22,11 +22,11 @@
>  
>  #define READ_PUBEK_RESULT_SIZE 314
>  #define READ_PUBEK_RESULT_MIN_BODY_SIZE (28 + 256)
> -#define TPM_ORD_READPUBEK cpu_to_be32(124)
> +#define TPM_ORD_READPUBEK 124
>  static const struct tpm_input_header tpm_readpubek_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(30),
> -	.ordinal = TPM_ORD_READPUBEK
> +	.ordinal = cpu_to_be32(TPM_ORD_READPUBEK)
>  };
>  static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
>  			  char *buf)
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
