From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] tpm_tis_spi: Use a single buffer
 for SPI transfers
Date: Fri, 25 Aug 2017 19:39:50 +0300
Message-ID: <20170825163950.bakf66k665nsbl3a@linux.intel.com>
References: <20170824082745.9372-1-Alexander.Steffen@infineon.com>
 <20170824082745.9372-3-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824082745.9372-3-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 24, 2017 at 10:27:45AM +0200, Alexander Steffen wrote:
> A single buffer is sufficient for both tx and rx, since bytes that have
> already been sent are not used anymore and can safely be overwritten with
> the received bytes.
> 
> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_tis_spi.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index 05ce841..5321245 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -46,9 +46,7 @@
>  struct tpm_tis_spi_phy {
>  	struct tpm_tis_data priv;
>  	struct spi_device *spi_device;
> -
> -	u8 *tx_buf;
> -	u8 *rx_buf;
> +	u8 *iobuf;
>  };
>  
>  static inline struct tpm_tis_spi_phy *to_tpm_tis_spi_phy(struct tpm_tis_data *data)
> @@ -71,14 +69,14 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  	while (len) {
>  		transfer_len = min_t(u16, len, MAX_SPI_FRAMESIZE);
>  
> -		phy->tx_buf[0] = direction | (transfer_len - 1);
> -		phy->tx_buf[1] = 0xd4;
> -		phy->tx_buf[2] = addr >> 8;
> -		phy->tx_buf[3] = addr;
> +		phy->iobuf[0] = direction | (transfer_len - 1);
> +		phy->iobuf[1] = 0xd4;
> +		phy->iobuf[2] = addr >> 8;
> +		phy->iobuf[3] = addr;
>  
>  		memset(&spi_xfer, 0, sizeof(spi_xfer));
> -		spi_xfer.tx_buf = phy->tx_buf;
> -		spi_xfer.rx_buf = phy->rx_buf;
> +		spi_xfer.tx_buf = phy->iobuf;
> +		spi_xfer.rx_buf = phy->iobuf;
>  		spi_xfer.len = 4;
>  		spi_xfer.cs_change = 1;
>  
> @@ -88,9 +86,9 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  		if (ret < 0)
>  			goto exit;
>  
> -		if ((phy->rx_buf[3] & 0x01) == 0) {
> +		if ((phy->iobuf[3] & 0x01) == 0) {
>  			// handle SPI wait states
> -			phy->tx_buf[0] = 0;
> +			phy->iobuf[0] = 0;
>  
>  			for (i = 0; i < TPM_RETRY; i++) {
>  				spi_xfer.len = 1;
> @@ -99,7 +97,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  				ret = spi_sync_locked(phy->spi_device, &m);
>  				if (ret < 0)
>  					goto exit;
> -				if (phy->rx_buf[0] & 0x01)
> +				if (phy->iobuf[0] & 0x01)
>  					break;
>  			}
>  
> @@ -117,7 +115,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  			spi_xfer.tx_buf = NULL;
>  		} else {
>  			spi_xfer.rx_buf = NULL;
> -			memcpy(phy->tx_buf, buffer, transfer_len);
> +			memcpy(phy->iobuf, buffer, transfer_len);
>  		}
>  
>  		spi_message_init(&m);
> @@ -127,7 +125,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  			goto exit;
>  
>  		if (direction)
> -			memcpy(buffer, phy->rx_buf, transfer_len);
> +			memcpy(buffer, phy->iobuf, transfer_len);
>  
>  		len -= transfer_len;
>  		buffer += transfer_len;
> @@ -196,12 +194,8 @@ static int tpm_tis_spi_probe(struct spi_device *dev)
>  
>  	phy->spi_device = dev;
>  
> -	phy->tx_buf = devm_kmalloc(&dev->dev, MAX_SPI_FRAMESIZE, GFP_KERNEL);
> -	if (!phy->tx_buf)
> -		return -ENOMEM;
> -
> -	phy->rx_buf = devm_kmalloc(&dev->dev, MAX_SPI_FRAMESIZE, GFP_KERNEL);
> -	if (!phy->rx_buf)
> +	phy->iobuf = devm_kmalloc(&dev->dev, MAX_SPI_FRAMESIZE, GFP_KERNEL);
> +	if (!phy->iobuf)
>  		return -ENOMEM;
>  
>  	return tpm_tis_core_init(&dev->dev, &phy->priv, -1, &tpm_spi_phy_ops,
> -- 
> 2.7.4
> 

Reviewed-by: Jarkko Sakkinen <jarkko.sakkine-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
