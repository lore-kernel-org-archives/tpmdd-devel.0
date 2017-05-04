From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v2 1/3] tpm: move endianness conversion of
 TPM_TAG_RQU_COMMAND to tpm_input_header
Date: Thu, 4 May 2017 20:34:18 +0300
Message-ID: <20170504173418.x3y7g22qusskpoep@intel.com>
References: <20170503161911.17606-1-roberto.sassu@huawei.com>
 <20170503161911.17606-2-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170503161911.17606-2-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 03, 2017 at 06:19:09PM +0200, Roberto Sassu wrote:
> In the long term, TPM 1.2 functions in the driver interface will be
> modified to use tpm_buf_init().
> 
> However, tag and ordinals cannot be passed directly to tpm_buf_init(),
> because this function performs CPU native to big-endian conversion of these
> arguments. Since TPM_TAG_RQU_COMMAND and TPM_ORD_ are already converted,
> passing them to the function will undo the previous conversion.
> 
> This patch moves the conversion of TPM_TAG_RQU_COMMAND from the tpm.h
> header file in the driver directory to the tpm_input_header declarations
> in the driver interface and tpm-sysfs.c.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviwed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

> ---
> v2
> - restored TPM_TAG_RQU_COMMAND definition in drivers/char/tpm/tpm.h
> - removed endianness conversion in TPM_TAG_RQU_COMMAND definition
> - removed '#include <linux/tpm_command.h>' in tpm-interface.c
>   and tpm-sysfs.c
> 
>  drivers/char/tpm/tpm-interface.c | 14 +++++++-------
>  drivers/char/tpm/tpm-sysfs.c     |  2 +-
>  drivers/char/tpm/tpm.h           |  2 +-
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index bd2128e..a6bc0ba 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -472,7 +472,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf,
>  #define TPM_ORD_GET_RANDOM cpu_to_be32(70)
>  
>  static const struct tpm_input_header tpm_getcap_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> +	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(22),
>  	.ordinal = TPM_ORD_GET_CAP
>  };
> @@ -514,7 +514,7 @@ EXPORT_SYMBOL_GPL(tpm_getcap);
>  #define TPM_ST_STATE cpu_to_be16(2)
>  #define TPM_ST_DEACTIVATED cpu_to_be16(3)
>  static const struct tpm_input_header tpm_startup_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> +	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(12),
>  	.ordinal = TPM_ORD_STARTUP
>  };
> @@ -664,7 +664,7 @@ EXPORT_SYMBOL_GPL(tpm_get_timeouts);
>  #define CONTINUE_SELFTEST_RESULT_SIZE 10
>  
>  static const struct tpm_input_header continue_selftest_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> +	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(10),
>  	.ordinal = cpu_to_be32(TPM_ORD_CONTINUE_SELFTEST),
>  };
> @@ -691,7 +691,7 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
>  #define READ_PCR_RESULT_SIZE 30
>  #define READ_PCR_RESULT_BODY_SIZE 20
>  static const struct tpm_input_header pcrread_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> +	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(14),
>  	.ordinal = TPM_ORDINAL_PCRREAD
>  };
> @@ -769,7 +769,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
>  #define EXTEND_PCR_RESULT_SIZE 34
>  #define EXTEND_PCR_RESULT_BODY_SIZE 20
>  static const struct tpm_input_header pcrextend_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> +	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(34),
>  	.ordinal = TPM_ORD_PCR_EXTEND
>  };
> @@ -991,7 +991,7 @@ EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
>  #define SAVESTATE_RESULT_SIZE 10
>  
>  static const struct tpm_input_header savestate_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> +	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(10),
>  	.ordinal = TPM_ORD_SAVESTATE
>  };
> @@ -1076,7 +1076,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
>  
>  #define TPM_GETRANDOM_RESULT_SIZE	18
>  static const struct tpm_input_header tpm_getrandom_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> +	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(14),
>  	.ordinal = TPM_ORD_GET_RANDOM
>  };
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 2f596d7..a078b4d 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -24,7 +24,7 @@
>  #define READ_PUBEK_RESULT_MIN_BODY_SIZE (28 + 256)
>  #define TPM_ORD_READPUBEK cpu_to_be32(124)
>  static const struct tpm_input_header tpm_readpubek_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> +	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
>  	.length = cpu_to_be32(30),
>  	.ordinal = TPM_ORD_READPUBEK
>  };
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 4937b56..7d6a606 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -215,7 +215,7 @@ struct tpm_output_header {
>  	__be32	return_code;
>  } __packed;
>  
> -#define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
> +#define TPM_TAG_RQU_COMMAND 193
>  
>  struct	stclear_flags_t {
>  	__be16	tag;
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
