From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/4] tpm: validate TPM 2.0 commands
Date: Wed, 4 Jan 2017 13:59:05 -0500
Message-ID: <OF3FD1DF4F.FB87C3F2-ON0025809E.00682E9B-8525809E.00684A8A@notes.na.collabserv.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-3-jarkko.sakkinen@linux.intel.com>
	<OF8D508BD2.EAB22BFD-ON0025809E.0062B40C-8525809E.006356C3@notes.na.collabserv.com>
	<1483553976.2561.38.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3252333643743349516=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1483553976.2561.38.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============3252333643743349516==
Content-Type: multipart/alternative;
	boundary="=_alternative 00684A888525809E_="


--=_alternative 00684A888525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote on 01/04/2017 01:19:36 PM:

> From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> To: Stefan Berger/Watson/IBM@IBMUS, Jarkko Sakkinen=20
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-
> devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Date: 01/04/2017 01:19 PM
> Subject: Re: [tpmdd-devel] [PATCH RFC 2/4] tpm: validate TPM 2.0=20
commands
>=20
> On Wed, 2017-01-04 at 13:04 -0500, Stefan Berger wrote:
> > Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/02/2017
> > 08:22:08 AM:
> >=20
> > > --- a/drivers/char/tpm/tpm2-cmd.c
> > > +++ b/drivers/char/tpm/tpm2-cmd.c
> > > @@ -943,7 +943,9 @@ EXPORT=5FSYMBOL=5FGPL(tpm2=5Fprobe);
> > >   */
> > >  int tpm2=5Fauto=5Fstartup(struct tpm=5Fchip *chip)
> > >  {
> > > +   u32 nr=5Fcommands;
> > >     int rc;
> > > +   int i;
> > >=20
> > >     rc =3D tpm=5Fget=5Ftimeouts(chip);
> > >     if (rc)
> > > @@ -967,8 +969,49 @@ int tpm2=5Fauto=5Fstartup(struct tpm=5Fchip *chi=
p)
> > >        }
> > >     }
> > >=20
> > > +   rc =3D tpm2=5Fget=5Ftpm=5Fpt(chip, TPM=5FPT=5FTOTAL=5FCOMMANDS, &=
nr=5Fcommands,
> > NULL);
> > > +   if (rc)
> > > +      return rc;
> > > +
> > > +   chip->cc=5Fattrs=5Ftbl =3D devm=5Fkzalloc(&chip->dev, 4 * nr=5Fco=
mmands,
> > > +                 GFP=5FKERNEL);
> >=20
> > For some reason this devm=5Fkzalloc bombs for the vtpm proxy driver.=20
> > The only reason I could come up with is that it's being called before
> > tpm=5Fadd=5Fchar=5Fdevice() has been called.
>=20
> No, it should be sufficient that chip->dev be initialized (which it is
> in tpm=5Fchip=5Falloc()).  What's the error you're getting?
>=20
> It does look like the intention was to have non-devm with
> tpm=5Fchip=5Falloc() and devm with tpmm=5Fchip=5Falloc(), but devm=5Fkzal=
loc
> should just work regardless because it's tied to the device model.

I am running a vtpm proxy test suite. Here's the error:

[   67.596172] tpm tpm1: Operation Canceled
[   67.699052] ------------[ cut here ]------------
[   67.699811] WARNING: CPU: 12 PID: 870 at mm/page=5Falloc.c:3511=20
=5F=5Falloc=5Fpages=5Fslowpath+0x771/0xaf0
[   67.701198] Modules linked in:
[   67.701400]  tpm=5Fvtpm=5Fproxy
[   67.701642]  nf=5Fconntrack=5Fnetbios=5Fns nf=5Fconntrack=5Fbroadcast
[   67.702450]  ip6t=5Frpfilter
[   67.702662]  ip6t=5FREJECT nf=5Freject=5Fipv6 xt=5Fconntrack ebtable=5Fn=
at
[   67.703618]  ebtable=5Fbroute
[   67.703784]  bridge stp llc ebtable=5Ffilter
[   67.704213]  ebtables
[   67.704367]  ip6table=5Fnat nf=5Fconntrack=5Fipv6 nf=5Fdefrag=5Fipv6
[   67.705310]  nf=5Fnat=5Fipv6
[   67.705523]  ip6table=5Fmangle ip6table=5Fsecurity ip6table=5Fraw=20
ip6table=5Ffilter ip6=5Ftables iptable=5Fnat nf=5Fconntrack=5Fipv4 nf=5Fdef=
rag=5Fipv4=20
nf=5Fnat=5Fipv4 nf=5Fnat nf=5Fconntrack iptable=5Fmangle iptable=5Fsecurity=
=20
iptable=5Fraw nfsd auth=5Frpcgss nfs=5Facl lockd crc32c=5Fintel tpm=5Ftis=20
virtio=5Fballoon i2c=5Fpiix4 tpm=5Ftis=5Fcore
[   67.711414]  i2c=5Fcore
[   67.711610]  joydev tpm pcspkr grace sunrpc
[   67.712170]  8139too
[   67.712360]  virtio=5Fpci 8139cp virtio=5Fring serio=5Fraw
[   67.713504]  ata=5Fgeneric
[   67.713706]  mii floppy pata=5Facpi virtio
[   67.714891] CPU: 12 PID: 870 Comm: kworker/12:2 Not tainted 4.9.0-rc5+=20
#652
[   67.715054] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =

rel-1.10.1-0-g8891697-prebuilt.qemu-project.org 04/01/2014
[   67.715054] Workqueue: tpm-vtpm vtpm=5Fproxy=5Fwork [tpm=5Fvtpm=5Fproxy]
[   67.715054]  ffffc90002b6fa80 ffffffff8140cad1
[   67.715054]  0000000000000000
[   67.715054]  0000000000000000
[   67.715054]  ffffc90002b6fac0 ffffffff810a8b6b 00000db7aba7d298=20
00000000026000c0
[   67.715054]  0000000000000000 0000000000000014 000000000260c0c0=20
ffff8802aba7ca00
[   67.715054] Call Trace:
[   67.715054]  [<ffffffff8140cad1>] dump=5Fstack+0x63/0x82
[   67.715054]  [<ffffffff810a8b6b>] =5F=5Fwarn+0xcb/0xf0
[   67.715054]  [<ffffffff810a8c9d>] warn=5Fslowpath=5Fnull+0x1d/0x20
[   67.715054]  [<ffffffff811da6f1>] =5F=5Falloc=5Fpages=5Fslowpath+0x771/0=
xaf0
[   67.715054]  [<ffffffff811d95e6>] ? get=5Fpage=5Ffrom=5Ffreelist+0x526/0=
xaf0
[   67.715054]  [<ffffffff8179e583>] ? =5F=5Fmutex=5Funlock=5Fslowpath+0xe3=
/0x1a0
[   67.715054]  [<ffffffff811dad9f>] =5F=5Falloc=5Fpages=5Fnodemask+0x32f/0=
x390
[   67.715054]  [<ffffffff8123a4fe>] kmalloc=5Flarge=5Fnode+0x7e/0xe0
[   67.715054]  [<ffffffff81241885>]=20
=5F=5Fkmalloc=5Fnode=5Ftrack=5Fcaller+0x225/0x2c0
[   67.715054]  [<ffffffffa00c0f42>] ? tpm2=5Fauto=5Fstartup+0xa2/0x2e0 [tp=
m]
[   67.715054]  [<ffffffff815572b7>] devm=5Fkmalloc+0x27/0x70
[   67.715054]  [<ffffffffa00c0f42>] tpm2=5Fauto=5Fstartup+0xa2/0x2e0 [tpm]
[   67.715054]  [<ffffffffa00bf3bc>] tpm=5Fchip=5Fregister+0x5c/0x200 [tpm]
[   67.715054]  [<ffffffffa029c309>] vtpm=5Fproxy=5Fwork+0x19/0x40=20
[tpm=5Fvtpm=5Fproxy]
[   67.715054]  [<ffffffff810c4593>] process=5Fone=5Fwork+0x1f3/0x560
[   67.715054]  [<ffffffff810c4511>] ? process=5Fone=5Fwork+0x171/0x560
[   67.715054]  [<ffffffff810c494e>] worker=5Fthread+0x4e/0x480
[   67.715054]  [<ffffffff810c4900>] ? process=5Fone=5Fwork+0x560/0x560
[   67.715054]  [<ffffffff810c4900>] ? process=5Fone=5Fwork+0x560/0x560
[   67.715054]  [<ffffffff810ca994>] kthread+0xf4/0x110
[   67.715054]  [<ffffffff810ca8a0>] ? kthread=5Fpark+0x60/0x60
[   67.715054]  [<ffffffff817a1c15>] ret=5Ffrom=5Ffork+0x25/0x30
[   67.746343] ---[ end trace 4d9abf66365987bd ]---




--=_alternative 00684A888525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>James Bottomley &lt;jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt; wrote
on 01/04/2017 01:19:36 PM:<br><br>&gt; From: James Bottomley &lt;jejb@linux=
.vnet.ibm.com&gt;</font></tt><br><tt><font size=3D2>&gt; To: Stefan Berger/=
Watson/IBM@IBMUS, Jarkko Sakkinen
<br>&gt; &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;</font></tt><br><tt><font s=
ize=3D2>&gt; Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-<br>&gt; deve=
l@lists.sourceforge.net, open list &lt;linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org&gt;</fo=
nt></tt><br><tt><font size=3D2>&gt; Date: 01/04/2017 01:19 PM</font></tt><b=
r><tt><font size=3D2>&gt; Subject: Re: [tpmdd-devel] [PATCH RFC 2/4] tpm:
validate TPM 2.0 commands</font></tt><br><tt><font size=3D2>&gt; <br>&gt; O=
n Wed, 2017-01-04 at 13:04 -0500, Stefan Berger wrote:<br>&gt; &gt; Jarkko =
Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt; wrote
on 01/02/2017<br>&gt; &gt; 08:22:08 AM:<br>&gt; &gt; <br>&gt; &gt; &gt; ---=
 a/drivers/char/tpm/tpm2-cmd.c<br>&gt; &gt; &gt; +++ b/drivers/char/tpm/tpm=
2-cmd.c<br>&gt; &gt; &gt; @@ -943,7 +943,9 @@ EXPORT=5FSYMBOL=5FGPL(tpm2=5F=
probe);<br>&gt; &gt; &gt; &nbsp; */<br>&gt; &gt; &gt; &nbsp;int tpm2=5Fauto=
=5Fstartup(struct tpm=5Fchip *chip)<br>&gt; &gt; &gt; &nbsp;{<br>&gt; &gt; =
&gt; + &nbsp; u32 nr=5Fcommands;<br>&gt; &gt; &gt; &nbsp; &nbsp; int rc;<br=
>&gt; &gt; &gt; + &nbsp; int i;<br>&gt; &gt; &gt; <br>&gt; &gt; &gt; &nbsp;=
 &nbsp; rc =3D tpm=5Fget=5Ftimeouts(chip);<br>&gt; &gt; &gt; &nbsp; &nbsp; =
if (rc)<br>&gt; &gt; &gt; @@ -967,8 +969,49 @@ int tpm2=5Fauto=5Fstartup(st=
ruct tpm=5Fchip
*chip)<br>&gt; &gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp;}<br>&gt; &gt; &gt; &nb=
sp; &nbsp; }<br>&gt; &gt; &gt; <br>&gt; &gt; &gt; + &nbsp; rc =3D tpm2=5Fge=
t=5Ftpm=5Fpt(chip, TPM=5FPT=5FTOTAL=5FCOMMANDS,
&amp;nr=5Fcommands,<br>&gt; &gt; NULL);<br>&gt; &gt; &gt; + &nbsp; if (rc)<=
br>&gt; &gt; &gt; + &nbsp; &nbsp; &nbsp;return rc;<br>&gt; &gt; &gt; +<br>&=
gt; &gt; &gt; + &nbsp; chip-&gt;cc=5Fattrs=5Ftbl =3D devm=5Fkzalloc(&amp;ch=
ip-&gt;dev,
4 * nr=5Fcommands,<br>&gt; &gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp;
GFP=5FKERNEL);<br>&gt; &gt; <br>&gt; &gt; For some reason this devm=5Fkzall=
oc bombs for the vtpm proxy driver.
<br>&gt; &gt; The only reason I could come up with is that it's being called
before<br>&gt; &gt; tpm=5Fadd=5Fchar=5Fdevice() has been called.<br>&gt; <b=
r>&gt; No, it should be sufficient that chip-&gt;dev be initialized (which
it is<br>&gt; in tpm=5Fchip=5Falloc()). &nbsp;What's the error you're getti=
ng?<br>&gt; <br>&gt; It does look like the intention was to have non-devm w=
ith<br>&gt; tpm=5Fchip=5Falloc() and devm with tpmm=5Fchip=5Falloc(), but d=
evm=5Fkzalloc<br>&gt; should just work regardless because it's tied to the =
device model.</font></tt><br><br><tt><font size=3D2>I am running a vtpm pro=
xy test suite. Here's the error:</font></tt><br><br><tt><font size=3D2>[ &n=
bsp; 67.596172] tpm tpm1: Operation Canceled</font></tt><br><tt><font size=
=3D2>[ &nbsp; 67.699052] ------------[ cut here ]------------</font></tt><b=
r><tt><font size=3D2>[ &nbsp; 67.699811] WARNING: CPU: 12 PID: 870 at mm/pa=
ge=5Falloc.c:3511
=5F=5Falloc=5Fpages=5Fslowpath+0x771/0xaf0</font></tt><br><tt><font size=3D=
2>[ &nbsp; 67.701198] Modules linked in:</font></tt><br><tt><font size=3D2>=
[ &nbsp; 67.701400] &nbsp;tpm=5Fvtpm=5Fproxy</font></tt><br><tt><font size=
=3D2>[ &nbsp; 67.701642] &nbsp;nf=5Fconntrack=5Fnetbios=5Fns
nf=5Fconntrack=5Fbroadcast</font></tt><br><tt><font size=3D2>[ &nbsp; 67.70=
2450] &nbsp;ip6t=5Frpfilter</font></tt><br><tt><font size=3D2>[ &nbsp; 67.7=
02662] &nbsp;ip6t=5FREJECT nf=5Freject=5Fipv6
xt=5Fconntrack ebtable=5Fnat</font></tt><br><tt><font size=3D2>[ &nbsp; 67.=
703618] &nbsp;ebtable=5Fbroute</font></tt><br><tt><font size=3D2>[ &nbsp; 6=
7.703784] &nbsp;bridge stp llc ebtable=5Ffilter</font></tt><br><tt><font si=
ze=3D2>[ &nbsp; 67.704213] &nbsp;ebtables</font></tt><br><tt><font size=3D2=
>[ &nbsp; 67.704367] &nbsp;ip6table=5Fnat nf=5Fconntrack=5Fipv6
nf=5Fdefrag=5Fipv6</font></tt><br><tt><font size=3D2>[ &nbsp; 67.705310] &n=
bsp;nf=5Fnat=5Fipv6</font></tt><br><tt><font size=3D2>[ &nbsp; 67.705523] &=
nbsp;ip6table=5Fmangle ip6table=5Fsecurity
ip6table=5Fraw ip6table=5Ffilter ip6=5Ftables iptable=5Fnat nf=5Fconntrack=
=5Fipv4 nf=5Fdefrag=5Fipv4
nf=5Fnat=5Fipv4 nf=5Fnat nf=5Fconntrack iptable=5Fmangle iptable=5Fsecurity=
 iptable=5Fraw
nfsd auth=5Frpcgss nfs=5Facl lockd crc32c=5Fintel tpm=5Ftis virtio=5Fballoo=
n i2c=5Fpiix4
tpm=5Ftis=5Fcore</font></tt><br><tt><font size=3D2>[ &nbsp; 67.711414] &nbs=
p;i2c=5Fcore</font></tt><br><tt><font size=3D2>[ &nbsp; 67.711610] &nbsp;jo=
ydev tpm pcspkr grace
sunrpc</font></tt><br><tt><font size=3D2>[ &nbsp; 67.712170] &nbsp;8139too<=
/font></tt><br><tt><font size=3D2>[ &nbsp; 67.712360] &nbsp;virtio=5Fpci 81=
39cp virtio=5Fring
serio=5Fraw</font></tt><br><tt><font size=3D2>[ &nbsp; 67.713504] &nbsp;ata=
=5Fgeneric</font></tt><br><tt><font size=3D2>[ &nbsp; 67.713706] &nbsp;mii =
floppy pata=5Facpi virtio</font></tt><br><tt><font size=3D2>[ &nbsp; 67.714=
891] CPU: 12 PID: 870 Comm: kworker/12:2
Not tainted 4.9.0-rc5+ #652</font></tt><br><tt><font size=3D2>[ &nbsp; 67.7=
15054] Hardware name: QEMU Standard PC
(i440FX + PIIX, 1996), BIOS rel-1.10.1-0-g8891697-prebuilt.qemu-project.org
04/01/2014</font></tt><br><tt><font size=3D2>[ &nbsp; 67.715054] Workqueue:=
 tpm-vtpm vtpm=5Fproxy=5Fwork
[tpm=5Fvtpm=5Fproxy]</font></tt><br><tt><font size=3D2>[ &nbsp; 67.715054] =
&nbsp;ffffc90002b6fa80 ffffffff8140cad1</font></tt><br><tt><font size=3D2>[=
 &nbsp; 67.715054] &nbsp;0000000000000000</font></tt><br><tt><font size=3D2=
>[ &nbsp; 67.715054] &nbsp;0000000000000000</font></tt><br><tt><font size=
=3D2>[ &nbsp; 67.715054] &nbsp;ffffc90002b6fac0 ffffffff810a8b6b
00000db7aba7d298 00000000026000c0</font></tt><br><tt><font size=3D2>[ &nbsp=
; 67.715054] &nbsp;0000000000000000 0000000000000014
000000000260c0c0 ffff8802aba7ca00</font></tt><br><tt><font size=3D2>[ &nbsp=
; 67.715054] Call Trace:</font></tt><br><tt><font size=3D2>[ &nbsp; 67.7150=
54] &nbsp;[&lt;ffffffff8140cad1&gt;]
dump=5Fstack+0x63/0x82</font></tt><br><tt><font size=3D2>[ &nbsp; 67.715054=
] &nbsp;[&lt;ffffffff810a8b6b&gt;]
=5F=5Fwarn+0xcb/0xf0</font></tt><br><tt><font size=3D2>[ &nbsp; 67.715054] =
&nbsp;[&lt;ffffffff810a8c9d&gt;]
warn=5Fslowpath=5Fnull+0x1d/0x20</font></tt><br><tt><font size=3D2>[ &nbsp;=
 67.715054] &nbsp;[&lt;ffffffff811da6f1&gt;]
=5F=5Falloc=5Fpages=5Fslowpath+0x771/0xaf0</font></tt><br><tt><font size=3D=
2>[ &nbsp; 67.715054] &nbsp;[&lt;ffffffff811d95e6&gt;]
? get=5Fpage=5Ffrom=5Ffreelist+0x526/0xaf0</font></tt><br><tt><font size=3D=
2>[ &nbsp; 67.715054] &nbsp;[&lt;ffffffff8179e583&gt;]
? =5F=5Fmutex=5Funlock=5Fslowpath+0xe3/0x1a0</font></tt><br><tt><font size=
=3D2>[ &nbsp; 67.715054] &nbsp;[&lt;ffffffff811dad9f&gt;]
=5F=5Falloc=5Fpages=5Fnodemask+0x32f/0x390</font></tt><br><tt><font size=3D=
2>[ &nbsp; 67.715054] &nbsp;[&lt;ffffffff8123a4fe&gt;]
kmalloc=5Flarge=5Fnode+0x7e/0xe0</font></tt><br><tt><font size=3D2>[ &nbsp;=
 67.715054] &nbsp;[&lt;ffffffff81241885&gt;]
=5F=5Fkmalloc=5Fnode=5Ftrack=5Fcaller+0x225/0x2c0</font></tt><br><tt><font =
size=3D2>[ &nbsp; 67.715054] &nbsp;[&lt;ffffffffa00c0f42&gt;]
? tpm2=5Fauto=5Fstartup+0xa2/0x2e0 [tpm]</font></tt><br><tt><font size=3D2>=
[ &nbsp; 67.715054] &nbsp;[&lt;ffffffff815572b7&gt;]
devm=5Fkmalloc+0x27/0x70</font></tt><br><tt><font size=3D2>[ &nbsp; 67.7150=
54] &nbsp;[&lt;ffffffffa00c0f42&gt;]
tpm2=5Fauto=5Fstartup+0xa2/0x2e0 [tpm]</font></tt><br><tt><font size=3D2>[ =
&nbsp; 67.715054] &nbsp;[&lt;ffffffffa00bf3bc&gt;]
tpm=5Fchip=5Fregister+0x5c/0x200 [tpm]</font></tt><br><tt><font size=3D2>[ =
&nbsp; 67.715054] &nbsp;[&lt;ffffffffa029c309&gt;]
vtpm=5Fproxy=5Fwork+0x19/0x40 [tpm=5Fvtpm=5Fproxy]</font></tt><br><tt><font=
 size=3D2>[ &nbsp; 67.715054] &nbsp;[&lt;ffffffff810c4593&gt;]
process=5Fone=5Fwork+0x1f3/0x560</font></tt><br><tt><font size=3D2>[ &nbsp;=
 67.715054] &nbsp;[&lt;ffffffff810c4511&gt;]
? process=5Fone=5Fwork+0x171/0x560</font></tt><br><tt><font size=3D2>[ &nbs=
p; 67.715054] &nbsp;[&lt;ffffffff810c494e&gt;]
worker=5Fthread+0x4e/0x480</font></tt><br><tt><font size=3D2>[ &nbsp; 67.71=
5054] &nbsp;[&lt;ffffffff810c4900&gt;]
? process=5Fone=5Fwork+0x560/0x560</font></tt><br><tt><font size=3D2>[ &nbs=
p; 67.715054] &nbsp;[&lt;ffffffff810c4900&gt;]
? process=5Fone=5Fwork+0x560/0x560</font></tt><br><tt><font size=3D2>[ &nbs=
p; 67.715054] &nbsp;[&lt;ffffffff810ca994&gt;]
kthread+0xf4/0x110</font></tt><br><tt><font size=3D2>[ &nbsp; 67.715054] &n=
bsp;[&lt;ffffffff810ca8a0&gt;]
? kthread=5Fpark+0x60/0x60</font></tt><br><tt><font size=3D2>[ &nbsp; 67.71=
5054] &nbsp;[&lt;ffffffff817a1c15&gt;]
ret=5Ffrom=5Ffork+0x25/0x30</font></tt><br><tt><font size=3D2>[ &nbsp; 67.7=
46343] ---[ end trace 4d9abf66365987bd
]---</font></tt><br><br><BR>
--=_alternative 00684A888525809E_=--



--===============3252333643743349516==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============3252333643743349516==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3252333643743349516==--
