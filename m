From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 04/10] tpm: Get rid of module locking
Date: Mon, 29 Feb 2016 15:49:55 -0500
Message-ID: <201602292050.u1TKo2lw028587@d03av02.boulder.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com><1456766996-9300-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229203550.GB26296@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9157860308168631768=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160229203550.GB26296-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============9157860308168631768==
Content-Type: multipart/alternative;
	boundary="=_alternative 00726FD785257F68_="


--=_alternative 00726FD785257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/29/2016=20
03:35:50 PM:


> On Mon, Feb 29, 2016 at 12:29:50PM -0500, Stefan Berger wrote:
> > Now that the tpm core has strong locking around 'ops' it is possible
> > to remove a TPM driver, module and all, even while user space still
> > has things like /dev/tpmX open. For consistency and simplicity, drop
> > the module locking entirely.
>=20
> I don't understand why the user visible behavior of /dev/tpmX should
> be changed if there are no life and death reasons to do it. Do you
> think that this patch is absolutely crucial for the feature
> implemented?

This changes the module counter on the hardware / backend driver and not=20
other user visible behavior from what I can tell. It's certainly/hopefully =

not a life-and-death thing, though I am wondering whether it's be applied=20
sooner or later anyway for cleanup reasons following the preceding patch=20
providing 'strong locking'.

   Stefan

>=20
> /Jarkko
>=20
> > Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm-chip.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index 1ae30f2..8f4b5f2 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -57,9 +57,6 @@ int tpm=5Ftry=5Fget=5Fops(struct tpm=5Fchip *chip)
> >     if (!chip->ops)
> >        goto out=5Flock;
> >=20
> > -   if (!try=5Fmodule=5Fget(chip->dev.parent->driver->owner))
> > -      goto out=5Flock;
> > -
> >     return 0;
> >  out=5Flock:
> >     up=5Fread(&chip->ops=5Fsem);
> > @@ -77,7 +74,6 @@ EXPORT=5FSYMBOL=5FGPL(tpm=5Ftry=5Fget=5Fops);
> >   */
> >  void tpm=5Fput=5Fops(struct tpm=5Fchip *chip)
> >  {
> > -   module=5Fput(chip->dev.parent->driver->owner);
> >     up=5Fread(&chip->ops=5Fsem);
> >     put=5Fdevice(&chip->dev);
> >  }
> > @@ -183,7 +179,7 @@ struct tpm=5Fchip *tpmm=5Fchip=5Falloc(struct devic=
e=20
*dev,
> >        goto out;
> >=20
> >     cdev=5Finit(&chip->cdev, &tpm=5Ffops);
> > -   chip->cdev.owner =3D dev->driver->owner;
> > +   chip->cdev.owner =3D THIS=5FMODULE;
> >     chip->cdev.kobj.parent =3D &chip->dev.kobj;
> >=20
> >     rc =3D devm=5Fadd=5Faction(dev, (void (*)(void *)) put=5Fdevice,=20
&chip->dev);
> > --=20
> > 2.4.3
> >=20
>=20



--=_alternative 00726FD785257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 02/29/2016 03:35:50 PM:<br><br><br>&gt; On Mon, Feb 29, 2016 at 12=
:29:50PM -0500, Stefan Berger wrote:<br>&gt; &gt; Now that the tpm core has=
 strong locking around 'ops' it is possible<br>&gt; &gt; to remove a TPM dr=
iver, module and all, even while user space
still<br>&gt; &gt; has things like /dev/tpmX open. For consistency and simp=
licity,
drop<br>&gt; &gt; the module locking entirely.<br>&gt; <br>&gt; I don't und=
erstand why the user visible behavior of /dev/tpmX should<br>&gt; be change=
d if there are no life and death reasons to do it. Do you<br>&gt; think tha=
t this patch is absolutely crucial for the feature<br>&gt; implemented?</fo=
nt></tt><br><br><tt><font size=3D2>This changes the module counter on the h=
ardware /
backend driver and not other user visible behavior from what I can tell.
It's certainly/hopefully not a life-and-death thing, though I am wondering
whether it's be applied sooner or later anyway for cleanup reasons following
the preceding patch providing 'strong locking'.</font></tt><br><br><tt><fon=
t size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt><font size=3D2><br>&gt; <=
br>&gt; /Jarkko<br>&gt; <br>&gt; &gt; Signed-off-by: Stefan Berger &lt;stef=
anb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;<br>&gt; &gt; ---<br>&gt; &gt; &nbsp;drivers/char=
/tpm/tpm-chip.c | 6 +-----<br>&gt; &gt; &nbsp;1 file changed, 1 insertion(+=
), 5 deletions(-)<br>&gt; &gt; <br>&gt; &gt; diff --git a/drivers/char/tpm/=
tpm-chip.c b/drivers/char/tpm/tpm-chip.c<br>&gt; &gt; index 1ae30f2..8f4b5f=
2 100644<br>&gt; &gt; --- a/drivers/char/tpm/tpm-chip.c<br>&gt; &gt; +++ b/=
drivers/char/tpm/tpm-chip.c<br>&gt; &gt; @@ -57,9 +57,6 @@ int tpm=5Ftry=5F=
get=5Fops(struct tpm=5Fchip *chip)<br>&gt; &gt; &nbsp; &nbsp; if (!chip-&gt=
;ops)<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp;goto out=5Flock;<br>&gt; &gt;=
 &nbsp;<br>&gt; &gt; - &nbsp; if (!try=5Fmodule=5Fget(chip-&gt;dev.parent-&=
gt;driver-&gt;owner))<br>&gt; &gt; - &nbsp; &nbsp; &nbsp;goto out=5Flock;<b=
r>&gt; &gt; -<br>&gt; &gt; &nbsp; &nbsp; return 0;<br>&gt; &gt; &nbsp;out=
=5Flock:<br>&gt; &gt; &nbsp; &nbsp; up=5Fread(&amp;chip-&gt;ops=5Fsem);<br>=
&gt; &gt; @@ -77,7 +74,6 @@ EXPORT=5FSYMBOL=5FGPL(tpm=5Ftry=5Fget=5Fops);<b=
r>&gt; &gt; &nbsp; */<br>&gt; &gt; &nbsp;void tpm=5Fput=5Fops(struct tpm=5F=
chip *chip)<br>&gt; &gt; &nbsp;{<br>&gt; &gt; - &nbsp; module=5Fput(chip-&g=
t;dev.parent-&gt;driver-&gt;owner);<br>&gt; &gt; &nbsp; &nbsp; up=5Fread(&a=
mp;chip-&gt;ops=5Fsem);<br>&gt; &gt; &nbsp; &nbsp; put=5Fdevice(&amp;chip-&=
gt;dev);<br>&gt; &gt; &nbsp;}<br>&gt; &gt; @@ -183,7 +179,7 @@ struct tpm=
=5Fchip *tpmm=5Fchip=5Falloc(struct device
*dev,<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp;goto out;<br>&gt; &gt; &nbsp;=
<br>&gt; &gt; &nbsp; &nbsp; cdev=5Finit(&amp;chip-&gt;cdev, &amp;tpm=5Ffops=
);<br>&gt; &gt; - &nbsp; chip-&gt;cdev.owner =3D dev-&gt;driver-&gt;owner;<=
br>&gt; &gt; + &nbsp; chip-&gt;cdev.owner =3D THIS=5FMODULE;<br>&gt; &gt; &=
nbsp; &nbsp; chip-&gt;cdev.kobj.parent =3D &amp;chip-&gt;dev.kobj;<br>&gt; =
&gt; &nbsp;<br>&gt; &gt; &nbsp; &nbsp; rc =3D devm=5Fadd=5Faction(dev, (voi=
d (*)(void *)) put=5Fdevice,
&amp;chip-&gt;dev);<br>&gt; &gt; -- <br>&gt; &gt; 2.4.3<br>&gt; &gt; <br>&g=
t; <br></font></tt><BR>
--=_alternative 00726FD785257F68_=--



--===============9157860308168631768==
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
--===============9157860308168631768==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============9157860308168631768==--
