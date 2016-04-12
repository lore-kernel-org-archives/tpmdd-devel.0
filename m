From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Tue, 12 Apr 2016 11:18:20 -0400
Message-ID: <201604121518.u3CFIUTu007360@d03av02.boulder.ibm.com>
References: <1459275554-12915-3-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160407123539.GA17489@intel.com>
	<57068198.6050407@linux.vnet.ibm.com>
	<20160411084358.GB11322@intel.com>
	<20160411181403.GB371@obsidianresearch.com>
	<201604111933.u3BJXErj001305@d03av03.boulder.ibm.com>
	<20160411202811.GA3663@obsidianresearch.com>
	<201604112030.u3BKUeJQ017181@d01av04.pok.ibm.com>
	<20160411205718.GC3663@obsidianresearch.com>
	<201604112213.u3BMD3i5028908@d03av02.boulder.ibm.com>
	<20160412000500.GC5861@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4137908708454029394=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160412000500.GC5861-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============4137908708454029394==
Content-Type: multipart/alternative;
	boundary="=_alternative 00541B1E85257F93_="


--=_alternative 00541B1E85257F93_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 04/11/2016=20
08:05:00 PM:
>=20
> On Mon, Apr 11, 2016 at 06:12:57PM -0400, Stefan Berger wrote:
> >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
04/11/2016
> >    04:57:18 PM:
> >    >
> >    > On Mon, Apr 11, 2016 at 04:30:34PM -0400, Stefan Berger wrote:
> >    >
> >    > >    > Doesn't matter, just dev=5Fset=5Fdrvdata right after the ch=
ip=20
is
> >    > >    > allocated, just like vtpm does already for chip->priv.
> >    > >    We don't have a dev at this point.
> >    >
> >    > Eh? If you have a chip you have a dev.
>=20
> >    Ok. I would nevertheless like to reduce the churn in the series=20
where I
> >    would post next a v10.
> >    I am using chip->dev.platform=5Fdata =3D proxy=5Fdev to store the=20
proxy=5Fdev.
> >    Here's the current v10:
> >    https://github.com/stefanberger/linux/commits/vtpm-driver.v10
>=20
> The *correct* thing for vtpm=5Fproxy.c is to replace this:
>=20
> +   dev=5Fset=5Fdrvdata(&chip->dev, chip);
> +   chip->dev.platform=5Fdata =3D proxy=5Fdev;
>=20
> With:
>=20
> +   dev=5Fset=5Fdrvdata(&chip->dev, proxy=5Fdev);
>=20
> [and replace all the dev=5Fget=5Fplatdata with dev=5Fget=5Fdrvdata]
>=20
> The use of platdata is an ugly hack.
>=20
> The entire point of the patch I sent earlier was to allow the original
> TPM=5FCHIP=5FFLAG=5FVIRTUAL patch (later versions which moved the
> dev=5Fset=5Fdrvdata out of tpm=5Fsys.c and into vtpm=5Fproxy.c are
> nonsensical) to entirely drop the dev=5Fset=5Fdrvdata, clearing the way
> for vtpm=5Fproxy.c to use the correct approach above.
>=20
> Here is an update of the idea patch I sent earlier, I realized the
> ordering was wrong. This probably almost works actually. If you and
> Christophe can finish it up the issue can be settled quickly.
>=20
> Stick it before the TPM=5FCHIP=5FFLAG=5FVIRTUAL patch and throw away most=
 of
> that patch. Just add two flag checks into tpm=5Fadd/del=5Flegacy=5Fsysfs()

Here's the v10 series now. If you want a better text for that patch,=20
please let me know.
I had to extend it to tpm-interface.c

https://github.com/stefanberger/linux/commits/vtpm-driver.v10


The patches pass my test suite and tpm tis seems to also work fine.

https://github.com/stefanberger/linux-vtpm-tests


 A question below.

>=20
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 2642cca05cac..657a010c6c02 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -275,14 +275,10 @@ static void tpm=5Fdel=5Fchar=5Fdevice(struct tpm=5F=
chip=20
*chip)
>=20
>  static int tpm1=5Fchip=5Fregister(struct tpm=5Fchip *chip)
>  {
> -   int rc;
> -
>     if (chip->flags & TPM=5FCHIP=5FFLAG=5FTPM2)
>        return 0;
>=20
> -   rc =3D tpm=5Fsysfs=5Fadd=5Fdevice(chip);
> -   if (rc)
> -      return rc;
> +   tpm=5Fsysfs=5Fadd=5Fdevice(chip);
>=20
>     chip->bios=5Fdir =3D tpm=5Fbios=5Flog=5Fsetup(dev=5Fname(&chip->dev));
>=20
> @@ -296,8 +292,50 @@ static void tpm1=5Fchip=5Funregister(struct tpm=5Fch=
ip=20
*chip)
>=20
>     if (chip->bios=5Fdir)
>        tpm=5Fbios=5Flog=5Fteardown(chip->bios=5Fdir);
> +}
> +
> +static void tpm=5Fdel=5Flegacy=5Fsysfs(struct tpm=5Fchip *chip)
> +{
> +   struct attribute **i;
> +
> +   if (chip->flags & TPM=5FCHIP=5FFLAG=5FTPM2)
> +      return;
> +
> +   sysfs=5Fremove=5Flink(&chip->dev.parent->kobj, "ppi");
>=20
> -   tpm=5Fsysfs=5Fdel=5Fdevice(chip);
> +   for (i =3D chip->groups[0]->attrs; *i !=3D NULL; ++i)
> +      sysfs=5Fremove=5Flink(&chip->dev.parent->kobj, (*i)->name);
> +}
> +
> +/* For compatability with legacy sysfs paths we provide symlinks from=20
the
> + * parent dev directory to selected names within the tpm chip=20
directory. Old
> + * kernel versions created these files directly under the parent.
> + */
> +static int tpm=5Fadd=5Flegacy=5Fsysfs(struct tpm=5Fchip *chip)
> +{
> +   struct attribute **i;
> +   int rc;
> +
> +   if (chip->flags & TPM=5FCHIP=5FFLAG=5FTPM2)
> +      return 0;
> +
> +   rc =3D =5F=5Fcompat=5Fonly=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(
> +      &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
> +   if (rc && rc !=3D -ENOENT)
> +      goto out=5Ferr;


I wonder whether it is necessary to goto out=5Ferr or not just return rc=20
here?


Also, for tpm0 I now find the following two pcrs entries, as well as all=20
the rest of course:

/sys/devices/pnp0/00:05/tpm/tpm0/pcrs
/sys/devices/pnp0/00:05/pcrs

Is this intentionately?



   Stefan

> +
> +   /* All the names from tpm-sysfs */
> +   for (i =3D chip->groups[0]->attrs; *i !=3D NULL; ++i) {
> +      rc =3D =5F=5Fcompat=5Fonly=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(
> +          &chip->dev.parent->kobj, &chip->dev.kobj, (*i)->name);
> +      if (rc)
> +         goto out=5Ferr;
> +   }
> +
> +   return 0;
> +out=5Ferr:
> +   tpm=5Fdel=5Flegacy=5Fsysfs(chip);
> +   return rc;
>  }
>=20
>  /*
> @@ -322,24 +360,20 @@ int tpm=5Fchip=5Fregister(struct tpm=5Fchip *chip)
>     tpm=5Fadd=5Fppi(chip);
>=20
>     rc =3D tpm=5Fadd=5Fchar=5Fdevice(chip);
> -   if (rc)
> -      goto out=5Ferr;
> +   if (rc) {
> +      tpm1=5Fchip=5Funregister(chip);
> +      return rc;
> +   }
>=20
>     chip->flags |=3D TPM=5FCHIP=5FFLAG=5FREGISTERED;
>=20
> -   if (!(chip->flags & TPM=5FCHIP=5FFLAG=5FTPM2)) {
> -      rc =3D =5F=5Fcompat=5Fonly=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(
> -          &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
> -      if (rc && rc !=3D -ENOENT) {
> -         tpm=5Fchip=5Funregister(chip);
> -         return rc;
> -      }
> +   rc =3D tpm=5Fadd=5Flegacy=5Fsysfs(chip);
> +   if (rc) {
> +      tpm=5Fchip=5Funregister(chip);
> +      return rc;
>     }
>=20
>     return 0;
> -out=5Ferr:
> -   tpm1=5Fchip=5Funregister(chip);
> -   return rc;
>  }
>  EXPORT=5FSYMBOL=5FGPL(tpm=5Fchip=5Fregister);
>=20
> @@ -361,12 +395,11 @@ void tpm=5Fchip=5Funregister(struct tpm=5Fchip *chi=
p)
>     if (!(chip->flags & TPM=5FCHIP=5FFLAG=5FREGISTERED))
>        return;
>=20
> +   tpm=5Fdel=5Flegacy=5Fsysfs(chip);
> +
>     if (chip->flags & TPM=5FCHIP=5FFLAG=5FTPM2)
>        tpm2=5Fshutdown(chip, TPM2=5FSU=5FCLEAR);
>=20
> -   if (!(chip->flags & TPM=5FCHIP=5FFLAG=5FTPM2))
> -      sysfs=5Fremove=5Flink(&chip->dev.parent->kobj, "ppi");
> -
>     tpm1=5Fchip=5Funregister(chip);
>     tpm=5Fdel=5Fchar=5Fdevice(chip);
>  }
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index a7c3473c3421..5f8e419a7c73 100644
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
> @@ -281,24 +281,12 @@ static const struct attribute=5Fgroup tpm=5Fdev=5Fg=
roup=20
=3D {
>     .attrs =3D tpm=5Fdev=5Fattrs,
>  };
>=20
> -int tpm=5Fsysfs=5Fadd=5Fdevice(struct tpm=5Fchip *chip)
> +void tpm=5Fsysfs=5Fadd=5Fdevice(struct tpm=5Fchip *chip)
>  {
> -   int err;
> -   err =3D sysfs=5Fcreate=5Fgroup(&chip->dev.parent->kobj,
> -             &tpm=5Fdev=5Fgroup);
> -
> -   if (err)
> -      dev=5Ferr(&chip->dev,
> -         "failed to create sysfs attributes, %d\n", err);
> -   return err;
> -}
> -
> -void tpm=5Fsysfs=5Fdel=5Fdevice(struct tpm=5Fchip *chip)
> -{
> -   /* The sysfs routines rely on an implicit tpm=5Ftry=5Fget=5Fops, this
> -    * function is called before ops is null'd and the sysfs core
> -    * synchronizes this removal so that no callbacks are running or can
> -    * run again
> +   /* The sysfs routines rely on an implicit tpm=5Ftry=5Fget=5Fops,=20
device=5Fdel
> +    * is called before ops is null'd and the sysfs core synchronizes=20
this
> +    * removal so that no callbacks are running or can run again
>      */
> -   sysfs=5Fremove=5Fgroup(&chip->dev.parent->kobj, &tpm=5Fdev=5Fgroup);
> +   WARN=5FON(chip->groups=5Fcnt !=3D 0);
> +   chip->groups[chip->groups=5Fcnt++] =3D &tpm=5Fdev=5Fgroup;
>  }
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 8bc6fb85fb38..83a231dfe2ed 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -168,9 +168,9 @@ struct tpm=5Fchip {
>=20
>     struct dentry **bios=5Fdir;
>=20
> -#ifdef CONFIG=5FACPI
> -   const struct attribute=5Fgroup *groups[2];
> +   const struct attribute=5Fgroup *groups[3];
>     unsigned int groups=5Fcnt;
> +#ifdef CONFIG=5FACPI
>     acpi=5Fhandle acpi=5Fdev=5Fhandle;
>     char ppi=5Fversion[TPM=5FPPI=5FVERSION=5FLEN + 1];
>  #endif /* CONFIG=5FACPI */
> @@ -496,8 +496,7 @@ extern struct tpm=5Fchip *tpmm=5Fchip=5Falloc(struct =

> device *pdev,
>  extern int tpm=5Fchip=5Fregister(struct tpm=5Fchip *chip);
>  extern void tpm=5Fchip=5Funregister(struct tpm=5Fchip *chip);
>=20
> -int tpm=5Fsysfs=5Fadd=5Fdevice(struct tpm=5Fchip *chip);
> -void tpm=5Fsysfs=5Fdel=5Fdevice(struct tpm=5Fchip *chip);
> +void tpm=5Fsysfs=5Fadd=5Fdevice(struct tpm=5Fchip *chip);
>=20
>  int tpm=5Fpcr=5Fread=5Fdev(struct tpm=5Fchip *chip, int pcr=5Fidx, u8 *r=
es=5Fbuf);
>=20
>=20



--=_alternative 00541B1E85257F93_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 04/11/2016 08:05:00 PM:<br>&gt; <br>&gt; On Mon, Apr 11, 2016 at 0=
6:12:57PM -0400, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;Jason Gunth=
orpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 04/11/2016<br>&gt; &gt; &nbsp; &nbsp;04:57:18 PM:<br>&gt; &gt; &nb=
sp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; On Mon, Apr 11, 2016 at 04:30=
:34PM -0400, Stefan
Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt;=
 &gt; &nbsp; &nbsp;&gt; Doesn't matter, just
dev=5Fset=5Fdrvdata right after the chip is<br>&gt; &gt; &nbsp; &nbsp;&gt; =
&gt; &nbsp; &nbsp;&gt; allocated, just like
vtpm does already for chip-&gt;priv.<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &n=
bsp; &nbsp;We don't have a dev at this
point.<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; Eh? If=
 you have a chip you have a dev.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;Ok. I w=
ould nevertheless like to reduce the churn
in the series where I<br>&gt; &gt; &nbsp; &nbsp;would post next a v10.<br>&=
gt; &gt; &nbsp; &nbsp;I am using chip-&gt;dev.platform=5Fdata =3D proxy=5Fd=
ev
to store the proxy=5Fdev.<br>&gt; &gt; &nbsp; &nbsp;Here's the current v10:=
<br>&gt; &gt; &nbsp; &nbsp;</font></tt><a href=3D"https://github.com/stefan=
berger/linux/commits/vtpm-driver.v10"><tt><font size=3D2>https://github.com=
/stefanberger/linux/commits/vtpm-driver.v10</font></tt></a><tt><font size=
=3D2><br>&gt; <br>&gt; The *correct* thing for vtpm=5Fproxy.c is to replace=
 this:<br>&gt; <br>&gt; + &nbsp; dev=5Fset=5Fdrvdata(&amp;chip-&gt;dev, chi=
p);<br>&gt; + &nbsp; chip-&gt;dev.platform=5Fdata =3D proxy=5Fdev;<br>&gt; =
<br>&gt; With:<br>&gt; <br>&gt; + &nbsp; dev=5Fset=5Fdrvdata(&amp;chip-&gt;=
dev, proxy=5Fdev);<br>&gt; <br>&gt; [and replace all the dev=5Fget=5Fplatda=
ta with dev=5Fget=5Fdrvdata]<br>&gt; <br>&gt; The use of platdata is an ugl=
y hack.<br>&gt; <br>&gt; The entire point of the patch I sent earlier was t=
o allow the original<br>&gt; TPM=5FCHIP=5FFLAG=5FVIRTUAL patch (later versi=
ons which moved the<br>&gt; dev=5Fset=5Fdrvdata out of tpm=5Fsys.c and into=
 vtpm=5Fproxy.c are<br>&gt; nonsensical) to entirely drop the dev=5Fset=5Fd=
rvdata, clearing the way<br>&gt; for vtpm=5Fproxy.c to use the correct appr=
oach above.<br>&gt; <br>&gt; Here is an update of the idea patch I sent ear=
lier, I realized the<br>&gt; ordering was wrong. This probably almost works=
 actually. If you and<br>&gt; Christophe can finish it up the issue can be =
settled quickly.<br>&gt; <br>&gt; Stick it before the TPM=5FCHIP=5FFLAG=5FV=
IRTUAL patch and throw away most
of<br>&gt; that patch. Just add two flag checks into tpm=5Fadd/del=5Flegacy=
=5Fsysfs()</font></tt><br><br><tt><font size=3D2>Here's the v10 series now.=
 If you want a better text
for that patch, please let me know.</font></tt><br><tt><font size=3D2>I had=
 to extend it to tpm-interface.c</font></tt><br><br><a href=3D"https://gith=
ub.com/stefanberger/linux/commits/vtpm-driver.v10"><tt><font size=3D2 color=
=3Dblue>https://github.com/stefanberger/linux/commits/vtpm-driver.v10</font=
></tt></a><br><br><br><tt><font size=3D2>The patches pass my test suite and=
 tpm tis seems to
also work fine.</font></tt><br><br><a href=3D"https://github.com/stefanberg=
er/linux-vtpm-tests"><tt><font size=3D2 color=3Dblue>https://github.com/ste=
fanberger/linux-vtpm-tests</font></tt></a><br><br><br><tt><font size=3D2>&n=
bsp;A question below.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; d=
iff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c<br>&g=
t; index 2642cca05cac..657a010c6c02 100644<br>&gt; --- a/drivers/char/tpm/t=
pm-chip.c<br>&gt; +++ b/drivers/char/tpm/tpm-chip.c<br>&gt; @@ -275,14 +275=
,10 @@ static void tpm=5Fdel=5Fchar=5Fdevice(struct tpm=5Fchip
*chip)<br>&gt; &nbsp;<br>&gt; &nbsp;static int tpm1=5Fchip=5Fregister(struc=
t tpm=5Fchip *chip)<br>&gt; &nbsp;{<br>&gt; - &nbsp; int rc;<br>&gt; -<br>&=
gt; &nbsp; &nbsp; if (chip-&gt;flags &amp; TPM=5FCHIP=5FFLAG=5FTPM2)<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp;return 0;<br>&gt; &nbsp;<br>&gt; - &nbsp; rc =
=3D tpm=5Fsysfs=5Fadd=5Fdevice(chip);<br>&gt; - &nbsp; if (rc)<br>&gt; - &n=
bsp; &nbsp; &nbsp;return rc;<br>&gt; + &nbsp; tpm=5Fsysfs=5Fadd=5Fdevice(ch=
ip);<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; chip-&gt;bios=5Fdir =3D tpm=5Fbio=
s=5Flog=5Fsetup(dev=5Fname(&amp;chip-&gt;dev));<br>&gt; &nbsp;<br>&gt; @@ -=
296,8 +292,50 @@ static void tpm1=5Fchip=5Funregister(struct tpm=5Fchip
*chip)<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; if (chip-&gt;bios=5Fdir)<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp;tpm=5Fbios=5Flog=5Fteardown(chip-&gt;bios=5Fdi=
r);<br>&gt; +}<br>&gt; +<br>&gt; +static void tpm=5Fdel=5Flegacy=5Fsysfs(st=
ruct tpm=5Fchip *chip)<br>&gt; +{<br>&gt; + &nbsp; struct attribute **i;<br=
>&gt; +<br>&gt; + &nbsp; if (chip-&gt;flags &amp; TPM=5FCHIP=5FFLAG=5FTPM2)=
<br>&gt; + &nbsp; &nbsp; &nbsp;return;<br>&gt; +<br>&gt; + &nbsp; sysfs=5Fr=
emove=5Flink(&amp;chip-&gt;dev.parent-&gt;kobj, &quot;ppi&quot;);<br>&gt; &=
nbsp;<br>&gt; - &nbsp; tpm=5Fsysfs=5Fdel=5Fdevice(chip);<br>&gt; + &nbsp; f=
or (i =3D chip-&gt;groups[0]-&gt;attrs; *i !=3D NULL; ++i)<br>&gt; + &nbsp;=
 &nbsp; &nbsp;sysfs=5Fremove=5Flink(&amp;chip-&gt;dev.parent-&gt;kobj,
(*i)-&gt;name);<br>&gt; +}<br>&gt; +<br>&gt; +/* For compatability with leg=
acy sysfs paths we provide symlinks
from the<br>&gt; + * parent dev directory to selected names within the tpm =
chip directory.
Old<br>&gt; + * kernel versions created these files directly under the pare=
nt.<br>&gt; + */<br>&gt; +static int tpm=5Fadd=5Flegacy=5Fsysfs(struct tpm=
=5Fchip *chip)<br>&gt; +{<br>&gt; + &nbsp; struct attribute **i;<br>&gt; + =
&nbsp; int rc;<br>&gt; +<br>&gt; + &nbsp; if (chip-&gt;flags &amp; TPM=5FCH=
IP=5FFLAG=5FTPM2)<br>&gt; + &nbsp; &nbsp; &nbsp;return 0;<br>&gt; +<br>&gt;=
 + &nbsp; rc =3D =5F=5Fcompat=5Fonly=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(<br=
>&gt; + &nbsp; &nbsp; &nbsp;&amp;chip-&gt;dev.parent-&gt;kobj, &amp;chip-&g=
t;dev.kobj,
&quot;ppi&quot;);<br>&gt; + &nbsp; if (rc &amp;&amp; rc !=3D -ENOENT)<br>&g=
t; + &nbsp; &nbsp; &nbsp;goto out=5Ferr;</font></tt><br><br><br><tt><font s=
ize=3D2>I wonder whether it is necessary to goto out=5Ferr or
not just return rc here?</font></tt><br><br><br><tt><font size=3D2>Also, fo=
r tpm0 I now find the following two pcrs entries,
as well as all the rest of course:</font></tt><br><br><tt><font size=3D2>/s=
ys/devices/pnp0/00:05/tpm/tpm0/pcrs</font></tt><br><tt><font size=3D2>/sys/=
devices/pnp0/00:05/pcrs</font></tt><br><br><tt><font size=3D2>Is this inten=
tionately?</font></tt><br><br><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefa=
n</font></tt><br><tt><font size=3D2><br>&gt; +<br>&gt; + &nbsp; /* All the =
names from tpm-sysfs */<br>&gt; + &nbsp; for (i =3D chip-&gt;groups[0]-&gt;=
attrs; *i !=3D NULL; ++i) {<br>&gt; + &nbsp; &nbsp; &nbsp;rc =3D =5F=5Fcomp=
at=5Fonly=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(<br>&gt; + &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;&amp;chip-&gt;dev.parent-&gt;kobj,
&amp;chip-&gt;dev.kobj, (*i)-&gt;name);<br>&gt; + &nbsp; &nbsp; &nbsp;if (r=
c)<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; goto out=5Ferr;<br>&gt; + &nbsp; }=
<br>&gt; +<br>&gt; + &nbsp; return 0;<br>&gt; +out=5Ferr:<br>&gt; + &nbsp; =
tpm=5Fdel=5Flegacy=5Fsysfs(chip);<br>&gt; + &nbsp; return rc;<br>&gt; &nbsp=
;}<br>&gt; &nbsp;<br>&gt; &nbsp;/*<br>&gt; @@ -322,24 +360,20 @@ int tpm=5F=
chip=5Fregister(struct tpm=5Fchip *chip)<br>&gt; &nbsp; &nbsp; tpm=5Fadd=5F=
ppi(chip);<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; rc =3D tpm=5Fadd=5Fchar=5Fd=
evice(chip);<br>&gt; - &nbsp; if (rc)<br>&gt; - &nbsp; &nbsp; &nbsp;goto ou=
t=5Ferr;<br>&gt; + &nbsp; if (rc) {<br>&gt; + &nbsp; &nbsp; &nbsp;tpm1=5Fch=
ip=5Funregister(chip);<br>&gt; + &nbsp; &nbsp; &nbsp;return rc;<br>&gt; + &=
nbsp; }<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; chip-&gt;flags |=3D TPM=5FCHIP=
=5FFLAG=5FREGISTERED;<br>&gt; &nbsp;<br>&gt; - &nbsp; if (!(chip-&gt;flags =
&amp; TPM=5FCHIP=5FFLAG=5FTPM2)) {<br>&gt; - &nbsp; &nbsp; &nbsp;rc =3D =5F=
=5Fcompat=5Fonly=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(<br>&gt; - &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;&amp;chip-&gt;dev.parent-&gt;kobj,
&amp;chip-&gt;dev.kobj, &quot;ppi&quot;);<br>&gt; - &nbsp; &nbsp; &nbsp;if =
(rc &amp;&amp; rc !=3D -ENOENT) {<br>&gt; - &nbsp; &nbsp; &nbsp; &nbsp; tpm=
=5Fchip=5Funregister(chip);<br>&gt; - &nbsp; &nbsp; &nbsp; &nbsp; return rc=
;<br>&gt; - &nbsp; &nbsp; &nbsp;}<br>&gt; + &nbsp; rc =3D tpm=5Fadd=5Flegac=
y=5Fsysfs(chip);<br>&gt; + &nbsp; if (rc) {<br>&gt; + &nbsp; &nbsp; &nbsp;t=
pm=5Fchip=5Funregister(chip);<br>&gt; + &nbsp; &nbsp; &nbsp;return rc;<br>&=
gt; &nbsp; &nbsp; }<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; return 0;<br>&gt; =
-out=5Ferr:<br>&gt; - &nbsp; tpm1=5Fchip=5Funregister(chip);<br>&gt; - &nbs=
p; return rc;<br>&gt; &nbsp;}<br>&gt; &nbsp;EXPORT=5FSYMBOL=5FGPL(tpm=5Fchi=
p=5Fregister);<br>&gt; &nbsp;<br>&gt; @@ -361,12 +395,11 @@ void tpm=5Fchip=
=5Funregister(struct tpm=5Fchip *chip)<br>&gt; &nbsp; &nbsp; if (!(chip-&gt=
;flags &amp; TPM=5FCHIP=5FFLAG=5FREGISTERED))<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp;return;<br>&gt; &nbsp;<br>&gt; + &nbsp; tpm=5Fdel=5Flegacy=5Fsysfs(ch=
ip);<br>&gt; +<br>&gt; &nbsp; &nbsp; if (chip-&gt;flags &amp; TPM=5FCHIP=5F=
FLAG=5FTPM2)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;tpm2=5Fshutdown(chip, TPM2=
=5FSU=5FCLEAR);<br>&gt; &nbsp;<br>&gt; - &nbsp; if (!(chip-&gt;flags &amp; =
TPM=5FCHIP=5FFLAG=5FTPM2))<br>&gt; - &nbsp; &nbsp; &nbsp;sysfs=5Fremove=5Fl=
ink(&amp;chip-&gt;dev.parent-&gt;kobj,
&quot;ppi&quot;);<br>&gt; -<br>&gt; &nbsp; &nbsp; tpm1=5Fchip=5Funregister(=
chip);<br>&gt; &nbsp; &nbsp; tpm=5Fdel=5Fchar=5Fdevice(chip);<br>&gt; &nbsp=
;}<br>&gt; diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm=
-sysfs.c<br>&gt; index a7c3473c3421..5f8e419a7c73 100644<br>&gt; --- a/driv=
ers/char/tpm/tpm-sysfs.c<br>&gt; +++ b/drivers/char/tpm/tpm-sysfs.c<br>&gt;=
 @@ -36,7 +36,7 @@ static ssize=5Ft pubek=5Fshow(struct device *dev, <br>&g=
t; struct device=5Fattribute *attr,<br>&gt; &nbsp; &nbsp; int i, rc;<br>&gt=
; &nbsp; &nbsp; char *str =3D buf;<br>&gt; &nbsp;<br>&gt; - &nbsp; struct t=
pm=5Fchip *chip =3D dev=5Fget=5Fdrvdata(dev);<br>&gt; + &nbsp; struct tpm=
=5Fchip *chip =3D to=5Ftpm=5Fchip(dev);<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp=
; tpm=5Fcmd.header.in =3D tpm=5Freadpubek=5Fheader;<br>&gt; &nbsp; &nbsp; e=
rr =3D tpm=5Ftransmit=5Fcmd(chip, &amp;tpm=5Fcmd, READ=5FPUBEK=5FRESULT=5FS=
IZE,<br>&gt; @@ -92,7 +92,7 @@ static ssize=5Ft pcrs=5Fshow(struct device *=
dev, <br>&gt; struct device=5Fattribute *attr,<br>&gt; &nbsp; &nbsp; ssize=
=5Ft rc;<br>&gt; &nbsp; &nbsp; int i, j, num=5Fpcrs;<br>&gt; &nbsp; &nbsp; =
char *str =3D buf;<br>&gt; - &nbsp; struct tpm=5Fchip *chip =3D dev=5Fget=
=5Fdrvdata(dev);<br>&gt; + &nbsp; struct tpm=5Fchip *chip =3D to=5Ftpm=5Fch=
ip(dev);<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; rc =3D tpm=5Fgetcap(dev, TPM=
=5FCAP=5FPROP=5FPCR, &amp;cap,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
quot;attempting to determine the
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
bsp; jiffies=5Fto=5Fusecs(chip-&gt;timeout=5Fa),<br>&gt; @@ -281,24 +281,12=
 @@ static const struct attribute=5Fgroup tpm=5Fdev=5Fgroup
=3D {<br>&gt; &nbsp; &nbsp; .attrs =3D tpm=5Fdev=5Fattrs,<br>&gt; &nbsp;};<=
br>&gt; &nbsp;<br>&gt; -int tpm=5Fsysfs=5Fadd=5Fdevice(struct tpm=5Fchip *c=
hip)<br>&gt; +void tpm=5Fsysfs=5Fadd=5Fdevice(struct tpm=5Fchip *chip)<br>&=
gt; &nbsp;{<br>&gt; - &nbsp; int err;<br>&gt; - &nbsp; err =3D sysfs=5Fcrea=
te=5Fgroup(&amp;chip-&gt;dev.parent-&gt;kobj,<br>&gt; - &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &amp;tpm=5Fdev=5Fgroup);<br>&gt; -<br>&gt; - &nbsp; =
if (err)<br>&gt; - &nbsp; &nbsp; &nbsp;dev=5Ferr(&amp;chip-&gt;dev,<br>&gt;=
 - &nbsp; &nbsp; &nbsp; &nbsp; &quot;failed to create sysfs attributes,
%d\n&quot;, err);<br>&gt; - &nbsp; return err;<br>&gt; -}<br>&gt; -<br>&gt;=
 -void tpm=5Fsysfs=5Fdel=5Fdevice(struct tpm=5Fchip *chip)<br>&gt; -{<br>&g=
t; - &nbsp; /* The sysfs routines rely on an implicit tpm=5Ftry=5Fget=5Fops,
this<br>&gt; - &nbsp; &nbsp;* function is called before ops is null'd and t=
he sysfs
core<br>&gt; - &nbsp; &nbsp;* synchronizes this removal so that no callback=
s are
running or can<br>&gt; - &nbsp; &nbsp;* run again<br>&gt; + &nbsp; /* The s=
ysfs routines rely on an implicit tpm=5Ftry=5Fget=5Fops,
device=5Fdel<br>&gt; + &nbsp; &nbsp;* is called before ops is null'd and th=
e sysfs core
synchronizes this<br>&gt; + &nbsp; &nbsp;* removal so that no callbacks are=
 running or can run
again<br>&gt; &nbsp; &nbsp; &nbsp;*/<br>&gt; - &nbsp; sysfs=5Fremove=5Fgrou=
p(&amp;chip-&gt;dev.parent-&gt;kobj, &amp;tpm=5Fdev=5Fgroup);<br>&gt; + &nb=
sp; WARN=5FON(chip-&gt;groups=5Fcnt !=3D 0);<br>&gt; + &nbsp; chip-&gt;grou=
ps[chip-&gt;groups=5Fcnt++] =3D &amp;tpm=5Fdev=5Fgroup;<br>&gt; &nbsp;}<br>=
&gt; diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h<br>&gt; i=
ndex 8bc6fb85fb38..83a231dfe2ed 100644<br>&gt; --- a/drivers/char/tpm/tpm.h=
<br>&gt; +++ b/drivers/char/tpm/tpm.h<br>&gt; @@ -168,9 +168,9 @@ struct tp=
m=5Fchip {<br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; struct dentry **bios=5Fdir;=
<br>&gt; &nbsp;<br>&gt; -#ifdef CONFIG=5FACPI<br>&gt; - &nbsp; const struct=
 attribute=5Fgroup *groups[2];<br>&gt; + &nbsp; const struct attribute=5Fgr=
oup *groups[3];<br>&gt; &nbsp; &nbsp; unsigned int groups=5Fcnt;<br>&gt; +#=
ifdef CONFIG=5FACPI<br>&gt; &nbsp; &nbsp; acpi=5Fhandle acpi=5Fdev=5Fhandle=
;<br>&gt; &nbsp; &nbsp; char ppi=5Fversion[TPM=5FPPI=5FVERSION=5FLEN + 1];<=
br>&gt; &nbsp;#endif /* CONFIG=5FACPI */<br>&gt; @@ -496,8 +496,7 @@ extern=
 struct tpm=5Fchip *tpmm=5Fchip=5Falloc(struct
<br>&gt; device *pdev,<br>&gt; &nbsp;extern int tpm=5Fchip=5Fregister(struc=
t tpm=5Fchip *chip);<br>&gt; &nbsp;extern void tpm=5Fchip=5Funregister(stru=
ct tpm=5Fchip *chip);<br>&gt; &nbsp;<br>&gt; -int tpm=5Fsysfs=5Fadd=5Fdevic=
e(struct tpm=5Fchip *chip);<br>&gt; -void tpm=5Fsysfs=5Fdel=5Fdevice(struct=
 tpm=5Fchip *chip);<br>&gt; +void tpm=5Fsysfs=5Fadd=5Fdevice(struct tpm=5Fc=
hip *chip);<br>&gt; &nbsp;<br>&gt; &nbsp;int tpm=5Fpcr=5Fread=5Fdev(struct =
tpm=5Fchip *chip, int pcr=5Fidx, u8
*res=5Fbuf);<br>&gt; &nbsp;<br>&gt; <br></font></tt><BR>
--=_alternative 00541B1E85257F93_=--



--===============4137908708454029394==
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
--===============4137908708454029394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4137908708454029394==--
