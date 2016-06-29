From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2 v4] tpm: Add TPM 2.0 support to the Nuvoton i2c
 driver (NPCT6xx family)
Date: Wed, 29 Jun 2016 17:08:45 +0300
Message-ID: <20160629140845.GC4589@intel.com>
References: <1467186759-5149-1-git-send-email-andrew.zamansky@nuvoton.com>
 <1467186759-5149-3-git-send-email-andrew.zamansky@nuvoton.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467186759-5149-3-git-send-email-andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, azamansk-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jun 29, 2016 at 10:52:39AM +0300, andrew zamansky wrote:
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>=20
> The command flow is exactly the same, the core simply needs to be
> told to enable TPM2 mode when the compatible string indicates a
> TPM2.
>=20
> Signed-off-by: Andrew Azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Rob, should the change to device tree stuff be a separate patch and
would it be better if you would take that patch instead of me putting
into my tree?

Just want to prevent unnecessary conflicts. Thanks.

/jarkko

> ---
>  .../devicetree/bindings/i2c/trivial-devices.txt    |  1 +
>  drivers/char/tpm/tpm_i2c_nuvoton.c                 | 24 ++++++++++++=
+++++-----
>  2 files changed, 20 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.tx=
t b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> index 53987449..5a14ef8 100644
> --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> @@ -62,6 +62,7 @@ national,lm80		Serial Interface ACPI-Compatible Mic=
roprocessor System Hardware M
>  national,lm85		Temperature sensor with integrated fan control
>  national,lm92		=B10.33=B0C Accurate, 12-Bit + Sign Temperature Senso=
r and Thermal Window Comparator with Two-Wire Interface
>  nuvoton,npct501		i2c trusted platform module (TPM)
> +nuvoton,npct6xx		i2c trusted platform module (TPM2)
>  nxp,pca9556		Octal SMBus and I2C registered interface
>  nxp,pca9557		8-bit I2C-bus and SMBus I/O port with reset
>  nxp,pcf8563		Real-time clock/calendar
> diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tp=
m_i2c_nuvoton.c
> index e8ff362..5b7b459 100644
> --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -1,5 +1,5 @@
>  /*******************************************************************=
***********
> - * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,
> + * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501/NPCT6=
XX,
>   * based on the TCG TPM Interface Spec version 1.2.
>   * Specifications at www.trustedcomputinggroup.org
>   *
> @@ -31,6 +31,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/wait.h>
>  #include <linux/i2c.h>
> +#include <linux/of_device.h>
>  #include "tpm.h"
> =20
>  /* I2C interface offsets */
> @@ -52,7 +53,8 @@
>  #define TPM_I2C_RETRY_DELAY_SHORT      2       /* msec */
>  #define TPM_I2C_RETRY_DELAY_LONG       10      /* msec */
> =20
> -#define I2C_DRIVER_NAME "tpm_i2c_nuvoton"
> +#define OF_IS_TPM2 ((void *)1)
> +#define I2C_IS_TPM2 1
> =20
>  struct priv_data {
>  	int irq;
> @@ -165,7 +167,7 @@ static int i2c_nuvoton_get_burstcount(struct i2c_=
client *client,
>  }
> =20
>  /*
> - * WPCT301/NPCT501 SINT# supports only dataAvail
> + * WPCT301/NPCT501/NPCT6XX SINT# supports only dataAvail
>   * any call to this function which is not waiting for dataAvail will
>   * set queue to NULL to avoid waiting for interrupt
>   */
> @@ -545,6 +547,16 @@ static int i2c_nuvoton_probe(struct i2c_client *=
client,
>  	if (!priv)
>  		return -ENOMEM;
> =20
> +	if (dev->of_node) {
> +		const struct of_device_id *of_id;
> +
> +		of_id =3D of_match_device(dev->driver->of_device_id, dev);
> +		if (of_id && of_id->data =3D=3D OF_IS_TPM2)
> +			chip->flags |=3D TPM_CHIP_FLAG_TPM2;
> +	} else
> +		if (id->driver_data =3D=3D I2C_IS_TPM2)
> +			chip->flags |=3D TPM_CHIP_FLAG_TPM2;
> +
>  	init_waitqueue_head(&priv->read_queue);
> =20
>  	/* Default timeouts */
> @@ -622,7 +634,8 @@ static int i2c_nuvoton_remove(struct i2c_client *=
client)
>  }
> =20
>  static const struct i2c_device_id i2c_nuvoton_id[] =3D {
> -	{I2C_DRIVER_NAME, 0},
> +	{"tpm_i2c_nuvoton"},
> +	{"tpm2_i2c_nuvoton", .driver_data =3D I2C_IS_TPM2},
>  	{}
>  };
>  MODULE_DEVICE_TABLE(i2c, i2c_nuvoton_id);
> @@ -631,6 +644,7 @@ MODULE_DEVICE_TABLE(i2c, i2c_nuvoton_id);
>  static const struct of_device_id i2c_nuvoton_of_match[] =3D {
>  	{.compatible =3D "nuvoton,npct501"},
>  	{.compatible =3D "winbond,wpct301"},
> +	{.compatible =3D "nuvoton,npct6xx", .data =3D OF_IS_TPM2},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, i2c_nuvoton_of_match);
> @@ -643,7 +657,7 @@ static struct i2c_driver i2c_nuvoton_driver =3D {
>  	.probe =3D i2c_nuvoton_probe,
>  	.remove =3D i2c_nuvoton_remove,
>  	.driver =3D {
> -		.name =3D I2C_DRIVER_NAME,
> +		.name =3D "tpm_i2c_nuvoton",
>  		.pm =3D &i2c_nuvoton_pm_ops,
>  		.of_match_table =3D of_match_ptr(i2c_nuvoton_of_match),
>  	},
> --=20
> 1.9.1
>=20
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
