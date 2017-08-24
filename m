From: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 1/2] tpm_tis_spi: Use DMA-safe memory for
 SPI transfers
Date: Thu, 24 Aug 2017 10:27:44 +0200
Message-ID: <20170824082745.9372-2-Alexander.Steffen@infineon.com>
References: <20170824082745.9372-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170824082745.9372-1-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The buffers used as tx_buf/rx_buf in a SPI transfer need to be DMA-safe.
This cannot be guaranteed for the buffers passed to tpm_tis_spi_read_bytes
and tpm_tis_spi_write_bytes. Therefore, we need to use our own DMA-safe
buffer and copy the data to/from it.

The buffer needs to be allocated separately, to ensure that it is
cacheline-aligned and not shared with other data, so that DMA can work
correctly.

Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index 88fe72a..05ce841 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -47,8 +47,8 @@ struct tpm_tis_spi_phy {
 	struct tpm_tis_data priv;
 	struct spi_device *spi_device;
 
-	u8 tx_buf[4];
-	u8 rx_buf[4];
+	u8 *tx_buf;
+	u8 *rx_buf;
 };
 
 static inline struct tpm_tis_spi_phy *to_tpm_tis_spi_phy(struct tpm_tis_data *data)
@@ -115,10 +115,9 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
 
 		if (direction) {
 			spi_xfer.tx_buf = NULL;
-			spi_xfer.rx_buf = buffer;
 		} else {
-			spi_xfer.tx_buf = buffer;
 			spi_xfer.rx_buf = NULL;
+			memcpy(phy->tx_buf, buffer, transfer_len);
 		}
 
 		spi_message_init(&m);
@@ -127,6 +126,9 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
 		if (ret < 0)
 			goto exit;
 
+		if (direction)
+			memcpy(buffer, phy->rx_buf, transfer_len);
+
 		len -= transfer_len;
 		buffer += transfer_len;
 	}
@@ -194,6 +196,14 @@ static int tpm_tis_spi_probe(struct spi_device *dev)
 
 	phy->spi_device = dev;
 
+	phy->tx_buf = devm_kmalloc(&dev->dev, MAX_SPI_FRAMESIZE, GFP_KERNEL);
+	if (!phy->tx_buf)
+		return -ENOMEM;
+
+	phy->rx_buf = devm_kmalloc(&dev->dev, MAX_SPI_FRAMESIZE, GFP_KERNEL);
+	if (!phy->rx_buf)
+		return -ENOMEM;
+
 	return tpm_tis_core_init(&dev->dev, &phy->priv, -1, &tpm_spi_phy_ops,
 				 NULL);
 }
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
