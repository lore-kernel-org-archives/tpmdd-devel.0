From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 03/11] tpm: Get rid of devname
Date: Mon, 22 Feb 2016 19:22:56 -0500
Message-ID: <201602230023.u1N0NO69020368@d03av05.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com><1455885728-10315-4-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222181929.GB22088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8091002323149278748=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160222181929.GB22088-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============8091002323149278748==
Content-Type: multipart/alternative;
	boundary="=_alternative 0002223D85257F62_="


--=_alternative 0002223D85257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
01:19:29 PM:

> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Date: 02/22/2016 01:20 PM
> Subject: Re: [tpmdd-devel] [PATCH v3 03/11] tpm: Get rid of devname
>=20
> On Fri, Feb 19, 2016 at 07:42:00AM -0500, Stefan Berger wrote:
> >=20
> > -   dev=5Fset=5Fname(&chip->dev, "%s", chip->devname);
> > +   err =3D dev=5Fset=5Fname(&chip->dev, "tpm%d", chip->dev=5Fnum);
> > +   if (err)
> > +      goto out;
> >=20
> >     device=5Finitialize(&chip->dev);
> >=20
> > @@ -142,6 +142,10 @@ struct tpm=5Fchip *tpmm=5Fchip=5Falloc(struct devi=
ce=20
*dev,
> >     }
> >=20
> >     return chip;
> > +
> > +out:
> > +   put=5Fdevice(&chip->dev);
> > +   return ERR=5FPTR(err);
>=20
> Oops, something went wrong here in all the rebasing - dev=5Fset=5Fname has
> to be after devince=5Finitialize.

dev=5Fset=5Fname is now after device=5Finitialize.

   Stefan



--=_alternative 0002223D85257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 01:19:29 PM:<br><br>&gt; From: Jason Gunthorpe &lt;jgun=
thorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;</font></tt><br><tt><font size=3D2>&gt; To: =
Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;</font></tt><br><tt><font s=
ize=3D2>&gt; Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org</font></tt><br><tt><font=
 size=3D2>&gt; Date: 02/22/2016 01:20 PM</font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] [PATCH v3 03/11] tpm:
Get rid of devname</font></tt><br><tt><font size=3D2>&gt; <br>&gt; On Fri, =
Feb 19, 2016 at 07:42:00AM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp;<=
br>&gt; &gt; - &nbsp; dev=5Fset=5Fname(&amp;chip-&gt;dev, &quot;%s&quot;, c=
hip-&gt;devname);<br>&gt; &gt; + &nbsp; err =3D dev=5Fset=5Fname(&amp;chip-=
&gt;dev, &quot;tpm%d&quot;,
chip-&gt;dev=5Fnum);<br>&gt; &gt; + &nbsp; if (err)<br>&gt; &gt; + &nbsp; &=
nbsp; &nbsp;goto out;<br>&gt; &gt; &nbsp;<br>&gt; &gt; &nbsp; &nbsp; device=
=5Finitialize(&amp;chip-&gt;dev);<br>&gt; &gt; &nbsp;<br>&gt; &gt; @@ -142,=
6 +142,10 @@ struct tpm=5Fchip *tpmm=5Fchip=5Falloc(struct
device *dev,<br>&gt; &gt; &nbsp; &nbsp; }<br>&gt; &gt; &nbsp;<br>&gt; &gt; =
&nbsp; &nbsp; return chip;<br>&gt; &gt; +<br>&gt; &gt; +out:<br>&gt; &gt; +=
 &nbsp; put=5Fdevice(&amp;chip-&gt;dev);<br>&gt; &gt; + &nbsp; return ERR=
=5FPTR(err);<br>&gt; <br>&gt; Oops, something went wrong here in all the re=
basing - dev=5Fset=5Fname
has<br>&gt; to be after devince=5Finitialize.</font></tt><br><br><tt><font =
size=3D2>dev=5Fset=5Fname is now after device=5Finitialize.</font></tt><br>=
<br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 0002223D85257F62_=--



--===============8091002323149278748==
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
--===============8091002323149278748==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8091002323149278748==--
