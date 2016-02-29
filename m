From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 03/10] tpm: Provide strong locking for
 device removal
Date: Mon, 29 Feb 2016 15:04:10 -0500
Message-ID: <201602292004.u1TK4IDH023664@d01av04.pok.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1456766996-9300-4-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229192532.GB15042@obsidianresearch.com>
	<201602291949.u1TJn2Av025592@d03av03.boulder.ibm.com>
	<20160229195400.GA32380@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1050127513998066304=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160229195400.GA32380-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============1050127513998066304==
Content-Type: multipart/alternative;
	boundary="=_alternative 006E3F3C85257F68_="


--=_alternative 006E3F3C85257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/29/2016=20
02:54:01 PM:

>=20
> On Mon, Feb 29, 2016 at 02:48:54PM -0500, Stefan Berger wrote:
> >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
02/29/2016
> >    02:25:32 PM:
> >    >
> >    > On Mon, Feb 29, 2016 at 12:29:49PM -0500, Stefan Berger wrote:
> >    > >   * the device. As the last step this function adds the chip to
> >    > the list of TPM
> >    > >   * chips available for in-kernel use.
> >    > >   *
> >    > > + * Once this function returns the driver call backs in 'op's=20
will
> >    not be
> >    > > + * running and will no longer start.
> >    > > + *
> >    > >   * This function should be only called after the chip
> >    initialization is
> >    > >   * complete.
> >    > >   */
> >    >
> >    > Not sure what happened here, but this hunk belongs with
> >    > tpm=5Fchip=5Funregister
> >    That's where it is. The context 'tpm1=5Fchip=5Funregister' the hunk =

shows
> >    is from the function 'above'.
>=20
> Eh?
>=20
> https://github.com/stefanberger/linux/blob/
>=20
63f0cd1bae930167d31bbe5d5779d40a277e91c5/drivers/char/tpm/tpm-chip.c#L311


Sorry. Fixed here :=20
https://github.com/stefanberger/linux/commit/5808cd0b01b00e1a4e3b23d6970bac=
4efee69038

   Stefan



--=_alternative 006E3F3C85257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/29/2016 02:54:01 PM:<br><br>&gt; <br>&gt; On Mon, Feb 29, 2016 =
at 02:48:54PM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;Jason G=
unthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/29/2016<br>&gt; &gt; &nbsp; &nbsp;02:25:32 PM:<br>&gt; &gt; &nb=
sp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; On Mon, Feb 29, 2016 at 12:29=
:49PM -0500, Stefan
Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; * the device. As t=
he last step
this function adds the chip to<br>&gt; &gt; &nbsp; &nbsp;&gt; the list of T=
PM<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; * chips available for in-kern=
el
use.<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; *<br>&gt; &gt; &nbsp; &nbsp=
;&gt; &gt; + * Once this function returns the driver
call backs in 'op's will<br>&gt; &gt; &nbsp; &nbsp;not be<br>&gt; &gt; &nbs=
p; &nbsp;&gt; &gt; + * running and will no longer start.<br>&gt; &gt; &nbsp=
; &nbsp;&gt; &gt; + *<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; * This fun=
ction should be only
called after the chip<br>&gt; &gt; &nbsp; &nbsp;initialization is<br>&gt; &=
gt; &nbsp; &nbsp;&gt; &gt; &nbsp; * complete.<br>&gt; &gt; &nbsp; &nbsp;&gt=
; &gt; &nbsp; */<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&=
gt; Not sure what happened here, but this hunk
belongs with<br>&gt; &gt; &nbsp; &nbsp;&gt; tpm=5Fchip=5Funregister<br>&gt;=
 &gt; &nbsp; &nbsp;That's where it is. The context 'tpm1=5Fchip=5Funregiste=
r'
the hunk shows<br>&gt; &gt; &nbsp; &nbsp;is from the function 'above'.<br>&=
gt; <br>&gt; Eh?<br>&gt; <br>&gt; </font></tt><a href=3Dhttps://github.com/=
stefanberger/linux/blob/><tt><font size=3D2>https://github.com/stefanberger=
/linux/blob/</font></tt></a><tt><font size=3D2><br>&gt; 63f0cd1bae930167d31=
bbe5d5779d40a277e91c5/drivers/char/tpm/tpm-chip.c#L311</font></tt><br><br><=
br><tt><font size=3D2>Sorry. Fixed here : </font></tt><a href=3Dhttps://git=
hub.com/stefanberger/linux/commit/5808cd0b01b00e1a4e3b23d6970bac4efee69038>=
<tt><font size=3D2 color=3Dblue>https://github.com/stefanberger/linux/commi=
t/5808cd0b01b00e1a4e3b23d6970bac4efee69038</font></tt></a><br><br><tt><font=
 size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 006E3F3C85257F68_=--



--===============1050127513998066304==
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
--===============1050127513998066304==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1050127513998066304==--
