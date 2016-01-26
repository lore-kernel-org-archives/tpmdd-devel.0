From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Tue, 26 Jan 2016 09:21:42 -0500
Message-ID: <201601261421.u0QELlNt014177@d01av03.pok.ibm.com>
References: <20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<56A2461C.7030607@linux.vnet.ibm.com>
	<20160125181046.GB28108@obsidianresearch.com>
	<201601260105.u0Q15IWW028777@d03av04.boulder.ibm.com>
	<20160126034632.GB24217@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0757175601561320385=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160126034632.GB24217-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============0757175601561320385==
Content-Type: multipart/alternative;
	boundary="=_alternative 004EE51885257F46_="


--=_alternative 004EE51885257F46_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/25/2016=20
10:46:32 PM:

>=20
> On Mon, Jan 25, 2016 at 08:05:14PM -0500, Stefan Berger wrote:
>=20
> > > And confused why there is a miscdev and a alloc=5Fchrdev=5Fregion ?
> >=20
> > miscdev =3D /dev/vtpmx - that should be ok, no ?
>=20
> Yes
>=20
> > So, I just removed alloc=5Fchrdev=5Fregion and with that the assignment=
 of=20
a
> > major+minor to the virtual device. This works fine on device creation=20
but on
> > device destruction something odd happens in sysfs.
>=20
> > With two 'vtpmctrl' test programs running sysfs looks like this:
> >=20
> > # find /sys/devices/virtual/vtpm/
> > /sys/devices/virtual/vtpm/
> > /sys/devices/virtual/vtpm/vtpms0
> > /sys/devices/virtual/vtpm/vtpms0/dev
>=20
> Ugh.
>=20
> So, in an ideal world vtpms0 wouldn't even exist. The need for it is
> more tpm core breakage. You could avoid this by having the tpm core
> not create sysfs files on the parent for the vtpms. I think we are
> very close to being able to do that.

We're not explicitly registering the parent with sysfs, yet it appears=20
there. How do you prevent it from appearing there? The only other solution =

I could think of is being able to pass a NULL for 'dev' into the existing=20
tpmm=5Fchip=5Falloc() and avoid the parent device altogether.

>=20
> The it would just be /sys/devices/virtual/tpm0/dev
>=20
> If vtpms0 is kept, then it shouldn't have a 'dev':

Now it doesn't have it anymore.

>=20
> > /sys/devices/virtual/vtpm/vtpms0/dev
>=20
> The plus side is that it should be able to act as the devm container
> for the tpmm=5F function.
>=20
> This should be the only dev:
>=20
> > /sys/devices/virtual/vtpm/vtpms0/tpm0/dev
>=20
> That is a big clue something is very wrong if the above exists but
> the alloc=5Fchrdev=5Fregion was removed.
>=20
> > That's all that is left now. .../vtpms1/tpm1/ has also already=20
disappeared.
> > Needless to say, the kernel is very unhappy once the other=20
> vtpmctrl terminates.
> >=20
> > The virtual device needs a major/minor as well. Are there any other=20
possible
> > solutions?
>=20
> This bad behavior is some secondary bug.. Just looking around I think
> all the lifetime stuff needs a good go over. I noticed at least...
>=20
> This looks wrong:
>=20
> +static int vtpm=5Ffops=5Frelease(struct inode *inode, struct file *filp)
>=20
> +    put=5Fdevice(&vtpm=5Fdev->dev);
> +
> +   =5Fvtpm=5Fdelete=5Fdevice=5Fpair(vtpm=5Fdev);
>=20
> put=5Fdevice should be last because it can kfree(vtpm=5Fdev)

Yes. Fixed.

>=20
> This looks questionable too:
>=20
> +   device=5Fdestroy(vtpm=5Fclass, vtpm=5Fdev->dev.devt);
>=20
> The driver never calls device=5Fcreate, it shouldn't call
> device=5Fdestroy.

My bad! This now has to be device=5Fdel() + put=5Fdevice() and then it work=
s.

>=20
> The device=5Finitialize transfers kref ownership to the caller, so
> vtpm=5Fdev->dev needs a matching device=5Fput on all error paths, not
> device=5Fdestroy
>=20
> IMHO, the put=5Fdevice in the fops->release should be the match to
> device=5Finitialize, and it should be the last thing. Audit eveything
> else to make that true
>=20
> This looks wrong too:
>=20
> +    /* device is needed for core TPM driver */
> +    device=5Finitialize(&vtpm=5Fdev->dev);
> +    vtpm=5Fdev->dev.devt =3D devt;
> +    vtpm=5Fdev->dev.class =3D vtpm=5Fclass;
> +    vtpm=5Fdev->dev.release =3D vtpm=5Fdev=5Frelease;
>=20
> I usualle like to put device=5Finitialize last in that sequence, drop
> the devt stuff so you don't get a 'dev'

I did that in the same order as what 'device=5Fcreate' ends up doing :

1697         device=5Finitialize(dev);
1698         dev->devt =3D devt;
1699         dev->class =3D class;
1700         dev->parent =3D parent;
1701         dev->groups =3D groups;
1702         dev->release =3D device=5Fcreate=5Frelease;
1703         dev=5Fset=5Fdrvdata(dev, drvdata);

http://lxr.free-electrons.com/source/drivers/base/core.c#L1680

Usage of 'devt' is gone.

I put the fixed version of the driver here:

https://github.com/stefanberger/linux/commits/vtpm-driver.v2


Thanks for the review.

   Stefan

>=20
> The RCU stuff looks off too - where is the synchronize=5Frcu ?
>=20
> Jason
>=20



--=_alternative 004EE51885257F46_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/25/2016 10:46:32 PM:<br><br>&gt; <br>&gt; On Mon, Jan 25, 2016 =
at 08:05:14PM -0500, Stefan Berger wrote:<br>&gt; <br>&gt; &gt; &gt; And co=
nfused why there is a miscdev and a alloc=5Fchrdev=5Fregion
?<br>&gt; &gt; <br>&gt; &gt; miscdev =3D /dev/vtpmx - that should be ok, no=
 ?<br>&gt; <br>&gt; Yes<br>&gt; <br>&gt; &gt; So, I just removed alloc=5Fch=
rdev=5Fregion and with that the assignment
of a<br>&gt; &gt; major+minor to the virtual device. This works fine on dev=
ice
creation but on<br>&gt; &gt; device destruction something odd happens in sy=
sfs.<br>&gt; <br>&gt; &gt; With two 'vtpmctrl' test programs running sysfs =
looks like this:<br>&gt; &gt; <br>&gt; &gt; # find /sys/devices/virtual/vtp=
m/<br>&gt; &gt; /sys/devices/virtual/vtpm/<br>&gt; &gt; /sys/devices/virtua=
l/vtpm/vtpms0<br>&gt; &gt; /sys/devices/virtual/vtpm/vtpms0/dev<br>&gt; <br=
>&gt; Ugh.<br>&gt; <br>&gt; So, in an ideal world vtpms0 wouldn't even exis=
t. The need for it
is<br>&gt; more tpm core breakage. You could avoid this by having the tpm c=
ore<br>&gt; not create sysfs files on the parent for the vtpms. I think we =
are<br>&gt; very close to being able to do that.</font></tt><br><br><tt><fo=
nt size=3D2>We're not explicitly registering the parent with sysfs,
yet it appears there. How do you prevent it from appearing there? The only
other solution I could think of is being able to pass a NULL for 'dev'
into the existing tpmm=5Fchip=5Falloc() and avoid the parent device altoget=
her.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; The it would just =
be /sys/devices/virtual/tpm0/dev<br>&gt; <br>&gt; If vtpms0 is kept, then i=
t shouldn't have a 'dev':</font></tt><br><br><tt><font size=3D2>Now it does=
n't have it anymore.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; &g=
t; /sys/devices/virtual/vtpm/vtpms0/dev<br>&gt; <br>&gt; The plus side is t=
hat it should be able to act as the devm container<br>&gt; for the tpmm=5F =
function.<br>&gt; <br>&gt; This should be the only dev:<br>&gt; <br>&gt; &g=
t; /sys/devices/virtual/vtpm/vtpms0/tpm0/dev<br>&gt; <br>&gt; That is a big=
 clue something is very wrong if the above exists but<br>&gt; the alloc=5Fc=
hrdev=5Fregion was removed.<br>&gt; <br>&gt; &gt; That's all that is left n=
ow. .../vtpms1/tpm1/ has also already
disappeared.<br>&gt; &gt; Needless to say, the kernel is very unhappy once =
the other <br>&gt; vtpmctrl terminates.<br>&gt; &gt; <br>&gt; &gt; The virt=
ual device needs a major/minor as well. Are there any
other possible<br>&gt; &gt; solutions?<br>&gt; <br>&gt; This bad behavior i=
s some secondary bug.. Just looking around I think<br>&gt; all the lifetime=
 stuff needs a good go over. I noticed at least...<br>&gt; <br>&gt; This lo=
oks wrong:<br>&gt; <br>&gt; +static int vtpm=5Ffops=5Frelease(struct inode =
*inode, struct file *filp)<br>&gt; <br>&gt; + &nbsp; &nbsp;put=5Fdevice(&am=
p;vtpm=5Fdev-&gt;dev);<br>&gt; +<br>&gt; + &nbsp; =5Fvtpm=5Fdelete=5Fdevice=
=5Fpair(vtpm=5Fdev);<br>&gt; <br>&gt; put=5Fdevice should be last because i=
t can kfree(vtpm=5Fdev)</font></tt><br><br><tt><font size=3D2>Yes. Fixed.</=
font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; This looks questionable =
too:<br>&gt; <br>&gt; + &nbsp; device=5Fdestroy(vtpm=5Fclass, vtpm=5Fdev-&g=
t;dev.devt);<br>&gt; <br>&gt; The driver never calls device=5Fcreate, it sh=
ouldn't call<br>&gt; device=5Fdestroy.</font></tt><br><br><tt><font size=3D=
2>My bad! This now has to be device=5Fdel() + put=5Fdevice()
and then it works.</font></tt><br><br><tt><font size=3D2>&gt; <br>&gt; The =
device=5Finitialize transfers kref ownership to the caller, so<br>&gt; vtpm=
=5Fdev-&gt;dev needs a matching device=5Fput on all error paths, not<br>&gt=
; device=5Fdestroy<br>&gt; <br>&gt; IMHO, the put=5Fdevice in the fops-&gt;=
release should be the match to<br>&gt; device=5Finitialize, and it should b=
e the last thing. Audit eveything<br>&gt; else to make that true<br>&gt; <b=
r>&gt; This looks wrong too:<br>&gt; <br>&gt; + &nbsp; &nbsp;/* device is n=
eeded for core TPM driver */<br>&gt; + &nbsp; &nbsp;device=5Finitialize(&am=
p;vtpm=5Fdev-&gt;dev);<br>&gt; + &nbsp; &nbsp;vtpm=5Fdev-&gt;dev.devt =3D d=
evt;<br>&gt; + &nbsp; &nbsp;vtpm=5Fdev-&gt;dev.class =3D vtpm=5Fclass;<br>&=
gt; + &nbsp; &nbsp;vtpm=5Fdev-&gt;dev.release =3D vtpm=5Fdev=5Frelease;<br>=
&gt; <br>&gt; I usualle like to put device=5Finitialize last in that sequen=
ce, drop<br>&gt; the devt stuff so you don't get a 'dev'</font></tt><br><br=
><tt><font size=3D2>I did that in the same order as what 'device=5Fcreate'
ends up doing :</font></tt><br><br><a href=3D"http://lxr.free-electrons.com=
/source/drivers/base/core.c#L1697"><tt><font size=3D3 color=3Dblue><u>1697<=
/u></font></tt></a><tt><font size=3D3>&nbsp; &nbsp; &nbsp; &nbsp; </font></=
tt><a href=3D"http://lxr.free-electrons.com/ident?i=3Ddevice=5Finitialize#L=
1680"><tt><font size=3D3 color=3Dblue><u>device=5Finitialize</u></font></tt=
></a><tt><font size=3D3>(</font></tt><a href=3D"http://lxr.free-electrons.c=
om/ident?i=3Ddev#L1680"><tt><font size=3D3 color=3Dblue><u>dev</u></font></=
tt></a><tt><font size=3D3>);<br></font></tt><a href=3D"http://lxr.free-elec=
trons.com/source/drivers/base/core.c#L1698"><tt><font size=3D3 color=3Dblue=
><u>1698</u></font></tt></a><tt><font size=3D3>&nbsp; &nbsp; &nbsp; &nbsp; =
</font></tt><a href=3D"http://lxr.free-electrons.com/ident?i=3Ddev#L1680"><=
tt><font size=3D3 color=3Dblue><u>dev</u></font></tt></a><tt><font size=3D3=
>-&gt;devt
=3D devt;<br></font></tt><a href=3D"http://lxr.free-electrons.com/source/dr=
ivers/base/core.c#L1699"><tt><font size=3D3 color=3Dblue><u>1699</u></font>=
</tt></a><tt><font size=3D3>&nbsp; &nbsp; &nbsp; &nbsp; </font></tt><a href=
=3D"http://lxr.free-electrons.com/ident?i=3Ddev#L1680"><tt><font size=3D3 c=
olor=3Dblue><u>dev</u></font></tt></a><tt><font size=3D3>-&gt;class
=3D class;<br></font></tt><a href=3D"http://lxr.free-electrons.com/source/d=
rivers/base/core.c#L1700"><tt><font size=3D3 color=3Dblue><u>1700</u></font=
></tt></a><tt><font size=3D3>&nbsp; &nbsp; &nbsp; &nbsp; </font></tt><a hre=
f=3D"http://lxr.free-electrons.com/ident?i=3Ddev#L1680"><tt><font size=3D3 =
color=3Dblue><u>dev</u></font></tt></a><tt><font size=3D3>-&gt;</font></tt>=
<a href=3D"http://lxr.free-electrons.com/ident?i=3Dparent#L1680"><tt><font =
size=3D3 color=3Dblue><u>parent</u></font></tt></a><tt><font size=3D3>=3D <=
/font></tt><a href=3D"http://lxr.free-electrons.com/ident?i=3Dparent#L1680"=
><tt><font size=3D3 color=3Dblue><u>parent</u></font></tt></a><tt><font siz=
e=3D3>;<br></font></tt><a href=3D"http://lxr.free-electrons.com/source/driv=
ers/base/core.c#L1701"><tt><font size=3D3 color=3Dblue><u>1701</u></font></=
tt></a><tt><font size=3D3>&nbsp; &nbsp; &nbsp; &nbsp; </font></tt><a href=
=3D"http://lxr.free-electrons.com/ident?i=3Ddev#L1680"><tt><font size=3D3 c=
olor=3Dblue><u>dev</u></font></tt></a><tt><font size=3D3>-&gt;groups
=3D groups;<br></font></tt><a href=3D"http://lxr.free-electrons.com/source/=
drivers/base/core.c#L1702"><tt><font size=3D3 color=3Dblue><u>1702</u></fon=
t></tt></a><tt><font size=3D3>&nbsp; &nbsp; &nbsp; &nbsp; </font></tt><a hr=
ef=3D"http://lxr.free-electrons.com/ident?i=3Ddev#L1680"><tt><font size=3D3=
 color=3Dblue><u>dev</u></font></tt></a><tt><font size=3D3>-&gt;</font></tt=
><a href=3D"http://lxr.free-electrons.com/ident?i=3Drelease#L1680"><tt><fon=
t size=3D3 color=3Dblue><u>release</u></font></tt></a><tt><font size=3D3>=
=3D </font></tt><a href=3D"http://lxr.free-electrons.com/ident?i=3Ddevice=
=5Fcreate=5Frelease#L1680"><tt><font size=3D3 color=3Dblue><u>device=5Fcrea=
te=5Frelease</u></font></tt></a><tt><font size=3D3>;<br></font></tt><a href=
=3D"http://lxr.free-electrons.com/source/drivers/base/core.c#L1703"><tt><fo=
nt size=3D3 color=3Dblue><u>1703</u></font></tt></a><tt><font size=3D3>&nbs=
p; &nbsp; &nbsp; &nbsp; </font></tt><a href=3D"http://lxr.free-electrons.co=
m/ident?i=3Ddev=5Fset=5Fdrvdata#L1680"><tt><font size=3D3 color=3Dblue><u>d=
ev=5Fset=5Fdrvdata</u></font></tt></a><tt><font size=3D3>(</font></tt><a hr=
ef=3D"http://lxr.free-electrons.com/ident?i=3Ddev#L1680"><tt><font size=3D3=
 color=3Dblue><u>dev</u></font></tt></a><tt><font size=3D3>,
drvdata);</font></tt><br><br><a href=3D"http://lxr.free-electrons.com/sourc=
e/drivers/base/core.c#L1680"><tt><font size=3D2 color=3Dblue>http://lxr.fre=
e-electrons.com/source/drivers/base/core.c#L1680</font></tt></a><br><br><tt=
><font size=3D2>Usage of 'devt' is gone.</font></tt><br><br><tt><font size=
=3D2>I put the fixed version of the driver here:</font></tt><br><br><a href=
=3D"https://github.com/stefanberger/linux/commits/vtpm-driver.v2"><tt><font=
 size=3D2 color=3Dblue>https://github.com/stefanberger/linux/commits/vtpm-d=
river.v2</font></tt></a><br><br><tt><font size=3D2><br>Thanks for the revie=
w.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br=
><tt><font size=3D2><br>&gt; <br>&gt; The RCU stuff looks off too - where i=
s the synchronize=5Frcu ?<br>&gt; <br>&gt; Jason<br>&gt; <br></font></tt><B=
R>
--=_alternative 004EE51885257F46_=--



--===============0757175601561320385==
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
--===============0757175601561320385==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0757175601561320385==--
