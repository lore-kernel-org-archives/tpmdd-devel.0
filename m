From: Ruben Roy <rubenroy2005-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm: fix duplicate inline declaration
 specifier
Date: Wed, 4 Oct 2017 17:04:04 +0530
Message-ID: <CAKmcHfhJVTkpTSHzjt_setDz4ok8zPnF4C6Bw3QdvMhQYHGYOQ@mail.gmail.com>
References: <1506434337-15284-1-git-send-email-rubenroy2005@gmail.com>
 <20170929171704.azziyvlikbv5qnbd@linux.intel.com>
 <20171004113112.u5jnf3ims7vcxo7b@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7828287310225021747=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20171004113112.u5jnf3ims7vcxo7b-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nick Desaulniers <nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============7828287310225021747==
Content-Type: multipart/alternative; boundary="001a114221ca3615b6055ab6fc13"

--001a114221ca3615b6055ab6fc13
Content-Type: text/plain; charset="UTF-8"

Thank you, Jarkko

On 4 Oct 2017 5:01 pm, "Jarkko Sakkinen" <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
wrote:

> On Fri, Sep 29, 2017 at 08:17:04PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Sep 26, 2017 at 01:58:57PM +0000, Ruben Roy wrote:
> > > This commit fixes the duplicate inline declaration specifier in
> > > tpm2_rc_value which caused a warning
> > >
> > > Signed-off-by: Ruben Roy <rubenroy2005-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/char/tpm/tpm.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > > index 04fbff2..f4d0272 100644
> > > --- a/drivers/char/tpm/tpm.h
> > > +++ b/drivers/char/tpm/tpm.h
> > > @@ -550,7 +550,7 @@ static inline void tpm_add_ppi(struct tpm_chip
> *chip)
> > >  }
> > >  #endif
> > >
> > > -static inline inline u32 tpm2_rc_value(u32 rc)
> > > +static inline u32 tpm2_rc_value(u32 rc)
> > >  {
> > >     return (rc & BIT(7)) ? rc & 0xff : rc;
> > >  }
> > > --
> > > 1.8.3.1
> > >
> >
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > /Jarkko
>
> Applied.
>
> /Jarkko
>

--001a114221ca3615b6055ab6fc13
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Thank you, Jarkko</div><div class=3D"gmail_extra"><br><di=
v class=3D"gmail_quote">On 4 Oct 2017 5:01 pm, &quot;Jarkko Sakkinen&quot; =
&lt;<a href=3D"mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org">jarkko.sakkinen@linu=
x.intel.com</a>&gt; wrote:<br type=3D"attribution"><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex">On Fri, Sep 29, 2017 at 08:17:04PM +0300, Jarkko Sakkinen wrote:<br>
&gt; On Tue, Sep 26, 2017 at 01:58:57PM +0000, Ruben Roy wrote:<br>
&gt; &gt; This commit fixes the duplicate inline declaration specifier in<b=
r>
&gt; &gt; tpm2_rc_value which caused a warning<br>
&gt; &gt;<br>
&gt; &gt; Signed-off-by: Ruben Roy &lt;<a href=3D"mailto:rubenroy2005@gmail=
.com">rubenroy2005-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;<br>
&gt; &gt; ---<br>
&gt; &gt;=C2=A0 drivers/char/tpm/tpm.h | 2 +-<br>
&gt; &gt;=C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)<br>
&gt; &gt;<br>
&gt; &gt; diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h<br>
&gt; &gt; index 04fbff2..f4d0272 100644<br>
&gt; &gt; --- a/drivers/char/tpm/tpm.h<br>
&gt; &gt; +++ b/drivers/char/tpm/tpm.h<br>
&gt; &gt; @@ -550,7 +550,7 @@ static inline void tpm_add_ppi(struct tpm_chi=
p *chip)<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt;=C2=A0 #endif<br>
&gt; &gt;<br>
&gt; &gt; -static inline inline u32 tpm2_rc_value(u32 rc)<br>
&gt; &gt; +static inline u32 tpm2_rc_value(u32 rc)<br>
&gt; &gt;=C2=A0 {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0return (rc &amp; BIT(7)) ? rc &amp; 0xff : rc;=
<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt; --<br>
&gt; &gt; 1.8.3.1<br>
&gt; &gt;<br>
&gt;<br>
&gt; Reviewed-by: Jarkko Sakkinen &lt;<a href=3D"mailto:jarkko.sakkinen@lin=
ux.intel.com">jarkko.sakkinen-VuQAYsv1562uYJLRA6qg5Q@public.gmane.org<wbr>com</a>&gt;<br>
&gt;<br>
&gt; /Jarkko<br>
<br>
Applied.<br>
<br>
/Jarkko<br>
</blockquote></div></div>

--001a114221ca3615b6055ab6fc13--


--===============7828287310225021747==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============7828287310225021747==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7828287310225021747==--
