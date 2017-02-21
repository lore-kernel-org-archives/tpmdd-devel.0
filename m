From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 1/2] tpm: Apply an adapterlimit for retransmission.
Date: Tue, 21 Feb 2017 15:44:59 +0100
Message-ID: <20170221144500.502-1-enric.balletbo@collabora.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: apronin@google.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Bryan Freed <bfreed@chromium.org>

When the I2C Infineon part is attached to an I2C adapter that imposes
a size limitation, large requests will fail -EINVAL.
Retry them with size backoff without re-issuing the 0x05 command
as this appears to occasionally put the TPM in a bad state.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 drivers/char/tpm/tpm_i2c_infineon.c | 44 ++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 62ee44e..f04c6b7 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -111,35 +111,24 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 
 	int rc = 0;
 	int count;
+	int adapterlimit = len;
 
 	/* Lock the adapter for the duration of the whole sequence. */
 	if (!tpm_dev.client->adapter->algo->master_xfer)
 		return -EOPNOTSUPP;
 	i2c_lock_adapter(tpm_dev.client->adapter);
 
-	if (tpm_dev.chip_type == SLB9645) {
-		/* use a combined read for newer chips
-		 * unfortunately the smbus functions are not suitable due to
-		 * the 32 byte limit of the smbus.
-		 * retries should usually not be needed, but are kept just to
-		 * be on the safe side.
-		 */
-		for (count = 0; count < MAX_COUNT; count++) {
-			rc = __i2c_transfer(tpm_dev.client->adapter, msgs, 2);
-			if (rc > 0)
-				break;	/* break here to skip sleep */
-			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
-		}
-	} else {
+	/* Expect to send one command message and one data message, but
+	 * support looping over each or both if necessary.
+	 */
+	while (len > 0) {
 		/* slb9635 protocol should work in all cases */
 		for (count = 0; count < MAX_COUNT; count++) {
 			rc = __i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
 			if (rc > 0)
-				break;	/* break here to skip sleep */
-
+				break;
 			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
 		}
-
 		if (rc <= 0)
 			goto out;
 
@@ -149,10 +138,29 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 		 */
 		for (count = 0; count < MAX_COUNT; count++) {
 			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
+			msg2.len = min(adapterlimit, len);
 			rc = __i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
-			if (rc > 0)
+			if (rc > 0) {
+				/* Since len is unsigned, make doubly sure we
+				 * do not underflow it.
+				 */
+				if (msg2.len > len)
+					len = 0;
+				else
+					len -= msg2.len;
+				msg2.buf += msg2.len;
 				break;
+			}
+			/* If the I2C adapter rejected the request,
+			 * try a smaller chunk.
+			 */
+			if (rc == -EINVAL) {
+				adapterlimit = (adapterlimit + 1) / 2;
+				adapterlimit = max(adapterlimit, 32);
+			}
 		}
+		if (rc <= 0)
+			goto out;
 	}
 
 out:
-- 
2.9.3
