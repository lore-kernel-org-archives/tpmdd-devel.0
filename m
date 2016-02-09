From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Tue, 9 Feb 2016 14:22:21 -0500
Message-ID: <201602091922.u19JMRAU016750@d01av02.pok.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
	<201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
	<201602091745.u19HjeEv001740@d03av02.boulder.ibm.com>
	<20160209180152.GA17475@obsidianresearch.com>
	<201602091812.u19ICTww018943@d03av01.boulder.ibm.com>
	<20160209182013.GA19018@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7570226329280810499=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160209182013.GA19018-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============7570226329280810499==
Content-Type: multipart/alternative;
	boundary="=_alternative 006A727785257F54_="


--=_alternative 006A727785257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/09/2016=20
01:20:13 PM:


> Subject: Re: [tpmdd-devel] [PATCH v5 4/5] Initialize TPM and get=20
> durations and timeouts
>=20
> On Tue, Feb 09, 2016 at 01:11:58PM -0500, Stefan Berger wrote:
>=20
> > :-( User space will just pass the fd to another process, which is the=20
TPM
> > emulator, and that thing then starts failing on the broken file=20
descriptor.
>=20
> .. and then it exits like any other failure and the caller has to sort
> it out, which it already has to handle.
>=20
> > Either way, I don't see how the TPM emulator can be fully operational=20
before
> > tpm=5Fchip=5Fregister() is called.
>=20
> You still haven't said what is wrong with doing all the work in a work
> queue so user space can respond normally without all this ugly hacking.

It doesn't seem right to simply close the file descriptor on the process=20
if something goes wrong. The process couldn't close() on it since another=20
thread could have gotten the same fd number for something else. I haven't=20
seen a file descriptor that one must not close() in user space.

It doesn't seem to work to only close the file (fput()) in case something=20
goes wrong while sending the commands to the TPM and before the=20
tpm=5Fchip=5Fregister(). In that case I see the message 'VFS: Close: file=20
count is 0' once the application closes the fd.

Do you have any insights?

   Stefan



--=_alternative 006A727785257F54_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/09/2016 01:20:13 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] [PATCH v5 4/5] Initialize
TPM and get <br>&gt; durations and timeouts</font></tt><br><tt><font size=
=3D2>&gt; <br>&gt; On Tue, Feb 09, 2016 at 01:11:58PM -0500, Stefan Berger =
wrote:<br>&gt; <br>&gt; &gt; :-( User space will just pass the fd to anothe=
r process, which
is the TPM<br>&gt; &gt; emulator, and that thing then starts failing on the=
 broken file
descriptor.<br>&gt; <br>&gt; .. and then it exits like any other failure an=
d the caller has to
sort<br>&gt; it out, which it already has to handle.<br>&gt; <br>&gt; &gt; =
Either way, I don't see how the TPM emulator can be fully operational
before<br>&gt; &gt; tpm=5Fchip=5Fregister() is called.<br>&gt; <br>&gt; You=
 still haven't said what is wrong with doing all the work in a
work<br>&gt; queue so user space can respond normally without all this ugly=
 hacking.</font></tt><br><br><tt><font size=3D2>It doesn't seem right to si=
mply close the file descriptor
on the process if something goes wrong. The process couldn't close() on
it since another thread could have gotten the same fd number for something
else. I haven't seen a file descriptor that one must not close() in user
space.</font></tt><br><br><tt><font size=3D2>It doesn't seem to work to onl=
y close the file (fput())
in case something goes wrong while sending the commands to the TPM and
before the tpm=5Fchip=5Fregister(). In that case I see the message 'VFS: Cl=
ose:
file count is 0' once the application closes the fd.</font></tt><br><br><tt=
><font size=3D2>Do you have any insights?</font></tt><br><br><tt><font size=
=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 006A727785257F54_=--



--===============7570226329280810499==
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
--===============7570226329280810499==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7570226329280810499==--
