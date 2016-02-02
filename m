From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Tue, 2 Feb 2016 14:22:30 -0500
Message-ID: <201602021922.u12JMiO0008886@d01av02.pok.ibm.com>
References: <20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<56A2461C.7030607@linux.vnet.ibm.com>
	<20160125181046.GB28108@obsidianresearch.com>
	<201601260105.u0Q15IWW028777@d03av04.boulder.ibm.com>
	<20160126034632.GB24217@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0381249517225739194=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160126034632.GB24217-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============0381249517225739194==
Content-Type: multipart/alternative;
	boundary="=_alternative 006A72D285257F4D_="


--=_alternative 006A72D285257F4D_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/25/2016=20
10:46:32 PM:

>=20
> On Mon, Jan 25, 2016 at 08:05:14PM -0500, Stefan Berger wrote:
>=20
> > > And confused why there is a miscdev and a alloc=5Fchrdev=5Fregion ?
> >=20
> > miscdev =3D /dev/vtpmx - that should be ok, no ?
>=20
> Yes
>=20
> > So, I just removed alloc=5Fchrdev=5Fregion and with that the assignment=
 of=20
a
> > major+minor to the virtual device. This works fine on device creation=20
but on
> > device destruction something odd happens in sysfs.
>=20
> > With two 'vtpmctrl' test programs running sysfs looks like this:
> >=20
> > # find /sys/devices/virtual/vtpm/
> > /sys/devices/virtual/vtpm/
> > /sys/devices/virtual/vtpm/vtpms0
> > /sys/devices/virtual/vtpm/vtpms0/dev
>=20
> Ugh.


I have to dig out the sysfs topic again because I think sysfs seems to be=20
the only remaining part that could be a problem.

The problem is information leakage between containers via sysfs due to=20
sysfs entries, at least for TPM 1.2. For TPM 1.2 we have a lot of sysfs=20
entries that show the current state of the TPM.

The good news is, there's the bind-mount trick that a container management =

stack can apply to hide everything under /sys/devices/virtual/vtpm. To=20
achieve that it would do 'mount -o bind [...]/nulldir=20
/sys/device/virtual/vtpm' inside a container and container users wouldn't=20
be able to see those sysfs entries anymore. However, the bind mount trick=20
only works if /sys/devices/virtual/vtpm exists and it only exists if a=20
vTPM has been created, but the first started container won't necessarily=20
have a vtpm, so that directory will not exists, but it will appear in that =

container once another container has a vtpm. Is there anything we can do=20
in the driver to help user space ? Another trick would be that the=20
container management stack creates a 'dummy vtpm' device pair every time=20
and keeps it around just so it has that sysfs entry and can do the=20
bind-mounting.

[mkdir under sysfs doesn't work]

   Stefan



--=_alternative 006A72D285257F4D_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/25/2016 10:46:32 PM:<br><br>&gt; <br>&gt; On Mon, Jan 25, 2016 =
at 08:05:14PM -0500, Stefan Berger wrote:<br>&gt; <br>&gt; &gt; &gt; And co=
nfused why there is a miscdev and a alloc=5Fchrdev=5Fregion
?<br>&gt; &gt; <br>&gt; &gt; miscdev =3D /dev/vtpmx - that should be ok, no=
 ?<br>&gt; <br>&gt; Yes<br>&gt; <br>&gt; &gt; So, I just removed alloc=5Fch=
rdev=5Fregion and with that the assignment
of a<br>&gt; &gt; major+minor to the virtual device. This works fine on dev=
ice
creation but on<br>&gt; &gt; device destruction something odd happens in sy=
sfs.<br>&gt; <br>&gt; &gt; With two 'vtpmctrl' test programs running sysfs =
looks like this:<br>&gt; &gt; <br>&gt; &gt; # find /sys/devices/virtual/vtp=
m/<br>&gt; &gt; /sys/devices/virtual/vtpm/<br>&gt; &gt; /sys/devices/virtua=
l/vtpm/vtpms0<br>&gt; &gt; /sys/devices/virtual/vtpm/vtpms0/dev<br>&gt; <br=
>&gt; Ugh.</font></tt><br><br><br><tt><font size=3D2>I have to dig out the =
sysfs topic again because I
think sysfs seems to be the only remaining part that could be a problem.</f=
ont></tt><br><br><tt><font size=3D2>The problem is information leakage betw=
een containers
via sysfs due to sysfs entries, at least for TPM 1.2. For TPM 1.2 we have
a lot of sysfs entries that show the current state of the TPM.</font></tt><=
br><br><tt><font size=3D2>The good news is, there's the bind-mount trick th=
at
a container management stack can apply to hide everything under /sys/device=
s/virtual/vtpm.
To achieve that it would do 'mount -o bind [...]/nulldir /sys/device/virtua=
l/vtpm'
inside a container and container users wouldn't be able to see those sysfs
entries anymore. However, the bind mount trick only works if /sys/devices/v=
irtual/vtpm
exists and it only exists if a vTPM has been created, but the first started
container won't necessarily have a vtpm, so that directory will not exists,
but it will appear in that container once another container has a vtpm.
Is there anything we can do in the driver to help user space ? Another
trick would be that the container management stack creates a 'dummy vtpm'
device pair every time and keeps it around just so it has that sysfs entry
and can do the bind-mounting.</font></tt><br><br><tt><font size=3D2>[mkdir =
under sysfs doesn't work]</font></tt><br><br><tt><font size=3D2>&nbsp; &nbs=
p;Stefan</font></tt><br><BR>
--=_alternative 006A72D285257F4D_=--



--===============0381249517225739194==
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
--===============0381249517225739194==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0381249517225739194==--
