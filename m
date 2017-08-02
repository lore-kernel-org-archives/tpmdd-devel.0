From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] msleep() delays - replace with
 usleep_range() in TPM 1.2/2.0 generic drivers
Date: Wed, 2 Aug 2017 15:28:52 +0300
Message-ID: <20170802122852.jmtsihjd6k4ezems@linux.intel.com>
References: <20170726174642.GA16821@dev-HP-EliteBook-Folio-1040-G1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170726174642.GA16821@dev-HP-EliteBook-Folio-1040-G1>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Hamza Attak <hamza-ZPxbGqLxI0U@public.gmane.org>
Cc: ludo-ZPxbGqLxI0U@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, nigel.edwards-ZPxbGqLxI0U@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 26, 2017 at 06:46:42PM +0100, Hamza Attak wrote:
> The patch simply replaces all msleep function calls with usleep_range calls
> in the generic drivers.
> 
> Tested with an Infineon TPM 1.2, using the generic tpm-tis module, for a
> thousand PCR extends, we see results going from 1m57s unpatched to 40s
> with the new patch. We obtain similar results when using the original and
> patched tpm_infineon driver, which is also part of the patch.
> Similarly with a STM TPM 2.0, using the CRB driver, it takes about 20ms per
> extend unpatched and around 7ms with the new patch.
> 
> Note that the PCR consistency is untouched with this patch, each TPM has
> been tested with 10 million extends and the aggregated PCR value is
> continuously verified to be correct.
> 
> As an extension of this work, this could potentially and easily be applied
> to other vendor's drivers. Still, these changes are not included in the
> proposed patch as they are untested.
> 
> Signed-off-by: Hamza Attak <hamza-ZPxbGqLxI0U@public.gmane.org>

I think this would be a lot cleaner that we would have

void tpm_msleep(unsigned long msecs) function that would call usleep_range().

The change makes in high-level sense but the implementation makes the
driver code a mess.

> ---
>  drivers/char/tpm/tpm-interface.c | 18 +++++++++++-------
>  drivers/char/tpm/tpm.h           | 11 +++++++++--
>  drivers/char/tpm/tpm2-cmd.c      |  6 +++---
>  drivers/char/tpm/tpm_infineon.c  | 17 ++++++++++-------
>  drivers/char/tpm/tpm_tis_core.c  | 11 +++++++----
>  5 files changed, 40 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index bd2128e..95276d1 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -395,7 +395,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>  			goto out;
>  		}
>  
> -		msleep(TPM_TIMEOUT);	/* CHECK */
> +		usleep_range(TPM_TIMEOUT_US,
> +			     TPM_TIMEOUT_US + TPM_TIMEOUT_RANGE_US);
>  		rmb();
>  	} while (time_before(jiffies, stop));
>  
> @@ -836,13 +837,13 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  {
>  	int rc;
>  	unsigned int loops;
> -	unsigned int delay_msec = 100;
> +	unsigned int delay_usec = 100000;
>  	unsigned long duration;
>  	u8 dummy[TPM_DIGEST_SIZE];
>  
>  	duration = tpm_calc_ordinal_duration(chip, TPM_ORD_CONTINUE_SELFTEST);
>  
> -	loops = jiffies_to_msecs(duration) / delay_msec;
> +	loops = jiffies_to_usecs(duration) / delay_usec;
>  
>  	rc = tpm_continue_selftest(chip);
>  	/* This may fail if there was no TPM driver during a suspend/resume
> @@ -862,7 +863,8 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  			dev_info(
>  			    &chip->dev, HW_ERR
>  			    "TPM command timed out during continue self test");
> -			msleep(delay_msec);
> +			usleep_range(delay_usec,
> +				     delay_usec + TPM_TIMEOUT_RANGE_US);
>  			continue;
>  		}
>  
> @@ -877,7 +879,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  		}
>  		if (rc != TPM_WARN_DOING_SELFTEST)
>  			return rc;
> -		msleep(delay_msec);
> +		usleep_range(delay_usec, delay_usec + TPM_TIMEOUT_RANGE_US);
>  	} while (--loops > 0);
>  
>  	return rc;
> @@ -977,7 +979,8 @@ again:
>  		}
>  	} else {
>  		do {
> -			msleep(TPM_TIMEOUT);
> +			usleep_range(TPM_TIMEOUT_US,
> +				     TPM_TIMEOUT_US + TPM_TIMEOUT_RANGE_US);
>  			status = chip->ops->status(chip);
>  			if ((status & mask) == mask)
>  				return 0;
> @@ -1045,7 +1048,8 @@ int tpm_pm_suspend(struct device *dev)
>  		 */
>  		if (rc != TPM_WARN_RETRY)
>  			break;
> -		msleep(TPM_TIMEOUT_RETRY);
> +		usleep_range(TPM_TIMEOUT_RETRY_US,
> +			     TPM_TIMEOUT_RETRY_US + TPM_TIMEOUT_RANGE_US);
>  	}
>  
>  	if (rc)
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 4937b56..c1ace6c 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -45,8 +45,15 @@ enum tpm_const {
>  };
>  
>  enum tpm_timeout {
> -	TPM_TIMEOUT = 5,	/* msecs */
> -	TPM_TIMEOUT_RETRY = 100 /* msecs */
> +	TPM_TIMEOUT = 5,	  /* msecs */
> +	TPM_TIMEOUT_RETRY = 100,  /* msecs */
> +	/* Ideally all the drivers should be using the usecs values,
> +	 * the msecs values are only kept there for compatibility purposes
> +	 * with the remaining untested drivers.
> +	 */
> +	TPM_TIMEOUT_US = TPM_TIMEOUT * 1000,             /* usecs */
> +	TPM_TIMEOUT_RETRY_US = TPM_TIMEOUT_RETRY * 1000, /* usecs */
> +	TPM_TIMEOUT_RANGE_US = 300                       /* usecs */

These renames are not needed and the comment doesn't make any sense
when you have _US postfix. Just keep them in msecs and implement the
wrapper. The exception is of course the new constant
TPM_TIMEOUT_RANGE_US, which you need to implement tpm_msleep().

>  };
>  
>  /* TPM addresses */
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 881aea9..425caa4 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -930,14 +930,14 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>  {
>  	int rc;
>  	unsigned int loops;
> -	unsigned int delay_msec = 100;
> +	unsigned int delay_usec = 100000;
>  	unsigned long duration;
>  	struct tpm2_cmd cmd;
>  	int i;
>  
>  	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
>  
> -	loops = jiffies_to_msecs(duration) / delay_msec;
> +	loops = jiffies_to_usecs(duration) / delay_usec;
>  
>  	rc = tpm2_start_selftest(chip, true);
>  	if (rc)
> @@ -961,7 +961,7 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>  		if (rc != TPM2_RC_TESTING)
>  			break;
>  
> -		msleep(delay_msec);
> +		usleep_range(delay_usec, delay_usec + TPM_TIMEOUT_RANGE_US);
>  	}
>  
>  	return rc;
> diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
> index e3cf9f3..c9d2d13 100644
> --- a/drivers/char/tpm/tpm_infineon.c
> +++ b/drivers/char/tpm/tpm_infineon.c
> @@ -22,10 +22,10 @@
>  /* Infineon specific definitions */
>  /* maximum number of WTX-packages */
>  #define	TPM_MAX_WTX_PACKAGES 	50
> -/* msleep-Time for WTX-packages */
> -#define	TPM_WTX_MSLEEP_TIME 	20
> -/* msleep-Time --> Interval to check status register */
> -#define	TPM_MSLEEP_TIME 	3
> +/* usleep-Time for WTX-packages */
> +#define	TPM_WTX_USLEEP_TIME	(20 * 1000)
> +/* usleep-Time --> Interval to check status register */
> +#define	TPM_USLEEP_TIME		(3 * 1000)
>  /* gives number of max. msleep()-calls before throwing timeout */
>  #define	TPM_MAX_TRIES		5000
>  #define	TPM_INFINEON_DEV_VEN_VALUE	0x15D1
> @@ -191,7 +191,8 @@ static int wait(struct tpm_chip *chip, int wait_for_bit)
>  		/* check the status-register if wait_for_bit is set */
>  		if (status & 1 << wait_for_bit)
>  			break;
> -		msleep(TPM_MSLEEP_TIME);
> +		usleep_range(TPM_USLEEP_TIME,
> +			     TPM_USLEEP_TIME + TPM_TIMEOUT_RANGE_US);
>  	}
>  	if (i == TPM_MAX_TRIES) {	/* timeout occurs */
>  		if (wait_for_bit == STAT_XFE)
> @@ -226,7 +227,8 @@ static void tpm_wtx(struct tpm_chip *chip)
>  	wait_and_send(chip, TPM_CTRL_WTX);
>  	wait_and_send(chip, 0x00);
>  	wait_and_send(chip, 0x00);
> -	msleep(TPM_WTX_MSLEEP_TIME);
> +	usleep_range(TPM_WTX_USLEEP_TIME,
> +		     TPM_WTX_USLEEP_TIME + TPM_TIMEOUT_RANGE_US);
>  }
>  
>  static void tpm_wtx_abort(struct tpm_chip *chip)
> @@ -237,7 +239,8 @@ static void tpm_wtx_abort(struct tpm_chip *chip)
>  	wait_and_send(chip, 0x00);
>  	wait_and_send(chip, 0x00);
>  	number_of_wtx = 0;
> -	msleep(TPM_WTX_MSLEEP_TIME);
> +	usleep_range(TPM_WTX_USLEEP_TIME,
> +		     TPM_WTX_USLEEP_TIME + TPM_TIMEOUT_RANGE_US);
>  }
>  
>  static int tpm_inf_recv(struct tpm_chip *chip, u8 * buf, size_t count)
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index c0f296b..93e3233 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -51,7 +51,8 @@ static int wait_startup(struct tpm_chip *chip, int l)
>  
>  		if (access & TPM_ACCESS_VALID)
>  			return 0;
> -		msleep(TPM_TIMEOUT);
> +		usleep_range(TPM_TIMEOUT_US,
> +			     TPM_TIMEOUT_US + TPM_TIMEOUT_RANGE_US);
>  	} while (time_before(jiffies, stop));
>  	return -1;
>  }
> @@ -125,7 +126,8 @@ again:
>  		do {
>  			if (check_locality(chip, l) >= 0)
>  				return l;
> -			msleep(TPM_TIMEOUT);
> +			usleep_range(TPM_TIMEOUT_US,
> +				     TPM_TIMEOUT_US + TPM_TIMEOUT_RANGE_US);
>  		} while (time_before(jiffies, stop));
>  	}
>  	return -1;
> @@ -170,7 +172,8 @@ static int get_burstcount(struct tpm_chip *chip)
>  		burstcnt = (value >> 8) & 0xFFFF;
>  		if (burstcnt)
>  			return burstcnt;
> -		msleep(TPM_TIMEOUT);
> +		usleep_range(TPM_TIMEOUT_US,
> +			     TPM_TIMEOUT_US + TPM_TIMEOUT_RANGE_US);
>  	} while (time_before(jiffies, stop));
>  	return -EBUSY;
>  }
> @@ -408,7 +411,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  	priv->irq = irq;
>  	chip->flags |= TPM_CHIP_FLAG_IRQ;
>  	if (!priv->irq_tested)
> -		msleep(1);
> +		usleep_range(1000, 1000 + TPM_TIMEOUT_RANGE_US);
>  	if (!priv->irq_tested)
>  		disable_interrupts(chip);
>  	priv->irq_tested = true;
> -- 
> 2.7.4
> 

PS. Please add linux-kernel and linux-security-module to CCs for the
next version and thanks for working on this improvement.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
