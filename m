From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 3/5] tpm_tis_spi: Check correct byte for
	wait state indicator
Date: Thu, 2 Mar 2017 13:03:13 +0000
Message-ID: <1488459879-24349-4-git-send-email-peter.huewe@infineon.com>
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

Wait states are signaled in the last byte received from the TPM in
response to the header, not the first byte. Check rx_buf[3] instead of
rx_buf[0].

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Tested-by: Benoit Houyere <benoit.houyere-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index 639614f2d415..62f50b6c9ef6 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -85,25 +85,25 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
 	if (ret < 0)
 		goto exit;
 
-	phy->tx_buf[0] = 0;
-
-	/* According to TCG PTP specification, if there is no TPM present at
-	 * all, then the design has a weak pull-up on MISO. If a TPM is not
-	 * present, a pull-up on MISO means that the SB controller sees a 1,
-	 * and will latch in 0xFF on the read.
-	 */
-	for (i = 0; (phy->rx_buf[0] & 0x01) == 0 && i < TPM_RETRY; i++) {
-		spi_xfer.len = 1;
-		spi_message_init(&m);
-		spi_message_add_tail(&spi_xfer, &m);
-		ret = spi_sync_locked(phy->spi_device, &m);
-		if (ret < 0)
+	if ((phy->rx_buf[3] & 0x01) == 0) {
+		// handle SPI wait states
+		phy->tx_buf[0] = 0;
+
+		for (i = 0; i < TPM_RETRY; i++) {
+			spi_xfer.len = 1;
+			spi_message_init(&m);
+			spi_message_add_tail(&spi_xfer, &m);
+			ret = spi_sync_locked(phy->spi_device, &m);
+			if (ret < 0)
+				goto exit;
+			if (phy->rx_buf[0] & 0x01)
+				break;
+		}
+
+		if (i == TPM_RETRY) {
+			ret = -ETIMEDOUT;
 			goto exit;
-	}
-
-	if (i == TPM_RETRY) {
-		ret = -ETIMEDOUT;
-		goto exit;
+		}
 	}
 
 	spi_xfer.cs_change = 0;
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
