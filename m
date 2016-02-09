From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Tue, 9 Feb 2016 13:11:58 -0500
Message-ID: <201602091812.u19IC4Rl028511@d03av04.boulder.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
	<201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
	<201602091745.u19HjeEv001740@d03av02.boulder.ibm.com>
	<20160209180152.GA17475@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4419284908462622574=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160209180152.GA17475-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============4419284908462622574==
Content-Type: multipart/alternative;
	boundary="=_alternative 006400DA85257F54_="


--=_alternative 006400DA85257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/09/2016=20
01:01:52 PM:


>=20
> On Tue, Feb 09, 2016 at 12:45:37PM -0500, Stefan Berger wrote:
> > And how do we unroll if tpm=5Fchip=5Fregister fails? We just close thef=
d=20
that we
> > gave to user space?
>=20
> Arrange for the fd to become permanently readable and read returns
> error, user space will close the fd.

:-( User space will just pass the fd to another process, which is the TPM=20
emulator, and that thing then starts failing on the broken file=20
descriptor.

>=20
> > I also don't see why it is a better solution than what I have here=20
now:
> >=20
> > https://github.com/stefanberger/linux/commit/
> > 954c7dece4a5c44525ca07a9569dc2f3b2b3d174
>=20
> As I've said, this mucks up where we want to go with the core code,
> and breaks our current invariants - the TPM hardware must be fully
> operational before tpm=5Fregister is called.

Either way, I don't see how the TPM emulator can be fully operational=20
before tpm=5Fchip=5Fregister() is called. So far the code allows to start a=
=20
TPM emulator on the file descript 'late'. The possibility for accomodating =

the solution in the future is there by leaving the possibility for a=20
boolean where the driver can choose whether timeout retrieval is done as=20
part of tpm=5Fchip=5Fregister or it has to take care of this itself.

   Stefan



--=_alternative 006400DA85257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"


<br><tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&=
gt;
wrote on 02/09/2016 01:01:52 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Tue, Feb 09, 2016 at 12:45:37PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; And how do we unroll if tpm=5Fchip=5Fregister fails? We just=
 close
thefd that we<br>&gt; &gt; gave to user space?<br>&gt; <br>&gt; Arrange for=
 the fd to become permanently readable and read returns<br>&gt; error, user=
 space will close the fd.</font></tt><br><br><tt><font size=3D2>:-( User sp=
ace will just pass the fd to another process,
which is the TPM emulator, and that thing then starts failing on the broken
file descriptor.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; &gt; I=
 also don't see why it is a better solution than what I have
here now:<br>&gt; &gt; <br>&gt; &gt; </font></tt><a href=3Dhttps://github.c=
om/stefanberger/linux/commit/><tt><font size=3D2>https://github.com/stefanb=
erger/linux/commit/</font></tt></a><tt><font size=3D2><br>&gt; &gt; 954c7de=
ce4a5c44525ca07a9569dc2f3b2b3d174<br>&gt; <br>&gt; As I've said, this mucks=
 up where we want to go with the core code,<br>&gt; and breaks our current =
invariants - the TPM hardware must be fully<br>&gt; operational before tpm=
=5Fregister is called.</font></tt><br><br><tt><font size=3D2>Either way, I =
don't see how the TPM emulator can be
fully operational before tpm=5Fchip=5Fregister() is called. So far the code
allows to start a TPM emulator on the file descript 'late'. The possibility
for accomodating the solution in the future is there by leaving the possibi=
lity
for a boolean where the driver can choose whether timeout retrieval is
done as part of tpm=5Fchip=5Fregister or it has to take care of this itself=
.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br>=
<BR>
--=_alternative 006400DA85257F54_=--



--===============4419284908462622574==
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
--===============4419284908462622574==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4419284908462622574==--
