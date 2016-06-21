From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 3/5] tpm: Factor out reading of timeout
	and duration capabilities
Date: Mon, 20 Jun 2016 18:46:50 -0700
Message-ID: <CAO_EM_m_XLMqvMj9ijGUsB2ODbgEdL=tCY6ZyO-CAF+Pza=W8Q@mail.gmail.com>
References: <1465426818-89356-1-git-send-email-eswierk@skyportsystems.com>
	<1465610107-87762-1-git-send-email-eswierk@skyportsystems.com>
	<1465610107-87762-4-git-send-email-eswierk@skyportsystems.com>
	<20160619120157.GA29626@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4134684558862644046=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160619120157.GA29626-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============4134684558862644046==
Content-Type: multipart/alternative; boundary=001a113d0efcfd3c9e0535c000cb

--001a113d0efcfd3c9e0535c000cb
Content-Type: text/plain; charset=UTF-8

On Sun, Jun 19, 2016 at 5:12 AM, Jarkko Sakkinen <
jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> I think inside tpm_get_timeouts() I'd rather something along the lines
> (with error handling and such details taken away):
>
> rc = tpm_getcap(...);
>
> if (rc == TPM_ERR_INVALID_POSTINIT) {
>         tpm_startup(...);
>         tpm_getca(...);
> }
>

Agreed.

> +     if (rc) {
> > +             dev_err(chip->pdev,
> > +                     "Error %zd reading %s\n", rc, desc);
> > +             return rc;
> > +     }
> > +
> > +     if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
> > +         be32_to_cpu(tpm_cmd.header.out.length)
> > +         != sizeof(tpm_cmd.header.out) + sizeof(u32) + size *
> sizeof(u32)) {
> > +             dev_err(chip->pdev,
> > +                     "Bad return code or length reading %s\n", desc);
> > +             return -EINVAL;
> > +     }
>
> This is bogus code. All this kind of checks should be contained in
> tpm_transmit_cmd(). This is easily "fixed" by moving tpm_getcap() :)
>

tpm_transmit_cmd() already checks the return_code, so that's easy. It
doesn't know the expected length, but tpm_getcap() does (or can, based on
the subcap_id).

--Ed

--001a113d0efcfd3c9e0535c000cb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On S=
un, Jun 19, 2016 at 5:12 AM, Jarkko Sakkinen <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" target=3D"_blank">jarkko.sakkin=
en-VuQAYsv1563Yd54FQh9/CA@public.gmane.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
I think inside tpm_get_timeouts() I&#39;d rather something along the lines<=
br>
(with error handling and such details taken away):<br>
<br>
rc =3D tpm_getcap(...);<br>
<br>
if (rc =3D=3D TPM_ERR_INVALID_POSTINIT) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tpm_startup(...);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tpm_getca(...);<br>
<span class=3D"">}<br></span></blockquote><div><br></div><div>Agreed.</div>=
<div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">
&gt; +=C2=A0 =C2=A0 =C2=A0if (rc) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(chip-&gt;pdev=
,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0&quot;Error %zd reading %s\n&quot;, rc, desc);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (be32_to_cpu(tpm_cmd.header.out.return_code) !=
=3D 0 ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0be32_to_cpu(tpm_cmd.header.out.leng=
th)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!=3D sizeof(tpm_cmd.header.out) + s=
izeof(u32) + size * sizeof(u32)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(chip-&gt;pdev=
,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0&quot;Bad return code or length reading %s\n&quot;, desc);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
<br>
</span>This is bogus code. All this kind of checks should be contained in<b=
r>
tpm_transmit_cmd(). This is easily &quot;fixed&quot; by moving tpm_getcap()=
 :)<br></blockquote><div><br></div><div>tpm_transmit_cmd() already checks t=
he return_code, so that&#39;s easy. It doesn&#39;t know the expected length=
, but tpm_getcap() does (or can, based on the subcap_id).</div><div><br></d=
iv><div>--Ed</div></div><br></div></div>

--001a113d0efcfd3c9e0535c000cb--


--===============4134684558862644046==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
--===============4134684558862644046==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4134684558862644046==--
