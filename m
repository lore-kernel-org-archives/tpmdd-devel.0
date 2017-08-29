From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 0/2] tpm_tis_spi: Use DMA-safe memory
Date: Tue, 29 Aug 2017 12:14:37 +0000
Message-ID: <9aea582eccbe4655b5de487dacf7c745@MUCSE603.infineon.com>
References: <20170824082745.9372-1-Alexander.Steffen@infineon.com>
 <20170826112259.ypwtqbwakyfdqkzo@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170826112259.ypwtqbwakyfdqkzo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> On Thu, Aug 24, 2017 at 10:27:43AM +0200, Alexander Steffen wrote:
> > The documentation says that DMA-safe memory is required for SPI
> transfers.
> > The I/O buffers passed in by the caller can be allocated anywhere,
> > including on the stack, which is not DMA-safe. So the data needs to be
> > copied to separate, DMA-safe buffers.
> >
> > We did not see any DMA-related issues on our test systems, even
> > without DMA-safe buffers. But this might simply be due to the fact
> > that the SPI transfer size is rather small, so our systems do not
> > bother to set up DMA transfers. Other systems might do so.
> >
> > v2:
> > - Updated commit message with more explanations.
> >
> > v3:
> > - Split into two patches, one for making the buffers DMA-safe and another
> >   for using only a single buffer.
> >
> > Alexander Steffen (2):
> >   tpm_tis_spi: Use DMA-safe memory for SPI transfers
> >   tpm_tis_spi: Use a single buffer for SPI transfers
> >
> >  drivers/char/tpm/tpm_tis_spi.c | 32 ++++++++++++++++++--------------
> >  1 file changed, 18 insertions(+), 14 deletions(-)
> >
> > --
> > 2.7.4
> >
> 
> Needs to be CC linux-kernel and linux-security-module

I will resend the patches there. Is this process of what patches to send where documented somewhere? MAINTAINERS mentions only tpmdd-devel.

> and tested-by.

I forgot to mention that before: Unless otherwise noted, everything that I submit has been tested with:

- tpm_tis on x86_64 with LPC TPMs 1.2 and 2.0 (Infineon SLB 9660 and SLB 9665)
- tpm_tis_spi on armv7l and aarch64 (Raspberry Pi 2 and 3) with SPI TPMs 1.2 and 2.0 (Infineon SLB 9670)
- tpm_i2c_infineon on armv7l (Raspberry Pi 2) with I2C TPMs 1.2 (Infineon SLB 9635 and SLB 9645)

Since those tests are fully automated, I'm happy to integrate more TPM chips, if anyone has got some for me ;-)

To get some more test coverage for this SPI-specific change, maybe Benoit or Christophe can rerun their tests? Though this change probably depends more on the platform than on the TPM. As far as we could tell from the code, our Raspberry Pis will never use DMA for the SPI transfers to the TPM, because those transfers are too small.

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
