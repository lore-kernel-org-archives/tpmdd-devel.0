From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 0/5] Fix whole native SPI TPM driver
Date: Thu, 2 Mar 2017 13:03:10 +0000
Message-ID: <1488459879-24349-1-git-send-email-peter.huewe@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

During our testing it showed that unfortunately the whole native spi tpm driver
was more or less non-functional since it was merged, e.g. the wrong byte for
waitstate handling was used and transfers larger than 64 bytes did not work at all.

This was probably caused by the merging of the different approaches back then,
as the initial RFC patch did not have these problems, and also my sudden lack
of time/commitment back then.
I'm sorry that the final driver code went untested for that long time.

This patch set fixes these issues one by one.
In order to avoid duplication the read/write function was consolidated to one
transfer function, so we do not have to apply the same fix at two locations.
Maybe consider squashing it - we splitted it for easier review.
 
Affected Kernels: 4.8, 4.9, 4.10
Patchset was tested on Raspberry Pi2 with SLB9670 (TPM1.2 and TPM2.0)

v2: Applied Jarkko's Comments

Peter Huewe (5):
  tpm_tis_spi: Use single function to transfer data
  tpm_tis_spi: Abort transfer when too many wait states are signaled
  tpm_tis_spi: Check correct byte for wait state indicator
  tpm_tis_spi: Remove limitation of transfers to MAX_SPI_FRAMESIZE bytes
  tpm_tis_spi: Add small delay after last transfer

 drivers/char/tpm/tpm_tis_spi.c | 160 ++++++++++++++++++-----------------------
 1 file changed, 68 insertions(+), 92 deletions(-)

-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
