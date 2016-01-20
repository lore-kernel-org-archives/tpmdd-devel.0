From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 20 Jan 2016 09:39:09 -0500
Message-ID: <201601201439.u0KEdGB9031710@d01av04.pok.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8293092633936206549=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160119235107.GA4307-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============8293092633936206549==
Content-Type: multipart/alternative;
	boundary="=_alternative 00507E4C85257F40_="


--=_alternative 00507E4C85257F40_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/19/2016=20
06:51:07 PM:

>=20
> On Thu, Jan 14, 2016 at 11:01:57AM -0500, Stefan Berger wrote:
> > +   pdev =3D platform=5Fdevice=5Fregister=5Fsimple("tpm=5Fvtpm",=20
vtpm=5Fdev->dev=5Fnum,
> > +                      NULL, 0);
>=20
> This seems strange, something like this should not be creating
> platform=5Fdevices.

Should it be a misc=5Fdevice then ?

>=20
> tpm's cannot be attached to platform=5Fdevices outside their probe
> functions, I just fixed that bug in tpm=5Ftis.
>=20
> Attach the tpm to a device on the vtpm=5Fclass? Do it through a callback
> that takes care of devm? IIRC there is one but the name escapes me now
> :)
>=20
> > +   vtpm=5Fdev->chip =3D tpmm=5Fchip=5Falloc=5Fpattern(vtpm=5Fdev->pdev,
> > +            &vtpm=5Ftpm=5Fops,
> > +            VTPM=5FDEV=5FPREFIX=5FCLIENT"%d");
>=20
> I agree with Jarkko I don't see why these deserve special names..

I did that because it becomes confusing when there are many /dev/tpm%d=20
type of devices. This way we can distinguish between a hardware /dev/tpm%d =

and all these types of devices.

>=20
> Presumably some namespace magic can be used to make them show up as
> tpm0 in a container?

The magic is to have the container management stack create the device=20
pair. From the ioctl it learns the name of the devices that were created=20
and it then finds out about the major/minor number of the created device=20
and have /dev/tpm0 with that major/minor created in the container's /dev=20
directory.

>=20
> > +   vtpm=5Fdev->chip->flags |=3D TPM=5FCHIP=5FFLAG=5FNO=5FSYSFS |=20
TPM=5FCHIP=5FFLAG=5FNO=5FLOG;
>=20
> Why no sysfs files?

I have changed this now to the following

+       if (vtpm=5Fdev->flags & VTPM=5FFLAG=5FNO=5FSYSFS)
+               vtpm=5Fdev->chip->flags |=3D TPM=5FCHIP=5FFLAG=5FNO=5FSYSFS;
+
+       if (vtpm=5Fdev->flags & VTPM=5FFLAG=5FNO=5FLOG)
+               vtpm=5Fdev->chip->flags |=3D TPM=5FCHIP=5FFLAG=5FNO=5FLOG;
+

https://github.com/stefanberger/linux/commit/5dd68fef872f10261521c91c23b1d0=
dfbdf69996#diff-0d6b7dbf28fbfdd13909c2e1b5a6d7a3R541


The issue with sysfs is that sysfs is showing directory entries for all=20
vTPMs in all containers. If we don't want users to see the PCRs of other=20
containers we set this flag. The side effect of setting this flag is that=20
the container will not be able to see its own TPM device, either, but=20
presumably the user has commands to reads PCRs etc.

Regarding VTPM=5FFLAG=5FNO=5FLOG: Container's boot/start without firmware t=
hat=20
would write an ACPI log. So in most cases one will choose the=20
VTPM=5FFLAG=5FNO=5FLOG flag since there is no log. Maybe that's a flag the =
user=20
shouldn't have control over.

>=20
> > +   switch (ioctl) {
> > +   case VTPM=5FNEW=5FDEV:
> > +      if (!capable(CAP=5FSYS=5FADMIN))
> > +         return -EPERM;
> > +      vtpm=5Fnew=5Fpair=5Fp =3D argp;
> > +      if (copy=5Ffrom=5Fuser(&vtpm=5Fnew=5Fpair, vtpm=5Fnew=5Fpair=5Fp,
> > +               sizeof(vtpm=5Fnew=5Fpair)))
> > +         return -EFAULT;
> > +      vtpm=5Fdev =3D vtpm=5Fcreate=5Fdevice=5Fpair(&vtpm=5Fnew=5Fpair);
> > +      if (IS=5FERR(vtpm=5Fdev))
> > +         return PTR=5FERR(vtpm=5Fdev);
> > +      if (copy=5Fto=5Fuser(vtpm=5Fnew=5Fpair=5Fp, &vtpm=5Fnew=5Fpair,
> > +             sizeof(vtpm=5Fnew=5Fpair)))
> > +         return -EFAULT;
>=20
> Another way to handle this is to return the FD for the server side of
> the new TPM here and then route accesses from the /dev/tpmX side to
> that FD. Avoid the extra char device. There is some kernel
> infrasturcture that helpd do this (anon fd or something, IIRC)

Hm, I would prefer to keep the server-side char device since that way one=20
isn't tied to fd passing or so and the TPM could terminate and be=20
restarted later on on top of that server side device while keeping the=20
client side device usable beyond the server side shutting down.

>=20
> For this usage that might make more sense than trying to copy the ptmx
> scheme, which is like that for other reasons..

:-) Yes, ptmx is where I took this from.

>=20
> > +   case VTPM=5FDEL=5FDEV:
> > +      if (!capable(CAP=5FSYS=5FADMIN))
> > +         return -EPERM;
>=20
> Then del becomes close() on the special fd

And with that the client side device would *have* to close as well because =

the backend now is inaccessible?

>=20
> > +   case VTPM=5FGET=5FVTPMDEV:
>=20
> And this wouldn't be needed

Assuming we want to keep server side for longer time, this ioctl and=20
VTPM=5FGET=5FTPMDEV help to determine the other side of device that found i=
n=20
/dev.

Thanks for looking at the patches. I would prefer to keep the two=20
character devices rather than the server side only being represented with=20
an fd.

   Stefan

>=20
> Jason
>=20



--=_alternative 00507E4C85257F40_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/19/2016 06:51:07 PM:<br><br>&gt; <br>&gt; On Thu, Jan 14, 2016 =
at 11:01:57AM -0500, Stefan Berger wrote:<br>&gt; &gt; + &nbsp; pdev =3D pl=
atform=5Fdevice=5Fregister=5Fsimple(&quot;tpm=5Fvtpm&quot;,
vtpm=5Fdev-&gt;dev=5Fnum,<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;NULL, 0);<br>&gt; <br>&gt; This seems strange, something like =
this should not be creating<br>&gt; platform=5Fdevices.</font></tt><br><br>=
<tt><font size=3D2>Should it be a misc=5Fdevice then ?</font></tt><br><tt><=
font size=3D2><br>&gt; <br>&gt; tpm's cannot be attached to platform=5Fdevi=
ces outside their probe<br>&gt; functions, I just fixed that bug in tpm=5Ft=
is.<br>&gt; <br>&gt; Attach the tpm to a device on the vtpm=5Fclass? Do it =
through a callback<br>&gt; that takes care of devm? IIRC there is one but t=
he name escapes me
now<br>&gt; :)<br>&gt; <br>&gt; &gt; + &nbsp; vtpm=5Fdev-&gt;chip =3D tpmm=
=5Fchip=5Falloc=5Fpattern(vtpm=5Fdev-&gt;pdev,<br>&gt; &gt; + &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;&amp;vtpm=5Ftpm=5Fops,<br>&gt; &gt; + &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp;VTPM=5FDEV=5FPREFIX=5FCLIENT&quot;%d&quot;)=
;<br>&gt; <br>&gt; I agree with Jarkko I don't see why these deserve specia=
l names..</font></tt><br><br><tt><font size=3D2>I did that because it becom=
es confusing when there
are many /dev/tpm%d type of devices. This way we can distinguish between
a hardware /dev/tpm%d and all these types of devices.</font></tt><br><tt><f=
ont size=3D2><br>&gt; <br>&gt; Presumably some namespace magic can be used =
to make them show up as<br>&gt; tpm0 in a container?</font></tt><br><br><tt=
><font size=3D2>The magic is to have the container management stack
create the device pair. From the ioctl it learns the name of the devices
that were created and it then finds out about the major/minor number of
the created device and have /dev/tpm0 with that major/minor created in
the container's /dev directory.</font></tt><br><tt><font size=3D2><br>&gt; =
<br>&gt; &gt; + &nbsp; vtpm=5Fdev-&gt;chip-&gt;flags |=3D TPM=5FCHIP=5FFLAG=
=5FNO=5FSYSFS
| TPM=5FCHIP=5FFLAG=5FNO=5FLOG;<br>&gt; <br>&gt; Why no sysfs files?</font>=
</tt><br><br><tt><font size=3D2>I have changed this now to the following</f=
ont></tt><br><br><font size=3D3>+ &nbsp; &nbsp; &nbsp; &nbsp;if (vtpm=5Fdev=
-&gt;flags
&amp; VTPM=5FFLAG=5FNO=5FSYSFS)</font><br><font size=3D3>+ &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;vtpm=5Fdev-&gt;chip-&gt;flags |=3D TPM=5FCHIP=5FFLAG=5FNO=5FSYSFS;</f=
ont><br><font size=3D3>+</font><br><font size=3D3>+ &nbsp; &nbsp; &nbsp; &n=
bsp;if (vtpm=5Fdev-&gt;flags
&amp; VTPM=5FFLAG=5FNO=5FLOG)</font><br><font size=3D3>+ &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;vtpm=5Fdev-&gt;chip-&gt;flags |=3D TPM=5FCHIP=5FFLAG=5FNO=5FLOG;</fon=
t><br><font size=3D3>+</font><br><br><a href=3D"https://github.com/stefanbe=
rger/linux/commit/5dd68fef872f10261521c91c23b1d0dfbdf69996#diff-0d6b7dbf28f=
bfdd13909c2e1b5a6d7a3R541"><tt><font size=3D2 color=3Dblue>https://github.c=
om/stefanberger/linux/commit/5dd68fef872f10261521c91c23b1d0dfbdf69996#diff-=
0d6b7dbf28fbfdd13909c2e1b5a6d7a3R541</font></tt></a><br><br><br><tt><font s=
ize=3D2>The issue with sysfs is that sysfs is showing directory
entries for all vTPMs in all containers. If we don't want users to see
the PCRs of other containers we set this flag. The side effect of setting
this flag is that the container will not be able to see its own TPM device,
either, but presumably the user has commands to reads PCRs etc.</font></tt>=
<br><br><tt><font size=3D2>Regarding VTPM=5FFLAG=5FNO=5FLOG: Container's bo=
ot/start
without firmware that would write an ACPI log. So in most cases one will
choose the VTPM=5FFLAG=5FNO=5FLOG flag since there is no log. Maybe that's a
flag the user shouldn't have control over.</font></tt><br><tt><font size=3D=
2><br>&gt; <br>&gt; &gt; + &nbsp; switch (ioctl) {<br>&gt; &gt; + &nbsp; ca=
se VTPM=5FNEW=5FDEV:<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;if (!capable(CAP=5F=
SYS=5FADMIN))<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; return -EPERM;<br>=
&gt; &gt; + &nbsp; &nbsp; &nbsp;vtpm=5Fnew=5Fpair=5Fp =3D argp;<br>&gt; &gt=
; + &nbsp; &nbsp; &nbsp;if (copy=5Ffrom=5Fuser(&amp;vtpm=5Fnew=5Fpair,
vtpm=5Fnew=5Fpair=5Fp,<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; sizeof(vtpm=5Fnew=5Fpair)))<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;=
 &nbsp; return -EFAULT;<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;vtpm=5Fdev =3D v=
tpm=5Fcreate=5Fdevice=5Fpair(&amp;vtpm=5Fnew=5Fpair);<br>&gt; &gt; + &nbsp;=
 &nbsp; &nbsp;if (IS=5FERR(vtpm=5Fdev))<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;=
 &nbsp; return PTR=5FERR(vtpm=5Fdev);<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;if=
 (copy=5Fto=5Fuser(vtpm=5Fnew=5Fpair=5Fp, &amp;vtpm=5Fnew=5Fpair,<br>&gt; &=
gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sizeof(vtpm=5Fnew=5Fpair)))=
<br>&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; return -EFAULT;<br>&gt; <br>&gt=
; Another way to handle this is to return the FD for the server side
of<br>&gt; the new TPM here and then route accesses from the /dev/tpmX side=
 to<br>&gt; that FD. Avoid the extra char device. There is some kernel<br>&=
gt; infrasturcture that helpd do this (anon fd or something, IIRC)</font></=
tt><br><br><tt><font size=3D2>Hm, I would prefer to keep the server-side ch=
ar device
since that way one isn't tied to fd passing or so and the TPM could termina=
te
and be restarted later on on top of that server side device while keeping
the client side device usable beyond the server side shutting down.</font><=
/tt><br><tt><font size=3D2><br>&gt; <br>&gt; For this usage that might make=
 more sense than trying to copy the
ptmx<br>&gt; scheme, which is like that for other reasons..</font></tt><br>=
<br><tt><font size=3D2>:-) Yes, ptmx is where I took this from.</font></tt>=
<br><tt><font size=3D2><br>&gt; <br>&gt; &gt; + &nbsp; case VTPM=5FDEL=5FDE=
V:<br>&gt; &gt; + &nbsp; &nbsp; &nbsp;if (!capable(CAP=5FSYS=5FADMIN))<br>&=
gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; return -EPERM;<br>&gt; <br>&gt; Then=
 del becomes close() on the special fd</font></tt><br><br><tt><font size=3D=
2>And with that the client side device would *have*
to close as well because the backend now is inaccessible?</font></tt><br><t=
t><font size=3D2><br>&gt; <br>&gt; &gt; + &nbsp; case VTPM=5FGET=5FVTPMDEV:=
<br>&gt; <br>&gt; And this wouldn't be needed</font></tt><br><br><tt><font =
size=3D2>Assuming we want to keep server side for longer time,
this ioctl and VTPM=5FGET=5FTPMDEV help to determine the other side of devi=
ce
that found in /dev.</font></tt><br><br><tt><font size=3D2>Thanks for lookin=
g at the patches. I would prefer
to keep the two character devices rather than the server side only being
represented with an fd.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;=
Stefan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Jason<br>&gt; <b=
r></font></tt><BR>
--=_alternative 00507E4C85257F40_=--



--===============8293092633936206549==
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
--===============8293092633936206549==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8293092633936206549==--
