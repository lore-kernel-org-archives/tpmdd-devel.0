From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: TPM emulator driver status
Date: Thu, 14 Jan 2016 09:58:45 -0500
Message-ID: <201601141458.u0EEwtGL011915@d03av02.boulder.ibm.com>
References: <201601131436.u0DEaIdD015610@d03av02.boulder.ibm.com>
	<11083.1452692382@warthog.procyon.org.uk>
	<25224.1452779110@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4514782278212561797=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <25224.1452779110-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============4514782278212561797==
Content-Type: multipart/alternative;
	boundary="=_alternative 00524A2B85257F3A_="


--=_alternative 00524A2B85257F3A_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote on 01/14/2016 08:45:10 AM:


> Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > I wrote a driver for support of (v)TPM for containers. It has ioctl's=20
for
> > creating and deleting of pairs of devices where one device is usedby=20
clients
> > and the other end is used by a TPM emulator to listen for=20
> commands. The client
> > device can be 'moved' in the container, meaning a device node with the =

same
> > major/minor numbers is created inside a container. Any number of such=20
device
> > pairs can be create. Does this driver sound like it would provide more
> > functionality than yours and would it address your use case as well?
>=20
> Maybe.  Is it accessible through the /dev/tpm<N> just like a h/w tpm?=20
And can
> it be accessed by in-kernel services that use a tpm?

Yes to all of the questions.

The primary target is integration with namespaced IMA and making vTPMs=20
available to each namespaced IMA. However, having the vTPM hooked up to=20
IMA is an extra ioctl that has to be issued at the right moment=20
(essentially before clone()) and is not necessary except for container=20
use-cases. So let me explain how the basic part works.

Using an ioctl, a new device pair is spawned. The core TPM device driver=20
creates /dev/vtpmcX (with X =3D 0...), which is just another name for=20
/dev/tpm0. I gave it a different name to be able to distinguish the=20
potentially many drivers from h/w tpm /dev/tpmZ (Z =3D 0...). Also a backen=
d=20
is created by that driver, with a device called /dev/vtpmsY (Y =3D 0...) . =

One places a software TPM emulator on this one and have it listen for=20
commands that are sent into /dev/vtpmcX. If there's no software TPM=20
listening on that device, all commands sent to the backend will receive a=20
-EIO.  So we have this connected device pair /dev/vtpmsY and /dev/vtpmcX,=20
a server and a client side. Another ioctl can delete the device pair=20
unless the backend is busy.

The above is added by a first series of patches. I can post them today.=20
Subsequent patches would add support for hooking the device pair to IMA=20
namespace...

So there's no device pair unless someone was to issue the ioctl. Then=20
kernel services would be able to find the device using=20
tpm=5Fchip=5Ffind=5Fget(int chip=5Fnum) and call the normal APIs to send TP=
M=20
command, though shouldn't do that before the swtpm has been started to=20
listen on the server side, otherwise they will get -EIO's.

There's a function call that could probably also create such a device pair =

during kernel startup or maybe conditionally if no hardware device is=20
available. Preferably we would leave this up to user space to handle this=20
via the ioctl.

A TPM device that I have been using for this setup is here :

https://github.com/stefanberger/swtpm

swtpm chardev --tpmstate dir=3D<dir> -c /dev/vtpms1 [other options] can be =

used to start a TPM emulator listening for commands on /dev/vtpmsY. Since=20
the TPM emulator behave just like a h/w TPM, one still needs to simulate=20
the BIOS initialization of the TPM using the tool swtpm=5Fbios run on=20
/dev/vtpmcX.


So I don't want to hold things up, but maybe this driver addresses your=20
use case as well.

   Stefan


>=20
> David
>=20



--=_alternative 00524A2B85257F3A_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>David Howells &lt;dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org&gt; wrote on 01/14=
/2016
08:45:10 AM:<br><br><br>&gt; Stefan Berger &lt;stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org&gt; wrote=
:<br>&gt; <br>&gt; &gt; I wrote a driver for support of (v)TPM for containe=
rs. It has
ioctl's for<br>&gt; &gt; creating and deleting of pairs of devices where on=
e device is
usedby clients<br>&gt; &gt; and the other end is used by a TPM emulator to =
listen for <br>&gt; commands. The client<br>&gt; &gt; device can be 'moved'=
 in the container, meaning a device node
with the same<br>&gt; &gt; major/minor numbers is created inside a containe=
r. Any number
of such device<br>&gt; &gt; pairs can be create. Does this driver sound lik=
e it would provide
more<br>&gt; &gt; functionality than yours and would it address your use ca=
se as
well?<br>&gt; <br>&gt; Maybe. &nbsp;Is it accessible through the /dev/tpm&l=
t;N&gt; just like
a h/w tpm? &nbsp;And can<br>&gt; it be accessed by in-kernel services that =
use a tpm?</font></tt><br><br><tt><font size=3D2>Yes to all of the question=
s.</font></tt><br><br><tt><font size=3D2>The primary target is integration =
with namespaced
IMA and making vTPMs available to each namespaced IMA. However, having
the vTPM hooked up to IMA is an extra ioctl that has to be issued at the
right moment (essentially before clone()) and is not necessary except for
container use-cases. So let me explain how the basic part works.</font></tt=
><br><br><tt><font size=3D2>Using an ioctl, a new device pair is spawned. T=
he
core TPM device driver creates /dev/vtpmcX (with X =3D 0...), which is just
another name for /dev/tpm0. I gave it a different name to be able to distin=
guish
the potentially many drivers from h/w tpm /dev/tpmZ (Z =3D 0...). Also a
backend is created by that driver, with a device called /dev/vtpmsY (Y
=3D 0...) . One places a software TPM emulator on this one and have it list=
en
for commands that are sent into /dev/vtpmcX. If there's no software TPM
listening on that device, all commands sent to the backend will receive
a -EIO. &nbsp;So we have this connected device pair /dev/vtpmsY and /dev/vt=
pmcX,
a server and a client side. Another ioctl can delete the device pair unless
the backend is busy.</font></tt><br><br><tt><font size=3D2>The above is add=
ed by a first series of patches. I
can post them today. Subsequent patches would add support for hooking the
device pair to IMA namespace...</font></tt><br><br><tt><font size=3D2>So th=
ere's no device pair unless someone was to issue
the ioctl. Then kernel services would be able to find the device using
tpm=5Fchip=5Ffind=5Fget(int chip=5Fnum) and call the normal APIs to send TP=
M command,
though shouldn't do that before the swtpm has been started to listen on
the server side, otherwise they will get -EIO's.</font></tt><br><br><tt><fo=
nt size=3D2>There's a function call that could probably also create
such a device pair during kernel startup or maybe conditionally if no hardw=
are
device is available. Preferably we would leave this up to user space to
handle this via the ioctl.</font></tt><br><br><tt><font size=3D2>A TPM devi=
ce that I have been using for this setup
is here :</font></tt><br><br><a href=3Dhttps://github.com/stefanberger/swtp=
m><tt><font size=3D2 color=3Dblue>https://github.com/stefanberger/swtpm</fo=
nt></tt></a><br><br><tt><font size=3D2>swtpm chardev --tpmstate dir=3D&lt;d=
ir&gt; -c /dev/vtpms1
[other options] can be used to start a TPM emulator listening for commands
on /dev/vtpmsY. Since the TPM emulator behave just like a h/w TPM, one
still needs to simulate the BIOS initialization of the TPM using the tool
swtpm=5Fbios run on /dev/vtpmcX.</font></tt><br><br><br><tt><font size=3D2>=
So I don't want to hold things up, but maybe this
driver addresses your use case as well.</font></tt><br><br><tt><font size=
=3D2>&nbsp; &nbsp;Stefan</font></tt><br><br><tt><font size=3D2><br>&gt; <br=
>&gt; David<br>&gt; <br></font></tt><BR>
--=_alternative 00524A2B85257F3A_=--



--===============4514782278212561797==
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
--===============4514782278212561797==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4514782278212561797==--
