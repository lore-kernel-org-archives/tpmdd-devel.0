From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm_tis: rename TPM_TIS_ITPM_POSSIBLE to
 TPM_TIS_ITPM_WORKAROUND
Date: Fri, 13 Jan 2017 17:51:31 +0200
Message-ID: <20170113155131.ohm5y5gv2ayn6pgy@intel.com>
References: <36b62240-e8c8-9cef-2052-e4e33a617bcf@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <36b62240-e8c8-9cef-2052-e4e33a617bcf@maciej.szmigiero.name>
Sender: linux-kernel-owner@vger.kernel.org
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Christophe Ricard <christophe.ricard@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 11:04:11PM +0100, Maciej S. Szmigiero wrote:
> Rename TPM_TIS_ITPM_POSSIBLE to TPM_TIS_ITPM_WORKAROUND since it gives a
> better idea what this flag actually does.
> 
> Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
> This needs "tpm_tis: fix iTPM probe via probe_itpm() function"
> applied first.
> 
>  drivers/char/tpm/tpm_tis.c      | 2 +-
>  drivers/char/tpm/tpm_tis_core.c | 8 ++++----
>  drivers/char/tpm/tpm_tis_core.h | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 0127af130cb1..7912dadc39be 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -159,7 +159,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  		irq = tpm_info->irq;
>  
>  	if (itpm)
> -		phy->priv.flags |= TPM_TIS_ITPM_POSSIBLE;
> +		phy->priv.flags |= TPM_TIS_ITPM_WORKAROUND;
>  
>  	return tpm_tis_core_init(dev, &phy->priv, irq, &tpm_tcg,
>  				 acpi_dev_handle);
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 401f1228547c..b6d2a6d474d2 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -264,7 +264,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
>  	int rc, status, burstcnt;
>  	size_t count = 0;
> -	bool itpm = priv->flags & TPM_TIS_ITPM_POSSIBLE;
> +	bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
>  
>  	if (request_locality(chip, 0) < 0)
>  		return -EBUSY;
> @@ -467,7 +467,7 @@ static int probe_itpm(struct tpm_chip *chip)
>  	size_t len = sizeof(cmd_getticks);
>  	u16 vendor;
>  
> -	if (priv->flags & TPM_TIS_ITPM_POSSIBLE)
> +	if (priv->flags & TPM_TIS_ITPM_WORKAROUND)
>  		return 0;
>  
>  	rc = tpm_tis_read16(priv, TPM_DID_VID(0), &vendor);
> @@ -485,13 +485,13 @@ static int probe_itpm(struct tpm_chip *chip)
>  	tpm_tis_ready(chip);
>  	release_locality(chip, priv->locality, 0);
>  
> -	priv->flags |= TPM_TIS_ITPM_POSSIBLE;
> +	priv->flags |= TPM_TIS_ITPM_WORKAROUND;
>  
>  	rc = tpm_tis_send_data(chip, cmd_getticks, len);
>  	if (rc == 0)
>  		dev_info(&chip->dev, "Detected an iTPM.\n");
>  	else {
> -		priv->flags &= ~TPM_TIS_ITPM_POSSIBLE;
> +		priv->flags &= ~TPM_TIS_ITPM_WORKAROUND;
>  		rc = -EFAULT;
>  	}
>  
> diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
> index 9191aabbf9c2..e2212f021a02 100644
> --- a/drivers/char/tpm/tpm_tis_core.h
> +++ b/drivers/char/tpm/tpm_tis_core.h
> @@ -80,7 +80,7 @@ enum tis_defaults {
>  #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
>  
>  enum tpm_tis_flags {
> -	TPM_TIS_ITPM_POSSIBLE		= BIT(0),
> +	TPM_TIS_ITPM_WORKAROUND		= BIT(0),
>  };
>  
>  struct tpm_tis_data {
> 
