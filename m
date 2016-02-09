From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Tue, 9 Feb 2016 12:45:37 -0500
Message-ID: <201602091742.u19HgRX4013045@d01av05.pok.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
	<201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9179227801679360496=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160209165228.GA14611-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============9179227801679360496==
Content-Type: multipart/alternative;
	boundary="=_alternative 006196BA85257F54_="


--=_alternative 006196BA85257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/09/2016=20
11:52:28 AM:

>=20
> On Tue, Feb 09, 2016 at 11:19:15AM -0500, Stefan Berger wrote:
> > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/09/
> 2016 12:33:23
> > AM:
> >=20
> >=20
> > >
> > > On Mon, Feb 08, 2016 at 02:27:07PM -0500, Stefan Berger wrote:=20
> > > > Add the retrieval of TPM 1.2 durations and timeouts. Since this=20
requires
> > > > the startup of the TPM, do this for TPM 1.2 and TPM 2.
> > > >
> > > > To not allow to interleave with commands from user space, so send=20
the
> > > > TPM=5FStartup as the first command. The timeouts can then be gotten=
=20
at any
> > > > later time, even interleaved with commands from user space.
> > >
> > > Do not call tpm=5Fregister until get=5Ftimeouts has completed and this
> > > will naturally be avoided the same way every other TPM driver does.
> >=20
> > Getting the timeouts cannot complete before the TPM emulator has=20
> started, which
> > in turn cannot start before the ioctl returns. We don't know=20
> whether user space
> > starts a client first on /dev/tpm1 or the TPM emulator starts=20
> first on the file
> > descriptor. We can control which command gets *queued* for the TPM
> emulator and
> > that's what I am doing by having the kernel queue the startup command=20
first.
>=20
> I keep saying this same solution - start a work queue just before the
> ioctl returns and do the get=5Ftimeouts and registration in there.

And how do we unroll if tpm=5Fchip=5Fregister fails? We just close the fd t=
hat=20
we gave to user space?=20

I also don't see why it is a better solution than what I have here now:

https://github.com/stefanberger/linux/commit/954c7dece4a5c44525ca07a9569dc2=
f3b2b3d174


Stefan

>=20
> Jason
>=20



--=_alternative 006196BA85257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/09/2016 11:52:28 AM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Tue, Feb 09, 2016 at 11:19:15AM -0500, Stefan Berger wrote:<br=
>&gt; &gt; Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt; wrote
on 02/09/<br>&gt; 2016 12:33:23<br>&gt; &gt; AM:<br>&gt; &gt; <br>&gt; &gt;=
 <br>&gt; &gt; &gt;<br>&gt; &gt; &gt; On Mon, Feb 08, 2016 at 02:27:07PM -0=
500, Stefan Berger
wrote: <br>&gt; &gt; &gt; &gt; Add the retrieval of TPM 1.2 durations and t=
imeouts.
Since this requires<br>&gt; &gt; &gt; &gt; the startup of the TPM, do this =
for TPM 1.2 and TPM
2.<br>&gt; &gt; &gt; &gt;<br>&gt; &gt; &gt; &gt; To not allow to interleave=
 with commands from user
space, so send the<br>&gt; &gt; &gt; &gt; TPM=5FStartup as the first comman=
d. The timeouts can
then be gotten at any<br>&gt; &gt; &gt; &gt; later time, even interleaved w=
ith commands from user
space.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; Do not call tpm=5Fregister until=
 get=5Ftimeouts has completed
and this<br>&gt; &gt; &gt; will naturally be avoided the same way every oth=
er TPM driver
does.<br>&gt; &gt; <br>&gt; &gt; Getting the timeouts cannot complete befor=
e the TPM emulator
has <br>&gt; started, which<br>&gt; &gt; in turn cannot start before the io=
ctl returns. We don't know
<br>&gt; whether user space<br>&gt; &gt; starts a client first on /dev/tpm1=
 or the TPM emulator starts
<br>&gt; first on the file<br>&gt; &gt; descriptor. We can control which co=
mmand gets *queued* for the
TPM<br>&gt; emulator and<br>&gt; &gt; that's what I am doing by having the =
kernel queue the startup
command first.<br>&gt; <br>&gt; I keep saying this same solution - start a =
work queue just before
the<br>&gt; ioctl returns and do the get=5Ftimeouts and registration in the=
re.</font></tt><br><br><tt><font size=3D2>And how do we unroll if tpm=5Fchi=
p=5Fregister fails? We
just close the fd that we gave to user space? </font></tt><br><br><tt><font=
 size=3D2>I also don't see why it is a better solution than
what I have here now:</font></tt><br><br><a href=3Dhttps://github.com/stefa=
nberger/linux/commit/954c7dece4a5c44525ca07a9569dc2f3b2b3d174><tt><font siz=
e=3D2 color=3Dblue>https://github.com/stefanberger/linux/commit/954c7dece4a=
5c44525ca07a9569dc2f3b2b3d174</font></tt></a><br><br><br><tt><font size=3D2=
>Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Jason<br>&gt; <=
br></font></tt><BR>
--=_alternative 006196BA85257F54_=--



--===============9179227801679360496==
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
--===============9179227801679360496==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============9179227801679360496==--
