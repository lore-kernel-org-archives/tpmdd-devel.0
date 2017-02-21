From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 2/2] tpm: Do not assume an i2c adapter preserves the msg len
Date: Tue, 21 Feb 2017 15:45:00 +0100
Message-ID: <20170221144500.502-2-enric.balletbo@collabora.com>
References: <20170221144500.502-1-enric.balletbo@collabora.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170221144500.502-1-enric.balletbo@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: apronin@google.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Bryan Freed <bfreed@chromium.org>

Prevent a possible infinite loop by using a local variable to
advance len down to 0.  This is safer than trusting the I2C and
adapter drivers to preserve msg2.len.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 drivers/char/tpm/tpm_i2c_infineon.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index f04c6b7..fbee05b 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -107,11 +107,10 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 		.len = len,
 		.buf = buffer
 	};
-	struct i2c_msg msgs[] = {msg1, msg2};
 
 	int rc = 0;
 	int count;
-	int adapterlimit = len;
+	unsigned int adapterlimit = len;
 
 	/* Lock the adapter for the duration of the whole sequence. */
 	if (!tpm_dev.client->adapter->algo->master_xfer)
@@ -137,18 +136,19 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 		 * retrieving the data
 		 */
 		for (count = 0; count < MAX_COUNT; count++) {
+			unsigned int msglen = msg2.len =
+					min_t(unsigned int, adapterlimit, len);
 			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
-			msg2.len = min(adapterlimit, len);
 			rc = __i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
 			if (rc > 0) {
 				/* Since len is unsigned, make doubly sure we
 				 * do not underflow it.
 				 */
-				if (msg2.len > len)
+				if (msglen > len)
 					len = 0;
 				else
-					len -= msg2.len;
-				msg2.buf += msg2.len;
+					len -= msglen;
+				msg2.buf += msglen;
 				break;
 			}
 			/* If the I2C adapter rejected the request,
@@ -156,7 +156,7 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 			 */
 			if (rc == -EINVAL) {
 				adapterlimit = (adapterlimit + 1) / 2;
-				adapterlimit = max(adapterlimit, 32);
+				adapterlimit = max(adapterlimit, 32U);
 			}
 		}
 		if (rc <= 0)
-- 
2.9.3
