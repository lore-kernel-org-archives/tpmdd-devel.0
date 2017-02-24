From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 3/5] tpm_tis_spi: Check correct byte for
 wait state indicator
Date: Fri, 24 Feb 2017 14:57:43 +0200
Message-ID: <20170224125743.dtiot3ygqstneve4@intel.com>
References: <1487261306-2494-1-git-send-email-peter.huewe@infineon.com>
	<1487261306-2494-4-git-send-email-peter.huewe@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487261306-2494-4-git-send-email-peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 16, 2017 at 04:08:24PM +0000, Peter Huewe wrote:
> Wait states are signaled in the last byte received from the TPM in
> response to the header, not the first byte. Check rx_buf[3] instead of
> rx_buf[0].
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>

Reviewed-by: Jarkko Sakkien <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm_tis_spi.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index d782b9974c14..16938e2253d2 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -60,7 +60,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u8 len,
>  				u8 *buffer, u8 direction)
>  {
>  	struct tpm_tis_spi_phy *phy = to_tpm_tis_spi_phy(data);
> -	int ret, i;
> +	int ret;
>  	struct spi_message m;
>  	struct spi_transfer spi_xfer = {
>  		.tx_buf = phy->tx_buf,
> @@ -85,25 +85,27 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u8 len,
>  	if (ret < 0)
>  		goto exit;
>  
> -	phy->tx_buf[0] = 0;
> -
> -	/* According to TCG PTP specification, if there is no TPM present at
> -	 * all, then the design has a weak pull-up on MISO. If a TPM is not
> -	 * present, a pull-up on MISO means that the SB controller sees a 1,
> -	 * and will latch in 0xFF on the read.
> -	 */
> -	for (i = 0; (phy->rx_buf[0] & 0x01) == 0 && i < TPM_RETRY; i++) {
> -		spi_xfer.len = 1;
> -		spi_message_init(&m);
> -		spi_message_add_tail(&spi_xfer, &m);
> -		ret = spi_sync_locked(phy->spi_device, &m);
> -		if (ret < 0)
> +	if ((phy->rx_buf[3] & 0x01) == 0) {
> +		// handle SPI wait states
> +		int i;
> +
> +		phy->tx_buf[0] = 0;
> +
> +		for (i = 0; i < TPM_RETRY; i++) {
> +			spi_xfer.len = 1;
> +			spi_message_init(&m);
> +			spi_message_add_tail(&spi_xfer, &m);
> +			ret = spi_sync_locked(phy->spi_device, &m);
> +			if (ret < 0)
> +				goto exit;
> +			if (phy->rx_buf[0] & 0x01)
> +				break;
> +		}
> +
> +		if (i == TPM_RETRY) {
> +			ret = -ETIMEDOUT;
>  			goto exit;
> -	}
> -
> -	if (i == TPM_RETRY) {
> -		ret = -ETIMEDOUT;
> -		goto exit;
> +		}
>  	}
>  
>  	spi_xfer.cs_change = 0;
> -- 
> 2.7.4
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
