From: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 1/5] tpm_tis_spi: Use single function to
	transfer data
Date: Thu, 2 Mar 2017 13:03:11 +0000
Message-ID: <1488459879-24349-2-git-send-email-peter.huewe@infineon.com>
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

The algorithm for sending data to the TPM is mostly identical to the
algorithm for receiving data from the TPM, so a single function is
sufficient to handle both cases.

This is a prequisite for all the other fixes, so we don't have to fix
everything twice (send/receive)

v2: u16 instead of u8 for the length.
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Tested-by: Benoit Houyere <benoit.houyere-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 87 ++++++++++++------------------------------
 1 file changed, 24 insertions(+), 63 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index 5292e5768a7e..062799e04f04 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -47,8 +47,8 @@ struct tpm_tis_spi_phy {
 	struct tpm_tis_data priv;
 	struct spi_device *spi_device;
 
-	u8 tx_buf[MAX_SPI_FRAMESIZE + 4];
-	u8 rx_buf[MAX_SPI_FRAMESIZE + 4];
+	u8 tx_buf[4];
+	u8 rx_buf[4];
 };
 
 static inline struct tpm_tis_spi_phy *to_tpm_tis_spi_phy(struct tpm_tis_data *data)
@@ -56,8 +56,8 @@ static inline struct tpm_tis_spi_phy *to_tpm_tis_spi_phy(struct tpm_tis_data *da
 	return container_of(data, struct tpm_tis_spi_phy, priv);
 }
 
-static int tpm_tis_spi_read_bytes(struct tpm_tis_data *data, u32 addr,
-				  u16 len, u8 *result)
+static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u16 len,
+				u8 *buffer, u8 direction)
 {
 	struct tpm_tis_spi_phy *phy = to_tpm_tis_spi_phy(data);
 	int ret, i;
@@ -66,17 +66,17 @@ static int tpm_tis_spi_read_bytes(struct tpm_tis_data *data, u32 addr,
 		.tx_buf = phy->tx_buf,
 		.rx_buf = phy->rx_buf,
 		.len = 4,
+		.cs_change = 1,
 	};
 
 	if (len > MAX_SPI_FRAMESIZE)
 		return -ENOMEM;
 
-	phy->tx_buf[0] = 0x80 | (len - 1);
+	phy->tx_buf[0] = direction | (len - 1);
 	phy->tx_buf[1] = 0xd4;
-	phy->tx_buf[2] = (addr >> 8)  & 0xFF;
-	phy->tx_buf[3] = addr	      & 0xFF;
+	phy->tx_buf[2] = addr >> 8;
+	phy->tx_buf[3] = addr;
 
-	spi_xfer.cs_change = 1;
 	spi_message_init(&m);
 	spi_message_add_tail(&spi_xfer, &m);
 
@@ -85,7 +85,7 @@ static int tpm_tis_spi_read_bytes(struct tpm_tis_data *data, u32 addr,
 	if (ret < 0)
 		goto exit;
 
-	memset(phy->tx_buf, 0, len);
+	phy->tx_buf[0] = 0;
 
 	/* According to TCG PTP specification, if there is no TPM present at
 	 * all, then the design has a weak pull-up on MISO. If a TPM is not
@@ -103,7 +103,14 @@ static int tpm_tis_spi_read_bytes(struct tpm_tis_data *data, u32 addr,
 
 	spi_xfer.cs_change = 0;
 	spi_xfer.len = len;
-	spi_xfer.rx_buf = result;
+
+	if (direction) {
+		spi_xfer.tx_buf = NULL;
+		spi_xfer.rx_buf = buffer;
+	} else {
+		spi_xfer.tx_buf = buffer;
+		spi_xfer.rx_buf = NULL;
+	}
 
 	spi_message_init(&m);
 	spi_message_add_tail(&spi_xfer, &m);
@@ -114,62 +121,16 @@ static int tpm_tis_spi_read_bytes(struct tpm_tis_data *data, u32 addr,
 	return ret;
 }
 
+static int tpm_tis_spi_read_bytes(struct tpm_tis_data *data, u32 addr,
+				  u16 len, u8 *result)
+{
+	return tpm_tis_spi_transfer(data, addr, len, result, 0x80);
+}
+
 static int tpm_tis_spi_write_bytes(struct tpm_tis_data *data, u32 addr,
 				   u16 len, u8 *value)
 {
-	struct tpm_tis_spi_phy *phy = to_tpm_tis_spi_phy(data);
-	int ret, i;
-	struct spi_message m;
-	struct spi_transfer spi_xfer = {
-		.tx_buf = phy->tx_buf,
-		.rx_buf = phy->rx_buf,
-		.len = 4,
-	};
-
-	if (len > MAX_SPI_FRAMESIZE)
-		return -ENOMEM;
-
-	phy->tx_buf[0] = len - 1;
-	phy->tx_buf[1] = 0xd4;
-	phy->tx_buf[2] = (addr >> 8)  & 0xFF;
-	phy->tx_buf[3] = addr         & 0xFF;
-
-	spi_xfer.cs_change = 1;
-	spi_message_init(&m);
-	spi_message_add_tail(&spi_xfer, &m);
-
-	spi_bus_lock(phy->spi_device->master);
-	ret = spi_sync_locked(phy->spi_device, &m);
-	if (ret < 0)
-		goto exit;
-
-	memset(phy->tx_buf, 0, len);
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
-			goto exit;
-	}
-
-	spi_xfer.len = len;
-	spi_xfer.tx_buf = value;
-	spi_xfer.cs_change = 0;
-	spi_xfer.tx_buf = value;
-	spi_message_init(&m);
-	spi_message_add_tail(&spi_xfer, &m);
-	ret = spi_sync_locked(phy->spi_device, &m);
-
-exit:
-	spi_bus_unlock(phy->spi_device->master);
-	return ret;
+	return tpm_tis_spi_transfer(data, addr, len, value, 0);
 }
 
 static int tpm_tis_spi_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
