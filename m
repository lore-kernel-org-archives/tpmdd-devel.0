From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2] tpm: Apply a sane minimum adapterlimit
 value for retransmission.
Date: Thu, 2 Mar 2017 14:55:43 +0200
Message-ID: <20170302125543.bsn7z5zkerabzh4u@intel.com>
References: <20170301153617.10106-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170301153617.10106-1-enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 01, 2017 at 04:36:17PM +0100, Enric Balletbo i Serra wrote:
> From: Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 
> When the I2C Infineon part is attached to an I2C adapter that imposes
> a size limitation, large requests will fail with -EOPNOTSUPP. Retry
> them with a sane minimum size without re-issuing the 0x05 command
> as this appears to occasionally put the TPM in a bad state.

What is 0x05 command?

/Jarkko

> Signed-off-by: Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> [rework the patch to adapt to the feedback received]
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> ---
> This is a reworked version of the original patch based on the
> suggestion made by Wolfram Sang to simply fall back to a sane minimum
> when the maximum fails.
> 
> Changes since v1:
>  - Check the correct return value (-EOPNOTSUPP instead of -EINVAL)
>  - Fall back len to I2C_SMBUS_BLOCK_MAX if fails.
> 
>  drivers/char/tpm/tpm_i2c_infineon.c | 45 +++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
> index 62ee44e..88bf947 100644
> --- a/drivers/char/tpm/tpm_i2c_infineon.c
> +++ b/drivers/char/tpm/tpm_i2c_infineon.c
> @@ -107,39 +107,27 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
>  		.len = len,
>  		.buf = buffer
>  	};
> -	struct i2c_msg msgs[] = {msg1, msg2};
>  
>  	int rc = 0;
>  	int count;
> +	unsigned int adapterlimit = len;
>  
>  	/* Lock the adapter for the duration of the whole sequence. */
>  	if (!tpm_dev.client->adapter->algo->master_xfer)
>  		return -EOPNOTSUPP;
>  	i2c_lock_adapter(tpm_dev.client->adapter);
>  
> -	if (tpm_dev.chip_type == SLB9645) {
> -		/* use a combined read for newer chips
> -		 * unfortunately the smbus functions are not suitable due to
> -		 * the 32 byte limit of the smbus.
> -		 * retries should usually not be needed, but are kept just to
> -		 * be on the safe side.
> -		 */
> -		for (count = 0; count < MAX_COUNT; count++) {
> -			rc = __i2c_transfer(tpm_dev.client->adapter, msgs, 2);
> -			if (rc > 0)
> -				break;	/* break here to skip sleep */
> -			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
> -		}
> -	} else {
> +	/* Expect to send one command message and one data message, but
> +	 * support looping over each or both if necessary.
> +	 */
> +	while (len > 0) {
>  		/* slb9635 protocol should work in all cases */
>  		for (count = 0; count < MAX_COUNT; count++) {
>  			rc = __i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
>  			if (rc > 0)
> -				break;	/* break here to skip sleep */
> -
> +				break;
>  			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
>  		}
> -
>  		if (rc <= 0)
>  			goto out;
>  
> @@ -148,11 +136,30 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
>  		 * retrieving the data
>  		 */
>  		for (count = 0; count < MAX_COUNT; count++) {
> +			unsigned int msglen = msg2.len =
> +					min_t(unsigned int, adapterlimit, len);
>  			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
>  			rc = __i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
> -			if (rc > 0)
> +			if (rc > 0) {
> +				/* Since len is unsigned, make doubly sure we
> +				 * do not underflow it.
> +				 */
> +				if (msglen > len)
> +					len = 0;
> +				else
> +					len -= msglen;
> +				msg2.buf += msglen;
>  				break;
> +			}
> +			/* If the I2C adapter rejected the request (e.g when
> +			 * the quirk read_max_len < len) fall back to a sane
> +			 * minimum value and try again.
> +			 */
> +			if (rc == -EOPNOTSUPP)
> +				adapterlimit = I2C_SMBUS_BLOCK_MAX;
>  		}
> +		if (rc <= 0)
> +			goto out;
>  	}
>  
>  out:
> -- 
> 2.9.3
> 
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
