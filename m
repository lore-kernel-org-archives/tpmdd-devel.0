From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix parameter order in tpm_getcap()
Date: Wed, 1 Feb 2017 21:49:40 +0200
Message-ID: <20170201194940.x26pb2vqjacz7vz7@intel.com>
References: <20170201184808.492-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170201184808.492-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 01, 2017 at 08:48:07PM +0200, Jarkko Sakkinen wrote:
> The parameter order mismatches tpm_transmit_cmd().
> 
> Fixes: c659af78eb7b ("tpm: Check size of response before accessing data")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Maybe it's better not to rush this into release as it is an cosmetic
issue only but spreads around the codebase (saw the kbuld test robot
mail).

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 14 +++++++-------
>  drivers/char/tpm/tpm-sysfs.c     | 33 ++++++++++++++++-----------------
>  drivers/char/tpm/tpm.h           |  2 +-
>  3 files changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 423938e..bcce061 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -478,7 +478,7 @@ static const struct tpm_input_header tpm_getcap_header = {
>  };
>  
>  ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
> -		   const char *desc, size_t min_cap_length)
> +		   size_t min_cap_length, const char *desc)
>  {
>  	struct tpm_cmd_t tpm_cmd;
>  	int rc;
> @@ -555,8 +555,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  		return 0;
>  	}
>  
> -	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL,
> -			sizeof(cap.timeout));
> +	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> +			sizeof(cap.timeout), NULL);
>  	if (rc == TPM_ERR_INVALID_POSTINIT) {
>  		/* The TPM is not started, we are the first to talk to it.
>  		   Execute a startup command. */
> @@ -565,8 +565,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  			return rc;
>  
>  		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> -				"attempting to determine the timeouts",
> -				sizeof(cap.timeout));
> +				sizeof(cap.timeout),
> +				"attempting to determine the timeouts");
>  	}
>  
>  	if (rc) {
> @@ -630,8 +630,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  	chip->timeout_d = usecs_to_jiffies(timeout_eff[3]);
>  
>  	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_DURATION, &cap,
> -			"attempting to determine the durations",
> -			sizeof(cap.duration));
> +			sizeof(cap.duration),
> +			"attempting to determine the durations");
>  	if (rc)
>  		return rc;
>  
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 2f596d7..fb9b7fe 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -96,9 +96,8 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
>  	char *str = buf;
>  	struct tpm_chip *chip = to_tpm_chip(dev);
>  
> -	rc = tpm_getcap(chip, TPM_CAP_PROP_PCR, &cap,
> -			"attempting to determine the number of PCRS",
> -			sizeof(cap.num_pcrs));
> +	rc = tpm_getcap(chip, TPM_CAP_PROP_PCR, &cap, sizeof(cap.num_pcrs),
> +			"attempting to determine the number of PCRS");
>  	if (rc)
>  		return 0;
>  
> @@ -123,8 +122,8 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
>  	ssize_t rc;
>  
>  	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
> -			"attempting to determine the permanent enabled state",
> -			sizeof(cap.perm_flags));
> +			sizeof(cap.perm_flags),
> +			"attempting to determine the permanent enabled state");
>  	if (rc)
>  		return 0;
>  
> @@ -140,8 +139,8 @@ static ssize_t active_show(struct device *dev, struct device_attribute *attr,
>  	ssize_t rc;
>  
>  	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
> -			"attempting to determine the permanent active state",
> -			sizeof(cap.perm_flags));
> +			sizeof(cap.perm_flags),
> +			"attempting to determine the permanent active state");
>  	if (rc)
>  		return 0;
>  
> @@ -157,8 +156,8 @@ static ssize_t owned_show(struct device *dev, struct device_attribute *attr,
>  	ssize_t rc;
>  
>  	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_PROP_OWNER, &cap,
> -			"attempting to determine the owner state",
> -			sizeof(cap.owned));
> +			sizeof(cap.owned),
> +			"attempting to determine the owner state");
>  	if (rc)
>  		return 0;
>  
> @@ -174,8 +173,8 @@ static ssize_t temp_deactivated_show(struct device *dev,
>  	ssize_t rc;
>  
>  	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_VOL, &cap,
> -			"attempting to determine the temporary state",
> -			sizeof(cap.stclear_flags));
> +			sizeof(cap.stclear_flags),
> +			"attempting to determine the temporary state");
>  	if (rc)
>  		return 0;
>  
> @@ -193,8 +192,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
>  	char *str = buf;
>  
>  	rc = tpm_getcap(chip, TPM_CAP_PROP_MANUFACTURER, &cap,
> -			"attempting to determine the manufacturer",
> -			sizeof(cap.manufacturer_id));
> +			sizeof(cap.manufacturer_id),
> +			"attempting to determine the manufacturer");
>  	if (rc)
>  		return 0;
>  	str += sprintf(str, "Manufacturer: 0x%x\n",
> @@ -202,8 +201,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
>  
>  	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
>  	rc = tpm_getcap(chip, TPM_CAP_VERSION_1_2, &cap,
> -			"attempting to determine the 1.2 version",
> -			sizeof(cap.tpm_version_1_2));
> +			sizeof(cap.tpm_version_1_2),
> +			"attempting to determine the 1.2 version");
>  	if (!rc) {
>  		str += sprintf(str,
>  			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
> @@ -214,8 +213,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
>  	} else {
>  		/* Otherwise just use TPM_STRUCT_VER */
>  		rc = tpm_getcap(chip, TPM_CAP_VERSION_1_1, &cap,
> -				"attempting to determine the 1.1 version",
> -				sizeof(cap.tpm_version));
> +				sizeof(cap.tpm_version),
> +				"attempting to determine the 1.1 version");
>  		if (rc)
>  			return 0;
>  		str += sprintf(str,
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index bff37be..3f76825 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -499,7 +499,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf, size_t bufsiz,
>  			 size_t min_rsp_body_len, unsigned int flags,
>  			 const char *desc);
>  ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
> -		   const char *desc, size_t min_cap_length);
> +		   size_t min_cap_length, const char *desc);
>  int tpm_get_timeouts(struct tpm_chip *);
>  int tpm1_auto_startup(struct tpm_chip *chip);
>  int tpm_do_selftest(struct tpm_chip *chip);
> -- 
> 2.9.3
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
