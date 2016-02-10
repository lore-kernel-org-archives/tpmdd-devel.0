From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Wed, 10 Feb 2016 00:15:44 -0500
Message-ID: <201602100515.u1A5FpPD018814@d03av05.boulder.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
	<201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
	<20160210035620.GB7161@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0856431288534685511=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160210035620.GB7161-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============0856431288534685511==
Content-Type: multipart/alternative;
	boundary="=_alternative 001CF00885257F55_="


--=_alternative 001CF00885257F55_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/09/2016=20
10:56:20 PM:

>=20
> On Tue, Feb 09, 2016 at 09:52:28AM -0700, Jason Gunthorpe wrote:
> > On Tue, Feb 09, 2016 at 11:19:15AM -0500, Stefan Berger wrote:
> > > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/
> 09/2016 12:33:23
> > > AM:
> > >=20
> > >=20
> > > >
> > > > On Mon, Feb 08, 2016 at 02:27:07PM -0500, Stefan Berger wrote:
> > > > > Add the retrieval of TPM 1.2 durations and timeouts. Since=20
> this requires
> > > > > the startup of the TPM, do this for TPM 1.2 and TPM 2.
> > > > >
> > > > > To not allow to interleave with commands from user space, so=20
send the
> > > > > TPM=5FStartup as the first command. The timeouts can then be=20
> gotten at any
> > > > > later time, even interleaved with commands from user space.
> > > >
> > > > Do not call tpm=5Fregister until get=5Ftimeouts has completed and t=
his
> > > > will naturally be avoided the same way every other TPM driver=20
does.
> > >=20
> > > Getting the timeouts cannot complete before the TPM emulator has
> started, which
> > > in turn cannot start before the ioctl returns. We don't know=20
> whether user space
> > > starts a client first on /dev/tpm1 or the TPM emulator starts=20
> first on the file
> > > descriptor. We can control which command gets *queued* for the=20
> TPM emulator and
> > > that's what I am doing by having the kernel queue the startup=20
> command first.
> >=20
> > I keep saying this same solution - start a work queue just before the
> > ioctl returns and do the get=5Ftimeouts and registration in there.
>=20
> *Maybe* it would be worth to check David's patch:
>=20
> https://github.com/PeterHuewe/linux-tpmdd/commit/
> 9329f13c403daf1f4bd1e715d2ba0866e089fb1d


Redid that now.

https://github.com/stefanberger/linux/commit/83019eaab2cf5eb33f2665efdf9d2a=
117ed703b2
   Stefan
>=20
> /Jarkko
>=20



--=_alternative 001CF00885257F55_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 02/09/2016 10:56:20 PM:<br><br>&gt; <br>&gt; On Tue, Feb 09, 2016 =
at 09:52:28AM -0700, Jason Gunthorpe wrote:<br>&gt; &gt; On Tue, Feb 09, 20=
16 at 11:19:15AM -0500, Stefan Berger wrote:<br>&gt; &gt; &gt; Jason Guntho=
rpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/<br>&gt; 09/2016 12:33:23<br>&gt; &gt; &gt; AM:<br>&gt; &gt; &g=
t; <br>&gt; &gt; &gt; <br>&gt; &gt; &gt; &gt;<br>&gt; &gt; &gt; &gt; On Mon=
, Feb 08, 2016 at 02:27:07PM -0500, Stefan Berger
wrote:<br>&gt; &gt; &gt; &gt; &gt; Add the retrieval of TPM 1.2 durations a=
nd timeouts.
Since <br>&gt; this requires<br>&gt; &gt; &gt; &gt; &gt; the startup of the=
 TPM, do this for TPM 1.2 and
TPM 2.<br>&gt; &gt; &gt; &gt; &gt;<br>&gt; &gt; &gt; &gt; &gt; To not allow=
 to interleave with commands from
user space, so send the<br>&gt; &gt; &gt; &gt; &gt; TPM=5FStartup as the fi=
rst command. The timeouts
can then be <br>&gt; gotten at any<br>&gt; &gt; &gt; &gt; &gt; later time, =
even interleaved with commands from
user space.<br>&gt; &gt; &gt; &gt;<br>&gt; &gt; &gt; &gt; Do not call tpm=
=5Fregister until get=5Ftimeouts has completed
and this<br>&gt; &gt; &gt; &gt; will naturally be avoided the same way ever=
y other
TPM driver does.<br>&gt; &gt; &gt; <br>&gt; &gt; &gt; Getting the timeouts =
cannot complete before the TPM emulator
has<br>&gt; started, which<br>&gt; &gt; &gt; in turn cannot start before th=
e ioctl returns. We don't
know <br>&gt; whether user space<br>&gt; &gt; &gt; starts a client first on=
 /dev/tpm1 or the TPM emulator starts
<br>&gt; first on the file<br>&gt; &gt; &gt; descriptor. We can control whi=
ch command gets *queued* for
the <br>&gt; TPM emulator and<br>&gt; &gt; &gt; that's what I am doing by h=
aving the kernel queue the startup
<br>&gt; command first.<br>&gt; &gt; <br>&gt; &gt; I keep saying this same =
solution - start a work queue just before
the<br>&gt; &gt; ioctl returns and do the get=5Ftimeouts and registration i=
n there.<br>&gt; <br>&gt; *Maybe* it would be worth to check David's patch:=
<br>&gt; <br>&gt; </font></tt><a href=3D"https://github.com/PeterHuewe/linu=
x-tpmdd/commit/"><tt><font size=3D2>https://github.com/PeterHuewe/linux-tpm=
dd/commit/</font></tt></a><tt><font size=3D2><br>&gt; 9329f13c403daf1f4bd1e=
715d2ba0866e089fb1d</font></tt><br><br><br><tt><font size=3D2>Redid that no=
w.</font></tt><br><br><a href=3Dhttps://github.com/stefanberger/linux/commi=
t/83019eaab2cf5eb33f2665efdf9d2a117ed703b2><tt><font size=3D2 color=3Dblue>=
https://github.com/stefanberger/linux/commit/83019eaab2cf5eb33f2665efdf9d2a=
117ed703b2</font></tt></a><br><tt><font size=3D2>&nbsp; &nbsp;Stefan<br>&gt=
; <br>&gt; /Jarkko<br>&gt; <br></font></tt><BR>
--=_alternative 001CF00885257F55_=--



--===============0856431288534685511==
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
--===============0856431288534685511==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0856431288534685511==--
