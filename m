From: Alexander Steffen <Alexander.Steffen@infineon.com>
Subject: [PATCH v4] tpm_tis_spi: Use DMA-safe memory for SPI transfers
Date: Mon, 11 Sep 2017 12:26:52 +0200
Message-ID: <20170911102652.15356-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Alexander Steffen <Alexander.Steffen@infineon.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

The buffers used as tx_buf/rx_buf in a SPI transfer need to be DMA-safe.
This cannot be guaranteed for the buffers passed to tpm_tis_spi_read_bytes
and tpm_tis_spi_write_bytes. Therefore, we need to use our own DMA-safe
buffer and copy the data to/from it.

The buffer needs to be allocated separately, to ensure that it is
cacheline-aligned and not shared with other data, so that DMA can work
correctly.

Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
---
v2:
- Updated commit message with more explanations.
v3:
- Split into two patches, one for making the buffers DMA-safe and another
  for using only a single buffer.
v4:
- Back to one patch, to fix conflicts with new const buffers.

 drivers/char/tpm/tpm_tis_spi.c | 45 +++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index e49f5b9..8ab0bd8 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -46,9 +46,7 @@
 struct tpm_tis_spi_phy {
 	struct tpm_tis_data priv;
 	struct spi_device *spi_device;
-
-	u8 tx_buf[4];
-	u8 rx_buf[4];
+	u8 *iobuf;
 };
 
 static inline struct tpm_tis_spi_phy *to_tpm_tis_spi_phy(struct tpm_tis_data *data)
@@ -71,14 +69,14 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
 	while (len) {
 		transfer_len = min_t(u16, len, MAX_SPI_FRAMESIZE);
 
-		phy->tx_buf[0] = (in ? 0x80 : 0) | (transfer_len - 1);
-		phy->tx_buf[1] = 0xd4;
-		phy->tx_buf[2] = addr >> 8;
-		phy->tx_buf[3] = addr;
+		phy->iobuf[0] = (in ? 0x80 : 0) | (transfer_len - 1);
+		phy->iobuf[1] = 0xd4;
+		phy->iobuf[2] = addr >> 8;
+		phy->iobuf[3] = addr;
 
 		memset(&spi_xfer, 0, sizeof(spi_xfer));
-		spi_xfer.tx_buf = phy->tx_buf;
-		spi_xfer.rx_buf = phy->rx_buf;
+		spi_xfer.tx_buf = phy->iobuf;
+		spi_xfer.rx_buf = phy->iobuf;
 		spi_xfer.len = 4;
 		spi_xfer.cs_change = 1;
 
@@ -88,9 +86,9 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
 		if (ret < 0)
 			goto exit;
 
-		if ((phy->rx_buf[3] & 0x01) == 0) {
+		if ((phy->iobuf[3] & 0x01) == 0) {
 			// handle SPI wait states
-			phy->tx_buf[0] = 0;
+			phy->iobuf[0] = 0;
 
 			for (i = 0; i < TPM_RETRY; i++) {
 				spi_xfer.len = 1;
@@ -99,7 +97,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
 				ret = spi_sync_locked(phy->spi_device, &m);
 				if (ret < 0)
 					goto exit;
-				if (phy->rx_buf[0] & 0x01)
+				if (phy->iobuf[0] & 0x01)
 					break;
 			}
 
@@ -112,8 +110,14 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
 		spi_xfer.cs_change = 0;
 		spi_xfer.len = transfer_len;
 		spi_xfer.delay_usecs = 5;
-		spi_xfer.tx_buf = out;
-		spi_xfer.rx_buf = in;
+
+		if (in) {
+			spi_xfer.tx_buf = NULL;
+		} else if (out) {
+			spi_xfer.rx_buf = NULL;
+			memcpy(phy->iobuf, out, transfer_len);
+			out += transfer_len;
+		}
 
 		spi_message_init(&m);
 		spi_message_add_tail(&spi_xfer, &m);
@@ -121,11 +125,12 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
 		if (ret < 0)
 			goto exit;
 
-		len -= transfer_len;
-		if (in)
+		if (in) {
+			memcpy(in, phy->iobuf, transfer_len);
 			in += transfer_len;
-		if (out)
-			out += transfer_len;
+		}
+
+		len -= transfer_len;
 	}
 
 exit:
@@ -191,6 +196,10 @@ static int tpm_tis_spi_probe(struct spi_device *dev)
 
 	phy->spi_device = dev;
 
+	phy->iobuf = devm_kmalloc(&dev->dev, MAX_SPI_FRAMESIZE, GFP_KERNEL);
+	if (!phy->iobuf)
+		return -ENOMEM;
+
 	return tpm_tis_core_init(&dev->dev, &phy->priv, -1, &tpm_spi_phy_ops,
 				 NULL);
 }
-- 
2.7.4

