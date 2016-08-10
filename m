From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix cacheline alignment for DMA-able
 buffers
Date: Wed, 10 Aug 2016 13:36:45 +0300
Message-ID: <20160810103645.GA12832@intel.com>
References: <1469761153-85576-1-git-send-email-apronin@chromium.org>
	<20160729172702.GB7020@obsidianresearch.com>
	<CAE_wzQ-=8Su6xzA8Cv+C6ma8iYJfnOwR=hW-KBKjBG+4eOwF4g@mail.gmail.com>
	<20160809094610.GA13566@intel.com>
	<20160809150114.GA9672@intel.com>
	<CAE_wzQ95LAm7JkfB=V2VZVc4Vha4GcRyOBH_J8ZEh1gG+ZjEAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE_wzQ95LAm7JkfB=V2VZVc4Vha4GcRyOBH_J8ZEh1gG+ZjEAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Dmitry Torokhov <dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 09, 2016 at 08:18:00AM -0700, Dmitry Torokhov wrote:
>    On Tue, Aug 9, 2016 at 8:01 AM, Jarkko Sakkinen
>    <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> =

>      On Tue, Aug 09, 2016 at 12:46:10PM +0300, Jarkko Sakkinen wrote:
>      > On Fri, Jul 29, 2016 at 10:30:22AM -0700, Dmitry Torokhov wrote:
>      > >=C2=A0 =C2=A0 On Fri, Jul 29, 2016 at 10:27 AM, Jason Gunthorpe
>      > >=C2=A0 =C2=A0 <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>      > >
>      > >=C2=A0 =C2=A0 =C2=A0 On Thu, Jul 28, 2016 at 07:59:13PM -0700, An=
drey Pronin
>      wrote:
>      > >=C2=A0 =C2=A0 =C2=A0 > Annotate buffers used in spi transactions =
as
>      ____cacheline_aligned
>      > >=C2=A0 =C2=A0 =C2=A0 > to use in DMA transfers.
>      > >=C2=A0 =C2=A0 =C2=A0 >
>      > >=C2=A0 =C2=A0 =C2=A0 > Signed-off-by: Andrey Pronin <apronin@chro=
mium.org>
>      > >=C2=A0 =C2=A0 =C2=A0 >=C2=A0 drivers/char/tpm/st33zp24/spi.c | 4 =
++--
>      > >=C2=A0 =C2=A0 =C2=A0 >=C2=A0 drivers/char/tpm/tpm_tis_spi.c=C2=A0=
 | 4 ++--
>      > >=C2=A0 =C2=A0 =C2=A0 >=C2=A0 2 files changed, 4 insertions(+), 4 =
deletions(-)
>      > >=C2=A0 =C2=A0 =C2=A0 >
>      > >=C2=A0 =C2=A0 =C2=A0 > diff --git a/drivers/char/tpm/st33zp24/spi=
.c
>      > >=C2=A0 =C2=A0 =C2=A0 b/drivers/char/tpm/st33zp24/spi.c
>      > >=C2=A0 =C2=A0 =C2=A0 > index 9f5a011..0e9aad9 100644
>      > >=C2=A0 =C2=A0 =C2=A0 > +++ b/drivers/char/tpm/st33zp24/spi.c
>      > >=C2=A0 =C2=A0 =C2=A0 > @@ -70,8 +70,8 @@
>      > >=C2=A0 =C2=A0 =C2=A0 >=C2=A0 struct st33zp24_spi_phy {
>      > >=C2=A0 =C2=A0 =C2=A0 >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct spi_devic=
e *spi_device;
>      > >=C2=A0 =C2=A0 =C2=A0 >
>      > >=C2=A0 =C2=A0 =C2=A0 > -=C2=A0 =C2=A0 =C2=A0u8 tx_buf[ST33ZP24_SP=
I_BUFFER_SIZE];
>      > >=C2=A0 =C2=A0 =C2=A0 > -=C2=A0 =C2=A0 =C2=A0u8 rx_buf[ST33ZP24_SP=
I_BUFFER_SIZE];
>      > >=C2=A0 =C2=A0 =C2=A0 > +=C2=A0 =C2=A0 =C2=A0u8 tx_buf[ST33ZP24_SP=
I_BUFFER_SIZE]
>      ____cacheline_aligned;
>      > >=C2=A0 =C2=A0 =C2=A0 > +=C2=A0 =C2=A0 =C2=A0u8 rx_buf[ST33ZP24_SP=
I_BUFFER_SIZE]
>      ____cacheline_aligned;
>      > >=C2=A0 =C2=A0 =C2=A0 >
>      > >=C2=A0 =C2=A0 =C2=A0 >=C2=A0 =C2=A0 =C2=A0 =C2=A0int io_lpcpd;
>      > >=C2=A0 =C2=A0 =C2=A0 >=C2=A0 =C2=A0 =C2=A0 =C2=A0int latency;
>      > >
>      > >=C2=A0 =C2=A0 =C2=A0 Hurm, this still looks wrong to me. Aligning=
 the start of
>      buffers is
>      > >=C2=A0 =C2=A0 =C2=A0 not enough, the DMA'able space must also end=
 on a cache line
>      as well.
>      > >
>      > >=C2=A0 =C2=A0 =C2=A0 So, the buffers must also always be placed a=
t the end of the
>      struct.
>      > >
>      > >=C2=A0 =C2=A0 =C2=A0 IMHO It would be cleaner and safer to always=
 kmalloc the DMA
>      buffer
>      > >=C2=A0 =C2=A0 =C2=A0 alone than to try and optimize like this.
>      > >
>      > >=C2=A0 =C2=A0 In this case moving them to the end of the structur=
e and
>      commenting why
>      > >=C2=A0 =C2=A0 they have to be at the end might be less invasive c=
hange. More
>      > >=C2=A0 =C2=A0 performance-efficient and resilient in low memory s=
ituations
>      too.
>      >
>      > kmallocs would be done in the driver initialization:
>      >
>      > * you rarely are in low memory situation
>      > * performance gain/loss is insignificant
>      >
>      > I really don't see your point.
> =

>      I'm fine having them at the end of the structure mainly for simplici=
ty
>      reasons but those arguments just didn't hold at all.
> =

>    Well, the main reason was simplicity and invasiveness of the change.
>    But I still maintain that doing 3 memory allocations instead of 1 is l=
ess
>    performant and puts more pressure on the kernel. Yes, it is at bind ti=
me,
>    but you do not have to do 3 times work when one allocation will suffic=
e.
>    Also, driver binding does not necessarily happen at boot time. I can
>    always unbind and rebind the driver or reload the module.

I'm fine with either approach.

>    Thanks,
>    Dmitry

/Jarkko

---------------------------------------------------------------------------=
---
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols ar=
e =

consuming the most bandwidth. Provides multi-vendor support for NetFlow, =

J-Flow, sFlow and other flows. Make informed decisions using capacity =

planning reports. http://sdm.link/zohodev2dev
