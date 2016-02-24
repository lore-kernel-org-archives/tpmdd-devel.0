From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 09/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Wed, 24 Feb 2016 18:10:42 -0500
Message-ID: <201602242306.u1ON6qGP030251@d01av05.pok.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-10-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222192741.GI22088@obsidianresearch.com>
	<201602230142.u1N1gSuF029481@d01av05.pok.ibm.com>
	<20160223021730.GD26177@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8019052637031585679=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160223021730.GD26177-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============8019052637031585679==
Content-Type: multipart/alternative;
	boundary="=_alternative 007F53ED85257F63_="


--=_alternative 007F53ED85257F63_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
09:17:30 PM:

>=20
> On Mon, Feb 22, 2016 at 08:45:51PM -0500, Stefan Berger wrote:
>=20
> > Two things:
> > - the ioctl takes flags; should we return an error on flags that are=20
not
> > supported but set by userspace?
>=20
> Typically yes. Otherwise you cannot introduce new flags in
> future.
>=20
> > - the sysfs works but I wished we could give some control over=20
> whether it shows
> > any entries. Can we have a flag in the ioctl on whether to show=20
> these files in
> > sysfs?
>=20
> That is something to address in the future namespace patch series I
> expect you'll prepare..

It may be a while until we get there ... nevertheless it may be worth some =

thought already.

So we have at least two choices for how to avoid data leakage via sysfs;=20
the problem is that sysfs shows all vtpm devices in all containers; the=20
good thing is that at least Docker (other mgmt. stacks probably also)=20
mount sysfs read-only into 'normal' containers, so that writing (even only =

to cancel) isn't typically possible.

1) allow user space to set a flag whether the sysfs entries are to be=20
registered; a typical container mgmt. stack would set the flag to avoid=20
data leakage between containers; no vtpm device with that flag set would=20
show anything via sysfs

2) we know in which (user) namespace a /dev/tpm%d device is moved into=20
following an ioctl on the device where a process's PID is a parameter; we=20
could associate the process's (user) namespace with the chip and compare=20
the current=5Fuser=5Fns() with chip->user=5Fns and return an empty string i=
f=20
they don't match; here the vtpm device owned by a particular (user)=20
namespace would then also show data in sysfs entries if accessed from the=20
right namespace; which sysfs entry to look at could be inferred from the=20
minor number on /dev/tpm0 inside the container


   Stefan



--=_alternative 007F53ED85257F63_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 09:17:30 PM:<br><br>&gt; <br>&gt; On Mon, Feb 22, 2016 =
at 08:45:51PM -0500, Stefan Berger wrote:<br>&gt; <br>&gt; &gt; Two things:=
<br>&gt; &gt; - the ioctl takes flags; should we return an error on flags t=
hat
are not<br>&gt; &gt; supported but set by userspace?<br>&gt; <br>&gt; Typic=
ally yes. Otherwise you cannot introduce new flags in<br>&gt; future.<br>&g=
t; <br>&gt; &gt; - the sysfs works but I wished we could give some control =
over
<br>&gt; whether it shows<br>&gt; &gt; any entries. Can we have a flag in t=
he ioctl on whether to show
<br>&gt; these files in<br>&gt; &gt; sysfs?<br>&gt; <br>&gt; That is someth=
ing to address in the future namespace patch series
I<br>&gt; expect you'll prepare..</font></tt><br><br><tt><font size=3D2>It =
may be a while until we get there ... nevertheless
it may be worth some thought already.</font></tt><br><br><tt><font size=3D2=
>So we have at least two choices for how to avoid data
leakage via sysfs; the problem is that sysfs shows all vtpm devices in
all containers; the good thing is that at least Docker (other mgmt. stacks
probably also) mount sysfs read-only into 'normal' containers, so that
writing (even only to cancel) isn't typically possible.</font></tt><br><br>=
<tt><font size=3D2>1) allow user space to set a flag whether the sysfs
entries are to be registered; a typical container mgmt. stack would set
the flag to avoid data leakage between containers; no vtpm device with
that flag set would show anything via sysfs</font></tt><br><br><tt><font si=
ze=3D2>2) we know in which (user) namespace a /dev/tpm%d
device is moved into following an ioctl on the device where a process's
PID is a parameter; we could associate the process's (user) namespace with
the chip and compare the current=5Fuser=5Fns() with chip-&gt;user=5Fns and =
return
an empty string if they don't match; here the vtpm device owned by a partic=
ular
(user) namespace would then also show data in sysfs entries if accessed
from the right namespace; which sysfs entry to look at could be inferred
from the minor number on /dev/tpm0 inside the container</font></tt><br><br>=
<br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 007F53ED85257F63_=--



--===============8019052637031585679==
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
--===============8019052637031585679==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8019052637031585679==--
