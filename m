From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 3/5] Make tpm_startup() available
Date: Tue, 9 Feb 2016 06:22:09 -0500
Message-ID: <201602091122.u19BMDnb020751@d03av02.boulder.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com><1454959628-30582-4-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209052957.GC12657@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1372053233428292906=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160209052957.GC12657-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============1372053233428292906==
Content-Type: multipart/alternative;
	boundary="=_alternative 003E7AFD85257F54_="


--=_alternative 003E7AFD85257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/09/2016=20
12:29:57 AM:

>=20
> On Mon, Feb 08, 2016 at 02:27:06PM -0500, Stefan Berger wrote:
> > Make tpm=5Fstartup() available for others to call.
>=20
> Why? Just call tpm=5Fget=5Ftimeouts.

See the subsequent patch.

tpm=5Fget=5Ftimeouts will first try to get the timeouts and will fail since=
=20
the TPM hasn't been initialized
and only then it will try a tpm=5Fstartup.

http://lxr.free-electrons.com/source/drivers/char/tpm/tpm-interface.c#L508

We want to prevent that user space is already waiting in the transmission=20
lock waiting to send its first
command and ends up sending a command before the tpm=5Fstartup.

http://lxr.free-electrons.com/ident?i=3Dmutex=5Flock


   Stefan



--=_alternative 003E7AFD85257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/09/2016 12:29:57 AM:<br><br>&gt; <br>&gt; On Mon, Feb 08, 2016 =
at 02:27:06PM -0500, Stefan Berger wrote:<br>&gt; &gt; Make tpm=5Fstartup()=
 available for others to call.<br>&gt; <br>&gt; Why? Just call tpm=5Fget=5F=
timeouts.</font></tt><br><br><tt><font size=3D2>See the subsequent patch.</=
font></tt><br><br><tt><font size=3D2>tpm=5Fget=5Ftimeouts will first try to=
 get the timeouts
and will fail since the TPM hasn't been initialized</font></tt><br><tt><fon=
t size=3D2>and only then it will try a tpm=5Fstartup.</font></tt><br><br><a=
 href=3D"http://lxr.free-electrons.com/source/drivers/char/tpm/tpm-interfac=
e.c#L508"><tt><font size=3D2 color=3Dblue>http://lxr.free-electrons.com/sou=
rce/drivers/char/tpm/tpm-interface.c#L508</font></tt></a><br><br><tt><font =
size=3D2>We want to prevent that user space is already waiting
in the transmission lock waiting to send its first</font></tt><br><tt><font=
 size=3D2>command and ends up sending a command before the tpm=5Fstartup.</=
font></tt><br><br><a href=3D"http://lxr.free-electrons.com/ident?i=3Dmutex=
=5Flock"><tt><font size=3D2 color=3Dblue>http://lxr.free-electrons.com/iden=
t?i=3Dmutex=5Flock</font></tt></a><br><br><br><tt><font size=3D2>&nbsp; &nb=
sp;Stefan</font></tt><br><BR>
--=_alternative 003E7AFD85257F54_=--



--===============1372053233428292906==
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
--===============1372053233428292906==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1372053233428292906==--
