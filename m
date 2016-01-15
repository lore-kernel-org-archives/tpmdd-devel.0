From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Fri, 15 Jan 2016 08:02:52 -0500
Message-ID: <201601151302.u0FD2wAk002441@d03av05.boulder.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160115101146.GA11987@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2896010122691524692=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160115101146.GA11987-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============2896010122691524692==
Content-Type: multipart/alternative;
	boundary="=_alternative 0047AEE285257F3B_="


--=_alternative 0047AEE285257F3B_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/15/2016=20
05:11:46 AM:

>=20
> On Thu, Jan 14, 2016 at 11:01:54AM -0500, Stefan Berger wrote:
> > From: Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>
> >=20
> > The following series of patches implements a multi-instance vTPM=20
driver
> > that can dynamically create TPM 'server' and client device pairs.
> >=20
> > Using ioctl's on the provided /dev/vtpmx, a server and a client
> > side vTPM device can be created. The server side offers a /dev/vtpms%d
> > device and a TPM emulator must be started on it to listen for TPM=20
commands
> > that are written to /dev/vtpmc%d, which is created by the core TPM=20
driver.
> >=20
> > The primary goal of this series of patches is enabling vTPM for=20
containers
> > and hooking them up to a (future) namespaced IMA. However, the driver=20
can
> > also be used for simulating a hardware TPM on the host.
> >=20
> > The last patch provides a test program for controlling device pairs.
>=20
> I like the idea. Looking into this in more detail after the next pull
> request. Thanks!

Thank you. I actually found some issues in the code yesterday, so I=20
eventually will need to repost.
I may put the latest on a public git repo in case someone wants to test.

   Stefan



--=_alternative 0047AEE285257F3B_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 01/15/2016 05:11:46 AM:<br><br>&gt; <br>&gt; On Thu, Jan 14, 2016 =
at 11:01:54AM -0500, Stefan Berger wrote:<br>&gt; &gt; From: Stefan Berger =
&lt;stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org&gt;<br>&gt; &gt; <br>&gt; &gt; The followin=
g series of patches implements a multi-instance vTPM
driver<br>&gt; &gt; that can dynamically create TPM 'server' and client dev=
ice pairs.<br>&gt; &gt; <br>&gt; &gt; Using ioctl's on the provided /dev/vt=
pmx, a server and a client<br>&gt; &gt; side vTPM device can be created. Th=
e server side offers a /dev/vtpms%d<br>&gt; &gt; device and a TPM emulator =
must be started on it to listen for
TPM commands<br>&gt; &gt; that are written to /dev/vtpmc%d, which is create=
d by the core
TPM driver.<br>&gt; &gt; <br>&gt; &gt; The primary goal of this series of p=
atches is enabling vTPM for
containers<br>&gt; &gt; and hooking them up to a (future) namespaced IMA. H=
owever, the
driver can<br>&gt; &gt; also be used for simulating a hardware TPM on the h=
ost.<br>&gt; &gt; <br>&gt; &gt; The last patch provides a test program for =
controlling device
pairs.<br>&gt; <br>&gt; I like the idea. Looking into this in more detail a=
fter the next pull<br>&gt; request. Thanks!</font></tt><br><br><tt><font si=
ze=3D2>Thank you. I actually found some issues in the code
yesterday, so I eventually will need to repost.</font></tt><br><tt><font si=
ze=3D2>I may put the latest on a public git repo in case
someone wants to test.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;S=
tefan</font></tt><br><BR>
--=_alternative 0047AEE285257F3B_=--



--===============2896010122691524692==
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
--===============2896010122691524692==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2896010122691524692==--
