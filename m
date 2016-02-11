From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Thu, 11 Feb 2016 17:26:24 -0500
Message-ID: <201602112226.u1BMQYd4003293@d03av01.boulder.ibm.com>
References: <20160210162809.GB20730@obsidianresearch.com>
	<201602102145.u1ALjSAs001597@d03av04.boulder.ibm.com>
	<20160210222313.GA7047@obsidianresearch.com>
	<201602110038.u1B0cuE0030670@d03av05.boulder.ibm.com>
	<20160211070426.GB9307@intel.com>
	<201602111534.u1BFYvRs019573@d01av03.pok.ibm.com>
	<20160211181208.GA6285@obsidianresearch.com>
	<201602111911.u1BJB2nK017410@d01av03.pok.ibm.com>
	<20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3863648294885320083=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160211221822.GA16304-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============3863648294885320083==
Content-Type: multipart/alternative;
	boundary="=_alternative 007B4CC685257F56_="


--=_alternative 007B4CC685257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/11/2016=20
05:18:22 PM:


>=20
> On Thu, Feb 11, 2016 at 05:10:28PM -0500, Stefan Berger wrote:
> >    Ok.
> >    So here's the new patch.
> >    [1]
https://github.com/stefanberger/linux/commit/a1037db7fb239c46449b054
> >    bfd1a1d18b54179f3
>=20
> What is the point of tpmm=5Fchip=5Fdev?

So that the usage model of the chip is the same. We get this in the=20
tpm-vtpm.c with tpm=5Falloc=5Fchip + tpmm=5Fchip=5Fdev while all others can=
 call=20
tpmm=5Fchip=5Falloc, which combines the two.

>=20
> Just have the vtpm driver do device=5Finitialize, then tpm=5Falloc and
> have the release function do put=5Fdevice on the chip. No need for devm
> at all

I would also like to have a tpm=5Fchip=5Fput (static inline in tpm.h ?) tha=
t=20
wraps the put=5Fdevice. To me this is more intuitive than calling=20
put=5Fdevice() as a counter-part to tpm=5Fchip=5Falloc.

    Stefan


>=20
> Jason
>=20



--=_alternative 007B4CC685257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/11/2016 05:18:22 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Thu, Feb 11, 2016 at 05:10:28PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; &nbsp; &nbsp;Ok.<br>&gt; &gt; &nbsp; &nbsp;So here's the new=
 patch.<br>&gt; &gt; &nbsp; &nbsp;[1]</font></tt><a href=3Dhttps://github.c=
om/stefanberger/linux/commit/a1037db7fb239c46449b054><tt><font size=3D2>htt=
ps://github.com/stefanberger/linux/commit/a1037db7fb239c46449b054</font></t=
t></a><tt><font size=3D2><br>&gt; &gt; &nbsp; &nbsp;bfd1a1d18b54179f3<br>&g=
t; <br>&gt; What is the point of tpmm=5Fchip=5Fdev?</font></tt><br><br><tt>=
<font size=3D2>So that the usage model of the chip is the same. We
get this in the tpm-vtpm.c with tpm=5Falloc=5Fchip + tpmm=5Fchip=5Fdev whil=
e all
others can call tpmm=5Fchip=5Falloc, which combines the two.</font></tt><br=
><tt><font size=3D2><br>&gt; <br>&gt; Just have the vtpm driver do device=
=5Finitialize, then tpm=5Falloc and<br>&gt; have the release function do pu=
t=5Fdevice on the chip. No need for devm<br>&gt; at all</font></tt><br><br>=
<tt><font size=3D2>I would also like to have a tpm=5Fchip=5Fput (static inl=
ine
in tpm.h ?) that wraps the put=5Fdevice. To me this is more intuitive than
calling put=5Fdevice() as a counter-part to tpm=5Fchip=5Falloc.</font></tt>=
<br><br><tt><font size=3D2>&nbsp; &nbsp; Stefan<br></font></tt><br><tt><fon=
t size=3D2><br>&gt; <br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 007B4CC685257F56_=--



--===============3863648294885320083==
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
--===============3863648294885320083==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3863648294885320083==--
