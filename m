From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 4/5] tpm_tis_spi: Remove limitation of
 transfers to MAX_SPI_FRAMESIZE bytes
Date: Fri, 24 Feb 2017 13:55:52 +0200
Message-ID: <20170224115552.rmg7ox2rneoz75yf@intel.com>
References: <1487261306-2494-1-git-send-email-peter.huewe@infineon.com>
	<1487261306-2494-5-git-send-email-peter.huewe@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487261306-2494-5-git-send-email-peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
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

On Thu, Feb 16, 2017 at 04:08:25PM +0000, Peter Huewe wrote:
> Limiting transfers to MAX_SPI_FRAMESIZE was not expected by the upper
> layers, as tpm_tis has no such limitation. Add a loop to hide that
> limitation.
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_tis_spi.c | 108 ++++++++++++++++++++++-------------------
>  1 file changed, 57 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index 16938e2253d2..b50c5b072df3 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -61,68 +61,74 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u8 len,
>  {
>  	struct tpm_tis_spi_phy *phy = to_tpm_tis_spi_phy(data);
>  	int ret;
> -	struct spi_message m;
> -	struct spi_transfer spi_xfer = {
> -		.tx_buf = phy->tx_buf,
> -		.rx_buf = phy->rx_buf,
> -		.len = 4,
> -		.cs_change = 1,
> -	};
> -
> -	if (len > MAX_SPI_FRAMESIZE)
> -		return -ENOMEM;
>  
> -	phy->tx_buf[0] = direction | (len - 1);
> -	phy->tx_buf[1] = 0xd4;
> -	phy->tx_buf[2] = addr >> 8;
> -	phy->tx_buf[3] = addr;
> +	spi_bus_lock(phy->spi_device->master);
>  
> -	spi_message_init(&m);
> -	spi_message_add_tail(&spi_xfer, &m);
> +	while (len) {
> +		struct spi_message m;
> +		struct spi_transfer spi_xfer = {
> +			.tx_buf = phy->tx_buf,
> +			.rx_buf = phy->rx_buf,
> +			.len = 4,
> +			.cs_change = 1,
> +		};

I like the habbit of keeping all the declarations in the beginning of
the function as we mostly have in the subsystem. It gives a fast view
what the function eats and how much stack it uses.

If you really think that declaring spi_xfer here is a good idea please
create a separate "helper" function for it.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
