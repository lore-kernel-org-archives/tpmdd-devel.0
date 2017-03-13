From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: add sleep only for retry in
 i2c_nuvoton_write_status()
Date: Mon, 13 Mar 2017 10:54:22 -0400
Message-ID: <1489416862.28954.156.camel@linux.vnet.ibm.com>
References: <1489171554-6844-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1489171554-6844-2-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1489171554-6844-2-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-4.8" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko,

On Fri, 2017-03-10 at 13:45 -0500, Nayna Jain wrote:
> Currently, there is an unnecessary 1 msec delay added in
> i2c_nuvoton_write_status() for the successful case. This 
> function is called multiple times during send() and recv(),
> which implies adding multiple extra delays for every TPM
> operation.
> 
> This patch calls usleep_range() only if retry is to be done.
> 
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-4.8)
> Reviewed-by: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Either Reviewed-by/Acked-by is fine. 

Can you pick up this patch and replace the original version of "tpm:
msleep() delays - replace with usleep_range()" with the one Nayna
posted?

Thanks!

Mimi

> ---
>  drivers/char/tpm/tpm_i2c_nuvoton.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
> index 0c98c42..c642877 100644
> --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -124,8 +124,9 @@ static s32 i2c_nuvoton_write_status(struct i2c_client *client, u8 data)
>  	/* this causes the current command to be aborted */
>  	for (i = 0, status = -1; i < TPM_I2C_RETRY_COUNT && status < 0; i++) {
>  		status = i2c_nuvoton_write_buf(client, TPM_STS, 1, &data);
> -		usleep_range(TPM_I2C_BUS_DELAY, TPM_I2C_BUS_DELAY
> -			     + TPM_I2C_DELAY_RANGE);
> +		if (status < 0)
> +			usleep_range(TPM_I2C_BUS_DELAY, TPM_I2C_BUS_DELAY
> +				     + TPM_I2C_DELAY_RANGE);
>  	}
>  	return status;
>  }



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
