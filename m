From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] char/tpm: Check return code of wait_for_tpm_stat
Date: Tue, 11 Oct 2016 15:01:01 +0300
Message-ID: <1476187261-29027-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Peter Huewe <peterhuewe@gmx.de>

In some weird cases it might be possible that the TPM does not set
STS.VALID within the given timeout time (or ever) but sets STS.EXPECT
(STS=0x0C) In this case the driver gets stuck in the while loop of
tpm_tis_send_data and loops endlessly.

Checking the return value of wait_for_tpm_stat fixes this and the driver
bails out correctly.  While at it fixing all other users since if the
TPM does not manage to set STS.VALID within the reasonable timeframe
something is definitely wrong and the driver should react correctly.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis_core.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index e3bf31b..73f4c4b 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -180,11 +180,13 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	int size = 0, burstcnt, rc;
 
-	while (size < count &&
-	       wait_for_tpm_stat(chip,
+	while (size < count) {
+		rc = wait_for_tpm_stat(chip,
 				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 				 chip->timeout_c,
-				 &priv->read_queue, true) == 0) {
+				 &priv->read_queue, true);
+		if (rc < 0)
+			return rc;
 		burstcnt = min_t(int, get_burstcount(chip), count - size);
 
 		rc = tpm_tis_read_bytes(priv, TPM_DATA_FIFO(priv->locality),
@@ -229,8 +231,11 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		goto out;
 	}
 
-	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
-			  &priv->int_queue, false);
+	if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
+				&priv->int_queue, false) < 0) {
+		size = -ETIME;
+		goto out;
+	}
 	status = tpm_tis_status(chip);
 	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
 		dev_err(&chip->dev, "Error left over data\n");
@@ -279,8 +284,11 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 
 		count += burstcnt;
 
-		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
-				  &priv->int_queue, false);
+		if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
+					&priv->int_queue, false) < 0) {
+			rc = -ETIME;
+			goto out_err;
+		}
 		status = tpm_tis_status(chip);
 		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
@@ -293,8 +301,11 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	if (rc < 0)
 		goto out_err;
 
-	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
-			  &priv->int_queue, false);
+	if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
+				&priv->int_queue, false) < 0) {
+		rc = -ETIME;
+		goto out_err;
+	}
 	status = tpm_tis_status(chip);
 	if (!itpm && (status & TPM_STS_DATA_EXPECT) != 0) {
 		rc = -EIO;
-- 
2.7.4
