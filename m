From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Tue, 16 Feb 2016 11:44:06 -0500
Message-ID: <201602161648.u1GGmmqj029901@d03av05.boulder.ibm.com>
References: <201602111534.u1BFYvRs019573@d01av03.pok.ibm.com><20160211181208.GA6285@obsidianresearch.com><201602111911.u1BJB2nK017410@d01av03.pok.ibm.com><20160211194810.GA24211@obsidianresearch.com><201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com><20160211221822.GA16304@obsidianresearch.com><201602112226.u1BMQZ59031657@d01av02.pok.ibm.com><20160211235611.GB16304@obsidianresearch.com><201602120356.u1C3usEe002034@d03av04.boulder.ibm.com><201602121813.u1CIDu4O015272@d01av01.pok.ibm.com><20160212183415.GA4289@obsidianresearch.com>
	<201602140637.u1E6baNX028563@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7112190030052393490=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201602140637.u1E6baNX028563-2xHzGjyANq4+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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


--===============7112190030052393490==
Content-Type: multipart/alternative;
	boundary="=_alternative 005BF67885257F5B_="


--=_alternative 005BF67885257F5B_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Stefan Berger/Watson/IBM@IBMUS wrote on 02/14/2016 01:37:08 AM:

>=20
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/12/
> 2016 01:34:15 PM:
>=20
> >=20
> > On Fri, Feb 12, 2016 at 01:13:39PM -0500, Stefan Berger wrote:
> > >    Stefan Berger/Watson/IBM@IBMUS wrote on 02/11/2016 10:56:47 PM:
> > >    >
> > >    > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
02/11/
> > >    > 2016 06:56:11 PM:
> > >    >
> > >    >
> > >    > >
> > >    > > On Thu, Feb 11, 2016 at 05:26:24PM -0500, Stefan Berger=20
wrote:
> > >    > >
> > >    > > >    > What is the point of tpmm=5Fchip=5Fdev?
> > >    > > >    So that the usage model of the chip is the same. We get=20
this
> > >    in the
> > >    > > >    tpm-vtpm.c with tpm=5Falloc=5Fchip + tpmm=5Fchip=5Fdev wh=
ile all
> > >    others can
> > >    > > >    call tpmm=5Fchip=5Falloc, which combines the two.
> > >    > >
> > >    > > No need, just don't use devm in vtpm, that is even better.=20
The
> > >    > > standard devm idiom is a with and without version.
> > >    >
> > >    > Updated the branch. Are you going to upstream your patch?=20
Otherwise
> > >    > I would just add your Signed-off-by to it if that's ok ?
> > >    >
> > >    > [1]https://github.com/stefanberger/linux/tree/vtpm-driver.v3
> > >    I converted tpm-chip.c to use IDA as well.
> > >    A test for 4096 vTPM instances:
> > >    for ((i =3D 0; i < 4096; i++)); do ./vtpmctrl & done
> >=20
> > Yeah, that looks good, thanks for doing this
> >=20
>=20
> With the IDR I ran into the problem that TPM core driver and backend
> now share the ID and create their device names with it. What can=20
> happen is that the core driver gives up ID 123, while the vTPM=20
> driver still has the device name vtpms123 registered with sysfs. Now
> the next device is created, ID 123 is recycled by the core driver,=20
> and it bombs while the vTPM driver again tries to register vtpm123=20
> that still hasn't been unregistered. One can trigger this problem=20
> with lots of concurrency (see below) and then the whole system even=20
> locks up. I don't know how to solve this ID issue in an easier way=20
> than having an IDR in the core driver and an IDA in the vTPM driver=20
> and so handling the IDs independently. This in turn makes the split=20
> of tpmm=5Fchip=5Falloc / tpm=5Fchip=5Falloc unnecessary since we don't ne=
ed=20
> the ID from the chip anymore. Now the below test runs stable.

Scratch that. The easier way to fix this was to release the tpm=5Fchip afte=
r=20
the vtpm=5Fdev.

   Stefan


>=20
>=20
> for pid in $(ps aux | grep vtpm | gawk '{print $2}'); do kill -9=20
> $pid; done ; for ((i =3D0; i< 8192; i++)); do ./vtpmctrl &>/dev/null &=20
done
>=20
>  Stefan
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



--=_alternative 005BF67885257F5B_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Stefan Berger/Watson/IBM@IBMUS wrote on 02/14/2016 01:37=
:08
AM:<br></font></tt><br><tt><font size=3D2>&gt; <br>&gt; Jason Gunthorpe &lt=
;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt; wrote on 02/12/<br>&gt; 2016 01:34:15 =
PM:<br>&gt; <br>&gt; &gt; <br>&gt; &gt; On Fri, Feb 12, 2016 at 01:13:39PM =
-0500, Stefan Berger wrote:<br>&gt; &gt; &gt; &nbsp; &nbsp;Stefan Berger/Wa=
tson/IBM@IBMUS wrote on 02/11/2016
10:56:47 PM:<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &gt; &nbsp; &=
nbsp;&gt; Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/11/<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; 2016 06:56:11 PM:<br>&g=
t; &gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; =
&gt; &gt; &nbsp; &nbsp;&gt; &gt;<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; &gt; O=
n Thu, Feb 11, 2016 at 05:26:24PM
-0500, Stefan Berger wrote:<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; &gt;<br>&gt=
; &gt; &gt; &nbsp; &nbsp;&gt; &gt; &gt; &nbsp; &nbsp;&gt; What is the
point of tpmm=5Fchip=5Fdev?<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; &gt; &gt; &=
nbsp; &nbsp;So that the usage
model of the chip is the same. We get this<br>&gt; &gt; &gt; &nbsp; &nbsp;i=
n the<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; &gt; &gt; &nbsp; &nbsp;tpm-vtpm.c=
 with
tpm=5Falloc=5Fchip + tpmm=5Fchip=5Fdev while all<br>&gt; &gt; &gt; &nbsp; &=
nbsp;others can<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; &gt; &gt; &nbsp; &nbsp;=
call tpmm=5Fchip=5Falloc,
which combines the two.<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; &gt;<br>&gt; &g=
t; &gt; &nbsp; &nbsp;&gt; &gt; No need, just don't use devm in vtpm,
that is even better. The<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; &gt; standard =
devm idiom is a with and
without version.<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &gt; &nbs=
p; &nbsp;&gt; Updated the branch. Are you going to upstream
your patch? Otherwise<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; I would just add =
your Signed-off-by to
it if that's ok ?<br>&gt; &gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &gt; &nb=
sp; &nbsp;&gt; [1]</font></tt><a href=3D"https://github.com/stefanberger/li=
nux/tree/vtpm-driver.v3"><tt><font size=3D2>https://github.com/stefanberger=
/linux/tree/vtpm-driver.v3</font></tt></a><tt><font size=3D2><br>&gt; &gt; =
&gt; &nbsp; &nbsp;I converted tpm-chip.c to use IDA as well.<br>&gt; &gt; &=
gt; &nbsp; &nbsp;A test for 4096 vTPM instances:<br>&gt; &gt; &gt; &nbsp; &=
nbsp;for ((i =3D 0; i &lt; 4096; i++)); do ./vtpmctrl
&amp; done<br>&gt; &gt; <br>&gt; &gt; Yeah, that looks good, thanks for doi=
ng this<br>&gt; &gt; <br>&gt; <br>&gt; With the IDR I ran into the problem =
that TPM core driver and backend<br>&gt; now share the ID and create their =
device names with it. What can <br>&gt; happen is that the core driver give=
s up ID 123, while the vTPM <br>&gt; driver still has the device name vtpms=
123 registered with sysfs. Now<br>&gt; the next device is created, ID 123 i=
s recycled by the core driver,
<br>&gt; and it bombs while the vTPM driver again tries to register vtpm123
<br>&gt; that still hasn't been unregistered. One can trigger this problem
<br>&gt; with lots of concurrency (see below) and then the whole system even
<br>&gt; locks up. I don't know how to solve this ID issue in an easier way
<br>&gt; than having an IDR in the core driver and an IDA in the vTPM driver
<br>&gt; and so handling the IDs independently. This in turn makes the split
<br>&gt; of tpmm=5Fchip=5Falloc / tpm=5Fchip=5Falloc unnecessary since we d=
on't need
<br>&gt; the ID from the chip anymore. Now the below test runs stable.</fon=
t></tt><br><br><tt><font size=3D2>Scratch that. The easier way to fix this =
was to release
the tpm=5Fchip after the vtpm=5Fdev.</font></tt><br><br><tt><font size=3D2>=
&nbsp; &nbsp;Stefan</font></tt><br><br><tt><font size=3D2><br>&gt; <br>&gt;=
 <br>&gt; for pid in $(ps aux | grep vtpm | gawk '{print $2}'); do kill -9 =
<br>&gt; $pid; done ; for ((i =3D0; i&lt; 8192; i++)); do ./vtpmctrl &amp;&=
gt;/dev/null
&amp; done<br>&gt; <br>&gt; &nbsp;Stefan<br>&gt; --------------------------=
----------------------------------------------------<br>&gt; Site24x7 APM I=
nsight: Get Deep Visibility into Application Performance<br>&gt; APM + Mobi=
le APM + RUM: Monitor 3 App instances at just $35/Month<br>&gt; Monitor end=
-to-end web transactions and take corrective actions now<br>&gt; Troublesho=
ot faster and improve end-user experience. Signup Now!<br>&gt; </font></tt>=
<a href=3D"http://pubads.g.doubleclick.net/gampad/clk?id=3D272487151&amp;iu=
=3D/4140"><tt><font size=3D2>http://pubads.g.doubleclick.net/gampad/clk?id=
=3D272487151&amp;iu=3D/4140</font></tt></a><tt><font size=3D2><br>&gt; =5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F<br>&gt; tpm=
dd-devel mailing list<br>&gt; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>&gt; </f=
ont></tt><a href=3D"https://lists.sourceforge.net/lists/listinfo/tpmdd-deve=
l"><tt><font size=3D2>https://lists.sourceforge.net/lists/listinfo/tpmdd-de=
vel</font></tt></a><tt><font size=3D2><br></font></tt><BR>
--=_alternative 005BF67885257F5B_=--



--===============7112190030052393490==
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
--===============7112190030052393490==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7112190030052393490==--
