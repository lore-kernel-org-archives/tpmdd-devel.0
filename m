From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: sanitize constant expressions
Date: Tue, 25 Oct 2016 23:32:48 +0300
Message-ID: <20161025203248.as45eyv73n4524g5@intel.com>
References: <20161021213928.14810-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161021213928.14810-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 22, 2016 at 12:39:27AM +0300, Jarkko Sakkinen wrote:
> Use cpu_to_b32 at the time it is needed in enum tpm_capabilities and
> enum tpm_sub_capabilities in order to be consistent with the other
> enums in drivats/char/tpm/tpm.h.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I'll apply this to my master branch as it is very trivial patch. Report
if you have any problems.

/Jarkko

> ---
> v2: parameter type of subcap_id to u32
>  drivers/char/tpm/tpm-interface.c | 15 +++++++++------
>  drivers/char/tpm/tpm-sysfs.c     |  4 ++--
>  drivers/char/tpm/tpm.h           | 25 ++++++++++++-------------
>  3 files changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index acf89e8..fa97520 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -442,26 +442,29 @@ static const struct tpm_input_header tpm_getcap_header = {
>  	.ordinal = TPM_ORD_GET_CAP
>  };
>  
> -ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
> +ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  		   const char *desc)
>  {
>  	struct tpm_cmd_t tpm_cmd;
>  	int rc;
>  
>  	tpm_cmd.header.in = tpm_getcap_header;
> -	if (subcap_id == CAP_VERSION_1_1 || subcap_id == CAP_VERSION_1_2) {
> -		tpm_cmd.params.getcap_in.cap = subcap_id;
> +	if (subcap_id == TPM_CAP_VERSION_1_1 ||
> +	    subcap_id == TPM_CAP_VERSION_1_2) {
> +		tpm_cmd.params.getcap_in.cap = cpu_to_be32(subcap_id);
>  		/*subcap field not necessary */
>  		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(0);
>  		tpm_cmd.header.in.length -= cpu_to_be32(sizeof(__be32));
>  	} else {
>  		if (subcap_id == TPM_CAP_FLAG_PERM ||
>  		    subcap_id == TPM_CAP_FLAG_VOL)
> -			tpm_cmd.params.getcap_in.cap = TPM_CAP_FLAG;
> +			tpm_cmd.params.getcap_in.cap =
> +				cpu_to_be32(TPM_CAP_FLAG);
>  		else
> -			tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> +			tpm_cmd.params.getcap_in.cap =
> +				cpu_to_be32(TPM_CAP_PROP);
>  		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> -		tpm_cmd.params.getcap_in.subcap = subcap_id;
> +		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
>  	}
>  	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
>  			      desc);
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index a76ab4a..59a1ead 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -193,7 +193,7 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
>  		       be32_to_cpu(cap.manufacturer_id));
>  
>  	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
> -	rc = tpm_getcap(chip, CAP_VERSION_1_2, &cap,
> +	rc = tpm_getcap(chip, TPM_CAP_VERSION_1_2, &cap,
>  			"attempting to determine the 1.2 version");
>  	if (!rc) {
>  		str += sprintf(str,
> @@ -204,7 +204,7 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
>  			       cap.tpm_version_1_2.revMinor);
>  	} else {
>  		/* Otherwise just use TPM_STRUCT_VER */
> -		rc = tpm_getcap(chip, CAP_VERSION_1_1, &cap,
> +		rc = tpm_getcap(chip, TPM_CAP_VERSION_1_1, &cap,
>  				"attempting to determine the 1.1 version");
>  		if (rc)
>  			return 0;
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 4d183c9..1864932 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -282,21 +282,20 @@ typedef union {
>  } cap_t;
>  
>  enum tpm_capabilities {
> -	TPM_CAP_FLAG = cpu_to_be32(4),
> -	TPM_CAP_PROP = cpu_to_be32(5),
> -	CAP_VERSION_1_1 = cpu_to_be32(0x06),
> -	CAP_VERSION_1_2 = cpu_to_be32(0x1A)
> +	TPM_CAP_FLAG = 4,
> +	TPM_CAP_PROP = 5,
> +	TPM_CAP_VERSION_1_1 = 0x06,
> +	TPM_CAP_VERSION_1_2 = 0x1A,
>  };
>  
>  enum tpm_sub_capabilities {
> -	TPM_CAP_PROP_PCR = cpu_to_be32(0x101),
> -	TPM_CAP_PROP_MANUFACTURER = cpu_to_be32(0x103),
> -	TPM_CAP_FLAG_PERM = cpu_to_be32(0x108),
> -	TPM_CAP_FLAG_VOL = cpu_to_be32(0x109),
> -	TPM_CAP_PROP_OWNER = cpu_to_be32(0x111),
> -	TPM_CAP_PROP_TIS_TIMEOUT = cpu_to_be32(0x115),
> -	TPM_CAP_PROP_TIS_DURATION = cpu_to_be32(0x120),
> -
> +	TPM_CAP_PROP_PCR = 0x101,
> +	TPM_CAP_PROP_MANUFACTURER = 0x103,
> +	TPM_CAP_FLAG_PERM = 0x108,
> +	TPM_CAP_FLAG_VOL = 0x109,
> +	TPM_CAP_PROP_OWNER = 0x111,
> +	TPM_CAP_PROP_TIS_TIMEOUT = 0x115,
> +	TPM_CAP_PROP_TIS_DURATION = 0x120,
>  };
>  
>  struct	tpm_getcap_params_in {
> @@ -484,7 +483,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>  		     unsigned int flags);
>  ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, int len,
>  			 unsigned int flags, const char *desc);
> -ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
> +ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  		   const char *desc);
>  int tpm_get_timeouts(struct tpm_chip *);
>  int tpm1_auto_startup(struct tpm_chip *chip);
> -- 
> 2.9.3
> 
