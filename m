From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 08/11] tpm:
	IntroduceTPM_CHIP_FLAG_VIRTUAL
Date: Mon, 22 Feb 2016 20:20:03 -0500
Message-ID: <201602230120.u1N1KUTI013956@d01av03.pok.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com><1455885728-10315-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222191922.GH22088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7565985326484186770=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160222191922.GH22088-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============7565985326484186770==
Content-Type: multipart/alternative;
	boundary="=_alternative 00075CB985257F62_="


--=_alternative 00075CB985257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
02:19:22 PM:

> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Date: 02/22/2016 02:19 PM
> Subject: Re: [tpmdd-devel] [PATCH v3 08/11] tpm: Introduce=20
> TPM=5FCHIP=5FFLAG=5FVIRTUAL
>=20
> On Fri, Feb 19, 2016 at 07:42:05AM -0500, Stefan Berger wrote:
>=20
> >     cdev=5Finit(&chip->cdev, &tpm=5Ffops);
> > -   chip->cdev.owner =3D dev->driver->owner;
>=20
> Shouldn't this be:
>=20
>    chip->cdev.owner =3D THIS=5FMODULE;
>=20
> ?
>=20
> Please drop this hunk into the 'tpm: Get rid of module locking' patch

Done.

>=20
> > +
> > +   if (!(chip->flags & TPM=5FCHIP=5FFLAG=5FVIRTUAL))
> > +      err =3D sysfs=5Fcreate=5Fgroup(&chip->dev.parent->kobj,
> > +                &tpm=5Fdev=5Fgroup);
> > +   else
> > +      chip->groups[chip->groups=5Fcnt++] =3D &tpm=5Fdev=5Fgroup;
>=20
> For other reviewers: The intent here is to make another patch that
> moves the main sysfs to only use groups with symlinks link ppi does
> now.
>=20
> Does sysfs work with vtpm? I am worried about dev=5Fget=5Fdrvdata here
> (and other places):
>=20
>  static ssize=5Ft durations=5Fshow(struct device *dev, struct=20
> device=5Fattribute *attr,
>                                char *buf)
>  {
>         struct tpm=5Fchip *chip =3D dev=5Fget=5Fdrvdata(dev);
>=20
> There is only one dev=5Fset=5Fdrvdata and it does not apply to chip->dev.
>=20
> Ultimately this should change to container=5Fof like ppi does.


Fix in this patch or yet another one ?

   Stefan

>=20
> Jason
>=20
>=20
---------------------------------------------------------------------------=
---
> Site24x7 APM Insight: Get Deep Visibility into Application Performance
> APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
> Monitor end-to-end web transactions and take corrective actions now
> Troubleshoot faster and improve end-user experience. Signup Now!
> http://pubads.g.doubleclick.net/gampad/clk?id=3D272487151&iu=3D/4140
> =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>=20



--=_alternative 00075CB985257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 02:19:22 PM:<br><br>&gt; From: Jason Gunthorpe &lt;jgun=
thorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;</font></tt><br><tt><font size=3D2>&gt; To: =
Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;</font></tt><br><tt><font s=
ize=3D2>&gt; Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org</font></tt><br><tt><font=
 size=3D2>&gt; Date: 02/22/2016 02:19 PM</font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] [PATCH v3 08/11] tpm:
Introduce <br>&gt; TPM=5FCHIP=5FFLAG=5FVIRTUAL</font></tt><br><tt><font siz=
e=3D2>&gt; <br>&gt; On Fri, Feb 19, 2016 at 07:42:05AM -0500, Stefan Berger=
 wrote:<br>&gt; <br>&gt; &gt; &nbsp; &nbsp; cdev=5Finit(&amp;chip-&gt;cdev,=
 &amp;tpm=5Ffops);<br>&gt; &gt; - &nbsp; chip-&gt;cdev.owner =3D dev-&gt;dr=
iver-&gt;owner;<br>&gt; <br>&gt; Shouldn't this be:<br>&gt; <br>&gt; &nbsp;=
 &nbsp;chip-&gt;cdev.owner =3D THIS=5FMODULE;<br>&gt; <br>&gt; ?<br>&gt; <b=
r>&gt; Please drop this hunk into the 'tpm: Get rid of module locking' patc=
h</font></tt><br><tt><font size=3D2><br>Done.</font></tt><br><tt><font size=
=3D2><br>&gt; <br>&gt; &gt; +<br>&gt; &gt; + &nbsp; if (!(chip-&gt;flags &a=
mp; TPM=5FCHIP=5FFLAG=5FVIRTUAL))<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;err =
=3D sysfs=5Fcreate=5Fgroup(&amp;chip-&gt;dev.parent-&gt;kobj,<br>&gt; &gt; =
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&amp;tpm=5Fdev=5Fg=
roup);<br>&gt; &gt; + &nbsp; else<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;chip-&=
gt;groups[chip-&gt;groups=5Fcnt++]
=3D &amp;tpm=5Fdev=5Fgroup;<br>&gt; <br>&gt; For other reviewers: The inten=
t here is to make another patch that<br>&gt; moves the main sysfs to only u=
se groups with symlinks link ppi does<br>&gt; now.<br>&gt; <br>&gt; Does sy=
sfs work with vtpm? I am worried about dev=5Fget=5Fdrvdata here<br>&gt; (an=
d other places):<br>&gt; <br>&gt; &nbsp;static ssize=5Ft durations=5Fshow(s=
truct device *dev, struct <br>&gt; device=5Fattribute *attr,<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;char *buf)<br>&gt; &nbsp;{<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; struct tpm=5Fchip *chip =3D dev=5Fget=5Fdrvdat=
a(dev);<br>&gt; <br>&gt; There is only one dev=5Fset=5Fdrvdata and it does =
not apply to chip-&gt;dev.<br>&gt; <br>&gt; Ultimately this should change t=
o container=5Fof like ppi does.</font></tt><br><br><br><tt><font size=3D2>F=
ix in this patch or yet another one ?</font></tt><br><br><tt><font size=3D2=
>&nbsp; &nbsp;Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Ja=
son<br>&gt; <br>&gt; ------------------------------------------------------=
------------------------<br>&gt; Site24x7 APM Insight: Get Deep Visibility =
into Application Performance<br>&gt; APM + Mobile APM + RUM: Monitor 3 App =
instances at just $35/Month<br>&gt; Monitor end-to-end web transactions and=
 take corrective actions now<br>&gt; Troubleshoot faster and improve end-us=
er experience. Signup Now!<br>&gt; </font></tt><a href=3D"http://pubads.g.d=
oubleclick.net/gampad/clk?id=3D272487151&amp;iu=3D/4140"><tt><font size=3D2=
>http://pubads.g.doubleclick.net/gampad/clk?id=3D272487151&amp;iu=3D/4140</=
font></tt></a><tt><font size=3D2><br>&gt; =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F<br>&gt; tpmdd-devel mailing list<br>&gt; =
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>&gt; </font></tt><a href=3D"https://li=
sts.sourceforge.net/lists/listinfo/tpmdd-devel"><tt><font size=3D2>https://=
lists.sourceforge.net/lists/listinfo/tpmdd-devel</font></tt></a><tt><font s=
ize=3D2><br>&gt; <br></font></tt><BR>
--=_alternative 00075CB985257F62_=--



--===============7565985326484186770==
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
--===============7565985326484186770==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7565985326484186770==--
