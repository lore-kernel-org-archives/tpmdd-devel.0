From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Wed, 10 Feb 2016 19:38:52 -0500
Message-ID: <201602110038.u1B0cuOT025818@d01av01.pok.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160209053323.GD12657@obsidianresearch.com>
	<201602091626.u19GQpga021574@d01av02.pok.ibm.com>
	<20160209165228.GA14611@obsidianresearch.com>
	<20160210035620.GB7161@intel.com>
	<201602100515.u1A5FpFi002736@d03av02.boulder.ibm.com>
	<20160210162809.GB20730@obsidianresearch.com>
	<201602102145.u1ALjSAs001597@d03av04.boulder.ibm.com>
	<20160210222313.GA7047@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4555674209256944900=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160210222313.GA7047-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============4555674209256944900==
Content-Type: multipart/alternative;
	boundary="=_alternative 000396A685257F56_="


--=_alternative 000396A685257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/10/2016=20
05:23:13 PM:

>
>=20
> >    > We shouldn't artificially limit the number of devices if
> >    > virtualization is the target. Use an idr, or figure out how to=20
get rid
> >    > of it. Since it is only used here:
> >    >
> >    >     dev=5Fset=5Fname(&vtpm=5Fdev->dev, "vtpms%d", vtpm=5Fdev->dev=
=5Fnum);
> >    >
> >    > Maybe it could be adjusted to use chip->dev=5Fnum instead.
>=20
> >    The chip->dev=5Fnum comes back from tpmm=5Fchip=5Falloc() which is c=
alled
> >    with the device as a parameter. That's the device we're trying to
>=20
> Hm, that is only needed for devm, could also do the tpm/tpmm split and
> avoid needing a registered dev.
>=20

How about another patch on top of the ones I have so far only solving this =

problem ?

>=20
>=20
> >    > Use u32's here:
> >    >
> >    >    u8 req=5Fbuf[TPM=5FBUFSIZE];     /* request buffer */
> >    >
> >    > and related to ensure the buffer is sensibly aligned
> >    May I ask why use u32's for a byte buffer? I am not sure what=20
alignment
> >    we need here. 4 byte boundary for maximum memcpy performance?
>=20
> Yes, it is nice to see the alignment guarenteed if memcpy is the
> primary use of this memory. It almost always happens naturally..

We now have only one buffer and there's a size=5Ft in front of it. So=20
alignment will be at 4 bytes.

>=20
> >    > Doesn't kill a running work thread - more synchronization is=20
needed
> >    > for that corner case
> >    Do you mean another test for STATE=5FOPEN bit is needed before it=20
enters
> >    the wait=5Fevent=5Finterruptible in the code below?
>=20
> No, just use a typical kernel idiom:
>=20
>             clear=5Fbit(STATE=5FOPENED, &vtpm=5Fdev->state);
>             wake=5Fup=5Finterruptible(&vtpm=5Fdev->wq);
>        flush=5Fworkqueue(&vtpm=5Fdev->work);
>=20
> And it would be typical/desirable to see that open coded in the
> one and only cleanup routine. That is what I usually look for when
> looking at work queues.
>=20
> I can't rember off hand if you need locking around dev->state to make
> the above work, IIRC the bit ops are special.

These ops are atomic:

http://lxr.free-electrons.com/source/include/asm-generic/bitops/atomic.h#L86


   Stefan

>=20
> Don't use work=5Fbusy in production code.
>=20
> >    >
> >    > fops=5Fwrite should fail if op=5Frecv isn't waiting for a buffer.
> >    So we introduce another state flag whether we are in receiving or
> >    sending mode ? Return -EBADF in the case of an unexpected write() ?
> >    Though -EBADF indicates "fd is not a valid file descriptor or is=20
not
> >    open for writing." So return -EIO?
>=20
> Probably yeah, pick an error code makes sense. EIO is probably OK, but
> maybe shift the 'STATE=5FOPEN' code to EPIPE or something.
>=20
> Jason
>=20



--=_alternative 000396A685257F56_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/10/2016 05:23:13 PM:<br><br>&gt;</font></tt><br><tt><font size=
=3D2>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; We shouldn't artificially limit t=
he number
of devices if<br>&gt; &gt; &nbsp; &nbsp;&gt; virtualization is the target. =
Use an idr, or
figure out how to get rid<br>&gt; &gt; &nbsp; &nbsp;&gt; of it. Since it is=
 only used here:<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&=
gt; &nbsp; &nbsp; dev=5Fset=5Fname(&amp;vtpm=5Fdev-&gt;dev,
&quot;vtpms%d&quot;, vtpm=5Fdev-&gt;dev=5Fnum);<br>&gt; &gt; &nbsp; &nbsp;&=
gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; Maybe it could be adjusted to use chip-&=
gt;dev=5Fnum
instead.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;The chip-&gt;dev=5Fnum comes ba=
ck from tpmm=5Fchip=5Falloc()
which is called<br>&gt; &gt; &nbsp; &nbsp;with the device as a parameter. T=
hat's the device
we're trying to<br>&gt; <br>&gt; Hm, that is only needed for devm, could al=
so do the tpm/tpmm split
and<br>&gt; avoid needing a registered dev.<br>&gt; </font></tt><br><br><tt=
><font size=3D2>How about another patch on top of the ones I have
so far only solving this problem ?</font></tt><br><tt><font size=3D2><br>&g=
t; <br>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; Use u32's here:<br>&gt; &gt; &n=
bsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; &nbsp; &nbsp;u8 req=5Fbuf[TP=
M=5FBUFSIZE]; &nbsp;
&nbsp; /* request buffer */<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nb=
sp; &nbsp;&gt; and related to ensure the buffer is sensibly
aligned<br>&gt; &gt; &nbsp; &nbsp;May I ask why use u32's for a byte buffer=
? I am
not sure what alignment<br>&gt; &gt; &nbsp; &nbsp;we need here. 4 byte boun=
dary for maximum memcpy
performance?<br>&gt; <br>&gt; Yes, it is nice to see the alignment guarente=
ed if memcpy is the<br>&gt; primary use of this memory. It almost always ha=
ppens naturally..<br></font></tt><br><tt><font size=3D2>We now have only on=
e buffer and there's a size=5Ft in
front of it. So alignment will be at 4 bytes.</font></tt><br><br><tt><font =
size=3D2>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; Doesn't kill a running work t=
hread - more synchronization
is needed<br>&gt; &gt; &nbsp; &nbsp;&gt; for that corner case<br>&gt; &gt; =
&nbsp; &nbsp;Do you mean another test for STATE=5FOPEN bit is needed
before it enters<br>&gt; &gt; &nbsp; &nbsp;the wait=5Fevent=5Finterruptible=
 in the code below?<br>&gt; <br>&gt; No, just use a typical kernel idiom:<b=
r>&gt; <br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; clear=5Fbit(STATE=
=5FOPENED,
&amp;vtpm=5Fdev-&gt;state);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; wake=5Fup=5Finterruptible(&amp;vtpm=5Fdev-&gt;wq);<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp;flush=5Fworkqueue(&amp;vtpm=5Fdev-&gt;work);<br>&gt; <br>&gt;=
 And it would be typical/desirable to see that open coded in the<br>&gt; on=
e and only cleanup routine. That is what I usually look for when<br>&gt; lo=
oking at work queues.<br>&gt; <br>&gt; I can't rember off hand if you need =
locking around dev-&gt;state to
make<br>&gt; the above work, IIRC the bit ops are special.</font></tt><br><=
br><tt><font size=3D2>These ops are atomic:</font></tt><br><br><a href=3D"h=
ttp://lxr.free-electrons.com/source/include/asm-generic/bitops/atomic.h#L86=
"><tt><font size=3D2 color=3Dblue>http://lxr.free-electrons.com/source/incl=
ude/asm-generic/bitops/atomic.h#L86</font></tt></a><br><br><br><tt><font si=
ze=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&=
gt; Don't use work=5Fbusy in production code.<br>&gt; <br>&gt; &gt; &nbsp; =
&nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; fops=5Fwrite should fail if op=5F=
recv isn't waiting
for a buffer.<br>&gt; &gt; &nbsp; &nbsp;So we introduce another state flag =
whether we are
in receiving or<br>&gt; &gt; &nbsp; &nbsp;sending mode ? Return -EBADF in t=
he case of an unexpected
write() ?<br>&gt; &gt; &nbsp; &nbsp;Though -EBADF indicates &quot;fd is not=
 a valid
file descriptor or is not<br>&gt; &gt; &nbsp; &nbsp;open for writing.&quot;=
 So return -EIO?<br>&gt; <br>&gt; Probably yeah, pick an error code makes s=
ense. EIO is probably OK,
but<br>&gt; maybe shift the 'STATE=5FOPEN' code to EPIPE or something.<br>&=
gt; <br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 000396A685257F56_=--



--===============4555674209256944900==
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
--===============4555674209256944900==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4555674209256944900==--
