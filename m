From: Peter Huewe <peter.huewe@infineon.com>
Subject: [PATCH 4/5] tpm_tis_spi: Remove limitation of transfers to MAX_SPI_FRAMESIZE bytes
Date: Thu, 16 Feb 2017 16:08:25 +0000
Message-ID: <1487261306-2494-5-git-send-email-peter.huewe@infineon.com>
References: <1487261306-2494-1-git-send-email-peter.huewe@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1487261306-2494-1-git-send-email-peter.huewe@infineon.com>
Sender: stable-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, Christophe Ricard <christophe-h.ricard@st.com>, Peter Huewe <peter.huewe@infineon.com>, stable@vger.kernel.org, Alexander Steffen <Alexander.Steffen@infineon.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Limiting transfers to MAX_SPI_FRAMESIZE was not expected by the upper
layers, as tpm_tis has no such limitation. Add a loop to hide that
limitation.

Cc: <stable@vger.kernel.org>
Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
---
 drivers/char/tpm/tpm_tis_spi.c | 108 ++++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 51 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index 16938e2253d2..b50c5b072df3 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -61,68 +61,74 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u8 len,
 {
 	struct tpm_tis_spi_phy *phy = to_tpm_tis_spi_phy(data);
 	int ret;
-	struct spi_message m;
-	struct spi_transfer spi_xfer = {
-		.tx_buf = phy->tx_buf,
-		.rx_buf = phy->rx_buf,
-		.len = 4,
-		.cs_change = 1,
-	};
-
-	if (len > MAX_SPI_FRAMESIZE)
-		return -ENOMEM;
 
-	phy->tx_buf[0] = direction | (len - 1);
-	phy->tx_buf[1] = 0xd4;
-	phy->tx_buf[2] = addr >> 8;
-	phy->tx_buf[3] = addr;
+	spi_bus_lock(phy->spi_device->master);
 
-	spi_message_init(&m);
-	spi_message_add_tail(&spi_xfer, &m);
+	while (len) {
+		struct spi_message m;
+		struct spi_transfer spi_xfer = {
+			.tx_buf = phy->tx_buf,
+			.rx_buf = phy->rx_buf,
+			.len = 4,
+			.cs_change = 1,
+		};
+		u8 transfer_len = min_t(u16, len, MAX_SPI_FRAMESIZE);
+
+		phy->tx_buf[0] = direction | (transfer_len - 1);
+		phy->tx_buf[1] = 0xd4;
+		phy->tx_buf[2] = addr >> 8;
+		phy->tx_buf[3] = addr;
+
+		spi_message_init(&m);
+		spi_message_add_tail(&spi_xfer, &m);
+		ret = spi_sync_locked(phy->spi_device, &m);
+		if (ret < 0)
+			goto exit;
 
-	spi_bus_lock(phy->spi_device->master);
-	ret = spi_sync_locked(phy->spi_device, &m);
-	if (ret < 0)
-		goto exit;
-
-	if ((phy->rx_buf[3] & 0x01) == 0) {
-		// handle SPI wait states
-		int i;
-
-		phy->tx_buf[0] = 0;
-
-		for (i = 0; i < TPM_RETRY; i++) {
-			spi_xfer.len = 1;
-			spi_message_init(&m);
-			spi_message_add_tail(&spi_xfer, &m);
-			ret = spi_sync_locked(phy->spi_device, &m);
-			if (ret < 0)
+		if ((phy->rx_buf[3] & 0x01) == 0) {
+			// handle SPI wait states
+			int i;
+
+			phy->tx_buf[0] = 0;
+
+			for (i = 0; i < TPM_RETRY; i++) {
+				spi_xfer.len = 1;
+				spi_message_init(&m);
+				spi_message_add_tail(&spi_xfer, &m);
+				ret = spi_sync_locked(phy->spi_device, &m);
+				if (ret < 0)
+					goto exit;
+				if (phy->rx_buf[0] & 0x01)
+					break;
+			}
+
+			if (i == TPM_RETRY) {
+				ret = -ETIMEDOUT;
 				goto exit;
-			if (phy->rx_buf[0] & 0x01)
-				break;
+			}
 		}
 
-		if (i == TPM_RETRY) {
-			ret = -ETIMEDOUT;
-			goto exit;
+		spi_xfer.cs_change = 0;
+		spi_xfer.len = transfer_len;
+
+		if (direction) {
+			spi_xfer.tx_buf = NULL;
+			spi_xfer.rx_buf = buffer;
+		} else {
+			spi_xfer.tx_buf = buffer;
+			spi_xfer.rx_buf = NULL;
 		}
-	}
 
-	spi_xfer.cs_change = 0;
-	spi_xfer.len = len;
+		spi_message_init(&m);
+		spi_message_add_tail(&spi_xfer, &m);
+		ret = spi_sync_locked(phy->spi_device, &m);
+		if (ret < 0)
+			goto exit;
 
-	if (direction) {
-		spi_xfer.tx_buf = NULL;
-		spi_xfer.rx_buf = buffer;
-	} else {
-		spi_xfer.tx_buf = buffer;
-		spi_xfer.rx_buf = NULL;
+		len -= transfer_len;
+		buffer += transfer_len;
 	}
 
-	spi_message_init(&m);
-	spi_message_add_tail(&spi_xfer, &m);
-	ret = spi_sync_locked(phy->spi_device, &m);
-
 exit:
 	spi_bus_unlock(phy->spi_device->master);
 	return ret;
-- 
2.7.4
