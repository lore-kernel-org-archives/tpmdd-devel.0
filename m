From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm tis: Do not print timeout
	messages twice
Date: Wed, 2 Nov 2016 04:26:17 -0600
Message-ID: <20161102102617.sxobs4madzsusgmt@intel.com>
References: <1477520926-32594-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477520926-32594-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 26, 2016 at 04:28:44PM -0600, Jason Gunthorpe wrote:
> The tis driver does a tpm_get_timeouts out side of tpm_chip_register,
> and tpm_get_timeouts can print a message, resulting in two prints, eg:
> 
>  tpm tpm0: [Hardware Error]: Adjusting reported timeouts: A 10000->750000us B 10000->2000000us C 10000->750000us D 10000->750000us
> 
> Keep track and prevent tpm_get_timeouts from running a second time, and
> clarify the purpose of the call in tpm_tis_core to only be connected to
> irq testing.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks for improving the comment. It makes a lot more sense now.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c |  7 +++++++
>  drivers/char/tpm/tpm.h           |  1 +
>  drivers/char/tpm/tpm_tis_core.c  | 20 ++++++++++----------
>  3 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index aef20ee2331a..d0285faa4f1b 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -505,6 +505,9 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  	struct duration_t *duration_cap;
>  	ssize_t rc;
>  
> +	if (chip->flags & TPM_CHIP_FLAG_HAVE_TIMEOUTS)
> +		return 0;
> +
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>  		/* Fixed timeouts for TPM2 */
>  		chip->timeout_a = msecs_to_jiffies(TPM2_TIMEOUT_A);
> @@ -517,6 +520,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  		    msecs_to_jiffies(TPM2_DURATION_MEDIUM);
>  		chip->duration[TPM_LONG] =
>  		    msecs_to_jiffies(TPM2_DURATION_LONG);
> +
> +		chip->flags |= TPM_CHIP_FLAG_HAVE_TIMEOUTS;
>  		return 0;
>  	}
>  
> @@ -630,6 +635,8 @@ duration:
>  		chip->duration_adjusted = true;
>  		dev_info(&chip->dev, "Adjusting TPM timeout parameters.");
>  	}
> +
> +	chip->flags |= TPM_CHIP_FLAG_HAVE_TIMEOUTS;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_get_timeouts);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index b0585e99da49..2611459271e5 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -143,6 +143,7 @@ enum tpm_chip_flags {
>  	TPM_CHIP_FLAG_TPM2		= BIT(1),
>  	TPM_CHIP_FLAG_IRQ		= BIT(2),
>  	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
> +	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= BIT(4),
>  };
>  
>  struct tpm_chip {
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index d66f51b3648e..193bee4d70e0 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -749,20 +749,20 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>  	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
>  		dev_dbg(dev, "\tData Avail Int Support\n");
>  
> -	/* Very early on issue a command to the TPM in polling mode to make
> -	 * sure it works. May as well use that command to set the proper
> -	 *  timeouts for the driver.
> -	 */
> -	if (tpm_get_timeouts(chip)) {
> -		dev_err(dev, "Could not get TPM timeouts and durations\n");
> -		rc = -ENODEV;
> -		goto out_err;
> -	}
> -
>  	/* INTERRUPT Setup */
>  	init_waitqueue_head(&priv->read_queue);
>  	init_waitqueue_head(&priv->int_queue);
>  	if (irq != -1) {
> +		/* Before doing irq testing issue a command to the TPM in polling mode
> +		 * to make sure it works. May as well use that command to set the
> +		 * proper timeouts for the driver.
> +		 */
> +		if (tpm_get_timeouts(chip)) {
> +			dev_err(dev, "Could not get TPM timeouts and durations\n");
> +			rc = -ENODEV;
> +			goto out_err;
> +		}
> +
>  		if (irq) {
>  			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
>  						 irq);
> -- 
> 2.1.4
> 

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
