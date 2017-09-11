From: "Nasim, Kam" <Kam.Nasim-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: TPM2.0: No binary_bios_measurements file in securityFS
Date: Mon, 11 Sep 2017 22:44:02 +0000
Message-ID: <CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751@ALA-MBC.corp.ad.wrs.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1738519581639240811=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============1738519581639240811==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751ALAMBCcorpadwrs_"

--_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751ALAMBCcorpadwrs_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi folks,

I am building my TPM 2.0 driver as Kernel modules (tpm.ko, tpm_tis_core.ko =
and tpm_tis.ko).

I noticed that while my /sys/kernel/security directory is created and mount=
ed to securityFS, it is empty.

Looking at tpm_bios_log_setup() in tpm1_event.log, I see that this is being=
 done during chip registration:

if (chip->flags & TPM_CHIP_FLAG_TPM2)
        chip->bin_log_seqops.seqops =3D
            &tpm2_binary_b_measurements_seqops;
    else
        chip->bin_log_seqops.seqops =3D
            &tpm_binary_b_measurements_seqops;


    chip->bios_dir[cnt] =3D
        securityfs_create_file("binary_bios_measurements",
                   0440, chip->bios_dir[0],
                   (void *)&chip->bin_log_seqops,
                   &tpm_bios_measurements_ops);
    if (IS_ERR(chip->bios_dir[cnt]))
        goto err;


My TPM modules are loaded properly and I can interact with TPM using usersp=
ace TSS2 applications:

$ sudo lsmod | grep tpm
Password:
tpm_crb                 6458  0
tpm_tis                 5950  0
tpm_tis_core           10054  1 tpm_tis
tpm                    48093  3 tpm_crb,tpm_tis,tpm_tis_core


2017-09-08T19:39:16.239 controller-0 kernel: warning [    0.000000] ACPI: T=
PM2 000000007b7c8000 00034 (v03 INTEL   S2600WT 00000002 INTL 01000013)
2017-09-08T19:39:16.252 controller-0 kernel: info [    5.457568] tpm_tis MS=
FT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)


How and when would this file be created? For that matter I don't even have =
a /sys/devices/pnp0/<pnp#>/pcrs file present
(I am on CentOS 7.3)


Thoughts?

Thanks,
Kam

--_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751ALAMBCcorpadwrs_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Hi folks,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><br>
I am building my TPM 2.0 driver as Kernel modules (tpm.ko, tpm_tis_core.ko =
and tpm_tis.ko).<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">I noticed that while my /sys/ke=
rnel/security directory is created and mounted to securityFS, it is empty.
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Looking at tpm_bios_log_setup()=
 in tpm1_event.log, I see that this is being done during chip registration:=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">if (chip-&gt;flags &amp; TPM_CH=
IP_FLAG_TPM2)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; chip-&gt;bin_log_seqops.seqops =3D<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;tpm2_binary_b_measurements_seqops;=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; else<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; chip-&gt;bin_log_seqops.seqops =3D<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;tpm_binary_b_measurements_seqops;<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; chip-&gt;bio=
s_dir[cnt] =3D<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; securityfs_create_file(&quot;binary_bios_measurements&quot;,<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0440, chip-&gt;bios_dir[0],<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; (void *)&amp;chip-&gt;bin_log_seqops,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; &amp;tpm_bios_measurements_ops);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; if (IS_ERR(c=
hip-&gt;bios_dir[cnt]))<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; goto err;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">My TPM modules are loaded prope=
rly and I can interact with TPM using userspace TSS2 applications:<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">$ sudo lsmod | grep tpm<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Password:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_crb&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 64=
58&nbsp; 0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 59=
50&nbsp; 0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis_core&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10054&nbsp; 1 tpm_tis<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; 48093&nbsp; 3 tpm_crb,tpm_tis,tpm_tis_core<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-08T19:39:16.239 control=
ler-0 kernel: warning [&nbsp;&nbsp;&nbsp; 0.000000] ACPI: TPM2 000000007b7c=
8000 00034 (v03 INTEL&nbsp;&nbsp; S2600WT 00000002 INTL 01000013)<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-08T19:39:16.252 control=
ler-0 kernel: info [&nbsp;&nbsp;&nbsp; 5.457568] tpm_tis MSFT0101:00: 2.0 T=
PM (device-id 0x1A, rev-id 16)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">How and when would this file be=
 created? For that matter I don&#8217;t even have a /sys/devices/pnp0/&lt;p=
np#&gt;/pcrs file present<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">(I am on CentOS 7.3)<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Thoughts?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Thanks,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Kam<o:p></o:p></span></p>
</div>
</body>
</html>

--_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751ALAMBCcorpadwrs_--


--===============1738519581639240811==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============1738519581639240811==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1738519581639240811==--
