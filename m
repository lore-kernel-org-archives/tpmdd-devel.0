From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 03/10] tpm: Provide strong locking
 for	device removal
Date: Mon, 29 Feb 2016 14:48:54 -0500
Message-ID: <201602291949.u1TJn11j027891@d01av02.pok.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com><1456766996-9300-4-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229192532.GB15042@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2591418589690807922=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160229192532.GB15042-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============2591418589690807922==
Content-Type: multipart/alternative;
	boundary="=_alternative 006CD9BF85257F68_="


--=_alternative 006CD9BF85257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/29/2016=20
02:25:32 PM:


>=20
> On Mon, Feb 29, 2016 at 12:29:49PM -0500, Stefan Berger wrote:
> >   * the device. As the last step this function adds the chip to=20
> the list of TPM
> >   * chips available for in-kernel use.
> >   *
> > + * Once this function returns the driver call backs in 'op's will not =

be
> > + * running and will no longer start.
> > + *
> >   * This function should be only called after the chip initialization=20
is
> >   * complete.
> >   */
>=20
> Not sure what happened here, but this hunk belongs with
> tpm=5Fchip=5Funregister

That's where it is. The context 'tpm1=5Fchip=5Funregister' the hunk shows i=
s=20
from the function 'above'.

   Stefan



--=_alternative 006CD9BF85257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/29/2016 02:25:32 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Mon, Feb 29, 2016 at 12:29:49PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; &nbsp; * the device. As the last step this function adds the
chip to <br>&gt; the list of TPM<br>&gt; &gt; &nbsp; * chips available for =
in-kernel use.<br>&gt; &gt; &nbsp; *<br>&gt; &gt; + * Once this function re=
turns the driver call backs in 'op's
will not be<br>&gt; &gt; + * running and will no longer start.<br>&gt; &gt;=
 + *<br>&gt; &gt; &nbsp; * This function should be only called after the ch=
ip initialization
is<br>&gt; &gt; &nbsp; * complete.<br>&gt; &gt; &nbsp; */<br>&gt; <br>&gt; =
Not sure what happened here, but this hunk belongs with<br>&gt; tpm=5Fchip=
=5Funregister<br></font></tt><br><tt><font size=3D2>That's where it is. The=
 context 'tpm1=5Fchip=5Funregister'
the hunk shows is from the function 'above'.</font></tt><br><br><tt><font s=
ize=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 006CD9BF85257F68_=--



--===============2591418589690807922==
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
--===============2591418589690807922==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2591418589690807922==--
