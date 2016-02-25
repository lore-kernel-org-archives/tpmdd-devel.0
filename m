From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 09/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Thu, 25 Feb 2016 17:11:46 -0500
Message-ID: <201602252207.u1PM7rgw015912@d01av05.pok.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-10-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222192741.GI22088@obsidianresearch.com>
	<201602230142.u1N1gSuF029481@d01av05.pok.ibm.com>
	<20160223021730.GD26177@obsidianresearch.com>
	<201602242306.u1ON6qGP030251@d01av05.pok.ibm.com>
	<20160225131732.GA20860@intel.com>
	<201602251409.u1PE98LH012367@d01av05.pok.ibm.com>
	<20160225173956.GA1407@obsidianresearch.com>
	<201602251842.u1PIgEuL014249@d03av03.boulder.ibm.com>
	<20160225203117.GA22984@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6016538208433309735=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160225203117.GA22984-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============6016538208433309735==
Content-Type: multipart/alternative;
	boundary="=_alternative 0079EEB285257F64_="


--=_alternative 0079EEB285257F64_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/25/2016=20
03:31:17 PM:


>=20
> On Thu, Feb 25, 2016 at 01:42:10PM -0500, Stefan Berger wrote:
>=20
> >    It looks like they some are being used on the kobject level.
>=20
> Yes, struct devices are kobjects.
>=20
> >    > Once you figure out how to define what TPMs are in a namespace it
> >    > should be doable to use the syfs=5Fns APIs to have sysfs follow=20
that
> >    > restriction just like net does.
>=20
> >    Networking has its own namespace and it looks like all devices get
> >    created while in that namespace.
>=20
> No, it is like tpm, a cannonical example is something like:
>=20
>  ip netns add blue
>  ip link add veth0 type veth peer name veth1
>  ip link set veth1 netns blue

True.

>=20
> To move an interface, which presumably moves the sysfs stuff as
> well. Seems exactly like a mode that could work for TPM.
>=20
> >    clone(), a long time after current registration with sysfs. Another
> >    difference is that we don't have a device namespace, so all our=20
device
> >    names and major / minor numbers need to be unique and that's also
> >    reflected in sysfs.
>=20
> major/minor numbers do not need to be unique, the mapping of TPM ID to
> physical TPM is something a namespace should control, eg TPM ID 0 is
> always major/minor 10:224, and can be routed to which ever tpm is
> correct for the namespace of the accessing process.

Though you would agree that the device gets created in the host=20
'namespace' first and then is moved into a namespace? We would then=20
emulate the major/minor assignment (misc device oddity and so on) in the=20
container management stack and assign the first 10:224 inside the=20
container? Would the move make the device disappear on the host's main=20
namespace? Like /dev/tpm2 now being moved into a namespace and it=20
disappearing on the host?

Then in tpm=5Fopen() (as well as all the other functions) we would not get =

the chip the way we do now but by checking the user namespace to determine =

from where the open() is coming from and then search an ordered list of=20
chips associated with that namespace and get the first entry? One would=20
have to be able to conclude from the inode or file what major/minor number =

the device is associated with.

       struct tpm=5Fchip *chip =3D
               container=5Fof(inode->i=5Fcdev, struct tpm=5Fchip, cdev);

Well, I guess that part of this  would involve a level of indirection=20
approximately like this:

struct tpm=5Ffile *tf =3D container=5Fof(inode->i=5Fcdev, struct tpm=5Ffile=
, cdev);

struct tpm=5Fchip *chip =3D tpm=5Ffind=5Fchip=5Fby=5Fnamespace(current=5Fus=
er=5Fns(),=20
tf->major, rf->minor);



>=20
> Same for sysfs, within the namespace the vtpm should appear as tpm0.
>=20
> >    I have been experimenting with an ioctl that passes along a file
> >    descriptor to a user namespace (/proc/pid/ns/user) for the purpose=20
of
> >    associating the vtpm with that user namespace.
>=20
> I would have thought you'd use the IMA namespace for this, seems more
> natural?

I am not yet sure. Maybe it's too early to talk about this ioctl.=20

Can we upstream the current driver with patches 1 - 9?


>=20
> Functionally it doesn't matter, which ever name space is used, migrate
> the sysfs stuff similar to net and virtualize all the ID.
>=20
> >    time option). Here we need to ensure that the child gets the chip
> >    hooked to the IMA namespace before the execve() triggers=20
measurements
> >    by IMA. Here I pass the process Id of that child to then determine=20
IMA
> >    namespace to hook the chip to and user namespace for vTPM sysfs
> >    association. I prefer the child's process id over passing two file
> >    descriptors in this case...
>=20
> I'm sure people familiar with namespaces/etc will have suggestions on
> how to build the uapi side.

Yes, not quite clear about which way is the best.=20

>=20
> I still intensely dislike the use of an ioctl on vtpm because
> namespaces will have to be a core tpm feature, an ioctl on the
> /dev/tpmX fd would be more approriate.

So that would be to move a hardware TPM into a container. If the=20
namespacing implementation would need to be device-specific, it could call =

a function on the chip to do that.

   Stefan



--=_alternative 0079EEB285257F64_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/25/2016 03:31:17 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Thu, Feb 25, 2016 at 01:42:10PM -0500, Stefan Berger wrote=
:<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;It looks like they some are being used=
 on the kobject
level.<br>&gt; <br>&gt; Yes, struct devices are kobjects.<br>&gt; <br>&gt; =
&gt; &nbsp; &nbsp;&gt; Once you figure out how to define what TPMs
are in a namespace it<br>&gt; &gt; &nbsp; &nbsp;&gt; should be doable to us=
e the syfs=5Fns APIs to
have sysfs follow that<br>&gt; &gt; &nbsp; &nbsp;&gt; restriction just like=
 net does.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;Networking has its own namesp=
ace and it looks like
all devices get<br>&gt; &gt; &nbsp; &nbsp;created while in that namespace.<=
br>&gt; <br>&gt; No, it is like tpm, a cannonical example is something like=
:<br>&gt; <br>&gt; &nbsp;ip netns add blue<br>&gt; &nbsp;ip link add veth0 =
type veth peer name veth1<br>&gt; &nbsp;ip link set veth1 netns blue</font>=
</tt><br><br><tt><font size=3D2>True.<br></font></tt><br><tt><font size=3D2=
>&gt; <br>&gt; To move an interface, which presumably moves the sysfs stuff=
 as<br>&gt; well. Seems exactly like a mode that could work for TPM.<br>&gt=
; <br>&gt; &gt; &nbsp; &nbsp;clone(), a long time after current registration
with sysfs. Another<br>&gt; &gt; &nbsp; &nbsp;difference is that we don't h=
ave a device namespace,
so all our device<br>&gt; &gt; &nbsp; &nbsp;names and major / minor numbers=
 need to be unique
and that's also<br>&gt; &gt; &nbsp; &nbsp;reflected in sysfs.<br>&gt; <br>&=
gt; major/minor numbers do not need to be unique, the mapping of TPM ID
to<br>&gt; physical TPM is something a namespace should control, eg TPM ID 0
is<br>&gt; always major/minor 10:224, and can be routed to which ever tpm i=
s<br>&gt; correct for the namespace of the accessing process.</font></tt><b=
r><br><tt><font size=3D2>Though you would agree that the device gets created
in the host 'namespace' first and then is moved into a namespace? We would
then emulate the major/minor assignment (misc device oddity and so on)
in the container management stack and assign the first 10:224 inside the
container? Would the move make the device disappear on the host's main
namespace? Like /dev/tpm2 now being moved into a namespace and it disappear=
ing
on the host?</font></tt><br><br><tt><font size=3D2>Then in tpm=5Fopen() (as=
 well as all the other functions)
we would not get the chip the way we do now but by checking the user namesp=
ace
to determine from where the open() is coming from and then search an ordered
list of chips associated with that namespace and get the first entry? One
would have to be able to conclude from the inode or file what major/minor
number the device is associated with.</font></tt><br><br><tt><font size=3D3=
>&nbsp; &nbsp; &nbsp; &nbsp;struct </font></tt><a href=3D"http://lxr.free-e=
lectrons.com/ident?i=3Dtpm=5Fchip"><tt><font size=3D3 color=3Dblue><u>tpm=
=5Fchip</u></font></tt></a><tt><font size=3D3>*</font></tt><a href=3D"http:=
//lxr.free-electrons.com/ident?i=3Dchip"><tt><font size=3D3 color=3Dblue><u=
>chip</u></font></tt></a><tt><font size=3D3>=3D<br> &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; </font></tt><a href=3D"http://lxr.free-electrons.=
com/ident?i=3Dcontainer=5Fof"><tt><font size=3D3 color=3Dblue><u>container=
=5Fof</u></font></tt></a><tt><font size=3D3>(</font></tt><a href=3D"http://=
lxr.free-electrons.com/ident?i=3Dinode"><tt><font size=3D3 color=3Dblue><u>=
inode</u></font></tt></a><tt><font size=3D3>-&gt;i=5Fcdev,
struct </font></tt><a href=3D"http://lxr.free-electrons.com/ident?i=3Dtpm=
=5Fchip"><tt><font size=3D3 color=3Dblue><u>tpm=5Fchip</u></font></tt></a><=
tt><font size=3D3>,
</font></tt><a href=3D"http://lxr.free-electrons.com/ident?i=3Dcdev"><tt><f=
ont size=3D3 color=3Dblue><u>cdev</u></font></tt></a><tt><font size=3D3>);<=
/font></tt><br><br><tt><font size=3D2>Well, I guess that part of this &nbsp=
;would involve
a level of indirection approximately like this:</font></tt><br><br><tt><fon=
t size=3D2>struct tpm=5Ffile *tf =3D container=5Fof(inode-&gt;i=5Fcdev,
struct tpm=5Ffile, cdev);</font></tt><br><br><tt><font size=3D2>struct tpm=
=5Fchip *chip =3D tpm=5Ffind=5Fchip=5Fby=5Fnamespace(current=5Fuser=5Fns(),
tf-&gt;major, rf-&gt;minor);</font></tt><br><br><br><tt><font size=3D2><br>=
&gt; <br>&gt; Same for sysfs, within the namespace the vtpm should appear a=
s tpm0.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;I have been experimenting with a=
n ioctl that passes
along a file<br>&gt; &gt; &nbsp; &nbsp;descriptor to a user namespace (/pro=
c/pid/ns/user)
for the purpose of<br>&gt; &gt; &nbsp; &nbsp;associating the vtpm with that=
 user namespace.<br>&gt; <br>&gt; I would have thought you'd use the IMA na=
mespace for this, seems more<br>&gt; natural?</font></tt><br><br><tt><font =
size=3D2>I am not yet sure. Maybe it's too early to talk about
this ioctl. </font></tt><br><br><tt><font size=3D2>Can we upstream the curr=
ent driver with patches 1
- 9?</font></tt><br><br><tt><font size=3D2><br>&gt; <br>&gt; Functionally i=
t doesn't matter, which ever name space is used, migrate<br>&gt; the sysfs =
stuff similar to net and virtualize all the ID.<br>&gt; <br>&gt; &gt; &nbsp=
; &nbsp;time option). Here we need to ensure that the child
gets the chip<br>&gt; &gt; &nbsp; &nbsp;hooked to the IMA namespace before =
the execve()
triggers measurements<br>&gt; &gt; &nbsp; &nbsp;by IMA. Here I pass the pro=
cess Id of that child
to then determine IMA<br>&gt; &gt; &nbsp; &nbsp;namespace to hook the chip =
to and user namespace
for vTPM sysfs<br>&gt; &gt; &nbsp; &nbsp;association. I prefer the child's =
process id over
passing two file<br>&gt; &gt; &nbsp; &nbsp;descriptors in this case...<br>&=
gt; <br>&gt; I'm sure people familiar with namespaces/etc will have suggest=
ions
on<br>&gt; how to build the uapi side.</font></tt><br><br><tt><font size=3D=
2>Yes, not quite clear about which way is the best.
</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; I still intensely disl=
ike the use of an ioctl on vtpm because<br>&gt; namespaces will have to be =
a core tpm feature, an ioctl on the<br>&gt; /dev/tpmX fd would be more appr=
oriate.</font></tt><br><br><tt><font size=3D2>So that would be to move a ha=
rdware TPM into a container.
If the namespacing implementation would need to be device-specific, it
could call a function on the chip to do that.</font></tt><br><br><tt><font =
size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 0079EEB285257F64_=--



--===============6016538208433309735==
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
--===============6016538208433309735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6016538208433309735==--
