From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Mon, 25 Jan 2016 20:05:14 -0500
Message-ID: <201601260105.u0Q15I0V028778@d03av04.boulder.ibm.com>
References: <20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<56A2461C.7030607@linux.vnet.ibm.com>
	<20160125181046.GB28108@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3801386771045353894=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160125181046.GB28108-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============3801386771045353894==
Content-Type: multipart/alternative;
	boundary="=_alternative 0005F9CA85257F46_="


--=_alternative 0005F9CA85257F46_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/25/2016=20
01:10:46 PM:

>=20
> On Fri, Jan 22, 2016 at 10:09:16AM -0500, Stefan Berger wrote:

> >=20
> > Thanks for all feedback. I will eventually post v2. For now it's to be =

found
> > here:
> >=20
> > https://github.com/stefanberger/linux
> >=20
> > The branch is easy to find.
>=20
> That looks much nicer, yes.
>=20
> I'd also merge the tpm-vtpm.h into the .c file

Ok, I can do that.

>=20
> However, I'm still not sure this is right:
>=20
> +   vtpm=5Fdev->chip =3D tpmm=5Fchip=5Falloc(&vtpm=5Fdev->dev, &vtpm=5Ftp=
m=5Fops);
>=20
> The only issue is error unwind, the tpmm version assumes devm works
> for that, but the vtpm=5Fdev will not be destroyed if the tpm attach
> fails, do devm is not appropriate.
>=20
> As I said before the tpmm stuff was a hack I did to make it easier to
> migrate the large number of drivers, core code should not be relying
> on devm like that... One good option here would be unwind that a bit
> and create a tpm=5Fchip=5Falloc/tpm=5Fchip=5Fregister flow that did not u=
se
> devm at all. That could be fairly straight forward..
>=20
> Also, what is up with the =5Fvtpm prefix on some functions? That doesn't
> seem aligned with the kernel style..

Renamed them.

>=20
> And confused why there is a miscdev and a alloc=5Fchrdev=5Fregion ?

miscdev =3D /dev/vtpmx - that should be ok, no ?

So, I just removed alloc=5Fchrdev=5Fregion and with that the assignment of =
a=20
major+minor to the virtual device. This works fine on device creation but=20
on device destruction something odd happens in sysfs.

With two 'vtpmctrl' test programs running sysfs looks like this:

# find /sys/devices/virtual/vtpm/
/sys/devices/virtual/vtpm/
/sys/devices/virtual/vtpm/vtpms0
/sys/devices/virtual/vtpm/vtpms0/dev
/sys/devices/virtual/vtpm/vtpms0/durations
...
/sys/devices/virtual/vtpm/vtpms0/tpm0
/sys/devices/virtual/vtpm/vtpms0/tpm0/dev
...
/sys/devices/virtual/vtpm/vtpms1
/sys/devices/virtual/vtpm/vtpms1/dev
/sys/devices/virtual/vtpm/vtpms1/durations
...
/sys/devices/virtual/vtpm/vtpms1/tpm1
/sys/devices/virtual/vtpm/vtpms1/tpm1/dev
...
/sys/devices/virtual/vtpm/vtpms1/tpm1/power
/sys/devices/virtual/vtpm/vtpms1/tpm1/power/control


Now one of the test process 'vtpmctrl' terminates:

/sys/devices/virtual/vtpm/
/sys/devices/virtual/vtpm/vtpms1
/sys/devices/virtual/vtpm/vtpms1/power
/sys/devices/virtual/vtpm/vtpms1/power/control
/sys/devices/virtual/vtpm/vtpms1/power/async
/sys/devices/virtual/vtpm/vtpms1/power/runtime=5Fenabled
/sys/devices/virtual/vtpm/vtpms1/power/runtime=5Factive=5Fkids
/sys/devices/virtual/vtpm/vtpms1/power/runtime=5Factive=5Ftime
/sys/devices/virtual/vtpm/vtpms1/power/autosuspend=5Fdelay=5Fms
/sys/devices/virtual/vtpm/vtpms1/power/runtime=5Fstatus
/sys/devices/virtual/vtpm/vtpms1/power/runtime=5Fusage
/sys/devices/virtual/vtpm/vtpms1/power/runtime=5Fsuspended=5Ftime
/sys/devices/virtual/vtpm/vtpms1/subsystem
/sys/devices/virtual/vtpm/vtpms1/uevent

That's all that is left now. .../vtpms1/tpm1/ has also already=20
disappeared. Needless to say, the kernel is very unhappy once the other=20
vtpmctrl terminates.

The virtual device needs a major/minor as well. Are there any other=20
possible solutions?

   Stefan


--=_alternative 0005F9CA85257F46_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/25/2016 01:10:46 PM:<br><br>&gt; <br>&gt; On Fri, Jan 22, 2016 =
at 10:09:16AM -0500, Stefan Berger wrote:</font></tt><br><tt><font size=3D2=
><br>&gt; &gt; <br>&gt; &gt; Thanks for all feedback. I will eventually pos=
t v2. For now it's
to be found<br>&gt; &gt; here:<br>&gt; &gt; <br>&gt; &gt; </font></tt><a hr=
ef=3Dhttps://github.com/stefanberger/linux><tt><font size=3D2>https://githu=
b.com/stefanberger/linux</font></tt></a><tt><font size=3D2><br>&gt; &gt; <b=
r>&gt; &gt; The branch is easy to find.<br>&gt; <br>&gt; That looks much ni=
cer, yes.<br>&gt; <br>&gt; I'd also merge the tpm-vtpm.h into the .c file</=
font></tt><br><br><tt><font size=3D2>Ok, I can do that.</font></tt><br><tt>=
<font size=3D2><br>&gt; <br>&gt; However, I'm still not sure this is right:=
<br>&gt; <br>&gt; + &nbsp; vtpm=5Fdev-&gt;chip =3D tpmm=5Fchip=5Falloc(&amp=
;vtpm=5Fdev-&gt;dev,
&amp;vtpm=5Ftpm=5Fops);<br>&gt; <br>&gt; The only issue is error unwind, th=
e tpmm version assumes devm works<br>&gt; for that, but the vtpm=5Fdev will=
 not be destroyed if the tpm attach<br>&gt; fails, do devm is not appropria=
te.<br>&gt; <br>&gt; As I said before the tpmm stuff was a hack I did to ma=
ke it easier
to<br>&gt; migrate the large number of drivers, core code should not be rel=
ying<br>&gt; on devm like that... One good option here would be unwind that=
 a bit<br>&gt; and create a tpm=5Fchip=5Falloc/tpm=5Fchip=5Fregister flow t=
hat did not use<br>&gt; devm at all. That could be fairly straight forward.=
.<br>&gt; <br>&gt; Also, what is up with the =5Fvtpm prefix on some functio=
ns? That doesn't<br>&gt; seem aligned with the kernel style..</font></tt><b=
r><br><tt><font size=3D2>Renamed them.</font></tt><br><tt><font size=3D2><b=
r>&gt; <br>&gt; And confused why there is a miscdev and a alloc=5Fchrdev=5F=
region ?</font></tt><br><br><tt><font size=3D2>miscdev =3D /dev/vtpmx - tha=
t should be ok, no ?</font></tt><br><br><tt><font size=3D2>So, I just remov=
ed alloc=5Fchrdev=5Fregion and with that
the assignment of a major+minor to the virtual device. This works fine
on device creation but on device destruction something odd happens in sysfs=
.</font></tt><br><br><tt><font size=3D2>With two 'vtpmctrl' test programs r=
unning sysfs looks
like this:</font></tt><br><br><tt><font size=3D2># find /sys/devices/virtua=
l/vtpm/</font></tt><br><tt><font size=3D2>/sys/devices/virtual/vtpm/</font>=
</tt><br><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms0</font></tt><br=
><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms0/dev</font></tt><br><tt=
><font size=3D2>/sys/devices/virtual/vtpm/vtpms0/durations</font></tt><br><=
tt><font size=3D2>...</font></tt><br><tt><font size=3D2>/sys/devices/virtua=
l/vtpm/vtpms0/tpm0</font></tt><br><tt><font size=3D2>/sys/devices/virtual/v=
tpm/vtpms0/tpm0/dev</font></tt><br><tt><font size=3D2>...</font></tt><br><t=
t><font size=3D2>/sys/devices/virtual/vtpm/vtpms1</font></tt><br><tt><font =
size=3D2>/sys/devices/virtual/vtpm/vtpms1/dev</font></tt><br><tt><font size=
=3D2>/sys/devices/virtual/vtpm/vtpms1/durations</font></tt><br><tt><font si=
ze=3D2>...</font></tt><br><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpm=
s1/tpm1</font></tt><br><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms1/=
tpm1/dev</font></tt><br><tt><font size=3D2>...</font></tt><br><tt><font siz=
e=3D2>/sys/devices/virtual/vtpm/vtpms1/tpm1/power</font></tt><br><tt><font =
size=3D2>/sys/devices/virtual/vtpm/vtpms1/tpm1/power/control</font></tt><br=
><br><br><tt><font size=3D2>Now one of the test process 'vtpmctrl' terminat=
es:</font></tt><br><br><tt><font size=3D2>/sys/devices/virtual/vtpm/</font>=
</tt><br><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms1</font></tt><br=
><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms1/power</font></tt><br><=
tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms1/power/control</font></tt=
><br><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms1/power/async</font>=
</tt><br><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms1/power/runtime=
=5Fenabled</font></tt><br><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpm=
s1/power/runtime=5Factive=5Fkids</font></tt><br><tt><font size=3D2>/sys/dev=
ices/virtual/vtpm/vtpms1/power/runtime=5Factive=5Ftime</font></tt><br><tt><=
font size=3D2>/sys/devices/virtual/vtpm/vtpms1/power/autosuspend=5Fdelay=5F=
ms</font></tt><br><tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms1/power=
/runtime=5Fstatus</font></tt><br><tt><font size=3D2>/sys/devices/virtual/vt=
pm/vtpms1/power/runtime=5Fusage</font></tt><br><tt><font size=3D2>/sys/devi=
ces/virtual/vtpm/vtpms1/power/runtime=5Fsuspended=5Ftime</font></tt><br><tt=
><font size=3D2>/sys/devices/virtual/vtpm/vtpms1/subsystem</font></tt><br><=
tt><font size=3D2>/sys/devices/virtual/vtpm/vtpms1/uevent</font></tt><br><b=
r><tt><font size=3D2>That's all that is left now. .../vtpms1/tpm1/ has
also already disappeared. Needless to say, the kernel is very unhappy once
the other vtpmctrl terminates.</font></tt><br><br><tt><font size=3D2>The vi=
rtual device needs a major/minor as well. Are
there any other possible solutions?</font></tt><br><br><tt><font size=3D2>&=
nbsp; &nbsp;Stefan</font></tt><BR>
--=_alternative 0005F9CA85257F46_=--



--===============3801386771045353894==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
--===============3801386771045353894==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3801386771045353894==--
