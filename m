From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/4] tpm: validate TPM 2.0 commands
Date: Wed, 4 Jan 2017 13:04:59 -0500
Message-ID: <OF8D508BD2.EAB22BFD-ON0025809E.0062B40C-8525809E.006356C3@notes.na.collabserv.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-3-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0639966033590733666=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170102132213.22880-3-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============0639966033590733666==
Content-Type: multipart/alternative;
	boundary="=_alternative 006356C38525809E_="


--=_alternative 006356C38525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/02/2017=20
08:22:08 AM:

> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -943,7 +943,9 @@ EXPORT=5FSYMBOL=5FGPL(tpm2=5Fprobe);
>   */
>  int tpm2=5Fauto=5Fstartup(struct tpm=5Fchip *chip)
>  {
> +   u32 nr=5Fcommands;
>     int rc;
> +   int i;
>=20
>     rc =3D tpm=5Fget=5Ftimeouts(chip);
>     if (rc)
> @@ -967,8 +969,49 @@ int tpm2=5Fauto=5Fstartup(struct tpm=5Fchip *chip)
>        }
>     }
>=20
> +   rc =3D tpm2=5Fget=5Ftpm=5Fpt(chip, TPM=5FPT=5FTOTAL=5FCOMMANDS, &nr=
=5Fcommands,=20
NULL);
> +   if (rc)
> +      return rc;
> +
> +   chip->cc=5Fattrs=5Ftbl =3D devm=5Fkzalloc(&chip->dev, 4 * nr=5Fcomman=
ds,
> +                 GFP=5FKERNEL);

For some reason this devm=5Fkzalloc bombs for the vtpm proxy driver. The=20
only reason I could come up with is that it's being called before=20
tpm=5Fadd=5Fchar=5Fdevice() has been called.

   Stefan



--=_alternative 006356C38525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 01/02/2017 08:22:08 AM:<br><br>&gt; --- a/drivers/char/tpm/tpm2-cm=
d.c<br>&gt; +++ b/drivers/char/tpm/tpm2-cmd.c<br>&gt; @@ -943,7 +943,9 @@ E=
XPORT=5FSYMBOL=5FGPL(tpm2=5Fprobe);<br>&gt; &nbsp; */<br>&gt; &nbsp;int tpm=
2=5Fauto=5Fstartup(struct tpm=5Fchip *chip)<br>&gt; &nbsp;{<br>&gt; + &nbsp=
; u32 nr=5Fcommands;<br>&gt; &nbsp; &nbsp; int rc;<br>&gt; + &nbsp; int i;<=
br>&gt; &nbsp;<br>&gt; &nbsp; &nbsp; rc =3D tpm=5Fget=5Ftimeouts(chip);<br>=
&gt; &nbsp; &nbsp; if (rc)<br>&gt; @@ -967,8 +969,49 @@ int tpm2=5Fauto=5Fs=
tartup(struct tpm=5Fchip *chip)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;}<br>&gt=
; &nbsp; &nbsp; }<br>&gt; &nbsp;<br>&gt; + &nbsp; rc =3D tpm2=5Fget=5Ftpm=
=5Fpt(chip, TPM=5FPT=5FTOTAL=5FCOMMANDS, &amp;nr=5Fcommands,
NULL);<br>&gt; + &nbsp; if (rc)<br>&gt; + &nbsp; &nbsp; &nbsp;return rc;<br=
>&gt; +<br>&gt; + &nbsp; chip-&gt;cc=5Fattrs=5Ftbl =3D devm=5Fkzalloc(&amp;=
chip-&gt;dev, 4
* nr=5Fcommands,<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; GFP=5FKERNEL);</font></tt><br><br><tt><font size=3D2>For some reaso=
n this devm=5Fkzalloc bombs for the vtpm
proxy driver. The only reason I could come up with is that it's being called
before tpm=5Fadd=5Fchar=5Fdevice() has been called.</font></tt><br><br><tt>=
<font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 006356C38525809E_=--



--===============0639966033590733666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============0639966033590733666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0639966033590733666==--
