From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Wed, 10 Feb 2016 16:45:24 -0500
Message-ID: <201602102145.u1ALjRqb007215@d01av01.pok.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
	<201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
	<20160210035620.GB7161@intel.com>
	<201602100515.u1A5FpFi002736@d03av02.boulder.ibm.com>
	<20160210162809.GB20730@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3505778495735249157=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160210162809.GB20730-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============3505778495735249157==
Content-Type: multipart/alternative;
	boundary="=_alternative 00778B3285257F55_="


--=_alternative 00778B3285257F55_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/10/2016=20
11:28:09 AM:

>=20
> On Wed, Feb 10, 2016 at 12:15:44AM -0500, Stefan Berger wrote:
> >    Redid that now.
> >     https://github.com/stefanberger/linux/commit/
> 83019eaab2cf5eb33f2665efdf9d2a117ed703b2
>=20
> Yeah, I think you've got that now.
>=20
> Just a few other random commments..
>=20
> This isn't great:
>=20
>    vtpm=5Fdev->dev=5Fnum =3D find=5Ffirst=5Fzero=5Fbit(dev=5Fmask, VTPM=
=5FNUM=5FDEVICES);
>=20
> We shouldn't artificially limit the number of devices if
> virtualization is the target. Use an idr, or figure out how to get rid
> of it. Since it is only used here:
>=20
>     dev=5Fset=5Fname(&vtpm=5Fdev->dev, "vtpms%d", vtpm=5Fdev->dev=5Fnum);
>=20
> Maybe it could be adjusted to use chip->dev=5Fnum instead.

The chip->dev=5Fnum comes back from tpmm=5Fchip=5Falloc() which is called w=
ith=20
the device as a parameter. That's the device we're trying to create. So it =

seems we need to have two independency ways to generate unique device=20
names. My suggestion would have been to increase the bitmap to the maximum =

size of the minor numbers but that's 20 bits, 1Mb. This would need to be=20
done for both sides.

I don't know how idr applies here from what I read in an article.=20
https://lwn.net/Articles/103209/

>=20
> This:
>    INIT=5FWORK(&vtpm=5Fdev->work, vtpm=5Fdev=5Fwork);
> should be near the kzalloc

Ok, I'll move that.

>=20
> Drop the 1 line functions (vtpm=5Fdev=5Fwork=5Fstart, vtpm=5Fdelete=5Fvtp=
m=5Fdev,

We have these function pairs here:

vtpm=5Fdev=5Fwork=5Fstart
vtpm=5Fdev=5Fwork=5Fstop

and

vtpm=5Fcreate=5Fvtpm=5Fdev
vtpm=5Fdelete=5Fvtpm=5Fdev

Can we just keep them as pairs with the one function undoing what the=20
other one has done. I prefix the one-liners with a 'static inline' and let =

the compiler optimize the code.


>=20
> Use u32's here:
>=20
>    u8 req=5Fbuf[TPM=5FBUFSIZE];     /* request buffer */
>=20
> and related to ensure the buffer is sensibly aligned

May I ask why use u32's for a byte buffer? I am not sure what alignment we =

need here. 4 byte boundary for maximum memcpy performance?

http://lxr.free-electrons.com/source/drivers/char/tpm/tpm-dev.c#L34
http://lxr.free-electrons.com/source/drivers/char/tpm/tpm=5Fi2c=5Finfineon.=
c#L67



>=20
> Don't log on user space inputs, use debug or something:
>=20
>       dev=5Ferr(&vtpm=5Fdev->dev,
>          "Invalid size in recv: count=3D%zd, req=5Flen=3D%zd\n",
>          count, len);
>=20
> This:
>=20
>    vtpm=5Fdev=5Fwork=5Fstop(vtpm=5Fdev);
>=20
> Doesn't kill a running work thread - more synchronization is needed
> for that corner case

Do you mean another test for STATE=5FOPEN bit is needed before it enters th=
e=20
wait=5Fevent=5Finterruptible in the code below?
Otherwise I tested this. What can happen is that the worker thread is=20
stuck in the wait function:

static int vtpm=5Ftpm=5Fop=5Frecv(struct tpm=5Fchip *chip, u8 *buf, size=5F=
t count)
[...]
        /* wait for response or responder gone */
        sig =3D wait=5Fevent=5Finterruptible(vtpm=5Fdev->wq,
                (vtpm=5Fdev->resp=5Flen !=3D 0
                || !test=5Fbit(STATE=5FOPENED, &vtpm=5Fdev->state)));
        if (sig)
                return -EINTR;

        /* process gone ? */
        if (!test=5Fbit(STATE=5FOPENED, &vtpm=5Fdev->state))
                return -EIO;
[...]

We loop while the task is still busy and kick it out of the above wait=20
queue with this function here. Ok, so far we may kick multiple times since =

the condition may only be tested after waiting.

static void vtpm=5Ffops=5Fundo=5Fopen(struct vtpm=5Fdev *vtpm=5Fdev)
{
        clear=5Fbit(STATE=5FOPENED, &vtpm=5Fdev->state);

        /* no more TPM responses -- wake up anyone waiting for them */
        wake=5Fup=5Finterruptible(&vtpm=5Fdev->wq);
}



>=20
> Make sure that devm is working for your specific case when this
> happens:
>=20

Just tested this and it seems to work. Chip is kfree'd once user space=20
closes the fd.

>  err:
>    /* did not register chip */
>    vtpm=5Fdev->chip =3D NULL;
>=20
> Instrument the core, devm should free the tpm chip when user space
> closes the fd. If not the core needs to provide a non-devm alloc for
> this driver. (easy)


It does that. We only partly unwind in the thread by letting the file=20
descriptor fail upon read and write and do the full unwinding upon file=20
descriptor closure.


>=20
> This spin lock:
>=20
>    spin=5Flock(&driver=5Flock);
>    vtpm=5Fdev->dev=5Fnum =3D find=5Ffirst=5Fzero=5Fbit(dev=5Fmask, VTPM=
=5FNUM=5FDEVICES);
>    [..]
>       err =3D device=5Fregister(&vtpm=5Fdev->dev); /* does get=5Fdevice */
>    spin=5Funlock(&driver=5Flock);
>=20
> I'm not comfortable with how big a region that is. If you keep
> dev=5Fmask, then only lock around the dev=5Fmask manipulation not other
> stuff. Relock to undo

Ok.

>=20
> fops=5Fwrite should fail if op=5Frecv isn't waiting for a buffer.

So we introduce another state flag whether we are in receiving or sending=20
mode ? Return -EBADF in the case of an unexpected write() ? Though -EBADF=20
indicates "fd is not a valid file descriptor or is not open for writing."=20
So return -EIO?

>=20
> Looks pretty good really

Yes. Thanks. And let's just keep the function pairs for the humans and let =

the compiler use the 'static inline' .

    Stefan


>=20
> Jason
>=20


--=_alternative 00778B3285257F55_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/10/2016 11:28:09 AM:</font></tt><br><br><tt><font size=3D2>&gt;=
 </font></tt><br><tt><font size=3D2>&gt; On Wed, Feb 10, 2016 at 12:15:44AM=
 -0500, Stefan
Berger wrote:</font></tt><br><tt><font size=3D2>&gt; &gt; &nbsp; &nbsp;Redi=
d that now.</font></tt><br><tt><font size=3D2>&gt; &gt; &nbsp; &nbsp; </fon=
t></tt><a href=3Dhttps://github.com/stefanberger/linux/commit/><tt><font si=
ze=3D2 color=3Dblue>https://github.com/stefanberger/linux/commit/</font></t=
t></a><br><tt><font size=3D2>&gt; 83019eaab2cf5eb33f2665efdf9d2a117ed703b2<=
/font></tt><br><tt><font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&=
gt; Yeah, I think you've got that now.</font></tt><br><tt><font size=3D2>&g=
t; </font></tt><br><tt><font size=3D2>&gt; Just a few other random commment=
s..</font></tt><br><tt><font size=3D2>&gt; </font></tt><br><tt><font size=
=3D2>&gt; This isn't great:</font></tt><br><tt><font size=3D2>&gt; </font><=
/tt><br><tt><font size=3D2>&gt; &nbsp; &nbsp;vtpm=5Fdev-&gt;dev=5Fnum =3D f=
ind=5Ffirst=5Fzero=5Fbit(dev=5Fmask,
VTPM=5FNUM=5FDEVICES);</font></tt><br><tt><font size=3D2>&gt; </font></tt><=
br><tt><font size=3D2>&gt; We shouldn't artificially limit the number of
devices if</font></tt><br><tt><font size=3D2>&gt; virtualization is the tar=
get. Use an idr, or
figure out how to get rid</font></tt><br><tt><font size=3D2>&gt; of it. Sin=
ce it is only used here:</font></tt><br><tt><font size=3D2>&gt; </font></tt=
><br><tt><font size=3D2>&gt; &nbsp; &nbsp; dev=5Fset=5Fname(&amp;vtpm=5Fdev=
-&gt;dev,
&quot;vtpms%d&quot;, vtpm=5Fdev-&gt;dev=5Fnum);</font></tt><br><tt><font si=
ze=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; Maybe it could be adjus=
ted to use chip-&gt;dev=5Fnum
instead.</font></tt><br><br><tt><font size=3D2>The chip-&gt;dev=5Fnum comes=
 back from tpmm=5Fchip=5Falloc()
which is called with the device as a parameter. That's the device we're
trying to create. So it seems we need to have two independency ways to
generate unique device names. My suggestion would have been to increase
the bitmap to the maximum size of the minor numbers but that's 20 bits,
1Mb. This would need to be done for both sides.</font></tt><br><br><tt><fon=
t size=3D2>I don't know how idr applies here from what I read
in an article. </font></tt><a href=3Dhttps://lwn.net/Articles/103209/><tt><=
font size=3D2 color=3Dblue>https://lwn.net/Articles/103209/</font></tt></a>=
<br><br><tt><font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; Thi=
s:</font></tt><br><tt><font size=3D2>&gt; &nbsp; &nbsp;INIT=5FWORK(&amp;vtp=
m=5Fdev-&gt;work,
vtpm=5Fdev=5Fwork);</font></tt><br><tt><font size=3D2>&gt; should be near t=
he kzalloc</font></tt><br><br><tt><font size=3D2>Ok, I'll move that.</font>=
</tt><br><br><tt><font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt=
; Drop the 1 line functions (vtpm=5Fdev=5Fwork=5Fstart,
vtpm=5Fdelete=5Fvtpm=5Fdev,</font></tt><br><br><tt><font size=3D2>We have t=
hese function pairs here:</font></tt><br><br><tt><font size=3D2>vtpm=5Fdev=
=5Fwork=5Fstart</font></tt><br><tt><font size=3D2>vtpm=5Fdev=5Fwork=5Fstop<=
/font></tt><br><br><tt><font size=3D2>and</font></tt><br><br><tt><font size=
=3D2>vtpm=5Fcreate=5Fvtpm=5Fdev</font></tt><br><tt><font size=3D2>vtpm=5Fde=
lete=5Fvtpm=5Fdev</font></tt><br><br><tt><font size=3D2>Can we just keep th=
em as pairs with the one function
undoing what the other one has done. I prefix the one-liners with a 'static
inline' and let the compiler optimize the code.</font></tt><br><br><br><tt>=
<font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; Use u32's here:=
</font></tt><br><tt><font size=3D2>&gt; </font></tt><br><tt><font size=3D2>=
&gt; &nbsp; &nbsp;u8 req=5Fbuf[TPM=5FBUFSIZE]; &nbsp;
&nbsp; /* request buffer */</font></tt><br><tt><font size=3D2>&gt; </font><=
/tt><br><tt><font size=3D2>&gt; and related to ensure the buffer is sensibly
aligned</font></tt><br><br><tt><font size=3D2>May I ask why use u32's for a=
 byte buffer? I am not
sure what alignment we need here. 4 byte boundary for maximum memcpy perfor=
mance?</font></tt><br><br><a href=3D"http://lxr.free-electrons.com/source/d=
rivers/char/tpm/tpm-dev.c#L34"><tt><font size=3D2 color=3Dblue>http://lxr.f=
ree-electrons.com/source/drivers/char/tpm/tpm-dev.c#L34</font></tt></a><br>=
<a href=3D"http://lxr.free-electrons.com/source/drivers/char/tpm/tpm=5Fi2c=
=5Finfineon.c#L67"><tt><font size=3D2 color=3Dblue>http://lxr.free-electron=
s.com/source/drivers/char/tpm/tpm=5Fi2c=5Finfineon.c#L67</font></tt></a><br=
><br><br><br><tt><font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt=
; Don't log on user space inputs, use debug or
something:</font></tt><br><tt><font size=3D2>&gt; </font></tt><br><tt><font=
 size=3D2>&gt; &nbsp; &nbsp; &nbsp; dev=5Ferr(&amp;vtpm=5Fdev-&gt;dev,</fon=
t></tt><br><tt><font size=3D2>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;=
Invalid
size in recv: count=3D%zd, req=5Flen=3D%zd\n&quot;,</font></tt><br><tt><fon=
t size=3D2>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;count, len);</font></tt><=
br><tt><font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; This:</f=
ont></tt><br><tt><font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt=
; &nbsp; &nbsp;vtpm=5Fdev=5Fwork=5Fstop(vtpm=5Fdev);</font></tt><br><tt><fo=
nt size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; Doesn't kill a run=
ning work thread - more synchronization
is needed</font></tt><br><tt><font size=3D2>&gt; for that corner case</font=
></tt><br><br><tt><font size=3D2>Do you mean another test for STATE=5FOPEN =
bit is needed
before it enters the wait=5Fevent=5Finterruptible in the code below?</font>=
</tt><br><tt><font size=3D2>Otherwise I tested this. What can happen is tha=
t the
worker thread is stuck in the wait function:</font></tt><br><br><tt><font s=
ize=3D2>static int vtpm=5Ftpm=5Fop=5Frecv(struct tpm=5Fchip *chip,
u8 *buf, size=5Ft count)</font></tt><br><tt><font size=3D2>[...]</font></tt=
><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; /* wait for response or
responder gone */</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &n=
bsp; sig =3D wait=5Fevent=5Finterruptible(vtpm=5Fdev-&gt;wq,</font></tt><br=
><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
(vtpm=5Fdev-&gt;resp=5Flen !=3D 0</font></tt><br><tt><font size=3D2>&nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
|| !test=5Fbit(STATE=5FOPENED, &amp;vtpm=5Fdev-&gt;state)));</font></tt><br=
><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; if (sig)</font></tt><br><tt=
><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
return -EINTR;</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &=
nbsp; /* process gone ? */</font></tt><br><tt><font size=3D2>&nbsp; &nbsp; =
&nbsp; &nbsp; if (!test=5Fbit(STATE=5FOPENED,
&amp;vtpm=5Fdev-&gt;state))</font></tt><br><tt><font size=3D2>&nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
return -EIO;</font></tt><br><tt><font size=3D2>[...]</font></tt><br><br><tt=
><font size=3D2>We loop while the task is still busy and kick it out
of the above wait queue with this function here. Ok, so far we may kick
multiple times since the condition may only be tested after waiting.</font>=
</tt><br><br><tt><font size=3D2>static void vtpm=5Ffops=5Fundo=5Fopen(struc=
t vtpm=5Fdev *vtpm=5Fdev)</font></tt><br><tt><font size=3D2>{</font></tt><b=
r><tt><font size=3D2>&nbsp; &nbsp; &nbsp; &nbsp; clear=5Fbit(STATE=5FOPENED,
&amp;vtpm=5Fdev-&gt;state);</font></tt><br><br><tt><font size=3D2>&nbsp; &n=
bsp; &nbsp; &nbsp; /* no more TPM responses
-- wake up anyone waiting for them */</font></tt><br><tt><font size=3D2>&nb=
sp; &nbsp; &nbsp; &nbsp; wake=5Fup=5Finterruptible(&amp;vtpm=5Fdev-&gt;wq);=
</font></tt><br><tt><font size=3D2>}</font></tt><br><br><br><br><tt><font s=
ize=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; Make sure that devm is=
 working for your specific
case when this</font></tt><br><tt><font size=3D2>&gt; happens:</font></tt><=
br><tt><font size=3D2>&gt; </font></tt><br><br><tt><font size=3D2>Just test=
ed this and it seems to work. Chip is kfree'd
once user space closes the fd.</font></tt><br><br><tt><font size=3D2>&gt; &=
nbsp;err:</font></tt><br><tt><font size=3D2>&gt; &nbsp; &nbsp;/* did not re=
gister chip */</font></tt><br><tt><font size=3D2>&gt; &nbsp; &nbsp;vtpm=5Fd=
ev-&gt;chip =3D NULL;</font></tt><br><tt><font size=3D2>&gt; </font></tt><b=
r><tt><font size=3D2>&gt; Instrument the core, devm should free the tpm
chip when user space</font></tt><br><tt><font size=3D2>&gt; closes the fd. =
If not the core needs to provide
a non-devm alloc for</font></tt><br><tt><font size=3D2>&gt; this driver. (e=
asy)</font></tt><br><br><br><tt><font size=3D2>It does that. We only partly=
 unwind in the thread
by letting the file descriptor fail upon read and write and do the full
unwinding upon file descriptor closure.</font></tt><br><br><br><tt><font si=
ze=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; This spin lock:</font><=
/tt><br><tt><font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; &nb=
sp; &nbsp;spin=5Flock(&amp;driver=5Flock);</font></tt><br><tt><font size=3D=
2>&gt; &nbsp; &nbsp;vtpm=5Fdev-&gt;dev=5Fnum =3D find=5Ffirst=5Fzero=5Fbit(=
dev=5Fmask,
VTPM=5FNUM=5FDEVICES);</font></tt><br><tt><font size=3D2>&gt; &nbsp; &nbsp;=
[..]</font></tt><br><tt><font size=3D2>&gt; &nbsp; &nbsp; &nbsp; err =3D de=
vice=5Fregister(&amp;vtpm=5Fdev-&gt;dev);
/* does get=5Fdevice */</font></tt><br><tt><font size=3D2>&gt; &nbsp; &nbsp=
;spin=5Funlock(&amp;driver=5Flock);</font></tt><br><tt><font size=3D2>&gt; =
</font></tt><br><tt><font size=3D2>&gt; I'm not comfortable with how big a =
region that
is. If you keep</font></tt><br><tt><font size=3D2>&gt; dev=5Fmask, then onl=
y lock around the dev=5Fmask
manipulation not other</font></tt><br><tt><font size=3D2>&gt; stuff. Relock=
 to undo</font></tt><br><br><tt><font size=3D2>Ok.</font></tt><br><br><tt><=
font size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; fops=5Fwrite sho=
uld fail if op=5Frecv isn't waiting
for a buffer.</font></tt><br><br><tt><font size=3D2>So we introduce another=
 state flag whether we are
in receiving or sending mode ? Return -EBADF in the case of an unexpected
write() ? Though -EBADF indicates &quot;fd is not a valid file descriptor
or is not open for writing.&quot; So return -EIO?</font></tt><br><br><tt><f=
ont size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; Looks pretty good=
 really</font></tt><br><br><tt><font size=3D2>Yes. Thanks. And let's just k=
eep the function pairs
for the humans and let the compiler use the 'static inline' .</font></tt><b=
r><br><tt><font size=3D2>&nbsp; &nbsp; Stefan</font></tt><br><br><br><tt><f=
ont size=3D2>&gt; </font></tt><br><tt><font size=3D2>&gt; Jason</font></tt>=
<br><tt><font size=3D2>&gt; </font></tt><BR>
--=_alternative 00778B3285257F55_=--



--===============3505778495735249157==
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
--===============3505778495735249157==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3505778495735249157==--
