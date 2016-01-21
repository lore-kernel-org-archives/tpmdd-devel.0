From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 20 Jan 2016 22:56:21 -0500
Message-ID: <201601210356.u0L3uQ0A002313@d03av03.boulder.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4590750843700430917=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160121032115.GA26266-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============4590750843700430917==
Content-Type: multipart/alternative;
	boundary="=_alternative 0015A4C985257F41_="


--=_alternative 0015A4C985257F41_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/20/2016=20
10:21:15 PM:

>=20
> On Wed, Jan 20, 2016 at 10:01:38PM -0500, Stefan Berger wrote:
> > > On Wed, Jan 20, 2016 at 09:39:09AM -0500, Stefan Berger wrote:
> > > >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
01/19/2016
> > > >    06:51:07 PM:
> > > >    >
> > > >    > On Thu, Jan 14, 2016 at 11:01:57AM -0500, Stefan Berger=20
wrote:
> > > >    > > +   pdev =3D platform=5Fdevice=5Fregister=5Fsimple("tpm=5Fvt=
pm",=20
> > > vtpm=5Fdev->dev=5Fnum,
> > > >    > > +                      NULL, 0);
> > > >    >
> > > >    > This seems strange, something like this should not be=20
creating
> > > >    > platform=5Fdevices.
> > > >    Should it be a misc=5Fdevice then ?
> > >
> > > No. Check what other virtual devices are doing..
> >=20
> > register=5Fchrdev maybe?
>=20
> ?? that doesn't replace a platform=5Fdevice
>=20
> > > Except that isn't good enough - the IMA kernel side doesn't knowthat =

this
> > > tpm is now acting as the 'main' 'default' TPM.
> >=20
> > Hooking the vTPM to IMA requires another patch that I haven't=20
> shown since IMA
> > namespacing isn't public yet. Basically we implement another ioctl
> () that is to
> > be called before the clone() in order to 'reserve' a vtpm device=20
> pair for the
> > calling process. During the clone() call IMA namespacing code can=20
query the
> > vTPM driver for a 'reserved' device pair. Hooking IMA up after the
> clone() may
> > also work but in case of docker/golang it's better to do this=20
> before since the
> > language libraries do a lot after the clone automatically.
>=20
> That sounds very complicated, wouldn't you just specify the TPM index to =

use
> in the IMA namespace when it is created?

The IMA namespace is created as part of clone(). You cannot pass anything=20
via clone(). So you either have to do it before or immediately after. If=20
after is too later for whatever reason, you have to do it before.

>=20
> > So here things aren't so clear to me, either. Sysfs should really=20
> only show the
> > devices that are relevant to a container, but it seems to show a lot
> > more than
>=20
> I think what you are missing is that nobody uses mainline containers
> for the kind of strong isolation you are thinking about. Out-of-tree
> patches are used by those people and, as I understand it, they cover
> all these issues.

?? Out-of-tree patches?

>=20
> So, in mainline, the correct thing to do is nothing, and realize that
> people who would care about pcr isolation between containers won't run
> mainline anyhow. Work with the out-of-tree people to make sure things
> work properly until they get the other bits in mainline.

Now one just needs to find those poeple.
Basically you suggest to ignore the potential leaking between containers.=20
Just register with sysfs ?

>=20
> At least that is my impression of the state of affairs, someone more
> involved may know better.
>=20
> > > The huge downside to using a master side dev node is that these=20
things
> > > will leak. Killing the vtpm daemon will not clean up the slave
> > > interface and another command and sysadmin interaction will be=20
needed
> > > to sort out the inevitable mess.
> >=20
> > This is a scenario that works, though.
>=20
> So you already implemented the same semantics as I talked about, a clean
> up on close?

It's part of the existing patch, yes. A flag gives a choice to keep it=20
around, or if not set and the server close()s, the pair disappears.

>=20
> Then just return the fd like I said.

Any driver that can be used as an example ?

>=20
> auto-delete a master char dev on close is a very strange API, don't do
> that.

What I called cleanup can be trigger by the vTPM closing /dev/vtpms%d, so=20
the server-side. What is the master for you? /dev/vtpmx where we run the=20
ioctls on?

  Stefan

>=20
> Jason
>=20



--=_alternative 0015A4C985257F41_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/20/2016 10:21:15 PM:<br><br>&gt; <br>&gt; On Wed, Jan 20, 2016 =
at 10:01:38PM -0500, Stefan Berger wrote:<br>&gt; &gt; &gt; On Wed, Jan 20,=
 2016 at 09:39:09AM -0500, Stefan Berger
wrote:<br>&gt; &gt; &gt; &gt; &nbsp; &nbsp;Jason Gunthorpe &lt;jgunthorpe@o=
bsidianresearch.com&gt;
wrote on 01/19/2016<br>&gt; &gt; &gt; &gt; &nbsp; &nbsp;06:51:07 PM:<br>&gt=
; &gt; &gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &gt; &gt; &nbsp; &nbsp;&gt;=
 On Thu, Jan 14, 2016 at 11:01:57AM
-0500, Stefan Berger wrote:<br>&gt; &gt; &gt; &gt; &nbsp; &nbsp;&gt; &gt; +=
 &nbsp; pdev =3D platform=5Fdevice=5Fregister=5Fsimple(&quot;tpm=5Fvtpm&quo=
t;,
&nbsp;<br>&gt; &gt; &gt; vtpm=5Fdev-&gt;dev=5Fnum,<br>&gt; &gt; &gt; &gt; &=
nbsp; &nbsp;&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;NULL, 0);<br>&gt; &gt; &gt;=
 &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &gt; &gt; &nbsp; &nbsp;&gt; This seems=
 strange, something like
this should not be creating<br>&gt; &gt; &gt; &gt; &nbsp; &nbsp;&gt; platfo=
rm=5Fdevices.<br>&gt; &gt; &gt; &gt; &nbsp; &nbsp;Should it be a misc=5Fdev=
ice then ?<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; No. Check what other virtual=
 devices are doing..<br>&gt; &gt; <br>&gt; &gt; register=5Fchrdev maybe?<br=
>&gt; <br>&gt; ?? that doesn't replace a platform=5Fdevice</font></tt><br><=
tt><font size=3D2>&gt; <br>&gt; &gt; &gt; Except that isn't good enough - t=
he IMA kernel side doesn't
knowthat this<br>&gt; &gt; &gt; tpm is now acting as the 'main' 'default' T=
PM.<br>&gt; &gt; <br>&gt; &gt; Hooking the vTPM to IMA requires another pat=
ch that I haven't
<br>&gt; shown since IMA<br>&gt; &gt; namespacing isn't public yet. Basical=
ly we implement another
ioctl<br>&gt; () that is to<br>&gt; &gt; be called before the clone() in or=
der to 'reserve' a vtpm device
<br>&gt; pair for the<br>&gt; &gt; calling process. During the clone() call=
 IMA namespacing code
can query the<br>&gt; &gt; vTPM driver for a 'reserved' device pair. Hookin=
g IMA up after
the<br>&gt; clone() may<br>&gt; &gt; also work but in case of docker/golang=
 it's better to do this
<br>&gt; before since the<br>&gt; &gt; language libraries do a lot after th=
e clone automatically.<br>&gt; <br>&gt; That sounds very complicated, would=
n't you just specify the TPM index
to use<br>&gt; in the IMA namespace when it is created?</font></tt><br><br>=
<tt><font size=3D2>The IMA namespace is created as part of clone(). You
cannot pass anything via clone(). So you either have to do it before or
immediately after. If after is too later for whatever reason, you have
to do it before.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; &gt; S=
o here things aren't so clear to me, either. Sysfs should really
<br>&gt; only show the<br>&gt; &gt; devices that are relevant to a containe=
r, but it seems to show
a lot<br>&gt; &gt; more than<br>&gt; <br>&gt; I think what you are missing =
is that nobody uses mainline containers<br>&gt; for the kind of strong isol=
ation you are thinking about. Out-of-tree<br>&gt; patches are used by those=
 people and, as I understand it, they cover<br>&gt; all these issues.</font=
></tt><br><br><tt><font size=3D2>?? Out-of-tree patches?</font></tt><br><tt=
><font size=3D2><br>&gt; <br>&gt; So, in mainline, the correct thing to do =
is nothing, and realize that<br>&gt; people who would care about pcr isolat=
ion between containers won't
run<br>&gt; mainline anyhow. Work with the out-of-tree people to make sure =
things<br>&gt; work properly until they get the other bits in mainline.</fo=
nt></tt><br><br><tt><font size=3D2>Now one just needs to find those poeple.=
</font></tt><br><tt><font size=3D2>Basically you suggest to ignore the pote=
ntial leaking
between containers. Just register with sysfs ?</font></tt><br><tt><font siz=
e=3D2><br>&gt; <br>&gt; At least that is my impression of the state of affa=
irs, someone more<br>&gt; involved may know better.<br>&gt; <br>&gt; &gt; &=
gt; The huge downside to using a master side dev node is that
these things<br>&gt; &gt; &gt; will leak. Killing the vtpm daemon will not =
clean up the
slave<br>&gt; &gt; &gt; interface and another command and sysadmin interact=
ion will
be needed<br>&gt; &gt; &gt; to sort out the inevitable mess.<br>&gt; &gt; <=
br>&gt; &gt; This is a scenario that works, though.<br>&gt; <br>&gt; So you=
 already implemented the same semantics as I talked about, a
clean<br>&gt; up on close?</font></tt><br><br><tt><font size=3D2>It's part =
of the existing patch, yes. A flag gives
a choice to keep it around, or if not set and the server close()s, the
pair disappears.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Then j=
ust return the fd like I said.</font></tt><br><br><tt><font size=3D2>Any dr=
iver that can be used as an example ?</font></tt><br><tt><font size=3D2><br=
>&gt; <br>&gt; auto-delete a master char dev on close is a very strange API=
, don't
do<br>&gt; that.</font></tt><br><br><tt><font size=3D2>What I called cleanu=
p can be trigger by the vTPM closing
/dev/vtpms%d, so the server-side. What is the master for you? /dev/vtpmx
where we run the ioctls on?</font></tt><br><br><tt><font size=3D2>&nbsp; St=
efan</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Jason<br>&gt; <br>=
</font></tt><BR>
--=_alternative 0015A4C985257F41_=--



--===============4590750843700430917==
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
--===============4590750843700430917==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4590750843700430917==--
