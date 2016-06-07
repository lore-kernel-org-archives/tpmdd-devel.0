From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 3/4] tpm: Allow TPM chip drivers to
 override reported command durations
Date: Tue, 7 Jun 2016 17:15:26 +0300
Message-ID: <20160607141526.GG3855@intel.com>
References: <1465270649-22498-1-git-send-email-eswierk@skyportsystems.com>
	<1465270649-22498-4-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465270649-22498-4-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jun 06, 2016 at 08:37:28PM -0700, Ed Swierk wrote:
> Some TPM chips report bogus command durations in their capabilities,
> just as others report incorrect timeouts. Add an update_durations()
> function and an implementation for tpm_tis, and move the existing
> BCM0102 workaround out of the common tpm_get_timeouts() code.
> 
> Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>


> ---
>  drivers/char/tpm/tpm-interface.c | 43 ++++++++++++++++++++++++----------------
>  drivers/char/tpm/tpm_tis.c       | 40 +++++++++++++++++++++++++++++++++++++
>  include/linux/tpm.h              |  2 ++
>  3 files changed, 68 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index cc1e5bc..91332dd 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -507,7 +507,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  	struct tpm_cmd_t tpm_cmd;
>  	unsigned long new_timeout[4];
>  	unsigned long old_timeout[4];
> -	struct duration_t *duration_cap;
> +	unsigned long new_duration[3];
> +	unsigned long old_duration[3];
>  	ssize_t rc;
>  
>  	tpm_cmd.header.in = tpm_getcap_header;
> @@ -599,26 +600,34 @@ duration:
>  	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
>  		return -EINVAL;
>  
> -	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
> +	old_duration[TPM_SHORT] =
> +		be32_to_cpu(tpm_cmd.params.getcap_out.cap.duration.tpm_short);
> +	old_duration[TPM_MEDIUM] =
> +		be32_to_cpu(tpm_cmd.params.getcap_out.cap.duration.tpm_medium);
> +	old_duration[TPM_LONG] =
> +		be32_to_cpu(tpm_cmd.params.getcap_out.cap.duration.tpm_long);
> +	memcpy(new_duration, old_duration, sizeof(new_duration));
> +
> +	if (chip->ops->update_durations != NULL)
> +		chip->vendor.duration_adjusted =
> +			chip->ops->update_durations(chip, new_duration);
> +
> +	/* Report adjusted durations */
> +	if (chip->vendor.duration_adjusted) {
> +		dev_info(chip->pdev,
> +			 HW_ERR "Adjusting reported durations: short %lu->%luus medium %lu->%luus long %lu->%luus\n",
> +			 old_duration[TPM_SHORT], new_duration[TPM_SHORT],
> +			 old_duration[TPM_MEDIUM], new_duration[TPM_MEDIUM],
> +			 old_duration[TPM_LONG], new_duration[TPM_LONG]);
> +	}
> +
>  	chip->vendor.duration[TPM_SHORT] =
> -	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
> +		usecs_to_jiffies(new_duration[TPM_SHORT]);
>  	chip->vendor.duration[TPM_MEDIUM] =
> -	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
> +		usecs_to_jiffies(new_duration[TPM_MEDIUM]);
>  	chip->vendor.duration[TPM_LONG] =
> -	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
> +		usecs_to_jiffies(new_duration[TPM_LONG]);
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
> -	}
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_get_timeouts);
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 088fa86..3baba73 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -505,6 +505,45 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
>  	return false;
>  }
>  
> +struct tis_vendor_duration_override {
> +	u32 did_vid;
> +	unsigned long duration_us[3];
> +};
> +
> +static const struct tis_vendor_duration_override vendor_duration_overrides[] = {
> +};
> +
> +static bool tpm_tis_update_durations(struct tpm_chip *chip,
> +				     unsigned long *duration_cap)
> +{
> +	int i;
> +	u32 did_vid;
> +
> +	did_vid = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
> +
> +	for (i = 0; i != ARRAY_SIZE(vendor_duration_overrides); i++) {
> +		if (vendor_duration_overrides[i].did_vid != did_vid)
> +			continue;
> +		memcpy(duration_cap, vendor_duration_overrides[i].duration_us,
> +		       sizeof(vendor_duration_overrides[i].duration_us));
> +		return true;
> +	}
> +
> +	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
> +	 * value wrong and apparently reports msecs rather than usecs. So we
> +	 * fix up the resulting too-small TPM_SHORT value to make things work.
> +	 * We also scale the TPM_MEDIUM and -_LONG values by 1000.
> +	 */
> +	if (duration_cap[TPM_SHORT] < (HZ / 100)) {
> +		duration_cap[TPM_SHORT] = HZ;
> +		duration_cap[TPM_MEDIUM] *= 1000;
> +		duration_cap[TPM_LONG] *= 1000;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  /*
>   * Early probing for iTPM with STS_DATA_EXPECT flaw.
>   * Try sending command without itpm flag set and if that
> @@ -570,6 +609,7 @@ static const struct tpm_class_ops tpm_tis = {
>  	.send = tpm_tis_send,
>  	.cancel = tpm_tis_ready,
>  	.update_timeouts = tpm_tis_update_timeouts,
> +	.update_durations = tpm_tis_update_durations,
>  	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
>  	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
>  	.req_canceled = tpm_tis_req_canceled,
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 706e63e..862d0a1 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -43,6 +43,8 @@ struct tpm_class_ops {
>  	u8 (*status) (struct tpm_chip *chip);
>  	bool (*update_timeouts)(struct tpm_chip *chip,
>  				unsigned long *timeout_cap);
> +	bool (*update_durations)(struct tpm_chip *chip,
> +				unsigned long *duration_cap);

I don't think this callback makes sense if only TIS driver is using it.
You are fixing a simple problem with over engineered solution.

>  
>  };
>  
> -- 
> 1.9.1

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
