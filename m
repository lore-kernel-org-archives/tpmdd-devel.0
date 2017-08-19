From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm_tis_spi: Use DMA-safe memory for SPI transfers
Date: Sat, 19 Aug 2017 20:12:07 +0300
Message-ID: <20170819171207.npq6ogm2v2oai5si@linux.intel.com>
References: <20170818121457.10084-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170818121457.10084-1-Alexander.Steffen@infineon.com>
Sender: stable-owner@vger.kernel.org
To: Alexander Steffen <Alexander.Steffen@infineon.com>
Cc: tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Aug 18, 2017 at 02:14:57PM +0200, Alexander Steffen wrote:
> The buffers used as tx_buf/rx_buf in a SPI transfer need to be DMA-safe.
> This cannot be guaranteed for the buffers passed to tpm_tis_spi_read_bytes
> and tpm_tis_spi_write_bytes. Therefore, we need to use our own DMA-safe
> buffer and copy the data to/from it.
> 
> A single buffer is sufficient for both tx and rx, since bytes that have
> already been sent are not used anymore and can safely be overwritten with
> the received bytes. The buffer needs to be allocated separately, to ensure
> that it is cacheline-aligned and not shared with other data, so that DMA
> can work correctly.
> 
> Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>

90% of this patch is about merging the buffers and 10% is the bug fix
that you even want to stable, right?

So please create a patch that does the fix without merging the buffers.
In this form this is pain to backport to stable.

/Jarkko

> ---
> v2: Updated commit message with more explanations.
> 
>  drivers/char/tpm/tpm_tis_spi.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index 88fe72a..5321245 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -46,9 +46,7 @@
>  struct tpm_tis_spi_phy {
>  	struct tpm_tis_data priv;
>  	struct spi_device *spi_device;
> -
> -	u8 tx_buf[4];
> -	u8 rx_buf[4];
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
> @@ -115,10 +113,9 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  
>  		if (direction) {
>  			spi_xfer.tx_buf = NULL;
> -			spi_xfer.rx_buf = buffer;
>  		} else {
> -			spi_xfer.tx_buf = buffer;
>  			spi_xfer.rx_buf = NULL;
> +			memcpy(phy->iobuf, buffer, transfer_len);
>  		}
>  
>  		spi_message_init(&m);
> @@ -127,6 +124,9 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  		if (ret < 0)
>  			goto exit;
>  
> +		if (direction)
> +			memcpy(buffer, phy->iobuf, transfer_len);
> +
>  		len -= transfer_len;
>  		buffer += transfer_len;
>  	}
> @@ -194,6 +194,10 @@ static int tpm_tis_spi_probe(struct spi_device *dev)
>  
>  	phy->spi_device = dev;
>  
> +	phy->iobuf = devm_kmalloc(&dev->dev, MAX_SPI_FRAMESIZE, GFP_KERNEL);
> +	if (!phy->iobuf)
> +		return -ENOMEM;
> +
>  	return tpm_tis_core_init(&dev->dev, &phy->priv, -1, &tpm_spi_phy_ops,
>  				 NULL);
>  }
> -- 
> 2.7.4
> 
