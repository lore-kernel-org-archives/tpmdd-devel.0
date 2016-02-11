From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Thu, 11 Feb 2016 17:10:28 -0500
Message-ID: <201602112210.u1BMAYdH006841@d03av05.boulder.ibm.com>
References: <20160210035620.GB7161@intel.com>
	<201602100515.u1A5FpFi002736@d03av02.boulder.ibm.com>
	<20160210162809.GB20730@obsidianresearch.com>
	<201602102145.u1ALjSAs001597@d03av04.boulder.ibm.com>
	<20160210222313.GA7047@obsidianresearch.com>
	<201602110038.u1B0cuE0030670@d03av05.boulder.ibm.com>
	<20160211070426.GB9307@intel.com>
	<201602111534.u1BFYvRs019573@d01av03.pok.ibm.com>
	<20160211181208.GA6285@obsidianresearch.com>
	<201602111911.u1BJB2nK017410@d01av03.pok.ibm.com>
	<20160211194810.GA24211@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1679372975013162795=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160211194810.GA24211-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============1679372975013162795==
Content-Type: multipart/alternative;
	boundary="=_alternative 0079D78485257F56_="


--=_alternative 0079D78485257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/11/2016=20
02:48:10 PM:

>=20
> On Thu, Feb 11, 2016 at 02:10:56PM -0500, Stefan Berger wrote:
>=20
> >    > Make sense. Don't change the names all the drivers would have to=20
be
> >    > churn'd. tpm=5Fchip=5Falloc, tpmm=5Fchip=5Falloc.
> >    >
> >    That's right:
> >    struct tpm=5Fchip *tpmm=5Fchip=5Falloc(struct device *dev,
> >                                     const struct tpm=5Fclass=5Fops *ops)
> >    {
> >            struct tpm=5Fchip *chip;
> >            chip =3D tpm=5Fchip=5Falloc(ops);
> >            if (IS=5FERR(chip))
> >                    return chip;
> >            tpmm=5Fchip=5Fdev(chip, dev);
>=20
> No, just call the one devm=5F function here (Based this work on top of
> Jarkko's patch that adds the devm function)

Ok.

So here's the new patch.

https://github.com/stefanberger/linux/commit/a1037db7fb239c46449b054bfd1a1d=
18b54179f3

I removed dev from parameter to tpm=5Fchip=5Falloc. We don't need to provid=
e=20
it here but it has to be a parameter to tpmm=5Fchip=5Fdev.

   Stefan


--=_alternative 0079D78485257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/11/2016 02:48:10 PM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Thu, Feb 11, 2016 at 02:10:56PM -0500, Stefan Berger wrote:<br=
>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; Make sense. Don't change the names al=
l the
drivers would have to be<br>&gt; &gt; &nbsp; &nbsp;&gt; churn'd. tpm=5Fchip=
=5Falloc, tpmm=5Fchip=5Falloc.<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; =
&nbsp; &nbsp;That's right:<br>&gt; &gt; &nbsp; &nbsp;struct tpm=5Fchip *tpm=
m=5Fchip=5Falloc(struct device *dev,<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; const struct
tpm=5Fclass=5Fops *ops)<br>&gt; &gt; &nbsp; &nbsp;{<br>&gt; &gt; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp;struct tpm=5Fchip *chip;<br>&gt; &gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;chip =3D tpm=5Fchip=5Falloc(ops);<br>&gt=
; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (IS=5FERR(chip))<br>&gt;=
 &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;return chip;<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;tp=
mm=5Fchip=5Fdev(chip,
dev);<br>&gt; <br>&gt; No, just call the one devm=5F function here (Based t=
his work on top
of<br>&gt; Jarkko's patch that adds the devm function)</font></tt><br><br><=
tt><font size=3D2>Ok.</font></tt><br><br><tt><font size=3D2>So here's the n=
ew patch.</font></tt><br><br><a href=3Dhttps://github.com/stefanberger/linu=
x/commit/a1037db7fb239c46449b054bfd1a1d18b54179f3><tt><font size=3D2 color=
=3Dblue>https://github.com/stefanberger/linux/commit/a1037db7fb239c46449b05=
4bfd1a1d18b54179f3</font></tt></a><br><br><tt><font size=3D2>I removed dev =
from parameter to tpm=5Fchip=5Falloc. We
don't need to provide it here but it has to be a parameter to tpmm=5Fchip=
=5Fdev.</font></tt><br><tt><font size=3D2><br> &nbsp; Stefan</font></tt><BR>
--=_alternative 0079D78485257F56_=--



--===============1679372975013162795==
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
--===============1679372975013162795==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1679372975013162795==--
