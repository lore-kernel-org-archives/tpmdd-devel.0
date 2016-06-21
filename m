From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v7 4/5] tpm: Allow TPM chip drivers to
 override reported command durations
Date: Tue, 21 Jun 2016 23:54:38 +0300
Message-ID: <20160621205438.GC8218@intel.com>
References: <1465610107-87762-1-git-send-email-eswierk@skyportsystems.com>
	<1466474042-110773-1-git-send-email-eswierk@skyportsystems.com>
	<1466474042-110773-5-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466474042-110773-5-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jun 20, 2016 at 06:54:01PM -0700, Ed Swierk wrote:
> Some TPM chips report bogus command durations in their capabilities,
> just as others report incorrect timeouts. Rework tpm_get_timeouts() to
> allow chip drivers to override either via a single callback. Also
> clean up handling of TPMs that report milliseconds instead of
> microseconds.
> 
> Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 143 +++++++++++++++++++++------------------
>  drivers/char/tpm/tpm_tis.c       |  35 +++-------
>  include/linux/tpm.h              |   3 +-
>  3 files changed, 88 insertions(+), 93 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 73c3ee0..36a6861 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -514,12 +514,11 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
>  
>  int tpm_get_timeouts(struct tpm_chip *chip)
>  {
> -	cap_t cap;
> -	unsigned long new_timeout[4];
> -	unsigned long old_timeout[4];
> -	ssize_t rc;
> +	cap_t cap1, cap2;
> +	int rc;
> +	struct tpm_vendor_specific orig_vendor;
>  
> -	rc = tpm_getcap(chip->pdev, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> +	rc = tpm_getcap(chip->pdev, TPM_CAP_PROP_TIS_TIMEOUT, &cap1,
>  			"attempting to determine the timeouts");
>  	if (rc == TPM_ERR_INVALID_POSTINIT) {
>  		/* The TPM is not started, we are the first to talk to it.
> @@ -528,77 +527,91 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  		if (tpm_startup(chip, TPM_ST_CLEAR))
>  			return rc;
>  
> -		rc = tpm_getcap(chip->pdev, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> +		rc = tpm_getcap(chip->pdev, TPM_CAP_PROP_TIS_TIMEOUT, &cap1,
>  				"attempting to determine the timeouts");
>  	}
>  	if (rc)
>  		return rc;
>  
> -	old_timeout[0] = be32_to_cpu(cap.timeout.a);
> -	old_timeout[1] = be32_to_cpu(cap.timeout.b);
> -	old_timeout[2] = be32_to_cpu(cap.timeout.c);
> -	old_timeout[3] = be32_to_cpu(cap.timeout.d);
> -	memcpy(new_timeout, old_timeout, sizeof(new_timeout));
> -
> -	/*
> -	 * Provide ability for vendor overrides of timeout values in case
> -	 * of misreporting.
> -	 */
> -	if (chip->ops->update_timeouts != NULL)
> -		chip->vendor.timeout_adjusted =
> -			chip->ops->update_timeouts(chip, new_timeout);
> -
> -	if (!chip->vendor.timeout_adjusted) {
> -		/* Don't overwrite default if value is 0 */
> -		if (new_timeout[0] != 0 && new_timeout[0] < 1000) {
> -			int i;
> -
> -			/* timeouts in msec rather usec */
> -			for (i = 0; i != ARRAY_SIZE(new_timeout); i++)
> -				new_timeout[i] *= 1000;
> -			chip->vendor.timeout_adjusted = true;
> -		}
> -	}
> -
> -	/* Report adjusted timeouts */
> -	if (chip->vendor.timeout_adjusted) {
> -		dev_info(chip->pdev,
> -			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->%luus D %lu->%luus\n",
> -			 old_timeout[0], new_timeout[0],
> -			 old_timeout[1], new_timeout[1],
> -			 old_timeout[2], new_timeout[2],
> -			 old_timeout[3], new_timeout[3]);
> -	}
> -
> -	chip->vendor.timeout_a = usecs_to_jiffies(new_timeout[0]);
> -	chip->vendor.timeout_b = usecs_to_jiffies(new_timeout[1]);
> -	chip->vendor.timeout_c = usecs_to_jiffies(new_timeout[2]);
> -	chip->vendor.timeout_d = usecs_to_jiffies(new_timeout[3]);
> -
> -	rc = tpm_getcap(chip->pdev, TPM_CAP_PROP_TIS_DURATION, &cap,
> +	rc = tpm_getcap(chip->pdev, TPM_CAP_PROP_TIS_DURATION, &cap2,
>  			"attempting to determine the durations");
>  	if (rc)
>  		return rc;
>  
> -	chip->vendor.duration[TPM_SHORT] =
> -		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_short));
> -	chip->vendor.duration[TPM_MEDIUM] =
> -		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_medium));
> -	chip->vendor.duration[TPM_LONG] =
> -		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_long));
> +	be32_to_cpus(&cap1.timeout.a);
> +	be32_to_cpus(&cap1.timeout.b);
> +	be32_to_cpus(&cap1.timeout.c);
> +	be32_to_cpus(&cap1.timeout.d);
> +	chip->vendor.timeout_a = usecs_to_jiffies(cap1.timeout.a);
> +	chip->vendor.timeout_b = usecs_to_jiffies(cap1.timeout.b);
> +	chip->vendor.timeout_c = usecs_to_jiffies(cap1.timeout.c);
> +	chip->vendor.timeout_d = usecs_to_jiffies(cap1.timeout.d);
>  
> -	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
> -	 * value wrong and apparently reports msecs rather than usecs. So we
> -	 * fix up the resulting too-small TPM_SHORT value to make things work.
> -	 * We also scale the TPM_MEDIUM and -_LONG values by 1000.
> -	 */
> -	if (chip->vendor.duration[TPM_SHORT] < (HZ / 100)) {
> -		chip->vendor.duration[TPM_SHORT] = HZ;
> -		chip->vendor.duration[TPM_MEDIUM] *= 1000;
> -		chip->vendor.duration[TPM_LONG] *= 1000;
> -		chip->vendor.duration_adjusted = true;
> -		dev_info(chip->pdev, "Adjusting TPM timeout parameters.");
> +	/* Some TPMs report timeouts in milliseconds rather than
> +	   microseconds. Use a value between 1 and 1000 as an
> +	   indication that this is the case. */
> +	if (cap1.timeout.a > 0 && cap1.timeout.a < 1000) {
> +		chip->vendor.timeout_a = msecs_to_jiffies(cap1.timeout.a);
> +		chip->vendor.timeout_b = msecs_to_jiffies(cap1.timeout.b);
> +		chip->vendor.timeout_c = msecs_to_jiffies(cap1.timeout.c);
> +		chip->vendor.timeout_d = msecs_to_jiffies(cap1.timeout.d);
> +		chip->vendor.timeout_adjusted = true;
>  	}
> +
> +	be32_to_cpus(&cap2.duration.tpm_short);
> +	be32_to_cpus(&cap2.duration.tpm_medium);
> +	be32_to_cpus(&cap2.duration.tpm_long);
> +	chip->vendor.duration[TPM_SHORT] =
> +		usecs_to_jiffies(cap2.duration.tpm_short);
> +	chip->vendor.duration[TPM_MEDIUM] =
> +		usecs_to_jiffies(cap2.duration.tpm_medium);
> +	chip->vendor.duration[TPM_LONG] =
> +		usecs_to_jiffies(cap2.duration.tpm_long);
> +
> +	memcpy(&orig_vendor, &chip->vendor, sizeof(orig_vendor));
> +
> +	/* Interpret duration values between 1 and 10000 as
> +	   milliseconds to deal with TPMs like the Broadcom BCM0102 in
> +	   the Dell Latitude D820. */
> +	if (cap2.duration.tpm_short > 0 && cap2.duration.tpm_short < 10000) {
> +		chip->vendor.duration[TPM_SHORT] =
> +			msecs_to_jiffies(cap2.duration.tpm_short);
> +		chip->vendor.duration[TPM_MEDIUM] =
> +			msecs_to_jiffies(cap2.duration.tpm_medium);
> +		chip->vendor.duration[TPM_LONG] =
> +			msecs_to_jiffies(cap2.duration.tpm_long);
> +		chip->vendor.duration_adjusted = true;
> +	}
> +
> +	if (chip->ops->update_timeouts != NULL)
> +		chip->ops->update_timeouts(chip);
> +
> +	if (chip->vendor.timeout_adjusted) {
> +		dev_info(chip->pdev,
> +			 HW_ERR "Adjusted timeouts: A %u->%uus B %u->%uus"
> +			 " C %u->%uus D %u->%uus\n",
> +			 jiffies_to_usecs(orig_vendor.timeout_a),
> +			 jiffies_to_usecs(chip->vendor.timeout_a),
> +			 jiffies_to_usecs(orig_vendor.timeout_b),
> +			 jiffies_to_usecs(chip->vendor.timeout_b),
> +			 jiffies_to_usecs(orig_vendor.timeout_c),
> +			 jiffies_to_usecs(chip->vendor.timeout_c),
> +			 jiffies_to_usecs(orig_vendor.timeout_d),
> +			 jiffies_to_usecs(chip->vendor.timeout_d));
> +	}
> +
> +	if (chip->vendor.duration_adjusted) {
> +		dev_info(chip->pdev,
> +			 HW_ERR "Adjusted durations: short %u->%uus"
> +			 " medium %u->%uus long %u->%uus\n",
> +			 jiffies_to_usecs(orig_vendor.duration[TPM_SHORT]),
> +			 jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
> +			 jiffies_to_usecs(orig_vendor.duration[TPM_MEDIUM]),
> +			 jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
> +			 jiffies_to_usecs(orig_vendor.duration[TPM_LONG]),
> +			 jiffies_to_usecs(chip->vendor.duration[TPM_LONG]));
> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_get_timeouts);
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 088fa86..caf7278 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -475,34 +475,17 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  	return rc;
>  }
>  
> -struct tis_vendor_timeout_override {
> -	u32 did_vid;
> -	unsigned long timeout_us[4];
> -};
> -
> -static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
> -	/* Atmel 3204 */
> -	{ 0x32041114, { (TIS_SHORT_TIMEOUT*1000), (TIS_LONG_TIMEOUT*1000),
> -			(TIS_SHORT_TIMEOUT*1000), (TIS_SHORT_TIMEOUT*1000) } },
> -};
> -
> -static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
> -				    unsigned long *timeout_cap)
> +static void tpm_tis_update_timeouts(struct tpm_chip *chip)
>  {
> -	int i;
> -	u32 did_vid;
> -
> -	did_vid = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
> -
> -	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
> -		if (vendor_timeout_overrides[i].did_vid != did_vid)
> -			continue;
> -		memcpy(timeout_cap, vendor_timeout_overrides[i].timeout_us,
> -		       sizeof(vendor_timeout_overrides[i].timeout_us));
> -		return true;
> +	switch (ioread32(chip->vendor.iobase + TPM_DID_VID(0))) {
> +	case 0x32041114: /* Atmel 3204 */
> +		chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> +		chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
> +		chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> +		chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> +		chip->vendor.timeout_adjusted = true;
> +		break;
>  	}
> -
> -	return false;
>  }
>  
>  /*
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 706e63e..2380ebf 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -41,8 +41,7 @@ struct tpm_class_ops {
>  	int (*send) (struct tpm_chip *chip, u8 *buf, size_t len);
>  	void (*cancel) (struct tpm_chip *chip);
>  	u8 (*status) (struct tpm_chip *chip);
> -	bool (*update_timeouts)(struct tpm_chip *chip,
> -				unsigned long *timeout_cap);
> +	void (*update_timeouts)(struct tpm_chip *chip);
>  
>  };
>  
> -- 
> 1.9.1
> 

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
