From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Tue, 26 Jan 2016 18:22:46 -0500
Message-ID: <201601262322.u0QNMof3008181@d01av01.pok.ibm.com>
References: <20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<56A2461C.7030607@linux.vnet.ibm.com>
	<20160125181046.GB28108@obsidianresearch.com>
	<201601260105.u0Q15IWW028777@d03av04.boulder.ibm.com>
	<20160126034632.GB24217@obsidianresearch.com>
	<201601261421.u0QELnI3002626@d01av02.pok.ibm.com>
	<20160126182248.GB17937@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3497912396924781798=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160126182248.GB17937-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============3497912396924781798==
Content-Type: multipart/alternative;
	boundary="=_alternative 00806E2785257F46_="


--=_alternative 00806E2785257F46_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/26/2016=20
01:22:48 PM:


>=20
> On Tue, Jan 26, 2016 at 09:21:42AM -0500, Stefan Berger wrote:
> >    > So, in an ideal world vtpms0 wouldn't even exist. The need for it =

is
> >    > more tpm core breakage. You could avoid this by having the tpm=20
core
> >    > not create sysfs files on the parent for the vtpms. I think we=20
are
> >    > very close to being able to do that.
>=20
> >    We're not explicitly registering the parent with sysfs, yet it=20
appears
> >    there. How do you prevent it from appearing there?
>=20
> static struct kobject *get=5Fdevice=5Fparent(struct device *dev,
>                                          struct device *parent)
>=20
>                 /*
>                  * If we have no parent, we live in "virtual".
>                  * Class-devices with a non class-device as parent, live
>                  * in a "glue" directory to prevent namespace=20
collisions.
>                  */
>=20
> The vtpm should be under virtual, the question is if we need vtpm and
> and tpm devices, ie should the vtpm driver be calling class=5Fcreate or
> not.
>=20
> I don't have an answer to that, are there other virtualization devices
> you can reference as an example?

I don't have a virtual device example that doesn't have a parent. I had=20
looked at virtio=5Fconsole for, but that one also has a parent.

http://lxr.free-electrons.com/source/drivers/char/virtio=5Fconsole.c#L1439

>=20
> Ideally you'd get someone familiar with sysfs to confirm these details.
>=20
> > The only other solution I could think of is being able to pass a
> > NULL for 'dev' into the existing tpmm=5Fchip=5Falloc() and avoid the
> > parent device altogether.
>=20
> This would drop the vtpm and put tpm directly under virtual, however I
> think the tpm core currently will segfault if parent is null, that
> could be fixed if that is the way this should go.

Likely the parent isn't needed if the vtpm driver calls it. So a couple of =

checks for dev being NULL could solve that. But I rather leave it as is=20
for now before I tear  code out that I may have to re-add later on.

>=20
> >> put=5Fdevice should be last because it can kfree(vtpm=5Fdev)
> > Yes. Fixed.
>=20
> Not on your github...
>=20
> +static int vtpm=5Ffops=5Frelease(struct inode *inode, struct file *filp)
> +{
> +   struct vtpm=5Fdev *vtpm=5Fdev =3D filp->private=5Fdata;
> +
> +   filp->private=5Fdata =3D NULL;
> +
> +   put=5Fdevice(&vtpm=5Fdev->dev);
> +
> +   vtpm=5Fdelete=5Fdevice=5Fpair(vtpm=5Fdev);
> +
> +   return 0;
> +}
>=20
> Don't put something then continue to reference it after.
>=20
> Also, I would probably drop the get=5Fdevice in vtpm=5Ffops=5Fopen, use t=
he
> implicit get=5Fdevice of device=5Finitialize instead. Then drop the
> put=5Fdevice in vtpm=5Fdestroy=5Fvtpm=5Fdev and use only one at the end o=
f the
> fops release.

We have the implicit get=5Fdevice in vtpm=5Fcreate=5Fvtpm=5Fdev and would=20
therefore try to keep the put=5Fdevice in vtpm=5Fdestroy=5Fvtpm=5Fdev.

Besides that a device=5Finitialize + device=5Fadd =3D device=5Fregister and=
=20
device=5Fdel + put=5Fdevice =3D device=5Funregister, which could go into=20
vtpm=5Fcreate=5Fvtpm=5Fdev and vtpm=5Fdestroy=5Fvtpm=5Fdev respectively.

>=20
> So the flow is, device=5Finitialize [...] create a flip, transfer the
> kref from device=5Finitialize to the flip [..]
>=20
> Which makes the error flow very sane, once the flip is created,
> deleting the flip will clean up everything.
>=20
> >    I put the fixed version of the driver here:
> >    https://github.com/stefanberger/linux/commits/vtpm-driver.v2
>=20
> Please go through all the error handling, it still looks wrong:
>=20
> +static long vtpmx=5Ffops=5Fioctl(struct file *f, unsigned int ioctl,
> +             unsigned long arg)
> +      vtpm=5Fdev =3D vtpm=5Fcreate=5Fdevice=5Fpair(&vtpm=5Fnew=5Fpair);
> [..]
> +      if (copy=5Fto=5Fuser(vtpm=5Fnew=5Fpair=5Fp, &vtpm=5Fnew=5Fpair,
> +             sizeof(vtpm=5Fnew=5Fpair)))
> +         return -EFAULT;
>=20
> Can't be right, that fails the ioctl but still creates the FD and TPM.


True. I have not been able to undo fd=5Finstall so far and cannot find any =

other code that does that. So, I pulled that out and put it after the=20
successful copy=5Fto=5Fuser().


>=20
> The goto unwind of vtpm=5Fcreate=5Fdevice=5Fpair looks wrong too, double
> calls vtpm=5Fdestroy=5Fvtpm=5Fdev and other. See above on how the flip
> release should be relied upon to do that once the flip is created.
>=20
> Also I'm wondering about the placement of tpm=5Fchip=5Fregister, long
> term we are going to be moving tpm setup commands under
> tpm=5Fchip=5Fregister, so the driver must be fully ready to handle
> commands when it is called, so I think vtpm calls it too early.

re-ordered

>=20
> For instance, get=5Ftimeouts is never called in vtpm, which is not
> correct. The soft tpm should have an opportunity to tell the kernel
> the timeout values.

That's seems a chick-and-egg problem. The vTPM can only be started once=20
the ioctl has provided the fd.

>=20
> I think you have to fix this by calling tpm=5Fget=5Ftimeouts/chip=5Fregis=
ter
> from a work queue thread created before the ioctl returns. That should
> avoid deadlock..

We'll only ever be able to call that once the vTPM has been started on the =

fd... otherwise the default timeout values will have to do it.

>=20
> This is also very wrong:
>=20
> +struct vtpm=5Fdev {
>  +   struct kref kref;
>  +
>  +   struct device dev;
>=20
> Structs should only ever have one kref. Get rid of 'kref' and use the
> kref embedded in 'dev' via get=5Fdevice/put=5Fdevice.

Yes, sir.

>=20
> Also, what is the point of 'vtpm=5Fdev=5Fget=5Fby=5Fchip' ? Just store the
> vtpm=5Fdev in the chip's private data pointer like every other driver.

Introduced chip->priv.

>=20
> No special locking is needed, tpm core guarentees no op is running or
> will ever be called again once tpm=5Funregister returns.
>=20
> Jason
>=20

cheers!

Stefan


--=_alternative 00806E2785257F46_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/26/2016 01:22:48 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Tue, Jan 26, 2016 at 09:21:42AM -0500, Stefan Berger wrote=
:<br>&gt; &gt; &nbsp; &nbsp;&gt; So, in an ideal world vtpms0 wouldn't even
exist. The need for it is<br>&gt; &gt; &nbsp; &nbsp;&gt; more tpm core brea=
kage. You could avoid this
by having the tpm core<br>&gt; &gt; &nbsp; &nbsp;&gt; not create sysfs file=
s on the parent for the
vtpms. I think we are<br>&gt; &gt; &nbsp; &nbsp;&gt; very close to being ab=
le to do that.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;We're not explicitly regi=
stering the parent with
sysfs, yet it appears<br>&gt; &gt; &nbsp; &nbsp;there. How do you prevent i=
t from appearing there?<br>&gt; <br>&gt; static struct kobject *get=5Fdevic=
e=5Fparent(struct device *dev,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;struct
device *parent)<br>&gt; <br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; /*<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;* If
we have no parent, we live in &quot;virtual&quot;.<br>&gt; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* Class-devices
with a non class-device as parent, live<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* in
a &quot;glue&quot; directory to prevent namespace collisions.<br>&gt; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*/<br>&gt; <br>&gt=
; The vtpm should be under virtual, the question is if we need vtpm
and<br>&gt; and tpm devices, ie should the vtpm driver be calling class=5Fc=
reate
or<br>&gt; not.<br>&gt; <br>&gt; I don't have an answer to that, are there =
other virtualization devices<br>&gt; you can reference as an example?</font=
></tt><br><br><tt><font size=3D2>I don't have a virtual device example that=
 doesn't
have a parent. I had looked at virtio=5Fconsole for, but that one also has
a parent.</font></tt><br><br><a href=3D"http://lxr.free-electrons.com/sourc=
e/drivers/char/virtio=5Fconsole.c#L1439"><tt><font size=3D2 color=3Dblue>ht=
tp://lxr.free-electrons.com/source/drivers/char/virtio=5Fconsole.c#L1439</f=
ont></tt></a><br><tt><font size=3D2><br>&gt; <br>&gt; Ideally you'd get som=
eone familiar with sysfs to confirm these details.<br>&gt; <br>&gt; &gt; Th=
e only other solution I could think of is being able to pass
a<br>&gt; &gt; NULL for 'dev' into the existing tpmm=5Fchip=5Falloc() and a=
void
the<br>&gt; &gt; parent device altogether.<br>&gt; <br>&gt; This would drop=
 the vtpm and put tpm directly under virtual, however
I<br>&gt; think the tpm core currently will segfault if parent is null, tha=
t<br>&gt; could be fixed if that is the way this should go.</font></tt><br>=
<br><tt><font size=3D2>Likely the parent isn't needed if the vtpm driver
calls it. So a couple of checks for dev being NULL could solve that. But
I rather leave it as is for now before I tear &nbsp;code out that I may
have to re-add later on.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt=
; &gt;&gt; put=5Fdevice should be last because it can kfree(vtpm=5Fdev)<br>=
&gt; &gt; Yes. Fixed.<br>&gt; <br>&gt; Not on your github...<br>&gt; <br>&g=
t; +static int vtpm=5Ffops=5Frelease(struct inode *inode, struct file *filp=
)<br>&gt; +{<br>&gt; + &nbsp; struct vtpm=5Fdev *vtpm=5Fdev =3D filp-&gt;pr=
ivate=5Fdata;<br>&gt; +<br>&gt; + &nbsp; filp-&gt;private=5Fdata =3D NULL;<=
br>&gt; +<br>&gt; + &nbsp; put=5Fdevice(&amp;vtpm=5Fdev-&gt;dev);<br>&gt; +=
<br>&gt; + &nbsp; vtpm=5Fdelete=5Fdevice=5Fpair(vtpm=5Fdev);<br>&gt; +<br>&=
gt; + &nbsp; return 0;<br>&gt; +}<br>&gt; <br>&gt; Don't put something then=
 continue to reference it after.<br>&gt; <br>&gt; Also, I would probably dr=
op the get=5Fdevice in vtpm=5Ffops=5Fopen, use
the<br>&gt; implicit get=5Fdevice of device=5Finitialize instead. Then drop=
 the<br>&gt; put=5Fdevice in vtpm=5Fdestroy=5Fvtpm=5Fdev and use only one a=
t the end of
the<br>&gt; fops release.</font></tt><br><br><tt><font size=3D2>We have the=
 implicit get=5Fdevice in vtpm=5Fcreate=5Fvtpm=5Fdev
and would therefore try to keep the put=5Fdevice in vtpm=5Fdestroy=5Fvtpm=
=5Fdev.</font></tt><br><br><tt><font size=3D2>Besides that a device=5Finiti=
alize + device=5Fadd =3D device=5Fregister
and device=5Fdel + put=5Fdevice =3D device=5Funregister, which could go int=
o vtpm=5Fcreate=5Fvtpm=5Fdev
and vtpm=5Fdestroy=5Fvtpm=5Fdev respectively.</font></tt><br><tt><font size=
=3D2><br>&gt; <br>&gt; So the flow is, device=5Finitialize [...] create a f=
lip, transfer the<br>&gt; kref from device=5Finitialize to the flip [..]<br=
>&gt; <br>&gt; Which makes the error flow very sane, once the flip is creat=
ed,<br>&gt; deleting the flip will clean up everything.<br>&gt; <br>&gt; &g=
t; &nbsp; &nbsp;I put the fixed version of the driver here:<br>&gt; &gt; &n=
bsp; &nbsp;</font></tt><a href=3D"https://github.com/stefanberger/linux/com=
mits/vtpm-driver.v2"><tt><font size=3D2>https://github.com/stefanberger/lin=
ux/commits/vtpm-driver.v2</font></tt></a><tt><font size=3D2><br>&gt; <br>&g=
t; Please go through all the error handling, it still looks wrong:<br>&gt; =
<br>&gt; +static long vtpmx=5Ffops=5Fioctl(struct file *f, unsigned int ioc=
tl,<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; unsigned long arg)<=
br>&gt; + &nbsp; &nbsp; &nbsp;vtpm=5Fdev =3D vtpm=5Fcreate=5Fdevice=5Fpair(=
&amp;vtpm=5Fnew=5Fpair);<br>&gt; [..]<br>&gt; + &nbsp; &nbsp; &nbsp;if (cop=
y=5Fto=5Fuser(vtpm=5Fnew=5Fpair=5Fp, &amp;vtpm=5Fnew=5Fpair,<br>&gt; + &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sizeof(vtpm=5Fnew=5Fpair)))<br>&gt; +=
 &nbsp; &nbsp; &nbsp; &nbsp; return -EFAULT;<br>&gt; <br>&gt; Can't be righ=
t, that fails the ioctl but still creates the FD and
TPM.</font></tt><br><br><br><tt><font size=3D2>True. I have not been able t=
o undo fd=5Finstall so far
and cannot find any other code that does that. So, I pulled that out and
put it after the successful copy=5Fto=5Fuser().</font></tt><br><br><br><tt>=
<font size=3D2>&gt; <br>&gt; The goto unwind of vtpm=5Fcreate=5Fdevice=5Fpa=
ir looks wrong too, double<br>&gt; calls vtpm=5Fdestroy=5Fvtpm=5Fdev and ot=
her. See above on how the flip<br>&gt; release should be relied upon to do =
that once the flip is created.<br>&gt; <br>&gt; Also I'm wondering about th=
e placement of tpm=5Fchip=5Fregister, long<br>&gt; term we are going to be =
moving tpm setup commands under<br>&gt; tpm=5Fchip=5Fregister, so the drive=
r must be fully ready to handle<br>&gt; commands when it is called, so I th=
ink vtpm calls it too early.</font></tt><br><br><tt><font size=3D2>re-order=
ed</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; For instance, get=5F=
timeouts is never called in vtpm, which is not<br>&gt; correct. The soft tp=
m should have an opportunity to tell the kernel<br>&gt; the timeout values.=
</font></tt><br><br><tt><font size=3D2>That's seems a chick-and-egg problem=
. The vTPM can
only be started once the ioctl has provided the fd.</font></tt><br><tt><fon=
t size=3D2><br>&gt; <br>&gt; I think you have to fix this by calling tpm=5F=
get=5Ftimeouts/chip=5Fregister<br>&gt; from a work queue thread created bef=
ore the ioctl returns. That should<br>&gt; avoid deadlock..</font></tt><br>=
<br><tt><font size=3D2>We'll only ever be able to call that once the vTPM
has been started on the fd... otherwise the default timeout values will
have to do it.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; This is =
also very wrong:<br>&gt; <br>&gt; +struct vtpm=5Fdev {<br>&gt; &nbsp;+ &nbs=
p; struct kref kref;<br>&gt; &nbsp;+<br>&gt; &nbsp;+ &nbsp; struct device d=
ev;<br>&gt; <br>&gt; Structs should only ever have one kref. Get rid of 'kr=
ef' and use
the<br>&gt; kref embedded in 'dev' via get=5Fdevice/put=5Fdevice.</font></t=
t><br><br><tt><font size=3D2>Yes, sir.</font></tt><br><tt><font size=3D2><b=
r>&gt; <br>&gt; Also, what is the point of 'vtpm=5Fdev=5Fget=5Fby=5Fchip' ?=
 Just store the<br>&gt; vtpm=5Fdev in the chip's private data pointer like =
every other driver.</font></tt><br><br><tt><font size=3D2>Introduced chip-&=
gt;priv.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; No special loc=
king is needed, tpm core guarentees no op is running
or<br>&gt; will ever be called again once tpm=5Funregister returns.<br>&gt;=
 <br>&gt; Jason<br>&gt; <br></font></tt><br><tt><font size=3D2>cheers!</fon=
t></tt><br><br><tt><font size=3D2>Stefan</font></tt><BR>
--=_alternative 00806E2785257F46_=--



--===============3497912396924781798==
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
--===============3497912396924781798==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3497912396924781798==--
