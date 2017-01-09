From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm_tis: Check return values from get_burstcount.
Date: Mon,  9 Jan 2017 23:46:58 +0200
Message-ID: <20170109214658.8474-1-jarkko.sakkinen@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Josh Zimmerman <joshz@google.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Josh Zimmerman <joshz@google.com>

If the TPM we're connecting to uses a static burst count, it will report
a burst count of zero throughout the response read. However, get_burstcount
assumes that a response of zero indicates that the TPM is not ready to
receive more data. In this case, it returns a negative error code, which
is passed on to tpm_tis_{write,read}_bytes as a u16, causing
them to read/write far too many bytes.

This patch checks for negative return codes and bails out from recv_data
and tpm_tis_send_data.

Cc: stable@vger.kernel.org
Fixes: 1107d065fdf1 (tpm_tis: Introduce intermediate layer for TPM access)
Signed-off-by: Josh Zimmerman <joshz@google.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
Backport for 4.8 and 4.9
Original commit ID: 26a137e31ffe6fbfdb008554a8d9b3d55bd5c86e
 drivers/char/tpm/tpm_tis_core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index d66f51b..5e71d6d 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -185,7 +185,12 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 				 chip->timeout_c,
 				 &priv->read_queue, true) == 0) {
-		burstcnt = min_t(int, get_burstcount(chip), count - size);
+		burstcnt = get_burstcount(chip);
+		if (burstcnt < 0) {
+			dev_err(&chip->dev, "Unable to read burstcount\n");
+			return burstcnt;
+		}
+		burstcnt = min_t(int, burstcnt, count - size);
 
 		rc = tpm_tis_read_bytes(priv, TPM_DATA_FIFO(priv->locality),
 					burstcnt, buf + size);
@@ -271,7 +276,13 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	}
 
 	while (count < len - 1) {
-		burstcnt = min_t(int, get_burstcount(chip), len - count - 1);
+		burstcnt = get_burstcount(chip);
+		if (burstcnt < 0) {
+			dev_err(&chip->dev, "Unable to read burstcount\n");
+			rc = burstcnt;
+			goto out_err;
+		}
+		burstcnt = min_t(int, burstcnt, len - count - 1);
 		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
 					 burstcnt, buf + count);
 		if (rc < 0)
-- 
2.9.3
