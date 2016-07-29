From: Dmitry Torokhov <dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] tpm: fix cacheline alignment for DMA-able
	buffers
Date: Fri, 29 Jul 2016 10:30:22 -0700
Message-ID: <CAE_wzQ-=8Su6xzA8Cv+C6ma8iYJfnOwR=hW-KBKjBG+4eOwF4g@mail.gmail.com>
References: <1469761153-85576-1-git-send-email-apronin@chromium.org>
	<20160729172702.GB7020@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3081336697701182373=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160729172702.GB7020-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Dmitry Torokhov <dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============3081336697701182373==
Content-Type: multipart/alternative; boundary=001a114a8538f6b0d10538c99aca

--001a114a8538f6b0d10538c99aca
Content-Type: text/plain; charset=UTF-8

On Fri, Jul 29, 2016 at 10:27 AM, Jason Gunthorpe <
jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Thu, Jul 28, 2016 at 07:59:13PM -0700, Andrey Pronin wrote:
> > Annotate buffers used in spi transactions as ____cacheline_aligned
> > to use in DMA transfers.
> >
> > Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >  drivers/char/tpm/st33zp24/spi.c | 4 ++--
> >  drivers/char/tpm/tpm_tis_spi.c  | 4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/char/tpm/st33zp24/spi.c
> b/drivers/char/tpm/st33zp24/spi.c
> > index 9f5a011..0e9aad9 100644
> > +++ b/drivers/char/tpm/st33zp24/spi.c
> > @@ -70,8 +70,8 @@
> >  struct st33zp24_spi_phy {
> >       struct spi_device *spi_device;
> >
> > -     u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE];
> > -     u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE];
> > +     u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline_aligned;
> > +     u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline_aligned;
> >
> >       int io_lpcpd;
> >       int latency;
>
> Hurm, this still looks wrong to me. Aligning the start of buffers is
> not enough, the DMA'able space must also end on a cache line as well.
>
> So, the buffers must also always be placed at the end of the struct.
>
> IMHO It would be cleaner and safer to always kmalloc the DMA buffer
> alone than to try and optimize like this.
>

In this case moving them to the end of the structure and commenting why
they have to be at the end might be less invasive change. More
performance-efficient and resilient in low memory situations too.

Thanks,
Dmitry

--001a114a8538f6b0d10538c99aca
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On F=
ri, Jul 29, 2016 at 10:27 AM, Jason Gunthorpe <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" target=3D"_blank">jgunthorpe@ob=
sidianresearch.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
<span class=3D"">On Thu, Jul 28, 2016 at 07:59:13PM -0700, Andrey Pronin wr=
ote:<br>
&gt; Annotate buffers used in spi transactions as ____cacheline_aligned<br>
&gt; to use in DMA transfers.<br>
&gt;<br>
&gt; Signed-off-by: Andrey Pronin &lt;<a href=3D"mailto:apronin-F7+t8E8rja8pug/h7KTFAQ@public.gmane.org=
g">apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org</a>&gt;<br>
</span><span class=3D"">&gt;=C2=A0 drivers/char/tpm/st33zp24/spi.c | 4 ++--=
<br>
&gt;=C2=A0 drivers/char/tpm/tpm_tis_spi.c=C2=A0 | 4 ++--<br>
&gt;=C2=A0 2 files changed, 4 insertions(+), 4 deletions(-)<br>
&gt;<br>
&gt; diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp=
24/spi.c<br>
&gt; index 9f5a011..0e9aad9 100644<br>
</span><span class=3D"">&gt; +++ b/drivers/char/tpm/st33zp24/spi.c<br>
&gt; @@ -70,8 +70,8 @@<br>
&gt;=C2=A0 struct st33zp24_spi_phy {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct spi_device *spi_device;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE];<br>
&gt; -=C2=A0 =C2=A0 =C2=A0u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE];<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline=
_aligned;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline=
_aligned;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int io_lpcpd;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int latency;<br>
<br>
</span>Hurm, this still looks wrong to me. Aligning the start of buffers is=
<br>
not enough, the DMA&#39;able space must also end on a cache line as well.<b=
r>
<br>
So, the buffers must also always be placed at the end of the struct.<br>
<br>
IMHO It would be cleaner and safer to always kmalloc the DMA buffer<br>
alone than to try and optimize like this.<br></blockquote><div><br></div><d=
iv>In this case moving them to the end of the structure and commenting why =
they have to be at the end might be less invasive change. More performance-=
efficient and resilient in low memory situations too.</div><div><br></div><=
div>Thanks,</div><div>Dmitry</div></div></div></div>

--001a114a8538f6b0d10538c99aca--


--===============3081336697701182373==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
--===============3081336697701182373==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3081336697701182373==--
