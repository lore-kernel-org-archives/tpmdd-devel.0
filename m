From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 04/12] tpm/st33zp24/spi: Remove field
	spi_xfer from st33zp24_spi_phy structure
Date: Sat, 13 Feb 2016 16:15:27 +0100
Message-ID: <1455376535-9549-5-git-send-email-christophe-h.ricard@st.com>
References: <1455376535-9549-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455376535-9549-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Remove spi_xfer from st33zp24_spi_phy structure and declare local spi_xfer
when needed instead.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/spi.c | 50 ++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index 08ffbfe..41c11c9 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -66,7 +66,7 @@
 
 struct st33zp24_spi_phy {
 	struct spi_device *spi_device;
-	struct spi_transfer spi_xfer;
+
 	u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE];
 	u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE];
 
@@ -113,28 +113,30 @@ static int st33zp24_spi_send(void *phy_id, u8 tpm_register, u8 *tpm_data,
 	int total_length = 0, ret = 0;
 	struct st33zp24_spi_phy *phy = phy_id;
 	struct spi_device *dev = phy->spi_device;
-	u8 *tx_buf = (u8 *)phy->spi_xfer.tx_buf;
-	u8 *rx_buf = phy->spi_xfer.rx_buf;
+	struct spi_transfer spi_xfer = {
+		.tx_buf = phy->tx_buf,
+		.rx_buf = phy->rx_buf,
+	};
 
 	/* Pre-Header */
-	tx_buf[total_length++] = TPM_WRITE_DIRECTION | LOCALITY0;
-	tx_buf[total_length++] = tpm_register;
+	phy->tx_buf[total_length++] = TPM_WRITE_DIRECTION | LOCALITY0;
+	phy->tx_buf[total_length++] = tpm_register;
 
 	if (tpm_size > 0 && tpm_register == TPM_DATA_FIFO) {
-		tx_buf[total_length++] = tpm_size >> 8;
-		tx_buf[total_length++] = tpm_size;
+		phy->tx_buf[total_length++] = tpm_size >> 8;
+		phy->tx_buf[total_length++] = tpm_size;
 	}
 
-	memcpy(&tx_buf[total_length], tpm_data, tpm_size);
+	memcpy(&phy->tx_buf[total_length], tpm_data, tpm_size);
 	total_length += tpm_size;
 
-	memset(&tx_buf[total_length], TPM_DUMMY_BYTE, phy->latency);
+	memset(&phy->tx_buf[total_length], TPM_DUMMY_BYTE, phy->latency);
 
-	phy->spi_xfer.len = total_length + phy->latency;
+	spi_xfer.len = total_length + phy->latency;
 
-	ret = spi_sync_transfer(dev, &phy->spi_xfer, 1);
+	ret = spi_sync_transfer(dev, &spi_xfer, 1);
 	if (ret == 0)
-		ret = rx_buf[total_length + phy->latency - 1];
+		ret = phy->rx_buf[total_length + phy->latency - 1];
 
 	return st33zp24_status_to_errno(ret);
 } /* st33zp24_spi_send() */
@@ -154,24 +156,25 @@ static int st33zp24_spi_read8_reg(void *phy_id, u8 tpm_register, u8 *tpm_data,
 	int total_length = 0, ret;
 	struct st33zp24_spi_phy *phy = phy_id;
 	struct spi_device *dev = phy->spi_device;
-	u8 *tx_buf = (u8 *)phy->spi_xfer.tx_buf;
-	u8 *rx_buf = phy->spi_xfer.rx_buf;
+	struct spi_transfer spi_xfer = {
+		.tx_buf = phy->tx_buf,
+		.rx_buf = phy->rx_buf,
+	};
 
 	/* Pre-Header */
-	tx_buf[total_length++] = LOCALITY0;
-	tx_buf[total_length++] = tpm_register;
+	phy->tx_buf[total_length++] = LOCALITY0;
+	phy->tx_buf[total_length++] = tpm_register;
 
-	memset(&tx_buf[total_length], TPM_DUMMY_BYTE,
-	       phy->latency + tpm_size);
+	memset(&phy->tx_buf[total_length], TPM_DUMMY_BYTE, phy->latency + tpm_size);
 
-	phy->spi_xfer.len = total_length + phy->latency + tpm_size;
+	spi_xfer.len = total_length + phy->latency + tpm_size;
 
 	/* header + status byte + size of the data + status byte */
-	ret = spi_sync_transfer(dev, &phy->spi_xfer, 1);
+	ret = spi_sync_transfer(dev, &spi_xfer, 1);
 	if (tpm_size > 0 && ret == 0) {
-		ret = rx_buf[total_length + phy->latency - 1];
+		ret = phy->rx_buf[total_length + phy->latency - 1];
 
-		memcpy(tpm_data, rx_buf + total_length + phy->latency,
+		memcpy(tpm_data, phy->rx_buf + total_length + phy->latency,
 		       tpm_size);
 	}
 
@@ -328,9 +331,6 @@ static int st33zp24_spi_probe(struct spi_device *dev)
 			return ret;
 	}
 
-	phy->spi_xfer.tx_buf = phy->tx_buf;
-	phy->spi_xfer.rx_buf = phy->rx_buf;
-
 	phy->latency = st33zp24_spi_evaluate_latency(phy);
 	if (phy->latency <= 0)
 		return -ENODEV;
-- 
2.5.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
