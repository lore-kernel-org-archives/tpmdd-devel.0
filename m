From: Dmitry Torokhov <dtor@chromium.org>
Subject: Re: [PATCH v3 2/2] tpm_tis_spi: add max xfer size
Date: Thu, 28 Jul 2016 15:53:16 -0700
Message-ID: <20160728225316.GB28623@dtor-ws>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
 <1469677797-74304-3-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469677797-74304-3-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Christophe Ricard <christophe.ricard@gmail.com>, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 27, 2016 at 08:49:57PM -0700, Andrey Pronin wrote:
> Reject burstcounts larger than 64 bytes reported by tpm.
> SPI Hardware Protocol defined in section 6.4 of TCG PTP
> Spec supports up to 64 bytes of data in a transaction.
> 
> Signed-off-by: Andrey Pronin <apronin@chromium.org>

Reviewed-by: Dmitry Torokhov <dtor@chromium.org>

> ---
>  drivers/char/tpm/tpm_tis_spi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index dbaad9c..b103373 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -206,6 +206,7 @@ static const struct tpm_tis_phy_ops tpm_spi_phy_ops = {
>  	.read16 = tpm_tis_spi_read16,
>  	.read32 = tpm_tis_spi_read32,
>  	.write32 = tpm_tis_spi_write32,
> +	.max_xfer_size = MAX_SPI_FRAMESIZE,
>  };
>  
>  static int tpm_tis_spi_probe(struct spi_device *dev)
> -- 
> 2.6.6
> 

-- 
Dmitry
