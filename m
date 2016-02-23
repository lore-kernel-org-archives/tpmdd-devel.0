From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 07/11] tpm: Replace device
 number	bitmap with IDR
Date: Mon, 22 Feb 2016 21:16:53 -0500
Message-ID: <201602230217.u1N2HIL0014602@d03av03.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com><1455885728-10315-8-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222190629.GE22088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5796075116313457432=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160222190629.GE22088-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============5796075116313457432==
Content-Type: multipart/alternative;
	boundary="=_alternative 000C90E885257F62_="


--=_alternative 000C90E885257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
02:06:29 PM:


>=20
> On Fri, Feb 19, 2016 at 07:42:04AM -0500, Stefan Berger wrote:
> > +   if (chip=5Fnum =3D=3D TPM=5FANY=5FNUM)
> > +      chip=5Fnext =3D 0;
> > +
> > +   mutex=5Flock(&idr=5Flock);
> > +
> > +   do {
> > +      if (chip=5Fnum =3D=3D TPM=5FANY=5FNUM) {
> > +         chip=5Fprev =3D chip=5Fnext;
> > +         chip =3D idr=5Fget=5Fnext(&dev=5Fnums=5Fidr, &chip=5Fnext);
> > +      } else
> > +         chip =3D idr=5Ffind=5Fslowpath(&dev=5Fnums=5Fidr, chip=5Fnum);
> > +
> > +      if (chip && !tpm=5Ftry=5Fget=5Fops(chip))
> > +         break;
> > +   } while (chip=5Fnum =3D=3D TPM=5FANY=5FNUM && chip=5Fprev !=3D chip=
=5Fnext);
>=20
> This while loop doesn't look very good if tpm=5Ftry=5Fget=5Fops fails?
>=20
> Maybe like this?
>=20
> struct tpm=5Fchip *tpm=5Fchip=5Ffind=5Fget(int chip=5Fnum)
> {
>    struct tpm=5Fchip *res =3D NULL;
>=20
>    mutex=5Flock(&idr=5Flock);
>=20
>    if (chip=5Fnum =3D=3D TPM=5FANY=5FNUM) {
>       struct tpm=5Fchip *chip;
>=20
>       chip=5Fnum =3D 0;
>       do {
>          chip =3D idr=5Fget=5Fnext(&dev=5Fnums=5Fidr, &chip=5Fnum);
>          if (res && !tpm=5Ftry=5Fget=5Fops(chip)) {
>             res =3D chip;
>             break;
>          }
>       }
>       while (chip);
>    } else {
>       res =3D idr=5Ffind=5Fslowpath(&dev=5Fnums=5Fidr, chip=5Fnum);
>       if (res && tpm=5Ftry=5Fget=5Fops(chip))
>          res =3D NULL;
>    }
>=20
>    mutex=5Funlock(&idr=5Flock);
>=20
>    return res;
> }

        mutex=5Flock(&idr=5Flock);

        if (chip=5Fnum =3D=3D TPM=5FANY=5FNUM) {
                chip=5Fnum =3D 0;
                do {
                        chip=5Fprev =3D chip=5Fnum;
                        chip =3D idr=5Fget=5Fnext(&dev=5Fnums=5Fidr, &chip=
=5Fnum);
                        if (chip && !tpm=5Ftry=5Fget=5Fops(chip)) {
                                res =3D chip;
                                break;
                        }
                } while (chip=5Fprev !=3D chip=5Fnum);
        } else {
                chip =3D idr=5Ffind=5Fslowpath(&dev=5Fnums=5Fidr, chip=5Fnu=
m);
                if (chip && !tpm=5Ftry=5Fget=5Fops(chip))
                        res =3D chip;
        }

        mutex=5Funlock(&idr=5Flock);



FYI: idr=5Fget=5Fnext will return NULL for a chip->dev=5Fnum that has nothi=
ng=20
(NULL) registered; we *may* find something after that again.

   Stefan



--=_alternative 000C90E885257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 02:06:29 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Fri, Feb 19, 2016 at 07:42:04AM -0500, Stefan Berger wrote=
:<br>&gt; &gt; + &nbsp; if (chip=5Fnum =3D=3D TPM=5FANY=5FNUM)<br>&gt; &gt;=
 + &nbsp; &nbsp; &nbsp;chip=5Fnext =3D 0;<br>&gt; &gt; +<br>&gt; &gt; + &nb=
sp; mutex=5Flock(&amp;idr=5Flock);<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; do =
{<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;if (chip=5Fnum =3D=3D TPM=5FANY=5FNUM)=
 {<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; chip=5Fprev =3D chip=5Fnext;<=
br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; chip =3D idr=5Fget=5Fnext(&amp;d=
ev=5Fnums=5Fidr,
&amp;chip=5Fnext);<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;} else<br>&gt; &gt; +=
 &nbsp; &nbsp; &nbsp; &nbsp; chip =3D idr=5Ffind=5Fslowpath(&amp;dev=5Fnums=
=5Fidr,
chip=5Fnum);<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;if (chip &am=
p;&amp; !tpm=5Ftry=5Fget=5Fops(chip))<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &=
nbsp; break;<br>&gt; &gt; + &nbsp; } while (chip=5Fnum =3D=3D TPM=5FANY=5FN=
UM &amp;&amp; chip=5Fprev
!=3D chip=5Fnext);<br>&gt; <br>&gt; This while loop doesn't look very good =
if tpm=5Ftry=5Fget=5Fops fails?<br>&gt; <br>&gt; Maybe like this?<br>&gt; <=
br>&gt; struct tpm=5Fchip *tpm=5Fchip=5Ffind=5Fget(int chip=5Fnum)<br>&gt; =
{<br>&gt; &nbsp; &nbsp;struct tpm=5Fchip *res =3D NULL;<br>&gt; <br>&gt; &n=
bsp; &nbsp;mutex=5Flock(&amp;idr=5Flock);<br>&gt; <br>&gt; &nbsp; &nbsp;if =
(chip=5Fnum =3D=3D TPM=5FANY=5FNUM) {<br>&gt; &nbsp; &nbsp; &nbsp; struct t=
pm=5Fchip *chip;<br>&gt; <br>&gt; &nbsp; &nbsp; &nbsp; chip=5Fnum =3D 0;<br=
>&gt; &nbsp; &nbsp; &nbsp; do {<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;c=
hip =3D idr=5Fget=5Fnext(&amp;dev=5Fnums=5Fidr,
&amp;chip=5Fnum);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (res &amp;&a=
mp; !tpm=5Ftry=5Fget=5Fops(chip))
{<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; res =3D chip;<br>&gt; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; break;<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;}<br>&gt; &nbsp; &nbsp; &nbsp; }<br>&gt; &nbsp; &nbsp; &nbsp=
; while (chip);<br>&gt; &nbsp; &nbsp;} else {<br>&gt; &nbsp; &nbsp; &nbsp; =
res =3D idr=5Ffind=5Fslowpath(&amp;dev=5Fnums=5Fidr, chip=5Fnum);<br>&gt; &=
nbsp; &nbsp; &nbsp; if (res &amp;&amp; tpm=5Ftry=5Fget=5Fops(chip))<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;res =3D NULL;<br>&gt; &nbsp; &nbsp;}<br>=
&gt; <br>&gt; &nbsp; &nbsp;mutex=5Funlock(&amp;idr=5Flock);<br>&gt; <br>&gt=
; &nbsp; &nbsp;return res;<br>&gt; }</font></tt><br><br><font size=3D4 face=
=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &nbsp; mutex=5Flock(&amp;idr=5Floc=
k);</font><br><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbs=
p; &nbsp; <b>if</b>(chip=5Fnum =3D=3D TPM=5FANY=5FNUM) </font><font size=3D=
4 color=3D#a1009f face=3D"Lucida Console">{</font><br><font size=3D4 face=
=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; chip=5Fnum =3D </font><font size=3D4 color=3D#00c1c2 f=
ace=3D"Lucida Console">0</font><font size=3D4 face=3D"Lucida Console">;</fo=
nt><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp;
&nbsp; &nbsp; &nbsp; <b>do</b> </font><font size=3D4 color=3D#a1009f face=
=3D"Lucida Console">{</font><br><font size=3D4 face=3D"Lucida Console">&nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; chip=5Fprev =3D chip=5Fnum=
;</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; chip =3D idr=5Fget=5Fnext(=
&amp;dev=5Fnums=5Fidr,
&amp;chip=5Fnum);</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b>if</b> (chip &amp;&amp;
!tpm=5Ftry=5Fget=5Fops(chip)) </font><font size=3D4 color=3D#a1009f face=3D=
"Lucida Console">{</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
res =3D chip;</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
<b>break</b>;</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </font><font size=3D4 colo=
r=3D#a1009f face=3D"Lucida Console">}</font><br><font size=3D4 face=3D"Luci=
da Console">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; </font><font size=3D4 color=3D#a1009f face=3D"Lucida C=
onsole">}</font><font size=3D4 face=3D"Lucida Console"><b>while</b> (chip=
=5Fprev !=3D chip=5Fnum);</font><br><font size=3D4 face=3D"Lucida Console">=
&nbsp; &nbsp; &nbsp; &nbsp; </font><font size=3D4 color=3D#a1009f face=3D"L=
ucida Console">}</font><font size=3D4 face=3D"Lucida Console"><b>else</b> <=
/font><font size=3D4 color=3D#a1009f face=3D"Lucida Console">{</font><br><f=
ont size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; chip =3D idr=5Ffind=5Fslowpath(&amp;dev=5Fnums=5Fidr, =
chip=5Fnum);</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; <b>if</b> (chip &amp;&amp; !tpm=5Ftry=5Fget=5Fops(chip=
))</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; res =3D chip;</font><br><f=
ont size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &nbsp; </font><fo=
nt size=3D4 color=3D#a1009f face=3D"Lucida Console">}</font><br><br><font s=
ize=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbsp; &nbsp; mutex=5Funlock(=
&amp;idr=5Flock);</font><br><br><br><br><tt><font size=3D2>FYI: idr=5Fget=
=5Fnext will return NULL for a chip-&gt;dev=5Fnum
that has nothing (NULL) registered; we *may* find something after that
again.<br></font></tt><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt=
><br><BR>
--=_alternative 000C90E885257F62_=--



--===============5796075116313457432==
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
--===============5796075116313457432==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============5796075116313457432==--
