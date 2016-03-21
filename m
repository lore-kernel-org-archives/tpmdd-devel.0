From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/12] tpm: Add check_data handle to
 tpm_class_ops in order to check data integrity
Date: Mon, 21 Mar 2016 18:44:54 +0100
Message-ID: <CALD+uuzogdJ+Nm0ue=thPnsVPfPNpUEsbjr-tP2M+MsztYGH_w@mail.gmail.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-12-git-send-email-christophe-h.ricard@st.com>
	<20160321013933.GC9417@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2014101034111663788=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160321013933.GC9417-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jean-Luc BLANC <jean-luc.blanc-qxv4g6HH51o@public.gmane.org>, "ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org" <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christophe RICARD <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============2014101034111663788==
Content-Type: multipart/alternative; boundary=001a1133b56cae2d21052e92a860

--001a1133b56cae2d21052e92a860
Content-Type: text/plain; charset=UTF-8

Hi Jason,

Just trying to understand. How check_data would be more specific than
update_timeouts only used by the tis part as well ?
Do you expect to have a tis_ops specific structure ?

Best Regards
Christophe

2016-03-21 2:39 GMT+01:00 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>:

> On Sun, Mar 20, 2016 at 08:34:42PM +0100, Christophe Ricard wrote:
> > @@ -43,6 +43,7 @@ struct tpm_class_ops {
> >       u8 (*status) (struct tpm_chip *chip);
> >       bool (*update_timeouts)(struct tpm_chip *chip,
> >                               unsigned long *timeout_cap);
> > +     bool (*check_data)(struct tpm_chip *chip, u8 *buf, size_t len);
> >       int (*read_bytes)(struct tpm_chip *chip, u32 addr, size_t len,
> >                         u8 size, u8 *dst);
>
> Don't add tis specific functions to this structure.
>
> Jason
>

--001a1133b56cae2d21052e92a860
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Jason,<div><br></div><div>Just trying to understand. Ho=
w check_data would be more specific than update_timeouts only used by the t=
is part as well ?</div><div>Do you expect to have a tis_ops specific struct=
ure ?</div><div><br></div><div>Best Regards</div><div>Christophe</div></div=
><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2016-03-21 2:39 =
GMT+01:00 Jason Gunthorpe <span dir=3D"ltr">&lt;<a href=3D"mailto:jgunthorp=
e@obsidianresearch.com" target=3D"_blank">jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org</=
a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Sun, M=
ar 20, 2016 at 08:34:42PM +0100, Christophe Ricard wrote:<br>
&gt; @@ -43,6 +43,7 @@ struct tpm_class_ops {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 (*status) (struct tpm_chip *chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0bool (*update_timeouts)(struct tpm_chip *chi=
p,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long *timeout_cap);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool (*check_data)(struct tpm_chip *chip, u8 *buf=
, size_t len);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int (*read_bytes)(struct tpm_chip *chip, u32=
 addr, size_t len,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0u8 size, u8 *dst);<br>
<br>
</span>Don&#39;t add tis specific functions to this structure.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Jason<br>
</font></span></blockquote></div><br></div>

--001a1133b56cae2d21052e92a860--


--===============2014101034111663788==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
--===============2014101034111663788==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2014101034111663788==--
