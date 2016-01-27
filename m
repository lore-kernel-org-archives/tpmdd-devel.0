From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 07:42:17 -0500
Message-ID: <201601271242.u0RCgLbc028108@d01av01.pok.ibm.com>
References: <201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<20160127031320.GC23863@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7732305614999205109=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160127031320.GC23863-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============7732305614999205109==
Content-Type: multipart/alternative;
	boundary="=_alternative 0045CB1285257F47_="


--=_alternative 0045CB1285257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/26/2016=20
10:13:20 PM:

>=20
> On Thu, Jan 21, 2016 at 03:10:40PM -0700, Jason Gunthorpe wrote:
> > On Thu, Jan 21, 2016 at 04:51:06PM -0500, Stefan Berger wrote:
> >=20
> > >    > You can't let this influence the kernel UAPI design.
> >=20
> > >    The choice is between getting this working 'today' (even if just
> > >    locally) or discussing this with golang designers, which in the=20
ideal
> > >    case would cause me waiting for the next version, dealing with=20
that
> > >    version dependency etc., plus the delay. So, clearly, an=20
additional
> > >    ioctl() and ~50 lines of code make this work 'now'. Doesn't this=20
seem
> > >    worth it?
> >=20
> > Sorry, for mainline stuff like this reserve thing is not clean enough
> > to be acceptable.
> >=20
> > Why can't you just open-code a modified forkAndExecInChild in docker?
> >=20
> > Seriously, the golang code you showed already has special stuff to do
> > user namespaces before the exec, it is totally unreasonable insist
>=20
> I'm starting to be along the same lines with the Jason now that I've
> actually tried to read through the discussion up to this email. I did
> say something opposite in last week but will take my words back since I
> had too weak understanding back then (you *never* should response to
> dicussions like this when you are overloaded with something else).
>=20
> I haven't yet locked whether the fd or major/minor passing is the right
> choice but at least I do agree that we cannot make decission based on
> some golang code in Docker. For the new mainline code we should pick the
> most robust API, nothing more or less...

So we can design it how it should work from user space. So far it's solved =

with an ioctl.

To pick up on Jason's suggestion to look into network namespaces and=20
associated tools:

What we don't want from the IMA perspective is that someone creates an IMA =

namespace on the host similar to how one can create a network namespace=20
(ip netns add ...), runs (malicious) programs under a different IMA=20
policy, and then closes that IMA namespace. On the other hand, what we=20
want are containers having their own IMA namespace with an independent=20
policy. Since the argument is that containers are well isolated from the=20
host and programs running there don't influence the host, their logs would =

be independent. The thing is that containers are made up of multiple=20
namespaces. So, we likely won't give direct control over IMA namespace=20
creation through tools like network namespacing does or even a dedicate=20
clone flag but connect it to one or multiple existing clone flags that=20
cause creation of a (mount, pid, etc.) namespace. So that could mean that=20
if someone creates a mount + pid namespace, and thus is well isolated, he=20
automatically gets an IMA namespace.

IMA namespacing would then provide less control for users compared to=20
network namespacing and therefore an ioctl, issued from the clone()ing=20
process, for IMA+vTPM driver hook-up would be sufficient.

   Stefan

>=20
> /Jarkko
>=20



--=_alternative 0045CB1285257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 01/26/2016 10:13:20 PM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Thu, Jan 21, 2016 at 03:10:40PM -0700, Jason Gunthorpe wrote:<=
br>&gt; &gt; On Thu, Jan 21, 2016 at 04:51:06PM -0500, Stefan Berger wrote:=
<br>&gt; &gt; <br>&gt; &gt; &gt; &nbsp; &nbsp;&gt; You can't let this influ=
ence the kernel
UAPI design.<br>&gt; &gt; <br>&gt; &gt; &gt; &nbsp; &nbsp;The choice is bet=
ween getting this working
'today' (even if just<br>&gt; &gt; &gt; &nbsp; &nbsp;locally) or discussing=
 this with golang designers,
which in the ideal<br>&gt; &gt; &gt; &nbsp; &nbsp;case would cause me waiti=
ng for the next version,
dealing with that<br>&gt; &gt; &gt; &nbsp; &nbsp;version dependency etc., p=
lus the delay. So,
clearly, an additional<br>&gt; &gt; &gt; &nbsp; &nbsp;ioctl() and ~50 lines=
 of code make this work
'now'. Doesn't this seem<br>&gt; &gt; &gt; &nbsp; &nbsp;worth it?<br>&gt; &=
gt; <br>&gt; &gt; Sorry, for mainline stuff like this reserve thing is not =
clean
enough<br>&gt; &gt; to be acceptable.<br>&gt; &gt; <br>&gt; &gt; Why can't =
you just open-code a modified forkAndExecInChild in
docker?<br>&gt; &gt; <br>&gt; &gt; Seriously, the golang code you showed al=
ready has special stuff
to do<br>&gt; &gt; user namespaces before the exec, it is totally unreasona=
ble insist<br>&gt; <br>&gt; I'm starting to be along the same lines with th=
e Jason now that I've<br>&gt; actually tried to read through the discussion=
 up to this email. I
did<br>&gt; say something opposite in last week but will take my words back=
 since
I<br>&gt; had too weak understanding back then (you *never* should response
to<br>&gt; dicussions like this when you are overloaded with something else=
).<br>&gt; <br>&gt; I haven't yet locked whether the fd or major/minor pass=
ing is the
right<br>&gt; choice but at least I do agree that we cannot make decission =
based
on<br>&gt; some golang code in Docker. For the new mainline code we should =
pick
the<br>&gt; most robust API, nothing more or less...</font></tt><br><br><tt=
><font size=3D2>So we can design it how it should work from user space.
So far it's solved with an ioctl.</font></tt><br><br><tt><font size=3D2>To =
pick up on Jason's suggestion to look into network
namespaces and associated tools:</font></tt><br><br><tt><font size=3D2>What=
 we don't want from the IMA perspective is that
someone creates an IMA namespace on the host similar to how one can create
a network namespace (ip netns add ...), runs (malicious) programs under
a different IMA policy, and then closes that IMA namespace. On the other
hand, what we want are containers having their own IMA namespace with an
independent policy. Since the argument is that containers are well isolated
from the host and programs running there don't influence the host, their
logs would be independent. The thing is that containers are made up of
multiple namespaces. So, we likely won't give direct control over IMA names=
pace
creation through tools like network namespacing does or even a dedicate
clone flag but connect it to one or multiple existing clone flags that
cause creation of a (mount, pid, etc.) namespace. So that could mean that
if someone creates a mount + pid namespace, and thus is well isolated,
he automatically gets an IMA namespace.</font></tt><br><br><tt><font size=
=3D2>IMA namespacing would then provide less control for
users compared to network namespacing and therefore an ioctl, issued from
the clone()ing process, for IMA+vTPM driver hook-up would be sufficient.</f=
ont></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt>=
<font size=3D2><br>&gt; <br>&gt; /Jarkko<br>&gt; <br></font></tt><BR>
--=_alternative 0045CB1285257F47_=--



--===============7732305614999205109==
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
--===============7732305614999205109==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7732305614999205109==--
