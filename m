From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Mon, 11 Apr 2016 18:12:57 -0400
Message-ID: <201604112213.u3BMD39f032718@d03av04.boulder.ibm.com>
References: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1459275554-12915-3-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160407123539.GA17489@intel.com>
	<57068198.6050407@linux.vnet.ibm.com>
	<20160411084358.GB11322@intel.com>
	<20160411181403.GB371@obsidianresearch.com>
	<201604111933.u3BJXErj001305@d03av03.boulder.ibm.com>
	<20160411202811.GA3663@obsidianresearch.com>
	<201604112030.u3BKUeJQ017181@d01av04.pok.ibm.com>
	<20160411205718.GC3663@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8371388750268727462=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160411205718.GC3663-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============8371388750268727462==
Content-Type: multipart/alternative;
	boundary="=_alternative 007A104E85257F92_="


--=_alternative 007A104E85257F92_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 04/11/2016=20
04:57:18 PM:


>=20
> On Mon, Apr 11, 2016 at 04:30:34PM -0400, Stefan Berger wrote:
>=20
> >    > Doesn't matter, just dev=5Fset=5Fdrvdata right after the chip is
> >    > allocated, just like vtpm does already for chip->priv.
> >    We don't have a dev at this point.
>=20
> Eh? If you have a chip you have a dev.

Ok. I would nevertheless like to reduce the churn in the series where I=20
would post next a v10.

I am using chip->dev.platform=5Fdata =3D proxy=5Fdev to store the proxy=5Fd=
ev.=20
Here's the current v10:

https://github.com/stefanberger/linux/commits/vtpm-driver.v10


>=20
> Jason
>=20



--=_alternative 007A104E85257F92_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 04/11/2016 04:57:18 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Mon, Apr 11, 2016 at 04:30:34PM -0400, Stefan Berger wrote=
:<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; Doesn't matter, just dev=5Fset=5F=
drvdata right
after the chip is<br>&gt; &gt; &nbsp; &nbsp;&gt; allocated, just like vtpm =
does already for
chip-&gt;priv.<br>&gt; &gt; &nbsp; &nbsp;We don't have a dev at this point.=
<br>&gt; <br>&gt; Eh? If you have a chip you have a dev.</font></tt><br><br=
><tt><font size=3D2>Ok. I would nevertheless like to reduce the churn
in the series where I would post next a v10.</font></tt><br><br><tt><font s=
ize=3D2>I am using chip-&gt;dev.platform=5Fdata =3D proxy=5Fdev
to store the proxy=5Fdev. Here's the current v10:</font></tt><br><br><a hre=
f=3D"https://github.com/stefanberger/linux/commits/vtpm-driver.v10"><tt><fo=
nt size=3D2 color=3Dblue>https://github.com/stefanberger/linux/commits/vtpm=
-driver.v10</font></tt></a><br><br><tt><font size=3D2><br>&gt; <br>&gt; Jas=
on<br>&gt; <br></font></tt><BR>
--=_alternative 007A104E85257F92_=--



--===============8371388750268727462==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
--===============8371388750268727462==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8371388750268727462==--
