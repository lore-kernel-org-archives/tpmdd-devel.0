From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 09/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Thu, 25 Feb 2016 09:12:57 -0500
Message-ID: <201602251413.u1PED0hm008329@d03av01.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-10-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222192741.GI22088@obsidianresearch.com>
	<201602230142.u1N1gSuF029481@d01av05.pok.ibm.com>
	<20160223021730.GD26177@obsidianresearch.com>
	<201602242306.u1ON6qGP030251@d01av05.pok.ibm.com>
	<20160225131732.GA20860@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2659657532261434924=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160225131732.GA20860-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============2659657532261434924==
Content-Type: multipart/alternative;
	boundary="=_alternative 004E186485257F64_="


--=_alternative 004E186485257F64_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/25/2016=20
08:17:32 AM:

>=20
> On Wed, Feb 24, 2016 at 06:10:42PM -0500, Stefan Berger wrote:
> >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
02/22/2016
> >    09:17:30 PM:
> >=20
> >    >
> >    > On Mon, Feb 22, 2016 at 08:45:51PM -0500, Stefan Berger wrote:
> >    >
> >    > > Two things:
> >    > > - the ioctl takes flags; should we return an error on flags=20
that are
> >    not
> >    > > supported but set by userspace?
> >    >
> >    > Typically yes. Otherwise you cannot introduce new flags in
> >    > future.
> >    >
> >    > > - the sysfs works but I wished we could give some control over
> >    > whether it shows
> >    > > any entries. Can we have a flag in the ioctl on whether to show
> >    > these files in
> >    > > sysfs?
> >    >
> >    > That is something to address in the future namespace patch series =

I
> >    > expect you'll prepare..
> >=20
> >    It may be a while until we get there ... nevertheless it may=20
beworth some
> >    thought already.
> >=20
> >    So we have at least two choices for how to avoid data leakage via=20
sysfs;
> >    the problem is that sysfs shows all vtpm devices in all containers; =

the
> >    good thing is that at least Docker (other mgmt. stacks probably=20
also)
> >    mount sysfs read-only into 'normal' containers, so that=20
writing(even only
> >    to cancel) isn't typically possible.
> >=20
> >    1) allow user space to set a flag whether the sysfs entries are to=20
be
> >    registered; a typical container mgmt. stack would set the flag to=20
avoid
> >    data leakage between containers; no vtpm device with that flag set=20
would
> >    show anything via sysfs
> >=20
> >    2) we know in which (user) namespace a /dev/tpm%d device is moved=20
into
> >    following an ioctl on the device where a process's PID is a=20
parameter; we
> >    could associate the process's (user) namespace with the chip and=20
compare
> >    the current=5Fuser=5Fns() with chip->user=5Fns and return an empty s=
tring=20
if
> >    they don't match; here the vtpm device owned by a particular (user)
> >    namespace would then also show data in sysfs entries if accessed=20
from the
> >    right namespace; which sysfs entry to look at could be inferred=20
from the
> >    minor number on /dev/tpm0 inside the container

With clone() not necessarily setting the user namespace and setns() being=20
able to do that after some fork()s, I think 2) doesn't work so well.

>=20
> 3) Do not show any existing sysfs attributes for containers. All but

A separate sysfs tree isn't built for every container, so sysfs is more or =

less global showing pretty much the same in every container except for=20
networking namespace seems to have a way of not doing that.

>    'ppi' are nonsense anyway or is there something that you couldn't=20
read
>    from /dev/tpm0? TPM 1.x user space tools could implement them by
>    using the character device. It is not backwards compatibility break
>    technically because existing code does not yet support vTPMs.

Is this the same as 1) then ?

>=20
> >       Stefan
>=20
> How would you address measurement logs?

IMA would be namespaced and log separately for every IMA namespace /=20
container.

   Stefan

>=20
> /Jarkko
>=20



--=_alternative 004E186485257F64_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 02/25/2016 08:17:32 AM:<br><br>&gt; <br>&gt; On Wed, Feb 24, 2016 =
at 06:10:42PM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;Jason G=
unthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016<br>&gt; &gt; &nbsp; &nbsp;09:17:30 PM:<br>&gt; &gt; <br=
>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; On Mon, Feb 22,=
 2016 at 08:45:51PM -0500, Stefan
Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt;=
 &gt; Two things:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; - the ioctl takes fla=
gs; should we return
an error on flags that are<br>&gt; &gt; &nbsp; &nbsp;not<br>&gt; &gt; &nbsp=
; &nbsp;&gt; &gt; supported but set by userspace?<br>&gt; &gt; &nbsp; &nbsp=
;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; Typically yes. Otherwise you cannot in=
troduce
new flags in<br>&gt; &gt; &nbsp; &nbsp;&gt; future.<br>&gt; &gt; &nbsp; &nb=
sp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; - the sysfs works but I wished =
we could
give some control over<br>&gt; &gt; &nbsp; &nbsp;&gt; whether it shows<br>&=
gt; &gt; &nbsp; &nbsp;&gt; &gt; any entries. Can we have a flag in the
ioctl on whether to show<br>&gt; &gt; &nbsp; &nbsp;&gt; these files in<br>&=
gt; &gt; &nbsp; &nbsp;&gt; &gt; sysfs?<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&g=
t; &gt; &nbsp; &nbsp;&gt; That is something to address in the future
namespace patch series I<br>&gt; &gt; &nbsp; &nbsp;&gt; expect you'll prepa=
re..<br>&gt; &gt; <br>&gt; &gt; &nbsp; &nbsp;It may be a while until we get=
 there ... nevertheless
it may beworth some<br>&gt; &gt; &nbsp; &nbsp;thought already.<br>&gt; &gt;=
 <br>&gt; &gt; &nbsp; &nbsp;So we have at least two choices for how to avoid
data leakage via sysfs;<br>&gt; &gt; &nbsp; &nbsp;the problem is that sysfs=
 shows all vtpm devices
in all containers; the<br>&gt; &gt; &nbsp; &nbsp;good thing is that at leas=
t Docker (other mgmt.
stacks probably also)<br>&gt; &gt; &nbsp; &nbsp;mount sysfs read-only into =
'normal' containers,
so that writing(even only<br>&gt; &gt; &nbsp; &nbsp;to cancel) isn't typica=
lly possible.<br>&gt; &gt; <br>&gt; &gt; &nbsp; &nbsp;1) allow user space t=
o set a flag whether the sysfs
entries are to be<br>&gt; &gt; &nbsp; &nbsp;registered; a typical container=
 mgmt. stack would
set the flag to avoid<br>&gt; &gt; &nbsp; &nbsp;data leakage between contai=
ners; no vtpm device
with that flag set would<br>&gt; &gt; &nbsp; &nbsp;show anything via sysfs<=
br>&gt; &gt; <br>&gt; &gt; &nbsp; &nbsp;2) we know in which (user) namespac=
e a /dev/tpm%d
device is moved into<br>&gt; &gt; &nbsp; &nbsp;following an ioctl on the de=
vice where a process's
PID is a parameter; we<br>&gt; &gt; &nbsp; &nbsp;could associate the proces=
s's (user) namespace with
the chip and compare<br>&gt; &gt; &nbsp; &nbsp;the current=5Fuser=5Fns() wi=
th chip-&gt;user=5Fns and
return an empty string if<br>&gt; &gt; &nbsp; &nbsp;they don't match; here =
the vtpm device owned by
a particular (user)<br>&gt; &gt; &nbsp; &nbsp;namespace would then also sho=
w data in sysfs entries
if accessed from the<br>&gt; &gt; &nbsp; &nbsp;right namespace; which sysfs=
 entry to look at could
be inferred from the<br>&gt; &gt; &nbsp; &nbsp;minor number on /dev/tpm0 in=
side the container</font></tt><br><br><tt><font size=3D2>With clone() not n=
ecessarily setting the user namespace
and setns() being able to do that after some fork()s, I think 2) doesn't
work so well.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; 3) Do not=
 show any existing sysfs attributes for containers. All but</font></tt><br>=
<br><tt><font size=3D2>A separate sysfs tree isn't built for every containe=
r,
so sysfs is more or less global showing pretty much the same in every conta=
iner
except for networking namespace seems to have a way of not doing that.</fon=
t></tt><br><tt><font size=3D2><br>&gt; &nbsp; &nbsp;'ppi' are nonsense anyw=
ay or is there something that
you couldn't read<br>&gt; &nbsp; &nbsp;from /dev/tpm0? TPM 1.x user space t=
ools could implement
them by<br>&gt; &nbsp; &nbsp;using the character device. It is not backward=
s compatibility
break<br>&gt; &nbsp; &nbsp;technically because existing code does not yet s=
upport
vTPMs.</font></tt><br><br><tt><font size=3D2>Is this the same as 1) then ?<=
/font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; &gt; &nbsp; &nbsp; &nbs=
p; Stefan<br>&gt; <br>&gt; How would you address measurement logs?</font></=
tt><br><br><tt><font size=3D2>IMA would be namespaced and log separately fo=
r every
IMA namespace / container.</font></tt><br><br><tt><font size=3D2>&nbsp; &nb=
sp;Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; /Jarkko<br>&g=
t; <br></font></tt><BR>
--=_alternative 004E186485257F64_=--



--===============2659657532261434924==
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
--===============2659657532261434924==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2659657532261434924==--
