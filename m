From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 07/11] tpm: Replace device
 number	bitmap with IDR
Date: Mon, 22 Feb 2016 20:15:38 -0500
Message-ID: <201602230116.u1N1G6RT013568@d03av05.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com><1455885728-10315-8-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222190629.GE22088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4718320904641190464=="
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


--===============4718320904641190464==
Content-Type: multipart/alternative;
	boundary="=_alternative 0006F57285257F62_="


--=_alternative 0006F57285257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
02:06:29 PM:

> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Date: 02/22/2016 02:06 PM
> Subject: Re: [tpmdd-devel] [PATCH v3 07/11] tpm: Replace device=20
> number bitmap with IDR
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
>=20
> > +   if (err < 0) {
> >        dev=5Ferr(dev, "No available tpm device numbers\n");
>=20
> I would drop the dev=5Ferr too
>=20
> > @@ -247,12 +253,6 @@ static int tpm=5Fdev=5Fadd=5Fdevice(struct tpm=5Fc=
hip=20
*chip)
> >  static void tpm=5Fdev=5Fdel=5Fdevice(struct tpm=5Fchip *chip)
> >  {
> >     cdev=5Fdel(&chip->cdev);
> > -
> > -   /* Make the driver uncallable. */
> > -   down=5Fwrite(&chip->ops=5Fsem);
> > -   chip->ops =3D NULL;
> > -   up=5Fwrite(&chip->ops=5Fsem);
> > -
> >     device=5Fdel(&chip->dev);
>=20
> Hum.. The ordering here is very important, I guess I got it slightly
> wrong as well in my patch adding ops.
>=20
> Lets go for this:
>=20
> - Tear down /dev/tpmX, sysfs and all other user accessible entry
>   points
> - Do device=5Fdel (get rid of all the sysfs stuff)
> - NULL the IDR (disables kAPI access and allow reuse of the ID)
> - NULL the ops (flush in-progress access now that new access is=20
impossible)

Why NULL the ops so late and allow access even after device=5Fdel? I'd do=20
that at the beginning.

Also the IDR has a two-stages:
 one making the chip inaccessible on the idr : idr=5Freplace(&dev=5Fnums=5F=
idr,=20
NULL, chip->dev=5Fnum)
 the other one by freeing the IDR for re-use : idr=5Fremove(&dev=5Fnums=5Fi=
r,=20
chip->dev=5Fnum)

> - put=5Fdevice to kfree (via devm)


My propsal:

- Tear down /dev/tpmX
- NULL the IDR (disable kAPI access since chip cannot be found anymore)
- NULL the ops (flush in-progress access now that new access is=20
impossible)
- Tear down sysfs and all other user accessible entry points
- put=5Fdevice
- Free the chip's device number from the IDR (makes IDR re-usable; must=20
happen after /dev/tpmX is released to avoid clashes

   Stefan

>=20
> Jason
>=20
>=20
---------------------------------------------------------------------------=
---
> Site24x7 APM Insight: Get Deep Visibility into Application Performance
> APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
> Monitor end-to-end web transactions and take corrective actions now
> Troubleshoot faster and improve end-user experience. Signup Now!
> http://pubads.g.doubleclick.net/gampad/clk?id=3D272487151&iu=3D/4140
> =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>=20



--=_alternative 0006F57285257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 02:06:29 PM:<br><br>&gt; From: Jason Gunthorpe &lt;jgun=
thorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;</font></tt><br><tt><font size=3D2>&gt; To: =
Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;</font></tt><br><tt><font s=
ize=3D2>&gt; Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org</font></tt><br><tt><font=
 size=3D2>&gt; Date: 02/22/2016 02:06 PM</font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] [PATCH v3 07/11] tpm:
Replace device <br>&gt; number bitmap with IDR</font></tt><br><tt><font siz=
e=3D2>&gt; <br>&gt; On Fri, Feb 19, 2016 at 07:42:04AM -0500, Stefan Berger=
 wrote:<br>&gt; &gt; + &nbsp; if (chip=5Fnum =3D=3D TPM=5FANY=5FNUM)<br>&gt=
; &gt; + &nbsp; &nbsp; &nbsp;chip=5Fnext =3D 0;<br>&gt; &gt; +<br>&gt; &gt;=
 + &nbsp; mutex=5Flock(&amp;idr=5Flock);<br>&gt; &gt; +<br>&gt; &gt; + &nbs=
p; do {<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;if (chip=5Fnum =3D=3D TPM=5FANY=
=5FNUM) {<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; chip=5Fprev =3D chip=
=5Fnext;<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; chip =3D idr=5Fget=5Fne=
xt(&amp;dev=5Fnums=5Fidr,
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
; &nbsp; &nbsp;return res;<br>&gt; }<br>&gt; <br>&gt; &gt; + &nbsp; if (err=
 &lt; 0) {<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp;dev=5Ferr(dev, &quot;No =
available tpm
device numbers\n&quot;);<br>&gt; <br>&gt; I would drop the dev=5Ferr too<br=
>&gt; <br>&gt; &gt; @@ -247,12 +253,6 @@ static int tpm=5Fdev=5Fadd=5Fdevic=
e(struct tpm=5Fchip
*chip)<br>&gt; &gt; &nbsp;static void tpm=5Fdev=5Fdel=5Fdevice(struct tpm=
=5Fchip *chip)<br>&gt; &gt; &nbsp;{<br>&gt; &gt; &nbsp; &nbsp; cdev=5Fdel(&=
amp;chip-&gt;cdev);<br>&gt; &gt; -<br>&gt; &gt; - &nbsp; /* Make the driver=
 uncallable. */<br>&gt; &gt; - &nbsp; down=5Fwrite(&amp;chip-&gt;ops=5Fsem)=
;<br>&gt; &gt; - &nbsp; chip-&gt;ops =3D NULL;<br>&gt; &gt; - &nbsp; up=5Fw=
rite(&amp;chip-&gt;ops=5Fsem);<br>&gt; &gt; -<br>&gt; &gt; &nbsp; &nbsp; de=
vice=5Fdel(&amp;chip-&gt;dev);<br>&gt; <br>&gt; Hum.. The ordering here is =
very important, I guess I got it slightly<br>&gt; wrong as well in my patch=
 adding ops.<br>&gt; <br>&gt; Lets go for this:<br>&gt; <br>&gt; - Tear dow=
n /dev/tpmX, sysfs and all other user accessible entry<br>&gt; &nbsp; point=
s<br>&gt; - Do device=5Fdel (get rid of all the sysfs stuff)<br>&gt; - NULL=
 the IDR (disables kAPI access and allow reuse of the ID)</font></tt><br><t=
t><font size=3D2>&gt; - NULL the ops (flush in-progress access now
that new access is impossible)</font></tt><br><br><tt><font size=3D2>Why NU=
LL the ops so late and allow access even after
device=5Fdel? I'd do that at the beginning.</font></tt><br><br><tt><font si=
ze=3D2>Also the IDR has a two-stages:</font></tt><br><tt><font size=3D2>&nb=
sp;one making the chip inaccessible on the idr
: idr=5Freplace(&amp;dev=5Fnums=5Fidr, NULL, chip-&gt;dev=5Fnum)</font></tt=
><br><tt><font size=3D2>&nbsp;the other one by freeing the IDR for re-use
: idr=5Fremove(&amp;dev=5Fnums=5Fir, chip-&gt;dev=5Fnum)</font></tt><br><br=
><tt><font size=3D2>&gt; - put=5Fdevice to kfree (via devm)</font></tt><br>=
<br><br><tt><font size=3D2>My propsal:</font></tt><br><br><tt><font size=3D=
2>- Tear down /dev/tpmX</font></tt><br><tt><font size=3D2>- NULL the IDR (d=
isable kAPI access since chip cannot
be found anymore)</font></tt><br><tt><font size=3D2>- NULL the ops (flush i=
n-progress access now that
new access is impossible)</font></tt><br><tt><font size=3D2>- Tear down sys=
fs and all other user accessible entry
points</font></tt><br><tt><font size=3D2>- put=5Fdevice</font></tt><br><tt>=
<font size=3D2>- Free the chip's device number from the IDR (makes
IDR re-usable; must happen after /dev/tpmX is released to avoid clashes</fo=
nt></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt><=
font size=3D2><br>&gt; <br>&gt; Jason<br>&gt; <br>&gt; --------------------=
----------------------------------------------------------<br>&gt; Site24x7=
 APM Insight: Get Deep Visibility into Application Performance<br>&gt; APM =
+ Mobile APM + RUM: Monitor 3 App instances at just $35/Month<br>&gt; Monit=
or end-to-end web transactions and take corrective actions now<br>&gt; Trou=
bleshoot faster and improve end-user experience. Signup Now!<br>&gt; </font=
></tt><a href=3D"http://pubads.g.doubleclick.net/gampad/clk?id=3D272487151&=
amp;iu=3D/4140"><tt><font size=3D2>http://pubads.g.doubleclick.net/gampad/c=
lk?id=3D272487151&amp;iu=3D/4140</font></tt></a><tt><font size=3D2><br>&gt;=
 =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F<br>&g=
t; tpmdd-devel mailing list<br>&gt; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>&g=
t; </font></tt><a href=3D"https://lists.sourceforge.net/lists/listinfo/tpmd=
d-devel"><tt><font size=3D2>https://lists.sourceforge.net/lists/listinfo/tp=
mdd-devel</font></tt></a><tt><font size=3D2><br>&gt; <br></font></tt><BR>
--=_alternative 0006F57285257F62_=--



--===============4718320904641190464==
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
--===============4718320904641190464==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4718320904641190464==--
