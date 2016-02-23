From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 08/11] tpm:
	IntroduceTPM_CHIP_FLAG_VIRTUAL
Date: Mon, 22 Feb 2016 20:21:09 -0500
Message-ID: <201602230121.u1N1LYfF030436@d03av05.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com><1455885728-10315-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222191922.GH22088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4014043945833913289=="
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


--===============4014043945833913289==
Content-Type: multipart/alternative;
	boundary="=_alternative 0007768085257F62_="


--=_alternative 0007768085257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
02:19:22 PM:


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

Yes, works. I have a set=5Fdrv=5Fdata in the vtpm driver.

   Stefan



--=_alternative 0007768085257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"


<br><tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&=
gt;
wrote on 02/22/2016 02:19:22 PM:<br></font></tt><br><tt><font size=3D2><br>=
&gt; &gt; +<br>&gt; &gt; + &nbsp; if (!(chip-&gt;flags &amp; TPM=5FCHIP=5FF=
LAG=5FVIRTUAL))<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;err =3D sysfs=5Fcreate=
=5Fgroup(&amp;chip-&gt;dev.parent-&gt;kobj,<br>&gt; &gt; + &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&amp;tpm=5Fdev=5Fgroup);<br>&gt; &gt=
; + &nbsp; else<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;chip-&gt;groups[chip-&gt=
;groups=5Fcnt++]
=3D &amp;tpm=5Fdev=5Fgroup;<br>&gt; <br>&gt; For other reviewers: The inten=
t here is to make another patch that<br>&gt; moves the main sysfs to only u=
se groups with symlinks link ppi does<br>&gt; now.<br>&gt; <br>&gt; Does sy=
sfs work with vtpm? I am worried about dev=5Fget=5Fdrvdata here<br>&gt; (an=
d other places):</font></tt><br><br><tt><font size=3D2>Yes, works. I have a=
 set=5Fdrv=5Fdata in the vtpm driver.</font></tt><br><br><tt><font size=3D2=
>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 0007768085257F62_=--



--===============4014043945833913289==
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
--===============4014043945833913289==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4014043945833913289==--
