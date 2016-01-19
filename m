From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Tue, 19 Jan 2016 18:05:47 -0500
Message-ID: <201601192305.u0JN5qYu002450@d03av03.boulder.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160119174400.GA7616@obsidianresearch.com>
	<201601191753.u0JHrku2031608@d01av01.pok.ibm.com>
	<20160119180802.GA8038@obsidianresearch.com>
	<1453241668.2673.31.camel@linux.vnet.ibm.com>
	<20160119224851.GA31745@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6374328420465428148=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160119224851.GA31745-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============6374328420465428148==
Content-Type: multipart/alternative;
	boundary="=_alternative 007EE0C385257F3F_="


--=_alternative 007EE0C385257F3F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/19/2016=20
05:48:51 PM:


> Date: 01/19/2016 05:49 PM
> Subject: Re: [tpmdd-devel] [RFC PATCH 0/4] Multi-instance vTPM driver
>=20
> On Tue, Jan 19, 2016 at 05:14:28PM -0500, Mimi Zohar wrote:
> > On Tue, 2016-01-19 at 11:08 -0700, Jason Gunthorpe wrote:
> > > On Tue, Jan 19, 2016 at 12:53:40PM -0500, Stefan Berger wrote:
> > > >    This series has absolutely nothing to do with resource
> > > >    management.
> > >=20
> > > Sure the patch doesn't, but the proposed application does.
> > >=20
> > > Linux namespaces is all about resource management.
> >=20
> > huh?  namespacing is about isolation.
>=20
> isolation of what? Every namespace in linux has a defined set of
> kernel managed resources it contains.

- network namespace isolates a network namespace from all the other=20
network namespace through separate network interfaces and separate network =

stack
- mount namespace isolates the mount points and filesystems from other=20
mount namespaces
- PID namespace isolates the process IDs of one container from those of=20
others

- IMA namespacing isolates the measurement lists between IMA namespaces;=20
alos each IMA namespace will have its own IMA policy

The goal is that each IMA namespace can have its own attached vTPM into=20
which IMA can do PCR extensions.

   Stefan

>=20
> > > This is an interesting way to make a software TPM,
> >
> > That's the intention, not namespacing the TPM.
>=20
> Did you read the patch?
>=20
>  The primary goal of this series of patches is enabling vTPM for=20
containers
>  and hooking them up to a (future) namespaced IMA. However, the driver=20
can
>  also be used for simulating a hardware TPM on the host.
>=20
> Jason
>=20



--=_alternative 007EE0C385257F3F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/19/2016 05:48:51 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; Date: 01/19/2016 05:49 PM</font></tt><br><tt><font size=3D2>&gt; Subje=
ct: Re: [tpmdd-devel] [RFC PATCH 0/4] Multi-instance
vTPM driver</font></tt><br><tt><font size=3D2>&gt; <br>&gt; On Tue, Jan 19,=
 2016 at 05:14:28PM -0500, Mimi Zohar wrote:<br>&gt; &gt; On Tue, 2016-01-1=
9 at 11:08 -0700, Jason Gunthorpe wrote:<br>&gt; &gt; &gt; On Tue, Jan 19, =
2016 at 12:53:40PM -0500, Stefan Berger
wrote:<br>&gt; &gt; &gt; &gt; &nbsp; &nbsp;This series has absolutely nothi=
ng to
do with resource<br>&gt; &gt; &gt; &gt; &nbsp; &nbsp;management.<br>&gt; &g=
t; &gt; <br>&gt; &gt; &gt; Sure the patch doesn't, but the proposed applica=
tion does.<br>&gt; &gt; &gt; <br>&gt; &gt; &gt; Linux namespaces is all abo=
ut resource management.<br>&gt; &gt; <br>&gt; &gt; huh? &nbsp;namespacing i=
s about isolation.<br>&gt; <br>&gt; isolation of what? Every namespace in l=
inux has a defined set of<br>&gt; kernel managed resources it contains.</fo=
nt></tt><br><br><tt><font size=3D2>- network namespace isolates a network n=
amespace from
all the other network namespace through separate network interfaces and
separate network stack</font></tt><br><tt><font size=3D2>- mount namespace =
isolates the mount points and filesystems
from other mount namespaces</font></tt><br><tt><font size=3D2>- PID namespa=
ce isolates the process IDs of one container
from those of others</font></tt><br><br><tt><font size=3D2>- IMA namespacin=
g isolates the measurement lists between
IMA namespaces; alos each IMA namespace will have its own IMA policy</font>=
</tt><br><br><tt><font size=3D2>The goal is that each IMA namespace can hav=
e its own
attached vTPM into which IMA can do PCR extensions.</font></tt><br><br><tt>=
<font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt><font size=3D2><br>&g=
t; <br>&gt; &gt; &gt; This is an interesting way to make a software TPM,<br=
>&gt; &gt;<br>&gt; &gt; That's the intention, not namespacing the TPM.<br>&=
gt; <br>&gt; Did you read the patch?<br>&gt; <br>&gt; &nbsp;The primary goa=
l of this series of patches is enabling vTPM
for containers<br>&gt; &nbsp;and hooking them up to a (future) namespaced I=
MA. However, the
driver can<br>&gt; &nbsp;also be used for simulating a hardware TPM on the =
host.</font></tt><br><tt><font size=3D2>&gt; <br>&gt; Jason<br>&gt; <br></f=
ont></tt><BR>
--=_alternative 007EE0C385257F3F_=--



--===============6374328420465428148==
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
--===============6374328420465428148==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6374328420465428148==--
