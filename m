From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: fix cacheline alignment for DMA-able buffers
Date: Fri, 29 Jul 2016 11:27:02 -0600
Message-ID: <20160729172702.GB7020@obsidianresearch.com>
References: <1469761153-85576-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469761153-85576-1-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Christophe Ricard <christophe.ricard@gmail.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, dtor@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 28, 2016 at 07:59:13PM -0700, Andrey Pronin wrote:
> Annotate buffers used in spi transactions as ____cacheline_aligned
> to use in DMA transfers.
> 
> Signed-off-by: Andrey Pronin <apronin@chromium.org>
>  drivers/char/tpm/st33zp24/spi.c | 4 ++--
>  drivers/char/tpm/tpm_tis_spi.c  | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
> index 9f5a011..0e9aad9 100644
> +++ b/drivers/char/tpm/st33zp24/spi.c
> @@ -70,8 +70,8 @@
>  struct st33zp24_spi_phy {
>  	struct spi_device *spi_device;
>  
> -	u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE];
> -	u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE];
> +	u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline_aligned;
> +	u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline_aligned;
>  
>  	int io_lpcpd;
>  	int latency;

Hurm, this still looks wrong to me. Aligning the start of buffers is
not enough, the DMA'able space must also end on a cache line as well.

So, the buffers must also always be placed at the end of the struct.

IMHO It would be cleaner and safer to always kmalloc the DMA buffer
alone than to try and optimize like this.

Jason
