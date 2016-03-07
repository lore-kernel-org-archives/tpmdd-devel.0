From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: ioctl API for vTPM driver
Date: Sun, 6 Mar 2016 19:40:40 -0500
Message-ID: <201603070040.u270eq7U019952@d01av03.pok.ibm.com>
References: <20160306120537.GA22702@intel.com><20160306121103.GA23480@intel.com>
	<20160306122816.GA24077@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0563738982233425745=="
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


--===============0563738982233425745==
Content-Type: multipart/alternative;
	boundary="=_alternative 0003BBD585257F6F_="


--=_alternative 0003BBD585257F6F_=
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


Here's the documentation patch:

https://github.com/stefanberger/linux/commit/bf1d11a67be64e580636c90cb8acba=
ce80e16ab7

If you have suggestions or comments, let me know.

I adjusted the code to reflect the ENOSYS (previously EINVAL) in case of=20
unsupported flags or unsupported ioctls.=20

Regards,
   Stefan



--=_alternative 0003BBD585257F6F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/06/2016 07:28:16 AM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Sun, Mar 06, 2016 at 02:11:03PM +0200, Jarkko Sakkinen wrote:<=
br>&gt; &gt; On Sun, Mar 06, 2016 at 02:05:37PM +0200, Jarkko Sakkinen wrot=
e:<br>&gt; &gt; &gt; Hi<br>&gt; &gt; &gt; <br>&gt; &gt; &gt; Some follow-up=
 question that have popped up while I've started
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
ailing<br>&gt; lists:</font></tt><br><br><br><tt><font size=3D2>Here's the =
documentation patch:</font></tt><br><br><a href=3Dhttps://github.com/stefan=
berger/linux/commit/bf1d11a67be64e580636c90cb8acbace80e16ab7><tt><font size=
=3D2 color=3Dblue>https://github.com/stefanberger/linux/commit/bf1d11a67be6=
4e580636c90cb8acbace80e16ab7</font></tt></a><br><br><tt><font size=3D2>If y=
ou have suggestions or comments, let me know.</font></tt><br><br><tt><font =
size=3D2>I adjusted the code to reflect the ENOSYS (previously
EINVAL) in case of unsupported flags or unsupported ioctls. </font></tt><br=
><br><tt><font size=3D2>Regards,</font></tt><br><tt><font size=3D2>&nbsp; &=
nbsp;Stefan</font></tt><br><BR>
--=_alternative 0003BBD585257F6F_=--



--===============0563738982233425745==
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
--===============0563738982233425745==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0563738982233425745==--
