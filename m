From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC PATCH] tpm: msleep() delays - replace with usleep_range()
 in i2c nuvoton driver
Date: Thu, 23 Feb 2017 17:00:51 -0700
Message-ID: <20170224000051.GB19131@obsidianresearch.com>
References: <1487893578.3193.155.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487893578.3193.155.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: tpmdd-devel <tpmdd-devel@lists.sourceforge.net>, linux-ima-devel <linux-ima-devel@lists.sourceforge.net>, linux-security-module <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dan Morav <dmorav@nuvoton.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 23, 2017 at 06:46:18PM -0500, Mimi Zohar wrote:
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
> 		linux-4.7 | msleep()	usleep_range()
> 1000 hz:	0m44.628s | 1m34.497s	29.243s
> 250 hz:		1m28.510s | 4m49.269s	32.386s
> 
> 		linux-4.7 	| min-max (msleep)  min-max (usleep_range)
> 1000 hz:	0:017 - 2:760s	| 0:015 - 3:967s    0:014 - 0:418s
> 250 hz:		0:028 - 1:954s	| 0:040 - 4:096s    0:016 - 0:816s
> 
> This patch replaces the msleep() with usleep_range() calls in the
> i2c nuvoton driver with a consistent max range value.
> 
> Signed-of-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Reviewed-by: Nayna Jain <nayna@linux.vnet.ibm.com>
>  drivers/char/tpm/tpm_i2c_nuvoton.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)

I wasn't aware of any of these, changes it but it makes sense to me..

> diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
> index e3a9155ee671..da2508a6bc0c 100644
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -49,9 +49,9 @@
>   */
>  #define TPM_I2C_MAX_BUF_SIZE           32
>  #define TPM_I2C_RETRY_COUNT            32
> -#define TPM_I2C_BUS_DELAY              1       /* msec */
> -#define TPM_I2C_RETRY_DELAY_SHORT      2       /* msec */
> -#define TPM_I2C_RETRY_DELAY_LONG       10      /* msec */
> +#define TPM_I2C_BUS_DELAY              1000      /* usec */
> +#define TPM_I2C_RETRY_DELAY_SHORT      2 * 1000  /* usec */
> +#define TPM_I2C_RETRY_DELAY_LONG       10 * 1000 /* usec */

While you are here could you put () around those #define expressions?

> -		msleep(TPM_I2C_BUS_DELAY);
> +		usleep_range(TPM_I2C_BUS_DELAY, TPM_I2C_BUS_DELAY + 300);

And we may as well have a constant for the 300 with a little
explanation comment that usleep_range is now required to get small
sleeps.

Jason
