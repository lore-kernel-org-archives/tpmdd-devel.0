From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 09/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Thu, 25 Feb 2016 13:42:10 -0500
Message-ID: <201602251842.u1PIgE8P014270@d03av03.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-10-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222192741.GI22088@obsidianresearch.com>
	<201602230142.u1N1gSuF029481@d01av05.pok.ibm.com>
	<20160223021730.GD26177@obsidianresearch.com>
	<201602242306.u1ON6qGP030251@d01av05.pok.ibm.com>
	<20160225131732.GA20860@intel.com>
	<201602251409.u1PE98LH012367@d01av05.pok.ibm.com>
	<20160225173956.GA1407@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7128441527637621535=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160225173956.GA1407-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============7128441527637621535==
Content-Type: multipart/alternative;
	boundary="=_alternative 0066BE5985257F64_="


--=_alternative 0066BE5985257F64_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/25/2016=20
12:39:56 PM:


>=20
> On Thu, Feb 25, 2016 at 09:12:57AM -0500, Stefan Berger wrote:
>=20
> >    > 3) Do not show any existing sysfs attributes for
> >    > containers. All but
>=20
> >    A separate sysfs tree isn't built for every container, so sysfs is=20
more
> >    or less global showing pretty much the same in every container=20
except
> >    for networking namespace seems to have a way of not doing that.
>=20
> TPM should be able to use the same techniques as net, the syfs.*ns set
> of APIs exists for this purpose. I've never looked at how to use them,
> but something should be workable there.

It looks like they some are being used on the kobject level.=20

>=20
> Once you figure out how to define what TPMs are in a namespace it
> should be doable to use the syfs=5Fns APIs to have sysfs follow that
> restriction just like net does.

Networking has its own namespace and it looks like all devices get created =

while in that namespace. So the kobject can have its association with that =

namespace right from the beginning. In the case of vtpm we need to create=20
the device on the host since we run the TPM emulator on the host out of=20
reach of signals from the container. We would only associate the vtpm=20
device with the namespace after the clone(), a long time after current=20
registration with sysfs. Another difference is that we don't have a device =

namespace, so all our device names and major / minor numbers need to be=20
unique and that's also reflected in sysfs.


I have been experimenting with an ioctl that passes along a file=20
descriptor to a user namespace (/proc/pid/ns/user) for the purpose of=20
associating the vtpm with that user namespace. This is similar to what=20
setns() does, except the ioctl associates a vTPM with a namespace. This=20
works (once the child is in its final namespace, which the parent needs to =

sync with) and following the proposed filtering on the TPM sysfs attribute =

level, only read()s issued from the user namespace that the vTPM is=20
associated with get data. That we can have up to 64k TPM entries in sysfs=20
certainly isn't nice.

This 1st ioctl can be called basically at any time and is called on the=20
file descriptor returned by the vtpm driver.

Another ioctl is the one we have been discussing previously for=20
associating the chip with an IMA namespace (which would be a compile time=20
option). Here we need to ensure that the child gets the chip hooked to the =

IMA namespace before the execve() triggers measurements by IMA. Here I=20
pass the process Id of that child to then determine IMA namespace to hook=20
the chip to and user namespace for vTPM sysfs association. I prefer the=20
child's process id over passing two file descriptors in this case...

   Stefan



--=_alternative 0066BE5985257F64_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/25/2016 12:39:56 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Thu, Feb 25, 2016 at 09:12:57AM -0500, Stefan Berger wrote=
:<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; 3) Do not show any existing sysfs=
 attributes
for<br>&gt; &gt; &nbsp; &nbsp;&gt; containers. All but<br>&gt; <br>&gt; &gt=
; &nbsp; &nbsp;A separate sysfs tree isn't built for every container,
so sysfs is more<br>&gt; &gt; &nbsp; &nbsp;or less global showing pretty mu=
ch the same in every
container except<br>&gt; &gt; &nbsp; &nbsp;for networking namespace seems t=
o have a way of
not doing that.<br>&gt; <br>&gt; TPM should be able to use the same techniq=
ues as net, the syfs.*ns
set<br>&gt; of APIs exists for this purpose. I've never looked at how to us=
e them,<br>&gt; but something should be workable there.</font></tt><br><br>=
<tt><font size=3D2>It looks like they some are being used on the kobject
level. </font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Once you figure=
 out how to define what TPMs are in a namespace it<br>&gt; should be doable=
 to use the syfs=5Fns APIs to have sysfs follow that<br>&gt; restriction ju=
st like net does.</font></tt><br><br><tt><font size=3D2>Networking has its =
own namespace and it looks like
all devices get created while in that namespace. So the kobject can have
its association with that namespace right from the beginning. In the case
of vtpm we need to create the device on the host since we run the TPM emula=
tor
on the host out of reach of signals from the container. We would only assoc=
iate
the vtpm device with the namespace after the clone(), a long time after
current registration with sysfs. Another difference is that we don't have
a device namespace, so all our device names and major / minor numbers need
to be unique and that's also reflected in sysfs.</font></tt><br><br><br><tt=
><font size=3D2>I have been experimenting with an ioctl that passes
along a file descriptor to a user namespace (/proc/pid/ns/user) for the
purpose of associating the vtpm with that user namespace. This is similar
to what setns() does, except the ioctl associates a vTPM with a namespace.
This works (once the child is in its final namespace, which the parent
needs to sync with) and following the proposed filtering on the TPM sysfs
attribute level, only read()s issued from the user namespace that the vTPM
is associated with get data. That we can have up to 64k TPM entries in
sysfs certainly isn't nice.</font></tt><br><br><tt><font size=3D2>This 1st =
ioctl can be called basically at any time
and is called on the file descriptor returned by the vtpm driver.</font></t=
t><br><br><tt><font size=3D2>Another ioctl is the one we have been discussi=
ng previously
for associating the chip with an IMA namespace (which would be a compile
time option). Here we need to ensure that the child gets the chip hooked
to the IMA namespace before the execve() triggers measurements by IMA.
Here I pass the process Id of that child to then determine IMA namespace
to hook the chip to and user namespace for vTPM sysfs association. I prefer
the child's process id over passing two file descriptors in this case...</f=
ont></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 0066BE5985257F64_=--



--===============7128441527637621535==
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
--===============7128441527637621535==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7128441527637621535==--
