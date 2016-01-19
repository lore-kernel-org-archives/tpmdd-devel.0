From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Tue, 19 Jan 2016 18:15:09 -0500
Message-ID: <201601192315.u0JNFFG6030371@d03av01.boulder.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160119174400.GA7616@obsidianresearch.com>
	<201601191753.u0JHrku2031608@d01av01.pok.ibm.com>
	<20160119180802.GA8038@obsidianresearch.com>
	<201601191818.u0JIIExQ010843@d03av04.boulder.ibm.com>
	<20160119230456.GB31745@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0212282775668831452=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160119230456.GB31745-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Kenneth Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============0212282775668831452==
Content-Type: multipart/alternative;
	boundary="=_alternative 007FBC3285257F3F_="


--=_alternative 007FBC3285257F3F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/19/2016=20
06:04:56 PM:

> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> To: Stefan Berger/Watson/IBM@IBMUS
> Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Stefan Berger=20
> <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Date: 01/19/2016 06:05 PM
> Subject: Re: [tpmdd-devel] [RFC PATCH 0/4] Multi-instance vTPM driver
>=20
> On Tue, Jan 19, 2016 at 01:18:08PM -0500, Stefan Berger wrote:
> >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
01/19/2016
> >    01:08:02 PM:
> >    >
> >    > On Tue, Jan 19, 2016 at 12:53:40PM -0500, Stefan Berger wrote:
> >    > >    This series has absolutely nothing to do with resource
> >    > >    management.
> >    >
> >    > Sure the patch doesn't, but the proposed application does.
> >    >
> >    > Linux namespaces is all about resource management.
> >    The resource manager that's been discussed on the list is something
> >    different, though, right?
>=20
> No, I meant that discussion.
>=20
> A completed TPM resource manager would be very close to supporting a
> 'tpm namespace'.
>=20
> Ie per-ns virtualizing of the SRK with would be trivial.

If someone takes ownership of the TPM 1.2 a password is associated with=20
the ownership and the SRK. How do you virtualize commands that need the=20
SRK password when a user wants to create a key where the SRK is the=20
parent? Does the resource manager now have to know the SRK password and=20
inject it into commands where the SRK password seems necessary ?

>=20
> Access control would already be done out of the box as a consequence
> of the process-to-process isolation the resource manager would need to
> perform.

Would that be a single hardware TPM for possibly hundreds of containers on =

a system? How well does that scale?

Besides that a namespaced IMA will want to maintain an isolated list of=20
measurements per IMA namespace and ideally wants to extend measurements=20
into PCR 10 of a vTPM that is associated with that namespace. Once that=20
namespace goes away (container torn down) , the list will go away as well=20
and along with it the TPM emulator. So that speaks for spawning a vTPM for =

each container with an associated IMA namespace.

>=20
> Not sure about PCRS, I guess that depends on how that could work. Not
> sure it makes alot of sense in TPM 1.2 at least...

The challenges in terms of 'virtualizing the single TPM' are similar for=20
TPM 2.

   Stefan

>=20
> Jason
>=20



--=_alternative 007FBC3285257F3F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/19/2016 06:04:56 PM:<br><br>&gt; From: Jason Gunthorpe &lt;jgun=
thorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;</font></tt><br><tt><font size=3D2>&gt; To: =
Stefan Berger/Watson/IBM@IBMUS</font></tt><br><tt><font size=3D2>&gt; Cc: d=
howells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
Stefan Berger <br>&gt; &lt;stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org&gt;, tpmdd-devel@lis=
ts.sourceforge.net</font></tt><br><tt><font size=3D2>&gt; Date: 01/19/2016 =
06:05 PM</font></tt><br><tt><font size=3D2>&gt; Subject: Re: [tpmdd-devel] =
[RFC PATCH 0/4] Multi-instance
vTPM driver</font></tt><br><tt><font size=3D2>&gt; <br>&gt; On Tue, Jan 19,=
 2016 at 01:18:08PM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;J=
ason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/19/2016<br>&gt; &gt; &nbsp; &nbsp;01:08:02 PM:<br>&gt; &gt; &nb=
sp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; On Tue, Jan 19, 2016 at 12:53=
:40PM -0500, Stefan
Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;This series =
has absolutely
nothing to do with resource<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbs=
p;management.<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt;=
 Sure the patch doesn't, but the proposed application
does.<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; Linux n=
amespaces is all about resource management.<br>&gt; &gt; &nbsp; &nbsp;The r=
esource manager that's been discussed on the
list is something<br>&gt; &gt; &nbsp; &nbsp;different, though, right?<br>&g=
t; <br>&gt; No, I meant that discussion.<br>&gt; <br>&gt; A completed TPM r=
esource manager would be very close to supporting
a<br>&gt; 'tpm namespace'.</font></tt><br><tt><font size=3D2>&gt; <br>&gt; =
Ie per-ns virtualizing of the SRK with would be trivial.</font></tt><br><br=
><tt><font size=3D2>If someone takes ownership of the TPM 1.2 a password
is associated with the ownership and the SRK. How do you virtualize commands
that need the SRK password when a user wants to create a key where the
SRK is the parent? Does the resource manager now have to know the SRK passw=
ord
and inject it into commands where the SRK password seems necessary ?</font>=
</tt><br><tt><font size=3D2><br>&gt; <br>&gt; Access control would already =
be done out of the box as a consequence<br>&gt; of the process-to-process i=
solation the resource manager would need
to<br>&gt; perform.</font></tt><br><br><tt><font size=3D2>Would that be a s=
ingle hardware TPM for possibly hundreds
of containers on a system? How well does that scale?</font></tt><br><br><tt=
><font size=3D2>Besides that a namespaced IMA will want to maintain
an isolated list of measurements per IMA namespace and ideally wants to
extend measurements into PCR 10 of a vTPM that is associated with that
namespace. Once that namespace goes away (container torn down) , the list
will go away as well and along with it the TPM emulator. So that speaks
for spawning a vTPM for each container with an associated IMA namespace.</f=
ont></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Not sure about PCRS, I gu=
ess that depends on how that could work.
Not<br>&gt; sure it makes alot of sense in TPM 1.2 at least...</font></tt><=
br><br><tt><font size=3D2>The challenges in terms of 'virtualizing the sing=
le
TPM' are similar for TPM 2.</font></tt><br><br><tt><font size=3D2>&nbsp; &n=
bsp;Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Jason<br>&gt=
; <br></font></tt><BR>
--=_alternative 007FBC3285257F3F_=--



--===============0212282775668831452==
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
--===============0212282775668831452==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0212282775668831452==--
