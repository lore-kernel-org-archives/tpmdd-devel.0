From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Thu, 11 Feb 2016 11:51:26 -0500
Message-ID: <201602111648.u1BGmEad031286@d01av05.pok.ibm.com>
References: <1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com><20160209053323.GD12657@obsidianresearch.com><201602091626.u19GQpga021574@d01av02.pok.ibm.com><20160209165228.GA14611@obsidianresearch.com><20160210035620.GB7161@intel.com><201602100515.u1A5FpFi002736@d03av02.boulder.ibm.com><20160210162809.GB20730@obsidianresearch.com><201602102145.u1ALjSAs001597@d03av04.boulder.ibm.com><20160210222313.GA7047@obsidianresearch.com><201602110038.u1B0cuE0030670@d03av05.boulder.ibm.com><20160211070426.GB9307@intel.com>
	<201602111521.u1BFLS3f007520@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6940923855591452043=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201602111521.u1BFLS3f007520-8DuMPbUlb4HImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============6940923855591452043==
Content-Type: multipart/alternative;
	boundary="=_alternative 005CA1EA85257F56_="


--=_alternative 005CA1EA85257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Stefan Berger/Watson/IBM@IBMUS wrote on 02/11/2016 10:24:18 AM:


> > If you'd create a patch that would migrate the subsystem to that and
> > do also do this split, I could take that patch as an independent
> > contribution and you would have a better baseline to develop on top
> > of. What do you think?
>=20
> We need two steps here. One to let tpmm=5Fchip=5Falloc call two=20
> functions tpm=5Fchip=5Falloc + tpmm=5Fchip=5Fdev (better name?), which ar=
e=20
> both going to be public and called by tpm-vtpm.c, and provide=20
> tpm=5Fchip=5Ffree. Let me do that. Then we can get rid of the bitmap for
> the chip->dev=5Fnum independently and use idr there.
>=20

Updated my branch now and based the driver on this function.

https://github.com/stefanberger/linux/commits/vtpm-driver.v3

No current driver needs this additional patch I think. So it can wait. I=20
fixed a locking problem on the way, though...

    Stefan



--=_alternative 005CA1EA85257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Stefan Berger/Watson/IBM@IBMUS wrote on 02/11/2016 10:24=
:18
AM:<br><br><br>&gt; &gt; If you'd create a patch that would migrate the sub=
system to that
and<br>&gt; &gt; do also do this split, I could take that patch as an indep=
endent<br>&gt; &gt; contribution and you would have a better baseline to de=
velop
on top<br>&gt; &gt; of. What do you think?<br>&gt; <br>&gt; We need two ste=
ps here. One to let tpmm=5Fchip=5Falloc call two <br>&gt; functions tpm=5Fc=
hip=5Falloc + tpmm=5Fchip=5Fdev (better name?), which are
<br>&gt; both going to be public and called by tpm-vtpm.c, and provide <br>=
&gt; tpm=5Fchip=5Ffree. Let me do that. Then we can get rid of the bitmap f=
or<br>&gt; the chip-&gt;dev=5Fnum independently and use idr there.<br>&gt; =
</font></tt><br><br><tt><font size=3D2>Updated my branch now and based the =
driver on this
function.</font></tt><br><br><a href=3D"https://github.com/stefanberger/lin=
ux/commits/vtpm-driver.v3"><tt><font size=3D2 color=3Dblue>https://github.c=
om/stefanberger/linux/commits/vtpm-driver.v3</font></tt></a><tt><font size=
=3D2><br></font></tt><br><tt><font size=3D2>No current driver needs this ad=
ditional patch I think.
So it can wait. I fixed a locking problem on the way, though...</font></tt>=
<br><br><tt><font size=3D2>&nbsp; &nbsp; Stefan</font></tt><br><BR>
--=_alternative 005CA1EA85257F56_=--



--===============6940923855591452043==
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
--===============6940923855591452043==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6940923855591452043==--
