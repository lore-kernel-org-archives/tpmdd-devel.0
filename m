From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RESEND v3 0/2] tpm_tis_spi: Use DMA-safe memory
Date: Wed, 6 Sep 2017 15:54:58 +0300
Message-ID: <20170906125458.ueqpmokh7bg64olc@linux.intel.com>
References: <20170831165819.13544-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170831165819.13544-1-Alexander.Steffen@infineon.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexander Steffen <Alexander.Steffen@infineon.com>
Cc: tpmdd-devel@lists.sourceforge.net, benoit.houyere@st.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 31, 2017 at 06:58:17PM +0200, Alexander Steffen wrote:
> The documentation says that DMA-safe memory is required for SPI transfers.
> The I/O buffers passed in by the caller can be allocated anywhere,
> including on the stack, which is not DMA-safe. So the data needs to be
> copied to separate, DMA-safe buffers.
> 
> We did not see any DMA-related issues on our test systems, even without
> DMA-safe buffers. But this might simply be due to the fact that the SPI
> transfer size is rather small, so our systems do not bother to set up DMA
> transfers. Other systems might do so.
> 
> v2:
> - Updated commit message with more explanations.
> 
> v3:
> - Split into two patches, one for making the buffers DMA-safe and another
>   for using only a single buffer.
> 
> Alexander Steffen (2):
>   tpm_tis_spi: Use DMA-safe memory for SPI transfers
>   tpm_tis_spi: Use a single buffer for SPI transfers
> 
>  drivers/char/tpm/tpm_tis_spi.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> -- 
> 2.7.4
> 

Applied to my bleeding edge master brach for more convenient testing.
Have not yet applied to my next branch.

/Jarkko
