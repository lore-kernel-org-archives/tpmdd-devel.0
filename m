From: Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Intel NUC and fTPM issue on 4.9.2
Date: Thu, 16 Feb 2017 18:40:02 +0000
Message-ID: <CAH=yMtLLrsyqLr9tOm+D2qvcCDNRO3P36hp8hCdJFVtDyJPWGQ@mail.gmail.com>
References: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg@mail.gmail.com>
	<20170216180116.GA7145@obsidianresearch.com>
	<CAH=yMtJkmxxm6sn=1DmakXW+P=E7rsBd3iwqsSwaVBvxazE29w@mail.gmail.com>
	<20170216181905.GA7257@obsidianresearch.com>
	<CAH=yMt+tWWDMban86H53Or+KngYLUw5hN0aB=+DaJ+MQOK4=4g@mail.gmail.com>
	<CAH=yMtJ7qWq=YpRaUPh2zzOECjFGiwV3jfBc+4HuvW3wOYt_Vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7543636522017762814=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CAH=yMtJ7qWq=YpRaUPh2zzOECjFGiwV3jfBc+4HuvW3wOYt_Vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============7543636522017762814==
Content-Type: multipart/alternative; boundary=001a1143703a0724e10548aa20af

--001a1143703a0724e10548aa20af
Content-Type: text/plain; charset=UTF-8

Sorry I missed 1 line:

[20417.678952] ACPI resource is [mem 0xfed40000-0xfed4087f flags 0x200]

[20417.678975] map request is is [mem 0xfed40040-0xfed4006f flags 0x200]

[20417.678990] map request is is [mem 0xfed40080-0xfed40fff flags 0x200]

[20417.678996] tpm_crb MSFT0101:00: can't request region for resource [mem
0xfed40080-0xfed40fff]

[20417.688797] tpm_crb: probe of MSFT0101:00 failed with error -16


On 16 February 2017 at 18:39, Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> [20417.678975] map request is is [mem 0xfed40040-0xfed4006f flags 0x200]
>
> [20417.678990] map request is is [mem 0xfed40080-0xfed40fff flags 0x200]
>
> [20417.678996] tpm_crb MSFT0101:00: can't request region for resource [mem
> 0xfed40080-0xfed40fff]
>
> [20417.688797] tpm_crb: probe of MSFT0101:00 failed with error -16
>
>
>
> On 16 February 2017 at 18:26, Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
>
>> No lines including the requested range:
>>
>> fed10000-fed17fff : pnp 00:06
>>
>> fed18000-fed18fff : pnp 00:06
>>
>> fed19000-fed19fff : pnp 00:06
>>
>> fed20000-fed3ffff : pnp 00:06
>>
>> fed40000-fed4087f : MSFT0101:00
>>
>> fed45000-fed8ffff : pnp 00:06
>>
>> fed90000-fed93fff : pnp 00:06
>>
>> fee00000-fee00fff : Local APIC
>>
>> This is the NUC I am using, if that can be useful.
>>
>> root@vhsv1:~# cat /sys/class/dmi/id/board_name
>> /sys/class/dmi/id/board_version
>>
>> NUC6i7KYB
>>
>> H90766-404
>>
>> I am compiling the module right as we speak, I will get back to you soon.
>>
>> On 16 February 2017 at 18:19, Jason Gunthorpe <
>> jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>>
>>> On Thu, Feb 16, 2017 at 06:10:43PM +0000, Davide Guerri wrote:
>>> >    Hey thanks for the prompt reply.
>>> >    I think you are interested in this:
>>> >       fed40000-fed4087f : MSFT0101:00
>>>
>>> Are there more lines below that?
>>>
>>> Can you apply this patch and report what the results are?
>>>
>>> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
>>> index a7c870af916c3d..acc54a03d6025d 100644
>>> --- a/drivers/char/tpm/tpm_crb.c
>>> +++ b/drivers/char/tpm/tpm_crb.c
>>> @@ -233,6 +233,8 @@ static void __iomem *crb_map_res(struct device *dev,
>>> struct crb_priv *priv,
>>>                 .flags  = IORESOURCE_MEM,
>>>         };
>>>
>>> +       printk("map request is is %pr\n",&new_res);
>>> +
>>>         /* Detect a 64 bit address on a 32 bit system */
>>>         if (start != new_res.start)
>>>                 return (void __iomem *) ERR_PTR(-EINVAL);
>>> @@ -267,6 +269,8 @@ static int crb_map_io(struct acpi_device *device,
>>> struct crb_priv *priv,
>>>                 return -EINVAL;
>>>         }
>>>
>>> +       printk("ACPI resource is %pr\n",&io_res);
>>> +
>>>         priv->iobase = devm_ioremap_resource(dev, &io_res);
>>>         if (IS_ERR(priv->iobase))
>>>                 return PTR_ERR(priv->iobase);
>>>
>>
>>
>>
>> --
>>
>>
>> [image: Davide Guerri on about.me]
>>
>> Davide Guerri
>> about.me/davide_guerri
>>   <http://about.me/davide_guerri>
>>
>
>
>
> --
>
>
> [image: Davide Guerri on about.me]
>
> Davide Guerri
> about.me/davide_guerri
>   <http://about.me/davide_guerri>
>



-- 


[image: Davide Guerri on about.me]

Davide Guerri
about.me/davide_guerri
  <http://about.me/davide_guerri>

--001a1143703a0724e10548aa20af
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sorry I missed 1 line:<div><br></div><div><p style=3D"marg=
in:0px;font-size:12px;line-height:normal;font-family:hack;color:rgb(77,47,4=
5);background-color:rgb(223,219,195)"><span style=3D"font-variant-ligatures=
:no-common-ligatures">[20417.678952] ACPI resource is [mem 0xfed40000-0xfed=
4087f flags 0x200]</span></p>
<p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;c=
olor:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-v=
ariant-ligatures:no-common-ligatures">[20417.678975] map request is is [mem=
 0xfed40040-0xfed4006f flags 0x200]</span></p>
<p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;c=
olor:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-v=
ariant-ligatures:no-common-ligatures">[20417.678990] map request is is [mem=
 0xfed40080-0xfed40fff flags 0x200]</span></p>
<p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;c=
olor:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-v=
ariant-ligatures:no-common-ligatures">[20417.678996] tpm_crb MSFT0101:00: c=
an&#39;t request region for resource [mem 0xfed40080-0xfed40fff]</span></p>
<p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;c=
olor:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-v=
ariant-ligatures:no-common-ligatures">[20417.688797] tpm_crb: probe of MSFT=
0101:00 failed with error -16</span></p></div><div><span style=3D"font-vari=
ant-ligatures:no-common-ligatures"><br></span></div></div><div class=3D"gma=
il_extra"><br><div class=3D"gmail_quote">On 16 February 2017 at 18:39, Davi=
de Guerri <span dir=3D"ltr">&lt;<a href=3D"mailto:davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" =
target=3D"_blank">davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;</span> wrote:<br><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex"><div dir=3D"ltr"><p style=3D"margin:0px;font-size:12=
px;line-height:normal;font-family:hack;color:rgb(77,47,45);background-color=
:rgb(223,219,195)"><span style=3D"font-variant-ligatures:no-common-ligature=
s">[20417.678975] map request is is [mem 0xfed40040-0xfed4006f flags 0x200]=
</span></p>
<p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;c=
olor:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-v=
ariant-ligatures:no-common-ligatures">[20417.678990] map request is is [mem=
 0xfed40080-0xfed40fff flags 0x200]</span></p>
<p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;c=
olor:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-v=
ariant-ligatures:no-common-ligatures">[20417.678996] tpm_crb MSFT0101:00: c=
an&#39;t request region for resource [mem 0xfed40080-0xfed40fff]</span></p>
<p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;c=
olor:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-v=
ariant-ligatures:no-common-ligatures">[20417.688797] tpm_crb: probe of MSFT=
0101:00 failed with error -16</span></p><div><span style=3D"font-variant-li=
gatures:no-common-ligatures"><br></span></div><div><span style=3D"font-vari=
ant-ligatures:no-common-ligatures"><br></span></div></div><div class=3D"HOE=
nZb"><div class=3D"h5"><div class=3D"gmail_extra"><br><div class=3D"gmail_q=
uote">On 16 February 2017 at 18:26, Davide Guerri <span dir=3D"ltr">&lt;<a =
href=3D"mailto:davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" target=3D"_blank">davide.guerri@gma=
il.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"=
ltr">No lines including the requested range:<div><br></div><div><p style=3D=
"margin:0px;font-size:12px;line-height:normal;font-family:hack;color:rgb(77=
,47,45);background-color:rgb(223,219,195)"><span style=3D"font-variant-liga=
tures:no-common-ligatures">fed10000-fed17fff : pnp 00:06</span></p><p style=
=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;color:rgb=
(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-variant-l=
igatures:no-common-ligatures">fed18000-fed18fff : pnp 00:06</span></p><p st=
yle=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;color:=
rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-varian=
t-ligatures:no-common-ligatures">fed19000-fed19fff : pnp 00:06</span></p><p=
 style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;col=
or:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-var=
iant-ligatures:no-common-ligatures">fed20000-fed3ffff : pnp 00:06</span></p=
><p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;=
color:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-=
variant-ligatures:no-common-ligatures">fed40000-fed4087f : MSFT0101:00</spa=
n></p><p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:=
hack;color:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"=
font-variant-ligatures:no-common-ligatures">fed45000-fed8ffff : pnp 00:06</=
span></p><p style=3D"margin:0px;font-size:12px;line-height:normal;font-fami=
ly:hack;color:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=
=3D"font-variant-ligatures:no-common-ligatures">fed90000-fed93fff : pnp 00:=
06</span></p><p style=3D"margin:0px;font-size:12px;line-height:normal;font-=
family:hack;color:rgb(77,47,45);background-color:rgb(223,219,195)"><span st=
yle=3D"font-variant-ligatures:no-common-ligatures">fee00000-fee00fff : Loca=
l APIC</span></p><div><div><br></div><div>This is the NUC I am using, if th=
at can be useful.</div><div><br></div><div><p style=3D"margin:0px;font-size=
:12px;line-height:normal;font-family:hack;color:rgb(77,47,45);background-co=
lor:rgb(223,219,195)"><span style=3D"font-variant-ligatures:no-common-ligat=
ures">root@vhsv1:~# cat /sys/class/dmi/id/board_name /sys/class/dmi/id/boar=
d_versio<wbr>n</span></p><p style=3D"margin:0px;font-size:12px;line-height:=
normal;font-family:hack;color:rgb(77,47,45);background-color:rgb(223,219,19=
5)"><span style=3D"font-variant-ligatures:no-common-ligatures">NUC6i7KYB</s=
pan></p><p style=3D"margin:0px;font-size:12px;line-height:normal;font-famil=
y:hack;color:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=
=3D"font-variant-ligatures:no-common-ligatures">H90766-404</span></p></div>=
<div><br></div></div></div><div>I am compiling the module right as we speak=
, I will get back to you soon.</div></div><div class=3D"gmail_extra"><div><=
div class=3D"m_2268449455654255963h5"><br><div class=3D"gmail_quote">On 16 =
February 2017 at 18:19, Jason Gunthorpe <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" target=3D"_blank">jgunthorpe@obsidian=
research.c<wbr>om</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><=
span>On Thu, Feb 16, 2017 at 06:10:43PM +0000, Davide Guerri wrote:<br>
&gt;=C2=A0 =C2=A0 Hey thanks for the prompt reply.<br>
&gt;=C2=A0 =C2=A0 I think you are interested in this:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0fed40000-fed4087f : MSFT0101:00<br>
<br>
</span>Are there more lines below that?<br>
<br>
Can you apply this patch and report what the results are?<br>
<br>
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c<br>
index a7c870af916c3d..acc54a03d6025d 100644<br>
--- a/drivers/char/tpm/tpm_crb.c<br>
+++ b/drivers/char/tpm/tpm_crb.c<br>
@@ -233,6 +233,8 @@ static void __iomem *crb_map_res(struct device *dev, st=
ruct crb_priv *priv,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .flags=C2=A0 =3D IO=
RESOURCE_MEM,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 };<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0printk(&quot;map request is is %pr\n&quot;,&amp=
;new_res);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Detect a 64 bit address on a 32 bit system *=
/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (start !=3D new_res.start)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return (void __iome=
m *) ERR_PTR(-EINVAL);<br>
@@ -267,6 +269,8 @@ static int crb_map_io(struct acpi_device *device, struc=
t crb_priv *priv,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0printk(&quot;ACPI resource is %pr\n&quot;,&amp;=
io_res);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 priv-&gt;iobase =3D devm_ioremap_resource(dev, =
&amp;io_res);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(priv-&gt;iobase))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PTR_ERR(priv=
-&gt;iobase);<br>
</blockquote></div><br><br clear=3D"all"><div><br></div></div></div><span>-=
- <br><div class=3D"m_2268449455654255963m_-7004952251488659925gmail_signat=
ure" data-smartmail=3D"gmail_signature"><div dir=3D"ltr">
			=09
	<a href=3D"http://about.me/davide_guerri" style=3D"text-decoration:none" t=
arget=3D"_blank">
		<table border=3D"0" cellpadding=3D"0" cellspacing=3D"0">
			<tbody>
				<tr><td colspan=3D"3" style=3D"height:30px;font-size:0px">=C2=A0</td></=
tr>
				<tr>
					<td style=3D"line-height:1;vertical-align:top" align=3D"left" valign=
=3D"top">
						<div><img src=3D"http://d3mod6n032mdiz.cloudfront.net/thumb2/d/a/v/da=
vide_guerri/davide_guerri-105x70.jpg" alt=3D"Davide Guerri on about.me" sty=
le=3D"margin:0;padding:0;display:block;border:1px solid #eeeeee" height=3D"=
70" width=3D"105"></div>
					</td>
					<td style=3D"width:10px;font-size:0px">=C2=A0</td>
					<td style=3D"line-height:1;padding:0px;padding-bottom:3px;vertical-ali=
gn:bottom" align=3D"left" valign=3D"bottom">
						<div style=3D"margin:0;font-size:18px;line-height:1;font-weight:bold;=
color:#333333;font-family:proxima-nova-1,Proxima-Nova,Helvetica,Arial,Sans-=
Serif">Davide Guerri</div>
						<div style=3D"margin:0;margin-top:1px;font-size:12px;color:#2b82ad;fo=
nt-family:proxima-nova-1,Proxima-Nova,Helvetica,Arial,Sans-Serif">about.me/=
davide_guerri</div>
					</td>
				</tr>
				<tr><td colspan=3D"3" style=3D"height:20px;font-size:0px">=C2=A0</td></=
tr>
			</tbody>
		</table>
	</a>

			</div></div>
</span></div>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div class=
=3D"m_2268449455654255963gmail_signature" data-smartmail=3D"gmail_signature=
"><div dir=3D"ltr">
			=09
	<a href=3D"http://about.me/davide_guerri" style=3D"text-decoration:none" t=
arget=3D"_blank">
		<table border=3D"0" cellpadding=3D"0" cellspacing=3D"0">
			<tbody>
				<tr><td colspan=3D"3" style=3D"height:30px;font-size:0px">=C2=A0</td></=
tr>
				<tr>
					<td style=3D"line-height:1;vertical-align:top" align=3D"left" valign=
=3D"top">
						<div><img src=3D"http://d3mod6n032mdiz.cloudfront.net/thumb2/d/a/v/da=
vide_guerri/davide_guerri-105x70.jpg" alt=3D"Davide Guerri on about.me" sty=
le=3D"margin:0;padding:0;display:block;border:1px solid #eeeeee" height=3D"=
70" width=3D"105"></div>
					</td>
					<td style=3D"width:10px;font-size:0px">=C2=A0</td>
					<td style=3D"line-height:1;padding:0px;padding-bottom:3px;vertical-ali=
gn:bottom" align=3D"left" valign=3D"bottom">
						<div style=3D"margin:0;font-size:18px;line-height:1;font-weight:bold;=
color:#333333;font-family:proxima-nova-1,Proxima-Nova,Helvetica,Arial,Sans-=
Serif">Davide Guerri</div>
						<div style=3D"margin:0;margin-top:1px;font-size:12px;color:#2b82ad;fo=
nt-family:proxima-nova-1,Proxima-Nova,Helvetica,Arial,Sans-Serif">about.me/=
davide_guerri</div>
					</td>
				</tr>
				<tr><td colspan=3D"3" style=3D"height:20px;font-size:0px">=C2=A0</td></=
tr>
			</tbody>
		</table>
	</a>

			</div></div>
</div>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=
=3D"ltr">
			=09
	<a href=3D"http://about.me/davide_guerri" style=3D"text-decoration:none" t=
arget=3D"_blank">
		<table border=3D"0" cellpadding=3D"0" cellspacing=3D"0">
			<tbody>
				<tr><td colspan=3D"3" style=3D"height:30px;font-size:0px">=C2=A0</td></=
tr>
				<tr>
					<td style=3D"line-height:1;vertical-align:top" align=3D"left" valign=
=3D"top">
						<div><img src=3D"http://d3mod6n032mdiz.cloudfront.net/thumb2/d/a/v/da=
vide_guerri/davide_guerri-105x70.jpg" alt=3D"Davide Guerri on about.me" sty=
le=3D"margin:0;padding:0;display:block;border:1px solid #eeeeee" height=3D"=
70" width=3D"105"></div>
					</td>
					<td style=3D"width:10px;font-size:0px">=C2=A0</td>
					<td style=3D"line-height:1;padding:0px;padding-bottom:3px;vertical-ali=
gn:bottom" align=3D"left" valign=3D"bottom">
						<div style=3D"margin:0;font-size:18px;line-height:1;font-weight:bold;=
color:#333333;font-family:proxima-nova-1,Proxima-Nova,Helvetica,Arial,Sans-=
Serif">Davide Guerri</div>
						<div style=3D"margin:0;margin-top:1px;font-size:12px;color:#2b82ad;fo=
nt-family:proxima-nova-1,Proxima-Nova,Helvetica,Arial,Sans-Serif">about.me/=
davide_guerri</div>
					</td>
				</tr>
				<tr><td colspan=3D"3" style=3D"height:20px;font-size:0px">=C2=A0</td></=
tr>
			</tbody>
		</table>
	</a>

			</div></div>
</div>

--001a1143703a0724e10548aa20af--


--===============7543636522017762814==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============7543636522017762814==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7543636522017762814==--
