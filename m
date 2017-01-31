From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix type errors in tpm_tis_spi.c
Date: Tue, 31 Jan 2017 20:24:00 +0200
Message-ID: <20170131182400.15466-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

In these functions u16 or u32 was used as __le16 or __le32:

- tpm_tis_spi_read16
- tpm_tis_spi_read32
- tpm_tis_spi_write32

Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis_spi.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index 5292e57..d3b0b30 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -174,29 +174,32 @@ static int tpm_tis_spi_write_bytes(struct tpm_tis_data *data, u32 addr,
 
 static int tpm_tis_spi_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
 {
+	__le16 tmp;
 	int rc;
 
-	rc = data->phy_ops->read_bytes(data, addr, sizeof(u16), (u8 *)result);
+	rc = data->phy_ops->read_bytes(data, addr, sizeof(u16), (u8 *)&tmp);
 	if (!rc)
-		*result = le16_to_cpu(*result);
+		*result = le16_to_cpu(tmp);
 	return rc;
 }
 
 static int tpm_tis_spi_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
 {
+	__le32 tmp;
 	int rc;
 
-	rc = data->phy_ops->read_bytes(data, addr, sizeof(u32), (u8 *)result);
+	rc = data->phy_ops->read_bytes(data, addr, sizeof(u32), (u8 *)&tmp);
 	if (!rc)
-		*result = le32_to_cpu(*result);
+		*result = le32_to_cpu(tmp);
 	return rc;
 }
 
 static int tpm_tis_spi_write32(struct tpm_tis_data *data, u32 addr, u32 value)
 {
-	value = cpu_to_le32(value);
-	return data->phy_ops->write_bytes(data, addr, sizeof(u32),
-					   (u8 *)&value);
+	__le32 tmp;
+
+	tmp = cpu_to_le32(value);
+	return data->phy_ops->write_bytes(data, addr, sizeof(u32), (u8 *)&tmp);
 }
 
 static const struct tpm_tis_phy_ops tpm_spi_phy_ops = {
-- 
2.9.3

