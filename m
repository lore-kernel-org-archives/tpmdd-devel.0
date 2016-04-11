From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Mon, 11 Apr 2016 15:33:10 -0400
Message-ID: <201604111927.u3BJRHjG012255@d01av05.pok.ibm.com>
References: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com><1459275554-12915-3-git-send-email-stefanb@linux.vnet.ibm.com><20160407123539.GA17489@intel.com><57068198.6050407@linux.vnet.ibm.com><20160411084358.GB11322@intel.com>
	<20160411181403.GB371@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6545048066291129348=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160411181403.GB371-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============6545048066291129348==
Content-Type: multipart/alternative;
	boundary="=_alternative 006B6F6A85257F92_="


--=_alternative 006B6F6A85257F92_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 04/11/2016=20
02:14:03 PM:


>=20
> On Mon, Apr 11, 2016 at 11:43:58AM +0300, Jarkko Sakkinen wrote:
> > On Thu, Apr 07, 2016 at 11:49:44AM -0400, Stefan Berger wrote:
> > > On 04/07/2016 08:35 AM, Jarkko Sakkinen wrote:
> > > >On Tue, Mar 29, 2016 at 02:19:12PM -0400, Stefan Berger wrote:
> > > >>This patch implements a proxy driver for supporting multiple=20
> emulated TPMs
> > > >>in a system.
> > > >>
> > > >>The driver implements a device /dev/vtpmx that is used to created
> > > >>a client device pair /dev/tpmX (e.g., /dev/tpm10) and a serverside =

that
> > > >>is accessed using a file descriptor returned by an ioctl.
> > > >>The device /dev/tpmX is the usual TPM device created by the core=20
TPM
> > > >>driver. Applications or kernel subsystems can send TPM commands to =

it
> > > >>and the corresponding server-side file descriptor receives these
> > > >>commands and delivers them to an emulated TPM.
> > > >>
> > > >>Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > > >>CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > >>CC: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > >>CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > >Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > >Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > >=20
> > > Thanks. So I can post a v10 where I have to re-introduce the=20
> priv field but
> > > put it into the tpm=5Fchip struct. Obviously it needs this field. I a=
m=20
not
> > > sure whether you'll let me take the Reviewed-by and Tested-by,=20
though?
> >=20
> > Lets hold for them then. I'll do retest when I get the new series.
>=20
> Lets just fix the sysfs stuff the same way we fixed ppi and be done
> with this issue.
>=20
> Something that looks kinda like this untested thing:

If the intent is to get rid of the priv field, I am not sure whether we=20
can solve the problem this way. You may remember that the vtpm proxy=20
driver only registers the chip once startup and retrieval of durations and =

timeouts successfully ran. But we need to access the proxy=5Fdev before=20
that:

https://github.com/stefanberger/linux/commit/3811e51743637efe11f9df99ddb616=
881fc34c04#diff-4f54b830a2a73696c2455277f4abbc41R230

Here the retrieval of timeouts and durations.

https://github.com/stefanberger/linux/commit/3b284694c802f718f36b07a3ddc005=
e343432338#diff-4f54b830a2a73696c2455277f4abbc41R369


If this patch is some form of cleanup, that may be a different story.


    Stefan


>=20
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index a7c3473c3421..51e898be4307 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -36,7 +36,7 @@ static ssize=5Ft pubek=5Fshow(struct device *dev,=20
> struct device=5Fattribute *attr,
>     int i, rc;
>     char *str =3D buf;
>=20
> -   struct tpm=5Fchip *chip =3D dev=5Fget=5Fdrvdata(dev);
> +   struct tpm=5Fchip *chip =3D to=5Ftpm=5Fchip(dev);
>=20
>     tpm=5Fcmd.header.in =3D tpm=5Freadpubek=5Fheader;
>     err =3D tpm=5Ftransmit=5Fcmd(chip, &tpm=5Fcmd, READ=5FPUBEK=5FRESULT=
=5FSIZE,
> @@ -92,7 +92,7 @@ static ssize=5Ft pcrs=5Fshow(struct device *dev,=20
> struct device=5Fattribute *attr,
>     ssize=5Ft rc;
>     int i, j, num=5Fpcrs;
>     char *str =3D buf;
> -   struct tpm=5Fchip *chip =3D dev=5Fget=5Fdrvdata(dev);
> +   struct tpm=5Fchip *chip =3D to=5Ftpm=5Fchip(dev);
>=20
>     rc =3D tpm=5Fgetcap(dev, TPM=5FCAP=5FPROP=5FPCR, &cap,
>           "attempting to determine the number of PCRS");
> @@ -222,7 +222,7 @@ static DEVICE=5FATTR=5FRO(caps);
>  static ssize=5Ft cancel=5Fstore(struct device *dev, struct=20
> device=5Fattribute *attr,
>               const char *buf, size=5Ft count)
>  {
> -   struct tpm=5Fchip *chip =3D dev=5Fget=5Fdrvdata(dev);
> +   struct tpm=5Fchip *chip =3D to=5Ftpm=5Fchip(dev);
>     if (chip =3D=3D NULL)
>        return 0;
>=20
> @@ -234,7 +234,7 @@ static DEVICE=5FATTR=5FWO(cancel);
>  static ssize=5Ft durations=5Fshow(struct device *dev, struct=20
> device=5Fattribute *attr,
>                 char *buf)
>  {
> -   struct tpm=5Fchip *chip =3D dev=5Fget=5Fdrvdata(dev);
> +   struct tpm=5Fchip *chip =3D to=5Ftpm=5Fchip(dev);
>=20
>     if (chip->duration[TPM=5FLONG] =3D=3D 0)
>        return 0;
> @@ -251,7 +251,7 @@ static DEVICE=5FATTR=5FRO(durations);
>  static ssize=5Ft timeouts=5Fshow(struct device *dev, struct=20
> device=5Fattribute *attr,
>                char *buf)
>  {
> -   struct tpm=5Fchip *chip =3D dev=5Fget=5Fdrvdata(dev);
> +   struct tpm=5Fchip *chip =3D to=5Ftpm=5Fchip(dev);
>=20
>     return sprintf(buf, "%d %d %d %d [%s]\n",
>               jiffies=5Fto=5Fusecs(chip->timeout=5Fa),
> @@ -283,22 +283,33 @@ static const struct attribute=5Fgroup tpm=5Fdev=5Fg=
roup=20
=3D {
>=20
>  int tpm=5Fsysfs=5Fadd=5Fdevice(struct tpm=5Fchip *chip)
>  {
> -   int err;
> -   err =3D sysfs=5Fcreate=5Fgroup(&chip->dev.parent->kobj,
> -             &tpm=5Fdev=5Fgroup);
> +   const struct attribute **i;
>=20
> -   if (err)
> -      dev=5Ferr(&chip->dev,
> -         "failed to create sysfs attributes, %d\n", err);
> -   return err;
> +   chip->groups[chip->groups=5Fcnt++] =3D &tpm=5Fdev=5Fgroup;
> +   if (chip->flags & TPM=5FCHIP=5FFLAG=5FTPM2)
> +      return 0;
> +
> +   for (i =3D tpm=5Fdev=5Fattrs; *i !=3D NULL; ++i) {
> +      rc =3D =5F=5Fcompat=5Fonly=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(
> +          &chip->dev.parent->kobj, &chip->dev.kobj, (*i)->name);
> +      if (rc && rc !=3D -ENOENT) {
> +         tpm=5Fsysfs=5Fdel=5Fdevice(chip);
> +         return rc;
> +      }
> +   }
> +
> +   return 0;
>  }
>=20
>  void tpm=5Fsysfs=5Fdel=5Fdevice(struct tpm=5Fchip *chip)
>  {
> -   /* The sysfs routines rely on an implicit tpm=5Ftry=5Fget=5Fops, this
> -    * function is called before ops is null'd and the sysfs core
> -    * synchronizes this removal so that no callbacks are running or can
> -    * run again
> +   const struct attribute **i;
> +
> +   /* The sysfs routines rely on an implicit tpm=5Ftry=5Fget=5Fops,=20
device=5Fdel
> +    * is called before ops is null'd and the sysfs core synchronizes=20
this
> +    * removal so that no callbacks are running or can run again
>      */
> -   sysfs=5Fremove=5Fgroup(&chip->dev.parent->kobj, &tpm=5Fdev=5Fgroup);
> +
> +   for (i =3D tpm=5Fdev=5Fattrs; *i !=3D NULL; ++i)
> +      sysfs=5Fremove=5Flink(&chip->dev.parent->kobj, (*i)->name);
>  }
>=20
>=20
---------------------------------------------------------------------------=
---
> Find and fix application performance issues faster with Applications=20
Manager
> Applications Manager provides deep performance insights into multiple=20
tiers of
> your business applications. It resolves application problems quickly and
> reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
> gampad/clk?id=3D1444514301&iu=3D/ca-pub-7940484522588532
> =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>=20



--=_alternative 006B6F6A85257F92_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 04/11/2016 02:14:03 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Mon, Apr 11, 2016 at 11:43:58AM +0300, Jarkko Sakkinen wro=
te:<br>&gt; &gt; On Thu, Apr 07, 2016 at 11:49:44AM -0400, Stefan Berger wr=
ote:<br>&gt; &gt; &gt; On 04/07/2016 08:35 AM, Jarkko Sakkinen wrote:<br>&g=
t; &gt; &gt; &gt;On Tue, Mar 29, 2016 at 02:19:12PM -0400, Stefan Berger
wrote:<br>&gt; &gt; &gt; &gt;&gt;This patch implements a proxy driver for s=
upporting
multiple <br>&gt; emulated TPMs<br>&gt; &gt; &gt; &gt;&gt;in a system.<br>&=
gt; &gt; &gt; &gt;&gt;<br>&gt; &gt; &gt; &gt;&gt;The driver implements a de=
vice /dev/vtpmx that is
used to created<br>&gt; &gt; &gt; &gt;&gt;a client device pair /dev/tpmX (e=
.g., /dev/tpm10)
and a serverside that<br>&gt; &gt; &gt; &gt;&gt;is accessed using a file de=
scriptor returned by
an ioctl.<br>&gt; &gt; &gt; &gt;&gt;The device /dev/tpmX is the usual TPM d=
evice created
by the core TPM<br>&gt; &gt; &gt; &gt;&gt;driver. Applications or kernel su=
bsystems can send
TPM commands to it<br>&gt; &gt; &gt; &gt;&gt;and the corresponding server-s=
ide file descriptor
receives these<br>&gt; &gt; &gt; &gt;&gt;commands and delivers them to an e=
mulated TPM.<br>&gt; &gt; &gt; &gt;&gt;<br>&gt; &gt; &gt; &gt;&gt;Signed-of=
f-by: Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;<br>&gt; &gt; &gt; &g=
t;&gt;CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org<br>&gt; &gt; &gt; &gt;&gt;CC: linux-=
doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org<br>&gt; &gt; &gt; &gt;&gt;CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org=
<br>&gt; &gt; &gt; &gt;Reviewed-by: Jarkko Sakkinen &lt;jarkko.sakkinen@lin=
ux.intel.com&gt;<br>&gt; &gt; &gt; &gt;Tested-by: Jarkko Sakkinen &lt;jarkk=
o.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;<br>&gt; &gt; &gt; <br>&gt; &gt; &gt; Thanks.=
 So I can post a v10 where I have to re-introduce
the <br>&gt; priv field but<br>&gt; &gt; &gt; put it into the tpm=5Fchip st=
ruct. Obviously it needs this
field. I am not<br>&gt; &gt; &gt; sure whether you'll let me take the Revie=
wed-by and Tested-by,
though?<br>&gt; &gt; <br>&gt; &gt; Lets hold for them then. I'll do retest =
when I get the new series.<br>&gt; <br>&gt; Lets just fix the sysfs stuff t=
he same way we fixed ppi and be done<br>&gt; with this issue.<br>&gt; <br>&=
gt; Something that looks kinda like this untested thing:</font></tt><br><br=
><tt><font size=3D2>If the intent is to get rid of the priv field, I am
not sure whether we can solve the problem this way. You may remember that
the vtpm proxy driver only registers the chip once startup and retrieval
of durations and timeouts successfully ran. But we need to access the proxy=
=5Fdev
before that:</font></tt><br><br><a href=3D"https://github.com/stefanberger/=
linux/commit/3811e51743637efe11f9df99ddb616881fc34c04#diff-4f54b830a2a73696=
c2455277f4abbc41R230"><tt><font size=3D2 color=3Dblue>https://github.com/st=
efanberger/linux/commit/3811e51743637efe11f9df99ddb616881fc34c04#diff-4f54b=
830a2a73696c2455277f4abbc41R230</font></tt></a><br><br><tt><font size=3D2>H=
ere the retrieval of timeouts and durations.</font></tt><br><br><a href=3D"=
https://github.com/stefanberger/linux/commit/3b284694c802f718f36b07a3ddc005=
e343432338#diff-4f54b830a2a73696c2455277f4abbc41R369"><tt><font size=3D2 co=
lor=3Dblue>https://github.com/stefanberger/linux/commit/3b284694c802f718f36=
b07a3ddc005e343432338#diff-4f54b830a2a73696c2455277f4abbc41R369</font></tt>=
</a><br><br><br><tt><font size=3D2>If this patch is some form of cleanup, t=
hat may be
a different story.</font></tt><br><br><br><tt><font size=3D2>&nbsp; &nbsp; =
Stefan</font></tt><br><br><tt><font size=3D2><br>&gt; <br>&gt; diff --git a=
/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c<br>&gt; index =
a7c3473c3421..51e898be4307 100644<br>&gt; --- a/drivers/char/tpm/tpm-sysfs.=
c<br>&gt; +++ b/drivers/char/tpm/tpm-sysfs.c<br>&gt; @@ -36,7 +36,7 @@ stat=
ic ssize=5Ft pubek=5Fshow(struct device *dev, <br>&gt; struct device=5Fattr=
ibute *attr,<br>&gt; &nbsp; &nbsp; int i, rc;<br>&gt; &nbsp; &nbsp; char *s=
tr =3D buf;<br>&gt; &nbsp;<br>&gt; - &nbsp; struct tpm=5Fchip *chip =3D dev=
=5Fget=5Fdrvdata(dev);<br>&gt; + &nbsp; struct tpm=5Fchip *chip =3D to=5Ftp=
m=5Fchip(dev);<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; tpm=5Fcmd.header.in =3D=
 tpm=5Freadpubek=5Fheader;<br>&gt; &nbsp; &nbsp; err =3D tpm=5Ftransmit=5Fc=
md(chip, &amp;tpm=5Fcmd, READ=5FPUBEK=5FRESULT=5FSIZE,<br>&gt; @@ -92,7 +92=
,7 @@ static ssize=5Ft pcrs=5Fshow(struct device *dev, <br>&gt; struct devi=
ce=5Fattribute *attr,<br>&gt; &nbsp; &nbsp; ssize=5Ft rc;<br>&gt; &nbsp; &n=
bsp; int i, j, num=5Fpcrs;<br>&gt; &nbsp; &nbsp; char *str =3D buf;<br>&gt;=
 - &nbsp; struct tpm=5Fchip *chip =3D dev=5Fget=5Fdrvdata(dev);<br>&gt; + &=
nbsp; struct tpm=5Fchip *chip =3D to=5Ftpm=5Fchip(dev);<br>&gt; &nbsp;<br>&=
gt; &nbsp; &nbsp; rc =3D tpm=5Fgetcap(dev, TPM=5FCAP=5FPROP=5FPCR, &amp;cap=
,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;attempting to determine =
the
number of PCRS&quot;);<br>&gt; @@ -222,7 +222,7 @@ static DEVICE=5FATTR=5FR=
O(caps);<br>&gt; &nbsp;static ssize=5Ft cancel=5Fstore(struct device *dev, =
struct <br>&gt; device=5Fattribute *attr,<br>&gt; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; const char *buf,
size=5Ft count)<br>&gt; &nbsp;{<br>&gt; - &nbsp; struct tpm=5Fchip *chip =
=3D dev=5Fget=5Fdrvdata(dev);<br>&gt; + &nbsp; struct tpm=5Fchip *chip =3D =
to=5Ftpm=5Fchip(dev);<br>&gt; &nbsp; &nbsp; if (chip =3D=3D NULL)<br>&gt; &=
nbsp; &nbsp; &nbsp; &nbsp;return 0;<br>&gt; &nbsp;<br>&gt; @@ -234,7 +234,7=
 @@ static DEVICE=5FATTR=5FWO(cancel);<br>&gt; &nbsp;static ssize=5Ft durat=
ions=5Fshow(struct device *dev, struct <br>&gt; device=5Fattribute *attr,<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; char *buf)<b=
r>&gt; &nbsp;{<br>&gt; - &nbsp; struct tpm=5Fchip *chip =3D dev=5Fget=5Fdrv=
data(dev);<br>&gt; + &nbsp; struct tpm=5Fchip *chip =3D to=5Ftpm=5Fchip(dev=
);<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; if (chip-&gt;duration[TPM=5FLONG] =
=3D=3D 0)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;return 0;<br>&gt; @@ -251,7 +2=
51,7 @@ static DEVICE=5FATTR=5FRO(durations);<br>&gt; &nbsp;static ssize=5F=
t timeouts=5Fshow(struct device *dev, struct <br>&gt; device=5Fattribute *a=
ttr,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;char *b=
uf)<br>&gt; &nbsp;{<br>&gt; - &nbsp; struct tpm=5Fchip *chip =3D dev=5Fget=
=5Fdrvdata(dev);<br>&gt; + &nbsp; struct tpm=5Fchip *chip =3D to=5Ftpm=5Fch=
ip(dev);<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; return sprintf(buf, &quot;%d =
%d %d %d [%s]\n&quot;,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; jiffies=5Fto=5Fusecs(chip-&gt;timeout=5Fa),<br>&gt; @@ -283,22 +283,33=
 @@ static const struct attribute=5Fgroup tpm=5Fdev=5Fgroup
=3D {<br>&gt; &nbsp;<br>&gt; &nbsp;int tpm=5Fsysfs=5Fadd=5Fdevice(struct tp=
m=5Fchip *chip)<br>&gt; &nbsp;{<br>&gt; - &nbsp; int err;<br>&gt; - &nbsp; =
err =3D sysfs=5Fcreate=5Fgroup(&amp;chip-&gt;dev.parent-&gt;kobj,<br>&gt; -=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &amp;tpm=5Fdev=5Fgroup);<br>&gt;=
 + &nbsp; const struct attribute **i;<br>&gt; &nbsp;<br>&gt; - &nbsp; if (e=
rr)<br>&gt; - &nbsp; &nbsp; &nbsp;dev=5Ferr(&amp;chip-&gt;dev,<br>&gt; - &n=
bsp; &nbsp; &nbsp; &nbsp; &quot;failed to create sysfs attributes,
%d\n&quot;, err);<br>&gt; - &nbsp; return err;<br>&gt; + &nbsp; chip-&gt;gr=
oups[chip-&gt;groups=5Fcnt++] =3D &amp;tpm=5Fdev=5Fgroup;<br>&gt; + &nbsp; =
if (chip-&gt;flags &amp; TPM=5FCHIP=5FFLAG=5FTPM2)<br>&gt; + &nbsp; &nbsp; =
&nbsp;return 0;<br>&gt; +<br>&gt; + &nbsp; for (i =3D tpm=5Fdev=5Fattrs; *i=
 !=3D NULL; ++i) {<br>&gt; + &nbsp; &nbsp; &nbsp;rc =3D =5F=5Fcompat=5Fonly=
=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;&amp;chip-&gt;dev.parent-&gt;kobj,
&amp;chip-&gt;dev.kobj, (*i)-&gt;name);<br>&gt; + &nbsp; &nbsp; &nbsp;if (r=
c &amp;&amp; rc !=3D -ENOENT) {<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; tpm=
=5Fsysfs=5Fdel=5Fdevice(chip);<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; return=
 rc;<br>&gt; + &nbsp; &nbsp; &nbsp;}<br>&gt; + &nbsp; }<br>&gt; +<br>&gt; +=
 &nbsp; return 0;<br>&gt; &nbsp;}<br>&gt; &nbsp;<br>&gt; &nbsp;void tpm=5Fs=
ysfs=5Fdel=5Fdevice(struct tpm=5Fchip *chip)<br>&gt; &nbsp;{<br>&gt; - &nbs=
p; /* The sysfs routines rely on an implicit tpm=5Ftry=5Fget=5Fops,
this<br>&gt; - &nbsp; &nbsp;* function is called before ops is null'd and t=
he sysfs
core<br>&gt; - &nbsp; &nbsp;* synchronizes this removal so that no callback=
s are
running or can<br>&gt; - &nbsp; &nbsp;* run again<br>&gt; + &nbsp; const st=
ruct attribute **i;<br>&gt; +<br>&gt; + &nbsp; /* The sysfs routines rely o=
n an implicit tpm=5Ftry=5Fget=5Fops,
device=5Fdel<br>&gt; + &nbsp; &nbsp;* is called before ops is null'd and th=
e sysfs core
synchronizes this<br>&gt; + &nbsp; &nbsp;* removal so that no callbacks are=
 running or can run
again<br>&gt; &nbsp; &nbsp; &nbsp;*/<br>&gt; - &nbsp; sysfs=5Fremove=5Fgrou=
p(&amp;chip-&gt;dev.parent-&gt;kobj, &amp;tpm=5Fdev=5Fgroup);<br>&gt; +<br>=
&gt; + &nbsp; for (i =3D tpm=5Fdev=5Fattrs; *i !=3D NULL; ++i)<br>&gt; + &n=
bsp; &nbsp; &nbsp;sysfs=5Fremove=5Flink(&amp;chip-&gt;dev.parent-&gt;kobj,
(*i)-&gt;name);<br>&gt; &nbsp;}<br>&gt; <br>&gt; --------------------------=
----------------------------------------------------<br>&gt; Find and fix a=
pplication performance issues faster with Applications
Manager<br>&gt; Applications Manager provides deep performance insights int=
o multiple
tiers of<br>&gt; your business applications. It resolves application proble=
ms quickly
and<br>&gt; reduces your MTTR. Get your free trial! </font></tt><a href=3Dh=
ttp://pubads.g.doubleclick.net/><tt><font size=3D2>http://pubads.g.doublecl=
ick.net/</font></tt></a><tt><font size=3D2><br>&gt; gampad/clk?id=3D1444514=
301&amp;iu=3D/ca-pub-7940484522588532<br>&gt; =5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F<br>&gt; tpmdd-devel mailing list<br=
>&gt; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>&gt; </font></tt><a href=3D"http=
s://lists.sourceforge.net/lists/listinfo/tpmdd-devel"><tt><font size=3D2>ht=
tps://lists.sourceforge.net/lists/listinfo/tpmdd-devel</font></tt></a><tt><=
font size=3D2><br>&gt; <br></font></tt><BR>
--=_alternative 006B6F6A85257F92_=--



--===============6545048066291129348==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
--===============6545048066291129348==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6545048066291129348==--
