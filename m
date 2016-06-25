From: Andrew Zamansky <stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: Factor out common startup code
Date: Sat, 25 Jun 2016 09:07:11 +0200
Message-ID: <CADYxEtfgYqh-hrpz4WVRk3gUG+rFR+b-ue4u_ERpo8D-N_qaRA@mail.gmail.com>
References: <1466324401-5054-1-git-send-email-andrew.zamansky@nuvoton.com>
	<1466324401-5054-2-git-send-email-andrew.zamansky@nuvoton.com>
	<20160619123923.GA31053@intel.com>
	<20160620210757.GB11746@obsidianresearch.com>
	<20160622122227.GA27577@intel.com>
	<20160624181437.GB14506@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4793322833309813958=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160624181437.GB14506-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, azamansk-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============4793322833309813958==
Content-Type: multipart/alternative; boundary=047d7bb04bdab4a2dd053614efef

--047d7bb04bdab4a2dd053614efef
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

i hope that i will be able to test it next week .

thanks,
andrew

On 24 June 2016 at 20:14, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
wrote:

> On Wed, Jun 22, 2016 at 03:22:28PM +0300, Jarkko Sakkinen wrote:
> > The patch set used TPM2_OPS_PROBE_TPM2 only for nuvoton driver. The mor=
e
> > recent one used it incorrectly with tpm_tis.
>
> What do you think of this approach?
>
> https://github.com/jgunthorpe/linux/commits/for-andrew
>
> Andrew, does this work for you?
>
> From 73b0f273285ed512a259aa536968175fb14c3450 Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date: Fri, 24 Jun 2016 12:13:02 -0600
> Subject: [PATCH 2/2] tpm: Add TPM 2.0 support to the Nuvoton i2c driver
>  (NPCT6xx family)
>
> The command flow is exactly the same, the core simply needs to be
> told to enable TPM2 mode when the compatible string indicates a
> TPM2.
>
> Signed-off-by: Andrew Azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/i2c/trivial-devices.txt |  1 +
>  drivers/char/tpm/tpm_i2c_nuvoton.c                        | 13
> +++++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> index 539874490492..d4f654276cf9 100644
> --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> @@ -62,6 +62,7 @@ national,lm80         Serial Interface ACPI-Compatible
> Microprocessor System Hardware M
>  national,lm85          Temperature sensor with integrated fan control
>  national,lm92          =C2=B10.33=C2=B0C Accurate, 12-Bit + Sign Tempera=
ture Sensor
> and Thermal Window Comparator with Two-Wire Interface
>  nuvoton,npct501                i2c trusted platform module (TPM)
> +nuvoton,npct601                i2c trusted platform module (TPM2)
>  nxp,pca9556            Octal SMBus and I2C registered interface
>  nxp,pca9557            8-bit I2C-bus and SMBus I/O port with reset
>  nxp,pcf8563            Real-time clock/calendar
> diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c
> b/drivers/char/tpm/tpm_i2c_nuvoton.c
> index b64effcf3235..2bb6ac9a2695 100644
> --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -1,5 +1,5 @@
>
>  /***********************************************************************=
*******
> - * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,
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
>
>  /* I2C interface offsets */
> @@ -54,6 +55,8 @@
>
>  #define I2C_DRIVER_NAME "tpm_i2c_nuvoton"
>
> +#define OF_IS_TPM2 ((void *)1)
> +
>  struct priv_data {
>         unsigned int intrs;
>  };
> @@ -163,7 +166,7 @@ static int i2c_nuvoton_get_burstcount(struct
> i2c_client *client,
>  }
>
>  /*
> - * WPCT301/NPCT501 SINT# supports only dataAvail
> + * WPCT301/NPCT501/NPCT6XX SINT# supports only dataAvail
>   * any call to this function which is not waiting for dataAvail will
>   * set queue to NULL to avoid waiting for interrupt
>   */
> @@ -522,6 +525,7 @@ static int i2c_nuvoton_probe(struct i2c_client *clien=
t,
>         int rc;
>         struct tpm_chip *chip;
>         struct device *dev =3D &client->dev;
> +       const struct of_device_id *match;
>         u32 vid =3D 0;
>
>         rc =3D get_vid(client, &vid);
> @@ -535,6 +539,10 @@ static int i2c_nuvoton_probe(struct i2c_client
> *client,
>         if (IS_ERR(chip))
>                 return PTR_ERR(chip);
>
> +       match =3D of_match_device(dev->driver->of_device_id, dev);
> +       if (match && match->data =3D=3D OF_IS_TPM2)
> +               chip->flags |=3D TPM_CHIP_FLAG_TPM2;
> +
>         chip->vendor.priv =3D devm_kzalloc(dev, sizeof(struct priv_data),
>                                          GFP_KERNEL);
>         if (!chip->vendor.priv)
> @@ -623,6 +631,7 @@ MODULE_DEVICE_TABLE(i2c, i2c_nuvoton_id);
>  static const struct of_device_id i2c_nuvoton_of_match[] =3D {
>         {.compatible =3D "nuvoton,npct501"},
>         {.compatible =3D "winbond,wpct301"},
> +       {.compatible =3D "nuvoton,npct601", .data =3D OF_IS_TPM2},
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, i2c_nuvoton_of_match);
> --
> 2.1.4
>
>

--047d7bb04bdab4a2dd053614efef
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>i hope that i will be able to test it next week =
.<br><br></div>thanks,<br></div>andrew<br></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On 24 June 2016 at 20:14, Jason Gunthorpe <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" targ=
et=3D"_blank">jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org</a>&gt;</span> wrote:<br><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex">On Wed, Jun 22, 2016 at 03:22:28PM +0300, Jarkko=
 Sakkinen wrote:<br>
&gt; The patch set used TPM2_OPS_PROBE_TPM2 only for nuvoton driver. The mo=
re<br>
&gt; recent one used it incorrectly with tpm_tis.<br>
<br>
What do you think of this approach?<br>
<br>
<a href=3D"https://github.com/jgunthorpe/linux/commits/for-andrew" rel=3D"n=
oreferrer" target=3D"_blank">https://github.com/jgunthorpe/linux/commits/fo=
r-andrew</a><br>
<br>
Andrew, does this work for you?<br>
<br>
>From 73b0f273285ed512a259aa536968175fb14c3450 Mon Sep 17 00:00:00 2001<br>
From: Jason Gunthorpe &lt;<a href=3D"mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org=
">jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org</a>&gt;<br>
Date: Fri, 24 Jun 2016 12:13:02 -0600<br>
Subject: [PATCH 2/2] tpm: Add TPM 2.0 support to the Nuvoton i2c driver<br>
=C2=A0(NPCT6xx family)<br>
<br>
The command flow is exactly the same, the core simply needs to be<br>
told to enable TPM2 mode when the compatible string indicates a<br>
TPM2.<br>
<br>
Signed-off-by: Andrew Azmansky &lt;<a href=3D"mailto:andrew.zamansky@nuvoto=
n.com">andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org</a>&gt;<br>
Signed-off-by: Jason Gunthorpe &lt;<a href=3D"mailto:jgunthorpe@obsidianres=
earch.com">jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org</a>&gt;<br>
Acked-by: Rob Herring &lt;<a href=3D"mailto:robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org">robh-DgEjT+Ai2yhQFI55V6+gNQ@public.gmane.org=
g</a>&gt;<br>
---<br>
=C2=A0Documentation/devicetree/bindings/i2c/trivial-devices.txt |=C2=A0 1 +=
<br>
=C2=A0drivers/char/tpm/tpm_i2c_nuvoton.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 13 +++++++++++--<br>
=C2=A02 files changed, 12 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Do=
cumentation/devicetree/bindings/i2c/trivial-devices.txt<br>
index 539874490492..d4f654276cf9 100644<br>
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt<br>
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt<br>
@@ -62,6 +62,7 @@ national,lm80=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Serial Int=
erface ACPI-Compatible Microprocessor System Hardware M<br>
=C2=A0national,lm85=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Temperature sensor wi=
th integrated fan control<br>
=C2=A0national,lm92=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=B10.33=C2=B0C Acc=
urate, 12-Bit + Sign Temperature Sensor and Thermal Window Comparator with =
Two-Wire Interface<br>
=C2=A0nuvoton,npct501=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 i2c trusted platform module (TPM)<br>
+nuvoton,npct601=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i2c=
 trusted platform module (TPM2)<br>
=C2=A0nxp,pca9556=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Octal SMBus and =
I2C registered interface<br>
=C2=A0nxp,pca9557=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 8-bit I2C-bus an=
d SMBus I/O port with reset<br>
=C2=A0nxp,pcf8563=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Real-time clock/=
calendar<br>
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_=
nuvoton.c<br>
index b64effcf3235..2bb6ac9a2695 100644<br>
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c<br>
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c<br>
@@ -1,5 +1,5 @@<br>
=C2=A0/********************************************************************=
**********<br>
- * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,<br>
+ * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501/NPCT6XX,<br=
>
=C2=A0 * based on the TCG TPM Interface Spec version 1.2.<br>
=C2=A0 * Specifications at <a href=3D"http://www.trustedcomputinggroup.org"=
 rel=3D"noreferrer" target=3D"_blank">www.trustedcomputinggroup.org</a><br>
=C2=A0 *<br>
@@ -31,6 +31,7 @@<br>
=C2=A0#include &lt;linux/interrupt.h&gt;<br>
=C2=A0#include &lt;linux/wait.h&gt;<br>
=C2=A0#include &lt;linux/i2c.h&gt;<br>
+#include &lt;linux/of_device.h&gt;<br>
=C2=A0#include &quot;tpm.h&quot;<br>
<br>
=C2=A0/* I2C interface offsets */<br>
@@ -54,6 +55,8 @@<br>
<br>
=C2=A0#define I2C_DRIVER_NAME &quot;tpm_i2c_nuvoton&quot;<br>
<br>
+#define OF_IS_TPM2 ((void *)1)<br>
+<br>
=C2=A0struct priv_data {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int intrs;<br>
=C2=A0};<br>
@@ -163,7 +166,7 @@ static int i2c_nuvoton_get_burstcount(struct i2c_client=
 *client,<br>
=C2=A0}<br>
<br>
=C2=A0/*<br>
- * WPCT301/NPCT501 SINT# supports only dataAvail<br>
+ * WPCT301/NPCT501/NPCT6XX SINT# supports only dataAvail<br>
=C2=A0 * any call to this function which is not waiting for dataAvail will<=
br>
=C2=A0 * set queue to NULL to avoid waiting for interrupt<br>
=C2=A0 */<br>
@@ -522,6 +525,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int rc;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct tpm_chip *chip;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct device *dev =3D &amp;client-&gt;dev;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0const struct of_device_id *match;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u32 vid =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D get_vid(client, &amp;vid);<br>
@@ -535,6 +539,10 @@ static int i2c_nuvoton_probe(struct i2c_client *client=
,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(chip))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PTR_ERR(chip=
);<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0match =3D of_match_device(dev-&gt;driver-&gt;of=
_device_id, dev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (match &amp;&amp; match-&gt;data =3D=3D OF_I=
S_TPM2)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;flags |=3D=
 TPM_CHIP_FLAG_TPM2;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 chip-&gt;vendor.priv =3D devm_kzalloc(dev, size=
of(struct priv_data),<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0GF=
P_KERNEL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!chip-&gt;vendor.priv)<br>
@@ -623,6 +631,7 @@ MODULE_DEVICE_TABLE(i2c, i2c_nuvoton_id);<br>
=C2=A0static const struct of_device_id i2c_nuvoton_of_match[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {.compatible =3D &quot;nuvoton,npct501&quot;},<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {.compatible =3D &quot;winbond,wpct301&quot;},<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0{.compatible =3D &quot;nuvoton,npct601&quot;, .=
data =3D OF_IS_TPM2},<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {},<br>
=C2=A0};<br>
=C2=A0MODULE_DEVICE_TABLE(of, i2c_nuvoton_of_match);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.1.4<br>
<br>
</font></span></blockquote></div><br></div>

--047d7bb04bdab4a2dd053614efef--


--===============4793322833309813958==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
--===============4793322833309813958==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4793322833309813958==--
