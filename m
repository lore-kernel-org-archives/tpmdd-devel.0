From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3] tpm: Apply a sane minimum adapterlimit
 value for retransmission.
Date: Wed, 5 Apr 2017 16:37:24 +0300
Message-ID: <20170405133724.gfmyopgtpbrgycxl@intel.com>
References: <20170328152938.14539-1-enric.balletbo@collabora.com>
	<20170405090327.pssnm3mjcpajpoy6@intel.com>
	<384D02FC-BCCF-45F0-896D-058326EC6783@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <384D02FC-BCCF-45F0-896D-058326EC6783-Mmb7MZpHnFY@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Apr 05, 2017 at 12:05:32PM +0200, Peter Huewe wrote:
> 
> 
> Am 5. April 2017 11:03:27 MESZ schrieb Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:
> >On Tue, Mar 28, 2017 at 05:29:38PM +0200, Enric Balletbo i Serra wrote:
> >> From: Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >> 
> >> When the I2C Infineon part is attached to an I2C adapter that imposes
> >> a size limitation, large requests will fail with -EOPNOTSUPP. Retry
> >> them with a sane minimum size without re-issuing the 0x05 command
> >> as this appears to occasionally put the TPM in a bad state.
> >> 
> >> Signed-off-by: Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >> [rework the patch to adapt to the feedback received]
> >> Signed-off-by: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> >> ---
> >> This is a reworked version of the original patch based on the
> >> suggestion made by Wolfram Sang to simply fall back to a sane minimum
> >> when the maximum fails.
> >> 
> >> Changes since v2:
> >>  - Do not remove faster transfers when chip is SLB9645 (Peter Huewe)
> >>  - Remember the adapterlimit length once it fails to not generate
> >extra
> >>    i2c core messages (suggested by Andrew Lunn)
> >> Changes since v1:
> >>  - Check the correct return value (-EOPNOTSUPP instead of -EINVAL)
> >>  - Fall back len to I2C_SMBUS_BLOCK_MAX if fails.
> >> 
> >>  drivers/char/tpm/tpm_i2c_infineon.c | 76
> >+++++++++++++++++++++++++++----------
> >>  1 file changed, 56 insertions(+), 20 deletions(-)
> >> 
> >> diff --git a/drivers/char/tpm/tpm_i2c_infineon.c
> >b/drivers/char/tpm/tpm_i2c_infineon.c
> >> index 62ee44e..fdefcdb 100644
> >> --- a/drivers/char/tpm/tpm_i2c_infineon.c
> >> +++ b/drivers/char/tpm/tpm_i2c_infineon.c
> >> @@ -70,6 +70,7 @@ struct tpm_inf_dev {
> >>  	u8 buf[TPM_BUFSIZE + sizeof(u8)]; /* max. buffer size + addr */
> >>  	struct tpm_chip *chip;
> >>  	enum i2c_chip_type chip_type;
> >> +	unsigned int adapterlimit;
> >>  };
> >>  
> >>  static struct tpm_inf_dev tpm_dev;
> >> @@ -111,6 +112,7 @@ static int iic_tpm_read(u8 addr, u8 *buffer,
> >size_t len)
> >>  
> >>  	int rc = 0;
> >>  	int count;
> >> +	unsigned int msglen = len;
> >>  
> >>  	/* Lock the adapter for the duration of the whole sequence. */
> >>  	if (!tpm_dev.client->adapter->algo->master_xfer)
> >> @@ -131,27 +133,61 @@ static int iic_tpm_read(u8 addr, u8 *buffer,
> >size_t len)
> >>  			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
> >>  		}
> >>  	} else {
> >> -		/* slb9635 protocol should work in all cases */
> >> -		for (count = 0; count < MAX_COUNT; count++) {
> >> -			rc = __i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
> >> -			if (rc > 0)
> >> -				break;	/* break here to skip sleep */
> >> -
> >> -			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
> >> -		}
> >> -
> >> -		if (rc <= 0)
> >> -			goto out;
> >> -
> >> -		/* After the TPM has successfully received the register address
> >> -		 * it needs some time, thus we're sleeping here again, before
> >> -		 * retrieving the data
> >> +		/* Expect to send one command message and one data message, but
> >> +		 * support looping over each or both if necessary.
> >>  		 */
> >> -		for (count = 0; count < MAX_COUNT; count++) {
> >> -			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
> >> -			rc = __i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
> >> -			if (rc > 0)
> >> -				break;
> >> +		while (len > 0) {
> >> +			/* slb9635 protocol should work in all cases */
> >> +			for (count = 0; count < MAX_COUNT; count++) {
> >> +				rc = __i2c_transfer(tpm_dev.client->adapter,
> >> +						    &msg1, 1);
> >> +				if (rc > 0)
> >> +					break;	/* break here to skip sleep */
> >> +
> >> +				usleep_range(SLEEP_DURATION_LOW,
> >> +					     SLEEP_DURATION_HI);
> >> +			}
> >> +
> >> +			if (rc <= 0)
> >> +				goto out;
> >> +
> >> +			/* After the TPM has successfully received the register
> >> +			 * address it needs some time, thus we're sleeping here
> >> +			 * again, before retrieving the data
> >> +			 */
> >> +			for (count = 0; count < MAX_COUNT; count++) {
> >> +				if (tpm_dev.adapterlimit) {
> >> +					msglen = min_t(unsigned int,
> >> +						       tpm_dev.adapterlimit,
> >> +						       len);
> >> +					msg2.len = msglen;
> >> +				}
> >> +				usleep_range(SLEEP_DURATION_LOW,
> >> +					     SLEEP_DURATION_HI);
> >> +				rc = __i2c_transfer(tpm_dev.client->adapter,
> >> +						    &msg2, 1);
> >> +				if (rc > 0) {
> >> +					/* Since len is unsigned, make doubly
> >> +					 * sure we do not underflow it.
> >> +					 */
> >> +					if (msglen > len)
> >> +						len = 0;
> >> +					else
> >> +						len -= msglen;
> >> +					msg2.buf += msglen;
> >> +					break;
> >> +				}
> >> +				/* If the I2C adapter rejected the request (e.g
> >> +				 * when the quirk read_max_len < len) fall back
> >> +				 * to a sane minimum value and try again.
> >> +				 */
> >> +				if (rc == -EOPNOTSUPP)
> >> +					tpm_dev.adapterlimit =
> >> +							I2C_SMBUS_BLOCK_MAX;
> >> +			}
> >> +
> >> +			if (rc <= 0)
> >> +				goto out;
> >>  		}
> >>  	}
> >>  
> >> -- 
> >> 2.9.3
> >> 
> >
> >Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> >Peter, Andrew, anyone: Tested-by?
> >
> 
> Not yet, I'll put it on my list to test.
> Hopefully by next tuesday.
> Peter

Ok, thanks. I can push this to my master branch if that would help
to ease the testig?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
