From: "Nasim, Kam" <Kam.Nasim-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: /dev/tmprm0 resource manager not created for tpm_crb
	KLM
Date: Thu, 20 Apr 2017 19:04:36 +0000
Message-ID: <CA352AD04C14CE4985F6AEB6AB8C130E3ED097A4@ALA-MBC.corp.ad.wrs.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7031862788870439314=="
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
To: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============7031862788870439314==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CA352AD04C14CE4985F6AEB6AB8C130E3ED097A4ALAMBCcorpadwrs_"

--_000_CA352AD04C14CE4985F6AEB6AB8C130E3ED097A4ALAMBCcorpadwrs_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,

For TPM 2.0, we would like to use the in-kernel RM, in order to have multip=
le apps connecting concurrently to my TPM device.

Since I am on CentOS 7.3, which is still on Kernel v3.10 (with 4.00 backpor=
ts), I had to build the TPM Kernel driver out of tree and load it in a 3.10=
 Kernel.

However I am not seeing any /dev/tpmrm0 character device being created afte=
r the tpm_crb KLM gets loaded.

Is there any additional configuration required to make this device node tha=
t I may not have backported to v3.10? I only picked from the <kernel>/drive=
rs/char/tpm subtree.

Also how do I access the TPM2 event logs? Would the tpmrm0 device node only=
 be created on boot?  (I see that if I delete the /dev/tpm0 device and relo=
ad the kernel module, the device does NOT get created)


Any help you folks can offer me would be greatly appreciated.

Cheers,
Kam

Kam Nasim, Software Engineer - Titanium Cloud, Wind River
direct 613.963.9926  mobile 613.408.3688  skype kamnasim



--_000_CA352AD04C14CE4985F6AEB6AB8C130E3ED097A4ALAMBCcorpadwrs_
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
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
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
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"Balloon Text Char";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Tahoma","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.BalloonTextChar
	{mso-style-name:"Balloon Text Char";
	mso-style-priority:99;
	mso-style-link:"Balloon Text";
	font-family:"Tahoma","sans-serif";}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
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
<p class=3D"MsoNormal">Hello,<br>
<br>
For TPM 2.0, we would like to use the in-kernel RM, in order to have multip=
le apps connecting concurrently to my TPM device.<o:p></o:p></p>
<p class=3D"MsoNormal"><br>
Since I am on CentOS 7.3, which is still on Kernel v3.10 (with 4.00 backpor=
ts), I had to build the TPM Kernel driver out of tree and load it in a 3.10=
 Kernel.<o:p></o:p></p>
<p class=3D"MsoNormal"><br>
However I am not seeing any /dev/tpmrm0 character device being created afte=
r the tpm_crb KLM gets loaded.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Is there any additional configuration required to ma=
ke this device node that I may not have backported to v3.10? I only picked =
from the &lt;kernel&gt;/drivers/char/tpm subtree.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Also how do I access the TPM2 event logs? Would the =
tpmrm0 device node only be created on boot?&nbsp; (I see that if I delete t=
he /dev/tpm0 device and reload the kernel module, the device does NOT get c=
reated)<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Any help you folks can offer me would be greatly app=
reciated.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Cheers,<br>
Kam<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><b><span style=3D"font-size:10.0pt;font-family:&quot=
;Arial&quot;,&quot;sans-serif&quot;;color:#333333">Kam Nasim</span></b><spa=
n style=3D"font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&=
quot;;color:#333333">, Software Engineer &#8211; Titanium Cloud,
</span><b><span style=3D"font-size:10.0pt;font-family:&quot;Arial&quot;,&qu=
ot;sans-serif&quot;;color:#CC0000">Wind River</span></b><br>
<span style=3D"font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-se=
rif&quot;;color:#333333">direct 613.963.9926&nbsp;&nbsp;mobile 613.408.3688=
</span>&nbsp;
<span style=3D"font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-se=
rif&quot;;color:#333333">skype kamnasim</span><br>
<br>
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_CA352AD04C14CE4985F6AEB6AB8C130E3ED097A4ALAMBCcorpadwrs_--


--===============7031862788870439314==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============7031862788870439314==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7031862788870439314==--
