From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 20 Jan 2016 22:01:38 -0500
Message-ID: <201601210301.u0L31hLD018933@d03av02.boulder.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0092176185974842004=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160121011701.GA20361-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============0092176185974842004==
Content-Type: multipart/alternative;
	boundary="=_alternative 0010A29685257F41_="


--=_alternative 0010A29685257F41_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/20/2016=20
08:17:01 PM:

>=20
> On Wed, Jan 20, 2016 at 09:39:09AM -0500, Stefan Berger wrote:
> >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
01/19/2016
> >    06:51:07 PM:
> >    >
> >    > On Thu, Jan 14, 2016 at 11:01:57AM -0500, Stefan Berger wrote:
> >    > > +   pdev =3D platform=5Fdevice=5Fregister=5Fsimple("tpm=5Fvtpm",=
=20
> vtpm=5Fdev->dev=5Fnum,
> >    > > +                      NULL, 0);
> >    >
> >    > This seems strange, something like this should not be creating
> >    > platform=5Fdevices.
> >    Should it be a misc=5Fdevice then ?
>=20
> No. Check what other virtual devices are doing..

register=5Fchrdev maybe?

>=20
> Generally speaking, the tpm core should not insist on a parent device
> the way it does. That is an artifact of the clean up I did of the
> drivers that was never fully compelted. To make the driver migration
> easier the TPM core is using devm in places it probably shouldn't, but
> unwinding that requires more difficult all-driver changes.
>=20
> If you get stuck here you will have to fix the core code.
>=20
> >    > > +   vtpm=5Fdev->chip =3D tpmm=5Fchip=5Falloc=5Fpattern(vtpm=5Fde=
v->pdev,
> >    > > +            &vtpm=5Ftpm=5Fops,
> >    > > +            VTPM=5FDEV=5FPREFIX=5FCLIENT"%d");
> >    >
> >    > I agree with Jarkko I don't see why these deserve special names..
> >    I did that because it becomes confusing when there are many=20
/dev/tpm%d
> >    type of devices. This way we can distinguish between a hardware
> >    /dev/tpm%d and all these types of devices.
>=20
> That isn't really consistent with how linux kernel naming works these
> days. Use a udev rule in userspace if you really want this.

Ok, then I will just try to call them /dev/tpm%d.

>=20
> >    > Presumably some namespace magic can be used to make them show up=20
as
> >    > tpm0 in a container?
> >    The magic is to have the container management stack create the=20
device
> >    pair. From the ioctl it learns the name of the devices that were
> >    created and it then finds out about the major/minor number of the
> >    created device and have /dev/tpm0 with that major/minor created in=20
the
> >    container's /dev directory.
>=20
> Except that isn't good enough - the IMA kernel side doesn't know that=20
this
> tpm is now acting as the 'main' 'default' TPM.

Hooking the vTPM to IMA requires another patch that I haven't shown since=20
IMA namespacing isn't public yet. Basically we implement another ioctl()=20
that is to be called before the clone() in order to 'reserve' a vtpm=20
device pair for the calling process. During the clone() call IMA=20
namespacing code can query the vTPM driver for a 'reserved' device pair.=20
Hooking IMA up after the clone() may also work but in case of=20
docker/golang it's better to do this before since the language libraries=20
do a lot after the clone automatically.

>=20
> >    The issue with sysfs is that sysfs is showing directory entries for =

all
> >    vTPMs in all containers.
>=20
> That is not a problem to solve here. The sysfs will also show entires
> for hardware tpms too. You need somekind of namespace related solution
> that works for all tpms.
>=20
> I don't know what became of it, but there used to be 'device
> namespaces' patch series that delt with this kind of problem.

Would be good to have now since I for me the best way is to work around=20
the problem entirely -- not registering with sysfs.

>=20
> Again, I suspect strongly this will need some kind of TPM/IMA
> namespace to actually do what you want.

So here things aren't so clear to me, either. Sysfs should really only=20
show the devices that are relevant to a container, but it seems to show a=20
lot more than that, serial bus for example, i8042 etc. , that don't=20
necessarily have relevance inside the container. So if there's a hardware=20
TPM on the system, it probably shouldn't show the sysfs entries in the=20
container. If we add a vTPM for the container, it would ideally show up as =

tpm0 inside the container's sysfs entries, but it doesn't do that unless=20
this is the first device created and there's no hardware TPM. So while all =

of this isn't possible with sysfs, I made the choice to hide the device=20
from sysfs entirely. If hw tpm0 shows, fine, we can report BIOS=20
measurements then. It seems like device subsystem namespacing would be=20
needed to realize part of this so that multiple tpm0s could exist, one in=20
each device namespace.


>=20
> >    If we don't want users to see the PCRs of other containers we set
> >    this flag. The side effect of setting this flag is that the
> >    container will not be able to see its own TPM device, either, but
> >    presumably the user has commands to reads PCRs etc.
>=20
> Erm, sysfs is just an obvious symptom, the container could also just
> create the dev node and access any tpm it likes, or use some future
> (?) IMA API with a tpm device number.

No, the device cgroup prevents that. Only the major/minor number of its=20
dedicated TPM (client) chardev can be accessed.



>=20
> >    VTPM=5FFLAG=5FNO=5FLOG: Container's boot/start without firmware that
> >    would write an ACPI log. So in most cases one will choose the
> >    VTPM=5FFLAG=5FNO=5FLOG flag since there is no log. Maybe that's a fl=
ag
> >    the user shouldn't have control over.
>=20
> ? But there is no ACPI handle so this should already be naturally
> defeated by the core code. Why a flag?
>=20
> >    > Another way to handle this is to return the FD for the server=20
side of
> >    > the new TPM here and then route accesses from the /dev/tpmX side=20
to
> >    > that FD. Avoid the extra char device. There is some kernel
> >    > infrasturcture that helpd do this (anon fd or something, IIRC)
>=20
> >    Hm, I would prefer to keep the server-side char device since that=20
way
> >    one isn't tied to fd passing or so and the TPM could terminate and=20
be
> >    restarted later on on top of that server side device while keeping=20
the
> >    client side device usable beyond the server side shutting down.
>=20
> Don't be afraid of FD passing.
>=20
> vTPM daemon restart isn't really feasible anyhow as TPMs are
> stateful. The kernel is not prepared to survive a HW TPM reboot.  If
> that problem were to be solved somehow then a scheme like systemd's
> FDSTORE=3D1 to keep the fd alive during a daemon crash could be used.
>=20
> The huge downside to using a master side dev node is that these things
> will leak. Killing the vtpm daemon will not clean up the slave
> interface and another command and sysadmin interaction will be needed
> to sort out the inevitable mess.

This is a scenario that works, though.

The server side opened /dev/vtpms1. It closed it and the clients side=20
disappeared. Both devices /dev/vtpms1 and /dev/vtpmc1 were removed. The=20
client side then shows the following:

# ls -l /proc/self/fd
total 0
lrwx------. 1 root root 64 Jan 20 21:34 0 -> /dev/pts/1
lrwx------. 1 root root 64 Jan 20 21:34 1 -> /dev/pts/1
lrwx------. 1 root root 64 Jan 20 21:34 100 -> /dev/vtpmc1 (deleted)
lrwx------. 1 root root 64 Jan 20 21:34 2 -> /dev/pts/1
lr-x------. 1 root root 64 Jan 20 21:34 3 -> /proc/23266/fd

# echo -en '\x00\xc1\x00\x00\x00\x0a\x00\x00\x00\x00' >&100
-bash: echo: write error: Input/output error


Once the client did a 'exec 100>&-', so closed the fd, the /dev/vtpmc0=20
could actually reappear.

There's a 'keepalive' flag in this vtpm driver that keeps the device pair=20
around even if the server side shuts down. If that had been set,=20
/dev/vtpmc1 wouldn't have been deleted upon server side closure.

  Stefan

>=20
> >    > Then del becomes close() on the special fd
> >    And with that the client side device would *have* to close as well
> >    because the backend now is inaccessible?
>=20
> The client side would see failures on all TPM commands it tries to
>=20
> Jason
>=20



--=_alternative 0010A29685257F41_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/20/2016 08:17:01 PM:<br><br>&gt; <br>&gt; On Wed, Jan 20, 2016 =
at 09:39:09AM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;Jason G=
unthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/19/2016<br>&gt; &gt; &nbsp; &nbsp;06:51:07 PM:<br>&gt; &gt; &nb=
sp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; On Thu, Jan 14, 2016 at 11:01=
:57AM -0500, Stefan
Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; + &nbsp; pdev =3D platfor=
m=5Fdevice=5Fregister=5Fsimple(&quot;tpm=5Fvtpm&quot;,
&nbsp;<br>&gt; vtpm=5Fdev-&gt;dev=5Fnum,<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt=
; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;NULL, 0);<br>&gt; &gt; &nbsp; &nbsp;&gt;<=
br>&gt; &gt; &nbsp; &nbsp;&gt; This seems strange, something like this shou=
ld
not be creating<br>&gt; &gt; &nbsp; &nbsp;&gt; platform=5Fdevices.<br>&gt; =
&gt; &nbsp; &nbsp;Should it be a misc=5Fdevice then ?<br>&gt; <br>&gt; No. =
Check what other virtual devices are doing..</font></tt><br><br><tt><font s=
ize=3D2>register=5Fchrdev maybe?</font></tt><br><tt><font size=3D2><br>&gt;=
 <br>&gt; Generally speaking, the tpm core should not insist on a parent de=
vice<br>&gt; the way it does. That is an artifact of the clean up I did of =
the<br>&gt; drivers that was never fully compelted. To make the driver migr=
ation<br>&gt; easier the TPM core is using devm in places it probably shoul=
dn't,
but<br>&gt; unwinding that requires more difficult all-driver changes.<br>&=
gt; <br>&gt; If you get stuck here you will have to fix the core code.<br>&=
gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; + &nbsp; vtpm=5Fdev-&gt;chip =3D t=
pmm=5Fchip=5Falloc=5Fpattern(vtpm=5Fdev-&gt;pdev,<br>&gt; &gt; &nbsp; &nbsp=
;&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&amp;vtpm=5Ftpm=5Fops=
,<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;VTPM=5FDEV=5FPREFIX=5FCLIENT&quot;%d&quot;);<br>&gt; &gt; &nbsp; &nbs=
p;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; I agree with Jarkko I don't see why t=
hese deserve
special names..<br>&gt; &gt; &nbsp; &nbsp;I did that because it becomes con=
fusing when there
are many /dev/tpm%d<br>&gt; &gt; &nbsp; &nbsp;type of devices. This way we =
can distinguish between
a hardware<br>&gt; &gt; &nbsp; &nbsp;/dev/tpm%d and all these types of devi=
ces.<br>&gt; <br>&gt; That isn't really consistent with how linux kernel na=
ming works these<br>&gt; days. Use a udev rule in userspace if you really w=
ant this.</font></tt><br><br><tt><font size=3D2>Ok, then I will just try to=
 call them /dev/tpm%d.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; =
&gt; &nbsp; &nbsp;&gt; Presumably some namespace magic can be used
to make them show up as<br>&gt; &gt; &nbsp; &nbsp;&gt; tpm0 in a container?=
<br>&gt; &gt; &nbsp; &nbsp;The magic is to have the container management st=
ack
create the device<br>&gt; &gt; &nbsp; &nbsp;pair. From the ioctl it learns =
the name of the devices
that were<br>&gt; &gt; &nbsp; &nbsp;created and it then finds out about the=
 major/minor
number of the<br>&gt; &gt; &nbsp; &nbsp;created device and have /dev/tpm0 w=
ith that major/minor
created in the<br>&gt; &gt; &nbsp; &nbsp;container's /dev directory.<br>&gt=
; <br>&gt; Except that isn't good enough - the IMA kernel side doesn't know=
 that
this<br>&gt; tpm is now acting as the 'main' 'default' TPM.</font></tt><br>=
<br><tt><font size=3D2>Hooking the vTPM to IMA requires another patch that
I haven't shown since IMA namespacing isn't public yet. Basically we implem=
ent
another ioctl() that is to be called before the clone() in order to 'reserv=
e'
a vtpm device pair for the calling process. During the clone() call IMA
namespacing code can query the vTPM driver for a 'reserved' device pair.
Hooking IMA up after the clone() may also work but in case of docker/golang
it's better to do this before since the language libraries do a lot after
the clone automatically.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt=
; &gt; &nbsp; &nbsp;The issue with sysfs is that sysfs is showing directory
entries for all<br>&gt; &gt; &nbsp; &nbsp;vTPMs in all containers.<br>&gt; =
<br>&gt; That is not a problem to solve here. The sysfs will also show enti=
res<br>&gt; for hardware tpms too. You need somekind of namespace related s=
olution<br>&gt; that works for all tpms.<br>&gt; <br>&gt; I don't know what=
 became of it, but there used to be 'device<br>&gt; namespaces' patch serie=
s that delt with this kind of problem.</font></tt><br><br><tt><font size=3D=
2>Would be good to have now since I for me the best
way is to work around the problem entirely -- not registering with sysfs.</=
font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Again, I suspect strongl=
y this will need some kind of TPM/IMA<br>&gt; namespace to actually do what=
 you want.</font></tt><br><br><tt><font size=3D2>So here things aren't so c=
lear to me, either. Sysfs
should really only show the devices that are relevant to a container, but
it seems to show a lot more than that, serial bus for example, i8042 etc.
, that don't necessarily have relevance inside the container. So if there's
a hardware TPM on the system, it probably shouldn't show the sysfs entries
in the container. If we add a vTPM for the container, it would ideally
show up as tpm0 inside the container's sysfs entries, but it doesn't do
that unless this is the first device created and there's no hardware TPM.
So while all of this isn't possible with sysfs, I made the choice to hide
the device from sysfs entirely. If hw tpm0 shows, fine, we can report BIOS
measurements then. It seems like device subsystem namespacing would be
needed to realize part of this so that multiple tpm0s could exist, one
in each device namespace.</font></tt><br><br><tt><font size=3D2><br>&gt; <b=
r>&gt; &gt; &nbsp; &nbsp;If we don't want users to see the PCRs of other
containers we set<br>&gt; &gt; &nbsp; &nbsp;this flag. The side effect of s=
etting this flag
is that the<br>&gt; &gt; &nbsp; &nbsp;container will not be able to see its=
 own TPM device,
either, but<br>&gt; &gt; &nbsp; &nbsp;presumably the user has commands to r=
eads PCRs etc.<br>&gt; <br>&gt; Erm, sysfs is just an obvious symptom, the =
container could also just<br>&gt; create the dev node and access any tpm it=
 likes, or use some future<br>&gt; (?) IMA API with a tpm device number.</f=
ont></tt><br><br><tt><font size=3D2>No, the device cgroup prevents that. On=
ly the major/minor
number of its dedicated TPM (client) chardev can be accessed.</font></tt><b=
r><br><br><tt><font size=3D2><br>&gt; <br>&gt; &gt; &nbsp; &nbsp;VTPM=5FFLA=
G=5FNO=5FLOG: Container's boot/start without
firmware that<br>&gt; &gt; &nbsp; &nbsp;would write an ACPI log. So in most=
 cases one will
choose the<br>&gt; &gt; &nbsp; &nbsp;VTPM=5FFLAG=5FNO=5FLOG flag since ther=
e is no log. Maybe
that's a flag<br>&gt; &gt; &nbsp; &nbsp;the user shouldn't have control ove=
r.<br>&gt; <br>&gt; ? But there is no ACPI handle so this should already be=
 naturally<br>&gt; defeated by the core code. Why a flag?<br>&gt; <br>&gt; =
&gt; &nbsp; &nbsp;&gt; Another way to handle this is to return the
FD for the server side of<br>&gt; &gt; &nbsp; &nbsp;&gt; the new TPM here a=
nd then route accesses from
the /dev/tpmX side to<br>&gt; &gt; &nbsp; &nbsp;&gt; that FD. Avoid the ext=
ra char device. There
is some kernel<br>&gt; &gt; &nbsp; &nbsp;&gt; infrasturcture that helpd do =
this (anon fd
or something, IIRC)<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;Hm, I would prefer t=
o keep the server-side char
device since that way<br>&gt; &gt; &nbsp; &nbsp;one isn't tied to fd passin=
g or so and the TPM could
terminate and be<br>&gt; &gt; &nbsp; &nbsp;restarted later on on top of tha=
t server side device
while keeping the<br>&gt; &gt; &nbsp; &nbsp;client side device usable beyon=
d the server side
shutting down.<br>&gt; <br>&gt; Don't be afraid of FD passing.<br>&gt; <br>=
&gt; vTPM daemon restart isn't really feasible anyhow as TPMs are<br>&gt; s=
tateful. The kernel is not prepared to survive a HW TPM reboot. &nbsp;If<br=
>&gt; that problem were to be solved somehow then a scheme like systemd's<b=
r>&gt; FDSTORE=3D1 to keep the fd alive during a daemon crash could be used=
.<br>&gt; <br>&gt; The huge downside to using a master side dev node is tha=
t these things<br>&gt; will leak. Killing the vtpm daemon will not clean up=
 the slave<br>&gt; interface and another command and sysadmin interaction w=
ill be needed<br>&gt; to sort out the inevitable mess.</font></tt><br><br><=
tt><font size=3D2>This is a scenario that works, though.</font></tt><br><br=
><tt><font size=3D2>The server side opened /dev/vtpms1. It closed it and
the clients side disappeared. Both devices /dev/vtpms1 and /dev/vtpmc1
were removed. The client side then shows the following:</font></tt><br><br>=
<font size=3D4 face=3D"Lucida Console"># ls -l /proc/self/fd</font><br><fon=
t size=3D4 face=3D"Lucida Console">total 0</font><br><font size=3D4 face=3D=
"Lucida Console">lrwx------. 1 root root 64 Jan 20
21:34 0 -&gt; /dev/pts/1</font><br><font size=3D4 face=3D"Lucida Console">l=
rwx------. 1 root root 64 Jan 20
21:34 1 -&gt; /dev/pts/1</font><br><font size=3D4 face=3D"Lucida Console">l=
rwx------. 1 root root 64 Jan 20
21:34 100 -&gt; /dev/vtpmc1 (deleted)</font><br><font size=3D4 face=3D"Luci=
da Console">lrwx------. 1 root root 64 Jan 20
21:34 2 -&gt; /dev/pts/1</font><br><font size=3D4 face=3D"Lucida Console">l=
r-x------. 1 root root 64 Jan 20
21:34 3 -&gt; /proc/23266/fd</font><br><br><font size=3D4 face=3D"Lucida Co=
nsole"># echo -en '\x00\xc1\x00\x00\x00\x0a\x00\x00\x00\x00'
&gt;&amp;100</font><br><font size=3D4 face=3D"Lucida Console">-bash: echo: =
write error: Input/output
error</font><br><br><br><tt><font size=3D2>Once the client did a 'exec 100&=
gt;&amp;-', so closed
the fd, the /dev/vtpmc0 could actually reappear.</font></tt><br><br><tt><fo=
nt size=3D2>There's a 'keepalive' flag in this vtpm driver that
keeps the device pair around even if the server side shuts down. If that
had been set, /dev/vtpmc1 wouldn't have been deleted upon server side closu=
re.</font></tt><br><br><tt><font size=3D2>&nbsp; Stefan</font></tt><br><tt>=
<font size=3D2><br>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; Then del becomes cl=
ose() on the special fd<br>&gt; &gt; &nbsp; &nbsp;And with that the client =
side device would *have*
to close as well<br>&gt; &gt; &nbsp; &nbsp;because the backend now is inacc=
essible?<br>&gt; <br>&gt; The client side would see failures on all TPM com=
mands it tries to<br>&gt; <br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 0010A29685257F41_=--



--===============0092176185974842004==
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
--===============0092176185974842004==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0092176185974842004==--
