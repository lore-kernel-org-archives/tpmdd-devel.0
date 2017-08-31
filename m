From: Alexander Steffen <Alexander.Steffen@infineon.com>
Subject: [PATCH RESEND v3 0/2] tpm_tis_spi: Use DMA-safe memory
Date: Thu, 31 Aug 2017 18:58:17 +0200
Message-ID: <20170831165819.13544-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net, benoit.houyere@st.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Alexander Steffen <Alexander.Steffen@infineon.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The documentation says that DMA-safe memory is required for SPI transfers.
The I/O buffers passed in by the caller can be allocated anywhere,
including on the stack, which is not DMA-safe. So the data needs to be
copied to separate, DMA-safe buffers.

We did not see any DMA-related issues on our test systems, even without
DMA-safe buffers. But this might simply be due to the fact that the SPI
transfer size is rather small, so our systems do not bother to set up DMA
transfers. Other systems might do so.

v2:
- Updated commit message with more explanations.

v3:
- Split into two patches, one for making the buffers DMA-safe and another
  for using only a single buffer.

Alexander Steffen (2):
  tpm_tis_spi: Use DMA-safe memory for SPI transfers
  tpm_tis_spi: Use a single buffer for SPI transfers

 drivers/char/tpm/tpm_tis_spi.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

-- 
2.7.4

