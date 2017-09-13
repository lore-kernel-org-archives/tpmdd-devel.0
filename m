From: "Nasim, Kam" <Kam.Nasim-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: Re: TPM2.0: No binary_bios_measurements file in
 securityFS
Date: Wed, 13 Sep 2017 15:01:16 +0000
Message-ID: <CA352AD04C14CE4985F6AEB6AB8C130E3EDB8A6E@ALA-MBC.corp.ad.wrs.com>
References: <CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751@ALA-MBC.corp.ad.wrs.com>
 <e9ea0327-ba94-cd19-f35f-dbfae5c8ab03@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1397196585409548370=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <e9ea0327-ba94-cd19-f35f-dbfae5c8ab03-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============1397196585409548370==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8A6EALAMBCcorpadwrs_"

--_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8A6EALAMBCcorpadwrs_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thank you Nayna for getting back to me, yes I am using ACPI so that would e=
xplain it.

Which brings me to my last issue, I am not seeing the PCRS file in either o=
f these locations:
/sys/devices/pnp0/<pnp#>/pcrs
/sys/devices/platform/tpm_tis/pcrs

I am loading TPM as kernel modules so is this behavior not supported when T=
PM is not built-in, or are these files specific to TPM 1.2?


Thanks,
Kam
From: Nayna Jain [mailto:nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org]
Sent: Wednesday, September 13, 2017 8:04 AM
To: Nasim, Kam; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Subject: Re: [tpmdd-devel] TPM2.0: No binary_bios_measurements file in secu=
rityFS




On 09/12/2017 04:14 AM, Nasim, Kam wrote:
Hi folks,

I am building my TPM 2.0 driver as Kernel modules (tpm.ko, tpm_tis_core.ko =
and tpm_tis.ko).

I noticed that while my /sys/kernel/security directory is created and mount=
ed to securityFS, it is empty.

Looking at tpm_bios_log_setup() in tpm1_event.log, I see that this is being=
 done during chip registration:
TPM 2.0 binary_bios_measurements event log file support is currently not av=
ailable for ACPI based platform. It is only for device tree based platform.=
 And I think you are using ACPI.

Thanks & Regards,
    - Nayna


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




---------------------------------------------------------------------------=
---

Check out the vibrant tech community on one of the world's most

engaging tech sites, Slashdot.org! http://sdm.link/slashdot




_______________________________________________

tpmdd-devel mailing list

tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>

https://lists.sourceforge.net/lists/listinfo/tpmdd-devel


--_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8A6EALAMBCcorpadwrs_
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
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:black;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p
	{mso-style-priority:99;
	mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:black;}
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";
	color:black;}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:Consolas;
	color:black;}
span.EmailStyle21
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
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
<body bgcolor=3D"white" lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Thank you Nayna for ge=
tting back to me, yes I am using ACPI so that would explain it.<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Which brings me to my =
last issue, I am not seeing the PCRS file in either of these locations:<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">/sys/devices/pnp0/&lt;pnp#&gt;/=
pcrs<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">/sys/devices/platform/tpm_tis/p=
crs<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">I am loading TPM as ke=
rnel modules so is this behavior not supported when TPM is not built-in, or=
 are these files specific to TPM 1.2?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Thanks,<br>
Kam<o:p></o:p></span></p>
<div>
<div style=3D"border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0in =
0in 0in">
<p class=3D"MsoNormal"><b><span style=3D"font-size:10.0pt;font-family:&quot=
;Tahoma&quot;,&quot;sans-serif&quot;;color:windowtext">From:</span></b><spa=
n style=3D"font-size:10.0pt;font-family:&quot;Tahoma&quot;,&quot;sans-serif=
&quot;;color:windowtext"> Nayna Jain [mailto:nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org]
<br>
<b>Sent:</b> Wednesday, September 13, 2017 8:04 AM<br>
<b>To:</b> Nasim, Kam; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>
<b>Subject:</b> Re: [tpmdd-devel] TPM2.0: No binary_bios_measurements file =
in securityFS<o:p></o:p></span></p>
</div>
</div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<div>
<p class=3D"MsoNormal">On 09/12/2017 04:14 AM, Nasim, Kam wrote:<o:p></o:p>=
</p>
</div>
<blockquote style=3D"margin-top:5.0pt;margin-bottom:5.0pt">
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Hi folks,</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><br>
I am building my TPM 2.0 driver as Kernel modules (tpm.ko, tpm_tis_core.ko =
and tpm_tis.ko).</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">I noticed that while my /sys/ke=
rnel/security directory is created and mounted to securityFS, it is empty.
</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Looking at tpm_bios_log_setup()=
 in tpm1_event.log, I see that this is being done during chip registration:=
</span><o:p></o:p></p>
</blockquote>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ti=
mes New Roman&quot;,&quot;serif&quot;">TPM 2.0 binary_bios_measurements eve=
nt log file support is currently not available for ACPI based platform. It =
is only for device tree based platform. And I think you
 are using ACPI.<br>
<br>
Thanks &amp; Regards,<br>
&nbsp;&nbsp;&nbsp; - Nayna<br>
<br>
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">if (chip-&gt;flags &amp; TPM_CH=
IP_FLAG_TPM2)</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; chip-&gt;bin_log_seqops.seqops =3D</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;tpm2_binary_b_measurements_seqops;=
</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; else</span><=
o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; chip-&gt;bin_log_seqops.seqops =3D</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;tpm_binary_b_measurements_seqops;<=
/span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; chip-&gt;bio=
s_dir[cnt] =3D</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; securityfs_create_file(&quot;binary_bios_measurements&quot;,</s=
pan><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0440, chip-&gt;bios_dir[0],</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; (void *)&amp;chip-&gt;bin_log_seqops,</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; &amp;tpm_bios_measurements_ops);</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; if (IS_ERR(c=
hip-&gt;bios_dir[cnt]))</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; goto err;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">My TPM modules are loaded prope=
rly and I can interact with TPM using userspace TSS2 applications:</span><o=
:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">$ sudo lsmod | grep tpm</span><=
o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Password:</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_crb&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 64=
58&nbsp; 0</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 59=
50&nbsp; 0</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis_core&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10054&nbsp; 1 tpm_tis</span><o:p>=
</o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; 48093&nbsp; 3 tpm_crb,tpm_tis,tpm_tis_core</span><o:p></o:p></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-08T19:39:16.239 control=
ler-0 kernel: warning [&nbsp;&nbsp;&nbsp; 0.000000] ACPI: TPM2 000000007b7c=
8000 00034 (v03 INTEL&nbsp;&nbsp; S2600WT 00000002 INTL 01000013)</span><o:=
p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-08T19:39:16.252 control=
ler-0 kernel: info [&nbsp;&nbsp;&nbsp; 5.457568] tpm_tis MSFT0101:00: 2.0 T=
PM (device-id 0x1A, rev-id 16)</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">How and when would this file be=
 created? For that matter I don&#8217;t even have a /sys/devices/pnp0/&lt;p=
np#&gt;/pcrs file present</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">(I am on CentOS 7.3)</span><o:p=
></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Thoughts?</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Thanks,</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Kam</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ti=
mes New Roman&quot;,&quot;serif&quot;"><br>
<br>
<br>
<o:p></o:p></span></p>
<pre>----------------------------------------------------------------------=
--------<o:p></o:p></pre>
<pre>Check out the vibrant tech community on one of the world's most<o:p></=
o:p></pre>
<pre>engaging tech sites, Slashdot.org! <a href=3D"http://sdm.link/slashdot=
">http://sdm.link/slashdot</a><o:p></o:p></pre>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ti=
mes New Roman&quot;,&quot;serif&quot;"><br>
<br>
<br>
<o:p></o:p></span></p>
<pre>_______________________________________________<o:p></o:p></pre>
<pre>tpmdd-devel mailing list<o:p></o:p></pre>
<pre><a href=3D"mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org">tpmdd-devel@lists=
.sourceforge.net</a><o:p></o:p></pre>
<pre><a href=3D"https://lists.sourceforge.net/lists/listinfo/tpmdd-devel">h=
ttps://lists.sourceforge.net/lists/listinfo/tpmdd-devel</a><o:p></o:p></pre=
>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ti=
mes New Roman&quot;,&quot;serif&quot;"><o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8A6EALAMBCcorpadwrs_--


--===============1397196585409548370==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============1397196585409548370==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1397196585409548370==--
