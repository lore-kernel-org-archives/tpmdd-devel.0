From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Fri, 18 Dec 2015 08:40:44 -0500
Message-ID: <201512181340.tBIDepEE011860@d01av04.pok.ibm.com>
References: <1450021353-8775-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E682BF194@ABGEX74E.FSC.NET>
	<20151214095830.GA21291@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E682BF197@ABGEX74E.FSC.NET>
	<20151214112501.GA26100@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E682BF19D@ABGEX74E.FSC.NET>
	<20151215233237.GA31965@obsidianresearch.com>
	<201512161652.tBGGqWPG019442@d03av04.boulder.ibm.com>
	<20151216171633.GB32594@obsidianresearch.com>
	<201512161721.tBGHLqXh009986@d03av03.boulder.ibm.com>
	<20151216174523.GC32594@obsidianresearch.com>
	<201512161804.tBGI47vu000331@d01av02.pok.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E69407545@ABGEX74E.FSC.NET>
	<201512171533.tBHFXn35003792@d03av02.boulder.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754E@ABGEX74E.FSC.NET>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6008181921543339824=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <C5A28EF7B98F574C85C70238C8E9ECC04E6940754E-bIoXcEM4pvRAuK1PVaBULA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Wilck, Martin" <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============6008181921543339824==
Content-Type: multipart/alternative;
	boundary="=_alternative 004B25BD85257F1F_="


--=_alternative 004B25BD85257F1F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

"Wilck, Martin" <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org> wrote on 12/18/2015 06:21:01 =

AM:

>=20
> On Do, 2015-12-17 at 10:23 -0500, Stefan Berger wrote:
>=20
> > > kernel space. Can you point out a particular part of the problem
> > that
> > > could be solved better or more easily in user space?
> >=20
> > User space would handle any number of client applications. It would
> > handle
> > the arbitration between applications from concurrent TPM usage while
> > one
> > application needs to access the TPM for a sequence of commands that
> > requires
> > access to session and key slots. This application can use the TPM
> > directly
> > with commands it passes through /dev/tpm0, so there's no need for a
> > higher
> > level API (provided by the TPM driver) for the usage of the TPM or the
> > need
> > to intercept commands where one application's usage of the TPM would
> > interfere with another application's usage of TPM, such as one
> > application
> > swapping out the context of another applications keys/session and/or
> > deleting
> > another applications session and key handles.
>=20
> I had asked for things that user space could do *better* than the
> kernel. Could you point that out more clearly?

I don't think it can do things 'better' just keep it simpler in the=20
kernel.

   Stefan



--=_alternative 004B25BD85257F1F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>&quot;Wilck, Martin&quot; &lt;martin.wilck-RJz4owOZxyW1NAuuztSHSw@public.gmane.org=
m&gt;
wrote on 12/18/2015 06:21:01 AM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Do, 2015-12-17 at 10:23 -0500, Stefan Berger wrote:<br>&gt; <b=
r>&gt; &gt; &gt; kernel space. Can you point out a particular part of the
problem<br>&gt; &gt; that<br>&gt; &gt; &gt; could be solved better or more =
easily in user space?<br>&gt; &gt; <br>&gt; &gt; User space would handle an=
y number of client applications. It
would<br>&gt; &gt; handle<br>&gt; &gt; the arbitration between applications=
 from concurrent TPM usage
while<br>&gt; &gt; one<br>&gt; &gt; application needs to access the TPM for=
 a sequence of commands
that<br>&gt; &gt; requires<br>&gt; &gt; access to session and key slots. Th=
is application can use the
TPM<br>&gt; &gt; directly<br>&gt; &gt; with commands it passes through /dev=
/tpm0, so there's no need
for a<br>&gt; &gt; higher<br>&gt; &gt; level API (provided by the TPM drive=
r) for the usage of the TPM
or the<br>&gt; &gt; need<br>&gt; &gt; to intercept commands where one appli=
cation's usage of the TPM
would<br>&gt; &gt; interfere with another application's usage of TPM, such =
as one<br>&gt; &gt; application<br>&gt; &gt; swapping out the context of an=
other applications keys/session
and/or<br>&gt; &gt; deleting<br>&gt; &gt; another applications session and =
key handles.<br>&gt; <br>&gt; I had asked for things that user space could =
do *better* than the<br>&gt; kernel. Could you point that out more clearly?=
</font></tt><br><br><tt><font size=3D2>I don't think it can do things 'bett=
er' just keep
it simpler in the kernel.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbs=
p;Stefan</font></tt><br><BR>
--=_alternative 004B25BD85257F1F_=--



--===============6008181921543339824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============6008181921543339824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6008181921543339824==--
