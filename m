From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v1 1/2] tpm: msleep() delays - replace
 with usleep_range() in i2c nuvoton driver
Date: Fri, 17 Mar 2017 20:57:45 +0200
Message-ID: <20170317185745.rixx4rcmgoqy7sqe@intel.com>
References: <1489171554-6844-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489171554-6844-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-4.8" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

I replaced the patch.

/Jarkko

On Fri, Mar 10, 2017 at 01:45:53PM -0500, Nayna Jain wrote:
> Commit 500462a9de65 "timers: Switch to a non-cascading wheel" replaced
> the 'classic' timer wheel, which aimed for near 'exact' expiry of the
> timers.  Their analysis was that the vast majority of timeout timers
> are used as safeguards, not as real timers, and are cancelled or
> rearmed before expiration.  The only exception noted to this were
> networking timers with a small expiry time.
> 
> Not included in the analysis was the TPM polling timer, which resulted
> in a longer normal delay and, every so often, a very long delay.  The
> non-cascading wheel delay is based on CONFIG_HZ.  For a description of
> the different rings and their delays, refer to the comments in
> kernel/time/timer.c.
> 
> Below are the delays given for rings 0 - 2, which explains the longer
> "normal" delays and the very, long delays as seen on systems with
> CONFIG_HZ 250.
> 
> * HZ 1000 steps
>  * Level Offset  Granularity            Range
>  *  0      0         1 ms                0 ms - 63 ms
>  *  1     64         8 ms               64 ms - 511 ms
>  *  2    128        64 ms              512 ms - 4095 ms (512ms - ~4s)
> 
> * HZ  250
>  * Level Offset  Granularity            Range
>  *  0      0         4 ms                0 ms - 255 ms
>  *  1     64        32 ms              256 ms - 2047 ms (256ms - ~2s)
>  *  2    128       256 ms             2048 ms - 16383 ms (~2s - ~16s)
> 
> Below is a comparison of extending the TPM with 1000 measurements,
> using msleep() vs. usleep_delay() when configured for 1000 hz vs. 250
> hz, before and after commit 500462a9de65.
> 
> linux-4.7 | msleep() usleep_range()
> 1000 hz: 0m44.628s | 1m34.497s 29.243s
> 250 hz: 1m28.510s | 4m49.269s 32.386s
> 
> linux-4.7  | min-max (msleep)  min-max (usleep_range)
> 1000 hz: 0:017 - 2:760s | 0:015 - 3:967s    0:014 - 0:418s
> 250 hz: 0:028 - 1:954s | 0:040 - 4:096s    0:016 - 0:816s
> 
> This patch replaces the msleep() with usleep_range() calls in the
> i2c nuvoton driver with a consistent max range value.
> 
> Signed-of-by: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-4.8)
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
> Changelog v1:
> 
> - Included Jason's feedbacks related to #defines.
> 
>  drivers/char/tpm/tpm_i2c_nuvoton.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
> index e3a9155..0c98c42 100644
> --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -49,9 +49,10 @@
>   */
>  #define TPM_I2C_MAX_BUF_SIZE           32
>  #define TPM_I2C_RETRY_COUNT            32
> -#define TPM_I2C_BUS_DELAY              1       /* msec */
> -#define TPM_I2C_RETRY_DELAY_SHORT      2       /* msec */
> -#define TPM_I2C_RETRY_DELAY_LONG       10      /* msec */
> +#define TPM_I2C_BUS_DELAY              1000      	/* usec */
> +#define TPM_I2C_RETRY_DELAY_SHORT      (2 * 1000)	/* usec */
> +#define TPM_I2C_RETRY_DELAY_LONG       (10 * 1000) 	/* usec */
> +#define TPM_I2C_DELAY_RANGE            300		/* usec */
>  
>  #define OF_IS_TPM2 ((void *)1)
>  #define I2C_IS_TPM2 1
> @@ -123,7 +124,8 @@ static s32 i2c_nuvoton_write_status(struct i2c_client *client, u8 data)
>  	/* this causes the current command to be aborted */
>  	for (i = 0, status = -1; i < TPM_I2C_RETRY_COUNT && status < 0; i++) {
>  		status = i2c_nuvoton_write_buf(client, TPM_STS, 1, &data);
> -		msleep(TPM_I2C_BUS_DELAY);
> +		usleep_range(TPM_I2C_BUS_DELAY, TPM_I2C_BUS_DELAY
> +			     + TPM_I2C_DELAY_RANGE);
>  	}
>  	return status;
>  }
> @@ -160,7 +162,8 @@ static int i2c_nuvoton_get_burstcount(struct i2c_client *client,
>  			burst_count = min_t(u8, TPM_I2C_MAX_BUF_SIZE, data);
>  			break;
>  		}
> -		msleep(TPM_I2C_BUS_DELAY);
> +		usleep_range(TPM_I2C_BUS_DELAY, TPM_I2C_BUS_DELAY
> +			     + TPM_I2C_DELAY_RANGE);
>  	} while (time_before(jiffies, stop));
>  
>  	return burst_count;
> @@ -203,13 +206,17 @@ static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
>  			return 0;
>  
>  		/* use polling to wait for the event */
> -		ten_msec = jiffies + msecs_to_jiffies(TPM_I2C_RETRY_DELAY_LONG);
> +		ten_msec = jiffies + usecs_to_jiffies(TPM_I2C_RETRY_DELAY_LONG);
>  		stop = jiffies + timeout;
>  		do {
>  			if (time_before(jiffies, ten_msec))
> -				msleep(TPM_I2C_RETRY_DELAY_SHORT);
> +				usleep_range(TPM_I2C_RETRY_DELAY_SHORT,
> +					     TPM_I2C_RETRY_DELAY_SHORT
> +					     + TPM_I2C_DELAY_RANGE);
>  			else
> -				msleep(TPM_I2C_RETRY_DELAY_LONG);
> +				usleep_range(TPM_I2C_RETRY_DELAY_LONG,
> +					     TPM_I2C_RETRY_DELAY_LONG
> +					     + TPM_I2C_DELAY_RANGE);
>  			status_valid = i2c_nuvoton_check_status(chip, mask,
>  								value);
>  			if (status_valid)
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
