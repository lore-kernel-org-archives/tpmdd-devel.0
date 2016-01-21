From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 1/4] New flags for TPM chip avoiding
 filesystem registrations
Date: Thu, 21 Jan 2016 10:07:32 +0200
Message-ID: <20160121080732.GA3889@intel.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-2-git-send-email-stefanb@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452787318-29610-2-git-send-email-stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 14, 2016 at 11:01:55AM -0500, Stefan Berger wrote:
> From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Introduce 2 new flags that prevent the registration of TPM devices
> with sysfs and securityfs. None of the exising devices set these flags.

Maybe a better name for this flag would be TPM_CHIP_FLAG_VIRTUAL to
better describe its use case because this covers more than just sysfs?

I can understand that for virtual devices you might want to disable
PPI but why you have to disable the other attributes?

PS. Is there any documentation of ibmvtpm hosted anywhere? I couldn't
find anything from Documentation/.

> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm-chip.c | 14 +++++++++-----
>  drivers/char/tpm/tpm.h      |  2 ++
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index fbd75c5..f2da376 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -182,11 +182,14 @@ static int tpm1_chip_register(struct tpm_chip *chip)
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		return 0;
>  
> -	rc = tpm_sysfs_add_device(chip);
> -	if (rc)
> -		return rc;
> +	if (!(chip->flags & TPM_CHIP_FLAG_NO_SYSFS)) {
> +		rc = tpm_sysfs_add_device(chip);
> +		if (rc)
> +			return rc;
> +	}
>  
> -	chip->bios_dir = tpm_bios_log_setup(chip->devname);
> +	if (!(chip->flags & TPM_CHIP_FLAG_NO_LOG))
> +		chip->bios_dir = tpm_bios_log_setup(chip->devname);
>  
>  	return 0;
>  }
> @@ -199,7 +202,8 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
>  	if (chip->bios_dir)
>  		tpm_bios_log_teardown(chip->bios_dir);
>  
> -	tpm_sysfs_del_device(chip);
> +	if (!(chip->flags & TPM_CHIP_FLAG_NO_SYSFS))
> +		tpm_sysfs_del_device(chip);
>  }
>  
>  /*
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index a4257a3..dfa755b 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -168,6 +168,8 @@ struct tpm_vendor_specific {
>  enum tpm_chip_flags {
>  	TPM_CHIP_FLAG_REGISTERED	= BIT(0),
>  	TPM_CHIP_FLAG_TPM2		= BIT(1),
> +	TPM_CHIP_FLAG_NO_SYSFS		= BIT(3),
> +	TPM_CHIP_FLAG_NO_LOG		= BIT(4),
>  };
>  
>  struct tpm_chip {
> -- 
> 2.4.3
> 

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
