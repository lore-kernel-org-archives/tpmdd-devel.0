From: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 0/2] tpm_tis_spi: Use DMA-safe memory
Date: Thu, 24 Aug 2017 10:27:43 +0200
Message-ID: <20170824082745.9372-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
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


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
