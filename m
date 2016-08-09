From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix cacheline alignment for DMA-able
 buffers
Date: Tue, 9 Aug 2016 18:01:14 +0300
Message-ID: <20160809150114.GA9672@intel.com>
References: <1469761153-85576-1-git-send-email-apronin@chromium.org>
 <20160729172702.GB7020@obsidianresearch.com>
 <CAE_wzQ-=8Su6xzA8Cv+C6ma8iYJfnOwR=hW-KBKjBG+4eOwF4g@mail.gmail.com>
 <20160809094610.GA13566@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160809094610.GA13566@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Christophe Ricard <christophe.ricard@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 09, 2016 at 12:46:10PM +0300, Jarkko Sakkinen wrote:
> On Fri, Jul 29, 2016 at 10:30:22AM -0700, Dmitry Torokhov wrote:
> >    On Fri, Jul 29, 2016 at 10:27 AM, Jason Gunthorpe
> >    <jgunthorpe@obsidianresearch.com> wrote:
> > 
> >      On Thu, Jul 28, 2016 at 07:59:13PM -0700, Andrey Pronin wrote:
> >      > Annotate buffers used in spi transactions as ____cacheline_aligned
> >      > to use in DMA transfers.
> >      >
> >      > Signed-off-by: Andrey Pronin <apronin@chromium.org>
> >      >  drivers/char/tpm/st33zp24/spi.c | 4 ++--
> >      >  drivers/char/tpm/tpm_tis_spi.c  | 4 ++--
> >      >  2 files changed, 4 insertions(+), 4 deletions(-)
> >      >
> >      > diff --git a/drivers/char/tpm/st33zp24/spi.c
> >      b/drivers/char/tpm/st33zp24/spi.c
> >      > index 9f5a011..0e9aad9 100644
> >      > +++ b/drivers/char/tpm/st33zp24/spi.c
> >      > @@ -70,8 +70,8 @@
> >      >  struct st33zp24_spi_phy {
> >      >       struct spi_device *spi_device;
> >      >
> >      > -     u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE];
> >      > -     u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE];
> >      > +     u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline_aligned;
> >      > +     u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline_aligned;
> >      >
> >      >       int io_lpcpd;
> >      >       int latency;
> > 
> >      Hurm, this still looks wrong to me. Aligning the start of buffers is
> >      not enough, the DMA'able space must also end on a cache line as well.
> > 
> >      So, the buffers must also always be placed at the end of the struct.
> > 
> >      IMHO It would be cleaner and safer to always kmalloc the DMA buffer
> >      alone than to try and optimize like this.
> > 
> >    In this case moving them to the end of the structure and commenting why
> >    they have to be at the end might be less invasive change. More
> >    performance-efficient and resilient in low memory situations too.
> 
> kmallocs would be done in the driver initialization:
> 
> * you rarely are in low memory situation
> * performance gain/loss is insignificant
> 
> I really don't see your point.

I'm fine having them at the end of the structure mainly for simplicity
reasons but those arguments just didn't hold at all.

/Jarkko
