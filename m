From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: Fix IRQ unwind ordering in TIS
Date: Thu, 28 Apr 2016 11:09:13 +0300
Message-ID: <1461830953.3482.1.camel@linux.intel.com>
References: <20160427165846.GA17064@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160427165846.GA17064@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2016-04-27 at 10:58 -0600, Jason Gunthorpe wrote:
> The devm for the IRQ was placed on the chip, not the pdev. This can
> cause the irq to be still callable after the pdev has been cleaned up
> (eg priv kfree'd).
>=C2=A0
> Found by CONFIG_DEBUG_SHIRQ=3Dy
>=C2=A0
> Reported-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> Fixes: 233a065e0cd0 ("tpm: Get rid of chip->pdev")
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Tested-by:=C2=A0=C2=A0Stefan Berger <stefanb@linux.vnet.ibm.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
> =C2=A0drivers/char/tpm/tpm_tis.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=C2=A0
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index a6b2d460bfc0..d88827046a42 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -387,7 +387,7 @@ static void disable_interrupts(struct tpm_chip *c=
hip)
> =C2=A0	intmask &=3D ~TPM_GLOBAL_INT_ENABLE;
> =C2=A0	iowrite32(intmask,
> =C2=A0		=C2=A0=C2=A0priv->iobase + TPM_INT_ENABLE(priv->locality));
> -	devm_free_irq(&chip->dev, priv->irq, chip);
> +	devm_free_irq(chip->dev.parent, priv->irq, chip);
> =C2=A0	priv->irq =3D 0;
> =C2=A0	chip->flags &=3D ~TPM_CHIP_FLAG_IRQ;
> =C2=A0}
> @@ -604,7 +604,7 @@ static int tpm_tis_probe_irq_single(struct tpm_ch=
ip *chip, u32
> intmask,
> =C2=A0	struct priv_data *priv =3D dev_get_drvdata(&chip->dev);
> =C2=A0	u8 original_int_vec;
> =C2=A0
> -	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
> +	if (devm_request_irq(chip->dev.parent, irq, tis_int_handler, flags,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dev_name(&chip->dev), chip) !=3D=
 0) {
> =C2=A0		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
> =C2=A0			=C2=A0irq);
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
