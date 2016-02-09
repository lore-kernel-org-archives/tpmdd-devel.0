From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Tue, 9 Feb 2016 11:19:15 -0500
Message-ID: <201602091626.u19GQrRs003549@d03av03.boulder.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com><1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2097807649996835747=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160209053323.GD12657-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============2097807649996835747==
Content-Type: multipart/alternative;
	boundary="=_alternative 0059AE4A85257F54_="


--=_alternative 0059AE4A85257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/09/2016=20
12:33:23 AM:


>=20
> On Mon, Feb 08, 2016 at 02:27:07PM -0500, Stefan Berger wrote:
> > Add the retrieval of TPM 1.2 durations and timeouts. Since this=20
requires
> > the startup of the TPM, do this for TPM 1.2 and TPM 2.
> >=20
> > To not allow to interleave with commands from user space, so send the
> > TPM=5FStartup as the first command. The timeouts can then be gotten at =

any
> > later time, even interleaved with commands from user space.
>=20
> Do not call tpm=5Fregister until get=5Ftimeouts has completed and this
> will naturally be avoided the same way every other TPM driver does.

Getting the timeouts cannot complete before the TPM emulator has started,=20
which in turn cannot start before the ioctl returns. We don't know whether =

user space starts a client first on /dev/tpm1 or the TPM emulator starts=20
first on the file descriptor. We can control which command gets *queued*=20
for the TPM emulator and that's what I am doing by having the kernel queue =

the startup command first.

I moved the start of the work call before the tpm=5Fchip=5Fregister, so tha=
t=20
we *queue* the TPM=5FStartup before user space can send its first command.

>=20
> The long term goal is to move the get=5Ftimeouts call into tpm=5Fregister.

That may become a problem then.

   Stefan

>=20
> Jason
>=20
>=20
---------------------------------------------------------------------------=
---
> Site24x7 APM Insight: Get Deep Visibility into Application Performance
> APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
> Monitor end-to-end web transactions and take corrective actions now
> Troubleshoot faster and improve end-user experience. Signup Now!
> http://pubads.g.doubleclick.net/gampad/clk?id=3D272487151&iu=3D/4140
> =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>=20



--=_alternative 0059AE4A85257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/09/2016 12:33:23 AM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Mon, Feb 08, 2016 at 02:27:07PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; Add the retrieval of TPM 1.2 durations and timeouts. Since t=
his
requires<br>&gt; &gt; the startup of the TPM, do this for TPM 1.2 and TPM 2=
.<br>&gt; &gt; <br>&gt; &gt; To not allow to interleave with commands from =
user space, so
send the<br>&gt; &gt; TPM=5FStartup as the first command. The timeouts can =
then be gotten
at any<br>&gt; &gt; later time, even interleaved with commands from user sp=
ace.<br>&gt; <br>&gt; Do not call tpm=5Fregister until get=5Ftimeouts has c=
ompleted and this<br>&gt; will naturally be avoided the same way every othe=
r TPM driver does.</font></tt><br><br><tt><font size=3D2>Getting the timeou=
ts cannot complete before the TPM
emulator has started, which in turn cannot start before the ioctl returns.
We don't know whether user space starts a client first on /dev/tpm1 or
the TPM emulator starts first on the file descriptor. We can control which
command gets *queued* for the TPM emulator and that's what I am doing by
having the kernel queue the startup command first.</font></tt><br><br><tt><=
font size=3D2>I moved the start of the work call before the tpm=5Fchip=5Fre=
gister,
so that we *queue* the TPM=5FStartup before user space can send its first
command.</font></tt><br><br><tt><font size=3D2>&gt; <br>&gt; The long term =
goal is to move the get=5Ftimeouts call into tpm=5Fregister.</font></tt><br=
><br><tt><font size=3D2>That may become a problem then.</font></tt><br><br>=
<tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt><font size=3D2><b=
r>&gt; <br>&gt; Jason<br>&gt; <br>&gt; ------------------------------------=
------------------------------------------<br>&gt; Site24x7 APM Insight: Ge=
t Deep Visibility into Application Performance<br>&gt; APM + Mobile APM + R=
UM: Monitor 3 App instances at just $35/Month<br>&gt; Monitor end-to-end we=
b transactions and take corrective actions now<br>&gt; Troubleshoot faster =
and improve end-user experience. Signup Now!<br>&gt; </font></tt><a href=3D=
"http://pubads.g.doubleclick.net/gampad/clk?id=3D272487151&amp;iu=3D/4140">=
<tt><font size=3D2>http://pubads.g.doubleclick.net/gampad/clk?id=3D27248715=
1&amp;iu=3D/4140</font></tt></a><tt><font size=3D2><br>&gt; =5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F<br>&gt; tpmdd-devel mai=
ling list<br>&gt; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>&gt; </font></tt><a =
href=3D"https://lists.sourceforge.net/lists/listinfo/tpmdd-devel"><tt><font=
 size=3D2>https://lists.sourceforge.net/lists/listinfo/tpmdd-devel</font></=
tt></a><tt><font size=3D2><br>&gt; <br></font></tt><BR>
--=_alternative 0059AE4A85257F54_=--



--===============2097807649996835747==
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
--===============2097807649996835747==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2097807649996835747==--
