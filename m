From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] tpm: TPM2.0 eventlog securityfs
	support
Date: Tue, 20 Sep 2016 08:27:11 -0400
Message-ID: <OF5845BD05.5A60A8A0-ON00258034.00438FB6-85258034.004479CA@notes.na.collabserv.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830101611.GA11819@intel.com>
	<OFFF1DBFC5.1719C0A6-ON00258033.00514374-85258033.005192C5@notes.na.collabserv.com>
	<20160920100423.GB32433@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1879645544885283469=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160920100423.GB32433-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============1879645544885283469==
Content-Type: multipart/alternative;
	boundary="=_alternative 004479CA85258034_="


--=_alternative 004479CA85258034_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 09/20/2016=20
06:04:23 AM:


>=20
> On Mon, Sep 19, 2016 at 10:50:15AM -0400, Stefan Berger wrote:
> >    > You also fail to explain how this should work with ACPI even=20
though
> >    > we know that there does not exist any kind for event log through=20
ACPI
> >    > with TPM 2.0 hardware. I.e. just by reading the commits I=20
canobviously
> >    > see that you are doing major untested code path changes.
> >=20
> >    That's true there there's not spec for a BIOS at the moment and I=20
would
> >    expect that TCG will likely not write one. Likely all vendors have=20
moved
> >    on to (U)EFI. We realized this also while implementing TPM 2=20
support for
> >    SeaBIOS and I ended up reusing the ACPI TCPA table but adopted the=20
EFI
> >    specified log format with that special first entry. Can we=20
> accomodate that
> >    ?
>=20
> Does that match to "SHA1 Event Log Entry Format" defined in [1]? In
> addition "Crypto Agile Log Entry Format" must be supported.

SeaBIOS supports the SHA1 Event Log Entry Format [5.1 in that spec]. It=20
uses it for TPM 1.2.

https://code.coreboot.org/p/seabios/source/tree/master/src/std/tcg.h#L521

In case of TPM 2 it will write the first log entry in the format of the=20
Event Log Header [5.3].

https://code.coreboot.org/p/seabios/source/tree/master/src/std/tcg.h#L521

All subsequent entries in the log will be written in Crypto Agile Log=20
Entry Format [5.2].

Again:=20
https://code.coreboot.org/p/seabios/source/tree/master/src/std/tcg.h#L521

UEFI may write into some special buffer that the OS can get to via an API=20
call. In case of SeaBIOS this buffer is just in the TCPA ACPI table, as in =

TPM 1.2.


>=20
> Philip: what was the UEFI handover procedure that was discussed in
> TPM BoF at LSS 2016?
>=20
> >       Stefan
>=20
> [1] http://www.trustedcomputinggroup.org/wp-content/uploads/EFI-
> Protocol-Specification-rev13-160330final.pdf
>=20
> /Jarkko
>=20



--=_alternative 004479CA85258034_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 09/20/2016 06:04:23 AM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Mon, Sep 19, 2016 at 10:50:15AM -0400, Stefan Berger wrote=
:<br>&gt; &gt; &nbsp; &nbsp;&gt; You also fail to explain how this should w=
ork
with ACPI even though<br>&gt; &gt; &nbsp; &nbsp;&gt; we know that there doe=
s not exist any kind
for event log through ACPI<br>&gt; &gt; &nbsp; &nbsp;&gt; with TPM 2.0 hard=
ware. I.e. just by reading
the commits I canobviously<br>&gt; &gt; &nbsp; &nbsp;&gt; see that you are =
doing major untested code
path changes.<br>&gt; &gt; <br>&gt; &gt; &nbsp; &nbsp;That's true there the=
re's not spec for a BIOS at
the moment and I would<br>&gt; &gt; &nbsp; &nbsp;expect that TCG will likel=
y not write one. Likely
all vendors have moved<br>&gt; &gt; &nbsp; &nbsp;on to (U)EFI. We realized =
this also while implementing
TPM 2 support for<br>&gt; &gt; &nbsp; &nbsp;SeaBIOS and I ended up reusing =
the ACPI TCPA table
but adopted the EFI<br>&gt; &gt; &nbsp; &nbsp;specified log format with tha=
t special first entry.
Can we <br>&gt; accomodate that<br>&gt; &gt; &nbsp; &nbsp;?<br>&gt; <br>&gt=
; Does that match to &quot;SHA1 Event Log Entry Format&quot; defined
in [1]? In<br>&gt; addition &quot;Crypto Agile Log Entry Format&quot; must =
be supported.</font></tt><br><br><tt><font size=3D2>SeaBIOS supports the SH=
A1 Event Log Entry Format [5.1
in that spec]. It uses it for TPM 1.2.</font></tt><br><br><a href=3Dhttps:/=
/code.coreboot.org/p/seabios/source/tree/master/src/std/tcg.h#L521><tt><fon=
t size=3D2 color=3Dblue>https://code.coreboot.org/p/seabios/source/tree/mas=
ter/src/std/tcg.h#L521</font></tt></a><br><br><tt><font size=3D2>In case of=
 TPM 2 it will write the first log entry
in the format of the Event Log Header [5.3].</font></tt><br><br><a href=3Dh=
ttps://code.coreboot.org/p/seabios/source/tree/master/src/std/tcg.h#L521><t=
t><font size=3D2 color=3Dblue>https://code.coreboot.org/p/seabios/source/tr=
ee/master/src/std/tcg.h#L521</font></tt></a><br><br><tt><font size=3D2>All =
subsequent entries in the log will be written
in Crypto Agile Log Entry Format [5.2].</font></tt><br><br><tt><font size=
=3D2>Again: </font></tt><a href=3Dhttps://code.coreboot.org/p/seabios/sourc=
e/tree/master/src/std/tcg.h#L521><tt><font size=3D2 color=3Dblue>https://co=
de.coreboot.org/p/seabios/source/tree/master/src/std/tcg.h#L521</font></tt>=
</a><br><br><tt><font size=3D2>UEFI may write into some special buffer that=
 the OS
can get to via an API call. In case of SeaBIOS this buffer is just in the
TCPA ACPI table, as in TPM 1.2.</font></tt><br><br><tt><font size=3D2><br>&=
gt; <br>&gt; Philip: what was the UEFI handover procedure that was discusse=
d in<br>&gt; TPM BoF at LSS 2016?<br>&gt; <br>&gt; &gt; &nbsp; &nbsp; &nbsp=
; Stefan<br>&gt; <br>&gt; [1] </font></tt><a href=3D"http://www.trustedcomp=
utinggroup.org/wp-content/uploads/EFI-"><tt><font size=3D2>http://www.trust=
edcomputinggroup.org/wp-content/uploads/EFI-</font></tt></a><tt><font size=
=3D2><br>&gt; Protocol-Specification-rev13-160330final.pdf<br>&gt; <br>&gt;=
 /Jarkko<br>&gt; <br></font></tt><BR>
--=_alternative 004479CA85258034_=--



--===============1879645544885283469==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============1879645544885283469==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1879645544885283469==--
