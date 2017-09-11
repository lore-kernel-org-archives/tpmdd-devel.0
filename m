From: "Nasim, Kam" <Kam.Nasim-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: IMA running as a Kernel module against TPM 2.0 driver
Date: Mon, 11 Sep 2017 21:29:39 +0000
Message-ID: <CA352AD04C14CE4985F6AEB6AB8C130E3EDB8737@ALA-MBC.corp.ad.wrs.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6309788755453881862=="
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

--===============6309788755453881862==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8737ALAMBCcorpadwrs_"

--_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8737ALAMBCcorpadwrs_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi folks,

Im stumped with some issues with getting IMA to talk to the TPM interface d=
river, and was hoping you guys could help me out.

I am building IMA as an out-of-tree Kernel module. We are based off CentOS =
v7.3 which is still sitting at the Linux v3.10 baseline (sad I know!). Ever=
ything seems to be fine but when I load the IMA module, it cannot seem to d=
o a PCR read from the TPM driver:

2017-09-11T19:06:47.438 controller-1 kernel: info [  228.152893] ima: No TP=
M chip found, activating TPM-bypass! (rc=3D-19)


We also had to build TPM as an out-of-tree Kernel module, since we had to u=
se the in-Kernel TPM resource manager which was unavailable till Jan 2017. =
TPM driver is loaded and operational:

2017-09-11T19:03:07.818 controller-1 kernel: info [    5.929071] tpm_tis MS=
FT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)



controller-1:~$ sudo lsmod | grep ima
ima                    47169  0
integrity               6430  1 ima


controller-1:~$ sudo lsmod | grep tpm
tpm_crb                 6458  0
tpm_tis                 5950  0
tpm_tis_core           10054  1 tpm_tis
tpm                    48093  3 tpm_crb,tpm_tis,tpm_tis_core


I've tracked down the failure to the tpm_pcr_read() in tpm-interface.c, thi=
s was added as an interface to integrity:

commit 659aaf2bb5496a425ba14036b5b5900f593e4484
Author: Rajiv Andrade <srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org<mailto:srajiv-23VcF4HTsmI+71yUvRxsjw@public.gmane.org=
bm.com>>
Date:   Mon Feb 2 15:23:44 2009 -0200

    TPM: integrity interface

    This patch adds internal kernel support for:
     - reading/extending a pcr value
     - looking up the tpm_chip for a given chip number

    Signed-off-by: Rajiv Andrade <srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org<mailto:srajiv@l=
inux.vnet.ibm.com>>
    Signed-off-by: Mimi Zohar <zohar-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org<mailto:zohar-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>>
    Signed-off-by: James Morris jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org<mailto:jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>


The comment above the function implies that it cannot be executed if TPM is=
 built as a Kernel module?

"The TPM driver should be built-in, but for whatever reason it
* isn't, protect against the chip disappearing, by incrementing
* the module usage count."


Is this understanding correct? If so then how do I get the IMA Kernel modul=
e to do a Kernel PCR read?


Any help you guys can offer me would be greatly appreciated.


Thanks,
Kam


P.S: I don't see a /sys/devices/pnp0/<pnp#>/pcrs file on my system although=
 TSS2 commands seem to indicate that the PCR list is active



--_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8737ALAMBCcorpadwrs_
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
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Im stumped with some issues wit=
h getting IMA to talk to the TPM interface driver, and was hoping you guys =
could help me out.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><br>
I am building IMA as an out-of-tree Kernel module. We are based off CentOS =
v7.3 which is still sitting at the Linux v3.10 baseline (sad I know!). Ever=
ything seems to be fine but when I load the IMA module, it cannot seem to d=
o a PCR read from the TPM driver:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-11T19:06:47.438 control=
ler-1 kernel: info [&nbsp; 228.152893] ima: No TPM chip found, activating T=
PM-bypass! (rc=3D-19)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">We also had to build TPM as an =
out-of-tree Kernel module, since we had to use the in-Kernel TPM resource m=
anager which was unavailable till Jan 2017. TPM driver is loaded and operat=
ional:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">2017-09-11T19:03:07.818 control=
ler-1 kernel: info [&nbsp;&nbsp;&nbsp; 5.929071] tpm_tis MSFT0101:00: 2.0 T=
PM (device-id 0x1A, rev-id 16)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">controller-1:~$ sudo lsmod | gr=
ep ima<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">ima&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; 47169&nbsp; 0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">integrity&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6430&nbsp; 1=
 ima<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">controller-1:~$ sudo lsmod | gr=
ep tpm<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_crb&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 64=
58&nbsp; 0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 59=
50&nbsp; 0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm_tis_core&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;10054&nbsp; 1 tpm_tis<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">tpm&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; 48093&nbsp; 3 tpm_crb,tpm_tis,tpm_tis_core<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">I&#8217;ve tracked down the fai=
lure to the tpm_pcr_read() in tpm-interface.c, this was added as an interfa=
ce to integrity:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">commit 659aaf2bb5496a425ba14036=
b5b5900f593e4484<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Author: Rajiv Andrade &lt;<a hr=
ef=3D"mailto:srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org">srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org</a>&gt;<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Date:&nbsp;&nbsp; Mon Feb 2 15:=
23:44 2009 -0200<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; TPM: integri=
ty interface<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; This patch a=
dds internal kernel support for:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp; - read=
ing/extending a pcr value<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp;&nbsp; - look=
ing up the tpm_chip for a given chip number<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; Signed-off-b=
y: Rajiv Andrade &lt;<a href=3D"mailto:srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org">srajiv@li=
nux.vnet.ibm.com</a>&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; Signed-off-b=
y: Mimi Zohar &lt;<a href=3D"mailto:zohar-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org">zohar-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org</a>&=
gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&nbsp;&nbsp;&nbsp; Signed-off-b=
y: James Morris <a href=3D"mailto:jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org">
jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org</a><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">The comment above the function =
implies that it cannot be executed if TPM is built as a Kernel module?<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">&#8220;The TPM driver should be=
 built-in, but for whatever reason it<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">* isn't, protect against the ch=
ip disappearing, by incrementing<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">* the module usage count.&#8221=
;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><br>
<br>
Is this understanding correct? If so then how do I get the IMA Kernel modul=
e to do a Kernel PCR read?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Any help you guys can offer me =
would be greatly appreciated.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">Thanks,<br>
Kam<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA">P.S: I don&#8217;t see a /sys/d=
evices/pnp0/&lt;pnp#&gt;/pcrs file on my system although TSS2 commands seem=
 to indicate that the PCR list is active<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-CA"><o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--_000_CA352AD04C14CE4985F6AEB6AB8C130E3EDB8737ALAMBCcorpadwrs_--


--===============6309788755453881862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============6309788755453881862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6309788755453881862==--
