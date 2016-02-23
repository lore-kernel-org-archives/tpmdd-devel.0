From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 09/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Tue, 23 Feb 2016 07:09:44 -0500
Message-ID: <201602231210.u1NCADWB008643@d03av03.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com><1455885728-10315-10-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160223102211.GA9474@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4792615263352736671=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160223102211.GA9474-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============4792615263352736671==
Content-Type: multipart/alternative;
	boundary="=_alternative 0042D7A685257F62_="


--=_alternative 0042D7A685257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/23/2016=20
05:22:11 AM:


>=20
> On Fri, Feb 19, 2016 at 07:42:06AM -0500, Stefan Berger wrote:
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
> >=20
> > Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > ---
> >  drivers/char/tpm/Kconfig    |  10 +
> >  drivers/char/tpm/Makefile   |   1 +
> >  drivers/char/tpm/tpm-vtpm.c | 543 +++++++++++++++++++++++++++++++
> +++++++++++++
> >  include/uapi/linux/Kbuild   |   1 +
> >  include/uapi/linux/vtpm.h   |  38 ++++
> >  5 files changed, 593 insertions(+)
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

> > +
> > +struct vtpm=5Fdev {
> > +   struct tpm=5Fchip *chip;
> > +
> > +   u32 flags;                   /* public API flags */
> > +
> > +   long state;
> > +#define STATE=5FOPENED=5FBIT        0
> > +#define STATE=5FWAIT=5FRESPONSE=5FBIT 1    /* waiting for emulator to =

> give response */
>=20
> I'd prefer something like this before declaring the struct:
>=20
> enum vtpm=5Fdev=5Fstates {
>    VTPM=5FDEV=5FOPENED         =3D BIT(0),
>    VTPM=5FDEV=5FWAITING=5FFOR=5FRESPONSE   =3D BIT(1),
> };
>=20
> This whole use of set/clear=5Fbit macros when you don't have variable
> number of bits just makes code less transparent.

Though read-modify-writes with the bit ops are atomic and need no spinlock =

protection to avoid concurrency mess. Now we would need a spinlock for=20
such ops.


>=20
> > +
> > +   spinlock=5Ft buf=5Flock;         /* lock for buffers */
> > +
> > +   wait=5Fqueue=5Fhead=5Ft wq;
> > +
> > +   size=5Ft req=5Flen;              /* length of queued TPM request */
> > +   size=5Ft resp=5Flen;             /* length of queued TPM response */
> > +   u8 buffer[TPM=5FBUFSIZE];      /* request/response buffer */
>=20
> I'd use alloc=5Fpage() with GFP=5FUSERHIGH in order to be a better citizen
> in 32-bit environments. You can kmap() it when you need it.
>=20
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
> > +   spin=5Flock(&vtpm=5Fdev->buf=5Flock);
> > +
> > +   len =3D vtpm=5Fdev->req=5Flen;
> > +
> > +   if (count < len) {
> > +      spin=5Funlock(&vtpm=5Fdev->buf=5Flock);
> > +      pr=5Fdebug("Invalid size in recv: count=3D%zd, req=5Flen=3D%zd\n=
",
> > +          count, len);
> > +      return -EIO;
> > +   }
> > +
> > +   rc =3D copy=5Fto=5Fuser(buf, vtpm=5Fdev->buffer, len);
> > +   memset(vtpm=5Fdev->buffer, 0, len);
> > +   vtpm=5Fdev->req=5Flen =3D 0;
>=20
> I saw already Jason's comment but maybe you could just use a mutex
> instead of a spinlock?

I'll let Jason respond to it whether it's the difference between spinlock=20
and mutex or just no locking at all. If no locking, I'd be inclined to=20
work with two buffers, one for requests and one for responses.



> > +
> > +/*
> > + * Called when core TPM driver reads TPM responses from 'server side'
> > + *
> > + * Return value:
> > + *      Number of TPM response bytes read, negative error value=20
otherwise
> > + */
> > +static int vtpm=5Ftpm=5Fop=5Frecv(struct tpm=5Fchip *chip, u8 *buf, si=
ze=5Ft=20
count)
> > +{
> > +   struct vtpm=5Fdev *vtpm=5Fdev =3D chip->vendor.priv;
> > +   int sig;
> > +   size=5Ft len;
> > +
> > +   if (!vtpm=5Fdev)
> > +      return -EIO;
> > +
> > +   /* wait for response or responder gone */
> > +   sig =3D wait=5Fevent=5Finterruptible(vtpm=5Fdev->wq,
> > +      (vtpm=5Fdev->resp=5Flen !=3D 0
> > +      || !test=5Fbit(STATE=5FOPENED=5FBIT, &vtpm=5Fdev->state)));
> > +
> > +   if (sig)
> > +      return -EINTR;


With us not operating this driver in interrupt mode, we don't need the=20
wait=5Fevent=5Finterruptible if we make another change further below:


> > +
> > +static u8 vtpm=5Ftpm=5Fop=5Fstatus(struct tpm=5Fchip *chip)
> > +{
> > +   return 0;
> > +}


I modified this to=20

static u8 vtpm=5Ftpm=5Fop=5Fstatus(struct tpm=5Fchip *chip)
{
        return (chip->resp=5Flen) ? VTPM=5FREQ=5FCOMPLETE=5FFLAG : 0;
}


> > +
> > +static bool vtpm=5Ftpm=5Freq=5Fcanceled(struct tpm=5Fchip  *chip, u8 s=
tatus)
> > +{
> > +   return (status =3D=3D 0);
> > +}

This will have to remain like this.

> > +
> > +static const struct tpm=5Fclass=5Fops vtpm=5Ftpm=5Fops =3D {
> > +   .recv =3D vtpm=5Ftpm=5Fop=5Frecv,
> > +   .send =3D vtpm=5Ftpm=5Fop=5Fsend,
> > +   .cancel =3D vtpm=5Ftpm=5Fop=5Fcancel,
> > +   .status =3D vtpm=5Ftpm=5Fop=5Fstatus,
> > +   .req=5Fcomplete=5Fmask =3D 0,
> > +   .req=5Fcomplete=5Fval =3D 0,

        .req=5Fcomplete=5Fmask =3D VTPM=5FREQ=5FCOMPLETE=5FFLAG,
        .req=5Fcomplete=5Fval =3D VTPM=5FREQ=5FCOMPLETE=5FFLAG,

with

#define VTPM=5FREQ=5FCOMPLETE=5FFLAG  BIT(0)


Agreed?

   Stefan



--=_alternative 0042D7A685257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 02/23/2016 05:22:11 AM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Fri, Feb 19, 2016 at 07:42:06AM -0500, Stefan Berger wrote=
:<br>&gt; &gt; This patch implements a driver for supporting multiple emula=
ted
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
; &gt; <br>&gt; &gt; Signed-off-by: Stefan Berger &lt;stefanb-23VcF4HTsmITcAY+lMofuw@public.gmane.org=
m.com&gt;<br>&gt; &gt; ---<br>&gt; &gt; &nbsp;drivers/char/tpm/Kconfig &nbs=
p; &nbsp;| &nbsp;10 +<br>&gt; &gt; &nbsp;drivers/char/tpm/Makefile &nbsp; |=
 &nbsp; 1 +<br>&gt; &gt; &nbsp;drivers/char/tpm/tpm-vtpm.c | 543 ++++++++++=
+++++++++++++++++++++<br>&gt; +++++++++++++<br>&gt; &gt; &nbsp;include/uapi=
/linux/Kbuild &nbsp; | &nbsp; 1 +<br>&gt; &gt; &nbsp;include/uapi/linux/vtp=
m.h &nbsp; | &nbsp;38 ++++<br>&gt; &gt; &nbsp;5 files changed, 593 insertio=
ns(+)<br>&gt; &gt; &nbsp;create mode 100644 drivers/char/tpm/tpm-vtpm.c<br>=
&gt; &gt; &nbsp;create mode 100644 include/uapi/linux/vtpm.h<br>&gt; &gt; <=
br>&gt; &gt; diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconf=
ig<br>&gt; &gt; index 3b84a8b..4c4e843 100644<br>&gt; &gt; --- a/drivers/ch=
ar/tpm/Kconfig<br>&gt; &gt; +++ b/drivers/char/tpm/Kconfig<br>&gt; &gt; @@ =
-122,5 +122,15 @@ config TCG=5FCRB<br>&gt; &gt; &nbsp; &nbsp; &nbsp; from w=
ithin Linux. &nbsp;To compile this
driver as a module, choose<br>&gt; &gt; &nbsp; &nbsp; &nbsp; M here; the mo=
dule will be called tpm=5Fcrb.<br>&gt; &gt; &nbsp;<br></font></tt><br><tt><=
font size=3D2>&gt; &gt; +<br>&gt; &gt; +struct vtpm=5Fdev {<br>&gt; &gt; + =
&nbsp; struct tpm=5Fchip *chip;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; u32 fl=
ags; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; /* public API flags */<br>&gt; &gt; +<br>&gt; &gt; + &=
nbsp; long state;<br>&gt; &gt; +#define STATE=5FOPENED=5FBIT &nbsp; &nbsp; =
&nbsp; &nbsp;0<br>&gt; &gt; +#define STATE=5FWAIT=5FRESPONSE=5FBIT 1 &nbsp;=
 &nbsp;/* waiting for
emulator to <br>&gt; give response */<br>&gt; <br>&gt; I'd prefer something=
 like this before declaring the struct:<br>&gt; <br>&gt; enum vtpm=5Fdev=5F=
states {<br>&gt; &nbsp; &nbsp;VTPM=5FDEV=5FOPENED &nbsp; &nbsp; &nbsp; &nbs=
p; =3D BIT(0),<br>&gt; &nbsp; &nbsp;VTPM=5FDEV=5FWAITING=5FFOR=5FRESPONSE &=
nbsp; =3D BIT(1),<br>&gt; };<br>&gt; <br>&gt; This whole use of set/clear=
=5Fbit macros when you don't have variable<br>&gt; number of bits just make=
s code less transparent.</font></tt><br><br><tt><font size=3D2>Though read-=
modify-writes with the bit ops are atomic
and need no spinlock protection to avoid concurrency mess. Now we would
need a spinlock for such ops.</font></tt><br><br><tt><font size=3D2><br>&gt=
; <br>&gt; &gt; +<br>&gt; &gt; + &nbsp; spinlock=5Ft buf=5Flock; &nbsp; &nb=
sp; &nbsp; &nbsp; /*
lock for buffers */<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; wait=5Fqueue=5Fhea=
d=5Ft wq;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; size=5Ft req=5Flen; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;/* length of queued TPM request */<br>&gt; &gt; + &nbsp; size=5Ft res=
p=5Flen; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; /* length of queued TPM response */<br>&gt; &gt; + &nbsp; u8 buffer[=
TPM=5FBUFSIZE]; &nbsp; &nbsp; &nbsp;/* request/response
buffer */<br>&gt; <br>&gt; I'd use alloc=5Fpage() with GFP=5FUSERHIGH in or=
der to be a better citizen<br>&gt; in 32-bit environments. You can kmap() i=
t when you need it.<br>&gt; <br>&gt; &gt; +};<br>&gt; &gt; +<br>&gt; &gt; +=
<br>&gt; &gt; +static void vtpm=5Fdelete=5Fdevice=5Fpair(struct vtpm=5Fdev =
*vtpm=5Fdev);<br>&gt; &gt; +<br>&gt; &gt; +/*<br>&gt; &gt; + * Functions re=
lated to 'server side'<br>&gt; &gt; + */<br>&gt; &gt; +<br>&gt; &gt; +/**<b=
r>&gt; &gt; + * vtpm=5Ffops=5Fread - Read TPM commands on 'server side'<br>=
&gt; &gt; + *<br>&gt; &gt; + * Return value:<br>&gt; &gt; + * &nbsp; Number=
 of bytes read or negative error code<br>&gt; &gt; + */<br>&gt; &gt; +stati=
c ssize=5Ft vtpm=5Ffops=5Fread(struct file *filp, char =5F=5Fuser
*buf,<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; size=
=5Ft count,
loff=5Ft *off)<br>&gt; &gt; +{<br>&gt; &gt; + &nbsp; struct vtpm=5Fdev *vtp=
m=5Fdev =3D filp-&gt;private=5Fdata;<br>&gt; &gt; + &nbsp; size=5Ft len;<br=
>&gt; &gt; + &nbsp; int sig, rc;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; sig =
=3D wait=5Fevent=5Finterruptible(vtpm=5Fdev-&gt;wq, vtpm=5Fdev-&gt;req=5Flen
!=3D 0);<br>&gt; &gt; + &nbsp; if (sig)<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;=
return -EINTR;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; spin=5Flock(&amp;vtpm=
=5Fdev-&gt;buf=5Flock);<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; len =3D vtpm=
=5Fdev-&gt;req=5Flen;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; if (count &lt; l=
en) {<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;spin=5Funlock(&amp;vtpm=5Fdev-&gt;=
buf=5Flock);<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;pr=5Fdebug(&quot;Invalid si=
ze in recv: count=3D%zd,
req=5Flen=3D%zd\n&quot;,<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;c=
ount, len);<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;return -EIO;<br>&gt; &gt; + =
&nbsp; }<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; rc =3D copy=5Fto=5Fuser(buf, =
vtpm=5Fdev-&gt;buffer, len);<br>&gt; &gt; + &nbsp; memset(vtpm=5Fdev-&gt;bu=
ffer, 0, len);<br>&gt; &gt; + &nbsp; vtpm=5Fdev-&gt;req=5Flen =3D 0;<br>&gt=
; <br>&gt; I saw already Jason's comment but maybe you could just use a mut=
ex<br>&gt; instead of a spinlock?</font></tt><br><br><tt><font size=3D2>I'l=
l let Jason respond to it whether it's the difference
between spinlock and mutex or just no locking at all. If no locking, I'd
be inclined to work with two buffers, one for requests and one for response=
s.</font></tt><br><br><br><br><tt><font size=3D2>&gt; &gt; +<br>&gt; &gt; +=
/*<br>&gt; &gt; + * Called when core TPM driver reads TPM responses from 's=
erver
side'<br>&gt; &gt; + *<br>&gt; &gt; + * Return value:<br>&gt; &gt; + * &nbs=
p; &nbsp; &nbsp;Number of TPM response bytes read, negative
error value otherwise<br>&gt; &gt; + */<br>&gt; &gt; +static int vtpm=5Ftpm=
=5Fop=5Frecv(struct tpm=5Fchip *chip, u8 *buf,
size=5Ft count)<br>&gt; &gt; +{<br>&gt; &gt; + &nbsp; struct vtpm=5Fdev *vt=
pm=5Fdev =3D chip-&gt;vendor.priv;<br>&gt; &gt; + &nbsp; int sig;<br>&gt; &=
gt; + &nbsp; size=5Ft len;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; if (!vtpm=
=5Fdev)<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;return -EIO;<br>&gt; &gt; +<br>&=
gt; &gt; + &nbsp; /* wait for response or responder gone */<br>&gt; &gt; + =
&nbsp; sig =3D wait=5Fevent=5Finterruptible(vtpm=5Fdev-&gt;wq,<br>&gt; &gt;=
 + &nbsp; &nbsp; &nbsp;(vtpm=5Fdev-&gt;resp=5Flen !=3D 0<br>&gt; &gt; + &nb=
sp; &nbsp; &nbsp;|| !test=5Fbit(STATE=5FOPENED=5FBIT, &amp;vtpm=5Fdev-&gt;s=
tate)));<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; if (sig)<br>&gt; &gt; + &nbsp=
; &nbsp; &nbsp;return -EINTR;</font></tt><br><br><br><tt><font size=3D2>Wit=
h us not operating this driver in interrupt mode,
we don't need the wait=5Fevent=5Finterruptible if we make another change fu=
rther
below:</font></tt><br><br><br><tt><font size=3D2>&gt; &gt; +<br>&gt; &gt; +=
static u8 vtpm=5Ftpm=5Fop=5Fstatus(struct tpm=5Fchip *chip)<br>&gt; &gt; +{=
<br>&gt; &gt; + &nbsp; return 0;<br>&gt; &gt; +}</font></tt><br><br><br><tt=
><font size=3D2>I modified this to </font></tt><br><br><font size=3D4 face=
=3D"Lucida Console"><b>static</b> u8 vtpm=5Ftpm=5Fop=5Fstatus(<b>struct</b>=
tpm=5Fchip *chip)</font><br><font size=3D4 color=3D#a1009f face=3D"Lucida C=
onsole">{</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &n=
bsp; &nbsp; <b>return</b>(chip-&gt;resp=5Flen) ? VTPM=5FREQ=5FCOMPLETE=5FFL=
AG : </font><font size=3D4 color=3D#00c1c2 face=3D"Lucida Console">0</font>=
<font size=3D4 face=3D"Lucida Console">;</font><br><font size=3D4 color=3D#=
a1009f face=3D"Lucida Console">}</font><br><br><tt><font size=3D2><br>&gt; =
&gt; +<br>&gt; &gt; +static bool vtpm=5Ftpm=5Freq=5Fcanceled(struct tpm=5Fc=
hip &nbsp;*chip,
u8 status)<br>&gt; &gt; +{<br>&gt; &gt; + &nbsp; return (status =3D=3D 0);<=
br>&gt; &gt; +}</font></tt><br><br><tt><font size=3D2>This will have to rem=
ain like this.</font></tt><br><tt><font size=3D2><br>&gt; &gt; +<br>&gt; &g=
t; +static const struct tpm=5Fclass=5Fops vtpm=5Ftpm=5Fops =3D {<br>&gt; &g=
t; + &nbsp; .recv =3D vtpm=5Ftpm=5Fop=5Frecv,<br>&gt; &gt; + &nbsp; .send =
=3D vtpm=5Ftpm=5Fop=5Fsend,<br>&gt; &gt; + &nbsp; .cancel =3D vtpm=5Ftpm=5F=
op=5Fcancel,<br>&gt; &gt; + &nbsp; .status =3D vtpm=5Ftpm=5Fop=5Fstatus,<br=
>&gt; &gt; + &nbsp; .req=5Fcomplete=5Fmask =3D 0,<br>&gt; &gt; + &nbsp; .re=
q=5Fcomplete=5Fval =3D 0,</font></tt><br><br><font size=3D4 face=3D"Lucida =
Console">&nbsp; &nbsp; &nbsp; &nbsp; .req=5Fcomplete=5Fmask
=3D VTPM=5FREQ=5FCOMPLETE=5FFLAG,</font><br><font size=3D4 face=3D"Lucida C=
onsole">&nbsp; &nbsp; &nbsp; &nbsp; .req=5Fcomplete=5Fval
=3D VTPM=5FREQ=5FCOMPLETE=5FFLAG,</font><br><br><tt><font size=3D2>with</fo=
nt></tt><br><br><font size=3D4 color=3D#0021bf face=3D"Lucida Console">#def=
ine </font><font size=3D4 color=3D#6181ff face=3D"Lucida Console">VTPM=5FRE=
Q=5FCOMPLETE=5FFLAG</font><font size=3D4 face=3D"Lucida Console">&nbsp;BIT(=
</font><font size=3D4 color=3D#00c1c2 face=3D"Lucida Console">0</font><font=
 size=3D4 face=3D"Lucida Console">)</font><br><br><br><tt><font size=3D2>Ag=
reed?</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt>=
<br><BR>
--=_alternative 0042D7A685257F62_=--



--===============4792615263352736671==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
--===============4792615263352736671==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4792615263352736671==--
