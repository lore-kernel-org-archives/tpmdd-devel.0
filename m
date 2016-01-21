From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Thu, 21 Jan 2016 14:02:17 -0500
Message-ID: <201601211912.u0LJCTxv029932@d03av04.boulder.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7396022361502378255=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160121174243.GD3064-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============7396022361502378255==
Content-Type: multipart/alternative;
	boundary="=_alternative 006895CA85257F41_="


--=_alternative 006895CA85257F41_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/21/2016=20
12:42:43 PM:

>=20
> On Wed, Jan 20, 2016 at 10:56:21PM -0500, Stefan Berger wrote:
> > The IMA namespace is created as part of clone(). You cannot pass=20
> anything via
> > clone(). So you either have to do it before or immediately after.=20
> If after is
> > too later for whatever reason, you have to do it before.
>=20
> Follow the pattern of something like the net ns.
>=20
> clone creates an 'empty' IMA namespace. After clone the child waits
> for the parent to complete its work.
>=20
> The parent creates a new vtpm /dev/tpm1 in it's namespace
>=20
> The parent does a kernel call to make tpm1 visiable in the child's
> IMA namespace as tpm0. (eg look at the 'ip link set .. netns ..' kind
> of scheme for inspiration)

What is IMA namespace in relation to a device's name? The method is to=20
read the major/minor numbers on the host and created /dev/tpm0 with the=20
same major/minor numbers in the container's filesystem. The name doesn't=20
matter I guess, but major/minor are important.

>=20
> Hook the tpm core's id to struct tpm=5Fchip code into the IMA namespace
> so that /dev/tpm0 and all other places actually access tpm1 when used
> in the child's IMA namespace
>=20
> The parent signals the child to continue to run. The child has a
> /dev/tpm0 that is actually routed to /dev/tpm1. The child is prevented
> from accessing other tpms.


The problem I have run into in particular with Docker and golang is that=20
Docker invokes the golang function to run an external program. The golang=20
function does a clone(), a whole lot of other stuff after it, and in the=20
end the execve().

The code is here:

https://golang.org/src/syscall/exec=5Flinux.go

Look at the function forkAndExecInChild on line 56++.

The problem with that is that the execve() will trigger IMA measurements.=20
IMA will refuse being hooked up with a vTPM driver if it couldn't put its=20
first measurement(s) into a vTPM. I don't think we should queue PCR=20
extensions until a device may eventually become available. So, the=20
conclusion is, to accomodate golang (for example) we can create the device =

pair, sit the vTPM on top of the master, and reserve the device pair befor =

the next clone() so that IMA finds it and can hook up to it.=20

What is wrong with this scheme? The ioctl for 'reservation' before the=20
clone()?


>=20
>=20
> > > Then just return the fd like I said.
> >=20
> > Any driver that can be used as an example ?
>=20
> The stuff in include/linux/anon=5Finodes.h is used to do this, eg
> a sequence of anon=5Finode=5Fgetfile, get=5Funused=5Ffd=5Fflags, fd=5Fins=
tall
> will create a file descriptor in the calling process associated with a
> struct file=5Foperations
>=20

So let me show how things work currently.

fd =3D open("/dev/vtpmx", ...);
ioctl(fd, 'create device pair; TPM will be a TPM 2 version device')
/* conveying that the device is a TPM 2 or 1.2 is important so that the=20
kernel sends the right commands to the device and possibly also for sysfs=20
handling */

/* at this point /dev/vtpmc0 and /dev/vtpms0 have been created */
clientfd =3D open("/dev/vtpmc0",...)
serverfd =3D open("/dev/vtpms0",...);

...

close(serverfd); /* /dev/vtpmc0 and /dev/vtpms0 disappeared */




Should it work like this?

serverfd =3D open("/dev/vtpmx", ...);
/* at this point /dev/vtpmc0 has been created and serverfd is used for the =

server side */

ioctl(fd, 'TPM will be a TPM 2 version device') /* setting flags on the=20
chip->flags 'late' should be possible */

...

close(serverfd); /* /dev/vtpmc0 disappeared */


Regards,
   Stefan


> > > auto-delete a master char dev on close is a very strange API, don't=20
do
> > > that.
> >=20
> > What I called cleanup can be trigger by the vTPM closing /dev/
> vtpms%d, so the
> > server-side. What is the master for you? /dev/vtpmx where we run=20
> the ioctls on?
>=20
> Sorry, master/slave is the ptx nomenclature for this scheme. Master
> would be your server side I think.=20
>=20
> Jason
>=20



--=_alternative 006895CA85257F41_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/21/2016 12:42:43 PM:<br><br>&gt; <br>&gt; On Wed, Jan 20, 2016 =
at 10:56:21PM -0500, Stefan Berger wrote:<br>&gt; &gt; The IMA namespace is=
 created as part of clone(). You cannot pass
<br>&gt; anything via<br>&gt; &gt; clone(). So you either have to do it bef=
ore or immediately after.
<br>&gt; If after is<br>&gt; &gt; too later for whatever reason, you have t=
o do it before.<br>&gt; <br>&gt; Follow the pattern of something like the n=
et ns.<br>&gt; <br>&gt; clone creates an 'empty' IMA namespace. After clone=
 the child waits<br>&gt; for the parent to complete its work.<br>&gt; <br>&=
gt; The parent creates a new vtpm /dev/tpm1 in it's namespace<br>&gt; <br>&=
gt; The parent does a kernel call to make tpm1 visiable in the child's<br>&=
gt; IMA namespace as tpm0. (eg look at the 'ip link set .. netns ..' kind<b=
r>&gt; of scheme for inspiration)</font></tt><br><br><tt><font size=3D2>Wha=
t is IMA namespace in relation to a device's name?
The method is to read the major/minor numbers on the host and created /dev/=
tpm0
with the same major/minor numbers in the container's filesystem. The name
doesn't matter I guess, but major/minor are important.</font></tt><br><tt><=
font size=3D2><br>&gt; <br>&gt; Hook the tpm core's id to struct tpm=5Fchip=
 code into the IMA namespace<br>&gt; so that /dev/tpm0 and all other places=
 actually access tpm1 when used<br>&gt; in the child's IMA namespace<br>&gt=
; <br>&gt; The parent signals the child to continue to run. The child has a=
<br>&gt; /dev/tpm0 that is actually routed to /dev/tpm1. The child is preve=
nted<br>&gt; from accessing other tpms.</font></tt><br><br><br><tt><font si=
ze=3D2>The problem I have run into in particular with Docker
and golang is that Docker invokes the golang function to run an external
program. The golang function does a clone(), a whole lot of other stuff
after it, and in the end the execve().</font></tt><br><br><tt><font size=3D=
2>The code is here:</font></tt><br><br><a href=3Dhttps://golang.org/src/sys=
call/exec=5Flinux.go><tt><font size=3D2 color=3Dblue>https://golang.org/src=
/syscall/exec=5Flinux.go</font></tt></a><br><br><tt><font size=3D2>Look at =
the function </font></tt><tt><font size=3D3>forkAndExecInChild</font></tt><=
tt><font size=3D2>on line 56++.</font></tt><br><br><tt><font size=3D2>The p=
roblem with that is that the execve() will trigger
IMA measurements. IMA will refuse being hooked up with a vTPM driver if
it couldn't put its first measurement(s) into a vTPM. I don't think we
should queue PCR extensions until a device may eventually become available.
So, the conclusion is, to accomodate golang (for example) we can create
the device pair, sit the vTPM on top of the master, and reserve the device
pair befor the next clone() so that IMA finds it and can hook up to it.
</font></tt><br><br><tt><font size=3D2>What is wrong with this scheme? The =
ioctl for 'reservation'
before the clone()?</font></tt><br><br><tt><font size=3D2><br>&gt; <br>&gt;=
 <br>&gt; &gt; &gt; Then just return the fd like I said.<br>&gt; &gt; <br>&=
gt; &gt; Any driver that can be used as an example ?<br>&gt; <br>&gt; The s=
tuff in include/linux/anon=5Finodes.h is used to do this, eg<br>&gt; a sequ=
ence of anon=5Finode=5Fgetfile, get=5Funused=5Ffd=5Fflags, fd=5Finstall<br>=
&gt; will create a file descriptor in the calling process associated with
a<br>&gt; struct file=5Foperations<br>&gt; </font></tt><br><br><tt><font si=
ze=3D2>So let me show how things work currently.</font></tt><br><br><tt><fo=
nt size=3D2>fd =3D open(&quot;/dev/vtpmx&quot;, ...);</font></tt><br><tt><f=
ont size=3D2>ioctl(fd, 'create device pair; TPM will be a TPM 2
version device')</font></tt><br><tt><font size=3D2>/* conveying that the de=
vice is a TPM 2 or 1.2 is
important so that the kernel sends the right commands to the device and
possibly also for sysfs handling */</font></tt><br><br><tt><font size=3D2>/=
* at this point /dev/vtpmc0 and /dev/vtpms0 have
been created */</font></tt><br><tt><font size=3D2>clientfd =3D open(&quot;/=
dev/vtpmc0&quot;,...)</font></tt><br><tt><font size=3D2>serverfd =3D open(&=
quot;/dev/vtpms0&quot;,...);</font></tt><br><br><tt><font size=3D2>...</fon=
t></tt><br><br><tt><font size=3D2>close(serverfd); /* /dev/vtpmc0 and /dev/=
vtpms0 disappeared
*/</font></tt><br><br><br><br><br><tt><font size=3D2>Should it work like th=
is?</font></tt><br><br><tt><font size=3D2>serverfd =3D open(&quot;/dev/vtpm=
x&quot;, ...);</font></tt><br><tt><font size=3D2>/* at this point /dev/vtpm=
c0 has been created and
serverfd is used for the server side */</font></tt><br><br><tt><font size=
=3D2>ioctl(fd, 'TPM will be a TPM 2 version device') /*
setting flags on the chip-&gt;flags 'late' should be possible */</font></tt=
><br><br><tt><font size=3D2>...</font></tt><br><br><tt><font size=3D2>close=
(serverfd); /* /dev/vtpmc0 disappeared */</font></tt><br><br><br><tt><font =
size=3D2>Regards,</font></tt><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</fo=
nt></tt><br><br><tt><font size=3D2><br>&gt; &gt; &gt; auto-delete a master =
char dev on close is a very strange
API, don't do<br>&gt; &gt; &gt; that.<br>&gt; &gt; <br>&gt; &gt; What I cal=
led cleanup can be trigger by the vTPM closing /dev/<br>&gt; vtpms%d, so th=
e<br>&gt; &gt; server-side. What is the master for you? /dev/vtpmx where we
run <br>&gt; the ioctls on?<br>&gt; <br>&gt; Sorry, master/slave is the ptx=
 nomenclature for this scheme. Master<br>&gt; would be your server side I t=
hink. <br>&gt; <br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 006895CA85257F41_=--



--===============7396022361502378255==
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
--===============7396022361502378255==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7396022361502378255==--
