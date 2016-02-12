From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 18:14:42 -0500
Message-ID: <201602122314.u1CNEjZV000390@d03av04.boulder.ibm.com>
References: <20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120353.u1C3rYif023135@d01av05.pok.ibm.com>
	<20160212184051.GB4289@obsidianresearch.com>
	<201602122031.u1CKVIOp028400@d03av03.boulder.ibm.com>
	<20160212203956.GB10540@obsidianresearch.com>
	<201602122044.u1CKiMbR023495@d03av03.boulder.ibm.com>
	<20160212211538.GA20737@obsidianresearch.com>
	<201602122223.u1CMNKL2004615@d03av02.boulder.ibm.com>
	<20160212224642.GA4781@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2923068860289015357=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160212224642.GA4781-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============2923068860289015357==
Content-Type: multipart/alternative;
	boundary="=_alternative 007FB90485257F57_="


--=_alternative 007FB90485257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/12/2016=20
05:46:42 PM:

>=20
> On Fri, Feb 12, 2016 at 05:23:16PM -0500, Stefan Berger wrote:
>=20
> >    > I don't see how that can happen. Looking at the tpm cdev, it is
>=20
> >    Well, following my tests, it does happen.
>=20
> How are you testing for use-after-free bugs? Did you test the kapi
> interface? Did you get it in *exactly* the right configuration to
> cause this?

I think there are two cases that matter for the final unwind:

1) server side closes last
2) client side closes last

Any other cases?

Here's what happens in these cases:

1) we unwind with vtpm=5Fdelete=5Fdevice=5Fpair + vtpm=5Fdelete=5Fvtpm=5Fde=
v [see=20
below]. The chip an vtpm=5Fdev are freed, in that order by just these=20
functions.

2) we unwind in tpm=5Frelease and the following kicks it off:

http://lxr.free-electrons.com/source/drivers/char/tpm/tpm-dev.c#L169

169         put=5Fdevice(priv->chip->pdev);
170         kfree(priv);
171         return 0;
172 }
173=20

The above put=5Fdevice (in the front-end) releases vtpm=5Fdev first and the=
n=20
after tpm=5Frelease finishes the chip is released (following the cdev's=20
end).=20

Once tpm=5Frelease happened, we closed the file descriptor and there's no=20
more code doing other business in either the front or backend drivers=20
other than unwinding.

   Stefan

>=20
> >    > So, we have a situation where tpm=5Funregister can return, release=
=20
the
> >    > kref on the vtpm and still have outstanding users, which will=20
result
> >    > in a use after-free.
>=20
> >    Maybe you should give it a try ... I don't see these problems and=20
any
> >    change seems like ill-fixing it. What will be accessed after
> >    tpm=5Funregister? The only case we have tpm=5Funregister is here:
>=20
> >    static void vtpm=5Fdelete=5Fdevice=5Fpair(structvtpm=5Fdev *vtpm=5Fd=
ev)
> >    {
> >            tpm=5Fchip=5Funregister(vtpm=5Fdev->chip);
> >            vtpm=5Ffops=5Fundo=5Fopen(vtpm=5Fdev);
> >            vtpm=5Fdelete=5Fvtpm=5Fdev(vtpm=5Fdev);
> >    }
>=20
> >    followed by:
>=20
> >    static inline voidvtpm=5Fdelete=5Fvtpm=5Fdev(struct vtpm=5Fdev *vtpm=
=5Fdev)
> >    {
> >            put=5Fdevice(&vtpm=5Fdev->chip->dev); /* frees chip */
> >            device=5Funregister(&vtpm=5Fdev->dev); /* does put=5Fdevice =
*/
> >    }
>=20
> >    I don't see a problem with that.
>=20
> device=5Funregister will put=5Fdevice(vtpmt=5Fdev) which will kfree it si=
nce
> no refs are left.
>=20
> tpm=5Fchip is still alive because the cdev/kapi are still holding a ref
> on it.
>=20
> The cdev/kapi can still call vtpm=5Ftpm=5Fop=5Fsend which will then deref
> chip->priv which is the free'd vtpm=5Fdev.
>=20
> Any attempt to test for this scenario is very likely to hit the
> STATE=5FOPENED=5FBIT test and exit without crashing. However that is just
> a user-after free getting lucky. Testing is not a substitute for
> proper analysis.
>=20
> Show me an analysis of what in cdev/kapi is holding the kref on
> vtpm=5Fdev if you still think this can't happen.
>=20
> As I said, the only kref the tpm core takes on vtpm=5Fdev is dropped
> by tpm=5Fchip=5Funregister.
>=20
> Jason
>=20



--=_alternative 007FB90485257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/12/2016 05:46:42 PM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Fri, Feb 12, 2016 at 05:23:16PM -0500, Stefan Berger wrote:<br=
>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; I don't see how that can happen. Look=
ing at
the tpm cdev, it is<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;Well, following my t=
ests, it does happen.<br>&gt; <br>&gt; How are you testing for use-after-fr=
ee bugs? Did you test the kapi<br>&gt; interface? Did you get it in *exactl=
y* the right configuration to<br>&gt; cause this?</font></tt><br><br><tt><f=
ont size=3D2>I think there are two cases that matter for the final
unwind:</font></tt><br><br><tt><font size=3D2>1) server side closes last</f=
ont></tt><br><tt><font size=3D2>2) client side closes last</font></tt><br><=
br><tt><font size=3D2>Any other cases?</font></tt><br><br><tt><font size=3D=
2>Here's what happens in these cases:</font></tt><br><br><tt><font size=3D2=
>1) we unwind with vtpm=5Fdelete=5Fdevice=5Fpair + vtpm=5Fdelete=5Fvtpm=5Fd=
ev
[see below]. The chip an vtpm=5Fdev are freed, in that order by just these
functions.</font></tt><br><br><tt><font size=3D2>2) we unwind in tpm=5Frele=
ase and the following kicks
it off:</font></tt><br><br><a href=3D"http://lxr.free-electrons.com/source/=
drivers/char/tpm/tpm-dev.c#L169"><tt><font size=3D2 color=3Dblue>http://lxr=
.free-electrons.com/source/drivers/char/tpm/tpm-dev.c#L169</font></tt></a><=
br><br><a href=3D"http://lxr.free-electrons.com/source/drivers/char/tpm/tpm=
-dev.c#L169"><tt><font size=3D3 color=3Dblue><u>169</u></font></tt></a><tt>=
<font size=3D3>&nbsp; &nbsp; &nbsp; &nbsp; </font></tt><a href=3D"http://lx=
r.free-electrons.com/ident?i=3Dput=5Fdevice#L169"><tt><font size=3D3 color=
=3Dblue><u>put=5Fdevice</u></font></tt></a><tt><font size=3D3>(</font></tt>=
<a href=3D"http://lxr.free-electrons.com/ident?i=3Dpriv#L169"><tt><font siz=
e=3D3 color=3Dblue><u>priv</u></font></tt></a><tt><font size=3D3>-&gt;</fon=
t></tt><a href=3D"http://lxr.free-electrons.com/ident?i=3Dchip#L169"><tt><f=
ont size=3D3 color=3Dblue><u>chip</u></font></tt></a><tt><font size=3D3>-&g=
t;</font></tt><a href=3D"http://lxr.free-electrons.com/ident?i=3Dpdev#L169"=
><tt><font size=3D3 color=3Dblue><u>pdev</u></font></tt></a><tt><font size=
=3D3>);<br></font></tt><a href=3D"http://lxr.free-electrons.com/source/driv=
ers/char/tpm/tpm-dev.c#L170"><tt><font size=3D3 color=3Dblue><u>170</u></fo=
nt></tt></a><tt><font size=3D3>&nbsp; &nbsp; &nbsp; &nbsp; </font></tt><a h=
ref=3D"http://lxr.free-electrons.com/ident?i=3Dkfree#L169"><tt><font size=
=3D3 color=3Dblue><u>kfree</u></font></tt></a><tt><font size=3D3>(</font></=
tt><a href=3D"http://lxr.free-electrons.com/ident?i=3Dpriv#L169"><tt><font =
size=3D3 color=3Dblue><u>priv</u></font></tt></a><tt><font size=3D3>);<br><=
/font></tt><a href=3D"http://lxr.free-electrons.com/source/drivers/char/tpm=
/tpm-dev.c#L171"><tt><font size=3D3 color=3Dblue><u>171</u></font></tt></a>=
<tt><font size=3D3>&nbsp; &nbsp; &nbsp; &nbsp; return 0;<br></font></tt><a =
href=3D"http://lxr.free-electrons.com/source/drivers/char/tpm/tpm-dev.c#L17=
2"><tt><font size=3D3 color=3Dblue><u>172</u></font></tt></a><tt><font size=
=3D3>}<br></font></tt><a href=3D"http://lxr.free-electrons.com/source/drive=
rs/char/tpm/tpm-dev.c#L173"><tt><font size=3D3 color=3Dblue><u>173</u></fon=
t></tt></a><tt><font size=3D3></font></tt><br><br><tt><font size=3D2>The ab=
ove put=5Fdevice (in the front-end) releases vtpm=5Fdev
first and then after tpm=5Frelease finishes the chip is released (following
the cdev's end). </font></tt><br><br><tt><font size=3D2>Once tpm=5Frelease =
happened, we closed the file descriptor
and there's no more code doing other business in either the front or backend
drivers other than unwinding.</font></tt><br><br><tt><font size=3D2>&nbsp; =
&nbsp;Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; &gt; &nbsp=
; &nbsp;&gt; So, we have a situation where tpm=5Funregister
can return, release the<br>&gt; &gt; &nbsp; &nbsp;&gt; kref on the vtpm and=
 still have outstanding
users, which will result<br>&gt; &gt; &nbsp; &nbsp;&gt; in a use after-free=
.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;Maybe you should give it a try ... I d=
on't see these
problems and any<br>&gt; &gt; &nbsp; &nbsp;change seems like ill-fixing it.=
 What will be accessed
after<br>&gt; &gt; &nbsp; &nbsp;tpm=5Funregister? The only case we have tpm=
=5Funregister
is here:<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;static void vtpm=5Fdelete=5Fdev=
ice=5Fpair(structvtpm=5Fdev
*vtpm=5Fdev)<br>&gt; &gt; &nbsp; &nbsp;{<br>&gt; &gt; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;tpm=5Fchip=5Funregister(vtpm=5Fdev-&gt;chip);<br>&gt; &=
gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;vtpm=5Ffops=5Fundo=5Fopen(vtpm=
=5Fdev);<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;vtpm=5Fdelet=
e=5Fvtpm=5Fdev(vtpm=5Fdev);<br>&gt; &gt; &nbsp; &nbsp;}<br>&gt; <br>&gt; &g=
t; &nbsp; &nbsp;followed by:<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;static inli=
ne voidvtpm=5Fdelete=5Fvtpm=5Fdev(struct vtpm=5Fdev
*vtpm=5Fdev)<br>&gt; &gt; &nbsp; &nbsp;{<br>&gt; &gt; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;put=5Fdevice(&amp;vtpm=5Fdev-&gt;chip-&gt;dev);
/* frees chip */<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;devi=
ce=5Funregister(&amp;vtpm=5Fdev-&gt;dev);
/* does put=5Fdevice */<br>&gt; &gt; &nbsp; &nbsp;}<br>&gt; <br>&gt; &gt; &=
nbsp; &nbsp;I don't see a problem with that.<br>&gt; <br>&gt; device=5Funre=
gister will put=5Fdevice(vtpmt=5Fdev) which will kfree it since<br>&gt; no =
refs are left.<br>&gt; <br>&gt; tpm=5Fchip is still alive because the cdev/=
kapi are still holding a
ref<br>&gt; on it.<br>&gt; <br>&gt; The cdev/kapi can still call vtpm=5Ftpm=
=5Fop=5Fsend which will then deref<br>&gt; chip-&gt;priv which is the free'=
d vtpm=5Fdev.<br>&gt; <br>&gt; Any attempt to test for this scenario is ver=
y likely to hit the<br>&gt; STATE=5FOPENED=5FBIT test and exit without cras=
hing. However that is just<br>&gt; a user-after free getting lucky. Testing=
 is not a substitute for<br>&gt; proper analysis.<br>&gt; <br>&gt; Show me =
an analysis of what in cdev/kapi is holding the kref on<br>&gt; vtpm=5Fdev =
if you still think this can't happen.<br>&gt; <br>&gt; As I said, the only =
kref the tpm core takes on vtpm=5Fdev is dropped<br>&gt; by tpm=5Fchip=5Fun=
register.<br>&gt; <br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 007FB90485257F57_=--



--===============2923068860289015357==
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
--===============2923068860289015357==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2923068860289015357==--
