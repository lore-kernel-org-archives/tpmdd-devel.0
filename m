From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Tue, 19 Jan 2016 13:18:08 -0500
Message-ID: <201601191818.u0JIIDem000938@d01av02.pok.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160119174400.GA7616@obsidianresearch.com>
	<201601191753.u0JHrku2031608@d01av01.pok.ibm.com>
	<20160119180802.GA8038@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1918981440243133984=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160119180802.GA8038-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============1918981440243133984==
Content-Type: multipart/alternative;
	boundary="=_alternative 00648B0785257F3F_="


--=_alternative 00648B0785257F3F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/19/2016=20
01:08:02 PM:


>=20
> On Tue, Jan 19, 2016 at 12:53:40PM -0500, Stefan Berger wrote:
> >    This series has absolutely nothing to do with resource
> >    management.
>=20
> Sure the patch doesn't, but the proposed application does.
>=20
> Linux namespaces is all about resource management.

The resource manager that's been discussed on the list is something=20
different, though, right?

>=20
> This is an interesting way to make a software TPM, but it is not a
> great way to namespace enable the TPM subsystem.

It tries to address the use case of making a virtual TPM available to 1st=20
level containers. It doesn't address recursive containers.

So one creates a device node on the host and moves that into the=20
container. That is what is for example being done for block devices as=20
well.

Do you have a better suggestion on how to do this?

Regards,
  Stefan



--=_alternative 00648B0785257F3F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/19/2016 01:08:02 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Tue, Jan 19, 2016 at 12:53:40PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; &nbsp; &nbsp;This series has absolutely nothing to do with r=
esource<br>&gt; &gt; &nbsp; &nbsp;management.<br>&gt; <br>&gt; Sure the pat=
ch doesn't, but the proposed application does.<br>&gt; <br>&gt; Linux names=
paces is all about resource management.</font></tt><br><br><tt><font size=
=3D2>The resource manager that's been discussed on the
list is something different, though, right?</font></tt><br><tt><font size=
=3D2><br>&gt; <br>&gt; This is an interesting way to make a software TPM, b=
ut it is not a<br>&gt; great way to namespace enable the TPM subsystem.</fo=
nt></tt><br><br><tt><font size=3D2>It tries to address the use case of maki=
ng a virtual
TPM available to 1st level containers. It doesn't address recursive contain=
ers.</font></tt><br><br><tt><font size=3D2>So one creates a device node on =
the host and moves
that into the container. That is what is for example being done for block
devices as well.</font></tt><br><br><tt><font size=3D2>Do you have a better=
 suggestion on how to do this?</font></tt><br><br><tt><font size=3D2>Regard=
s,</font></tt><br><tt><font size=3D2>&nbsp; Stefan</font></tt><br><BR>
--=_alternative 00648B0785257F3F_=--



--===============1918981440243133984==
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
--===============1918981440243133984==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1918981440243133984==--
