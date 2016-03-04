From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 08/10] tpm: Driver for supporting
 multiple emulated TPMs
Date: Fri, 4 Mar 2016 16:16:41 -0500
Message-ID: <201603042116.u24LGlSP017830@d03av05.boulder.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com><1456766996-9300-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160304202928.GA32617@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1893294898492107644=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160304202928.GA32617-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============1893294898492107644==
Content-Type: multipart/alternative;
	boundary="=_alternative 0074E51085257F6C_="


--=_alternative 0074E51085257F6C_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/04/2016=20
03:29:28 PM:
>=20
> Hi
>=20
> I noticed some glitches.
>=20
> On Mon, Feb 29, 2016 at 12:29:54PM -0500, Stefan Berger wrote:
> > This patch implements a driver for supporting multiple emulated TPMs=20
in a
> > system.
> >=20
> > The driver implements a device /dev/vtpmx that is used to created
> > a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side=20
that
> > is accessed using a file descriptor returned by an ioctl.
> > The device /dev/tpmX is the usual TPM device created by the core TPM
> > driver. Applications or kernel subsystems can send TPM commands to it
> > and the corresponding server-side file descriptor receives these
> > commands and delivers them to an emulated TPM.
>=20
> Every other driver in the subsystem except xen-tpmfront uses
> underscore instead of dash. For the sake of consistency this should be
> renamed as tpm=5Fvtpm.

fixed.


>=20
>=20
> > Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > ---
> >  drivers/char/tpm/Kconfig    |  10 +
> >  drivers/char/tpm/Makefile   |   1 +
> >  drivers/char/tpm/tpm-vtpm.c | 546 +++++++++++++++++++++++++++++++
> +++++++++++++
> >  include/uapi/linux/Kbuild   |   1 +
> >  include/uapi/linux/vtpm.h   |  41 ++++
> >  5 files changed, 599 insertions(+)
> >  create mode 100644 drivers/char/tpm/tpm-vtpm.c
> >  create mode 100644 include/uapi/linux/vtpm.h
> >=20
> > diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> > index 3b84a8b..4c4e843 100644
> > --- a/drivers/char/tpm/Kconfig
> > +++ b/drivers/char/tpm/Kconfig
> > @@ -122,5 +122,15 @@ config TCG=5FCRB
> >       from within Linux.  To compile this driver as a module, choose
> >       M here; the module will be called tpm=5Fcrb.
> >=20
> > +config TCG=5FVTPM
> > +   tristate "VTPM Interface"
> > +   depends on TCG=5FTPM
> > +   ---help---
> > +     This driver supports an emulated TPM (vTPM) running in=20
userspace.
> > +     A device /dev/vtpmx is provided that creates a device pair
> > +     /dev/vtpmX and a server-side file descriptor on which the vTPM
> > +     can receive commands.
> > +
> > +
> >  source "drivers/char/tpm/st33zp24/Kconfig"
> >  endif # TCG=5FTPM
> > diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> > index 56e8f1f..d947db2 100644
> > --- a/drivers/char/tpm/Makefile
> > +++ b/drivers/char/tpm/Makefile
> > @@ -23,3 +23,4 @@ obj-$(CONFIG=5FTCG=5FIBMVTPM) +=3D tpm=5Fibmvtpm.o
> >  obj-$(CONFIG=5FTCG=5FTIS=5FST33ZP24) +=3D st33zp24/
> >  obj-$(CONFIG=5FTCG=5FXEN) +=3D xen-tpmfront.o
> >  obj-$(CONFIG=5FTCG=5FCRB) +=3D tpm=5Fcrb.o
> > +obj-$(CONFIG=5FTCG=5FVTPM) +=3D tpm-vtpm.o
> > diff --git a/drivers/char/tpm/tpm-vtpm.c b/drivers/char/tpm/tpm-vtpm.c
> > new file mode 100644
> > index 0000000..2c69363
> > --- /dev/null
> > +++ b/drivers/char/tpm/tpm-vtpm.c
> > @@ -0,0 +1,546 @@
> > +/*
> > + * Copyright (C) 2015, 2016 IBM Corporation
> > + *
> > + * Author: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > + *
> > + * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> > + *
> > + * Device driver for vTPM.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation, version 2 of the
> > + * License.
> > + *
> > + */
> > +
> > +#include <linux/types.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/wait.h>
> > +#include <linux/miscdevice.h>
> > +#include <linux/vtpm.h>
> > +#include <linux/file.h>
> > +#include <linux/anon=5Finodes.h>
> > +#include <linux/poll.h>
> > +#include <linux/compat.h>
> > +
> > +#include "tpm.h"
> > +
> > +#define VTPM=5FREQ=5FCOMPLETE=5FFLAG  BIT(0)
> > +
> > +struct vtpm=5Fdev {
> > +   struct tpm=5Fchip *chip;
> > +
> > +   u32 flags;                   /* public API flags */
> > +
> > +   wait=5Fqueue=5Fhead=5Ft wq;
> > +
> > +   struct mutex buf=5Flock;       /* protect buffer and flag=20
modifications */
> > +
> > +   long state;                  /* internal state */
> > +#define STATE=5FOPENED=5FFLAG        BIT(0)
> > +#define STATE=5FWAIT=5FRESPONSE=5FFLAG BIT(1)  /* waiting for emulator=
=20
> response */
> > +
> > +   size=5Ft req=5Flen;              /* length of queued TPM request */
> > +   size=5Ft resp=5Flen;             /* length of queued TPM response */
> > +   u8 buffer[TPM=5FBUFSIZE];      /* request/response buffer */
> > +};
> > +
> > +
> > +static void vtpm=5Fdelete=5Fdevice=5Fpair(struct vtpm=5Fdev *vtpm=5Fde=
v);
> > +
> > +/*
> > + * Functions related to 'server side'
> > + */
> > +
> > +/**
> > + * vtpm=5Ffops=5Fread - Read TPM commands on 'server side'
> > + *
> > + * Return value:
> > + *   Number of bytes read or negative error code
> > + */
> > +static ssize=5Ft vtpm=5Ffops=5Fread(struct file *filp, char =5F=5Fuser=
 *buf,
> > +               size=5Ft count, loff=5Ft *off)
> > +{
> > +   struct vtpm=5Fdev *vtpm=5Fdev =3D filp->private=5Fdata;
> > +   size=5Ft len;
> > +   int sig, rc;
> > +
> > +   sig =3D wait=5Fevent=5Finterruptible(vtpm=5Fdev->wq, vtpm=5Fdev->re=
q=5Flen !=3D=20
0);
> > +   if (sig)
> > +      return -EINTR;
> > +
> > +   mutex=5Flock(&vtpm=5Fdev->buf=5Flock);
> > +
> > +   len =3D vtpm=5Fdev->req=5Flen;
> > +
> > +   if (count < len) {
> > +      mutex=5Funlock(&vtpm=5Fdev->buf=5Flock);
> > +      pr=5Fdebug("Invalid size in recv: count=3D%zd, req=5Flen=3D%zd\n=
",
> > +          count, len);
> > +      return -EIO;
> > +   }
> > +
> > +   rc =3D copy=5Fto=5Fuser(buf, vtpm=5Fdev->buffer, len);
> > +   memset(vtpm=5Fdev->buffer, 0, len);
> > +   vtpm=5Fdev->req=5Flen =3D 0;
> > +
> > +   if (!rc)
> > +      vtpm=5Fdev->state |=3D STATE=5FWAIT=5FRESPONSE=5FFLAG;
> > +
> > +   mutex=5Funlock(&vtpm=5Fdev->buf=5Flock);
> > +
> > +   if (rc)
> > +      return -EFAULT;
> > +
> > +   return len;
> > +}
> > +
> > +/**
> > + * vtpm=5Ffops=5Fwrite - Write TPM responses on 'server side'
> > + *
> > + * Return value:
> > + *   Number of bytes read or negative error value
> > + */
> > +static ssize=5Ft vtpm=5Ffops=5Fwrite(struct file *filp, const char =5F=
=5Fuser=20
*buf,
> > +                size=5Ft count, loff=5Ft *off)
> > +{
> > +   struct vtpm=5Fdev *vtpm=5Fdev =3D filp->private=5Fdata;
> > +
> > +   if (count > sizeof(vtpm=5Fdev->buffer) ||
> > +       !(vtpm=5Fdev->state & STATE=5FWAIT=5FRESPONSE=5FFLAG))
> > +      return -EIO;
>=20
> This is not atomic in any sense. You should move this statement after
> taking buf=5Flock.


set=5Fbit and friends were all atomic. Now we need to put all of these into=
=20
the mutex... ?

   Stefan




--=_alternative 0074E51085257F6C_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/04/2016 03:29:28 PM:<br>&gt; <br>&gt; Hi<br>&gt; <br>&gt; I not=
iced some glitches.<br>&gt; <br>&gt; On Mon, Feb 29, 2016 at 12:29:54PM -05=
00, Stefan Berger wrote:<br>&gt; &gt; This patch implements a driver for su=
pporting multiple emulated
TPMs in a<br>&gt; &gt; system.<br>&gt; &gt; <br>&gt; &gt; The driver implem=
ents a device /dev/vtpmx that is used to created<br>&gt; &gt; a client devi=
ce pair /dev/tpmX (e.g., /dev/tpm10) and a server
side that<br>&gt; &gt; is accessed using a file descriptor returned by an i=
octl.<br>&gt; &gt; The device /dev/tpmX is the usual TPM device created by =
the core
TPM<br>&gt; &gt; driver. Applications or kernel subsystems can send TPM com=
mands
to it<br>&gt; &gt; and the corresponding server-side file descriptor receiv=
es these<br>&gt; &gt; commands and delivers them to an emulated TPM.<br>&gt=
; <br>&gt; Every other driver in the subsystem except xen-tpmfront uses<br>=
&gt; underscore instead of dash. For the sake of consistency this should
be<br>&gt; renamed as tpm=5Fvtpm.</font></tt><br><br><tt><font size=3D2>fix=
ed.</font></tt><br><br><tt><font size=3D2><br>&gt; <br>&gt; <br>&gt; &gt; S=
igned-off-by: Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;<br>&gt; &gt;=
 ---<br>&gt; &gt; &nbsp;drivers/char/tpm/Kconfig &nbsp; &nbsp;| &nbsp;10 +<=
br>&gt; &gt; &nbsp;drivers/char/tpm/Makefile &nbsp; | &nbsp; 1 +<br>&gt; &g=
t; &nbsp;drivers/char/tpm/tpm-vtpm.c | 546 +++++++++++++++++++++++++++++++<=
br>&gt; +++++++++++++<br>&gt; &gt; &nbsp;include/uapi/linux/Kbuild &nbsp; |=
 &nbsp; 1 +<br>&gt; &gt; &nbsp;include/uapi/linux/vtpm.h &nbsp; | &nbsp;41 =
++++<br>&gt; &gt; &nbsp;5 files changed, 599 insertions(+)<br>&gt; &gt; &nb=
sp;create mode 100644 drivers/char/tpm/tpm-vtpm.c<br>&gt; &gt; &nbsp;create=
 mode 100644 include/uapi/linux/vtpm.h<br>&gt; &gt; <br>&gt; &gt; diff --gi=
t a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig<br>&gt; &gt; index =
3b84a8b..4c4e843 100644<br>&gt; &gt; --- a/drivers/char/tpm/Kconfig<br>&gt;=
 &gt; +++ b/drivers/char/tpm/Kconfig<br>&gt; &gt; @@ -122,5 +122,15 @@ conf=
ig TCG=5FCRB<br>&gt; &gt; &nbsp; &nbsp; &nbsp; from within Linux. &nbsp;To =
compile this
driver as a module, choose<br>&gt; &gt; &nbsp; &nbsp; &nbsp; M here; the mo=
dule will be called tpm=5Fcrb.<br>&gt; &gt; &nbsp;<br>&gt; &gt; +config TCG=
=5FVTPM<br>&gt; &gt; + &nbsp; tristate &quot;VTPM Interface&quot;<br>&gt; &=
gt; + &nbsp; depends on TCG=5FTPM<br>&gt; &gt; + &nbsp; ---help---<br>&gt; =
&gt; + &nbsp; &nbsp; This driver supports an emulated TPM (vTPM) running
in userspace.<br>&gt; &gt; + &nbsp; &nbsp; A device /dev/vtpmx is provided =
that creates
a device pair<br>&gt; &gt; + &nbsp; &nbsp; /dev/vtpmX and a server-side fil=
e descriptor
on which the vTPM<br>&gt; &gt; + &nbsp; &nbsp; can receive commands.<br>&gt=
; &gt; +<br>&gt; &gt; +<br>&gt; &gt; &nbsp;source &quot;drivers/char/tpm/st=
33zp24/Kconfig&quot;<br>&gt; &gt; &nbsp;endif # TCG=5FTPM<br>&gt; &gt; diff=
 --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile<br>&gt; &gt;=
 index 56e8f1f..d947db2 100644<br>&gt; &gt; --- a/drivers/char/tpm/Makefile=
<br>&gt; &gt; +++ b/drivers/char/tpm/Makefile<br>&gt; &gt; @@ -23,3 +23,4 @=
@ obj-$(CONFIG=5FTCG=5FIBMVTPM) +=3D tpm=5Fibmvtpm.o<br>&gt; &gt; &nbsp;obj=
-$(CONFIG=5FTCG=5FTIS=5FST33ZP24) +=3D st33zp24/<br>&gt; &gt; &nbsp;obj-$(C=
ONFIG=5FTCG=5FXEN) +=3D xen-tpmfront.o<br>&gt; &gt; &nbsp;obj-$(CONFIG=5FTC=
G=5FCRB) +=3D tpm=5Fcrb.o<br>&gt; &gt; +obj-$(CONFIG=5FTCG=5FVTPM) +=3D tpm=
-vtpm.o<br>&gt; &gt; diff --git a/drivers/char/tpm/tpm-vtpm.c b/drivers/cha=
r/tpm/tpm-vtpm.c<br>&gt; &gt; new file mode 100644<br>&gt; &gt; index 00000=
00..2c69363<br>&gt; &gt; --- /dev/null<br>&gt; &gt; +++ b/drivers/char/tpm/=
tpm-vtpm.c<br>&gt; &gt; @@ -0,0 +1,546 @@<br>&gt; &gt; +/*<br>&gt; &gt; + *=
 Copyright (C) 2015, 2016 IBM Corporation<br>&gt; &gt; + *<br>&gt; &gt; + *=
 Author: Stefan Berger &lt;stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org&gt;<br>&gt; &gt; + *<br>&gt; =
&gt; + * Maintained by: &lt;tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org&gt;<br>&gt; &=
gt; + *<br>&gt; &gt; + * Device driver for vTPM.<br>&gt; &gt; + *<br>&gt; &=
gt; + * This program is free software; you can redistribute it and/or<br>&g=
t; &gt; + * modify it under the terms of the GNU General Public License
as<br>&gt; &gt; + * published by the Free Software Foundation, version 2 of=
 the<br>&gt; &gt; + * License.<br>&gt; &gt; + *<br>&gt; &gt; + */<br>&gt; &=
gt; +<br>&gt; &gt; +#include &lt;linux/types.h&gt;<br>&gt; &gt; +#include &=
lt;linux/spinlock.h&gt;<br>&gt; &gt; +#include &lt;linux/uaccess.h&gt;<br>&=
gt; &gt; +#include &lt;linux/wait.h&gt;<br>&gt; &gt; +#include &lt;linux/mi=
scdevice.h&gt;<br>&gt; &gt; +#include &lt;linux/vtpm.h&gt;<br>&gt; &gt; +#i=
nclude &lt;linux/file.h&gt;<br>&gt; &gt; +#include &lt;linux/anon=5Finodes.=
h&gt;<br>&gt; &gt; +#include &lt;linux/poll.h&gt;<br>&gt; &gt; +#include &l=
t;linux/compat.h&gt;<br>&gt; &gt; +<br>&gt; &gt; +#include &quot;tpm.h&quot=
;<br>&gt; &gt; +<br>&gt; &gt; +#define VTPM=5FREQ=5FCOMPLETE=5FFLAG &nbsp;B=
IT(0)<br>&gt; &gt; +<br>&gt; &gt; +struct vtpm=5Fdev {<br>&gt; &gt; + &nbsp=
; struct tpm=5Fchip *chip;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; u32 flags; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; /* public API flags */<br>&gt; &gt; +<br>&gt; &gt; + &=
nbsp; wait=5Fqueue=5Fhead=5Ft wq;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; stru=
ct mutex buf=5Flock; &nbsp; &nbsp; &nbsp; /* protect
buffer and flag modifications */<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; long =
state; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp;/* internal state */<br>&gt; &gt; +#define STATE=5FOPEN=
ED=5FFLAG &nbsp; &nbsp; &nbsp; &nbsp;BIT(0)<br>&gt; &gt; +#define STATE=5FW=
AIT=5FRESPONSE=5FFLAG BIT(1) &nbsp;/* waiting for
emulator <br>&gt; response */<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; size=5Ft=
 req=5Flen; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;/* length of queued TPM request */<br>&gt; &gt; + &nbsp; size=5Ft res=
p=5Flen; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; /* length of queued TPM response */<br>&gt; &gt; + &nbsp; u8 buffer[=
TPM=5FBUFSIZE]; &nbsp; &nbsp; &nbsp;/* request/response
buffer */<br>&gt; &gt; +};<br>&gt; &gt; +<br>&gt; &gt; +<br>&gt; &gt; +stat=
ic void vtpm=5Fdelete=5Fdevice=5Fpair(struct vtpm=5Fdev *vtpm=5Fdev);<br>&g=
t; &gt; +<br>&gt; &gt; +/*<br>&gt; &gt; + * Functions related to 'server si=
de'<br>&gt; &gt; + */<br>&gt; &gt; +<br>&gt; &gt; +/**<br>&gt; &gt; + * vtp=
m=5Ffops=5Fread - Read TPM commands on 'server side'<br>&gt; &gt; + *<br>&g=
t; &gt; + * Return value:<br>&gt; &gt; + * &nbsp; Number of bytes read or n=
egative error code<br>&gt; &gt; + */<br>&gt; &gt; +static ssize=5Ft vtpm=5F=
fops=5Fread(struct file *filp, char =5F=5Fuser
*buf,<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; size=
=5Ft count,
loff=5Ft *off)<br>&gt; &gt; +{<br>&gt; &gt; + &nbsp; struct vtpm=5Fdev *vtp=
m=5Fdev =3D filp-&gt;private=5Fdata;<br>&gt; &gt; + &nbsp; size=5Ft len;<br=
>&gt; &gt; + &nbsp; int sig, rc;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; sig =
=3D wait=5Fevent=5Finterruptible(vtpm=5Fdev-&gt;wq, vtpm=5Fdev-&gt;req=5Flen
!=3D 0);<br>&gt; &gt; + &nbsp; if (sig)<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;=
return -EINTR;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; mutex=5Flock(&amp;vtpm=
=5Fdev-&gt;buf=5Flock);<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; len =3D vtpm=
=5Fdev-&gt;req=5Flen;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; if (count &lt; l=
en) {<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;mutex=5Funlock(&amp;vtpm=5Fdev-&gt=
;buf=5Flock);<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;pr=5Fdebug(&quot;Invalid s=
ize in recv: count=3D%zd,
req=5Flen=3D%zd\n&quot;,<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;c=
ount, len);<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;return -EIO;<br>&gt; &gt; + =
&nbsp; }<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; rc =3D copy=5Fto=5Fuser(buf, =
vtpm=5Fdev-&gt;buffer, len);<br>&gt; &gt; + &nbsp; memset(vtpm=5Fdev-&gt;bu=
ffer, 0, len);<br>&gt; &gt; + &nbsp; vtpm=5Fdev-&gt;req=5Flen =3D 0;<br>&gt=
; &gt; +<br>&gt; &gt; + &nbsp; if (!rc)<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;=
vtpm=5Fdev-&gt;state |=3D STATE=5FWAIT=5FRESPONSE=5FFLAG;<br>&gt; &gt; +<br=
>&gt; &gt; + &nbsp; mutex=5Funlock(&amp;vtpm=5Fdev-&gt;buf=5Flock);<br>&gt;=
 &gt; +<br>&gt; &gt; + &nbsp; if (rc)<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;re=
turn -EFAULT;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; return len;<br>&gt; &gt;=
 +}<br>&gt; &gt; +<br>&gt; &gt; +/**<br>&gt; &gt; + * vtpm=5Ffops=5Fwrite -=
 Write TPM responses on 'server side'<br>&gt; &gt; + *<br>&gt; &gt; + * Ret=
urn value:<br>&gt; &gt; + * &nbsp; Number of bytes read or negative error v=
alue<br>&gt; &gt; + */<br>&gt; &gt; +static ssize=5Ft vtpm=5Ffops=5Fwrite(s=
truct file *filp, const char
=5F=5Fuser *buf,<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;size=5Ft
count, loff=5Ft *off)<br>&gt; &gt; +{<br>&gt; &gt; + &nbsp; struct vtpm=5Fd=
ev *vtpm=5Fdev =3D filp-&gt;private=5Fdata;<br>&gt; &gt; +<br>&gt; &gt; + &=
nbsp; if (count &gt; sizeof(vtpm=5Fdev-&gt;buffer) ||<br>&gt; &gt; + &nbsp;=
 &nbsp; &nbsp; !(vtpm=5Fdev-&gt;state &amp; STATE=5FWAIT=5FRESPONSE=5FFLAG)=
)<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;return -EIO;<br>&gt; <br>&gt; This is =
not atomic in any sense. You should move this statement after<br>&gt; takin=
g buf=5Flock.</font></tt><br><br><br><tt><font size=3D2>set=5Fbit and frien=
ds were all atomic. Now we need to
put all of these into the mutex... ?</font></tt><br><br><tt><font size=3D2>=
&nbsp; &nbsp;Stefan</font></tt><br><br><BR>
--=_alternative 0074E51085257F6C_=--



--===============1893294898492107644==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============1893294898492107644==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1893294898492107644==--
