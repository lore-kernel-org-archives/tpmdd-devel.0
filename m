From: Dmitry Torokhov <dtor@chromium.org>
Subject: Re: [PATCH v3 1/2] tpm_tis_core: add optional max xfer size check
Date: Thu, 28 Jul 2016 15:52:50 -0700
Message-ID: <20160728225250.GA28623@dtor-ws>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
 <1469677797-74304-2-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469677797-74304-2-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Christophe Ricard <christophe.ricard@gmail.com>, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 27, 2016 at 08:49:56PM -0700, Andrey Pronin wrote:
> If tpm reports a bigger burstcnt than allowed by the physical protocol,
> set burstcnt to the max allowed value.
> 
> In practice, seen in case of xfer issues (e.g. in spi interface case,
> lost header causing flow control issues and wrong values returned on read
> from TPM_STS). Without catching, causes the physical layer to reject xfer.
> 
> Signed-off-by: Andrey Pronin <apronin@chromium.org>
> ---
>  drivers/char/tpm/tpm_tis_core.c | 9 ++++++++-
>  drivers/char/tpm/tpm_tis_core.h | 1 +
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index f22caf8..7c4fa0c 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -168,8 +168,15 @@ static int get_burstcount(struct tpm_chip *chip)
>  			return rc;
>  
>  		burstcnt = (value >> 8) & 0xFFFF;
> -		if (burstcnt)
> +		if (burstcnt) {
> +			if (priv->phy_ops->max_xfer_size &&
> +			    (burstcnt > priv->phy_ops->max_xfer_size)) {

This does not actually need parentheses, otehrwise:

Reviewed-by: Dmitry Torokhov <dtor@chromium.org>

> +				dev_warn(&chip->dev,
> +					 "Bad burstcnt read: %d\n", burstcnt);
> +				burstcnt = priv->phy_ops->max_xfer_size;
> +			}
>  			return burstcnt;
> +		}
>  		msleep(TPM_TIMEOUT);
>  	} while (time_before(jiffies, stop));
>  	return -EBUSY;
> diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
> index 9191aab..58e8b14 100644
> --- a/drivers/char/tpm/tpm_tis_core.h
> +++ b/drivers/char/tpm/tpm_tis_core.h
> @@ -102,6 +102,7 @@ struct tpm_tis_phy_ops {
>  	int (*read16)(struct tpm_tis_data *data, u32 addr, u16 *result);
>  	int (*read32)(struct tpm_tis_data *data, u32 addr, u32 *result);
>  	int (*write32)(struct tpm_tis_data *data, u32 addr, u32 src);
> +	u16 max_xfer_size;
>  };
>  
>  static inline int tpm_tis_read_bytes(struct tpm_tis_data *data, u32 addr,
> -- 
> 2.6.6
> 

-- 
Dmitry
