From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: tpm: Introduce TPM_CHIP_FLAG_VIRTUAL
Date: Thu, 31 Mar 2016 15:06:52 +0200
Message-ID: <CALD+uuy43FyxE_s7HR2mz6G=E4uwFh63oJLxJ8AF0i-0-AfT=Q@mail.gmail.com>
References: <CALD+uuyndJkab4YxEaAJA1XX1Wsy9QqMRLAh7ewibpUYQiNPAg@mail.gmail.com>
	<56FD0D77.6090905@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4650460273092636483=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <56FD0D77.6090905-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============4650460273092636483==
Content-Type: multipart/alternative; boundary=001a114b1584c92d01052f57f01e

--001a114b1584c92d01052f57f01e
Content-Type: text/plain; charset=UTF-8

Hi Stefan,

[Adding tpmdd mailing list].
I agree that it would work when calling tpm_chip_alloc with NULL, my only
worry is that it is not chain the same way in other drivers.
Currently we are not using chip->dev.drvdata to store chip but platform
data.
chip is stored into the device platform data from the physical layer (e.g:
i2c, spi, pdev...).

At the end, I think this would not cause any issue as TPM_CHIP_FLAG_VIRTUAL
will covert it. However in the current form i believe
It looks like priv field will be required only for the purpose of
vtpm_proxy.

After previous discussion with Jarkko and Jason, priv is currently on its
way to get removed... https://patchwork.kernel.org/patch/8705291/

Would it be reasonable to use chip->dev.platform_data to store the newly
allocated proxy_dev instead of using a dedicated field (priv)?

Best Regards
Christophe


2016-03-31 13:43 GMT+02:00 Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>:

> On 03/30/2016 05:56 AM, Christophe Ricard wrote:
>
>> Hi Stefan,
>>
>> One question here:
>>   int tpm_sysfs_add_device(struct tpm_chip *chip)
>>   {
>> - int err;
>> - err = sysfs_create_group(&chip->dev.parent->kobj,
>> - &tpm_dev_group);
>> + int err = 0;
>> +
>> + if (!(chip->flags & TPM_CHIP_FLAG_VIRTUAL))
>> + err = sysfs_create_group(&chip->dev.parent->kobj,
>> + &tpm_dev_group);
>> + else {
>> + dev_set_drvdata(&chip->dev, chip);
>> What is the purpose of setting chip->dev.drvdata with chip ?
>> I don't see any place with a dev_get_drvdata. Can you explain ?
>>
>
> The subsequent patches implement a device driver that calls
> tpm_chip_alloc() with NULL for the driver parameter and dev_set_drvdata(),
> that typically gets called in tpmm_chip_alloc(), is not called. There are
> dev_get_drvdata() calls in tpm-sysfs.c that would not work without us
> calling dev_set_drvdata() here.
>
>    Stefan
>
>

--001a114b1584c92d01052f57f01e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Stefan,<div><br></div><div>[Adding tpmdd mailing list].=
</div><div>I agree that it would work when calling tpm_chip_alloc with NULL=
, my only worry is that it is not chain the same way in other drivers.</div=
><div>Currently we are not using chip-&gt;dev.drvdata to store chip but pla=
tform data.</div><div>chip is stored into the device platform data from the=
 physical layer (e.g: i2c, spi, pdev...).<br></div><div><br></div><div>At t=
he end, I think this would not cause any issue as TPM_CHIP_FLAG_VIRTUAL wil=
l covert it. However in the current form i believe</div><div>It looks like =
priv field will be required only for the purpose of=C2=A0<span style=3D"col=
or:rgb(0,0,0);font-size:12px">vtpm_proxy.</span></div><div><span style=3D"c=
olor:rgb(0,0,0);font-size:12px"><br></span></div><div><span style=3D"color:=
rgb(0,0,0);font-size:12px">After previous discussion with Jarkko and Jason,=
 priv is currently on its way to get removed...=C2=A0</span><font color=3D"=
#000000"><span style=3D"font-size:12px"><a href=3D"https://patchwork.kernel=
.org/patch/8705291/">https://patchwork.kernel.org/patch/8705291/</a></span>=
</font></div><div><font color=3D"#000000"><span style=3D"font-size:12px"><b=
r></span></font></div><div><font color=3D"#000000"><span style=3D"font-size=
:12px">Would it be reasonable to use chip-&gt;dev.platform_data to store th=
e newly allocated proxy_dev instead of using a dedicated field (priv)?</spa=
n></font></div><div><font color=3D"#000000"><span style=3D"font-size:12px">=
<br></span></font></div><div><font color=3D"#000000"><span style=3D"font-si=
ze:12px">Best Regards</span></font></div><div><font color=3D"#000000"><span=
 style=3D"font-size:12px">Christophe</span></font></div><div><font color=3D=
"#000000"><span style=3D"font-size:12px"><br></span></font></div></div><div=
 class=3D"gmail_extra"><br><div class=3D"gmail_quote">2016-03-31 13:43 GMT+=
02:00 Stefan Berger <span dir=3D"ltr">&lt;<a href=3D"mailto:stefanb@linux.v=
net.ibm.com" target=3D"_blank">stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org</a>&gt;</span>:<b=
r><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:=
1px #ccc solid;padding-left:1ex"><span class=3D"">On 03/30/2016 05:56 AM, C=
hristophe Ricard wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hi Stefan,<br>
<br>
One question here:<br>
=C2=A0 int tpm_sysfs_add_device(struct tpm_chip *chip)<br>
=C2=A0 {<br>
- int err;<br>
- err =3D sysfs_create_group(&amp;chip-&gt;dev.parent-&gt;kobj,<br>
- &amp;tpm_dev_group);<br>
+ int err =3D 0;<br>
+<br>
+ if (!(chip-&gt;flags &amp; TPM_CHIP_FLAG_VIRTUAL))<br>
+ err =3D sysfs_create_group(&amp;chip-&gt;dev.parent-&gt;kobj,<br>
+ &amp;tpm_dev_group);<br>
+ else {<br>
+ dev_set_drvdata(&amp;chip-&gt;dev, chip);<br>
What is the purpose of setting chip-&gt;dev.drvdata with chip ?<br>
I don&#39;t see any place with a dev_get_drvdata. Can you explain ?<br>
</blockquote>
<br></span>
The subsequent patches implement a device driver that calls tpm_chip_alloc(=
) with NULL for the driver parameter and dev_set_drvdata(), that typically =
gets called in tpmm_chip_alloc(), is not called. There are dev_get_drvdata(=
) calls in tpm-sysfs.c that would not work without us calling dev_set_drvda=
ta() here.<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
=C2=A0 =C2=A0Stefan<br>
<br>
</font></span></blockquote></div><br></div>

--001a114b1584c92d01052f57f01e--


--===============4650460273092636483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
--===============4650460273092636483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4650460273092636483==--
