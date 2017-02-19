From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Intel NUC and fTPM issue on 4.9.2
Date: Sun, 19 Feb 2017 22:28:08 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B54398ADC@hasmsx108.ger.corp.intel.com>
References: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg@mail.gmail.com>
	<20170216180116.GA7145@obsidianresearch.com>
	<CAH=yMtJkmxxm6sn=1DmakXW+P=E7rsBd3iwqsSwaVBvxazE29w@mail.gmail.com>
	<20170216181905.GA7257@obsidianresearch.com>
	<CAH=yMt+tWWDMban86H53Or+KngYLUw5hN0aB=+DaJ+MQOK4=4g@mail.gmail.com>
	<CAH=yMtJ7qWq=YpRaUPh2zzOECjFGiwV3jfBc+4HuvW3wOYt_Vg@mail.gmail.com>
	<CAH=yMtLLrsyqLr9tOm+D2qvcCDNRO3P36hp8hCdJFVtDyJPWGQ@mail.gmail.com>
	<5B8DA87D05A7694D9FA63FD143655C1B54395CD5@hasmsx108.ger.corp.intel.com>
	<20170217164332.GB30677@obsidianresearch.com>
	<1487356105.6424.1.camel@intel.com>
	<20170217190125.GA5984@obsidianresearch.com>
	<0FB78E3E-1E73-46EC-9ABD-FD05E1E8B0E2@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7018901075810679716=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <0FB78E3E-1E73-46EC-9ABD-FD05E1E8B0E2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Sakkinen, Jarkko" <jarkko.sakkinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============7018901075810679716==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_5B8DA87D05A7694D9FA63FD143655C1B54398ADChasmsx108gercor_"

--_000_5B8DA87D05A7694D9FA63FD143655C1B54398ADChasmsx108gercor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I need few days to get into BIOS to understand how we got to here at the fi=
rst place,
Can you please send me the dmidecode of the NUC (even privately) so I can u=
nderstand what exactly issue we have. The fixed BIOS I'm testing now is for=
 the Kaby Lake platform.
Davide if would fill a bug for that via intel support page so we can follow=
 up on that.

Thanks
Tomas

From: Davide Guerri [mailto:davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
Sent: Friday, February 17, 2017 23:15
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sakkinen, Jarkko <jarkko.sakkinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Winkler, Tomas <tomas.win=
kler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Subject: Re: [tpmdd-devel] Intel NUC and fTPM issue on 4.9.2

Hey,
sorry fro the delayed reply.

Jason's patch works. I had no doubt it would, because I tried a qnd patch w=
ith manually cropped sizes.
I have cleaned it up a little bit, removing printks.

Thanks again!

D.


On 17 Feb 2017, at 7:01 pm, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMNAWLNoT+7d/@public.gmane.org=
m<mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>> wrote:

I would rather review a patch with proper commit message than just pick
from an email thread in all cases with a proper explanation what the
patch does and why it is the right way to fix the issue.

Of course, but I am waiting for Davide to say the approach even works
..

Jason


--_000_5B8DA87D05A7694D9FA63FD143655C1B54398ADChasmsx108gercor_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman",serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-reply;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
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
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,sans-serif;color:#1F497D">I need few days to get into BIOS to u=
nderstand how we got to here at the first place,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,sans-serif;color:#1F497D">Can you please send me the dmidecode =
of the NUC (even privately) so I can understand what exactly issue we have.=
 The fixed BIOS I&#8217;m testing now is for the Kaby
 Lake platform.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,sans-serif;color:#1F497D">Davide if would fill a bug for that v=
ia intel support page so we can follow up on that.
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,sans-serif;color:#1F497D"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,sans-serif;color:#1F497D">Thanks<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,sans-serif;color:#1F497D">Tomas<o:p></o:p></span></p>
<p class=3D"MsoNormal"><a name=3D"_MailEndCompose"><span style=3D"font-size=
:11.0pt;font-family:&quot;Calibri&quot;,sans-serif;color:#1F497D"><o:p>&nbs=
p;</o:p></span></a></p>
<div style=3D"border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm =
4.0pt">
<div>
<div style=3D"border:none;border-top:solid #E1E1E1 1.0pt;padding:3.0pt 0cm =
0cm 0cm">
<p class=3D"MsoNormal"><a name=3D"_____replyseparator"></a><b><span style=
=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,sans-serif">From:</spa=
n></b><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,sans-=
serif"> Davide Guerri [mailto:davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
<br>
<b>Sent:</b> Friday, February 17, 2017 23:15<br>
<b>To:</b> Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;<br>
<b>Cc:</b> Sakkinen, Jarkko &lt;jarkko.sakkinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org&gt;; Winkler, Tom=
as &lt;tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org&gt;; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>
<b>Subject:</b> Re: [tpmdd-devel] Intel NUC and fTPM issue on 4.9.2<o:p></o=
:p></span></p>
</div>
</div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<div>
<div>
<p class=3D"MsoNormal">Hey,<o:p></o:p></p>
</div>
<div>
<p class=3D"MsoNormal">sorry fro the delayed reply.<o:p></o:p></p>
</div>
<div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
<div>
<p class=3D"MsoNormal">Jason's patch works. I had no doubt it would, becaus=
e I tried a qnd patch with manually cropped sizes.&nbsp;<o:p></o:p></p>
</div>
<div>
<p class=3D"MsoNormal">I have cleaned it up a little bit, removing&nbsp;<sp=
an style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;color:=
#500050;background:white">printks.</span><o:p></o:p></p>
</div>
<div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
<div>
<p class=3D"MsoNormal"><span style=3D"font-size:9.5pt;font-family:&quot;Ari=
al&quot;,sans-serif;color:#500050;background:white">Thanks again!</span><o:=
p></o:p></p>
</div>
<div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
<div>
<p class=3D"MsoNormal"><span style=3D"font-size:9.5pt;font-family:&quot;Ari=
al&quot;,sans-serif;color:#500050;background:white">D.&nbsp;</span><o:p></o=
:p></p>
</div>
<div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</div>
<div>
<div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<div>
<blockquote style=3D"margin-top:5.0pt;margin-bottom:5.0pt">
<div>
<p class=3D"MsoNormal">On 17 Feb 2017, at 7:01 pm, Jason Gunthorpe &lt;<a h=
ref=3D"mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org">jgunthorpe@obsidianresearch.=
com</a>&gt; wrote:<o:p></o:p></p>
</div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<div>
<div>
<blockquote style=3D"margin-top:5.0pt;margin-bottom:5.0pt">
<p class=3D"MsoNormal">I would rather review a patch with proper commit mes=
sage than just pick<br>
from an email thread in all cases with a proper explanation what the<br>
patch does and why it is the right way to fix the issue.<o:p></o:p></p>
</blockquote>
<p class=3D"MsoNormal"><br>
Of course, but I am waiting for Davide to say the approach even works<br>
..<br>
<br>
Jason<o:p></o:p></p>
</div>
</div>
</blockquote>
</div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</div>
</div>
</div>
</body>
</html>

--_000_5B8DA87D05A7694D9FA63FD143655C1B54398ADChasmsx108gercor_--


--===============7018901075810679716==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============7018901075810679716==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7018901075810679716==--
