From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 2/5] tpm_tis_spi: Abort transfer when too
	many wait states are signaled
Date: Thu, 2 Mar 2017 13:03:12 +0000
Message-ID: <1488459879-24349-3-git-send-email-peter.huewe@infineon.com>
References: <1488459879-24349-1-git-send-email-peter.huewe@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1488459879-24349-1-git-send-email-peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Abort the transfer with ETIMEDOUT when the TPM signals more than
TPM_RETRY wait states. Continuing with the transfer in this state
will only lead to arbitrary failures in other parts of the code.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Tested-by: Benoit Houyere <benoit.houyere-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index 062799e04f04..639614f2d415 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -101,6 +101,11 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
 			goto exit;
 	}
 
+	if (i == TPM_RETRY) {
+		ret = -ETIMEDOUT;
+		goto exit;
+	}
+
 	spi_xfer.cs_change = 0;
 	spi_xfer.len = len;
 
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
