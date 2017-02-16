From: Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Intel NUC and fTPM issue on 4.9.2
Date: Thu, 16 Feb 2017 11:15:41 +0000
Message-ID: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0242597656554911478=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============0242597656554911478==
Content-Type: multipart/alternative; boundary=001a1143fcd2f049f70548a3eaad

--001a1143fcd2f049f70548a3eaad
Content-Type: text/plain; charset=UTF-8

Hello guys,
I am trying to get the fTPM on an Intel NUC working bit I get this error

[    3.191376] tpm_crb MSFT0101:00: can't request region for resource [mem
0xfed40080-0xfed40fff]

[    3.200378] tpm_crb: probe of MSFT0101:00 failed with error -16

and, of course, the TPM device is not registered in dev/sysfs

In my understanding this is a regression as it has been already fixed in
the past and merged in 4.7 or 4.8.
I also verified my source and tpm_crb.c contains this patch:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=422eac3f7deae34dbaffd08e03e27f37a5394a56

Is that a known issue? If so, are there workaround/patches?

Thanks in advance,
 Davide.

--001a1143fcd2f049f70548a3eaad
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello guys,<div>I am trying to get the fTPM on an Intel NU=
C working bit I get this error<br>
<div><br></div><div><p style=3D"margin:0px;font-size:12px;line-height:norma=
l;font-family:hack;color:rgb(77,47,45);background-color:rgb(223,219,195)"><=
span style=3D"font-variant-ligatures:no-common-ligatures">[=C2=A0 =C2=A0 3.=
191376] tpm_crb MSFT0101:00: can&#39;t request region for resource [mem 0xf=
ed40080-0xfed40fff]</span></p>
<p style=3D"margin:0px;font-size:12px;line-height:normal;font-family:hack;c=
olor:rgb(77,47,45);background-color:rgb(223,219,195)"><span style=3D"font-v=
ariant-ligatures:no-common-ligatures">[=C2=A0 =C2=A0 3.200378] tpm_crb: pro=
be of MSFT0101:00 failed with error -16</span></p></div><div><span style=3D=
"font-variant-ligatures:no-common-ligatures"><br></span></div></div><div><s=
pan style=3D"font-variant-ligatures:no-common-ligatures">and, of course, th=
e TPM device is not registered in dev/sysfs</span></div><div><span style=3D=
"font-variant-ligatures:no-common-ligatures"><br></span></div><div>In my un=
derstanding this is a regression as it has been already fixed in the past a=
nd merged in 4.7 or 4.8.</div><div>I also verified my source and tpm_crb.c =
contains this patch:=C2=A0<a href=3D"https://git.kernel.org/cgit/linux/kern=
el/git/torvalds/linux.git/commit/?id=3D422eac3f7deae34dbaffd08e03e27f37a539=
4a56">https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commi=
t/?id=3D422eac3f7deae34dbaffd08e03e27f37a5394a56</a></div><div><br></div><d=
iv>Is that a known issue? If so, are there workaround/patches?</div><div><b=
r></div><div>Thanks in advance,</div><div>=C2=A0Davide.</div><div><br></div=
></div>

--001a1143fcd2f049f70548a3eaad--


--===============0242597656554911478==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============0242597656554911478==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0242597656554911478==--
