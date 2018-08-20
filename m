From: Abbaraju Manojsai <abbarajumanojsai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: regarding a storing a data in nv memory of tpm ,
 without using authorisation or key storing techniques.
Date: Mon, 20 Aug 2018 11:00:12 +0530
Message-ID: <CAM8JkLK4yJXQJWUYgEUUXnP4rQwVROhpF7t5akQ_gP75n=0v7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9088877568708707769=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============9088877568708707769==
Content-Type: multipart/alternative; boundary="0000000000001952910573d7347f"

--0000000000001952910573d7347f
Content-Type: text/plain; charset="UTF-8"

Hello ,

I had seen your mail in linux related post related to tpm . so i am
thinking your the right person to contact you regarding tpm2.0

actually main problem is we interfaced slb 9670(tpm-2.0) with 16 bit msp430
controller which does not support linux kernel or any OS.

now our task is to store a 100 byes of data in NV memory, without any
authorisation technique, as simple as possible.

please guide me in that way.

slb 9670 is interfaced with msp430 controller through SPI protocol.

I able to read device id , version id of slb9670 , so spi communication is
working fine with our controller .

what is packet format to be send with our data , i am not able to
understand the TCG documents .

theoretically iam able to understand we have to do nvdefinespace , nvwrite
,nvread .. internaly what is the format i have to be send not able to
understand

can you please guide me , or share any code snippet .

sorry if i trouble you or any irrelevant questions.

Regards,
Manoj,
mail : abbarajumanojsai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
+91-9063249308

--0000000000001952910573d7347f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">

<p style=3D"text-decoration-style:initial;text-decoration-color:initial;box=
-sizing:border-box;margin-bottom:16px;color:rgb(36,41,46);font-family:-appl=
e-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Helvetica,Arial,sans-serif=
,&quot;Apple Color Emoji&quot;,&quot;Segoe UI Emoji&quot;,&quot;Segoe UI Sy=
mbol&quot;;font-size:14px;margin-top:0px">Hello ,</p><p style=3D"text-decor=
ation-style:initial;text-decoration-color:initial;box-sizing:border-box;mar=
gin-bottom:16px;color:rgb(36,41,46);font-family:-apple-system,BlinkMacSyste=
mFont,&quot;Segoe UI&quot;,Helvetica,Arial,sans-serif,&quot;Apple Color Emo=
ji&quot;,&quot;Segoe UI Emoji&quot;,&quot;Segoe UI Symbol&quot;;font-size:1=
4px;margin-top:0px">I had seen your mail in linux related post related to t=
pm . so i am thinking your the right person to contact you regarding tpm2.0=
</p><p style=3D"text-decoration-style:initial;text-decoration-color:initial=
;box-sizing:border-box;margin-top:0px;margin-bottom:16px;color:rgb(36,41,46=
);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Helveti=
ca,Arial,sans-serif,&quot;Apple Color Emoji&quot;,&quot;Segoe UI Emoji&quot=
;,&quot;Segoe UI Symbol&quot;;font-size:14px">actually main problem is we i=
nterfaced slb 9670(tpm-2.0) with 16 bit msp430 controller which does not su=
pport linux kernel or any OS.</p><p style=3D"text-decoration-style:initial;=
text-decoration-color:initial;box-sizing:border-box;margin-top:0px;margin-b=
ottom:16px;color:rgb(36,41,46);font-family:-apple-system,BlinkMacSystemFont=
,&quot;Segoe UI&quot;,Helvetica,Arial,sans-serif,&quot;Apple Color Emoji&qu=
ot;,&quot;Segoe UI Emoji&quot;,&quot;Segoe UI Symbol&quot;;font-size:14px">=
now our task is to store a 100 byes of data in NV memory, without any autho=
risation technique, as simple as possible.</p><p style=3D"text-decoration-s=
tyle:initial;text-decoration-color:initial;box-sizing:border-box;margin-top=
:0px;margin-bottom:16px;color:rgb(36,41,46);font-family:-apple-system,Blink=
MacSystemFont,&quot;Segoe UI&quot;,Helvetica,Arial,sans-serif,&quot;Apple C=
olor Emoji&quot;,&quot;Segoe UI Emoji&quot;,&quot;Segoe UI Symbol&quot;;fon=
t-size:14px">please guide me in that way.</p><p style=3D"text-decoration-st=
yle:initial;text-decoration-color:initial;box-sizing:border-box;margin-top:=
0px;margin-bottom:16px;color:rgb(36,41,46);font-family:-apple-system,BlinkM=
acSystemFont,&quot;Segoe UI&quot;,Helvetica,Arial,sans-serif,&quot;Apple Co=
lor Emoji&quot;,&quot;Segoe UI Emoji&quot;,&quot;Segoe UI Symbol&quot;;font=
-size:14px">slb 9670 is interfaced with msp430 controller through SPI proto=
col.</p><p style=3D"text-decoration-style:initial;text-decoration-color:ini=
tial;box-sizing:border-box;margin-top:0px;margin-bottom:16px;color:rgb(36,4=
1,46);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Hel=
vetica,Arial,sans-serif,&quot;Apple Color Emoji&quot;,&quot;Segoe UI Emoji&=
quot;,&quot;Segoe UI Symbol&quot;;font-size:14px">I able to read device id =
, version id of slb9670 , so spi communication is working fine with our con=
troller .</p><p style=3D"text-decoration-style:initial;text-decoration-colo=
r:initial;box-sizing:border-box;margin-top:0px;margin-bottom:16px;color:rgb=
(36,41,46);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot=
;,Helvetica,Arial,sans-serif,&quot;Apple Color Emoji&quot;,&quot;Segoe UI E=
moji&quot;,&quot;Segoe UI Symbol&quot;;font-size:14px">what is packet forma=
t to be send with our data , i am not able to understand the TCG documents =
.</p><p style=3D"text-decoration-style:initial;text-decoration-color:initia=
l;box-sizing:border-box;margin-top:0px;margin-bottom:16px;color:rgb(36,41,4=
6);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Helvet=
ica,Arial,sans-serif,&quot;Apple Color Emoji&quot;,&quot;Segoe UI Emoji&quo=
t;,&quot;Segoe UI Symbol&quot;;font-size:14px">theoretically iam able to un=
derstand we have to do nvdefinespace , nvwrite ,nvread .. internaly what is=
 the format i have to be send not able to understand</p><p style=3D"text-de=
coration-style:initial;text-decoration-color:initial;box-sizing:border-box;=
margin-top:0px;margin-bottom:16px;color:rgb(36,41,46);font-family:-apple-sy=
stem,BlinkMacSystemFont,&quot;Segoe UI&quot;,Helvetica,Arial,sans-serif,&qu=
ot;Apple Color Emoji&quot;,&quot;Segoe UI Emoji&quot;,&quot;Segoe UI Symbol=
&quot;;font-size:14px">can you please guide me , or share any code snippet =
.</p><p style=3D"text-decoration-style:initial;text-decoration-color:initia=
l;box-sizing:border-box;margin-top:0px;margin-bottom:16px;color:rgb(36,41,4=
6);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Helvet=
ica,Arial,sans-serif,&quot;Apple Color Emoji&quot;,&quot;Segoe UI Emoji&quo=
t;,&quot;Segoe UI Symbol&quot;;font-size:14px">sorry if i trouble you or an=
y irrelevant questions.</p><p style=3D"text-decoration-style:initial;text-d=
ecoration-color:initial;box-sizing:border-box;margin-top:0px;color:rgb(36,4=
1,46);font-family:-apple-system,BlinkMacSystemFont,&quot;Segoe UI&quot;,Hel=
vetica,Arial,sans-serif,&quot;Apple Color Emoji&quot;,&quot;Segoe UI Emoji&=
quot;,&quot;Segoe UI Symbol&quot;;font-size:14px;margin-bottom:0px">Regards=
,<br style=3D"box-sizing:border-box">Manoj,<br style=3D"box-sizing:border-b=
ox">mail :<span>=C2=A0</span><a href=3D"mailto:abbarajumanojsai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" =
target=3D"_blank" style=3D"color:rgb(3,102,214);box-sizing:border-box;backg=
round-color:transparent;text-decoration:none">abbarajumanojsai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a=
><br style=3D"box-sizing:border-box">+91-9063249308</p><div class=3D"gmail-=
yj6qo" style=3D"font-size:12.8px;text-decoration-style:initial;text-decorat=
ion-color:initial"></div><br class=3D"gmail-Apple-interchange-newline">

<br></div>

--0000000000001952910573d7347f--


--===============9088877568708707769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============9088877568708707769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============9088877568708707769==--
