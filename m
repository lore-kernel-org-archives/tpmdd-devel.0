From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Mon, 21 Dec 2015 09:23:11 -0500
Message-ID: <201512211423.tBLENMcx015842@d03av03.boulder.ibm.com>
References: <201512161804.tBGI47vu000331@d01av02.pok.ibm.com><C5A28EF7B98F574C85C70238C8E9ECC04E69407545@ABGEX74E.FSC.NET><201512171523.tBHFNlJ6013434@d03av03.boulder.ibm.com><9F48E1A823B03B4790B7E6E69430724DA58648F1@EXCH2010A.sit.fraunhofer.de><201512171620.tBHGK3GE030569@d03av04.boulder.ibm.com><9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de><C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET><20151218105148.GA12882@intel.com>
	<20151218105323.GB12882@intel.com><C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET><20151218114131.GA3287@intel.com>,
	<n5144n$1ug$1@ger.gmane.org>
	<9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7099680445285729315=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724DA586A57C-wI35/lLZEdRyXeJKmmMAp2SU2VBt9E6NG9Ur7JDdleE@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Kenneth Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============7099680445285729315==
Content-Type: multipart/alternative;
	boundary="=_alternative 004F08E985257F22_="


--=_alternative 004F08E985257F22_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

"Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org> wrote on 12/21/2015=20
08:22:04 AM:


>=20
> Let me emphasise this even more. It would be greate to have a=20
kernel-space TPM
> Resource Manager (everybody thinks to agree), but it would also bit=20
> a big module
> and a big programming investment.
>=20
> I ask the tpmdd-maintainers to check (reconcile with parent subsystem
> maintainers) if a 3-5 kLoC module would be generally acceptable for a=20
> TPM-ResourceManager?

Does that include TPM 2 only or also TPM 1.2 ? The need for a light-RM=20
inside the kernel
is also there for TPM 1.2.

Regards,
   Stefan



--=_alternative 004F08E985257F22_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>&quot;Fuchs, Andreas&quot; &lt;andreas.fuchs-iXjGqz/onsDV0Folhc9sRw@public.gmane.org=
fer.de&gt;
wrote on 12/21/2015 08:22:04 AM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; Let me emphasise this even more. It would be greate to have a=
 kernel-space
TPM<br>&gt; Resource Manager (everybody thinks to agree), but it would also=
 bit
<br>&gt; a big module<br>&gt; and a big programming investment.<br>&gt; <br=
>&gt; I ask the tpmdd-maintainers to check (reconcile with parent subsystem=
<br>&gt; maintainers) if a 3-5 kLoC module would be generally acceptable for
a <br>&gt; TPM-ResourceManager?</font></tt><br><br><tt><font size=3D2>Does =
that include TPM 2 only or also TPM 1.2 ? The
need for a light-RM inside the kernel</font></tt><br><tt><font size=3D2>is =
also there for TPM 1.2.</font></tt><br><br><tt><font size=3D2>Regards,</fon=
t></tt><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 004F08E985257F22_=--



--===============7099680445285729315==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============7099680445285729315==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7099680445285729315==--
