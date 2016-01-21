From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Thu, 21 Jan 2016 16:51:06 -0500
Message-ID: <201601212151.u0LLpCtB021178@d01av01.pok.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7456862119242475492=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160121193049.GA31938-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============7456862119242475492==
Content-Type: multipart/alternative;
	boundary="=_alternative 00780A5585257F41_="


--=_alternative 00780A5585257F41_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/21/2016=20
02:30:49 PM:

>=20
> On Thu, Jan 21, 2016 at 02:02:17PM -0500, Stefan Berger wrote:
> >    What is IMA namespace in relation to a device's name? The method is =

to
> >    read the major/minor numbers on the host and created /dev/tpm0 with =

the
> >    same major/minor numbers in the container's filesystem. The name
> >    doesn't matter I guess, but major/minor are important.
>=20
> Ostensibly we number the /dev/tpmX's in relation to the tpm index
> number.
>=20
> Internally to the kernel the TPM access is done by that tpm index.
>=20
> Today, IMA hard codes that index value to 0 (IIRC). I could see a
> future IMA allowing user space to specify the index. The index is also
> how to associate the /dev/tpm node with the /sysfs files.
>=20
> So the index is important, we'd want to control it for namespaces.
>=20
> In any case the tpm index is part of the contract, and it would be
> ideal if the IMA namespace made tpm index 0 be the right vtpm.

Got it.

>=20
> >    The problem I have run into in particular with Docker and golang is
> >    that Docker invokes the golang function to run an external program. =

The
> >    golang function does a clone(), a whole lot of other stuff after=20
it,
> >    and in the end the execve().
>=20
> Well, ultimately that is a docker problem, as you describe IMA has a
> special new requirement where the IMA NS has to be setup quickly.
>=20
> >    The code is here:
> >    [1]https://golang.org/src/syscall/exec=5Flinux.go
> >    Look at the function forkAndExecInChildon line 56++.
>=20
> Well, that is just bad API design, sorry. The unix model of=20
fork()/exec()
> is that the app gets a chance to adjust the environment between
> fork/exec, and this design, while easy to use, locks the app into the
> hard wired customization that forkAndExecInChild does.

>From a callers' perspective it's attractive to have it do all kinds of=20
stuff IF one doesn't have to go in between. Unfortunately we have to go in =

between.

>=20
> Maybe add a callback to SysProcAttr or something? Can't help you here.
>=20
> You can't let this influence the kernel UAPI design.

The choice is between getting this working 'today' (even if just locally)=20
or discussing this with golang designers, which in the ideal case would=20
cause me waiting for the next version, dealing with that version=20
dependency etc., plus the delay. So, clearly, an additional ioctl() and=20
~50 lines of code make this work 'now'. Doesn't this seem worth it?

>=20
> >    available. So, the conclusion is, to accomodate golang (for=20
example) we
> >    can create the device pair, sit the vTPM on top of the master, and
> >    reserve the device pair befor the next clone() so that IMA finds it =

and
> >    can hook up to it.
> >    What is wrong with this scheme? The ioctl for 'reservation' before=20
the
> >    clone()?
>=20
> Yes, how does that sort of thing even make sense in a complex
> multi-threaded world?

controlfd =3D open("/dev/vtpmx, ...");
ioctl(controlfd, CREATE=5FVTPM, &inargs, &outargs);
[...]
ioctl(controlfd, RESERVE=5FVTPM=5FFOR=5FNS, ...params);
clone()

The possibility of passing that controlfd between threads is there if=20
clone() was to happen in another thread ... (it currently doesn't). It=20
shouldn't be a problem.

>=20
> >    Should it work like this?
>=20
> Sort of like this:
>=20
>     controlfd =3D open("/dev/vtpmx", ...);
>     ioctl(controlfd, CREATE=5FVTPM, &inargs, &outargs);
>     serverfd =3D outargs.fd;
>     // /dev/tpmX exists. X is returned in outargs.tpm=5Findex, maybe=20
> return major/minor too
>=20
>     child =3D clone(...)
>     ioctl(??? , ASSIGN=5FVTPM=5FTO=5FNS, .. child->ima=5Fns .., to index =
=3D 0,
>           from index =3D outargs.tpm=5Findex);

after the clone() you are in that IMA namespace. So the only argument=20
needed there is the index to the tpm=5Fchip to hook up to the current IMA=20
namespace.

>=20
>     /* tpm index X is destroyed, kernel prevents reuse of index X
>        until the NS is destroyed too. /dev/tpmX is removed by udev */
>     close(severfd);
>=20
> So, you'd probably make a vtpm daemon that took as execv args a
> reference to the IMA namespace to create the tpm in, and have docker
> launch it after the clone, but before the exec in the parent
> namespace.


I got that part with the fd, major & minor number. It seems to work.
I have one ioctl to reserve for before the clone and another ioctl to hook =

IMA-NS and vTPM together after the clone, but that patch is for later. So=20
let's not just kill the ioctl for 'reservation' like that, please.

>=20
> That is fairly similar to how net ns works, with the wrinkle you have
> to do this before the exec, I guess.
>=20
> It also allows hw tpms to be routed to the ns.

How many hardware TPMs are going to be there ? One? That is to be used for =

the host, right? Presumably the containers will all get emulated TPMs. And =

sharing the single hardware TPM between multiple containers just isn't=20
possible.

This will not be possible when going through the vTPM driver, but you have =

the ??? up there. I'd put the 'controlfd' in that place. The vTPM driver=20
will only know about vtpm=5Fdev->chip that it created and none of them is a=
=20
hardware TPM.

    Stefan

>=20
> The docker container just has the normal /dev/tpm0=20
>=20
> Jason
>=20



--=_alternative 00780A5585257F41_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/21/2016 02:30:49 PM:<br><br>&gt; <br>&gt; On Thu, Jan 21, 2016 =
at 02:02:17PM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;What is=
 IMA namespace in relation to a device's
name? The method is to<br>&gt; &gt; &nbsp; &nbsp;read the major/minor numbe=
rs on the host and created
/dev/tpm0 with the<br>&gt; &gt; &nbsp; &nbsp;same major/minor numbers in th=
e container's filesystem.
The name<br>&gt; &gt; &nbsp; &nbsp;doesn't matter I guess, but major/minor =
are important.<br>&gt; <br>&gt; Ostensibly we number the /dev/tpmX's in rel=
ation to the tpm index<br>&gt; number.<br>&gt; <br>&gt; Internally to the k=
ernel the TPM access is done by that tpm index.<br>&gt; <br>&gt; Today, IMA=
 hard codes that index value to 0 (IIRC). I could see a<br>&gt; future IMA =
allowing user space to specify the index. The index is
also<br>&gt; how to associate the /dev/tpm node with the /sysfs files.<br>&=
gt; <br>&gt; So the index is important, we'd want to control it for namespa=
ces.<br>&gt; <br>&gt; In any case the tpm index is part of the contract, an=
d it would be<br>&gt; ideal if the IMA namespace made tpm index 0 be the ri=
ght vtpm.</font></tt><br><br><tt><font size=3D2>Got it.</font></tt><br><tt>=
<font size=3D2><br>&gt; <br>&gt; &gt; &nbsp; &nbsp;The problem I have run i=
nto in particular with Docker
and golang is<br>&gt; &gt; &nbsp; &nbsp;that Docker invokes the golang func=
tion to run an
external program. The<br>&gt; &gt; &nbsp; &nbsp;golang function does a clon=
e(), a whole lot of other
stuff after it,<br>&gt; &gt; &nbsp; &nbsp;and in the end the execve().<br>&=
gt; <br>&gt; Well, ultimately that is a docker problem, as you describe IMA=
 has
a<br>&gt; special new requirement where the IMA NS has to be setup quickly.=
<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;The code is here:<br>&gt; &gt; &nbsp; &=
nbsp;[1]</font></tt><a href=3Dhttps://golang.org/src/syscall/exec=5Flinux.g=
o><tt><font size=3D2>https://golang.org/src/syscall/exec=5Flinux.go</font><=
/tt></a><tt><font size=3D2><br>&gt; &gt; &nbsp; &nbsp;Look at the function =
forkAndExecInChildon line 56++.<br>&gt; <br>&gt; Well, that is just bad API=
 design, sorry. The unix model of fork()/exec()<br>&gt; is that the app get=
s a chance to adjust the environment between<br>&gt; fork/exec, and this de=
sign, while easy to use, locks the app into
the<br>&gt; hard wired customization that forkAndExecInChild does.</font></=
tt><br><br><tt><font size=3D2>From a callers' perspective it's attractive t=
o have
it do all kinds of stuff IF one doesn't have to go in between. Unfortunately
we have to go in between.</font></tt><br><tt><font size=3D2><br>&gt; <br>&g=
t; Maybe add a callback to SysProcAttr or something? Can't help you here.<b=
r>&gt; <br>&gt; You can't let this influence the kernel UAPI design.</font>=
</tt><br><br><tt><font size=3D2>The choice is between getting this working =
'today'
(even if just locally) or discussing this with golang designers, which
in the ideal case would cause me waiting for the next version, dealing
with that version dependency etc., plus the delay. So, clearly, an addition=
al
ioctl() and ~50 lines of code make this work 'now'. Doesn't this seem worth
it?</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; &gt; &nbsp; &nbsp;a=
vailable. So, the conclusion is, to accomodate
golang (for example) we<br>&gt; &gt; &nbsp; &nbsp;can create the device pai=
r, sit the vTPM on top
of the master, and<br>&gt; &gt; &nbsp; &nbsp;reserve the device pair befor =
the next clone() so
that IMA finds it and<br>&gt; &gt; &nbsp; &nbsp;can hook up to it.<br>&gt; =
&gt; &nbsp; &nbsp;What is wrong with this scheme? The ioctl for 'reservatio=
n'
before the<br>&gt; &gt; &nbsp; &nbsp;clone()?<br>&gt; <br>&gt; Yes, how doe=
s that sort of thing even make sense in a complex<br>&gt; multi-threaded wo=
rld?</font></tt><br><br><tt><font size=3D2>controlfd =3D open(&quot;/dev/vt=
pmx, ...&quot;);</font></tt><br><tt><font size=3D2>ioctl(controlfd, CREATE=
=5FVTPM, &amp;inargs, &amp;outargs);</font></tt><br><tt><font size=3D2>[...=
]</font></tt><br><tt><font size=3D2>ioctl(controlfd, RESERVE=5FVTPM=5FFOR=
=5FNS, ...params);</font></tt><br><tt><font size=3D2>clone()</font></tt><br=
><br><tt><font size=3D2>The possibility of passing that controlfd between
threads is there if clone() was to happen in another thread ... (it current=
ly
doesn't). It shouldn't be a problem.</font></tt><br><br><tt><font size=3D2>=
&gt; <br>&gt; &gt; &nbsp; &nbsp;Should it work like this?<br>&gt; <br>&gt; =
Sort of like this:<br>&gt; <br>&gt; &nbsp; &nbsp; controlfd =3D open(&quot;=
/dev/vtpmx&quot;, ...);<br>&gt; &nbsp; &nbsp; ioctl(controlfd, CREATE=5FVTP=
M, &amp;inargs, &amp;outargs);<br>&gt; &nbsp; &nbsp; serverfd =3D outargs.f=
d;<br>&gt; &nbsp; &nbsp; // /dev/tpmX exists. X is returned in outargs.tpm=
=5Findex,
maybe &nbsp;<br>&gt; return major/minor too<br>&gt; <br>&gt; &nbsp; &nbsp; =
child =3D clone(...)<br>&gt; &nbsp; &nbsp; ioctl(??? , ASSIGN=5FVTPM=5FTO=
=5FNS, .. child-&gt;ima=5Fns ..,
to index =3D 0,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; from index =3D o=
utargs.tpm=5Findex);</font></tt><br><br><tt><font size=3D2>after the clone(=
) you are in that IMA namespace. So
the only argument needed there is the index to the tpm=5Fchip to hook up
to the current IMA namespace.</font></tt><br><tt><font size=3D2><br>&gt; <b=
r>&gt; &nbsp; &nbsp; /* tpm index X is destroyed, kernel prevents reuse of
index X<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;until the NS is destroyed too. /=
dev/tpmX
is removed by udev */<br>&gt; &nbsp; &nbsp; close(severfd);<br>&gt; <br>&gt=
; So, you'd probably make a vtpm daemon that took as execv args a<br>&gt; r=
eference to the IMA namespace to create the tpm in, and have docker<br>&gt;=
 launch it after the clone, but before the exec in the parent<br>&gt; names=
pace.</font></tt><br><br><br><tt><font size=3D2>I got that part with the fd=
, major &amp; minor number.
It seems to work.</font></tt><br><tt><font size=3D2>I have one ioctl to res=
erve for before the clone and
another ioctl to hook IMA-NS and vTPM together after the clone, but that
patch is for later. So let's not just kill the ioctl for 'reservation'
like that, please.</font></tt><br><br><tt><font size=3D2>&gt; <br>&gt; That=
 is fairly similar to how net ns works, with the wrinkle you have<br>&gt; t=
o do this before the exec, I guess.<br>&gt; <br>&gt; It also allows hw tpms=
 to be routed to the ns.</font></tt><br><br><tt><font size=3D2>How many har=
dware TPMs are going to be there ? One?
That is to be used for the host, right? Presumably the containers will
all get emulated TPMs. And sharing the single hardware TPM between multiple
containers just isn't possible.</font></tt><br><br><tt><font size=3D2>This =
will not be possible when going through the vTPM
driver, but you have the ??? up there. I'd put the 'controlfd' in that
place. The vTPM driver will only know about vtpm=5Fdev-&gt;chip that it cre=
ated
and none of them is a hardware TPM.</font></tt><br><br><tt><font size=3D2>&=
nbsp; &nbsp; Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; The=
 docker container just has the normal /dev/tpm0 <br>&gt; <br>&gt; Jason<br>=
&gt; <br></font></tt><BR>
--=_alternative 00780A5585257F41_=--



--===============7456862119242475492==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
--===============7456862119242475492==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7456862119242475492==--
