From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 08/10] tpm: Driver for supporting
 multiple emulated TPMs
Date: Sat, 5 Mar 2016 09:55:47 -0500
Message-ID: <201603051455.u25EtqdW023217@d01av01.pok.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1456766996-9300-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160304202928.GA32617@intel.com>
	<201603042112.u24LCT7q016369@d01av05.pok.ibm.com>
	<20160304223410.GA12143@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1237418144405576369=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160304223410.GA12143-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============1237418144405576369==
Content-Type: multipart/alternative;
	boundary="=_alternative 005205B885257F6D_="


--=_alternative 005205B885257F6D_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/04/2016=20
05:34:10 PM:


> On Fri, Mar 04, 2016 at 04:16:41PM -0500, Stefan Berger wrote:
> >    > > +static ssize=5Ft vtpm=5Ffops=5Fwrite(struct file *filp, const c=
har=20
=5F=5Fuser
> >    *buf,
> >    > > +                size=5Ft count, loff=5Ft *off)
> >    > > +{
> >    > > +   struct vtpm=5Fdev *vtpm=5Fdev =3D filp->private=5Fdata;
> >    > > +
> >    > > +   if (count > sizeof(vtpm=5Fdev->buffer) ||
> >    > > +       !(vtpm=5Fdev->state & STATE=5FWAIT=5FRESPONSE=5FFLAG))
> >    > > +      return -EIO;
> >    >
> >    > This is not atomic in any sense. You should move this statement=20
after
> >    > taking buf=5Flock.
> >=20
> >    set=5Fbit and friends were all atomic. Now we need to put all of=20
these into
> >    the mutex... ?
>=20
> Hmm... but you have other fields too in struct vtpm=5Fdev so you anyway
> need to use mutex for concurrent access to the file. In that statement
> you are accessing two fields from that structure.
>=20
> Lets say someone forks 100 processes that concurrently access this
> same open file. How else you would keep the state of vtpm=5Fdev coherent
> than protecting with a mutex?

I moved the accesses to the flag now into the mutex where necessary,=20
except for one place where it's done so early that there's no concurrency. =

The updated code is here:

https://github.com/stefanberger/linux/commits/vtpm-driver.v5

   Stefan



--=_alternative 005205B885257F6D_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/04/2016 05:34:10 PM:<br><br><br>&gt; On Fri, Mar 04, 2016 at 04=
:16:41PM -0500, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; +s=
tatic ssize=5Ft vtpm=5Ffops=5Fwrite(struct
file *filp, const char =5F=5Fuser<br>&gt; &gt; &nbsp; &nbsp;*buf,<br>&gt; &=
gt; &nbsp; &nbsp;&gt; &gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;size=5Ft count, loff=5Ft *off)<br>&gt; &gt; &nbsp; &nbsp;&gt; =
&gt; +{<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; + &nbsp; struct vtpm=5Fdev *vtp=
m=5Fdev =3D filp-&gt;private=5Fdata;<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; +<=
br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; + &nbsp; if (count &gt; sizeof(vtpm=5Fd=
ev-&gt;buffer)
||<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; + &nbsp; &nbsp; &nbsp; !(vtpm=5Fdev-=
&gt;state
&amp; STATE=5FWAIT=5FRESPONSE=5FFLAG))<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; =
+ &nbsp; &nbsp; &nbsp;return -EIO;<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &=
gt; &nbsp; &nbsp;&gt; This is not atomic in any sense. You should
move this statement after<br>&gt; &gt; &nbsp; &nbsp;&gt; taking buf=5Flock.=
<br>&gt; &gt; <br>&gt; &gt; &nbsp; &nbsp;set=5Fbit and friends were all ato=
mic. Now we need
to put all of these into<br>&gt; &gt; &nbsp; &nbsp;the mutex... ?<br>&gt; <=
br>&gt; Hmm... but you have other fields too in struct vtpm=5Fdev so you an=
yway<br>&gt; need to use mutex for concurrent access to the file. In that s=
tatement<br>&gt; you are accessing two fields from that structure.<br>&gt; =
<br>&gt; Lets say someone forks 100 processes that concurrently access this=
<br>&gt; same open file. How else you would keep the state of vtpm=5Fdev co=
herent<br>&gt; than protecting with a mutex?</font></tt><br><br><tt><font s=
ize=3D2>I moved the accesses to the flag now into the mutex
where necessary, except for one place where it's done so early that there's
no concurrency. The updated code is here:</font></tt><br><br><a href=3D"htt=
ps://github.com/stefanberger/linux/commits/vtpm-driver.v5"><tt><font size=
=3D2 color=3Dblue>https://github.com/stefanberger/linux/commits/vtpm-driver=
.v5</font></tt></a><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></t=
t><br><BR>
--=_alternative 005205B885257F6D_=--



--===============1237418144405576369==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============1237418144405576369==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1237418144405576369==--
