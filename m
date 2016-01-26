From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Mon, 25 Jan 2016 19:28:35 -0500
Message-ID: <201601260028.u0Q0Sg7T031384@d01av01.pok.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160115101146.GA11987@intel.com>
	<201601151302.u0FD2wGG003518@d03av03.boulder.ibm.com>
	<20160125231532.GA10732@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5092837522934406877=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160125231532.GA10732-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============5092837522934406877==
Content-Type: multipart/alternative;
	boundary="=_alternative 00029EE885257F46_="


--=_alternative 00029EE885257F46_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/25/2016=20
06:15:32 PM:

>=20
> On Fri, Jan 15, 2016 at 08:02:52AM -0500, Stefan Berger wrote:
> > Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/15/
> 2016 05:11:46
> > AM:
> >=20
> > >
> > > On Thu, Jan 14, 2016 at 11:01:54AM -0500, Stefan Berger wrote:
> > > > From: Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>
> > > >
> > > > The following series of patches implements a multi-instance vTPM=20
driver
> > > > that can dynamically create TPM 'server' and client device pairs.
> > > >
> > > > Using ioctl's on the provided /dev/vtpmx, a server and a client
> > > > side vTPM device can be created. The server side offers a=20
/dev/vtpms%d
> > > > device and a TPM emulator must be started on it to listen for=20
> TPM commands
> > > > that are written to /dev/vtpmc%d, which is created by the core
> TPM driver.
> > > >
> > > > The primary goal of this series of patches is enabling vTPM=20
> for containers
> > > > and hooking them up to a (future) namespaced IMA. However,=20
thedriver can
> > > > also be used for simulating a hardware TPM on the host.
> > > >
> > > > The last patch provides a test program for controlling device=20
pairs.
> > >
> > > I like the idea. Looking into this in more detail after the next=20
pull
> > > request. Thanks!
> >=20
> > Thank you. I actually found some issues in the code yesterday, so=20
> I eventually
> > will need to repost.
> > I may put the latest on a public git repo in case someone wants to=20
test.
>=20
> I haven't yet reviewed the first version nor read the discussion you and
> Jason have had (except for some distinct emails). The main reasons is
> that I haven't received any feedback to some questions I've asked... One
> of the most important has been is there any documentation for vTPM?

If necessary I can add documentation for the vTPM driver to the patch.

Otherwise there are man pages in this project here that at least explain=20
the command line parameters and tools for the vTPM.

https://github.com/stefanberger/swtpm/blob/master/man/man8

example:

https://github.com/stefanberger/swtpm/blob/master/man/man8/swtpm.pod


    Stefan



--=_alternative 00029EE885257F46_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 01/25/2016 06:15:32 PM:<br><br>&gt; <br>&gt; On Fri, Jan 15, 2016 =
at 08:02:52AM -0500, Stefan Berger wrote:<br>&gt; &gt; Jarkko Sakkinen &lt;=
jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt; wrote
on 01/15/<br>&gt; 2016 05:11:46<br>&gt; &gt; AM:<br>&gt; &gt; <br>&gt; &gt;=
 &gt;<br>&gt; &gt; &gt; On Thu, Jan 14, 2016 at 11:01:54AM -0500, Stefan Be=
rger
wrote:<br>&gt; &gt; &gt; &gt; From: Stefan Berger &lt;stefanb-0rqouEpbLJkO+L8eLDa7Mg@public.gmane.org=
bm.com&gt;<br>&gt; &gt; &gt; &gt;<br>&gt; &gt; &gt; &gt; The following seri=
es of patches implements a multi-instance
vTPM driver<br>&gt; &gt; &gt; &gt; that can dynamically create TPM 'server'=
 and client
device pairs.<br>&gt; &gt; &gt; &gt;<br>&gt; &gt; &gt; &gt; Using ioctl's o=
n the provided /dev/vtpmx, a server
and a client<br>&gt; &gt; &gt; &gt; side vTPM device can be created. The se=
rver side offers
a /dev/vtpms%d<br>&gt; &gt; &gt; &gt; device and a TPM emulator must be sta=
rted on it to
listen for <br>&gt; TPM commands<br>&gt; &gt; &gt; &gt; that are written to=
 /dev/vtpmc%d, which is created
by the core<br>&gt; TPM driver.<br>&gt; &gt; &gt; &gt;<br>&gt; &gt; &gt; &g=
t; The primary goal of this series of patches is enabling
vTPM <br>&gt; for containers<br>&gt; &gt; &gt; &gt; and hooking them up to =
a (future) namespaced IMA. However,
thedriver can<br>&gt; &gt; &gt; &gt; also be used for simulating a hardware=
 TPM on the host.<br>&gt; &gt; &gt; &gt;<br>&gt; &gt; &gt; &gt; The last pa=
tch provides a test program for controlling
device pairs.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; I like the idea. Looking =
into this in more detail after
the next pull<br>&gt; &gt; &gt; request. Thanks!<br>&gt; &gt; <br>&gt; &gt;=
 Thank you. I actually found some issues in the code yesterday,
so <br>&gt; I eventually<br>&gt; &gt; will need to repost.<br>&gt; &gt; I m=
ay put the latest on a public git repo in case someone wants
to test.<br>&gt; <br>&gt; I haven't yet reviewed the first version nor read=
 the discussion you
and<br>&gt; Jason have had (except for some distinct emails). The main reas=
ons
is<br>&gt; that I haven't received any feedback to some questions I've aske=
d...
One<br>&gt; of the most important has been is there any documentation for v=
TPM?</font></tt><br><br><tt><font size=3D2>If necessary I can add documenta=
tion for the vTPM
driver to the patch.</font></tt><br><br><tt><font size=3D2>Otherwise there =
are man pages in this project here
that at least explain the command line parameters and tools for the vTPM.</=
font></tt><br><br><a href=3Dhttps://github.com/stefanberger/swtpm/blob/mast=
er/man/man8><tt><font size=3D2 color=3Dblue>https://github.com/stefanberger=
/swtpm/blob/master/man/man8</font></tt></a><br><br><tt><font size=3D2>examp=
le:</font></tt><br><br><a href=3Dhttps://github.com/stefanberger/swtpm/blob=
/master/man/man8/swtpm.pod><tt><font size=3D2 color=3Dblue>https://github.c=
om/stefanberger/swtpm/blob/master/man/man8/swtpm.pod</font></tt></a><br><br=
><br><tt><font size=3D2>&nbsp; &nbsp; Stefan</font></tt><br><BR>
--=_alternative 00029EE885257F46_=--



--===============5092837522934406877==
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
--===============5092837522934406877==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============5092837522934406877==--
