From: apronin@chromium.org
Subject: [PATCH] tpm: read burstcount from TPM_STS in one 32-bit transaction
Date: Wed, 29 Jun 2016 20:49:04 -0700
Message-ID: <1467258544-117297-1-git-send-email-apronin@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christophe Ricard <christophe.ricard@gmail.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Andrey Pronin <apronin@chromium.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Andrey Pronin <apronin@chromium.org>

Some chips incorrectly support partial reads from TPM_STS register
at non-zero offsets. Read the entire 32-bits register instead of
making two 8-bit reads to support such devices and reduce the number
of bus transactions when obtaining the burstcount from TPM_STS.

Signed-off-by: Andrey Pronin <apronin@chromium.org>
---
 drivers/char/tpm/tpm_tis_core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 03a06b3..8110b52 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -157,22 +157,17 @@ static int get_burstcount(struct tpm_chip *chip)
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	unsigned long stop;
 	int burstcnt, rc;
-	u8 value;
+	u32 value;
 
 	/* wait for burstcount */
 	/* which timeout value, spec has 2 answers (c & d) */
 	stop = jiffies + chip->timeout_d;
 	do {
-		rc = tpm_tis_read8(priv, TPM_STS(priv->locality) + 1, &value);
+		rc = tpm_tis_read32(priv, TPM_STS(priv->locality), &value);
 		if (rc < 0)
 			return rc;
 
-		burstcnt = value;
-		rc = tpm_tis_read8(priv, TPM_STS(priv->locality) + 2, &value);
-		if (rc < 0)
-			return rc;
-
-		burstcnt += value << 8;
+		burstcnt = (value >> 8) & 0xFFFF;
 		if (burstcnt)
 			return burstcnt;
 		msleep(TPM_TIMEOUT);
-- 
2.6.6
