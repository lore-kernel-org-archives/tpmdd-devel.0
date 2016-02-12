From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 17:23:16 -0500
Message-ID: <201602122223.u1CMNJXl023711@d01av01.pok.ibm.com>
References: <20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120353.u1C3rYif023135@d01av05.pok.ibm.com>
	<20160212184051.GB4289@obsidianresearch.com>
	<201602122031.u1CKVIOp028400@d03av03.boulder.ibm.com>
	<20160212203956.GB10540@obsidianresearch.com>
	<201602122044.u1CKiMbR023495@d03av03.boulder.ibm.com>
	<20160212211538.GA20737@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1446629851525014608=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160212211538.GA20737-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============1446629851525014608==
Content-Type: multipart/alternative;
	boundary="=_alternative 007B036985257F57_="


--=_alternative 007B036985257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/12/2016=20
04:15:38 PM:

> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> To: Stefan Berger/Watson/IBM@IBMUS
> Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Jarkko Sakkinen=20
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Date: 02/12/2016 04:15 PM
> Subject: Re: [tpmdd-devel] [PATCH v5 4/5] Initialize TPM and get=20
> durations and timeouts
>=20
> On Fri, Feb 12, 2016 at 03:44:14PM -0500, Stefan Berger wrote:
> >    What I observed is that both tpm=5Fchip and vtpm=5Fdev structures ar=
e=20
freed
> >    once the last one of two sides (/dev/tpmX or server side file
> >    descriptor) closes.
>=20
> Hmmm...
>=20
> I don't see how that can happen. Looking at the tpm cdev, it is

Well, following my tests, it does happen.

> continues to exist even after tpm=5Funregister returns (cdev=5Fdel does
> not force close existing opens). Certainly the kAPI (ie
> tpm=5Fchip=5Ffind=5Fget) will continue to use the chip without blocking
> tpm=5Funregister.
>=20
> I see no mechanism for the cdev/kAPI to continue to hold a kref on the
> vtpm struct.
>=20
> The obvious one would be because the vtpm struct is a parent of the
> chip, but that kref is let go during device=5Fdel.
>=20
> So, we have a situation where tpm=5Funregister can return, release the
> kref on the vtpm and still have outstanding users, which will result
> in a use after-free.

Maybe you should give it a try ... I don't see these problems and any=20
change seems like ill-fixing it. What will be accessed after=20
tpm=5Funregister? The only case we have tpm=5Funregister is here:

static void vtpm=5Fdelete=5Fdevice=5Fpair(struct vtpm=5Fdev *vtpm=5Fdev)
{
        tpm=5Fchip=5Funregister(vtpm=5Fdev->chip);

        vtpm=5Ffops=5Fundo=5Fopen(vtpm=5Fdev);

        vtpm=5Fdelete=5Fvtpm=5Fdev(vtpm=5Fdev);
}

followed by:

static inline void vtpm=5Fdelete=5Fvtpm=5Fdev(struct vtpm=5Fdev *vtpm=5Fdev)
{
        put=5Fdevice(&vtpm=5Fdev->chip->dev); /* frees chip */
        device=5Funregister(&vtpm=5Fdev->dev); /* does put=5Fdevice */
}

I don't see a problem with that.

>=20
> [BTW, your lastest vtpm on github still has a problem with error
>  unwind. Move the put=5Fdevice(&vtpm=5Fdev->chip->dev);  from
>  vtpm=5Fdelete=5Fvtpm=5Fdev() and put it in vtpm=5Fdev=5Frelease() with a=
 NULL
>  test.

I tested all the error paths. The vtpm=5Fdelete=5Fvtpm=5Fdev is the counter=
-part=20
to vtpm=5Fcreate=5Fvtpm=5Fdev and only ever gets called if vtpm=5Fcreate=5F=
vtpm=5Fdev=20
ran successfully and is the function to call to unwind=20
vtpm=5Fcreate=5Fvtpm=5Fdev. So if we unwind there in reverse order then we =

should be ok. If not, why not ?

>=20
>  The put=5Fdevice is missing after the tpm=5Fchip=5Funregister call, the
>  above is the safest way to fix it.

No, it's the vtpm=5Fdelete=5Fvtpm=5Fdev function that unwinds it. I tested =
this=20
and structures get freed properly.

>=20
>  This is why you shouldn't wrapper put=5Fdevice, anything but naked
>  put=5Fdevice is probably wrong]
>=20
> [Also, err=5Fkfree should not exist in vtpm=5Fcreate=5Fvtpm=5Fdev, always
>  put=5Fdevice after device=5Finitialize returns, the comment near the=20
device=5Fadd
>  is wrong, it is using the get=5Fdevice done implicitly by
>  device=5Finitialize]

Fixed.
>=20
> [Don't forget to error check dev=5Fset=5Fname]

Fixed. Looks like 80% of the drivers don't check here.

   Stefan
>=20
> Jason
>=20



--=_alternative 007B036985257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/12/2016 04:15:38 PM:<br><br>&gt; From: Jason Gunthorpe &lt;jgun=
thorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;</font></tt><br><tt><font size=3D2>&gt; To: =
Stefan Berger/Watson/IBM@IBMUS</font></tt><br><tt><font size=3D2>&gt; Cc: d=
howells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
Jarkko Sakkinen <br>&gt; &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;, tpmdd-dev=
el-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org</font></tt><br><tt><font size=3D2>&gt; Date: 02/12=
/2016 04:15 PM</font></tt><br><tt><font size=3D2>&gt; Subject: Re: [tpmdd-d=
evel] [PATCH v5 4/5] Initialize
TPM and get <br>&gt; durations and timeouts</font></tt><br><tt><font size=
=3D2>&gt; <br>&gt; On Fri, Feb 12, 2016 at 03:44:14PM -0500, Stefan Berger =
wrote:<br>&gt; &gt; &nbsp; &nbsp;What I observed is that both tpm=5Fchip an=
d vtpm=5Fdev
structures are freed<br>&gt; &gt; &nbsp; &nbsp;once the last one of two sid=
es (/dev/tpmX or server
side file<br>&gt; &gt; &nbsp; &nbsp;descriptor) closes.<br>&gt; <br>&gt; Hm=
mm...<br>&gt; <br>&gt; I don't see how that can happen. Looking at the tpm =
cdev, it is</font></tt><br><br><tt><font size=3D2>Well, following my tests,=
 it does happen.</font></tt><br><tt><font size=3D2><br>&gt; continues to ex=
ist even after tpm=5Funregister returns (cdev=5Fdel does<br>&gt; not force =
close existing opens). Certainly the kAPI (ie<br>&gt; tpm=5Fchip=5Ffind=5Fg=
et) will continue to use the chip without blocking<br>&gt; tpm=5Funregister=
.<br>&gt; <br>&gt; I see no mechanism for the cdev/kAPI to continue to hold=
 a kref on
the<br>&gt; vtpm struct.<br>&gt; <br>&gt; The obvious one would be because =
the vtpm struct is a parent of the<br>&gt; chip, but that kref is let go du=
ring device=5Fdel.<br>&gt; <br>&gt; So, we have a situation where tpm=5Funr=
egister can return, release the<br>&gt; kref on the vtpm and still have out=
standing users, which will result<br>&gt; in a use after-free.</font></tt><=
br><br><tt><font size=3D2>Maybe you should give it a try ... I don't see th=
ese
problems and any change seems like ill-fixing it. What will be accessed
after tpm=5Funregister? The only case we have tpm=5Funregister is here:</fo=
nt></tt><br><br><font size=3D4 face=3D"Lucida Console"><b>static</b> <b>voi=
d</b> vtpm=5Fdelete=5Fdevice=5Fpair(<b>struct</b>vtpm=5Fdev *vtpm=5Fdev)</f=
ont><br><font size=3D4 color=3D#a1009f face=3D"Lucida Console">{</font><br>=
<font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &nbsp; tpm=5Fch=
ip=5Funregister(vtpm=5Fdev-&gt;chip);</font><br><br><font size=3D4 face=3D"=
Lucida Console">&nbsp; &nbsp; &nbsp; &nbsp; vtpm=5Ffops=5Fundo=5Fopen(vtpm=
=5Fdev);</font><br><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp;=
 &nbsp; &nbsp; vtpm=5Fdelete=5Fvtpm=5Fdev(vtpm=5Fdev);</font><br><font size=
=3D4 color=3D#a1009f face=3D"Lucida Console">}</font><br><br><tt><font size=
=3D2>followed by:</font></tt><br><br><font size=3D4 face=3D"Lucida Console"=
><b>static</b> <b>inline</b> <b>void</b>vtpm=5Fdelete=5Fvtpm=5Fdev(<b>struc=
t</b> vtpm=5Fdev *vtpm=5Fdev)</font><br><font size=3D4 color=3D#a1009f face=
=3D"Lucida Console">{</font><br><font size=3D4 face=3D"Lucida Console">&nbs=
p; &nbsp; &nbsp; &nbsp; put=5Fdevice(&amp;vtpm=5Fdev-&gt;chip-&gt;dev);
</font><font size=3D4 color=3D#00c200 face=3D"Lucida Console">/* frees chip=
 */</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &=
nbsp; device=5Funregister(&amp;vtpm=5Fdev-&gt;dev);
</font><font size=3D4 color=3D#00c200 face=3D"Lucida Console">/* does put=
=5Fdevice
*/</font><br><font size=3D4 color=3D#a1009f face=3D"Lucida Console">}</font=
><br><br><tt><font size=3D2>I don't see a problem with that.</font></tt><br=
><tt><font size=3D2><br>&gt; <br>&gt; [BTW, your lastest vtpm on github sti=
ll has a problem with error<br>&gt; &nbsp;unwind. Move the put=5Fdevice(&am=
p;vtpm=5Fdev-&gt;chip-&gt;dev);
&nbsp;from<br>&gt; &nbsp;vtpm=5Fdelete=5Fvtpm=5Fdev() and put it in vtpm=5F=
dev=5Frelease() with
a NULL<br>&gt; &nbsp;test.</font></tt><br><br><tt><font size=3D2>I tested a=
ll the error paths. The vtpm=5Fdelete=5Fvtpm=5Fdev
is the counter-part to vtpm=5Fcreate=5Fvtpm=5Fdev and only ever gets called=
 if
vtpm=5Fcreate=5Fvtpm=5Fdev ran successfully and is the function to call to =
unwind
vtpm=5Fcreate=5Fvtpm=5Fdev. So if we unwind there in reverse order then we =
should
be ok. If not, why not ?</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt=
; &nbsp;The put=5Fdevice is missing after the tpm=5Fchip=5Funregister call,
the<br>&gt; &nbsp;above is the safest way to fix it.</font></tt><br><br><tt=
><font size=3D2>No, it's the vtpm=5Fdelete=5Fvtpm=5Fdev function that unwin=
ds
it. I tested this and structures get freed properly.</font></tt><br><tt><fo=
nt size=3D2><br>&gt; &nbsp;<br>&gt; &nbsp;This is why you shouldn't wrapper=
 put=5Fdevice, anything but naked<br>&gt; &nbsp;put=5Fdevice is probably wr=
ong]<br>&gt; <br>&gt; [Also, err=5Fkfree should not exist in vtpm=5Fcreate=
=5Fvtpm=5Fdev, always<br>&gt; &nbsp;put=5Fdevice after device=5Finitialize =
returns, the comment near
the device=5Fadd<br>&gt; &nbsp;is wrong, it is using the get=5Fdevice done =
implicitly by<br>&gt; &nbsp;device=5Finitialize]</font></tt><br><br><tt><fo=
nt size=3D2>Fixed.<br>&gt; <br>&gt; [Don't forget to error check dev=5Fset=
=5Fname]</font></tt><br><br><tt><font size=3D2>Fixed. Looks like 80% of the=
 drivers don't check here.</font></tt><br><br><tt><font size=3D2>&nbsp; &nb=
sp;Stefan<br>&gt; <br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 007B036985257F57_=--



--===============1446629851525014608==
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
--===============1446629851525014608==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1446629851525014608==--
