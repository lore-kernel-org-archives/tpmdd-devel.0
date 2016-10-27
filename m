From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] tpm_tis: Check return values from
	get_burstcount.
Date: Thu, 27 Oct 2016 14:50:29 -0700
Message-ID: <CAHSjozAcL7W-WN+Hf4LGBO8AsGQ+e3SG+VeKB0xnonrSt5SS_A@mail.gmail.com>
References: <20161027174000.GA4432@google.com>
	<5B8DA87D05A7694D9FA63FD143655C1B5430F484@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5882686759182151102=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B5430F484-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============5882686759182151102==
Content-Type: multipart/alternative; boundary=001a113bf6be1779b9053fdfbcb1

--001a113bf6be1779b9053fdfbcb1
Content-Type: text/plain; charset=UTF-8

Thanks, that's a fair point. Updated patch sent.

Josh

On Thu, Oct 27, 2016 at 1:31 PM, Winkler, Tomas <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
wrote:

> >
> > If the TPM we're connecting to uses a static burst count, it will report
> a burst
> > count of zero throughout the response read. However, get_burstcount
> assumes
> > that a response of zero indicates that the TPM is not ready to receive
> more
> > data. In this case, it returns a negative error code, which is passed on
> to
> > tpm_tis_{write,read}_bytes as a u16, causing them to read/write far too
> many
> > bytes.
> >
> > This patch checks for negative return codes and bails out from recv_data
> and
> > tpm_tis_send_data.
> >
> > Fixes: 1107d065fdf1 (tpm_tis: Introduce intermediate layer for TPM
> access)
> > Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > ---
> > Changelog v4:
> >  - Add short description to Fixes tag line.
> >  - Remove some unnecessary information in dev_err statements.
> > Changelog v3:
> >  - Add signed-off-by.
> > Changelog v2:
> >  - Fix typo (rc->burstcnt)
> >
> > ---
> >  drivers/char/tpm/tpm_tis_core.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_
> core.c
> > index e3bf31b..0f2c233 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -186,6 +186,10 @@ static int recv_data(struct tpm_chip *chip, u8 *buf,
> > size_t count)
> >                                chip->timeout_c,
> >                                &priv->read_queue, true) == 0) {
> >               burstcnt = min_t(int, get_burstcount(chip), count - size);
> > +             if (burstcnt < 0) {
>
> It is much more readable to directly check get_burstcount return value,
> 'count - size' is protected be above condition to not reach negative value.
>                              burstcnt = get_burstcount(chip)
>                              if (brustcnt < 0) ...
>
>
> > +                     dev_err(&chip->dev, "Unable to read burstcount\n");
> > +                     return burstcnt;
> > +             }
> >
> >               rc = tpm_tis_read_bytes(priv,
> TPM_DATA_FIFO(priv->locality),
> >                                       burstcnt, buf + size);
> > @@ -272,6 +276,11 @@ static int tpm_tis_send_data(struct tpm_chip *chip,
> u8
> > *buf, size_t len)
> >
> >       while (count < len - 1) {
> >               burstcnt = min_t(int, get_burstcount(chip), len - count -
> 1);
> > +             if (burstcnt < 0) {
> Same here
> > +                     dev_err(&chip->dev, "Unable to read burstcount\n");
> > +                     rc = burstcnt;
> > +                     goto out_err;
> > +             }
> >               rc = tpm_tis_write_bytes(priv,
> TPM_DATA_FIFO(priv->locality),
> >                                        burstcnt, buf + count);
> >               if (rc < 0)
> > --
> > 2.8.0.rc3.226.g39d4020
>
> Thanks
> Tomas
>

--001a113bf6be1779b9053fdfbcb1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks, that&#39;s a fair point. Updated patch sent.</div>=
<div class=3D"gmail_extra"><br clear=3D"all"><div><div class=3D"gmail_signa=
ture" data-smartmail=3D"gmail_signature"><div dir=3D"ltr">Josh</div></div><=
/div>
<br><div class=3D"gmail_quote">On Thu, Oct 27, 2016 at 1:31 PM, Winkler, To=
mas <span dir=3D"ltr">&lt;<a href=3D"mailto:tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" target=
=3D"_blank">tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">&gt;<br>
&gt; If the TPM we&#39;re connecting to uses a static burst count, it will =
report a burst<br>
&gt; count of zero throughout the response read. However, get_burstcount as=
sumes<br>
&gt; that a response of zero indicates that the TPM is not ready to receive=
 more<br>
&gt; data. In this case, it returns a negative error code, which is passed =
on to<br>
&gt; tpm_tis_{write,read}_bytes as a u16, causing them to read/write far to=
o many<br>
&gt; bytes.<br>
&gt;<br>
&gt; This patch checks for negative return codes and bails out from recv_da=
ta and<br>
&gt; tpm_tis_send_data.<br>
&gt;<br>
&gt; Fixes: 1107d065fdf1 (tpm_tis: Introduce intermediate layer for TPM acc=
ess)<br>
&gt; Signed-off-by: Josh Zimmerman &lt;<a href=3D"mailto:joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org">=
joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org</a>&gt;<br>
&gt;<br>
&gt; ---<br>
&gt; Changelog v4:<br>
&gt;=C2=A0 - Add short description to Fixes tag line.<br>
&gt;=C2=A0 - Remove some unnecessary information in dev_err statements.<br>
&gt; Changelog v3:<br>
&gt;=C2=A0 - Add signed-off-by.<br>
&gt; Changelog v2:<br>
&gt;=C2=A0 - Fix typo (rc-&gt;burstcnt)<br>
&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/char/tpm/tpm_tis_core.<wbr>c | 9 +++++++++<br>
&gt;=C2=A0 1 file changed, 9 insertions(+)<br>
&gt;<br>
&gt; diff --git a/drivers/char/tpm/tpm_tis_<wbr>core.c b/drivers/char/tpm/t=
pm_tis_<wbr>core.c<br>
&gt; index e3bf31b..0f2c233 100644<br>
&gt; --- a/drivers/char/tpm/tpm_tis_<wbr>core.c<br>
&gt; +++ b/drivers/char/tpm/tpm_tis_<wbr>core.c<br>
&gt; @@ -186,6 +186,10 @@ static int recv_data(struct tpm_chip *chip, u8 *b=
uf,<br>
&gt; size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip-&gt;timeout_c,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;priv-&gt;read_queue, true) =
=3D=3D 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D min=
_t(int, get_burstcount(chip), count - size);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (burstcnt &lt; 0) =
{<br>
<br>
</div></div>It is much more readable to directly check get_burstcount retur=
n value, &#39;count - size&#39; is protected be above condition to not reac=
h negative value.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D get_burstcount(chip)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (brustcnt &lt; 0) ...<br>
<span class=3D""><br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0dev_err(&amp;chip-&gt;dev, &quot;Unable to read burstcount\n&quot;);=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return burstcnt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D tpm_tis_r=
ead_bytes(priv, TPM_DATA_FIFO(priv-&gt;locality),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstc=
nt, buf + size);<br>
&gt; @@ -272,6 +276,11 @@ static int tpm_tis_send_data(struct tpm_chip *chi=
p, u8<br>
&gt; *buf, size_t len)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while (count &lt; len - 1) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D min=
_t(int, get_burstcount(chip), len - count - 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (burstcnt &lt; 0) =
{<br>
</span>Same here<br>
<span class=3D"">&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;chip-&gt;dev, &quot;Unable to read bur=
stcount\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0rc =3D burstcnt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0goto out_err;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D tpm_tis_w=
rite_bytes(priv, TPM_DATA_FIFO(priv-&gt;locality),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 burst=
cnt, buf + count);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc &lt; 0)<b=
r>
&gt; --<br>
&gt; 2.8.0.rc3.226.g39d4020<br>
<br>
</span>Thanks<br>
<span class=3D"HOEnZb"><font color=3D"#888888">Tomas<br>
</font></span></blockquote></div><br></div>

--001a113bf6be1779b9053fdfbcb1--


--===============5882686759182151102==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
The Command Line: Reinvented for Modern Developers
Did the resurgence of CLI tooling catch you by surprise?
Reconnect with the command line and become more productive. 
Learn the new .NET and ASP.NET CLI. Get your free copy!
http://sdm.link/telerik
--===============5882686759182151102==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============5882686759182151102==--
