From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3] tpm: Apply a sane minimum adapterlimit value for
 retransmission.
Date: Fri, 31 Mar 2017 11:13:11 +0300
Message-ID: <20170331081311.cf55bpujvzgopbzw@intel.com>
References: <20170328152938.14539-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170328152938.14539-1-enric.balletbo@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Andrew Lunn <andrew@lunn.ch>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, wsa@the-dreams.de, Bryan Freed <bfreed@chromium.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Mar 28, 2017 at 05:29:38PM +0200, Enric Balletbo i Serra wrote:
> From: Bryan Freed <bfreed@chromium.org>
> 
> When the I2C Infineon part is attached to an I2C adapter that imposes
> a size limitation, large requests will fail with -EOPNOTSUPP. Retry
> them with a sane minimum size without re-issuing the 0x05 command
> as this appears to occasionally put the TPM in a bad state.
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
> [rework the patch to adapt to the feedback received]
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> ---
> This is a reworked version of the original patch based on the
> suggestion made by Wolfram Sang to simply fall back to a sane minimum
> when the maximum fails.
> 
> Changes since v2:
>  - Do not remove faster transfers when chip is SLB9645 (Peter Huewe)
>  - Remember the adapterlimit length once it fails to not generate extra
>    i2c core messages (suggested by Andrew Lunn)
> Changes since v1:
>  - Check the correct return value (-EOPNOTSUPP instead of -EINVAL)
>  - Fall back len to I2C_SMBUS_BLOCK_MAX if fails.
> 
>  drivers/char/tpm/tpm_i2c_infineon.c | 76 +++++++++++++++++++++++++++----------
>  1 file changed, 56 insertions(+), 20 deletions(-)

Looking into this after taking of the request for 4.12.

/Jarkko

> 
> diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
> index 62ee44e..fdefcdb 100644
> --- a/drivers/char/tpm/tpm_i2c_infineon.c
> +++ b/drivers/char/tpm/tpm_i2c_infineon.c
> @@ -70,6 +70,7 @@ struct tpm_inf_dev {
>  	u8 buf[TPM_BUFSIZE + sizeof(u8)]; /* max. buffer size + addr */
>  	struct tpm_chip *chip;
>  	enum i2c_chip_type chip_type;
> +	unsigned int adapterlimit;
>  };
>  
>  static struct tpm_inf_dev tpm_dev;
> @@ -111,6 +112,7 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
>  
>  	int rc = 0;
>  	int count;
> +	unsigned int msglen = len;
>  
>  	/* Lock the adapter for the duration of the whole sequence. */
>  	if (!tpm_dev.client->adapter->algo->master_xfer)
> @@ -131,27 +133,61 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
>  			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
>  		}
>  	} else {
> -		/* slb9635 protocol should work in all cases */
> -		for (count = 0; count < MAX_COUNT; count++) {
> -			rc = __i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
> -			if (rc > 0)
> -				break;	/* break here to skip sleep */
> -
> -			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
> -		}
> -
> -		if (rc <= 0)
> -			goto out;
> -
> -		/* After the TPM has successfully received the register address
> -		 * it needs some time, thus we're sleeping here again, before
> -		 * retrieving the data
> +		/* Expect to send one command message and one data message, but
> +		 * support looping over each or both if necessary.
>  		 */
> -		for (count = 0; count < MAX_COUNT; count++) {
> -			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
> -			rc = __i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
> -			if (rc > 0)
> -				break;
> +		while (len > 0) {
> +			/* slb9635 protocol should work in all cases */
> +			for (count = 0; count < MAX_COUNT; count++) {
> +				rc = __i2c_transfer(tpm_dev.client->adapter,
> +						    &msg1, 1);
> +				if (rc > 0)
> +					break;	/* break here to skip sleep */
> +
> +				usleep_range(SLEEP_DURATION_LOW,
> +					     SLEEP_DURATION_HI);
> +			}
> +
> +			if (rc <= 0)
> +				goto out;
> +
> +			/* After the TPM has successfully received the register
> +			 * address it needs some time, thus we're sleeping here
> +			 * again, before retrieving the data
> +			 */
> +			for (count = 0; count < MAX_COUNT; count++) {
> +				if (tpm_dev.adapterlimit) {
> +					msglen = min_t(unsigned int,
> +						       tpm_dev.adapterlimit,
> +						       len);
> +					msg2.len = msglen;
> +				}
> +				usleep_range(SLEEP_DURATION_LOW,
> +					     SLEEP_DURATION_HI);
> +				rc = __i2c_transfer(tpm_dev.client->adapter,
> +						    &msg2, 1);
> +				if (rc > 0) {
> +					/* Since len is unsigned, make doubly
> +					 * sure we do not underflow it.
> +					 */
> +					if (msglen > len)
> +						len = 0;
> +					else
> +						len -= msglen;
> +					msg2.buf += msglen;
> +					break;
> +				}
> +				/* If the I2C adapter rejected the request (e.g
> +				 * when the quirk read_max_len < len) fall back
> +				 * to a sane minimum value and try again.
> +				 */
> +				if (rc == -EOPNOTSUPP)
> +					tpm_dev.adapterlimit =
> +							I2C_SMBUS_BLOCK_MAX;
> +			}
> +
> +			if (rc <= 0)
> +				goto out;
>  		}
>  	}
>  
> -- 
> 2.9.3
> 
