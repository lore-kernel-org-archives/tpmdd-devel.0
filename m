From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Sun, 14 Feb 2016 01:37:08 -0500
Message-ID: <201602140637.u1E6baNX028563@d03av04.boulder.ibm.com>
References: <201602111534.u1BFYvRs019573@d01av03.pok.ibm.com>
	<20160211181208.GA6285@obsidianresearch.com>
	<201602111911.u1BJB2nK017410@d01av03.pok.ibm.com>
	<20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120356.u1C3usEe002034@d03av04.boulder.ibm.com>
	<201602121813.u1CIDu4O015272@d01av01.pok.ibm.com>
	<20160212183415.GA4289@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1877858074929885965=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160212183415.GA4289-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============1877858074929885965==
Content-Type: multipart/alternative;
	boundary="=_alternative 0024647585257F59_="


--=_alternative 0024647585257F59_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/12/2016=20
01:34:15 PM:

>=20
> On Fri, Feb 12, 2016 at 01:13:39PM -0500, Stefan Berger wrote:
> >    Stefan Berger/Watson/IBM@IBMUS wrote on 02/11/2016 10:56:47 PM:
> >    >
> >    > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/11/
> >    > 2016 06:56:11 PM:
> >    >
> >    >
> >    > >
> >    > > On Thu, Feb 11, 2016 at 05:26:24PM -0500, Stefan Berger wrote:
> >    > >
> >    > > >    > What is the point of tpmm=5Fchip=5Fdev?
> >    > > >    So that the usage model of the chip is the same. We get=20
this
> >    in the
> >    > > >    tpm-vtpm.c with tpm=5Falloc=5Fchip + tpmm=5Fchip=5Fdev whil=
e all
> >    others can
> >    > > >    call tpmm=5Fchip=5Falloc, which combines the two.
> >    > >
> >    > > No need, just don't use devm in vtpm, that is even better. The
> >    > > standard devm idiom is a with and without version.
> >    >
> >    > Updated the branch. Are you going to upstream your patch?=20
Otherwise
> >    > I would just add your Signed-off-by to it if that's ok ?
> >    >
> >    > [1]https://github.com/stefanberger/linux/tree/vtpm-driver.v3
> >    I converted tpm-chip.c to use IDA as well.
> >    A test for 4096 vTPM instances:
> >    for ((i =3D 0; i < 4096; i++)); do ./vtpmctrl & done
>=20
> Yeah, that looks good, thanks for doing this
>=20

With the IDR I ran into the problem that TPM core driver and backend now=20
share the ID and create their device names with it. What can happen is=20
that the core driver gives up ID 123, while the vTPM driver still has the=20
device name vtpms123 registered with sysfs. Now the next device is=20
created, ID 123 is recycled by the core driver, and it bombs while the=20
vTPM driver again tries to register vtpm123 that still hasn't been=20
unregistered. One can trigger this problem with lots of concurrency (see=20
below) and then the whole system even locks up. I don't know how to solve=20
this ID issue in an easier way than having an IDR in the core driver and=20
an IDA in the vTPM driver and so handling the IDs independently. This in=20
turn makes the split of tpmm=5Fchip=5Falloc / tpm=5Fchip=5Falloc unnecessar=
y since=20
we don't need the ID from the chip anymore. Now the below test runs=20
stable.


for pid in $(ps aux | grep vtpm | gawk '{print $2}'); do kill -9 $pid;=20
done ; for ((i =3D0; i< 8192; i++)); do ./vtpmctrl &>/dev/null & done

 Stefan



--=_alternative 0024647585257F59_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/12/2016 01:34:15 PM:<br><br>&gt; <br>&gt; On Fri, Feb 12, 2016 =
at 01:13:39PM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;Stefan =
Berger/Watson/IBM@IBMUS wrote on 02/11/2016
10:56:47 PM:<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; =
Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/11/<br>&gt; &gt; &nbsp; &nbsp;&gt; 2016 06:56:11 PM:<br>&gt; &g=
t; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nb=
sp;&gt; &gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; On Thu, Feb 11, 2016 at 05=
:26:24PM -0500,
Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt;<br>&gt; &gt; &nbsp=
; &nbsp;&gt; &gt; &gt; &nbsp; &nbsp;&gt; What is the point
of tpmm=5Fchip=5Fdev?<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &gt; &nbsp; &nbsp=
;So that the usage model
of the chip is the same. We get this<br>&gt; &gt; &nbsp; &nbsp;in the<br>&g=
t; &gt; &nbsp; &nbsp;&gt; &gt; &gt; &nbsp; &nbsp;tpm-vtpm.c with tpm=5Fallo=
c=5Fchip
+ tpmm=5Fchip=5Fdev while all<br>&gt; &gt; &nbsp; &nbsp;others can<br>&gt; =
&gt; &nbsp; &nbsp;&gt; &gt; &gt; &nbsp; &nbsp;call tpmm=5Fchip=5Falloc,
which combines the two.<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt;<br>&gt; &gt; &n=
bsp; &nbsp;&gt; &gt; No need, just don't use devm in vtpm,
that is even better. The<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; standard devm =
idiom is a with and without
version.<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; Upda=
ted the branch. Are you going to upstream
your patch? Otherwise<br>&gt; &gt; &nbsp; &nbsp;&gt; I would just add your =
Signed-off-by to it if
that's ok ?<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; [=
1]</font></tt><a href=3D"https://github.com/stefanberger/linux/tree/vtpm-dr=
iver.v3"><tt><font size=3D2>https://github.com/stefanberger/linux/tree/vtpm=
-driver.v3</font></tt></a><tt><font size=3D2><br>&gt; &gt; &nbsp; &nbsp;I c=
onverted tpm-chip.c to use IDA as well.<br>&gt; &gt; &nbsp; &nbsp;A test fo=
r 4096 vTPM instances:<br>&gt; &gt; &nbsp; &nbsp;for ((i =3D 0; i &lt; 4096=
; i++)); do ./vtpmctrl &amp;
done<br>&gt; <br>&gt; Yeah, that looks good, thanks for doing this<br>&gt; =
</font></tt><br><br><tt><font size=3D2>With the IDR I ran into the problem =
that TPM core
driver and backend now share the ID and create their device names with
it. What can happen is that the core driver gives up ID 123, while the
vTPM driver still has the device name vtpms123 registered with sysfs. Now
the next device is created, ID 123 is recycled by the core driver, and
it bombs while the vTPM driver again tries to register vtpm123 that still
hasn't been unregistered. One can trigger this problem with lots of concurr=
ency
(see below) and then the whole system even locks up. I don't know how to
solve this ID issue in an easier way than having an IDR in the core driver
and an IDA in the vTPM driver and so handling the IDs independently. This
in turn makes the split of tpmm=5Fchip=5Falloc / tpm=5Fchip=5Falloc unneces=
sary
since we don't need the ID from the chip anymore. Now the below test runs
stable.</font></tt><br><br><br><font size=3D4 face=3D"Lucida Console">for p=
id in $(ps aux | grep vtpm
| gawk '{print $2}'); do kill -9 $pid; done ; for ((i =3D0; i&lt; 8192; i++=
));
do ./vtpmctrl &amp;&gt;/dev/null &amp; done</font><br><br><tt><font size=3D=
2>&nbsp;Stefan</font></tt><br><BR>
--=_alternative 0024647585257F59_=--



--===============1877858074929885965==
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
--===============1877858074929885965==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1877858074929885965==--
