From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Thu, 11 Feb 2016 10:24:18 -0500
Message-ID: <201602111521.u1BFLS3f007520@d01av05.pok.ibm.com>
References: <1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
	<201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
	<20160210035620.GB7161@intel.com>
	<201602100515.u1A5FpFi002736@d03av02.boulder.ibm.com>
	<20160210162809.GB20730@obsidianresearch.com>
	<201602102145.u1ALjSAs001597@d03av04.boulder.ibm.com>
	<20160210222313.GA7047@obsidianresearch.com>
	<201602110038.u1B0cuE0030670@d03av05.boulder.ibm.com>
	<20160211070426.GB9307@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4897970045091176542=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160211070426.GB9307-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============4897970045091176542==
Content-Type: multipart/alternative;
	boundary="=_alternative 0054A7CE85257F56_="


--=_alternative 0054A7CE85257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/11/2016=20
02:04:26 AM:

> From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> To: Stefan Berger/Watson/IBM@IBMUS
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,=20
> dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,=20
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Date: 02/11/2016 02:04 AM
> Subject: Re: [tpmdd-devel] [PATCH v5 4/5] Initialize TPM and get=20
> durations and timeouts
>=20
> On Wed, Feb 10, 2016 at 07:38:52PM -0500, Stefan Berger wrote:
> >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
02/10/2016
> >    05:23:13 PM:
> >=20
> >    >
> >    >
> >    > >    > We shouldn't artificially limit the number of devices if
> >    > >    > virtualization is the target. Use an idr, or figure out=20
how to
> >    get rid
> >    > >    > of it. Since it is only used here:
> >    > >    >
> >    > >    >     dev=5Fset=5Fname(&vtpm=5Fdev->dev, "vtpms%d",=20
vtpm=5Fdev->dev=5Fnum);
> >    > >    >
> >    > >    > Maybe it could be adjusted to use chip->dev=5Fnum instead.
> >    >
> >    > >    The chip->dev=5Fnum comes back from tpmm=5Fchip=5Falloc()=20
> which is called
> >    > >    with the device as a parameter. That's the device we're=20
trying to
> >    >
> >    > Hm, that is only needed for devm, could also do the tpm/tpmm=20
split and
> >    > avoid needing a registered dev.
> >    >
> >=20
> >    How about another patch on top of the ones I have so far only=20
> solving this
> >    problem ?
>=20
> IDR has been on my backlog for a long time (over a year now).
>=20
> If you'd create a patch that would migrate the subsystem to that and
> do also do this split, I could take that patch as an independent
> contribution and you would have a better baseline to develop on top
> of. What do you think?

We need two steps here. One to let tpmm=5Fchip=5Falloc call two functions=20
tpm=5Fchip=5Falloc + tpmm=5Fchip=5Fdev (better name?), which are both going=
 to be=20
public and called by tpm-vtpm.c, and provide tpm=5Fchip=5Ffree. Let me do=20
that. Then we can get rid of the bitmap for the chip->dev=5Fnum=20
independently and use idr there.


   Stefan
>=20
> /Jarkko
>=20



--=_alternative 0054A7CE85257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 02/11/2016 02:04:26 AM:<br><br>&gt; From: Jarkko Sakkinen &lt;jark=
ko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;</font></tt><br><tt><font size=3D2>&gt; To: =
Stefan Berger/Watson/IBM@IBMUS</font></tt><br><tt><font size=3D2>&gt; Cc: J=
ason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;,
<br>&gt; dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tpmdd-devel-5NWGOfrQmncRDUWM+popnw@public.gmane.org=
forge.net</font></tt><br><tt><font size=3D2>&gt; Date: 02/11/2016 02:04 AM<=
/font></tt><br><tt><font size=3D2>&gt; Subject: Re: [tpmdd-devel] [PATCH v5=
 4/5] Initialize
TPM and get <br>&gt; durations and timeouts</font></tt><br><tt><font size=
=3D2>&gt; <br>&gt; On Wed, Feb 10, 2016 at 07:38:52PM -0500, Stefan Berger =
wrote:<br>&gt; &gt; &nbsp; &nbsp;Jason Gunthorpe &lt;jgunthorpe@obsidianres=
earch.com&gt;
wrote on 02/10/2016<br>&gt; &gt; &nbsp; &nbsp;05:23:13 PM:<br>&gt; &gt; <br=
>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &n=
bsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; We shouldn't artificially
limit the number of devices if<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &=
nbsp;&gt; virtualization is the
target. Use an idr, or figure out how to<br>&gt; &gt; &nbsp; &nbsp;get rid<=
br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; of it. Since it is on=
ly
used here:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &g=
t; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &nbsp; &nbsp; dev=5Fset=5Fname(=
&amp;vtpm=5Fdev-&gt;dev,
&quot;vtpms%d&quot;, vtpm=5Fdev-&gt;dev=5Fnum);<br>&gt; &gt; &nbsp; &nbsp;&=
gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp=
;&gt; Maybe it could be adjusted
to use chip-&gt;dev=5Fnum instead.<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &=
gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;The chip-&gt;dev=5Fnum comes
back from tpmm=5Fchip=5Falloc() <br>&gt; which is called<br>&gt; &gt; &nbsp=
; &nbsp;&gt; &gt; &nbsp; &nbsp;with the device as a parameter.
That's the device we're trying to<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &g=
t; &nbsp; &nbsp;&gt; Hm, that is only needed for devm, could also
do the tpm/tpmm split and<br>&gt; &gt; &nbsp; &nbsp;&gt; avoid needing a re=
gistered dev.<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; <br>&gt; &gt; &nb=
sp; &nbsp;How about another patch on top of the ones I have
so far only <br>&gt; solving this<br>&gt; &gt; &nbsp; &nbsp;problem ?<br>&g=
t; <br>&gt; IDR has been on my backlog for a long time (over a year now).<b=
r>&gt; <br>&gt; If you'd create a patch that would migrate the subsystem to=
 that and<br>&gt; do also do this split, I could take that patch as an inde=
pendent<br>&gt; contribution and you would have a better baseline to develo=
p on top<br>&gt; of. What do you think?</font></tt><br><br><tt><font size=
=3D2>We need two steps here. One to let tpmm=5Fchip=5Falloc
call two functions tpm=5Fchip=5Falloc + tpmm=5Fchip=5Fdev (better name?), w=
hich
are both going to be public and called by tpm-vtpm.c, and provide tpm=5Fchi=
p=5Ffree.
Let me do that. Then we can get rid of the bitmap for the chip-&gt;dev=5Fnum
independently and use idr there.</font></tt><br><br><br><tt><font size=3D2>=
&nbsp; &nbsp;Stefan<br>&gt; <br>&gt; /Jarkko<br>&gt; <br></font></tt><BR>
--=_alternative 0054A7CE85257F56_=--



--===============4897970045091176542==
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
--===============4897970045091176542==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4897970045091176542==--
