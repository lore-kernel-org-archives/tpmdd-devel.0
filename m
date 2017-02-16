From: Peter Huewe <peter.huewe@infineon.com>
Subject: [PATCH] tpm_tis_core: Choose appropriate timeout for reading burstcount
Date: Thu, 16 Feb 2017 15:33:36 +0000
Message-ID: <1487259216-28955-1-git-send-email-peter.huewe@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, Alexander Steffen <Alexander.Steffen@infineon.com>, stable@vger.kernel.org, Peter Huewe <peter.huewe@infineon.com>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Alexander Steffen <Alexander.Steffen@infineon.com>

TIS v1.3 for TPM 1.2 and PTP for TPM 2.0 disagree about which timeout
value applies to reading a valid burstcount. It is TIMEOUT_D according to
TIS, but TIMEOUT_A according to PTP, so choose the appropriate value
depending on whether we deal with a TPM 1.2 or a TPM 2.0.

This is important since according to the PTP TIMEOUT_D is much smaller
than TIMEOUT_A. So the previous implementation could run into timeouts
with a TPM 2.0, even though the TPM was behaving perfectly fine.

During tpm2_probe TIMEOUT_D will be used even with a TPM 2.0, because
TPM_CHIP_FLAG_TPM2 is not yet set. This is fine, since the timeout values
will only be changed afterwards by tpm_get_timeouts. Until then
TIS_TIMEOUT_D_MAX applies, which is large enough.

Cc: stable@vger.kernel.org
Fixes: aec04cbdf723 ("tpm: TPM 2.0 FIFO Interface")

Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
---
 drivers/char/tpm/tpm_tis_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index c0f296b5d413..fc0e9a2734ed 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -160,8 +160,10 @@ static int get_burstcount(struct tpm_chip *chip)
 	u32 value;
 
 	/* wait for burstcount */
-	/* which timeout value, spec has 2 answers (c & d) */
-	stop = jiffies + chip->timeout_d;
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		stop = jiffies + chip->timeout_a;
+	else
+		stop = jiffies + chip->timeout_d;
 	do {
 		rc = tpm_tis_read32(priv, TPM_STS(priv->locality), &value);
 		if (rc < 0)
-- 
2.7.4
