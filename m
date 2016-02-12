From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 13:13:39 -0500
Message-ID: <201602121810.u1CIAZn7013811@d01av05.pok.ibm.com>
References: <20160210222313.GA7047@obsidianresearch.com><201602110038.u1B0cuE0030670@d03av05.boulder.ibm.com><20160211070426.GB9307@intel.com><201602111534.u1BFYvRs019573@d01av03.pok.ibm.com><20160211181208.GA6285@obsidianresearch.com><201602111911.u1BJB2nK017410@d01av03.pok.ibm.com><20160211194810.GA24211@obsidianresearch.com><201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com><20160211221822.GA16304@obsidianresearch.com><201602112226.u1BMQZ59031657@d01av02.pok.ibm.com><20160211235611.GB16304@obsidianresearch.com>
	<201602120356.u1C3usEe002034@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0590726878686834990=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201602120356.u1C3usEe002034-2xHzGjyANq4+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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


--===============0590726878686834990==
Content-Type: multipart/alternative;
	boundary="=_alternative 0064293385257F57_="


--=_alternative 0064293385257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Stefan Berger/Watson/IBM@IBMUS wrote on 02/11/2016 10:56:47 PM:

>=20
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/11/
> 2016 06:56:11 PM:
>=20
>=20
> >=20
> > On Thu, Feb 11, 2016 at 05:26:24PM -0500, Stefan Berger wrote:
> >=20
> > >    > What is the point of tpmm=5Fchip=5Fdev?
> > >    So that the usage model of the chip is the same. We get this in=20
the
> > >    tpm-vtpm.c with tpm=5Falloc=5Fchip + tpmm=5Fchip=5Fdev while all o=
thers=20
can
> > >    call tpmm=5Fchip=5Falloc, which combines the two.
> >=20
> > No need, just don't use devm in vtpm, that is even better. The
> > standard devm idiom is a with and without version.
>=20
> Updated the branch. Are you going to upstream your patch? Otherwise=20
> I would just add your Signed-off-by to it if that's ok ?
>=20
> https://github.com/stefanberger/linux/tree/vtpm-driver.v3

I converted tpm-chip.c to use IDA as well.=20

A test for 4096 vTPM instances:

for ((i =3D 0; i < 4096; i++)); do ./vtpmctrl & done

   Stefan



--=_alternative 0064293385257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Stefan Berger/Watson/IBM@IBMUS wrote on 02/11/2016 10:56=
:47
PM:<br><br>&gt; <br>&gt; Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMNAWLNoT+7d/@public.gmane.org=
m&gt; wrote on 02/11/<br>&gt; 2016 06:56:11 PM:<br>&gt; <br>&gt; <br>&gt; &=
gt; <br>&gt; &gt; On Thu, Feb 11, 2016 at 05:26:24PM -0500, Stefan Berger w=
rote:<br>&gt; &gt; <br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; What is the point o=
f tpmm=5Fchip=5Fdev?<br>&gt; &gt; &gt; &nbsp; &nbsp;So that the usage model=
 of the chip is the
same. We get this in the<br>&gt; &gt; &gt; &nbsp; &nbsp;tpm-vtpm.c with tpm=
=5Falloc=5Fchip + tpmm=5Fchip=5Fdev
while all others can<br>&gt; &gt; &gt; &nbsp; &nbsp;call tpmm=5Fchip=5Fallo=
c, which combines the two.<br>&gt; &gt; <br>&gt; &gt; No need, just don't u=
se devm in vtpm, that is even better. The<br>&gt; &gt; standard devm idiom =
is a with and without version.<br>&gt; <br>&gt; Updated the branch. Are you=
 going to upstream your patch? Otherwise
<br>&gt; I would just add your Signed-off-by to it if that's ok ?<br>&gt; <=
br>&gt; </font></tt><a href=3D"https://github.com/stefanberger/linux/tree/v=
tpm-driver.v3"><tt><font size=3D2 color=3Dblue>https://github.com/stefanber=
ger/linux/tree/vtpm-driver.v3</font></tt></a><br><br><tt><font size=3D2>I c=
onverted tpm-chip.c to use IDA as well. </font></tt><br><br><tt><font size=
=3D2>A test for 4096 vTPM instances:</font></tt><br><br><tt><font size=3D2>=
for ((i =3D 0; i &lt; 4096; i++)); do ./vtpmctrl &amp;
done</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><=
br><BR>
--=_alternative 0064293385257F57_=--



--===============0590726878686834990==
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
--===============0590726878686834990==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0590726878686834990==--
