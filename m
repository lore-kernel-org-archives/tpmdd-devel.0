From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 08/11] tpm:
	IntroduceTPM_CHIP_FLAG_VIRTUAL
Date: Mon, 22 Feb 2016 22:40:32 -0500
Message-ID: <201602230340.u1N3ewwD029310@d03av04.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222191922.GH22088@obsidianresearch.com>
	<201602230121.u1N1LYk2024786@d01av01.pok.ibm.com>
	<20160223020515.GA26177@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4072322056463761113=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160223020515.GA26177-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============4072322056463761113==
Content-Type: multipart/alternative;
	boundary="=_alternative 0014394785257F62_="


--=_alternative 0014394785257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
09:05:15 PM:

>=20
> On Mon, Feb 22, 2016 at 08:21:09PM -0500, Stefan Berger wrote:
> >=20
> > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/
> 2016 02:19:22
> > PM:
> >=20
> >=20
> > > > +
> > > > +   if (!(chip->flags & TPM=5FCHIP=5FFLAG=5FVIRTUAL))
> > > > +      err =3D sysfs=5Fcreate=5Fgroup(&chip->dev.parent->kobj,
> > > > +                &tpm=5Fdev=5Fgroup);
> > > > +   else
> > > > +      chip->groups[chip->groups=5Fcnt++] =3D &tpm=5Fdev=5Fgroup;
> > >
> > > For other reviewers: The intent here is to make another patch that
> > > moves the main sysfs to only use groups with symlinks link ppi does
> > > now.
> > >
> > > Does sysfs work with vtpm? I am worried about dev=5Fget=5Fdrvdata here
> > > (and other places):
> >=20
> > Yes, works. I have a set=5Fdrv=5Fdata in the vtpm driver.
>=20
> ?? I don't see that in the vtpm patch posted to the list? Can you
> point me to it?

That was in the past that I had that call ... when there still was a=20
device and when sysfs was still working.

I now converted the dev=5Fget=5Fdrvdata in tpm-interface.c and tpm-sysfs.c =
to=20
container=5Fof to make sysfs work for vtpm. It has to be part of this patch.

  Stefan

>=20
> In any event, the core code should be self contained and not rely on
> things in the drivers like this.
>=20
> Jason
>=20



--=_alternative 0014394785257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 09:05:15 PM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Mon, Feb 22, 2016 at 08:21:09PM -0500, Stefan Berger wrote:<br=
>&gt; &gt; <br>&gt; &gt; Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMNAWLNoT+7d/@public.gmane.org=
m&gt; wrote
on 02/22/<br>&gt; 2016 02:19:22<br>&gt; &gt; PM:<br>&gt; &gt; <br>&gt; &gt;=
 <br>&gt; &gt; &gt; &gt; +<br>&gt; &gt; &gt; &gt; + &nbsp; if (!(chip-&gt;f=
lags &amp; TPM=5FCHIP=5FFLAG=5FVIRTUAL))<br>&gt; &gt; &gt; &gt; + &nbsp; &n=
bsp; &nbsp;err =3D sysfs=5Fcreate=5Fgroup(&amp;chip-&gt;dev.parent-&gt;kobj=
,<br>&gt; &gt; &gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;&amp;tpm=5Fdev=5Fgroup);<br>&gt; &gt; &gt; &gt; + &nbsp; else<br>&gt;=
 &gt; &gt; &gt; + &nbsp; &nbsp; &nbsp;chip-&gt;groups[chip-&gt;groups=5Fcnt=
++]
=3D &amp;tpm=5Fdev=5Fgroup;<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; For other r=
eviewers: The intent here is to make another
patch that<br>&gt; &gt; &gt; moves the main sysfs to only use groups with s=
ymlinks link
ppi does<br>&gt; &gt; &gt; now.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; Does sy=
sfs work with vtpm? I am worried about dev=5Fget=5Fdrvdata
here<br>&gt; &gt; &gt; (and other places):<br>&gt; &gt; <br>&gt; &gt; Yes, =
works. I have a set=5Fdrv=5Fdata in the vtpm driver.<br>&gt; <br>&gt; ?? I =
don't see that in the vtpm patch posted to the list? Can you<br>&gt; point =
me to it?</font></tt><br><br><tt><font size=3D2>That was in the past that I=
 had that call ... when
there still was a device and when sysfs was still working.</font></tt><br><=
br><tt><font size=3D2>I now converted the dev=5Fget=5Fdrvdata in tpm-interf=
ace.c
and tpm-sysfs.c to container=5Fof to make sysfs work for vtpm. It has to
be part of this patch.</font></tt><br><br><tt><font size=3D2>&nbsp; Stefan<=
/font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; In any event, the core =
code should be self contained and not rely
on<br>&gt; things in the drivers like this.<br>&gt; <br>&gt; Jason<br>&gt; =
<br></font></tt><BR>
--=_alternative 0014394785257F62_=--



--===============4072322056463761113==
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
--===============4072322056463761113==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4072322056463761113==--
