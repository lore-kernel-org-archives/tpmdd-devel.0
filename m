From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: constify transmit data pointers
Date: Thu, 7 Sep 2017 19:24:03 +0300
Message-ID: <20170907162403.4o3li6k74livw2bk@linux.intel.com>
References: <20170907133130.2463746-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170907133130.2463746-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Colin Ian King <colin.king@canonical.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 07, 2017 at 03:30:45PM +0200, Arnd Bergmann wrote:
> Making cmd_getticks 'const' introduced a couple of harmless warnings:
> 
> drivers/char/tpm/tpm_tis_core.c: In function 'probe_itpm':
> drivers/char/tpm/tpm_tis_core.c:469:31: error: passing argument 2 of 'tpm_tis_send_data' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
>   rc = tpm_tis_send_data(chip, cmd_getticks, len);
> drivers/char/tpm/tpm_tis_core.c:477:31: error: passing argument 2 of 'tpm_tis_send_data' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
>   rc = tpm_tis_send_data(chip, cmd_getticks, len);
> drivers/char/tpm/tpm_tis_core.c:255:12: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'const u8 * {aka const unsigned char *}'
>  static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
> 
> This changes the related functions to all take 'const' pointers
> so that gcc can see this as being correct. I had to slightly
> modify the logic around tpm_tis_spi_transfer() for this to work
> without introducing ugly casts.
> 
> Fixes: 5e35bd8e06b9 ("tpm_tis: make array cmd_getticks static const to shink object code size")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/char/tpm/tpm_tis.c      |  2 +-
>  drivers/char/tpm/tpm_tis_core.c |  4 ++--
>  drivers/char/tpm/tpm_tis_core.h |  4 ++--
>  drivers/char/tpm/tpm_tis_spi.c  | 25 +++++++++++--------------
>  4 files changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 7e55aa9ce680..ebd0e75a3e4d 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -223,7 +223,7 @@ static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
>  }
>  
>  static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
> -			       u8 *value)
> +			       const u8 *value)
>  {
>  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
>  
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 1e957e923d21..fdde971bc810 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -252,7 +252,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>   * tpm.c can skip polling for the data to be available as the interrupt is
>   * waited for here
>   */
> -static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
> +static int tpm_tis_send_data(struct tpm_chip *chip, const u8 *buf, size_t len)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
>  	int rc, status, burstcnt;
> @@ -343,7 +343,7 @@ static void disable_interrupts(struct tpm_chip *chip)
>   * tpm.c can skip polling for the data to be available as the interrupt is
>   * waited for here
>   */
> -static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
> +static int tpm_tis_send_main(struct tpm_chip *chip, const u8 *buf, size_t len)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
>  	int rc;
> diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
> index e2212f021a02..6bbac319ff3b 100644
> --- a/drivers/char/tpm/tpm_tis_core.h
> +++ b/drivers/char/tpm/tpm_tis_core.h
> @@ -98,7 +98,7 @@ struct tpm_tis_phy_ops {
>  	int (*read_bytes)(struct tpm_tis_data *data, u32 addr, u16 len,
>  			  u8 *result);
>  	int (*write_bytes)(struct tpm_tis_data *data, u32 addr, u16 len,
> -			   u8 *value);
> +			   const u8 *value);
>  	int (*read16)(struct tpm_tis_data *data, u32 addr, u16 *result);
>  	int (*read32)(struct tpm_tis_data *data, u32 addr, u32 *result);
>  	int (*write32)(struct tpm_tis_data *data, u32 addr, u32 src);
> @@ -128,7 +128,7 @@ static inline int tpm_tis_read32(struct tpm_tis_data *data, u32 addr,
>  }
>  
>  static inline int tpm_tis_write_bytes(struct tpm_tis_data *data, u32 addr,
> -				      u16 len, u8 *value)
> +				      u16 len, const u8 *value)
>  {
>  	return data->phy_ops->write_bytes(data, addr, len, value);
>  }
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index 88fe72ae967f..e49f5b9b739a 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -57,7 +57,7 @@ static inline struct tpm_tis_spi_phy *to_tpm_tis_spi_phy(struct tpm_tis_data *da
>  }
>  
>  static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
> -				u8 *buffer, u8 direction)
> +				u8 *in, const u8 *out)
>  {
>  	struct tpm_tis_spi_phy *phy = to_tpm_tis_spi_phy(data);
>  	int ret = 0;
> @@ -71,7 +71,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  	while (len) {
>  		transfer_len = min_t(u16, len, MAX_SPI_FRAMESIZE);
>  
> -		phy->tx_buf[0] = direction | (transfer_len - 1);
> +		phy->tx_buf[0] = (in ? 0x80 : 0) | (transfer_len - 1);
>  		phy->tx_buf[1] = 0xd4;
>  		phy->tx_buf[2] = addr >> 8;
>  		phy->tx_buf[3] = addr;
> @@ -112,14 +112,8 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  		spi_xfer.cs_change = 0;
>  		spi_xfer.len = transfer_len;
>  		spi_xfer.delay_usecs = 5;
> -
> -		if (direction) {
> -			spi_xfer.tx_buf = NULL;
> -			spi_xfer.rx_buf = buffer;
> -		} else {
> -			spi_xfer.tx_buf = buffer;
> -			spi_xfer.rx_buf = NULL;
> -		}
> +		spi_xfer.tx_buf = out;
> +		spi_xfer.rx_buf = in;
>  
>  		spi_message_init(&m);
>  		spi_message_add_tail(&spi_xfer, &m);
> @@ -128,7 +122,10 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  			goto exit;
>  
>  		len -= transfer_len;
> -		buffer += transfer_len;
> +		if (in)
> +			in += transfer_len;
> +		if (out)
> +			out += transfer_len;
>  	}
>  
>  exit:
> @@ -139,13 +136,13 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
>  static int tpm_tis_spi_read_bytes(struct tpm_tis_data *data, u32 addr,
>  				  u16 len, u8 *result)
>  {
> -	return tpm_tis_spi_transfer(data, addr, len, result, 0x80);
> +	return tpm_tis_spi_transfer(data, addr, len, result, NULL);
>  }
>  
>  static int tpm_tis_spi_write_bytes(struct tpm_tis_data *data, u32 addr,
> -				   u16 len, u8 *value)
> +				   u16 len, const u8 *value)
>  {
> -	return tpm_tis_spi_transfer(data, addr, len, value, 0);
> +	return tpm_tis_spi_transfer(data, addr, len, NULL, value);
>  }
>  
>  static int tpm_tis_spi_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
> -- 
> 2.9.0
> 

Thank you Arnd. Do you mind if squash this to Colin's commit and your
signed-off-by to that one?

/Jarkko
