From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Thu, 11 Feb 2016 14:10:56 -0500
Message-ID: <201602111911.u1BJB2oZ001491@d03av04.boulder.ibm.com>
References: <201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
	<20160210035620.GB7161@intel.com>
	<201602100515.u1A5FpFi002736@d03av02.boulder.ibm.com>
	<20160210162809.GB20730@obsidianresearch.com>
	<201602102145.u1ALjSAs001597@d03av04.boulder.ibm.com>
	<20160210222313.GA7047@obsidianresearch.com>
	<201602110038.u1B0cuE0030670@d03av05.boulder.ibm.com>
	<20160211070426.GB9307@intel.com>
	<201602111534.u1BFYvRs019573@d01av03.pok.ibm.com>
	<20160211181208.GA6285@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5447697866429497229=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160211181208.GA6285-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============5447697866429497229==
Content-Type: multipart/alternative;
	boundary="=_alternative 006967BD85257F56_="


--=_alternative 006967BD85257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/11/2016=20
01:12:08 PM:


>=20
> On Thu, Feb 11, 2016 at 10:24:18AM -0500, Stefan Berger wrote:
> >    We need two steps here. One to let tpmm=5Fchip=5Falloc call two=20
functions
> >    tpm=5Fchip=5Falloc + tpmm=5Fchip=5Fdev (better name?), which are bot=
h going=20
to
> >    be public and called by tpm-vtpm.c, and provide tpm=5Fchip=5Ffree. L=
et=20
me
> >    do that. Then we can get rid of the bitmap for the chip->dev=5Fnum
> >    independently and use idr there.
>=20
> Make sense. Don't change the names all the drivers would have to be
> churn'd. tpm=5Fchip=5Falloc, tpmm=5Fchip=5Falloc.
>=20

That's right:

struct tpm=5Fchip *tpmm=5Fchip=5Falloc(struct device *dev,
                                 const struct tpm=5Fclass=5Fops *ops)
{
        struct tpm=5Fchip *chip;

        chip =3D tpm=5Fchip=5Falloc(ops);
        if (IS=5FERR(chip))
                return chip;

        tpmm=5Fchip=5Fdev(chip, dev);

        return chip;
}
EXPORT=5FSYMBOL=5FGPL(tpmm=5Fchip=5Falloc);


> It is probably OK just to use put=5Fdevice(&chip->dev), tpm=5Fchip=5Fput =
is
> already taken for something else. Don't call it free, it isn't free.

tpm=5Fchip=5Ffree undoes what tpm=5Fchip=5Falloc did.

/**
 * tpm=5Fchip=5Falloc() - allocate a new struct tpm=5Fchip instance
 * @dev: device to which the chip is associated
 * @ops: struct tpm=5Fclass=5Fops instance
 *
 * Allocates a new struct tpm=5Fchip instance and assigns a free
 * device number for it.
 */
struct tpm=5Fchip *tpm=5Fchip=5Falloc(const struct tpm=5Fclass=5Fops *ops)
{
        struct tpm=5Fchip *chip;

        chip =3D kzalloc(sizeof(*chip), GFP=5FKERNEL);
        if (chip =3D=3D NULL)
                return ERR=5FPTR(-ENOMEM);

        mutex=5Finit(&chip->tpm=5Fmutex);
        INIT=5FLIST=5FHEAD(&chip->list);

        chip->ops =3D ops;

        spin=5Flock(&driver=5Flock);
        chip->dev=5Fnum =3D find=5Ffirst=5Fzero=5Fbit(dev=5Fmask, TPM=5FNUM=
=5FDEVICES);
        if (chip->dev=5Fnum < TPM=5FNUM=5FDEVICES)
                set=5Fbit(chip->dev=5Fnum, dev=5Fmask);
        spin=5Funlock(&driver=5Flock);

        if (chip->dev=5Fnum >=3D TPM=5FNUM=5FDEVICES) {
                pr=5Ferr("No available tpm device numbers\n");
                kfree(chip);
                return ERR=5FPTR(-ENOMEM);
        }

        scnprintf(chip->devname, sizeof(chip->devname), "tpm%d",=20
chip->dev=5Fnum);

        return chip;
}
EXPORT=5FSYMBOL=5FGPL(tpm=5Fchip=5Falloc);

/**
 * tpm=5Fchip=5Ffree() - free tpm=5Fchip previously allocated with=20
tpm=5Fchip=5Falloc
 * @chip: the tpm=5Fchip to free
 */
void tpm=5Fchip=5Ffree(struct tpm=5Fchip *chip)
{
        spin=5Flock(&driver=5Flock);
        clear=5Fbit(chip->dev=5Fnum, dev=5Fmask);
        spin=5Funlock(&driver=5Flock);

        kfree(chip);
}
EXPORT=5FSYMBOL=5FGPL(tpm=5Fchip=5Ffree);


Good?

   Stefan

>=20
> Jason
>=20


--=_alternative 006967BD85257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/11/2016 01:12:08 PM:</font></tt><br><br><br><tt><font size=3D2>=
&gt; </font></tt><br><tt><font size=3D2>&gt; On Thu, Feb 11, 2016 at 10:24:=
18AM -0500, Stefan
Berger wrote:</font></tt><br><tt><font size=3D2>&gt; &gt; &nbsp; &nbsp;We n=
eed two steps here. One
to let tpmm=5Fchip=5Falloc call two functions</font></tt><br><tt><font size=
=3D2>&gt; &gt; &nbsp; &nbsp;tpm=5Fchip=5Falloc + tpmm=5Fchip=5Fdev
(better name?), which are both going to</font></tt><br><tt><font size=3D2>&=
gt; &gt; &nbsp; &nbsp;be public and called by tpm-vtpm.c,
and provide tpm=5Fchip=5Ffree. Let me</font></tt><br><tt><font size=3D2>&gt=
; &gt; &nbsp; &nbsp;do that. Then we can get rid
of the bitmap for the chip-&gt;dev=5Fnum</font></tt><br><tt><font size=3D2>=
&gt; &gt; &nbsp; &nbsp;independently and use idr there.</font></tt><br><tt>=
<font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; Make sense. Don=
't change the names all the drivers
would have to be</font></tt><br><tt><font size=3D2>&gt; churn'd. tpm=5Fchip=
=5Falloc, tpmm=5Fchip=5Falloc.</font></tt><br><tt><font size=3D2>&gt; </fon=
t></tt><br><br><tt><font size=3D2>That's right:</font></tt><br><br><tt><fon=
t size=3D2>struct tpm=5Fchip *tpmm=5Fchip=5Falloc(struct device *dev,</font=
></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;const struct
tpm=5Fclass=5Fops *ops)</font></tt><br><tt><font size=3D2>{</font></tt><br>=
<tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; struct tpm=5Fchip *chip;</fo=
nt></tt><br><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; chip =3D tpm=
=5Fchip=5Falloc(ops);</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp=
; &nbsp; if (IS=5FERR(chip))</font></tt><br><tt><font size=3D2>&nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
return chip;</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nb=
sp; tpmm=5Fchip=5Fdev(chip, dev);</font></tt><br><br><tt><font size=3D2>&nb=
sp; &nbsp; &nbsp; &nbsp; return chip;</font></tt><br><tt><font size=3D2>}</=
font></tt><br><tt><font size=3D2>EXPORT=5FSYMBOL=5FGPL(tpmm=5Fchip=5Falloc)=
;</font></tt><br><br><br><tt><font size=3D2>&gt; It is probably OK just to =
use put=5Fdevice(&amp;chip-&gt;dev),
tpm=5Fchip=5Fput is</font></tt><br><tt><font size=3D2>&gt; already taken fo=
r something else. Don't call
it free, it isn't free.</font></tt><br><br><tt><font size=3D2>tpm=5Fchip=5F=
free undoes what tpm=5Fchip=5Falloc did.</font></tt><br><br><tt><font size=
=3D2>/**</font></tt><br><tt><font size=3D2>&nbsp;* tpm=5Fchip=5Falloc() - a=
llocate a new struct tpm=5Fchip
instance</font></tt><br><tt><font size=3D2>&nbsp;* @dev: device to which th=
e chip is associated</font></tt><br><tt><font size=3D2>&nbsp;* @ops: struct=
 tpm=5Fclass=5Fops instance</font></tt><br><tt><font size=3D2>&nbsp;*</font=
></tt><br><tt><font size=3D2>&nbsp;* Allocates a new struct tpm=5Fchip inst=
ance and
assigns a free</font></tt><br><tt><font size=3D2>&nbsp;* device number for =
it.</font></tt><br><tt><font size=3D2>&nbsp;*/</font></tt><br><tt><font siz=
e=3D2>struct tpm=5Fchip *tpm=5Fchip=5Falloc(const struct tpm=5Fclass=5Fops
*ops)</font></tt><br><tt><font size=3D2>{</font></tt><br><tt><font size=3D2=
>&nbsp; &nbsp; &nbsp; &nbsp; struct tpm=5Fchip *chip;</font></tt><br><br><t=
t><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; chip =3D kzalloc(sizeof(*chip),
GFP=5FKERNEL);</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp=
; if (chip =3D=3D NULL)</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
return ERR=5FPTR(-ENOMEM);</font></tt><br><br><tt><font size=3D2>&nbsp; &nb=
sp; &nbsp; &nbsp; mutex=5Finit(&amp;chip-&gt;tpm=5Fmutex);</font></tt><br><=
tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; INIT=5FLIST=5FHEAD(&amp;chip-=
&gt;list);</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp=
; chip-&gt;ops =3D ops;</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;=
 &nbsp; &nbsp; spin=5Flock(&amp;driver=5Flock);</font></tt><br><tt><font si=
ze=3D2>&nbsp; &nbsp; &nbsp; &nbsp; chip-&gt;dev=5Fnum =3D find=5Ffirst=5Fze=
ro=5Fbit(dev=5Fmask,
TPM=5FNUM=5FDEVICES);</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp=
; &nbsp; if (chip-&gt;dev=5Fnum &lt;
TPM=5FNUM=5FDEVICES)</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
set=5Fbit(chip-&gt;dev=5Fnum, dev=5Fmask);</font></tt><br><tt><font size=3D=
2>&nbsp; &nbsp; &nbsp; &nbsp; spin=5Funlock(&amp;driver=5Flock);</font></tt=
><br><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; if (chip-&gt;dev=5F=
num &gt;=3D
TPM=5FNUM=5FDEVICES) {</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
pr=5Ferr(&quot;No available tpm device numbers\n&quot;);</font></tt><br><tt=
><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
kfree(chip);</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;
return ERR=5FPTR(-ENOMEM);</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; =
&nbsp; &nbsp; }</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; =
&nbsp; scnprintf(chip-&gt;devname,
sizeof(chip-&gt;devname), &quot;tpm%d&quot;, chip-&gt;dev=5Fnum);</font></t=
t><br><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; return chip;</font=
></tt><br><tt><font size=3D2>}</font></tt><br><tt><font size=3D2>EXPORT=5FS=
YMBOL=5FGPL(tpm=5Fchip=5Falloc);</font></tt><br><br><tt><font size=3D2>/**<=
/font></tt><br><tt><font size=3D2>&nbsp;* tpm=5Fchip=5Ffree() - free tpm=5F=
chip previously
allocated with tpm=5Fchip=5Falloc</font></tt><br><tt><font size=3D2>&nbsp;*=
 @chip: the tpm=5Fchip to free</font></tt><br><tt><font size=3D2>&nbsp;*/</=
font></tt><br><tt><font size=3D2>void tpm=5Fchip=5Ffree(struct tpm=5Fchip *=
chip)</font></tt><br><tt><font size=3D2>{</font></tt><br><tt><font size=3D2=
>&nbsp; &nbsp; &nbsp; &nbsp; spin=5Flock(&amp;driver=5Flock);</font></tt><b=
r><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; clear=5Fbit(chip-&gt;dev=
=5Fnum,
dev=5Fmask);</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; =
spin=5Funlock(&amp;driver=5Flock);</font></tt><br><br><tt><font size=3D2>&n=
bsp; &nbsp; &nbsp; &nbsp; kfree(chip);</font></tt><br><tt><font size=3D2>}<=
/font></tt><br><tt><font size=3D2>EXPORT=5FSYMBOL=5FGPL(tpm=5Fchip=5Ffree);=
</font></tt><br><br><br><tt><font size=3D2>Good?</font></tt><br><br><tt><fo=
nt size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><br><tt><font size=3D2>&gt; =
</font></tt><br><tt><font size=3D2>&gt; Jason</font></tt><br><tt><font size=
=3D2>&gt; </font></tt><BR>
--=_alternative 006967BD85257F56_=--



--===============5447697866429497229==
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
--===============5447697866429497229==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============5447697866429497229==--
