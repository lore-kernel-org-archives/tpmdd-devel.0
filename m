From: Thiebaud Weksteen via tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: TPM2.0: No binary_bios_measurements file in
 securityFS
Date: Tue, 12 Sep 2017 08:40:43 +0200
Message-ID: <CA+zpnLcwMaHAEEE0rTnL-TLixK6J7mXpX8t=J7QVxk8nLEMxAw@mail.gmail.com>
References: <CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751@ALA-MBC.corp.ad.wrs.com>
Reply-To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2068726749024591944=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CA352AD04C14CE4985F6AEB6AB8C130E3EDB8751-/c0cZIGrDsgyzarUywkIaosyD1qQU09I@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Nasim, Kam" <Kam.Nasim-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============2068726749024591944==
Content-Type: multipart/alternative; boundary="001a11448a0cc672470558f8531b"

--001a11448a0cc672470558f8531b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kam,

Access to the binary event log for TPM 2.0 is not fully supported. I've
recently sent a patch to implement it: https://lkml.org/lkml/2017/9/11/118

Thanks,
Thiebaud

On Tue, Sep 12, 2017 at 12:44 AM, Nasim, Kam <Kam.Nasim-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
wrote:

> Hi folks,
>
>
> I am building my TPM 2.0 driver as Kernel modules (tpm.ko, tpm_tis_core.k=
o
> and tpm_tis.ko).
>
>
>
> I noticed that while my /sys/kernel/security directory is created and
> mounted to securityFS, it is empty.
>
>
>
> Looking at tpm_bios_log_setup() in tpm1_event.log, I see that this is
> being done during chip registration:
>
>
>
> if (chip->flags & TPM_CHIP_FLAG_TPM2)
>
>         chip->bin_log_seqops.seqops =3D
>
>             &tpm2_binary_b_measurements_seqops;
>
>     else
>
>         chip->bin_log_seqops.seqops =3D
>
>             &tpm_binary_b_measurements_seqops;
>
>
>
>
>
>     chip->bios_dir[cnt] =3D
>
>         securityfs_create_file("binary_bios_measurements",
>
>                    0440, chip->bios_dir[0],
>
>                    (void *)&chip->bin_log_seqops,
>
>                    &tpm_bios_measurements_ops);
>
>     if (IS_ERR(chip->bios_dir[cnt]))
>
>         goto err;
>
>
>
>
>
> My TPM modules are loaded properly and I can interact with TPM using
> userspace TSS2 applications:
>
>
>
> $ sudo lsmod | grep tpm
>
> Password:
>
> tpm_crb                 6458  0
>
> tpm_tis                 5950  0
>
> tpm_tis_core           10054  1 tpm_tis
>
> tpm                    48093  3 tpm_crb,tpm_tis,tpm_tis_core
>
>
>
>
>
> 2017-09-08T19:39:16.239 controller-0 kernel: warning [    0.000000] ACPI:
> TPM2 000000007b7c8000 00034 (v03 INTEL   S2600WT 00000002 INTL 01000013)
>
> 2017-09-08T19:39:16.252 controller-0 kernel: info [    5.457568] tpm_tis
> MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)
>
>
>
>
>
> How and when would this file be created? For that matter I don=E2=80=99t =
even have
> a /sys/devices/pnp0/<pnp#>/pcrs file present
>
> (I am on CentOS 7.3)
>
>
>
>
>
> Thoughts?
>
>
>
> Thanks,
>
> Kam
>
> ------------------------------------------------------------
> ------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, Slashdot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>
>

--001a11448a0cc672470558f8531b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Kam,<div><br></div><div>Access to the binary event log =
for TPM 2.0 is not fully supported. I&#39;ve recently sent a patch to imple=
ment it:=C2=A0<a href=3D"https://lkml.org/lkml/2017/9/11/118">https://lkml.=
org/lkml/2017/9/11/118</a></div><div><br></div><div>Thanks,</div><div>Thieb=
aud</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On=
 Tue, Sep 12, 2017 at 12:44 AM, Nasim, Kam <span dir=3D"ltr">&lt;<a href=3D=
"mailto:Kam.Nasim-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org" target=3D"_blank">Kam.Nasim-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">





<div lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"m_5930658149515264975WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Hi folks,<u></u><u></u></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><br>
I am building my TPM 2.0 driver as Kernel modules (tpm.ko, tpm_tis_core.ko =
and tpm_tis.ko).<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">I noticed that while my /sys/ke=
rnel/security directory is created and mounted to securityFS, it is empty.
<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Looking at tpm_bios_log_setup()=
 in tpm1_event.log, I see that this is being done during chip registration:=
<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">if (chip-&gt;flags &amp; TPM_CH=
IP_FLAG_TPM2)<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 chip-&gt;bin_log_seqops.seqops =3D<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &amp;tpm2_binary_b_measurements_<wbr>s=
eqops;<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0 else<u></u><=
u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 chip-&gt;bin_log_seqops.seqops =3D<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &amp;tpm_binary_b_measurements_<wbr>se=
qops;<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0 chip-&gt;bio=
s_dir[cnt] =3D<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 securityfs_create_file(&quot;<wbr>binary_bios_measurements&quo=
t;,<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0440, chip-&gt;bios_dir[0],<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 (void *)&amp;chip-&gt;bin_log_seqops,<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 &amp;tpm_bios_measurements_ops);<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0 if (IS_ERR(c=
hip-&gt;bios_dir[cnt]))<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 goto err;<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">My TPM modules are loaded prope=
rly and I can interact with TPM using userspace TSS2 applications:<u></u><u=
></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">$ sudo lsmod | grep tpm<u></u><=
u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Password:<u></u><u></u></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_crb=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 64=
58=C2=A0 0<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 59=
50=C2=A0 0<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis_core=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 10054=C2=A0 1 tpm_tis<u></u><u><=
/u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 48093=C2=A0 3 tpm_crb,tpm_tis,tpm_tis_core<u></u><u></u></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-08T19:39:16.239 control=
ler-0 kernel: warning [=C2=A0=C2=A0=C2=A0 0.000000] ACPI: TPM2 000000007b7c=
8000 00034 (v03 INTEL=C2=A0=C2=A0 S2600WT 00000002 INTL 01000013)<u></u><u>=
</u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-08T19:39:16.252 control=
ler-0 kernel: info [=C2=A0=C2=A0=C2=A0 5.457568] tpm_tis MSFT0101:00: 2.0 T=
PM (device-id 0x1A, rev-id 16)<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">How and when would this file be=
 created? For that matter I don=E2=80=99t even have a /sys/devices/pnp0/&lt=
;pnp#&gt;/pcrs file present<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">(I am on CentOS 7.3)<u></u><u><=
/u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Thoughts?<u></u><u></u></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Thanks,<u></u><u></u></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Kam<u></u><u></u></span></p>
</div>
</div>

<br>------------------------------<wbr>------------------------------<wbr>-=
-----------------<br>
Check out the vibrant tech community on one of the world&#39;s most<br>
engaging tech sites, Slashdot.org! <a href=3D"http://sdm.link/slashdot" rel=
=3D"noreferrer" target=3D"_blank">http://sdm.link/slashdot</a><br>_________=
_____________________<wbr>_________________<br>
tpmdd-devel mailing list<br>
<a href=3D"mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org">tpmdd-devel-5NWGOfrQmnd4wTydcyPnfg@public.gmane.org=
ceforge.<wbr>net</a><br>
<a href=3D"https://lists.sourceforge.net/lists/listinfo/tpmdd-devel" rel=3D=
"noreferrer" target=3D"_blank">https://lists.sourceforge.net/<wbr>lists/lis=
tinfo/tpmdd-devel</a><br>
<br></blockquote></div><br></div>

--001a11448a0cc672470558f8531b--


--===============2068726749024591944==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============2068726749024591944==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2068726749024591944==--
