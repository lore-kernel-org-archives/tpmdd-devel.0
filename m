From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 03/10] tpm: Provide strong locking for
 device removal
Date: Fri, 4 Mar 2016 17:01:37 -0500
Message-ID: <201603042211.u24MBvnu029585@d03av01.boulder.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1456766996-9300-4-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229192532.GB15042@obsidianresearch.com>
	<201602291949.u1TJn2Av025592@d03av03.boulder.ibm.com>
	<20160229195400.GA32380@obsidianresearch.com>
	<201602292004.u1TK4IDH023664@d01av04.pok.ibm.com>
	<20160304181038.GA24462@intel.com>
	<201603041908.u24J89Mv018643@d01av03.pok.ibm.com>
	<20160304212716.GA9158@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6516002056122231727=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160304212716.GA9158-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============6516002056122231727==
Content-Type: multipart/alternative;
	boundary="=_alternative 0079024A85257F6C_="


--=_alternative 0079024A85257F6C_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/04/2016=20
04:27:16 PM:

> On Fri, Mar 04, 2016 at 02:06:23PM -0500, Stefan Berger wrote:
> >    Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on=20
03/04/2016
> >    01:10:38 PM:
> >    >
> >    > On Mon, Feb 29, 2016 at 03:04:10PM -0500, Stefan Berger wrote:
> >    > >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on
> >    02/29/2016
> >    > >    02:54:01 PM:
> >    > >
> >    > >    >
> >    > >    > On Mon, Feb 29, 2016 at 02:48:54PM -0500, Stefan Berger=20
wrote:
> >    > >    > >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>=20
wrote on
> >    > >    02/29/2016
> >    > >    > >    02:25:32 PM:
> >    > >    > >    >
> >    > >    > >    > On Mon, Feb 29, 2016 at 12:29:49PM -0500, Stefan=20
Berger
> >    wrote:
> >    > >    > >    > >   * the device. As the last step this function=20
adds
> >    > the chip to
> >    > >    > >    > the list of TPM
> >    > >    > >    > >   * chips available for in-kernel use.
> >    > >    > >    > >   *
> >    > >    > >    > > + * Once this function returns the driver call=20
backs in
> >    'op's
> >    > >    will
> >    > >    > >    not be
> >    > >    > >    > > + * running and will no longer start.
> >    > >    > >    > > + *
> >    > >    > >    > >   * This function should be only called after the =

chip
> >    > >    > >    initialization is
> >    > >    > >    > >   * complete.
> >    > >    > >    > >   */
> >    > >    > >    >
> >    > >    > >    > Not sure what happened here, but this hunk belongs=20
with
> >    > >    > >    > tpm=5Fchip=5Funregister
> >    > >    > >    That's where it is. The context=20
'tpm1=5Fchip=5Funregister' the
> >    hunk
> >    > >    shows
> >    > >    > >    is from the function 'above'.
> >    > >    >
> >    > >    > Eh?
> >    > >    >
> >    > >    > https://github.com/stefanberger/linux/blob/
> >    > >    >
> >    > >=20
> >     63f0cd1bae930167d31bbe5d5779d40a277e91c5/drivers/char/tpm/tpm-
> chip.c#L311
> >    > >
> >    > >    Sorry. Fixed here :
> >    > >    https://github.com/stefanberger/linux/commit/
> >    > 5808cd0b01b00e1a4e3b23d6970bac4efee69038
> >    >
> >    > Already applied v4. Could you send a fix for this to the list?
> >    > Thanks.
> >=20
> >    I can post v5 that also has the Reviewed-by's applied.
> >=20
> >    https://github.com/stefanberger/linux/commits/vtpm-driver.v5
>=20
> That works too. I then just replace patches in my master with new ones.
> BTW, before your post. Could you check my comment about the driver name.
> I think it would be better if the name was tpm=5Fvtpm for consistency
> reasons.
>=20

I renamed the driver file to tpm=5Fvtpm.c . I tested it a bit and it's=20
available here now:

https://github.com/stefanberger/linux/commits/vtpm-driver.v5


   Stefan



--=_alternative 0079024A85257F6C_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/04/2016 04:27:16 PM:<br><br>&gt; On Fri, Mar 04, 2016 at 02:06:=
23PM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;Jarkko Sakkinen =
&lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/04/2016<br>&gt; &gt; &nbsp; &nbsp;01:10:38 PM:<br>&gt; &gt; &nb=
sp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; On Mon, Feb 29, 2016 at 03:04=
:10PM -0500, Stefan
Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;Jason Guntho=
rpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on<br>&gt; &gt; &nbsp; &nbsp;02/29/2016<br>&gt; &gt; &nbsp; &nbsp;&gt=
; &gt; &nbsp; &nbsp;02:54:01 PM:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt;<br>&gt=
; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&=
gt; &gt; &nbsp; &nbsp;&gt; On Mon, Feb 29, 2016
at 02:48:54PM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt; &g=
t; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;Jason
Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt; wrote on<br>&gt; &gt; &nb=
sp; &nbsp;&gt; &gt; &nbsp; &nbsp;02/29/2016<br>&gt; &gt; &nbsp; &nbsp;&gt; =
&gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;02:25:32
PM:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp=
;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nb=
sp;&gt;
On Mon, Feb 29, 2016 at 12:29:49PM -0500, Stefan Berger<br>&gt; &gt; &nbsp;=
 &nbsp;wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &n=
bsp; &nbsp;&gt;
&gt; &nbsp; * the device. As the last step this function adds<br>&gt; &gt; =
&nbsp; &nbsp;&gt; the chip to<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &n=
bsp;&gt; &gt; &nbsp; &nbsp;&gt;
the list of TPM<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; =
&nbsp; &nbsp;&gt;
&gt; &nbsp; * chips available for in-kernel use.<br>&gt; &gt; &nbsp; &nbsp;=
&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt;
&gt; &nbsp; *<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &n=
bsp; &nbsp;&gt;
&gt; + * Once this function returns the driver call backs in<br>&gt; &gt; &=
nbsp; &nbsp;'op's<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;will<br>=
&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;not
be<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;=
&gt;
&gt; + * running and will no longer start.<br>&gt; &gt; &nbsp; &nbsp;&gt; &=
gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt;
&gt; + *<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; =
&nbsp;&gt;
&gt; &nbsp; * This function should be only called after the chip<br>&gt; &g=
t; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;initialization
is<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;=
&gt;
&gt; &nbsp; * complete.<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&g=
t; &gt; &nbsp; &nbsp;&gt;
&gt; &nbsp; */<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &=
nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt;=
 &nbsp; &nbsp;&gt;
Not sure what happened here, but this hunk belongs with<br>&gt; &gt; &nbsp;=
 &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt;
tpm=5Fchip=5Funregister<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&g=
t; &gt; &nbsp; &nbsp;That's
where it is. The context 'tpm1=5Fchip=5Funregister' the<br>&gt; &gt; &nbsp;=
 &nbsp;hunk<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;shows<br>&gt; =
&gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;is
from the function 'above'.<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp=
;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt; Eh?<br>&gt; &gt=
; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; &=
gt; &nbsp; &nbsp;&gt; </font></tt><a href=3Dhttps://github.com/stefanberger=
/linux/blob/><tt><font size=3D2>https://github.com/stefanberger/linux/blob/=
</font></tt></a><tt><font size=3D2><br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nb=
sp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp;<br>&gt; &gt; &nbs=
p; &nbsp; 63f0cd1bae930167d31bbe5d5779d40a277e91c5/drivers/char/tpm/tpm-<br=
>&gt; chip.c#L311<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt;<br>&gt; &gt; &nbsp; &=
nbsp;&gt; &gt; &nbsp; &nbsp;Sorry. Fixed here :<br>&gt; &gt; &nbsp; &nbsp;&=
gt; &gt; &nbsp; &nbsp;</font></tt><a href=3Dhttps://github.com/stefanberger=
/linux/commit/><tt><font size=3D2>https://github.com/stefanberger/linux/com=
mit/</font></tt></a><tt><font size=3D2><br>&gt; &gt; &nbsp; &nbsp;&gt; 5808=
cd0b01b00e1a4e3b23d6970bac4efee69038<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt;=
 &gt; &nbsp; &nbsp;&gt; Already applied v4. Could you send a fix for
this to the list?<br>&gt; &gt; &nbsp; &nbsp;&gt; Thanks.<br>&gt; &gt; <br>&=
gt; &gt; &nbsp; &nbsp;I can post v5 that also has the Reviewed-by's applied=
.<br>&gt; &gt; <br>&gt; &gt; &nbsp; &nbsp;</font></tt><a href=3D"https://gi=
thub.com/stefanberger/linux/commits/vtpm-driver.v5"><tt><font size=3D2>http=
s://github.com/stefanberger/linux/commits/vtpm-driver.v5</font></tt></a><tt=
><font size=3D2><br>&gt; <br>&gt; That works too. I then just replace patch=
es in my master with new
ones.<br>&gt; BTW, before your post. Could you check my comment about the d=
river
name.<br>&gt; I think it would be better if the name was tpm=5Fvtpm for con=
sistency<br>&gt; reasons.<br>&gt; </font></tt><br><br><tt><font size=3D2>I =
renamed the driver file to tpm=5Fvtpm.c . I tested
it a bit and it's available here now:</font></tt><br><br><a href=3D"https:/=
/github.com/stefanberger/linux/commits/vtpm-driver.v5"><tt><font size=3D2 c=
olor=3Dblue>https://github.com/stefanberger/linux/commits/vtpm-driver.v5</f=
ont></tt></a><br><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt>=
<br><BR>
--=_alternative 0079024A85257F6C_=--



--===============6516002056122231727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============6516002056122231727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6516002056122231727==--
