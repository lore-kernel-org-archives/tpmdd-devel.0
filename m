From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] tpm: Add TPM 2.0 support to the
 Nuvoton i2c driver (NPCT6xx family)
Date: Mon, 18 Jul 2016 21:00:24 +0300
Message-ID: <20160718180024.GA22594@intel.com>
References: <1468345311-8014-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1468345311-8014-3-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468345311-8014-3-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 12, 2016 at 11:41:50AM -0600, Jason Gunthorpe wrote:
> The command flow is exactly the same, the core simply needs to be
> told to enable TPM2 mode when the compatible string indicates a
> TPM2.
> =

> Signed-off-by: Andrew Azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
> Tested-by: Andrew Zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

I've been on a vacation since last week and will be until Aug 8th.
That's why there might be some delay with code reviews.

/Jarkko

> ---
>  .../devicetree/bindings/i2c/trivial-devices.txt    |  1 +
>  drivers/char/tpm/tpm_i2c_nuvoton.c                 | 26 ++++++++++++++++=
+-----
>  2 files changed, 21 insertions(+), 6 deletions(-)
> =

> diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/=
Documentation/devicetree/bindings/i2c/trivial-devices.txt
> index 539874490492..d4f654276cf9 100644
> --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> @@ -62,6 +62,7 @@ national,lm80		Serial Interface ACPI-Compatible Micropr=
ocessor System Hardware M
>  national,lm85		Temperature sensor with integrated fan control
>  national,lm92		=B10.33=B0C Accurate, 12-Bit + Sign Temperature Sensor an=
d Thermal Window Comparator with Two-Wire Interface
>  nuvoton,npct501		i2c trusted platform module (TPM)
> +nuvoton,npct601		i2c trusted platform module (TPM2)
>  nxp,pca9556		Octal SMBus and I2C registered interface
>  nxp,pca9557		8-bit I2C-bus and SMBus I/O port with reset
>  nxp,pcf8563		Real-time clock/calendar
> diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2=
c_nuvoton.c
> index 6e404e0211dd..e3a9155ee671 100644
> --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -1,5 +1,5 @@
> -/***********************************************************************=
*******
> - * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,
> + /**********************************************************************=
********
> + * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501/NPCT6XX,
>   * based on the TCG TPM Interface Spec version 1.2.
>   * Specifications at www.trustedcomputinggroup.org
>   *
> @@ -31,6 +31,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/wait.h>
>  #include <linux/i2c.h>
> +#include <linux/of_device.h>
>  #include "tpm.h"
>  =

>  /* I2C interface offsets */
> @@ -52,7 +53,8 @@
>  #define TPM_I2C_RETRY_DELAY_SHORT      2       /* msec */
>  #define TPM_I2C_RETRY_DELAY_LONG       10      /* msec */
>  =

> -#define I2C_DRIVER_NAME "tpm_i2c_nuvoton"
> +#define OF_IS_TPM2 ((void *)1)
> +#define I2C_IS_TPM2 1
>  =

>  struct priv_data {
>  	int irq;
> @@ -165,7 +167,7 @@ static int i2c_nuvoton_get_burstcount(struct i2c_clie=
nt *client,
>  }
>  =

>  /*
> - * WPCT301/NPCT501 SINT# supports only dataAvail
> + * WPCT301/NPCT501/NPCT6XX SINT# supports only dataAvail
>   * any call to this function which is not waiting for dataAvail will
>   * set queue to NULL to avoid waiting for interrupt
>   */
> @@ -545,6 +547,16 @@ static int i2c_nuvoton_probe(struct i2c_client *clie=
nt,
>  	if (!priv)
>  		return -ENOMEM;
>  =

> +	if (dev->of_node) {
> +		const struct of_device_id *of_id;
> +
> +		of_id =3D of_match_device(dev->driver->of_match_table, dev);
> +		if (of_id && of_id->data =3D=3D OF_IS_TPM2)
> +			chip->flags |=3D TPM_CHIP_FLAG_TPM2;
> +	} else
> +		if (id->driver_data =3D=3D I2C_IS_TPM2)
> +			chip->flags |=3D TPM_CHIP_FLAG_TPM2;
> +
>  	init_waitqueue_head(&priv->read_queue);
>  =

>  	/* Default timeouts */
> @@ -620,7 +632,8 @@ static int i2c_nuvoton_remove(struct i2c_client *clie=
nt)
>  }
>  =

>  static const struct i2c_device_id i2c_nuvoton_id[] =3D {
> -	{I2C_DRIVER_NAME, 0},
> +	{"tpm_i2c_nuvoton"},
> +	{"tpm2_i2c_nuvoton", .driver_data =3D I2C_IS_TPM2},
>  	{}
>  };
>  MODULE_DEVICE_TABLE(i2c, i2c_nuvoton_id);
> @@ -629,6 +642,7 @@ MODULE_DEVICE_TABLE(i2c, i2c_nuvoton_id);
>  static const struct of_device_id i2c_nuvoton_of_match[] =3D {
>  	{.compatible =3D "nuvoton,npct501"},
>  	{.compatible =3D "winbond,wpct301"},
> +	{.compatible =3D "nuvoton,npct601", .data =3D OF_IS_TPM2},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, i2c_nuvoton_of_match);
> @@ -641,7 +655,7 @@ static struct i2c_driver i2c_nuvoton_driver =3D {
>  	.probe =3D i2c_nuvoton_probe,
>  	.remove =3D i2c_nuvoton_remove,
>  	.driver =3D {
> -		.name =3D I2C_DRIVER_NAME,
> +		.name =3D "tpm_i2c_nuvoton",
>  		.pm =3D &i2c_nuvoton_pm_ops,
>  		.of_match_table =3D of_match_ptr(i2c_nuvoton_of_match),
>  	},
> -- =

> 2.1.4
> =


---------------------------------------------------------------------------=
---
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols ar=
e =

consuming the most bandwidth. Provides multi-vendor support for NetFlow, =

J-Flow, sFlow and other flows. Make informed decisions using capacity plann=
ing
reports.http://sdm.link/zohodev2dev
