From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: ioctl API for vTPM driver
Date: Tue, 8 Mar 2016 12:24:10 -0500
Message-ID: <201603081724.u28HOtXm023400@d03av04.boulder.ibm.com>
References: <20160306120537.GA22702@intel.com><20160306121103.GA23480@intel.com>
	<20160306122816.GA24077@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1991367040909674134=="
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


--===============1991367040909674134==
Content-Type: multipart/alternative;
	boundary="=_alternative 005F991985257F70_="


--=_alternative 005F991985257F70_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/06/2016=20
07:28:16 AM:


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
> > > 2. Is 'pair' or 'tuple' a better term?
> > > 3. Where is the documentation for the ioctl? I don't think I can
> > >    merge this to my next branch before it exists.
> > > 4. I have forgotten why the major and minor numbers were returned.
> > >    My guess is that they were returned so that a container could
> > >    replicate the device? This is one reason why documentation is
> > >    mandatory.
> >=20
> > 5. Is there any particular reason why 'tpm=5Fdev=5Fnum' couldn't simply=
 be
> >    'dev=5Fnum'?
>=20
> I think you should still send a patch set after documentation has been
> completed and we have addressed these items to the following mailing
> lists:
>=20
> * linux-kernel
> * linux-api
> * linux-doc
> * tpmdd
>=20
> Now these patches have circled only in the tpmdd mailing list which
> is not sufficient. I just realized this recently that the relevant
> mailing lists were completely missing (while starting to write a
> test program).
>=20
> For patches up to TPM=5FCHIP=5FFLAG=5FVIRTUAL you could downloaded patches
> from my repository before posting the patch set since they include
> also my reviewed/tested-by's.

I will post a v6 tomorrow again with the 3 vtpm related patches cc'ed to=20
the above mailing lists. V6 addresses the errno's Jason has been=20
suggesting.

   Stefan



--=_alternative 005F991985257F70_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/06/2016 07:28:16 AM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Sun, Mar 06, 2016 at 02:11:03PM +0200, Jarkko Sakkinen wro=
te:<br>&gt; &gt; On Sun, Mar 06, 2016 at 02:05:37PM +0200, Jarkko Sakkinen =
wrote:<br>&gt; &gt; &gt; Hi<br>&gt; &gt; &gt; <br>&gt; &gt; &gt; Some follo=
w-up question that have popped up while I've started
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
VTPM=5FNEW=5FPAIR<br>&gt; &gt; &gt; &nbsp; &nbsp;and vtpm=5Fnew=5Fpair.<br>=
&gt; &gt; &gt; 2. Is 'pair' or 'tuple' a better term?<br>&gt; &gt; &gt; 3. =
Where is the documentation for the ioctl? I don't think
I can<br>&gt; &gt; &gt; &nbsp; &nbsp;merge this to my next branch before it=
 exists.<br>&gt; &gt; &gt; 4. I have forgotten why the major and minor numb=
ers were
returned.<br>&gt; &gt; &gt; &nbsp; &nbsp;My guess is that they were returne=
d so that
a container could<br>&gt; &gt; &gt; &nbsp; &nbsp;replicate the device? This=
 is one reason why
documentation is<br>&gt; &gt; &gt; &nbsp; &nbsp;mandatory.<br>&gt; &gt; <br=
>&gt; &gt; 5. Is there any particular reason why 'tpm=5Fdev=5Fnum' couldn't
simply be<br>&gt; &gt; &nbsp; &nbsp;'dev=5Fnum'?<br>&gt; <br>&gt; I think y=
ou should still send a patch set after documentation has
been<br>&gt; completed and we have addressed these items to the following m=
ailing<br>&gt; lists:<br>&gt; <br>&gt; * linux-kernel<br>&gt; * linux-api<b=
r>&gt; * linux-doc<br>&gt; * tpmdd<br>&gt; <br>&gt; Now these patches have =
circled only in the tpmdd mailing list which<br>&gt; is not sufficient. I j=
ust realized this recently that the relevant<br>&gt; mailing lists were com=
pletely missing (while starting to write a<br>&gt; test program).<br>&gt; <=
br>&gt; For patches up to TPM=5FCHIP=5FFLAG=5FVIRTUAL you could downloaded =
patches<br>&gt; from my repository before posting the patch set since they =
include<br>&gt; also my reviewed/tested-by's.</font></tt><br><br><tt><font =
size=3D2>I will post a v6 tomorrow again with the 3 vtpm related
patches cc'ed to the above mailing lists. V6 addresses the errno's Jason
has been suggesting.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Ste=
fan</font></tt><br><BR>
--=_alternative 005F991985257F70_=--



--===============1991367040909674134==
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
--===============1991367040909674134==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1991367040909674134==--
