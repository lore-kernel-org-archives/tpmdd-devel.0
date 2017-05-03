From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 2/3] tpm: move ordinals definition to
 include/linux/tpm_command.h
Date: Wed, 3 May 2017 15:45:32 +0300
Message-ID: <20170503124532.72pnwjz3dmheuqua@intel.com>
References: <20170502123151.24354-1-roberto.sassu@huawei.com>
 <20170502123151.24354-3-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170502123151.24354-3-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, May 02, 2017 at 02:31:50PM +0200, Roberto Sassu wrote:
> Move definition from tpm-interface.c to tpm_command.h, so that there is
> no duplication. Also convert the ordinals in the tpm_input_header
> declarations.
> 
> With the previous and this patch it will now be possible to convert TPM 1.2
> functions to use tpm_buf_init(), which expect CPU native value for the
> tag and ordinal arguments.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 19 ++++++-------------
>  drivers/char/tpm/tpm-sysfs.c     |  3 +--
>  include/linux/tpm_command.h      |  7 +++++++
>  3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 48f5dff..5c2c032 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -469,13 +469,11 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf,
>  #define TPM_DIGEST_SIZE 20
>  #define TPM_RET_CODE_IDX 6
>  #define TPM_INTERNAL_RESULT_SIZE 200
> -#define TPM_ORD_GET_CAP cpu_to_be32(101)
> -#define TPM_ORD_GET_RANDOM cpu_to_be32(70)
>  
>  static const struct tpm_input_header tpm_getcap_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(22),
> -	.ordinal = TPM_ORD_GET_CAP
> +	.ordinal = cpu_to_be32(TPM_ORD_GET_CAP)
>  };
>  
>  ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
> @@ -510,14 +508,13 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  }
>  EXPORT_SYMBOL_GPL(tpm_getcap);
>  
> -#define TPM_ORD_STARTUP cpu_to_be32(153)
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
> @@ -661,7 +658,6 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  }
>  EXPORT_SYMBOL_GPL(tpm_get_timeouts);
>  
> -#define TPM_ORD_CONTINUE_SELFTEST 83
>  #define CONTINUE_SELFTEST_RESULT_SIZE 10
>  
>  static const struct tpm_input_header continue_selftest_header = {
> @@ -688,13 +684,12 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
>  	return rc;
>  }
>  
> -#define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
>  #define READ_PCR_RESULT_SIZE 30
>  #define READ_PCR_RESULT_BODY_SIZE 20
>  static const struct tpm_input_header pcrread_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(14),
> -	.ordinal = TPM_ORDINAL_PCRREAD
> +	.ordinal = cpu_to_be32(TPM_ORD_PCRREAD)
>  };
>  
>  int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
> @@ -766,13 +761,12 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
>  }
>  EXPORT_SYMBOL_GPL(tpm_pcr_read);
>  
> -#define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
>  #define EXTEND_PCR_RESULT_SIZE 34
>  #define EXTEND_PCR_RESULT_BODY_SIZE 20
>  static const struct tpm_input_header pcrextend_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(34),
> -	.ordinal = TPM_ORD_PCR_EXTEND
> +	.ordinal = cpu_to_be32(TPM_ORD_PCREXTEND)
>  };
>  
>  /**
> @@ -988,13 +982,12 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>  }
>  EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
>  
> -#define TPM_ORD_SAVESTATE cpu_to_be32(152)
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
> @@ -1079,7 +1072,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
>  static const struct tpm_input_header tpm_getrandom_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(14),
> -	.ordinal = TPM_ORD_GET_RANDOM
> +	.ordinal = cpu_to_be32(TPM_ORD_GETRANDOM)
>  };
>  
>  /**
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 69a0741..413ac2c 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -23,11 +23,10 @@
>  
>  #define READ_PUBEK_RESULT_SIZE 314
>  #define READ_PUBEK_RESULT_MIN_BODY_SIZE (28 + 256)
> -#define TPM_ORD_READPUBEK cpu_to_be32(124)
>  static const struct tpm_input_header tpm_readpubek_header = {
>  	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(30),
> -	.ordinal = TPM_ORD_READPUBEK
> +	.ordinal = cpu_to_be32(TPM_ORD_READPUBEK)
>  };
>  static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
>  			  char *buf)
> diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
> index 727512e..0fe58d8 100644
> --- a/include/linux/tpm_command.h
> +++ b/include/linux/tpm_command.h
> @@ -20,6 +20,13 @@
>  #define TPM_ORD_OIAP                    10
>  #define TPM_ORD_SEAL                    23
>  #define TPM_ORD_UNSEAL                  24
> +#define TPM_ORD_GET_CAP                101
> +#define TPM_ORD_STARTUP                153
> +#define TPM_ORD_CONTINUE_SELFTEST       83
> +#define TPM_ORD_PCRREAD                 21
> +#define TPM_ORD_PCREXTEND               20
> +#define TPM_ORD_SAVESTATE              152
> +#define TPM_ORD_READPUBEK              124
>  
>  /* Other constants */
>  #define SRKHANDLE                       0x40000000
> -- 
> 2.9.3
> 
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, Slashdot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
