From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] tpm: TPM2.0 eventlog securityfs
	support
Date: Mon, 19 Sep 2016 10:50:15 -0400
Message-ID: <OFFF1DBFC5.1719C0A6-ON00258033.00514374-85258033.005192C5@notes.na.collabserv.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830101611.GA11819@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8118222765745640979=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160830101611.GA11819-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============8118222765745640979==
Content-Type: multipart/alternative;
	boundary="=_alternative 005192C585258033_="


--=_alternative 005192C585258033_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 08/30/2016=20
06:16:11 AM:

>=20
> On Tue, Aug 30, 2016 at 12:50:12AM -0400, Nayna Jain wrote:
> > Existing TPM2.0 support lacks the support for eventlog securityfs=20
file.
> > This patch adds the binary=5Fbios=5Fmeasurements to TPM2.0 eventlog
> > securityfs file.
>=20
> This is kind of patch set that would require very elaborate description
> how the problem was solved. I cannot really mirror the patches to
> anything (especially as the commit messages in commits are also very low
> quality).
>=20
> If you write bad commit messages, it leaves me worried that the quality
> is low by other measure.
>=20
> This is just an example but I do not know how this scales with=20
algorithmic=20
> agility.=20
>=20
> You also fail to explain how this should work with ACPI even though
> we know that there does not exist any kind for event log through ACPI
> with TPM 2.0 hardware. I.e. just by reading the commits I can obviously
> see that you are doing major untested code path changes.

That's true there there's not spec for a BIOS at the moment and I would=20
expect that TCG will likely not write one. Likely all vendors have moved=20
on to (U)EFI. We realized this also while implementing TPM 2 support for=20
SeaBIOS and I ended up reusing the ACPI TCPA table but adopted the EFI=20
specified log format with that special first entry. Can we accomodate that =

?

   Stefan


>=20
> This will need a lot of rework...
>=20
> > Additionally, it also includes the review feedbacks as suggested by
> > Jason.
> >=20
> > Further, commit msg subject line is prefixed with tpm as was suggested
> > by Jarkko.
> >=20
> > Changelog v3:
> >=20
> > * Includes the review feedbacks as suggested by Jason
> >         * Split of patches into one patch per idea
> >         * Generic open() method for ascii/bios measurements
> >         * Replacement of of **bios=5Fdir with *bios=5Fdir[3]
> >         * Verifying readlog() is successful before creating
> >         securityfs entries
> >         * Generic readlog() to check for ACPI/OF in sequence
> >    * read=5Flog=5Fof() method now uses of=5Fnode propertry rather than
> >         calling find=5Fdevice=5Fby=5Fname
> >    * read=5Flog differentiates vtpm/tpm using its compatible property
> >    * Cleans pr=5Ferr with dev=5Fdbg
> >    * Commit msgs subject line prefixed with tpm
>=20
> BTW, what is the logic in this indentation.
>=20
> >=20
> > Nayna Jain (7):
> >   tpm: Define a generic open() method for ascii & bios measurements.
> >   tpm: Replace the dynamically allocated bios=5Fdir as struct dentry
> >     array.
> >   tpm: Validate the eventlog access before tpm=5Fbios=5Flog=5Fsetup
> >   tpm: Redefine the read=5Flog method to check for ACPI/OF properties
> >     sequentially
> >   tpm: Replace the of=5Ffind=5Fnode=5Fby=5Fname() with dev of=5Fnode pr=
operty
> >   tpm: Moves the eventlog init functions to tpm=5Feventlog=5Finit.c
> >   tpm: Adds securityfs support for TPM2.0 eventlog
> >=20
> >  drivers/char/tpm/Makefile            |  13 +-
> >  drivers/char/tpm/tpm-chip.c          |  21 +---
> >  drivers/char/tpm/tpm.h               |   7 +-
> >  drivers/char/tpm/tpm2.h              |  85 +++++++++++++
> >  drivers/char/tpm/tpm2=5Feventlog.c     | 224 ++++++++++++++++++++++
> +++++++++++++
> >  drivers/char/tpm/tpm=5Facpi.c          |  19 +--
> >  drivers/char/tpm/tpm=5Feventlog.c      | 154 +-----------------------
> >  drivers/char/tpm/tpm=5Feventlog.h      |  26 ++--
> >  drivers/char/tpm/tpm=5Feventlog=5Finit.c | 153 ++++++++++++++++++++++++
> >  drivers/char/tpm/tpm=5Fof.c            |  65 ++++++----
> >  10 files changed, 543 insertions(+), 224 deletions(-)
> >  create mode 100644 drivers/char/tpm/tpm2.h
> >  create mode 100644 drivers/char/tpm/tpm2=5Feventlog.c
> >  create mode 100644 drivers/char/tpm/tpm=5Feventlog=5Finit.c
> >=20
> > --=20
> > 2.5.0
> >=20
> >=20
> >=20
>=20
---------------------------------------------------------------------------=
---
> > =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> > tpmdd-devel mailing list
> > tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
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



--=_alternative 005192C585258033_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 08/30/2016 06:16:11 AM:<br><br>&gt; <br>&gt; On Tue, Aug 30, 2016 =
at 12:50:12AM -0400, Nayna Jain wrote:<br>&gt; &gt; Existing TPM2.0 support=
 lacks the support for eventlog securityfs
file.<br>&gt; &gt; This patch adds the binary=5Fbios=5Fmeasurements to TPM2=
.0 eventlog<br>&gt; &gt; securityfs file.<br>&gt; <br>&gt; This is kind of =
patch set that would require very elaborate description<br>&gt; how the pro=
blem was solved. I cannot really mirror the patches to<br>&gt; anything (es=
pecially as the commit messages in commits are also very
low<br>&gt; quality).<br>&gt; <br>&gt; If you write bad commit messages, it=
 leaves me worried that the quality<br>&gt; is low by other measure.<br>&gt=
; <br>&gt; This is just an example but I do not know how this scales with a=
lgorithmic
<br>&gt; agility. <br>&gt; <br>&gt; You also fail to explain how this shoul=
d work with ACPI even though<br>&gt; we know that there does not exist any =
kind for event log through ACPI<br>&gt; with TPM 2.0 hardware. I.e. just by=
 reading the commits I can obviously<br>&gt; see that you are doing major u=
ntested code path changes.</font></tt><br><br><tt><font size=3D2>That's tru=
e there there's not spec for a BIOS at the
moment and I would expect that TCG will likely not write one. Likely all
vendors have moved on to (U)EFI. We realized this also while implementing
TPM 2 support for SeaBIOS and I ended up reusing the ACPI TCPA table but
adopted the EFI specified log format with that special first entry. Can
we accomodate that ?</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Ste=
fan</font></tt><br><br><tt><font size=3D2><br>&gt; <br>&gt; This will need =
a lot of rework...<br>&gt; <br>&gt; &gt; Additionally, it also includes the=
 review feedbacks as suggested
by<br>&gt; &gt; Jason.<br>&gt; &gt; <br>&gt; &gt; Further, commit msg subje=
ct line is prefixed with tpm as was
suggested<br>&gt; &gt; by Jarkko.<br>&gt; &gt; <br>&gt; &gt; Changelog v3:<=
br>&gt; &gt; <br>&gt; &gt; * Includes the review feedbacks as suggested by =
Jason<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; * Split of patches into one =
patch
per idea<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; * Generic open() method f=
or ascii/bios
measurements<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; * Replacement of of *=
*bios=5Fdir with
*bios=5Fdir[3]<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; * Verifying readlog=
() is successful
before creating<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; securityfs entries=
<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; * Generic readlog() to check for
ACPI/OF in sequence<br>&gt; &gt; &nbsp; &nbsp;* read=5Flog=5Fof() method no=
w uses of=5Fnode propertry
rather than<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; calling find=5Fdevice=
=5Fby=5Fname<br>&gt; &gt; &nbsp; &nbsp;* read=5Flog differentiates vtpm/tpm=
 using its compatible
property<br>&gt; &gt; &nbsp; &nbsp;* Cleans pr=5Ferr with dev=5Fdbg<br>&gt;=
 &gt; &nbsp; &nbsp;* Commit msgs subject line prefixed with tpm<br>&gt; <br=
>&gt; BTW, what is the logic in this indentation.<br>&gt; <br>&gt; &gt; <br=
>&gt; &gt; Nayna Jain (7):<br>&gt; &gt; &nbsp; tpm: Define a generic open()=
 method for ascii &amp; bios
measurements.<br>&gt; &gt; &nbsp; tpm: Replace the dynamically allocated bi=
os=5Fdir as struct
dentry<br>&gt; &gt; &nbsp; &nbsp; array.<br>&gt; &gt; &nbsp; tpm: Validate =
the eventlog access before tpm=5Fbios=5Flog=5Fsetup<br>&gt; &gt; &nbsp; tpm=
: Redefine the read=5Flog method to check for ACPI/OF
properties<br>&gt; &gt; &nbsp; &nbsp; sequentially<br>&gt; &gt; &nbsp; tpm:=
 Replace the of=5Ffind=5Fnode=5Fby=5Fname() with dev of=5Fnode
property<br>&gt; &gt; &nbsp; tpm: Moves the eventlog init functions to tpm=
=5Feventlog=5Finit.c<br>&gt; &gt; &nbsp; tpm: Adds securityfs support for T=
PM2.0 eventlog<br>&gt; &gt; <br>&gt; &gt; &nbsp;drivers/char/tpm/Makefile &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;| &nbsp;13 +-<br>&gt; &gt; &nbsp;drivers/char/tpm/tpm-chip.c &nbsp; &=
nbsp; &nbsp; &nbsp;
&nbsp;| &nbsp;21 +---<br>&gt; &gt; &nbsp;drivers/char/tpm/tpm.h &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; | &nbsp; 7 +-<br>&gt; &gt; &nbsp;drivers/char/tpm/tpm2.h &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;| &nbsp;85 +++++++++++++<br>&gt; &gt; &nbsp;drivers/char/tpm/t=
pm2=5Feventlog.c &nbsp; &nbsp; | 224 ++++++++++++++++++++++<br>&gt; +++++++=
++++++<br>&gt; &gt; &nbsp;drivers/char/tpm/tpm=5Facpi.c &nbsp; &nbsp; &nbsp=
; &nbsp;
&nbsp;| &nbsp;19 +--<br>&gt; &gt; &nbsp;drivers/char/tpm/tpm=5Feventlog.c &=
nbsp; &nbsp; &nbsp;| 154
+-----------------------<br>&gt; &gt; &nbsp;drivers/char/tpm/tpm=5Feventlog=
.h &nbsp; &nbsp; &nbsp;| &nbsp;26
++--<br>&gt; &gt; &nbsp;drivers/char/tpm/tpm=5Feventlog=5Finit.c | 153 ++++=
++++++++++++++++++++<br>&gt; &gt; &nbsp;drivers/char/tpm/tpm=5Fof.c &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;| &nbsp;65 ++++++----<br>&gt; &gt; &nbsp;10 files changed, 543 insert=
ions(+), 224 deletions(-)<br>&gt; &gt; &nbsp;create mode 100644 drivers/cha=
r/tpm/tpm2.h<br>&gt; &gt; &nbsp;create mode 100644 drivers/char/tpm/tpm2=5F=
eventlog.c<br>&gt; &gt; &nbsp;create mode 100644 drivers/char/tpm/tpm=5Feve=
ntlog=5Finit.c<br>&gt; &gt; <br>&gt; &gt; -- <br>&gt; &gt; 2.5.0<br>&gt; &g=
t; <br>&gt; &gt; <br>&gt; &gt; <br>&gt; -----------------------------------=
-------------------------------------------<br>&gt; &gt; =5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F<br>&gt; &gt; tpmdd-devel m=
ailing list<br>&gt; &gt; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>&gt; &gt; </f=
ont></tt><a href=3D"https://lists.sourceforge.net/lists/listinfo/tpmdd-deve=
l"><tt><font size=3D2>https://lists.sourceforge.net/lists/listinfo/tpmdd-de=
vel</font></tt></a><tt><font size=3D2><br>&gt; <br>&gt; /Jarkko<br>&gt; <br=
>&gt; ---------------------------------------------------------------------=
---------<br>&gt; =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F<br>&gt; tpmdd-devel mailing list<br>&gt; tpmdd-devel-5NWGOfrQmncRDUWM+popnw@public.gmane.org=
forge.net<br>&gt; </font></tt><a href=3D"https://lists.sourceforge.net/list=
s/listinfo/tpmdd-devel"><tt><font size=3D2>https://lists.sourceforge.net/li=
sts/listinfo/tpmdd-devel</font></tt></a><tt><font size=3D2><br>&gt; <br></f=
ont></tt><BR>
--=_alternative 005192C585258033_=--



--===============8118222765745640979==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============8118222765745640979==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8118222765745640979==--
