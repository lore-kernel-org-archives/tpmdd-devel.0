From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Thu, 11 Feb 2016 22:56:47 -0500
Message-ID: <201602120356.u1C3usEe002034@d03av04.boulder.ibm.com>
References: <20160210222313.GA7047@obsidianresearch.com>
	<201602110038.u1B0cuE0030670@d03av05.boulder.ibm.com>
	<20160211070426.GB9307@intel.com>
	<201602111534.u1BFYvRs019573@d01av03.pok.ibm.com>
	<20160211181208.GA6285@obsidianresearch.com>
	<201602111911.u1BJB2nK017410@d01av03.pok.ibm.com>
	<20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8735304070803288526=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160211235611.GB16304-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============8735304070803288526==
Content-Type: multipart/alternative;
	boundary="=_alternative 0015B63585257F57_="


--=_alternative 0015B63585257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/11/2016=20
06:56:11 PM:


>=20
> On Thu, Feb 11, 2016 at 05:26:24PM -0500, Stefan Berger wrote:
>=20
> >    > What is the point of tpmm=5Fchip=5Fdev?
> >    So that the usage model of the chip is the same. We get this in the
> >    tpm-vtpm.c with tpm=5Falloc=5Fchip + tpmm=5Fchip=5Fdev while all oth=
ers can
> >    call tpmm=5Fchip=5Falloc, which combines the two.
>=20
> No need, just don't use devm in vtpm, that is even better. The
> standard devm idiom is a with and without version.

Updated the branch. Are you going to upstream your patch? Otherwise I=20
would just add your Signed-off-by to it if that's ok ?

https://github.com/stefanberger/linux/tree/vtpm-driver.v3

>=20
> >    > Just have the vtpm driver do device=5Finitialize, then tpm=5Falloc=
=20
and
> >    > have the release function do put=5Fdevice on the chip. No need for=
=20
devm
> >    > at all
>=20
> >    I would also like to have a tpm=5Fchip=5Fput (static inline in tpm.h=
 ?)
> >    that wraps the put=5Fdevice. To me this is more intuitive than=20
calling
> >    put=5Fdevice() as a counter-part to tpm=5Fchip=5Falloc.
>=20
> Many in the kernel community would call this sort of wrapping
> obfuscation.. We don't have a put=5Fplatform=5Fdevice, etc for
> instance. Naked put=5Fdevice in an error path is fine.

I guess it's a matter of getting used to. I still like being 'guided' by=20
function names...

   Stefan

>=20
> Jason
>=20



--=_alternative 0015B63585257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/11/2016 06:56:11 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Thu, Feb 11, 2016 at 05:26:24PM -0500, Stefan Berger wrote=
:<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; What is the point of tpmm=5Fchip=
=5Fdev?<br>&gt; &gt; &nbsp; &nbsp;So that the usage model of the chip is th=
e same.
We get this in the<br>&gt; &gt; &nbsp; &nbsp;tpm-vtpm.c with tpm=5Falloc=5F=
chip + tpmm=5Fchip=5Fdev while
all others can<br>&gt; &gt; &nbsp; &nbsp;call tpmm=5Fchip=5Falloc, which co=
mbines the two.<br>&gt; <br>&gt; No need, just don't use devm in vtpm, that=
 is even better. The<br>&gt; standard devm idiom is a with and without vers=
ion.</font></tt><br><br><tt><font size=3D2>Updated the branch. Are you goin=
g to upstream your
patch? Otherwise I would just add your Signed-off-by to it if that's ok
?</font></tt><br><br><a href=3D"https://github.com/stefanberger/linux/tree/=
vtpm-driver.v3"><tt><font size=3D2 color=3Dblue>https://github.com/stefanbe=
rger/linux/tree/vtpm-driver.v3</font></tt></a><br><tt><font size=3D2><br>&g=
t; <br>&gt; &gt; &nbsp; &nbsp;&gt; Just have the vtpm driver do device=5Fin=
itialize,
then tpm=5Falloc and<br>&gt; &gt; &nbsp; &nbsp;&gt; have the release functi=
on do put=5Fdevice on
the chip. No need for devm<br>&gt; &gt; &nbsp; &nbsp;&gt; at all<br>&gt; <b=
r>&gt; &gt; &nbsp; &nbsp;I would also like to have a tpm=5Fchip=5Fput (stat=
ic
inline in tpm.h ?)<br>&gt; &gt; &nbsp; &nbsp;that wraps the put=5Fdevice. T=
o me this is more intuitive
than calling<br>&gt; &gt; &nbsp; &nbsp;put=5Fdevice() as a counter-part to =
tpm=5Fchip=5Falloc.<br>&gt; <br>&gt; Many in the kernel community would cal=
l this sort of wrapping<br>&gt; obfuscation.. We don't have a put=5Fplatfor=
m=5Fdevice, etc for<br>&gt; instance. Naked put=5Fdevice in an error path i=
s fine.</font></tt><br><br><tt><font size=3D2>I guess it's a matter of gett=
ing used to. I still
like being 'guided' by function names...</font></tt><br><br><tt><font size=
=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt=
; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 0015B63585257F57_=--



--===============8735304070803288526==
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
--===============8735304070803288526==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8735304070803288526==--
