From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 16:58:51 -0500
Message-ID: <201601272158.u0RLwtmR025106@d03av03.boulder.ibm.com>
References: <201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<20160127031320.GC23863@intel.com>
	<201601271242.u0RCgM0E031875@d03av05.boulder.ibm.com>
	<20160127175839.GA31038@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0237207970446107888=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160127175839.GA31038-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mimi, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============0237207970446107888==
Content-Type: multipart/alternative;
	boundary="=_alternative 0078BF8585257F47_="


--=_alternative 0078BF8585257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/27/2016=20
12:58:39 PM:

>=20
> On Wed, Jan 27, 2016 at 07:42:17AM -0500, Stefan Berger wrote:
> >    What we don't want from the IMA perspective is that someone creates =

an
> >    IMA namespace on the host similar to how one can create a network
> >    namespace (ip netns add ...), runs (malicious) programs under a
> >    different IMA policy, and then closes that IMA namespace.
>=20
> Presumably who ever is implementing IMA namespaces has some kind of
> solution for this though?
>=20
> That seems like a very difficult problem.
>=20
> >    hand, what we want are containers having their own IMA namespace=20
with
> >    an independent policy. Since the argument is that containers are=20
well
> >    isolated from the host and programs running there don't influence=20
the
> >    host, their logs would be independent. The thing is that containers =

are
> >    made up of multiple namespaces. So, we likely won't give direct=20
control
> >    over IMA namespace creation through tools like network namespacing=20
does
> >    or even a dedicate clone flag but connect it to one or multiple
> >    existing clone flags that cause creation of a (mount, pid, etc.)
> >    namespace. So that could mean that if someone creates a mount + pid
> >    namespace, and thus is well isolated, he automatically gets an IMA
> >    namespace.
>=20
> That isn't nearly good enough, mount namespaces don't mean you are
> isolated. It isn't until another tool like docker goes through and
> alters the child's mount table that some degree of isolation is
> achieved..
>=20
> I don't think there is a generic kernel side point where it could tell
> the child is isolated enough. Whatever that means.

I agree. Which set of namespaces is enough for running any program in this =

set of namespaces (aka container) and being able to forget about the list=20
of measurements once the set of namespaces goes away because whatever ran=20
there couldn't have influenced the host. I would say mount, network, and=20
user namespace is such a set. Probably also include PID namespace in that=20
space assuming that in a shared PID namespace one process could signal=20
other processes. Though this may be mitigated with user namespace mapping=20
etc.. Not clear about UTS namespace, but may not be so important.

To be on the safe side, maybe all would be required and one gets an IMA=20
namespace only then.

>=20
> Doesn't selinux have the exact same problem? How does selinux handle
> namespaces?

They solve it by mounting with a context option, which enforces an sVirt=20
SELinux label across all files that the container user then cannot change.

tmpfs /dev tmpfs rw,context=3D
"system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c860",nosuid,mode=
=3D755 0 0
devpts /dev/pts devpts rw,context=3D
"system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c860
",nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmode=3D666 0 0
shm /dev/shm tmpfs=20
rw,context=3D"system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c860=
",nosuid,nodev,noexec,relatime,size=3D65536k=20
0 0
tmpfs /sys/fs/cgroup tmpfs=20
rw,context=3D"system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c860=
",nosuid,nodev,noexec,relatime=20
0 0
tmpfs /run/secrets tmpfs=20
rw,context=3D"system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c860=
",nosuid,nodev,noexec,relatime=20
0 0
tmpfs /proc/kcore tmpfs=20
rw,context=3D"system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c860=
",nosuid,mode=3D755=20
0 0
tmpfs /proc/latency=5Fstats tmpfs=20
rw,context=3D"system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c860=
",nosuid,mode=3D755=20
0 0
tmpfs /proc/timer=5Fstats tmpfs=20
rw,context=3D"system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c860=
",nosuid,mode=3D755=20
0 0


>=20
> >    IMA namespacing would then provide less control for users compared=20
to
> >    network namespacing and therefore an ioctl, issued from the=20
clone()ing
> >    process, for IMA+vTPM driver hook-up would be sufficient.
>=20
> I agree IMA namespaces probably don't need the whole 'ip setns' type
> interface, but realistically if an ioctl is provided to install a TPM
> in a child namespace it should let anyone with privilege in the parent
> namespaces install a TPM in a child IMA namespace, that is just how
> the namespace APIs seem to work.

Agree.

>=20
> That said, maybe looking at selinux namespaces interaction will give a
> different idea..

See above. We cannot use the same trick.

   Stefan

>=20
> Jason
>=20



--=_alternative 0078BF8585257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/27/2016 12:58:39 PM:<br><br>&gt; <br>&gt; On Wed, Jan 27, 2016 =
at 07:42:17AM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;What we=
 don't want from the IMA perspective is that
someone creates an<br>&gt; &gt; &nbsp; &nbsp;IMA namespace on the host simi=
lar to how one can
create a network<br>&gt; &gt; &nbsp; &nbsp;namespace (ip netns add ...), ru=
ns (malicious) programs
under a<br>&gt; &gt; &nbsp; &nbsp;different IMA policy, and then closes tha=
t IMA namespace.<br>&gt; <br>&gt; Presumably who ever is implementing IMA n=
amespaces has some kind of<br>&gt; solution for this though?<br>&gt; <br>&g=
t; That seems like a very difficult problem.<br>&gt; <br>&gt; &gt; &nbsp; &=
nbsp;hand, what we want are containers having their own
IMA namespace with<br>&gt; &gt; &nbsp; &nbsp;an independent policy. Since t=
he argument is that
containers are well<br>&gt; &gt; &nbsp; &nbsp;isolated from the host and pr=
ograms running there
don't influence the<br>&gt; &gt; &nbsp; &nbsp;host, their logs would be ind=
ependent. The thing
is that containers are<br>&gt; &gt; &nbsp; &nbsp;made up of multiple namesp=
aces. So, we likely won't
give direct control<br>&gt; &gt; &nbsp; &nbsp;over IMA namespace creation t=
hrough tools like network
namespacing does<br>&gt; &gt; &nbsp; &nbsp;or even a dedicate clone flag bu=
t connect it to
one or multiple<br>&gt; &gt; &nbsp; &nbsp;existing clone flags that cause c=
reation of a (mount,
pid, etc.)<br>&gt; &gt; &nbsp; &nbsp;namespace. So that could mean that if =
someone creates
a mount + pid<br>&gt; &gt; &nbsp; &nbsp;namespace, and thus is well isolate=
d, he automatically
gets an IMA<br>&gt; &gt; &nbsp; &nbsp;namespace.<br>&gt; <br>&gt; That isn'=
t nearly good enough, mount namespaces don't mean you are<br>&gt; isolated.=
 It isn't until another tool like docker goes through and<br>&gt; alters th=
e child's mount table that some degree of isolation is<br>&gt; achieved..<b=
r>&gt; <br>&gt; I don't think there is a generic kernel side point where it=
 could
tell<br>&gt; the child is isolated enough. Whatever that means.</font></tt>=
<br><br><tt><font size=3D2>I agree. Which set of namespaces is enough for r=
unning
any program in this set of namespaces (aka container) and being able to
forget about the list of measurements once the set of namespaces goes away
because whatever ran there couldn't have influenced the host. I would say
mount, network, and user namespace is such a set. Probably also include
PID namespace in that space assuming that in a shared PID namespace one
process could signal other processes. Though this may be mitigated with
user namespace mapping etc.. Not clear about UTS namespace, but may not
be so important.</font></tt><br><br><tt><font size=3D2>To be on the safe si=
de, maybe all would be required
and one gets an IMA namespace only then.</font></tt><br><tt><font size=3D2>=
<br>&gt; <br>&gt; Doesn't selinux have the exact same problem? How does sel=
inux handle<br>&gt; namespaces?</font></tt><br><br><tt><font size=3D2>They =
solve it by mounting with a context option, which
enforces an sVirt SELinux label across all files that the container user
then cannot change.</font></tt><br><br><font size=3D2 face=3D"sans-serif">t=
mpfs /dev tmpfs rw,context=3D<b>&quot;system=5Fu:object=5Fr:svirt=5Fsandbox=
=5Ffile=5Ft:s0:c322,c860</b>&quot;,nosuid,mode=3D755
0 0</font><br><font size=3D2 face=3D"sans-serif">devpts /dev/pts devpts rw,=
context=3D<b>&quot;system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322=
,c860</b>&quot;,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmode=3D666
0 0</font><br><font size=3D2 face=3D"sans-serif">shm /dev/shm tmpfs rw,cont=
ext=3D&quot;system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c860&q=
uot;,nosuid,nodev,noexec,relatime,size=3D65536k
0 0</font><br><font size=3D2 face=3D"sans-serif">tmpfs /sys/fs/cgroup tmpfs=
 rw,context=3D&quot;system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c32=
2,c860&quot;,nosuid,nodev,noexec,relatime
0 0</font><br><font size=3D2 face=3D"sans-serif">tmpfs /run/secrets tmpfs r=
w,context=3D&quot;system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,=
c860&quot;,nosuid,nodev,noexec,relatime
0 0</font><br><font size=3D2 face=3D"sans-serif">tmpfs /proc/kcore tmpfs rw=
,context=3D&quot;system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s0:c322,c=
860&quot;,nosuid,mode=3D755
0 0</font><br><font size=3D2 face=3D"sans-serif">tmpfs /proc/latency=5Fstat=
s tmpfs rw,context=3D&quot;system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft=
:s0:c322,c860&quot;,nosuid,mode=3D755
0 0</font><br><font size=3D2 face=3D"sans-serif">tmpfs /proc/timer=5Fstats =
tmpfs rw,context=3D&quot;system=5Fu:object=5Fr:svirt=5Fsandbox=5Ffile=5Ft:s=
0:c322,c860&quot;,nosuid,mode=3D755
0 0</font><br><br><br><tt><font size=3D2>&gt; <br>&gt; &gt; &nbsp; &nbsp;IM=
A namespacing would then provide less control
for users compared to<br>&gt; &gt; &nbsp; &nbsp;network namespacing and the=
refore an ioctl, issued
from the clone()ing<br>&gt; &gt; &nbsp; &nbsp;process, for IMA+vTPM driver =
hook-up would be sufficient.<br>&gt; <br>&gt; I agree IMA namespaces probab=
ly don't need the whole 'ip setns' type<br>&gt; interface, but realisticall=
y if an ioctl is provided to install a
TPM<br>&gt; in a child namespace it should let anyone with privilege in the=
 parent<br>&gt; namespaces install a TPM in a child IMA namespace, that is =
just how<br>&gt; the namespace APIs seem to work.</font></tt><br><br><tt><f=
ont size=3D2>Agree.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Tha=
t said, maybe looking at selinux namespaces interaction will give
a<br>&gt; different idea..</font></tt><br><br><tt><font size=3D2>See above.=
 We cannot use the same trick.</font></tt><br><br><tt><font size=3D2>&nbsp;=
 &nbsp;Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Jason<br>=
&gt; <br></font></tt><BR>
--=_alternative 0078BF8585257F47_=--



--===============0237207970446107888==
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
--===============0237207970446107888==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0237207970446107888==--
