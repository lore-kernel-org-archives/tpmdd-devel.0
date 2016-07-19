From: Alex Gershgorin <Alex.Gershgorin-z19BhFikLL4AvxtiuMwx3w@public.gmane.org>
Subject: (no subject)
Date: Tue, 19 Jul 2016 08:34:20 +0000
Message-ID: <1DC01DCD0F70AE4284AE3A5E8C726E2240106236@Ex2010.q-core.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5328299723243624429=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============5328299723243624429==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_1DC01DCD0F70AE4284AE3A5E8C726E2240106236Ex2010qcorecoil_"

--_000_1DC01DCD0F70AE4284AE3A5E8C726E2240106236Ex2010qcorecoil_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi everyone,

Our company use Atmel TPM AT97SC3205 - SPI interface.
Accordingly to datasheests it's compliant to Trusted Computing Group (TCG) =
Trusted Platform Module TPM) Version 1.2 Specification. Compliant with TCG =
PC Client-Specific TPM Interface Specification (TIS Version 1.3).
On my target board I'm running Kernel from git://git.infradead.org/users/jj=
s/linux-tpmdd.git   next head.
I have made some additional changes on my Device Tree.

spi1: spi@fc000000 {
                pinctrl-names =3D "default";
                pinctrl-0 =3D <&pinctrl_spi1_default>;
                status =3D "okay";

                tpm_tis@0 {
                            compatible =3D "tcg,tpm_tis-spi";
                    reg =3D <0>;
                            spi-max-frequency =3D <10000000>;
                    };
            };

This is part of my kernel boot messages:
atmel_spi fc000000.spi: version: 0x311
atmel_spi fc000000.spi: Using dma0chan2 (tx) and dma0chan3 (rx) for DMA tra=
nsfers
atmel_spi fc000000.spi: Using FIFO (16 data)
atmel_spi fc000000.spi: Atmel SPI Controller at 0xfc000000 (irq 36)
tpm tpm0: tpm_transmit: tpm_send: error -5
tpm_tis_spi: probe of spi32765.0 failed with error -5

I verified with an oscilloscope that all SPI bus signals are in order.

Following the above kernel boot messages - my question is :
    Can I use tpm_tis_spi device driver for AT97SC3205 device ?

Please advise and help with any directions.

Thanks in advance,
Alex Gershgorin






--_000_1DC01DCD0F70AE4284AE3A5E8C726E2240106236Ex2010qcorecoil_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html dir=3D"ltr">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style id=3D"owaParaStyle" type=3D"text/css">=0A=
<!--=0A=
p=0A=
	{margin-top:0;=0A=
	margin-bottom:0}=0A=
-->=0A=
P {margin-top:0;margin-bottom:0;}</style>
</head>
<body ocsi=3D"0" fpstyle=3D"1">
<div style=3D"direction: ltr;font-family: Tahoma;color: #000000;font-size: =
10pt;">
<div style=3D"direction:ltr; font-family:Tahoma; color:#000000; font-size:1=
0pt">Hi everyone,<br>
<br>
Our company use Atmel TPM AT97SC3205 - SPI interface.<br>
Accordingly to datasheests it's compliant to Trusted Computing Group (<span=
 class=3D"highlight selected">TCG</span>) Trusted Platform Module TPM) Vers=
ion 1.2 Specification. Compliant with TCG PC Client-Specific TPM Interface =
Specification (TIS Version 1.3).<br>
On my target board I'm running Kernel from git://git.infradead.org/users/jj=
s/linux-tpmdd.git &nbsp;
<b>next head</b>.<br>
I have made some additional changes on my Device Tree. <br>
&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <br>
spi1: spi@fc000000 {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 pinctrl-names =3D &quot;default&quot;;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 pinctrl-0 =3D &lt;&amp;pinctrl_spi1_default&gt;;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 status =3D &quot;okay&quot;;<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 tpm_tis@0 {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; co=
mpatible =3D &quot;tcg,tpm_tis-spi&quot;;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp; reg =3D &lt;0&gt;;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sp=
i-max-frequency =3D &lt;10000000&gt;;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; };<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; };<br>
<br>
<b>This is part of my kernel boot messages: </b><br>
atmel_spi fc000000.spi: version: 0x311<br>
atmel_spi fc000000.spi: Using dma0chan2 (tx) and dma0chan3 (rx) for DMA tra=
nsfers<br>
atmel_spi fc000000.spi: Using FIFO (16 data)<br>
atmel_spi fc000000.spi: Atmel SPI Controller at 0xfc000000 (irq 36)<br>
tpm tpm0: tpm_transmit: tpm_send: error -5<br>
tpm_tis_spi: probe of spi32765.0 failed with error -5<br>
<br>
I verified with an oscilloscope that all SPI bus signals are in order.<br>
<br>
Following the above kernel boot messages - my question is :<br>
&nbsp;&nbsp;&nbsp; Can I use tpm_tis_spi device driver for AT97SC3205 devic=
e ?<br>
<br>
Please advise and help with any directions.<br>
<br>
Thanks in advance,<br>
Alex Gershgorin<br>
<br>
<br>
<br>
<br>
<br>
<span lang=3D"en-US"></span>
<div>
<div style=3D"font-family:Tahoma; font-size:13px">
<div style=3D"font-family:Tahoma; font-size:13px">
<div style=3D"font-family:Tahoma; font-size:13px"></div>
</div>
</div>
</div>
</div>
</div>
</body>
</html>

--_000_1DC01DCD0F70AE4284AE3A5E8C726E2240106236Ex2010qcorecoil_--


--===============5328299723243624429==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
--===============5328299723243624429==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============5328299723243624429==--
