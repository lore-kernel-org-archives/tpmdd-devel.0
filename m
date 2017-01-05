From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] tpm: check size of response before
	accessingdata
Date: Thu, 5 Jan 2017 07:14:04 -0500
Message-ID: <OF1977AA81.7A4C4986-ON0025809F.004319A3-8525809F.00433655@notes.na.collabserv.com>
References: <1483618284-3470-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0010976743908008488=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1483618284-3470-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============0010976743908008488==
Content-Type: multipart/alternative;
	boundary="=_alternative 004336558525809F_="


--=_alternative 004336558525809F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote on 01/05/2017 07:11:24=20
AM:

>=20
> Check the size of the response before accesing data in
> the response packet. This is to avoid accessing data beyond
> the end of the response.

This patch applies on top of Jarkko's tabrm tree.
There are of course many more places where such checks should be done, if=20
we agree that we want them to be done.

    Stefan

>=20
> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/char/tpm/tpm2-cmd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index abaa355..98e591b 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -394,6 +394,10 @@ int tpm2=5Fget=5Frandom(struct tpm=5Fchip *chip, u8 =

> *out, size=5Ft max)
>     (sizeof(struct tpm=5Finput=5Fheader) + \
>      sizeof(struct tpm2=5Fget=5Ftpm=5Fpt=5Fin))
>=20
> +#define TPM2=5FGET=5FTPM=5FPT=5FOUT=5FSIZE \
> +   (sizeof(struct tpm=5Foutput=5Fheader) + \
> +    sizeof(struct tpm2=5Fget=5Ftpm=5Fpt=5Fout))
> +
>  static const struct tpm=5Finput=5Fheader tpm2=5Fget=5Ftpm=5Fpt=5Fheader =
=3D {
>     .tag =3D cpu=5Fto=5Fbe16(TPM2=5FST=5FNO=5FSESSIONS),
>     .length =3D cpu=5Fto=5Fbe32(TPM2=5FGET=5FTPM=5FPT=5FIN=5FSIZE),
> @@ -713,6 +717,8 @@ ssize=5Ft tpm2=5Fget=5Ftpm=5Fpt(struct tpm=5Fchip *ch=
ip,=20
> u32 property=5Fid,  u32 *value,
>     cmd.params.get=5Ftpm=5Fpt=5Fin.property=5Fcnt =3D cpu=5Fto=5Fbe32(1);
>=20
>     rc =3D tpm=5Ftransmit=5Fcmd(chip, NULL, &cmd, sizeof(cmd), 0, desc);
> +   if (be32=5Fto=5Fcpu(cmd.header.out.length) < TPM2=5FGET=5FTPM=5FPT=5F=
OUT=5FSIZE)
> +      return -EFAULT;
>     if (!rc)
>        *value =3D be32=5Fto=5Fcpu(cmd.params.get=5Ftpm=5Fpt=5Fout.value);
>=20
> --=20
> 2.4.3
>=20
>=20
>=20
---------------------------------------------------------------------------=
---
> Check out the vibrant tech community on one of the world's most=20
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>=20



--=_alternative 004336558525809F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt; wrote
on 01/05/2017 07:11:24 AM:<br><br>&gt; <br>&gt; Check the size of the respo=
nse before accesing data in<br>&gt; the response packet. This is to avoid a=
ccessing data beyond<br>&gt; the end of the response.</font></tt><br><br><t=
t><font size=3D2>This patch applies on top of Jarkko's tabrm tree.</font></=
tt><br><tt><font size=3D2>There are of course many more places where such c=
hecks
should be done, if we agree that we want them to be done.</font></tt><br><b=
r><tt><font size=3D2>&nbsp; &nbsp; Stefan</font></tt><br><tt><font size=3D2=
><br>&gt; <br>&gt; Signed-off-by: Stefan Berger &lt;stefanb-23VcF4HTsmLD8bA29Zxznw@public.gmane.org=
com&gt;<br>&gt; ---<br>&gt; &nbsp;drivers/char/tpm/tpm2-cmd.c | 6 ++++++<br=
>&gt; &nbsp;1 file changed, 6 insertions(+)<br>&gt; <br>&gt; diff --git a/d=
rivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c<br>&gt; index abaa=
355..98e591b 100644<br>&gt; --- a/drivers/char/tpm/tpm2-cmd.c<br>&gt; +++ b=
/drivers/char/tpm/tpm2-cmd.c<br>&gt; @@ -394,6 +394,10 @@ int tpm2=5Fget=5F=
random(struct tpm=5Fchip *chip, u8
<br>&gt; *out, size=5Ft max)<br>&gt; &nbsp; &nbsp; (sizeof(struct tpm=5Finp=
ut=5Fheader) + \<br>&gt; &nbsp; &nbsp; &nbsp;sizeof(struct tpm2=5Fget=5Ftpm=
=5Fpt=5Fin))<br>&gt; &nbsp;<br>&gt; +#define TPM2=5FGET=5FTPM=5FPT=5FOUT=5F=
SIZE \<br>&gt; + &nbsp; (sizeof(struct tpm=5Foutput=5Fheader) + \<br>&gt; +=
 &nbsp; &nbsp;sizeof(struct tpm2=5Fget=5Ftpm=5Fpt=5Fout))<br>&gt; +<br>&gt;=
 &nbsp;static const struct tpm=5Finput=5Fheader tpm2=5Fget=5Ftpm=5Fpt=5Fhea=
der
=3D {<br>&gt; &nbsp; &nbsp; .tag =3D cpu=5Fto=5Fbe16(TPM2=5FST=5FNO=5FSESSI=
ONS),<br>&gt; &nbsp; &nbsp; .length =3D cpu=5Fto=5Fbe32(TPM2=5FGET=5FTPM=5F=
PT=5FIN=5FSIZE),<br>&gt; @@ -713,6 +717,8 @@ ssize=5Ft tpm2=5Fget=5Ftpm=5Fp=
t(struct tpm=5Fchip *chip,
<br>&gt; u32 property=5Fid, &nbsp;u32 *value,<br>&gt; &nbsp; &nbsp; cmd.par=
ams.get=5Ftpm=5Fpt=5Fin.property=5Fcnt =3D cpu=5Fto=5Fbe32(1);<br>&gt; &nbs=
p;<br>&gt; &nbsp; &nbsp; rc =3D tpm=5Ftransmit=5Fcmd(chip, NULL, &amp;cmd, =
sizeof(cmd),
0, desc);<br>&gt; + &nbsp; if (be32=5Fto=5Fcpu(cmd.header.out.length) &lt; =
TPM2=5FGET=5FTPM=5FPT=5FOUT=5FSIZE)<br>&gt; + &nbsp; &nbsp; &nbsp;return -E=
FAULT;<br>&gt; &nbsp; &nbsp; if (!rc)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;*v=
alue =3D be32=5Fto=5Fcpu(cmd.params.get=5Ftpm=5Fpt=5Fout.value);<br>&gt; &n=
bsp;<br>&gt; -- <br>&gt; 2.4.3<br>&gt; <br>&gt; <br>&gt; ------------------=
------------------------------------------------------------<br>&gt; Check =
out the vibrant tech community on one of the world's most <br>&gt; engaging=
 tech sites, SlashDot.org! </font></tt><a href=3Dhttp://sdm.link/slashdot><=
tt><font size=3D2>http://sdm.link/slashdot</font></tt></a><tt><font size=3D=
2><br>&gt; =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F<br>&gt; tpmdd-devel mailing list<br>&gt; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uuRhgaa4a2kL@public.gmane.org=
net<br>&gt; </font></tt><a href=3D"https://lists.sourceforge.net/lists/list=
info/tpmdd-devel"><tt><font size=3D2>https://lists.sourceforge.net/lists/li=
stinfo/tpmdd-devel</font></tt></a><tt><font size=3D2><br>&gt; <br></font></=
tt><BR>
--=_alternative 004336558525809F_=--



--===============0010976743908008488==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============0010976743908008488==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0010976743908008488==--
