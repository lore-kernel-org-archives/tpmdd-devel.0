From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: TPM2.0: No binary_bios_measurements file in
 securityFS
Date: Wed, 13 Sep 2017 17:33:56 +0530
Message-ID: <e9ea0327-ba94-cd19-f35f-dbfae5c8ab03@linux.vnet.ibm.com>
References: <CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751@ALA-MBC.corp.ad.wrs.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4324339177482879205=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751-/c0cZIGrDsgyzarUywkIaosyD1qQU09I@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Nasim, Kam" <Kam.Nasim-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

This is a multi-part message in MIME format.
--===============4324339177482879205==
Content-Type: multipart/alternative;
 boundary="------------318E33988B830231410FB72D"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------318E33988B830231410FB72D
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx0a-001b2d01.pphosted.com id v8DC3whT120961



On 09/12/2017 04:14 AM, Nasim, Kam wrote:
>
> Hi folks,
>
>
> I am building my TPM 2.0 driver as Kernel modules (tpm.ko,=20
> tpm_tis_core.ko and tpm_tis.ko).
>
> I noticed that while my /sys/kernel/security directory is created and=20
> mounted to securityFS, it is empty.
>
> Looking at tpm_bios_log_setup() in tpm1_event.log, I see that this is=20
> being done during chip registration:
>
TPM 2.0 binary_bios_measurements event log file support is currently not=20
available for ACPI based platform. It is only for device tree based=20
platform. And I think you are using ACPI.

Thanks & Regards,
 =A0=A0=A0 - Nayna
>
> if (chip->flags & TPM_CHIP_FLAG_TPM2)
>
> chip->bin_log_seqops.seqops =3D
>
> &tpm2_binary_b_measurements_seqops;
>
> =A0=A0=A0 else
>
> chip->bin_log_seqops.seqops =3D
>
> &tpm_binary_b_measurements_seqops;
>
> chip->bios_dir[cnt] =3D
>
> securityfs_create_file("binary_bios_measurements",
>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0440, chip->bios=
_dir[0],
>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (void *)&chip->b=
in_log_seqops,
>
> &tpm_bios_measurements_ops);
>
> =A0=A0=A0 if (IS_ERR(chip->bios_dir[cnt]))
>
> =A0=A0=A0=A0=A0=A0=A0 goto err;
>
> My TPM modules are loaded properly and I can interact with TPM using=20
> userspace TSS2 applications:
>
> $ sudo lsmod | grep tpm
>
> Password:
>
> tpm_crb 6458=A0 0
>
> tpm_tis 5950=A0 0
>
> tpm_tis_core 10054=A0 1 tpm_tis
>
> tpm 48093=A0 3 tpm_crb,tpm_tis,tpm_tis_core
>
> 2017-09-08T19:39:16.239 controller-0 kernel: warning [=A0=A0=A0 0.00000=
0]=20
> ACPI: TPM2 000000007b7c8000 00034 (v03 INTEL=A0=A0 S2600WT 00000002 INT=
L=20
> 01000013)
>
> 2017-09-08T19:39:16.252 controller-0 kernel: info [=A0=A0=A0 5.457568]=20
> tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)
>
> How and when would this file be created? For that matter I don=92t even=
=20
> have a /sys/devices/pnp0/<pnp#>/pcrs file present
>
> (I am on CentOS 7.3)
>
> Thoughts?
>
> Thanks,
>
> Kam
>
>
>
> -----------------------------------------------------------------------=
-------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, Slashdot.org! http://sdm.link/slashdot
>
>
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel


--------------318E33988B830231410FB72D
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx0a-001b2d01.pphosted.com id v8DC3whT120961

<html>
  <head>
    <meta http-equiv=3D"Content-Type" content=3D"text/html;
      charset=3Dwindows-1252">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <p><br>
    </p>
    <br>
    <div class=3D"moz-cite-prefix">On 09/12/2017 04:14 AM, Nasim, Kam
      wrote:<br>
    </div>
    <blockquote type=3D"cite"
cite=3D"mid:CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751-/c0cZIGrDsgyzarUywkIak48LkL9auvm@public.gmane.org=
com">
      <meta http-equiv=3D"Content-Type" content=3D"text/html;
        charset=3Dwindows-1252">
      <meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered
        medium)">
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
      <div class=3D"WordSection1">
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">Hi folks,<o:p></o:p><=
/span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><br>
            I am building my TPM 2.0 driver as Kernel modules (tpm.ko,
            tpm_tis_core.ko and tpm_tis.ko).<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">I noticed that while =
my
            /sys/kernel/security directory is created and mounted to
            securityFS, it is empty.
            <o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">Looking at
            tpm_bios_log_setup() in tpm1_event.log, I see that this is
            being done during chip registration:</span></p>
      </div>
    </blockquote>
    TPM 2.0 binary_bios_measurements event log file support is currently
    not available for ACPI based platform. It is only for device tree
    based platform. And I think you are using ACPI.<br>
    <br>
    Thanks &amp; Regards,<br>
    =A0=A0=A0 - Nayna<br>
    <blockquote type=3D"cite"
cite=3D"mid:CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751-/c0cZIGrDsgyzarUywkIak48LkL9auvm@public.gmane.org=
com">
      <div class=3D"WordSection1">
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p></o:p></span></p=
>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">if (chip-&gt;flags &a=
mp;
            TPM_CHIP_FLAG_TPM2)<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0=A0=A0=A0=A0
            chip-&gt;bin_log_seqops.seqops =3D<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0
            &amp;tpm2_binary_b_measurements_seqops;<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0 else<o:p></=
o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0=A0=A0=A0=A0
            chip-&gt;bin_log_seqops.seqops =3D<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0
            &amp;tpm_binary_b_measurements_seqops;<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0
            chip-&gt;bios_dir[cnt] =3D<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0=A0=A0=A0=A0
            securityfs_create_file("binary_bios_measurements",<o:p></o:p>=
</span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0440,
            chip-&gt;bios_dir[0],<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (void
            *)&amp;chip-&gt;bin_log_seqops,<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
            &amp;tpm_bios_measurements_ops);<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0 if
            (IS_ERR(chip-&gt;bios_dir[cnt]))<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">=A0=A0=A0=A0=A0=A0=A0=
 goto err;<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">My TPM modules are
            loaded properly and I can interact with TPM using userspace
            TSS2 applications:<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">$ sudo lsmod | grep t=
pm<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">Password:<o:p></o:p><=
/span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_crb=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
            6458=A0 0<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
            5950=A0 0<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis_core=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0
            10054=A0 1 tpm_tis<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
            48093=A0 3 tpm_crb,tpm_tis,tpm_tis_core<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-08T19:39:16.2=
39
            controller-0 kernel: warning [=A0=A0=A0 0.000000] ACPI: TPM2
            000000007b7c8000 00034 (v03 INTEL=A0=A0 S2600WT 00000002 INTL
            01000013)<o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-08T19:39:16.2=
52
            controller-0 kernel: info [=A0=A0=A0 5.457568] tpm_tis
            MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)<o:p></o:p></=
span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">How and when would th=
is
            file be created? For that matter I don=92t even have a
            /sys/devices/pnp0/&lt;pnp#&gt;/pcrs file present<o:p></o:p></=
span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">(I am on CentOS 7.3)<=
o:p></o:p></span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">Thoughts?<o:p></o:p><=
/span></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>=A0</o:p></span>=
</p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">Thanks,<o:p></o:p></s=
pan></p>
        <p class=3D"MsoNormal"><span lang=3D"EN-CA">Kam<o:p></o:p></span>=
</p>
      </div>
      <br>
      <fieldset class=3D"mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap=3D"">----------------------------------------------------=
--------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! <a class=3D"moz-txt-link-freetext" hre=
f=3D"http://sdm.link/slashdot">http://sdm.link/slashdot</a></pre>
      <br>
      <fieldset class=3D"mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap=3D"">_______________________________________________
tpmdd-devel mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:tpmdd-devel-5NWGOfrQmnc@public.gmane.org=
urceforge.net">tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://lists.sourceforge.net/=
lists/listinfo/tpmdd-devel">https://lists.sourceforge.net/lists/listinfo/=
tpmdd-devel</a>
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------318E33988B830231410FB72D--



--===============4324339177482879205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============4324339177482879205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4324339177482879205==--
