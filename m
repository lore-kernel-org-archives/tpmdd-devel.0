From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 4/4] tpm: add the infrastructure for
 TPM	space for TPM 2.0
Date: Wed, 4 Jan 2017 12:50:21 -0500
Message-ID: <OF9C3EE9AE.65978870-ON0025809E.0061E7AF-8525809E.0061FFDA@notes.na.collabserv.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-5-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3484087515824621499=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170102132213.22880-5-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============3484087515824621499==
Content-Type: multipart/alternative;
	boundary="=_alternative 0061FFDA8525809E_="


--=_alternative 0061FFDA8525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/02/2017=20
08:22:10 AM:

>=20
> Added a ioctl for creating a TPM space. The space is isolated from the
> other users of the TPM. Only a process holding the file with the handle
> can access the objects and only objects that are created through that
> file handle can be accessed.
>=20
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---

> diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
> index 912ad30..139638b 100644
> --- a/drivers/char/tpm/tpm-dev.c
> +++ b/drivers/char/tpm/tpm-dev.c
> @@ -19,6 +19,7 @@
>   */
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <uapi/linux/tpm.h>
>  #include "tpm.h"
>=20
>  struct file=5Fpriv {
> @@ -32,6 +33,8 @@ struct file=5Fpriv {
>     struct work=5Fstruct work;
>=20
>     u8 data=5Fbuffer[TPM=5FBUFSIZE];
> +   struct tpm=5Fspace space;
> +   bool has=5Fspace;
>  };
>=20
>  static void user=5Freader=5Ftimeout(unsigned long ptr)
> @@ -115,6 +118,7 @@ static ssize=5Ft tpm=5Fwrite(struct file *file,=20
> const char =5F=5Fuser *buf,
>            size=5Ft size, loff=5Ft *off)
>  {
>     struct file=5Fpriv *priv =3D file->private=5Fdata;
> +   struct tpm=5Fspace *space =3D NULL;
>     size=5Ft in=5Fsize =3D size;
>     ssize=5Ft out=5Fsize;
>=20
> @@ -130,6 +134,9 @@ static ssize=5Ft tpm=5Fwrite(struct file *file,=20
> const char =5F=5Fuser *buf,
>=20
>     mutex=5Flock(&priv->buffer=5Fmutex);
>=20
> +   if (priv->has=5Fspace)
> +      space =3D &priv->space;
> +
>     if (copy=5Ffrom=5Fuser
>         (priv->data=5Fbuffer, (void =5F=5Fuser *) buf, in=5Fsize)) {
>        mutex=5Funlock(&priv->buffer=5Fmutex);
> @@ -144,7 +151,7 @@ static ssize=5Ft tpm=5Fwrite(struct file *file,=20
> const char =5F=5Fuser *buf,
>        mutex=5Funlock(&priv->buffer=5Fmutex);
>        return -EPIPE;
>     }
> -   out=5Fsize =3D tpm=5Ftransmit(priv->chip, priv->data=5Fbuffer,
> +   out=5Fsize =3D tpm=5Ftransmit(priv->chip, space, priv->data=5Fbuffer,
>              sizeof(priv->data=5Fbuffer), 0);
>=20
>     tpm=5Fput=5Fops(priv->chip);
> @@ -162,6 +169,65 @@ static ssize=5Ft tpm=5Fwrite(struct file *file,=20
> const char =5F=5Fuser *buf,
>     return in=5Fsize;
>  }
>=20
> +/**
> + * tpm=5Fioc=5Fnew=5Fspace - handler for %SGX=5FIOC=5FNEW=5FSPACE ioctl
> + *
> + * Creates a new TPM space that can hold a set of transient=20
> objects. The space
> + * is isolated with virtual handles that are mapped into physical=20
> handles by the
> + * driver.
> + */
> +static long tpm=5Fioc=5Fnew=5Fspace(struct file *file, unsigned int ioct=
l,
> +               unsigned long arg)
> +{
> +   struct file=5Fpriv *priv =3D file->private=5Fdata;
> +   struct tpm=5Fchip *chip =3D priv->chip;
> +   int rc =3D 0;
> +
> +   if (!(chip->flags & TPM=5FCHIP=5FFLAG=5FTPM2))
> +      return -EOPNOTSUPP;
> +
> +   mutex=5Flock(&priv->buffer=5Fmutex);
> +
> +   if (priv->has=5Fspace) {
> +      rc =3D -EBUSY;
> +      goto out;
> +   }
> +
> +   priv->space.context=5Fbuf =3D kzalloc(PAGE=5FSIZE, GFP=5FKERNEL);
> +   if (!priv->space.context=5Fbuf) {
> +      rc =3D -ENOMEM;
> +      goto out;
> +   }
> +
> +   /* The TPM device can be opened again as this file has been moved to =

a
> +    * TPM handle space.
> +    */
> +   priv->has=5Fspace =3D true;
> +   clear=5Fbit(0, &chip->is=5Fopen);
> +out:
> +   mutex=5Funlock(&priv->buffer=5Fmutex);
> +   return rc;
> +}
> +
> +static long tpm=5Fioctl(struct file *file, unsigned int ioctl,
> +            unsigned long arg)
> +{
> +   switch (ioctl) {
> +   case TPM=5FIOC=5FNEW=5FSPACE:
> +      return tpm=5Fioc=5Fnew=5Fspace(file, ioctl, arg);
> +   default:
> +      return -ENOIOCTLCMD;
> +   }
> +}
> +
> +#ifdef CONFIG=5FCOMPAT
> +static long tpm=5Fcompat=5Fioctl(struct file *file, unsigned int ioctl,
> +              unsigned long arg)
> +{
> +   return tpm=5Fioctl(file, ioctl, arg);
> +}
> +#endif
> +
>  /*
>   * Called on file close
>   */
> @@ -169,6 +235,14 @@ static int tpm=5Frelease(struct inode *inode,=20
> struct file *file)
>  {
>     struct file=5Fpriv *priv =3D file->private=5Fdata;
>=20
> +   if (tpm=5Ftry=5Fget=5Fops(priv->chip)) {
> +      mutex=5Funlock(&priv->buffer=5Fmutex);
> +      return -EPIPE;
> +   }


That mutex=5Funlock looks wrong.

   Stefan


--=_alternative 0061FFDA8525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 01/02/2017 08:22:10 AM:<br><br>&gt; <br>&gt; Added a ioctl for cre=
ating a TPM space. The space is isolated from
the<br>&gt; other users of the TPM. Only a process holding the file with th=
e handle<br>&gt; can access the objects and only objects that are created t=
hrough that<br>&gt; file handle can be accessed.<br>&gt; <br>&gt; Signed-of=
f-by: Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;<br>&gt; ---<b=
r><br>&gt; diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-d=
ev.c<br>&gt; index 912ad30..139638b 100644<br>&gt; --- a/drivers/char/tpm/t=
pm-dev.c<br>&gt; +++ b/drivers/char/tpm/tpm-dev.c<br>&gt; @@ -19,6 +19,7 @@=
<br>&gt; &nbsp; */<br>&gt; &nbsp;#include &lt;linux/slab.h&gt;<br>&gt; &nbs=
p;#include &lt;linux/uaccess.h&gt;<br>&gt; +#include &lt;uapi/linux/tpm.h&g=
t;<br>&gt; &nbsp;#include &quot;tpm.h&quot;<br>&gt; &nbsp;<br>&gt; &nbsp;st=
ruct file=5Fpriv {<br>&gt; @@ -32,6 +33,8 @@ struct file=5Fpriv {<br>&gt; &=
nbsp; &nbsp; struct work=5Fstruct work;<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp=
; u8 data=5Fbuffer[TPM=5FBUFSIZE];<br>&gt; + &nbsp; struct tpm=5Fspace spac=
e;<br>&gt; + &nbsp; bool has=5Fspace;<br>&gt; &nbsp;};<br>&gt; &nbsp;<br>&g=
t; &nbsp;static void user=5Freader=5Ftimeout(unsigned long ptr)<br>&gt; @@ =
-115,6 +118,7 @@ static ssize=5Ft tpm=5Fwrite(struct file *file, <br>&gt; c=
onst char =5F=5Fuser *buf,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;size=5Ft size, loff=5Ft *off)<br>&gt; &nbsp;{<br>&gt; &nbsp; &nbsp; struct=
 file=5Fpriv *priv =3D file-&gt;private=5Fdata;<br>&gt; + &nbsp; struct tpm=
=5Fspace *space =3D NULL;<br>&gt; &nbsp; &nbsp; size=5Ft in=5Fsize =3D size=
;<br>&gt; &nbsp; &nbsp; ssize=5Ft out=5Fsize;<br>&gt; &nbsp;<br>&gt; @@ -13=
0,6 +134,9 @@ static ssize=5Ft tpm=5Fwrite(struct file *file, <br>&gt; cons=
t char =5F=5Fuser *buf,<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; mutex=5Flock(&=
amp;priv-&gt;buffer=5Fmutex);<br>&gt; &nbsp;<br>&gt; + &nbsp; if (priv-&gt;=
has=5Fspace)<br>&gt; + &nbsp; &nbsp; &nbsp;space =3D &amp;priv-&gt;space;<b=
r>&gt; +<br>&gt; &nbsp; &nbsp; if (copy=5Ffrom=5Fuser<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; (priv-&gt;data=5Fbuffer, (void =5F=5Fuser *)
buf, in=5Fsize)) {<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;mutex=5Funlock(&amp;p=
riv-&gt;buffer=5Fmutex);<br>&gt; @@ -144,7 +151,7 @@ static ssize=5Ft tpm=
=5Fwrite(struct file *file, <br>&gt; const char =5F=5Fuser *buf,<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp;mutex=5Funlock(&amp;priv-&gt;buffer=5Fmutex);<br>&=
gt; &nbsp; &nbsp; &nbsp; &nbsp;return -EPIPE;<br>&gt; &nbsp; &nbsp; }<br>&g=
t; - &nbsp; out=5Fsize =3D tpm=5Ftransmit(priv-&gt;chip, priv-&gt;data=5Fbu=
ffer,<br>&gt; + &nbsp; out=5Fsize =3D tpm=5Ftransmit(priv-&gt;chip, space, =
priv-&gt;data=5Fbuffer,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp;sizeof(priv-&gt;data=5Fbuffer),
0);<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; tpm=5Fput=5Fops(priv-&gt;chip);<br=
>&gt; @@ -162,6 +169,65 @@ static ssize=5Ft tpm=5Fwrite(struct file *file, =
<br>&gt; const char =5F=5Fuser *buf,<br>&gt; &nbsp; &nbsp; return in=5Fsize=
;<br>&gt; &nbsp;}<br>&gt; &nbsp;<br>&gt; +/**<br>&gt; + * tpm=5Fioc=5Fnew=
=5Fspace - handler for %SGX=5FIOC=5FNEW=5FSPACE ioctl<br>&gt; + *<br>&gt; +=
 * Creates a new TPM space that can hold a set of transient <br>&gt; object=
s. The space<br>&gt; + * is isolated with virtual handles that are mapped i=
nto physical
<br>&gt; handles by the<br>&gt; + * driver.<br>&gt; + */<br>&gt; +static lo=
ng tpm=5Fioc=5Fnew=5Fspace(struct file *file, unsigned int ioctl,<br>&gt; +=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; unsigned long arg)<br>&gt=
; +{<br>&gt; + &nbsp; struct file=5Fpriv *priv =3D file-&gt;private=5Fdata;=
<br>&gt; + &nbsp; struct tpm=5Fchip *chip =3D priv-&gt;chip;<br>&gt; + &nbs=
p; int rc =3D 0;<br>&gt; +<br>&gt; + &nbsp; if (!(chip-&gt;flags &amp; TPM=
=5FCHIP=5FFLAG=5FTPM2))<br>&gt; + &nbsp; &nbsp; &nbsp;return -EOPNOTSUPP;<b=
r>&gt; +<br>&gt; + &nbsp; mutex=5Flock(&amp;priv-&gt;buffer=5Fmutex);<br>&g=
t; +<br>&gt; + &nbsp; if (priv-&gt;has=5Fspace) {<br>&gt; + &nbsp; &nbsp; &=
nbsp;rc =3D -EBUSY;<br>&gt; + &nbsp; &nbsp; &nbsp;goto out;<br>&gt; + &nbsp=
; }<br>&gt; +<br>&gt; + &nbsp; priv-&gt;space.context=5Fbuf =3D kzalloc(PAG=
E=5FSIZE, GFP=5FKERNEL);<br>&gt; + &nbsp; if (!priv-&gt;space.context=5Fbuf=
) {<br>&gt; + &nbsp; &nbsp; &nbsp;rc =3D -ENOMEM;<br>&gt; + &nbsp; &nbsp; &=
nbsp;goto out;<br>&gt; + &nbsp; }<br>&gt; +<br>&gt; + &nbsp; /* The TPM dev=
ice can be opened again as this file has been
moved to a<br>&gt; + &nbsp; &nbsp;* TPM handle space.<br>&gt; + &nbsp; &nbs=
p;*/<br>&gt; + &nbsp; priv-&gt;has=5Fspace =3D true;<br>&gt; + &nbsp; clear=
=5Fbit(0, &amp;chip-&gt;is=5Fopen);<br>&gt; +out:<br>&gt; + &nbsp; mutex=5F=
unlock(&amp;priv-&gt;buffer=5Fmutex);<br>&gt; + &nbsp; return rc;<br>&gt; +=
}<br>&gt; +<br>&gt; +static long tpm=5Fioctl(struct file *file, unsigned in=
t ioctl,<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;unsigned long a=
rg)<br>&gt; +{<br>&gt; + &nbsp; switch (ioctl) {<br>&gt; + &nbsp; case TPM=
=5FIOC=5FNEW=5FSPACE:<br>&gt; + &nbsp; &nbsp; &nbsp;return tpm=5Fioc=5Fnew=
=5Fspace(file, ioctl, arg);<br>&gt; + &nbsp; default:<br>&gt; + &nbsp; &nbs=
p; &nbsp;return -ENOIOCTLCMD;<br>&gt; + &nbsp; }<br>&gt; +}<br>&gt; +<br>&g=
t; +#ifdef CONFIG=5FCOMPAT<br>&gt; +static long tpm=5Fcompat=5Fioctl(struct=
 file *file, unsigned int ioctl,<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp;unsigned long arg)<br>&gt; +{<br>&gt; + &nbsp; return tpm=
=5Fioctl(file, ioctl, arg);<br>&gt; +}<br>&gt; +#endif<br>&gt; +<br>&gt; &n=
bsp;/*<br>&gt; &nbsp; * Called on file close<br>&gt; &nbsp; */<br>&gt; @@ -=
169,6 +235,14 @@ static int tpm=5Frelease(struct inode *inode, <br>&gt; str=
uct file *file)<br>&gt; &nbsp;{<br>&gt; &nbsp; &nbsp; struct file=5Fpriv *p=
riv =3D file-&gt;private=5Fdata;<br>&gt; &nbsp;<br>&gt; + &nbsp; if (tpm=5F=
try=5Fget=5Fops(priv-&gt;chip)) {<br>&gt; + &nbsp; &nbsp; &nbsp;mutex=5Funl=
ock(&amp;priv-&gt;buffer=5Fmutex);<br>&gt; + &nbsp; &nbsp; &nbsp;return -EP=
IPE;<br>&gt; + &nbsp; }</font></tt><br><br><br><tt><font size=3D2>That mute=
x=5Funlock looks wrong.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;=
Stefan</font></tt><BR>
--=_alternative 0061FFDA8525809E_=--



--===============3484087515824621499==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============3484087515824621499==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3484087515824621499==--
