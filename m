From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/12] tpm/tpm_tis: Rework interrupt
	management for phy compatibility
Date: Mon, 21 Mar 2016 18:45:52 +0100
Message-ID: <CALD+uuwVeLkkORAprsVbMEsUWhWab+yOjy=QUPTZfcFLmeUi6w@mail.gmail.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-10-git-send-email-christophe-h.ricard@st.com>
	<20160321013722.GB9417@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0967573238948359548=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160321013722.GB9417-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

--===============0967573238948359548==
Content-Type: multipart/alternative; boundary=001a11407e60312ae4052e92ac02

--001a11407e60312ae4052e92ac02
Content-Type: text/plain; charset=UTF-8

Ok, let me look into that a bit deeper.

2016-03-21 2:37 GMT+01:00 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>:

> On Sun, Mar 20, 2016 at 08:34:40PM +0100, Christophe Ricard wrote:
> > Rework interrupt handling in order to be compatible with every phy.
>
> You need to describe this much more.
>
> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -881,7 +881,9 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8
> mask, unsigned long timeout,
> >       unsigned long stop;
> >       long rc;
> >       u8 status;
> > +     u32 cur_intrs;
> >       bool canceled = false;
> > +     bool condition;
> >
> >       /* check current status */
> >       status = chip->ops->status(chip);
> > @@ -892,14 +894,17 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8
> mask, unsigned long timeout,
> >
> >       if (chip->vendor.irq) {
> >  again:
> > +             cur_intrs = chip->vendor.intrs;
> >               timeout = stop - jiffies;
> >               if ((long)timeout <= 0)
> >                       return -ETIME;
> >               rc = wait_event_interruptible_timeout(*queue,
> > -                     wait_for_tpm_stat_cond(chip, mask, check_cancel,
> > -                                            &canceled),
> > +                     cur_intrs != chip->vendor.intrs,
> >                       timeout);
> > -             if (rc > 0) {
> > +             condition = wait_for_tpm_stat_cond(chip, mask,
> > +                                                check_cancel,
> > +                                                &canceled);
> > +             if (rc > 0 && condition) {
> >                       if (canceled)
> >                               return -ECANCELED;
> >                       return 0;
>
> This should not be buried into a packet to tpm_tis.
>
> How does this even work for other drivers?
>
> > +static void tpm_tis_clear_int(struct tpm_chip *chip)
>
> All these changes look a little unsettling.. Ordering is really
> important when working with interrupts and this changes all sorts of
> things.
>
> I'd be alot happier if the current flow wasn't being changed to add
> the new interfaces.
>
> > -     if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
> > -                          dev_name(&chip->dev), chip) != 0) {
> > +     if (devm_request_threaded_irq(&chip->dev, irq, NULL,
> tis_int_handler, flags,
> > +                                   dev_name(&chip->dev), chip) != 0) {
>
> This shouldn't be changed for the lpc case either.
>
> Jason
>

--001a11407e60312ae4052e92ac02
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ok, let me look into that a bit deeper.</div><div class=3D=
"gmail_extra"><br><div class=3D"gmail_quote">2016-03-21 2:37 GMT+01:00 Jaso=
n Gunthorpe <span dir=3D"ltr">&lt;<a href=3D"mailto:jgunthorpe@obsidianrese=
arch.com" target=3D"_blank">jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org</a>&gt;</span>:=
<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex"><span class=3D"">On Sun, Mar 20, 2016 at=
 08:34:40PM +0100, Christophe Ricard wrote:<br>
&gt; Rework interrupt handling in order to be compatible with every phy.<br=
>
<br>
</span>You need to describe this much more.<br>
<div><div class=3D"h5"><br>
&gt; +++ b/drivers/char/tpm/tpm-interface.c<br>
&gt; @@ -881,7 +881,9 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 ma=
sk, unsigned long timeout,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0long rc;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 status;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u32 cur_intrs;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0bool canceled =3D false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool condition;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* check current status */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D chip-&gt;ops-&gt;status(chip);<br=
>
&gt; @@ -892,14 +894,17 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 =
mask, unsigned long timeout,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (chip-&gt;vendor.irq) {<br>
&gt;=C2=A0 again:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cur_intrs =3D chip-&g=
t;vendor.intrs;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0timeout =3D stop=
 - jiffies;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((long)timeou=
t &lt;=3D 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -ETIME;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D wait_even=
t_interruptible_timeout(*queue,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0wait_for_tpm_stat_cond(chip, mask, check_cancel,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &amp;canceled),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0cur_intrs !=3D chip-&gt;vendor.intrs,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0timeout);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc &gt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condition =3D wait_fo=
r_tpm_stat_cond(chip, mask,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 check_cancel,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 &amp;canceled);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc &gt; 0 &amp;&a=
mp; condition) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (canceled)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ECANCELED;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return 0;<br>
<br>
</div></div>This should not be buried into a packet to tpm_tis.<br>
<br>
How does this even work for other drivers?<br>
<span class=3D""><br>
&gt; +static void tpm_tis_clear_int(struct tpm_chip *chip)<br>
<br>
</span>All these changes look a little unsettling.. Ordering is really<br>
important when working with interrupts and this changes all sorts of<br>
things.<br>
<br>
I&#39;d be alot happier if the current flow wasn&#39;t being changed to add=
<br>
the new interfaces.<br>
<span class=3D""><br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (devm_request_irq(&amp;chip-&gt;dev, irq, tis_=
int_handler, flags,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 dev_name(&amp;chip-&gt;dev), chip) !=3D 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (devm_request_threaded_irq(&amp;chip-&gt;dev, =
irq, NULL, tis_int_handler, flags,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_name(&amp;chip-=
&gt;dev), chip) !=3D 0) {<br>
<br>
</span>This shouldn&#39;t be changed for the lpc case either.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Jason<br>
</font></span></blockquote></div><br></div>

--001a11407e60312ae4052e92ac02--


--===============0967573238948359548==
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
--===============0967573238948359548==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0967573238948359548==--
