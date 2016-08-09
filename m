From: Dmitry Torokhov <dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] tpm: fix cacheline alignment for DMA-able
	buffers
Date: Tue, 9 Aug 2016 08:18:00 -0700
Message-ID: <CAE_wzQ95LAm7JkfB=V2VZVc4Vha4GcRyOBH_J8ZEh1gG+ZjEAA@mail.gmail.com>
References: <1469761153-85576-1-git-send-email-apronin@chromium.org>
	<20160729172702.GB7020@obsidianresearch.com>
	<CAE_wzQ-=8Su6xzA8Cv+C6ma8iYJfnOwR=hW-KBKjBG+4eOwF4g@mail.gmail.com>
	<20160809094610.GA13566@intel.com> <20160809150114.GA9672@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3517980134801445065=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160809150114.GA9672-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Dmitry Torokhov <dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============3517980134801445065==
Content-Type: multipart/alternative; boundary=94eb2c0c7d22d59fad0539a50974

--94eb2c0c7d22d59fad0539a50974
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 9, 2016 at 8:01 AM, Jarkko Sakkinen <
jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> On Tue, Aug 09, 2016 at 12:46:10PM +0300, Jarkko Sakkinen wrote:
> > On Fri, Jul 29, 2016 at 10:30:22AM -0700, Dmitry Torokhov wrote:
> > >    On Fri, Jul 29, 2016 at 10:27 AM, Jason Gunthorpe
> > >    <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > >
> > >      On Thu, Jul 28, 2016 at 07:59:13PM -0700, Andrey Pronin wrote:
> > >      > Annotate buffers used in spi transactions as
> ____cacheline_aligned
> > >      > to use in DMA transfers.
> > >      >
> > >      > Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > >      >  drivers/char/tpm/st33zp24/spi.c | 4 ++--
> > >      >  drivers/char/tpm/tpm_tis_spi.c  | 4 ++--
> > >      >  2 files changed, 4 insertions(+), 4 deletions(-)
> > >      >
> > >      > diff --git a/drivers/char/tpm/st33zp24/spi.c
> > >      b/drivers/char/tpm/st33zp24/spi.c
> > >      > index 9f5a011..0e9aad9 100644
> > >      > +++ b/drivers/char/tpm/st33zp24/spi.c
> > >      > @@ -70,8 +70,8 @@
> > >      >  struct st33zp24_spi_phy {
> > >      >       struct spi_device *spi_device;
> > >      >
> > >      > -     u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE];
> > >      > -     u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE];
> > >      > +     u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE]
> ____cacheline_aligned;
> > >      > +     u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE]
> ____cacheline_aligned;
> > >      >
> > >      >       int io_lpcpd;
> > >      >       int latency;
> > >
> > >      Hurm, this still looks wrong to me. Aligning the start of buffers
> is
> > >      not enough, the DMA'able space must also end on a cache line as
> well.
> > >
> > >      So, the buffers must also always be placed at the end of the
> struct.
> > >
> > >      IMHO It would be cleaner and safer to always kmalloc the DMA
> buffer
> > >      alone than to try and optimize like this.
> > >
> > >    In this case moving them to the end of the structure and commenting
> why
> > >    they have to be at the end might be less invasive change. More
> > >    performance-efficient and resilient in low memory situations too.
> >
> > kmallocs would be done in the driver initialization:
> >
> > * you rarely are in low memory situation
> > * performance gain/loss is insignificant
> >
> > I really don't see your point.
>
> I'm fine having them at the end of the structure mainly for simplicity
> reasons but those arguments just didn't hold at all.
>

Well, the main reason was simplicity and invasiveness of the change.

But I still maintain that doing 3 memory allocations instead of 1 is less
performant and puts more pressure on the kernel. Yes, it is at bind time,
but you do not have to do 3 times work when one allocation will suffice.
Also, driver binding does not necessarily happen at boot time. I can always
unbind and rebind the driver or reload the module.

Thanks,
Dmitry

--94eb2c0c7d22d59fad0539a50974
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
ue, Aug 9, 2016 at 8:01 AM, Jarkko Sakkinen <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" target=3D"_blank">jarkko.sakkin=
en-VuQAYsv1563Yd54FQh9/CA@public.gmane.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
<div class=3D"HOEnZb"><div class=3D"h5">On Tue, Aug 09, 2016 at 12:46:10PM =
+0300, Jarkko Sakkinen wrote:<br>
&gt; On Fri, Jul 29, 2016 at 10:30:22AM -0700, Dmitry Torokhov wrote:<br>
&gt; &gt;=C2=A0 =C2=A0 On Fri, Jul 29, 2016 at 10:27 AM, Jason Gunthorpe<br=
>
&gt; &gt;=C2=A0 =C2=A0 &lt;<a href=3D"mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMNAWLNoT+7d/@public.gmane.org=
m">jgunthorpe@obsidianresearch.<wbr>com</a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 On Thu, Jul 28, 2016 at 07:59:13PM -0700, And=
rey Pronin wrote:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; Annotate buffers used in spi transaction=
s as ____cacheline_aligned<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; to use in DMA transfers.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; Signed-off-by: Andrey Pronin &lt;<a href=
=3D"mailto:apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org">apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org</a>&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 drivers/char/tpm/st33zp24/spi.<wbr=
>c | 4 ++--<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 drivers/char/tpm/tpm_tis_spi.<wbr>=
c=C2=A0 | 4 ++--<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 2 files changed, 4 insertions(+), =
4 deletions(-)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; diff --git a/drivers/char/tpm/st33zp24/<=
wbr>spi.c<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 b/drivers/char/tpm/st33zp24/<wbr>spi.c<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; index 9f5a011..0e9aad9 100644<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; +++ b/drivers/char/tpm/st33zp24/<wbr>spi=
.c<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -70,8 +70,8 @@<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 struct st33zp24_spi_phy {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct spi_dev=
ice *spi_device;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0u8 tx_buf[ST33ZP24_=
SPI_BUFFER_<wbr>SIZE];<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0u8 rx_buf[ST33ZP24_=
SPI_BUFFER_<wbr>SIZE];<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0u8 tx_buf[ST33ZP24_=
SPI_BUFFER_<wbr>SIZE] ____cacheline_aligned;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0u8 rx_buf[ST33ZP24_=
SPI_BUFFER_<wbr>SIZE] ____cacheline_aligned;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int io_lpcpd;<=
br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int latency;<b=
r>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 Hurm, this still looks wrong to me. Aligning =
the start of buffers is<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 not enough, the DMA&#39;able space must also =
end on a cache line as well.<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 So, the buffers must also always be placed at=
 the end of the struct.<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 IMHO It would be cleaner and safer to always =
kmalloc the DMA buffer<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 alone than to try and optimize like this.<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 In this case moving them to the end of the structure=
 and commenting why<br>
&gt; &gt;=C2=A0 =C2=A0 they have to be at the end might be less invasive ch=
ange. More<br>
&gt; &gt;=C2=A0 =C2=A0 performance-efficient and resilient in low memory si=
tuations too.<br>
&gt;<br>
&gt; kmallocs would be done in the driver initialization:<br>
&gt;<br>
&gt; * you rarely are in low memory situation<br>
&gt; * performance gain/loss is insignificant<br>
&gt;<br>
&gt; I really don&#39;t see your point.<br>
<br>
</div></div>I&#39;m fine having them at the end of the structure mainly for=
 simplicity<br>
reasons but those arguments just didn&#39;t hold at all.<br></blockquote><d=
iv><br></div><div>Well, the main reason was simplicity and invasiveness of =
the change.</div><div><br></div><div>But I still maintain that doing 3 memo=
ry allocations instead of 1 is less performant and puts more pressure on th=
e kernel. Yes, it is at bind time, but you do not have to do 3 times work w=
hen one allocation will suffice. Also, driver binding does not necessarily =
happen at boot time. I can always unbind and rebind the driver or reload th=
e module.</div><div><br></div><div>Thanks,</div><div>Dmitry</div></div></di=
v></div>

--94eb2c0c7d22d59fad0539a50974--


--===============3517980134801445065==
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
--===============3517980134801445065==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3517980134801445065==--
