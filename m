From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: ioctl API for vTPM driver
Date: Mon, 7 Mar 2016 17:24:03 -0500
Message-ID: <201603072224.u27MO9v0027911@d01av04.pok.ibm.com>
References: <20160306120537.GA22702@intel.com>
	<20160306121103.GA23480@intel.com>
	<20160306122816.GA24077@intel.com>
	<201603070040.u270eq7U019952@d01av03.pok.ibm.com>
	<20160307203206.GA4303@obsidianresearch.com>
	<201603072115.u27LFcMK001519@d01av01.pok.ibm.com>
	<20160307213453.GA4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2218340363459344895=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160307213453.GA4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============2218340363459344895==
Content-Type: multipart/alternative;
	boundary="=_alternative 007B0D7785257F6F_="


--=_alternative 007B0D7785257F6F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 03/07/2016=20
04:34:53 PM:

> Subject: Re: [tpmdd-devel] ioctl API for vTPM driver
>=20
> On Mon, Mar 07, 2016 at 04:12:45PM -0500, Stefan Berger wrote:
> >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
03/07/2016
> >    03:32:06 PM:
> >    >
> >    > On Sun, Mar 06, 2016 at 07:40:40PM -0500, Stefan Berger wrote:
> >    >
> >    > >    If you have suggestions or comments, let me know.
> >    > >    I adjusted the code to reflect the ENOSYS (previously=20
EINVAL) in
> >    case
> >    > >    of unsupported flags or unsupported ioctls.
> >    >
> >    > Please don't use ENOSYS, the desire is that is only used by
> >    > systemcalls.
>=20
> >    Ok, found alternatives: ENOTSUPP for the flag ENOIOCTLCMD for the
> >    unsupported ioctl ?
>=20
> ENOIOCTLCMD might be OK, just make sure it gets converted to ENOTTY:
>=20
> 390  * Is it an unrecognized ioctl? The correct returns are either
> 391  * ENOTTY (final) or ENOIOCTLCMD ("I don't know this one, try a
> 392  * fallback"). ENOIOCTLCMD gets turned into ENOTTY by the ioctl
> 393  * code before returning.
>=20
> ENOTSUPP is for NFS internal use only, can't be exported to user
> space.

It's found in more then 300 files using that errno...

http://lxr.free-electrons.com/ident?i=3DENOTSUPP

>=20
> Try EOPNOTSUPP

Ok, I will use that one.

   Stefan

>=20
> Jason
>=20



--=_alternative 007B0D7785257F6F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 03/07/2016 04:34:53 PM:<br><br>&gt; Subject: Re: [tpmdd-devel] ioc=
tl API for vTPM driver</font></tt><br><tt><font size=3D2>&gt; <br>&gt; On M=
on, Mar 07, 2016 at 04:12:45PM -0500, Stefan Berger wrote:<br>&gt; &gt; &nb=
sp; &nbsp;Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 03/07/2016<br>&gt; &gt; &nbsp; &nbsp;03:32:06 PM:<br>&gt; &gt; &nb=
sp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; On Sun, Mar 06, 2016 at 07:40=
:40PM -0500, Stefan
Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt;=
 &gt; &nbsp; &nbsp;If you have suggestions or
comments, let me know.<br>&gt; &gt; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;I a=
djusted the code to reflect
the ENOSYS (previously EINVAL) in<br>&gt; &gt; &nbsp; &nbsp;case<br>&gt; &g=
t; &nbsp; &nbsp;&gt; &gt; &nbsp; &nbsp;of unsupported flags or unsupported
ioctls.<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; Pleas=
e don't use ENOSYS, the desire is that
is only used by<br>&gt; &gt; &nbsp; &nbsp;&gt; systemcalls.<br>&gt; <br>&gt=
; &gt; &nbsp; &nbsp;Ok, found alternatives: ENOTSUPP for the flag ENOIOCTLC=
MD
for the<br>&gt; &gt; &nbsp; &nbsp;unsupported ioctl ?<br>&gt; <br>&gt; ENOI=
OCTLCMD might be OK, just make sure it gets converted to ENOTTY:<br>&gt; <b=
r>&gt; 390 &nbsp;* Is it an unrecognized ioctl? The correct returns are eit=
her<br>&gt; 391 &nbsp;* ENOTTY (final) or ENOIOCTLCMD (&quot;I don't know t=
his
one, try a<br>&gt; 392 &nbsp;* fallback&quot;). ENOIOCTLCMD gets turned int=
o ENOTTY by
the ioctl<br>&gt; 393 &nbsp;* code before returning.<br>&gt; <br>&gt; ENOTS=
UPP is for NFS internal use only, can't be exported to user<br>&gt; space.<=
/font></tt><br><br><tt><font size=3D2>It's found in more then 300 files usi=
ng that errno...</font></tt><br><br><a href=3D"http://lxr.free-electrons.co=
m/ident?i=3DENOTSUPP"><tt><font size=3D2 color=3Dblue>http://lxr.free-elect=
rons.com/ident?i=3DENOTSUPP</font></tt></a><br><tt><font size=3D2><br>&gt; =
<br>&gt; Try EOPNOTSUPP</font></tt><br><br><tt><font size=3D2>Ok, I will us=
e that one.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font=
></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Jason<br>&gt; <br></font></t=
t><BR>
--=_alternative 007B0D7785257F6F_=--



--===============2218340363459344895==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://makebettercode.com/inteldaal-eval
--===============2218340363459344895==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2218340363459344895==--
