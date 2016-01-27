From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 17:55:50 -0500
Message-ID: <201601272255.u0RMtsRL018655@d01av03.pok.ibm.com>
References: <201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<20160127031320.GC23863@intel.com>
	<201601271242.u0RCgM0E031875@d03av05.boulder.ibm.com>
	<20160127175839.GA31038@obsidianresearch.com>
	<201601272158.u0RLwvIK005533@d01av01.pok.ibm.com>
	<20160127222534.GB5520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5515617251182464589=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160127222534.GB5520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============5515617251182464589==
Content-Type: multipart/alternative;
	boundary="=_alternative 007DF71685257F47_="


--=_alternative 007DF71685257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/27/2016=20
05:25:34 PM:


>=20
> On Wed, Jan 27, 2016 at 04:58:51PM -0500, Stefan Berger wrote:
>=20
> >    > I don't think there is a generic kernel side point where it could =

tell
> >    > the child is isolated enough. Whatever that means.
>=20
> >    I agree. Which set of namespaces is enough for running any program=20
in
> >    this set of namespaces (aka container) and being able to forget
> >    about
>=20
> It isn't just the presense of namespaces that matter, eg a net mount
> namespace does not mean access is denied to the parent namespace, net
> namespaces don't mean devices are isolated, etc.
>=20
> This is not a good direction to go, access to an IMA namespace needs to
> be very strongly controlled, 'enough namespaces' is not a sufficient
> criteria!

Isolation should be a criteria and isolation becomes better with more=20
namespaces enabled. That way one can run any program inside the set of=20
namespaces and not harm the host or any other namespaces / containers.=20


>=20
> Any flaw in the access criteria immediately destroys the security of
> IMA in non-container contexts, so this needs to be done very
> carefully.
>=20
> >    > Doesn't selinux have the exact same problem? How does selinux=20
handle
> >    > namespaces?
>=20
> >    They solve it by mounting with a context option, which enforces an
> >    sVirt SELinux label across all files that the container user then
> >    cannot change.
>=20
> This sounds very sane.
>=20
> >    > That said, maybe looking at selinux namespaces interaction will=20
give a
> >    > different idea..
>=20
> >    See above. We cannot use the same trick.
>=20
> Hmm, well, it certainly seems to be a lot of what is required,=20
> and like a much better direction than trying to use namespaces.

I don't agree. We want to allow users to run the own IMA appraisal policy. =

For that files need to be signed and the user's key passed to the IMA=20
namespace. To enable that we need per-file file signatures, not some=20
single label that works across all files in a filesystem. IMA's appraisal=20
mode just doesn't work this way.

>=20
> Arranging for an IMA namespace to only exists in association with a
> SELinux label - and then rely on SELinux to provide the necessary
> security isolation instead of trying to do the same thing with
> namespaces sounds more likely to succeed..

I am not sure whether SELinux labeling alone provides enough isolation.=20
And it's likely not just the label that's important but all the rules that =

go with it to determine what a process can do and what not. How do you=20
even evaluate that from inside the kernel that it's worthy an IMA=20
namespace?=20

   Stefan

>=20
> Jason
>=20



--=_alternative 007DF71685257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/27/2016 05:25:34 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Wed, Jan 27, 2016 at 04:58:51PM -0500, Stefan Berger wrote=
:<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; I don't think there is a generic =
kernel side
point where it could tell<br>&gt; &gt; &nbsp; &nbsp;&gt; the child is isola=
ted enough. Whatever that
means.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;I agree. Which set of namespaces =
is enough for running
any program in<br>&gt; &gt; &nbsp; &nbsp;this set of namespaces (aka contai=
ner) and being
able to forget<br>&gt; &gt; &nbsp; &nbsp;about<br>&gt; <br>&gt; It isn't ju=
st the presense of namespaces that matter, eg a net mount<br>&gt; namespace=
 does not mean access is denied to the parent namespace,
net<br>&gt; namespaces don't mean devices are isolated, etc.<br>&gt; <br>&g=
t; This is not a good direction to go, access to an IMA namespace needs
to<br>&gt; be very strongly controlled, 'enough namespaces' is not a suffic=
ient<br>&gt; criteria!</font></tt><br><br><tt><font size=3D2>Isolation shou=
ld be a criteria and isolation becomes
better with more namespaces enabled. That way one can run any program inside
the set of namespaces and not harm the host or any other namespaces / conta=
iners.
</font></tt><br><br><tt><font size=3D2><br>&gt; <br>&gt; Any flaw in the ac=
cess criteria immediately destroys the security
of<br>&gt; IMA in non-container contexts, so this needs to be done very<br>=
&gt; carefully.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; Doesn't selinux hav=
e the exact same problem?
How does selinux handle<br>&gt; &gt; &nbsp; &nbsp;&gt; namespaces?<br>&gt; =
<br>&gt; &gt; &nbsp; &nbsp;They solve it by mounting with a context option,
which enforces an<br>&gt; &gt; &nbsp; &nbsp;sVirt SELinux label across all =
files that the container
user then<br>&gt; &gt; &nbsp; &nbsp;cannot change.<br>&gt; <br>&gt; This so=
unds very sane.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; That said, maybe lo=
oking at selinux namespaces
interaction will give a<br>&gt; &gt; &nbsp; &nbsp;&gt; different idea..<br>=
&gt; <br>&gt; &gt; &nbsp; &nbsp;See above. We cannot use the same trick.<br=
>&gt; <br>&gt; Hmm, well, it certainly seems to be a lot of what is require=
d, <br>&gt; and like a much better direction than trying to use namespaces.=
</font></tt><br><br><tt><font size=3D2>I don't agree. We want to allow user=
s to run the own
IMA appraisal policy. For that files need to be signed and the user's key
passed to the IMA namespace. To enable that we need per-file file signature=
s,
not some single label that works across all files in a filesystem. IMA's
appraisal mode just doesn't work this way.</font></tt><br><tt><font size=3D=
2><br>&gt; <br>&gt; Arranging for an IMA namespace to only exists in associ=
ation with
a<br>&gt; SELinux label - and then rely on SELinux to provide the necessary=
<br>&gt; security isolation instead of trying to do the same thing with<br>=
&gt; namespaces sounds more likely to succeed..</font></tt><br><br><tt><fon=
t size=3D2>I am not sure whether SELinux labeling alone provides
enough isolation. And it's likely not just the label that's important but
all the rules that go with it to determine what a process can do and what
not. How do you even evaluate that from inside the kernel that it's worthy
an IMA namespace? </font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefa=
n</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Jason<br>&gt; <br></f=
ont></tt><BR>
--=_alternative 007DF71685257F47_=--



--===============5515617251182464589==
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
--===============5515617251182464589==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============5515617251182464589==--
