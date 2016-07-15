From: Andrey Pronin <apronin@chromium.org>
Subject: [PATCH 1/2] tpm_tis_core: add optional max xfer size check
Date: Thu, 14 Jul 2016 18:39:04 -0700
Message-ID: <1468546745-14646-2-git-send-email-apronin@chromium.org>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468546745-14646-1-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Andrey Pronin <apronin@chromium.org>, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

If tpm reports a bigger burstcnt than allowed by the physical protocol,
re-query the burstcnt and correct, if needed, if still too large.

In practice, seen in case of xfer issues (e.g. in spi interface case,
lost header causing flow control issues and wrong values returned on read
from TPM_STS). Without catching, causes the physical layer to reject xfer,
while is easily preventable by re-querying TPM_STS.

Signed-off-by: Andrey Pronin <apronin@chromium.org>
---
 drivers/char/tpm/tpm_tis_core.c | 17 +++++++++++++++--
 drivers/char/tpm/tpm_tis_core.h | 13 +++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 8110b52..f5d456c 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -158,6 +158,7 @@ static int get_burstcount(struct tpm_chip *chip)
 	unsigned long stop;
 	int burstcnt, rc;
 	u32 value;
+	bool retry_burstcnt = false;
 
 	/* wait for burstcount */
 	/* which timeout value, spec has 2 answers (c & d) */
@@ -168,8 +169,20 @@ static int get_burstcount(struct tpm_chip *chip)
 			return rc;
 
 		burstcnt = (value >> 8) & 0xFFFF;
-		if (burstcnt)
-			return burstcnt;
+		if (burstcnt) {
+			/* If burstcnt is larger than max allowed xfer
+			 * size, retry once - may be a glitch. Return
+			 * max_xfer_size on the 2nd try to avoid being
+			 * stuck forever.
+			 */
+			if (tpm_tis_burstcnt_is_valid(priv, burstcnt))
+				return burstcnt;
+			if (retry_burstcnt)
+				return tpm_tis_max_xfer_size(priv);
+			dev_warn(&chip->dev, "Bad burstcnt read: %d\n",
+				 burstcnt);
+			retry_burstcnt = true;
+		}
 		msleep(TPM_TIMEOUT);
 	} while (time_before(jiffies, stop));
 	return -EBUSY;
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 9191aab..713aa5a 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -102,6 +102,7 @@ struct tpm_tis_phy_ops {
 	int (*read16)(struct tpm_tis_data *data, u32 addr, u16 *result);
 	int (*read32)(struct tpm_tis_data *data, u32 addr, u32 *result);
 	int (*write32)(struct tpm_tis_data *data, u32 addr, u32 src);
+	u16 max_xfer_size;
 };
 
 static inline int tpm_tis_read_bytes(struct tpm_tis_data *data, u32 addr,
@@ -144,6 +145,18 @@ static inline int tpm_tis_write32(struct tpm_tis_data *data, u32 addr,
 	return data->phy_ops->write32(data, addr, value);
 }
 
+static inline u16 tpm_tis_max_xfer_size(struct tpm_tis_data *data)
+{
+	return data->phy_ops->max_xfer_size;
+}
+
+static inline bool tpm_tis_burstcnt_is_valid(struct tpm_tis_data *data,
+					     u16 burstcnt)
+{
+	return (tpm_tis_max_xfer_size(data) == 0)
+		|| (burstcnt <= tpm_tis_max_xfer_size(data));
+}
+
 void tpm_tis_remove(struct tpm_chip *chip);
 int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		      const struct tpm_tis_phy_ops *phy_ops,
-- 
2.6.6
