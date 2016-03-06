From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: ioctl API for vTPM driver
Date: Sun, 6 Mar 2016 11:21:42 -0500
Message-ID: <201603061621.u26GLuQK014398@d03av04.boulder.ibm.com>
References: <20160306120537.GA22702@intel.com><20160306121103.GA23480@intel.com>
	<20160306122816.GA24077@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1376215373662174564=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160306122816.GA24077-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============1376215373662174564==
Content-Type: multipart/alternative;
	boundary="=_alternative 0059E35185257F6E_="


--=_alternative 0059E35185257F6E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/06/2016=20
07:28:16 AM:

> From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Date: 03/06/2016 07:29 AM
> Subject: Re: [tpmdd-devel] ioctl API for vTPM driver
>=20
> On Sun, Mar 06, 2016 at 02:11:03PM +0200, Jarkko Sakkinen wrote:
> > On Sun, Mar 06, 2016 at 02:05:37PM +0200, Jarkko Sakkinen wrote:
> > > Hi
> > >=20
> > > Some follow-up question that have popped up while I've started to
> > > write a test program for this feature mainly about ioctl API.  It's
> > > better to be extremly cautious here because we will be stuck with=20
this
> > > ioctl forever.
> > >=20
> > > 1. Why the ioctl name is VTPM=5FNEW=5FDEV but the struct name is
> > >    vtpm=5Fnew=5Fpair? It would be better if they both were either
> > >    VTPM=5FNEW=5FDEV and vtpm=5Fnew=5Fdev or alternatively VTPM=5FNEW=
=5FPAIR
> > >    and vtpm=5Fnew=5Fpair.

Renamed it to vtpm=5Fnew=5Fdev.

> > > 2. Is 'pair' or 'tuple' a better term?
> > > 3. Where is the documentation for the ioctl? I don't think I can
> > >    merge this to my next branch before it exists.

I'll add some later today or tomorrow.

> > > 4. I have forgotten why the major and minor numbers were returned.
> > >    My guess is that they were returned so that a container could
> > >    replicate the device? This is one reason why documentation is
> > >    mandatory.

Yes, it's there so that inside a container a device with that major and=20
minor number can be created and device cgroups be setup.

> >=20
> > 5. Is there any particular reason why 'tpm=5Fdev=5Fnum' couldn't simply=
 be
> >    'dev=5Fnum'?

Renamed to 'tpm=5Fnum' Updated my git repo.

>=20
> I think you should still send a patch set after documentation has been
> completed and we have addressed these items to the following mailing
> lists:
>=20
> * linux-kernel
> * linux-api
> * linux-doc
> * tpmdd

The whole patchset as 'v5' ?

>=20
> Now these patches have circled only in the tpmdd mailing list which
> is not sufficient. I just realized this recently that the relevant
> mailing lists were completely missing (while starting to write a
> test program).
>=20
> For patches up to TPM=5FCHIP=5FFLAG=5FVIRTUAL you could downloaded patches
> from my repository before posting the patch set since they include
> also my reviewed/tested-by's.

Ok, will sync.

    Stefan

>=20
> Thanks.
>=20
> /Jarkko
>=20
>=20
---------------------------------------------------------------------------=
---
> =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>=20



--=_alternative 0059E35185257F6E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/06/2016 07:28:16 AM:<br><br>&gt; From: Jarkko Sakkinen &lt;jark=
ko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;</font></tt><br><tt><font size=3D2>&gt; To: =
Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;</font></tt><br><tt><font s=
ize=3D2>&gt; Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org</font></tt><br><tt><font=
 size=3D2>&gt; Date: 03/06/2016 07:29 AM</font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] ioctl API for vTPM
driver</font></tt><br><tt><font size=3D2>&gt; <br>&gt; On Sun, Mar 06, 2016=
 at 02:11:03PM +0200, Jarkko Sakkinen wrote:<br>&gt; &gt; On Sun, Mar 06, 2=
016 at 02:05:37PM +0200, Jarkko Sakkinen wrote:<br>&gt; &gt; &gt; Hi<br>&gt=
; &gt; &gt; <br>&gt; &gt; &gt; Some follow-up question that have popped up =
while I've started
to<br>&gt; &gt; &gt; write a test program for this feature mainly about ioc=
tl
API. &nbsp;It's<br>&gt; &gt; &gt; better to be extremly cautious here becau=
se we will be stuck
with this<br>&gt; &gt; &gt; ioctl forever.<br>&gt; &gt; &gt; <br>&gt; &gt; =
&gt; 1. Why the ioctl name is VTPM=5FNEW=5FDEV but the struct name
is<br>&gt; &gt; &gt; &nbsp; &nbsp;vtpm=5Fnew=5Fpair? It would be better if =
they both
were either<br>&gt; &gt; &gt; &nbsp; &nbsp;VTPM=5FNEW=5FDEV and vtpm=5Fnew=
=5Fdev or alternatively
VTPM=5FNEW=5FPAIR<br>&gt; &gt; &gt; &nbsp; &nbsp;and vtpm=5Fnew=5Fpair.</fo=
nt></tt><br><br><tt><font size=3D2>Renamed it to vtpm=5Fnew=5Fdev.</font></=
tt><br><tt><font size=3D2><br>&gt; &gt; &gt; 2. Is 'pair' or 'tuple' a bett=
er term?</font></tt><br><tt><font size=3D2>&gt; &gt; &gt; 3. Where is the d=
ocumentation for the
ioctl? I don't think I can<br>&gt; &gt; &gt; &nbsp; &nbsp;merge this to my =
next branch before it exists.</font></tt><br><br><tt><font size=3D2>I'll ad=
d some later today or tomorrow.</font></tt><br><tt><font size=3D2><br>&gt; =
&gt; &gt; 4. I have forgotten why the major and minor numbers were
returned.<br>&gt; &gt; &gt; &nbsp; &nbsp;My guess is that they were returne=
d so that
a container could<br>&gt; &gt; &gt; &nbsp; &nbsp;replicate the device? This=
 is one reason why
documentation is<br>&gt; &gt; &gt; &nbsp; &nbsp;mandatory.</font></tt><br><=
br><tt><font size=3D2>Yes, it's there so that inside a container a device
with that major and minor number can be created and device cgroups be setup=
.</font></tt><br><tt><font size=3D2><br>&gt; &gt; <br>&gt; &gt; 5. Is there=
 any particular reason why 'tpm=5Fdev=5Fnum' couldn't
simply be<br>&gt; &gt; &nbsp; &nbsp;'dev=5Fnum'?</font></tt><br><br><tt><fo=
nt size=3D2>Renamed to 'tpm=5Fnum' Updated my git repo.</font></tt><br><tt>=
<font size=3D2><br>&gt; <br>&gt; I think you should still send a patch set =
after documentation has
been<br>&gt; completed and we have addressed these items to the following m=
ailing<br>&gt; lists:<br>&gt; <br>&gt; * linux-kernel<br>&gt; * linux-api<b=
r>&gt; * linux-doc<br>&gt; * tpmdd</font></tt><br><br><tt><font size=3D2>Th=
e whole patchset as 'v5' ?</font></tt><br><tt><font size=3D2><br>&gt; <br>&=
gt; Now these patches have circled only in the tpmdd mailing list which<br>=
&gt; is not sufficient. I just realized this recently that the relevant<br>=
&gt; mailing lists were completely missing (while starting to write a<br>&g=
t; test program).<br>&gt; <br>&gt; For patches up to TPM=5FCHIP=5FFLAG=5FVI=
RTUAL you could downloaded patches<br>&gt; from my repository before postin=
g the patch set since they include<br>&gt; also my reviewed/tested-by's.</f=
ont></tt><br><br><tt><font size=3D2>Ok, will sync.</font></tt><br><br><tt><=
font size=3D2>&nbsp; &nbsp; Stefan</font></tt><br><tt><font size=3D2><br>&g=
t; <br>&gt; Thanks.<br>&gt; <br>&gt; /Jarkko<br>&gt; <br>&gt; -------------=
-----------------------------------------------------------------<br>&gt; =
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F<br>&gt; =
tpmdd-devel mailing list<br>&gt; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>&gt; =
</font></tt><a href=3D"https://lists.sourceforge.net/lists/listinfo/tpmdd-d=
evel"><tt><font size=3D2>https://lists.sourceforge.net/lists/listinfo/tpmdd=
-devel</font></tt></a><tt><font size=3D2><br>&gt; <br></font></tt><BR>
--=_alternative 0059E35185257F6E_=--



--===============1376215373662174564==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============1376215373662174564==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1376215373662174564==--
