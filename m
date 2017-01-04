From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/4] tpm: validate TPM 2.0 commands
Date: Wed, 4 Jan 2017 14:22:45 -0500
Message-ID: <OFDFABBD23.E5E1F639-ON0025809E.006924C4-8525809E.006A7568@notes.na.collabserv.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-3-jarkko.sakkinen@linux.intel.com>
	<OF8D508BD2.EAB22BFD-ON0025809E.0062B40C-8525809E.006356C3@notes.na.collabserv.com>
	<1483553976.2561.38.camel@linux.vnet.ibm.com>
	<OF3FD1DF4F.FB87C3F2-ON0025809E.00682E9B-8525809E.00684A8A@notes.na.collabserv.com>
	<1483556735.2561.53.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7570210585177102823=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1483556735.2561.53.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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


--===============7570210585177102823==
Content-Type: multipart/alternative;
	boundary="=_alternative 006A75688525809E_="


--=_alternative 006A75688525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote on 01/04/2017 02:05:35 PM:

> From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> To: Stefan Berger/Watson/IBM@IBMUS
> Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-
> devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe=20
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date: 01/04/2017 02:05 PM
> Subject: Re: [tpmdd-devel] [PATCH RFC 2/4] tpm: validate TPM 2.0=20
commands
>=20
> On Wed, 2017-01-04 at 13:59 -0500, Stefan Berger wrote:
> > [   67.699811] WARNING: CPU: 12 PID: 870 at mm/page=5Falloc.c:3511=20
>=20
> What's the code context around this line in your source?  Or what
> kernel version?  If it's this
>=20
>    if (order >=3D MAX=5FORDER) {
>       WARN=5FON=5FONCE(!(gfp=5Fmask & =5F=5FGFP=5FNOWARN));
>       return NULL;
>    }
>=20

I am running Jarkko's tree, the tabrm branch. 4.9.0-rc5 I think. I have=20
exactly what you are showing above.

> Then I think you may have returned bogus data to TPM=5FPT=5FTOTAL=5FCOMMA=
NDS;
> perhaps print nr=5Fcommands.

Ha, what is likely the cause here is that the test suite, which implements =

only a few commands to respond to the kernel with from the vtpm proxy=20
side, isn't feeding good data to the driver and the nr=5Fcommands ends up=20
being 0... or actually bogus data / not initialized. I guess the function=20
should check for valid input.

   Stefan


>=20
> James
>=20
> > =5F=5Falloc=5Fpages=5Fslowpath+0x771/0xaf0
> > [   67.701198] Modules linked in:
> > [   67.701400]  tpm=5Fvtpm=5Fproxy
> > [   67.701642]  nf=5Fconntrack=5Fnetbios=5Fns nf=5Fconntrack=5Fbroadcast
> > [   67.702450]  ip6t=5Frpfilter
> > [   67.702662]  ip6t=5FREJECT nf=5Freject=5Fipv6 xt=5Fconntrack ebtable=
=5Fnat
> > [   67.703618]  ebtable=5Fbroute
> > [   67.703784]  bridge stp llc ebtable=5Ffilter
> > [   67.704213]  ebtables
> > [   67.704367]  ip6table=5Fnat nf=5Fconntrack=5Fipv6 nf=5Fdefrag=5Fipv6
> > [   67.705310]  nf=5Fnat=5Fipv6
> > [   67.705523]  ip6table=5Fmangle ip6table=5Fsecurity ip6table=5Fraw=20
> > ip6table=5Ffilter ip6=5Ftables iptable=5Fnat nf=5Fconntrack=5Fipv4
> > nf=5Fdefrag=5Fipv4=20
> > nf=5Fnat=5Fipv4 nf=5Fnat nf=5Fconntrack iptable=5Fmangle iptable=5Fsecu=
rity=20
> > iptable=5Fraw nfsd auth=5Frpcgss nfs=5Facl lockd crc32c=5Fintel tpm=5Ft=
is=20
> > virtio=5Fballoon i2c=5Fpiix4 tpm=5Ftis=5Fcore
> > [   67.711414]  i2c=5Fcore
> > [   67.711610]  joydev tpm pcspkr grace sunrpc
> > [   67.712170]  8139too
> > [   67.712360]  virtio=5Fpci 8139cp virtio=5Fring serio=5Fraw
> > [   67.713504]  ata=5Fgeneric
> > [   67.713706]  mii floppy pata=5Facpi virtio
> > [   67.714891] CPU: 12 PID: 870 Comm: kworker/12:2 Not tainted 4.9.0
> > -rc5+=20
> > #652
> > [   67.715054] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > BIOS=20
> > rel-1.10.1-0-g8891697-prebuilt.qemu-project.org 04/01/2014
> > [   67.715054] Workqueue: tpm-vtpm vtpm=5Fproxy=5Fwork [tpm=5Fvtpm=5Fpr=
oxy]
> > [   67.715054]  ffffc90002b6fa80 ffffffff8140cad1
> > [   67.715054]  0000000000000000
> > [   67.715054]  0000000000000000
> > [   67.715054]  ffffc90002b6fac0 ffffffff810a8b6b 00000db7aba7d298=20
> > 00000000026000c0
> > [   67.715054]  0000000000000000 0000000000000014 000000000260c0c0=20
> > ffff8802aba7ca00
> > [   67.715054] Call Trace:
> > [   67.715054]  [<ffffffff8140cad1>] dump=5Fstack+0x63/0x82
> > [   67.715054]  [<ffffffff810a8b6b>] =5F=5Fwarn+0xcb/0xf0
> > [   67.715054]  [<ffffffff810a8c9d>] warn=5Fslowpath=5Fnull+0x1d/0x20
> > [   67.715054]  [<ffffffff811da6f1>]
> > =5F=5Falloc=5Fpages=5Fslowpath+0x771/0xaf0
> > [   67.715054]  [<ffffffff811d95e6>] ?
> > get=5Fpage=5Ffrom=5Ffreelist+0x526/0xaf0
> > [   67.715054]  [<ffffffff8179e583>] ?
> > =5F=5Fmutex=5Funlock=5Fslowpath+0xe3/0x1a0
> > [   67.715054]  [<ffffffff811dad9f>]
> > =5F=5Falloc=5Fpages=5Fnodemask+0x32f/0x390
> > [   67.715054]  [<ffffffff8123a4fe>] kmalloc=5Flarge=5Fnode+0x7e/0xe0
> > [   67.715054]  [<ffffffff81241885>]=20
> > =5F=5Fkmalloc=5Fnode=5Ftrack=5Fcaller+0x225/0x2c0
> > [   67.715054]  [<ffffffffa00c0f42>] ? tpm2=5Fauto=5Fstartup+0xa2/0x2e0
> > [tpm]
> > [   67.715054]  [<ffffffff815572b7>] devm=5Fkmalloc+0x27/0x70
> > [   67.715054]  [<ffffffffa00c0f42>] tpm2=5Fauto=5Fstartup+0xa2/0x2e0
> > [tpm]
> > [   67.715054]  [<ffffffffa00bf3bc>] tpm=5Fchip=5Fregister+0x5c/0x200
> > [tpm]
> > [   67.715054]  [<ffffffffa029c309>] vtpm=5Fproxy=5Fwork+0x19/0x40=20
> > [tpm=5Fvtpm=5Fproxy]
> > [   67.715054]  [<ffffffff810c4593>] process=5Fone=5Fwork+0x1f3/0x560
> > [   67.715054]  [<ffffffff810c4511>] ? process=5Fone=5Fwork+0x171/0x560
> > [   67.715054]  [<ffffffff810c494e>] worker=5Fthread+0x4e/0x480
> > [   67.715054]  [<ffffffff810c4900>] ? process=5Fone=5Fwork+0x560/0x560
> > [   67.715054]  [<ffffffff810c4900>] ? process=5Fone=5Fwork+0x560/0x560
> > [   67.715054]  [<ffffffff810ca994>] kthread+0xf4/0x110
> > [   67.715054]  [<ffffffff810ca8a0>] ? kthread=5Fpark+0x60/0x60
> > [   67.715054]  [<ffffffff817a1c15>] ret=5Ffrom=5Ffork+0x25/0x30
> > [   67.746343] ---[ end trace 4d9abf66365987bd ]---
> >=20
> >=20
> >=20
>=20



--=_alternative 006A75688525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>James Bottomley &lt;jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt; wrote
on 01/04/2017 02:05:35 PM:<br><br>&gt; From: James Bottomley &lt;jejb@linux=
.vnet.ibm.com&gt;</font></tt><br><tt><font size=3D2>&gt; To: Stefan Berger/=
Watson/IBM@IBMUS</font></tt><br><tt><font size=3D2>&gt; Cc: Jarkko Sakkinen=
 &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;,
tpmdd-<br>&gt; devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe &lt;jgunthorpe@=
obsidianresearch.com&gt;</font></tt><br><tt><font size=3D2>&gt; Date: 01/04=
/2017 02:05 PM</font></tt><br><tt><font size=3D2>&gt; Subject: Re: [tpmdd-d=
evel] [PATCH RFC 2/4] tpm:
validate TPM 2.0 commands</font></tt><br><tt><font size=3D2>&gt; <br>&gt; O=
n Wed, 2017-01-04 at 13:59 -0500, Stefan Berger wrote:<br>&gt; &gt; [ &nbsp=
; 67.699811] WARNING: CPU: 12 PID: 870 at mm/page=5Falloc.c:3511
<br>&gt; <br>&gt; What's the code context around this line in your source? =
&nbsp;Or
what<br>&gt; kernel version? &nbsp;If it's this<br>&gt; <br>&gt; &nbsp; &nb=
sp;if (order &gt;=3D MAX=5FORDER) {<br>&gt; &nbsp; &nbsp; &nbsp; WARN=5FON=
=5FONCE(!(gfp=5Fmask &amp; =5F=5FGFP=5FNOWARN));<br>&gt; &nbsp; &nbsp; &nbs=
p; return NULL;<br>&gt; &nbsp; &nbsp;}<br>&gt; </font></tt><br><br><tt><fon=
t size=3D2>I am running Jarkko's tree, the tabrm branch. 4.9.0-rc5
I think. I have exactly what you are showing above.</font></tt><br><tt><fon=
t size=3D2><br>&gt; Then I think you may have returned bogus data to TPM=5F=
PT=5FTOTAL=5FCOMMANDS;<br>&gt; perhaps print nr=5Fcommands.</font></tt><br>=
<br><tt><font size=3D2>Ha, what is likely the cause here is that the test
suite, which implements only a few commands to respond to the kernel with
from the vtpm proxy side, isn't feeding good data to the driver and the
nr=5Fcommands ends up being 0... or actually bogus data / not initialized.
I guess the function should check for valid input.</font></tt><br><br><tt><=
font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><br><tt><font size=3D2><br=
>&gt; <br>&gt; James<br>&gt; <br>&gt; &gt; =5F=5Falloc=5Fpages=5Fslowpath+0=
x771/0xaf0<br>&gt; &gt; [ &nbsp; 67.701198] Modules linked in:<br>&gt; &gt;=
 [ &nbsp; 67.701400] &nbsp;tpm=5Fvtpm=5Fproxy<br>&gt; &gt; [ &nbsp; 67.7016=
42] &nbsp;nf=5Fconntrack=5Fnetbios=5Fns nf=5Fconntrack=5Fbroadcast<br>&gt; =
&gt; [ &nbsp; 67.702450] &nbsp;ip6t=5Frpfilter<br>&gt; &gt; [ &nbsp; 67.702=
662] &nbsp;ip6t=5FREJECT nf=5Freject=5Fipv6 xt=5Fconntrack
ebtable=5Fnat<br>&gt; &gt; [ &nbsp; 67.703618] &nbsp;ebtable=5Fbroute<br>&g=
t; &gt; [ &nbsp; 67.703784] &nbsp;bridge stp llc ebtable=5Ffilter<br>&gt; &=
gt; [ &nbsp; 67.704213] &nbsp;ebtables<br>&gt; &gt; [ &nbsp; 67.704367] &nb=
sp;ip6table=5Fnat nf=5Fconntrack=5Fipv6 nf=5Fdefrag=5Fipv6<br>&gt; &gt; [ &=
nbsp; 67.705310] &nbsp;nf=5Fnat=5Fipv6<br>&gt; &gt; [ &nbsp; 67.705523] &nb=
sp;ip6table=5Fmangle ip6table=5Fsecurity ip6table=5Fraw
<br>&gt; &gt; ip6table=5Ffilter ip6=5Ftables iptable=5Fnat nf=5Fconntrack=
=5Fipv4<br>&gt; &gt; nf=5Fdefrag=5Fipv4 <br>&gt; &gt; nf=5Fnat=5Fipv4 nf=5F=
nat nf=5Fconntrack iptable=5Fmangle iptable=5Fsecurity
<br>&gt; &gt; iptable=5Fraw nfsd auth=5Frpcgss nfs=5Facl lockd crc32c=5Fint=
el tpm=5Ftis
<br>&gt; &gt; virtio=5Fballoon i2c=5Fpiix4 tpm=5Ftis=5Fcore<br>&gt; &gt; [ =
&nbsp; 67.711414] &nbsp;i2c=5Fcore<br>&gt; &gt; [ &nbsp; 67.711610] &nbsp;j=
oydev tpm pcspkr grace sunrpc<br>&gt; &gt; [ &nbsp; 67.712170] &nbsp;8139to=
o<br>&gt; &gt; [ &nbsp; 67.712360] &nbsp;virtio=5Fpci 8139cp virtio=5Fring =
serio=5Fraw<br>&gt; &gt; [ &nbsp; 67.713504] &nbsp;ata=5Fgeneric<br>&gt; &g=
t; [ &nbsp; 67.713706] &nbsp;mii floppy pata=5Facpi virtio<br>&gt; &gt; [ &=
nbsp; 67.714891] CPU: 12 PID: 870 Comm: kworker/12:2 Not tainted
4.9.0<br>&gt; &gt; -rc5+ <br>&gt; &gt; #652<br>&gt; &gt; [ &nbsp; 67.715054=
] Hardware name: QEMU Standard PC (i440FX +
PIIX, 1996),<br>&gt; &gt; BIOS <br>&gt; &gt; rel-1.10.1-0-g8891697-prebuilt=
.qemu-project.org 04/01/2014<br>&gt; &gt; [ &nbsp; 67.715054] Workqueue: tp=
m-vtpm vtpm=5Fproxy=5Fwork [tpm=5Fvtpm=5Fproxy]<br>&gt; &gt; [ &nbsp; 67.71=
5054] &nbsp;ffffc90002b6fa80 ffffffff8140cad1<br>&gt; &gt; [ &nbsp; 67.7150=
54] &nbsp;0000000000000000<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;000000000=
0000000<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;ffffc90002b6fac0 ffffffff810=
a8b6b 00000db7aba7d298
<br>&gt; &gt; 00000000026000c0<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;00000=
00000000000 0000000000000014 000000000260c0c0
<br>&gt; &gt; ffff8802aba7ca00<br>&gt; &gt; [ &nbsp; 67.715054] Call Trace:=
<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffff8140cad1&gt;] dump=5Fs=
tack+0x63/0x82<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffff810a8b6b=
&gt;] =5F=5Fwarn+0xcb/0xf0<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffff=
ffff810a8c9d&gt;] warn=5Fslowpath=5Fnull+0x1d/0x20<br>&gt; &gt; [ &nbsp; 67=
.715054] &nbsp;[&lt;ffffffff811da6f1&gt;]<br>&gt; &gt; =5F=5Falloc=5Fpages=
=5Fslowpath+0x771/0xaf0<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;fffffff=
f811d95e6&gt;] ?<br>&gt; &gt; get=5Fpage=5Ffrom=5Ffreelist+0x526/0xaf0<br>&=
gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffff8179e583&gt;] ?<br>&gt; &gt=
; =5F=5Fmutex=5Funlock=5Fslowpath+0xe3/0x1a0<br>&gt; &gt; [ &nbsp; 67.71505=
4] &nbsp;[&lt;ffffffff811dad9f&gt;]<br>&gt; &gt; =5F=5Falloc=5Fpages=5Fnode=
mask+0x32f/0x390<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffff8123a4=
fe&gt;] kmalloc=5Flarge=5Fnode+0x7e/0xe0<br>&gt; &gt; [ &nbsp; 67.715054] &=
nbsp;[&lt;ffffffff81241885&gt;] <br>&gt; &gt; =5F=5Fkmalloc=5Fnode=5Ftrack=
=5Fcaller+0x225/0x2c0<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffffa=
00c0f42&gt;] ? tpm2=5Fauto=5Fstartup+0xa2/0x2e0<br>&gt; &gt; [tpm]<br>&gt; =
&gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffff815572b7&gt;] devm=5Fkmalloc+0x=
27/0x70<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffffa00c0f42&gt;] t=
pm2=5Fauto=5Fstartup+0xa2/0x2e0<br>&gt; &gt; [tpm]<br>&gt; &gt; [ &nbsp; 67=
.715054] &nbsp;[&lt;ffffffffa00bf3bc&gt;] tpm=5Fchip=5Fregister+0x5c/0x200<=
br>&gt; &gt; [tpm]<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffffa029=
c309&gt;] vtpm=5Fproxy=5Fwork+0x19/0x40
<br>&gt; &gt; [tpm=5Fvtpm=5Fproxy]<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[=
&lt;ffffffff810c4593&gt;] process=5Fone=5Fwork+0x1f3/0x560<br>&gt; &gt; [ &=
nbsp; 67.715054] &nbsp;[&lt;ffffffff810c4511&gt;] ? process=5Fone=5Fwork+0x=
171/0x560<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffff810c494e&gt;]=
 worker=5Fthread+0x4e/0x480<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;fff=
fffff810c4900&gt;] ? process=5Fone=5Fwork+0x560/0x560<br>&gt; &gt; [ &nbsp;=
 67.715054] &nbsp;[&lt;ffffffff810c4900&gt;] ? process=5Fone=5Fwork+0x560/0=
x560<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffff810ca994&gt;] kthr=
ead+0xf4/0x110<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&lt;ffffffff810ca8a0=
&gt;] ? kthread=5Fpark+0x60/0x60<br>&gt; &gt; [ &nbsp; 67.715054] &nbsp;[&l=
t;ffffffff817a1c15&gt;] ret=5Ffrom=5Ffork+0x25/0x30<br>&gt; &gt; [ &nbsp; 6=
7.746343] ---[ end trace 4d9abf66365987bd ]---<br>&gt; &gt; <br>&gt; &gt; <=
br>&gt; &gt; <br>&gt; <br></font></tt><BR>
--=_alternative 006A75688525809E_=--



--===============7570210585177102823==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============7570210585177102823==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7570210585177102823==--
