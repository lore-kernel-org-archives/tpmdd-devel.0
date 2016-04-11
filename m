From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Mon, 11 Apr 2016 16:30:34 -0400
Message-ID: <201604112030.u3BKUdOM026490@d01av02.pok.ibm.com>
References: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1459275554-12915-3-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160407123539.GA17489@intel.com>
	<57068198.6050407@linux.vnet.ibm.com>
	<20160411084358.GB11322@intel.com>
	<20160411181403.GB371@obsidianresearch.com>
	<201604111933.u3BJXErj001305@d03av03.boulder.ibm.com>
	<20160411202811.GA3663@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8232081261925915356=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160411202811.GA3663-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============8232081261925915356==
Content-Type: multipart/alternative;
	boundary="=_alternative 0070B0F285257F92_="


--=_alternative 0070B0F285257F92_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 04/11/2016=20
04:28:11 PM:


>=20
> On Mon, Apr 11, 2016 at 03:33:10PM -0400, Stefan Berger wrote:
> >    If the intent is to get rid of the priv field, I am not sure=20
whether we
> >    can solve the problem this way.
>=20
> We are not 'getting rid' of priv, the desire is to replace chip->priv=20
with
> dev=5Fget=5Fdrvdata(&chip->dev), which is more consistent with the core=20
driver
> model.
>=20
> > You may remember that the vtpm proxy driver only registers the chip
> > once startup and retrieval of durations and timeouts successfully
>=20
> Doesn't matter, just dev=5Fset=5Fdrvdata right after the chip is
> allocated, just like vtpm does already for chip->priv.

We don't have a dev at this point.

   Stefan



--=_alternative 0070B0F285257F92_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 04/11/2016 04:28:11 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Mon, Apr 11, 2016 at 03:33:10PM -0400, Stefan Berger wrote=
:<br>&gt; &gt; &nbsp; &nbsp;If the intent is to get rid of the priv field, I
am not sure whether we<br>&gt; &gt; &nbsp; &nbsp;can solve the problem this=
 way.<br>&gt; <br>&gt; We are not 'getting rid' of priv, the desire is to r=
eplace chip-&gt;priv
with<br>&gt; dev=5Fget=5Fdrvdata(&amp;chip-&gt;dev), which is more consiste=
nt with
the core driver<br>&gt; model.<br>&gt; <br>&gt; &gt; You may remember that =
the vtpm proxy driver only registers the
chip<br>&gt; &gt; once startup and retrieval of durations and timeouts succ=
essfully<br>&gt; <br>&gt; Doesn't matter, just dev=5Fset=5Fdrvdata right af=
ter the chip is<br>&gt; allocated, just like vtpm does already for chip-&gt=
;priv.</font></tt><br><br><tt><font size=3D2>We don't have a dev at this po=
int.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><=
br><BR>
--=_alternative 0070B0F285257F92_=--



--===============8232081261925915356==
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
--===============8232081261925915356==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8232081261925915356==--
