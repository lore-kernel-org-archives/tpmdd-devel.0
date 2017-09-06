From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH 1/4] tpm: ignore burstcount to improve tpm_tis send() performance.
Date: Wed,  6 Sep 2017 08:56:40 -0400
Message-ID: <20170906125643.5070-6-nayna@linux.vnet.ibm.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The TPM burstcount status indicates the number of bytes that can
be sent to the TPM without causing bus wait states.  Effectively,
it is the number of empty bytes in the command FIFO. Further,
some TPMs have a static burstcount, when the value remains zero
until the entire FIFO is empty.

This patch adds an optimization to check for burstcount only once.
And if it is valid, it writes all the bytes at once, permitting
wait states. The performance of a 34 byte extend on a TPM 1.2 with
an 8 byte burstcount improved from 41 msec to 14 msec.

This functionality is enabled only by passing module
parameter ignore_burst_count=1. By default, this parameter
is disabled.

Suggested-by: Ken Goldman <kgold@linux.vnet.ibm.com> in
conjunction with the TPM Device Driver work group.
Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
 drivers/char/tpm/tpm_tis_core.c                 | 24 +++++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4e303be83df6..3c59bb91e1ee 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1465,6 +1465,14 @@
 			mode generally follows that for the NaN encoding,
 			except where unsupported by hardware.
 
+	ignore_burst_count [TPM_TIS_CORE]
+			tpm_tis_core driver queries for the burstcount before
+			every send call in a loop. However, it causes delay to
+			the send command for TPMs with low burstcount value.
+			Setting this value to 1, will make driver to query for
+			burstcount only once in the loop to improve the
+			performance. By default, its value is set to 0.
+
 	ignore_loglevel	[KNL]
 			Ignore loglevel setting - this will print /all/
 			kernel messages to the console. Useful for debugging.
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 63bc6c3b949e..6b9bf4c4d434 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -31,6 +31,11 @@
 #include "tpm.h"
 #include "tpm_tis_core.h"
 
+static bool ignore_burst_count = false;
+module_param(ignore_burst_count, bool, 0444);
+MODULE_PARM_DESC(ignore_burst_count,
+		"Ignore burstcount value while writing data");
+
 /* Before we attempt to access the TPM we must see that the valid bit is set.
  * The specification says that this bit is 0 at reset and remains 0 until the
  * 'TPM has gone through its self test and initialization and has established
@@ -256,6 +261,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	int rc, status, burstcnt;
+	int sendcnt;
 	size_t count = 0;
 	bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
 
@@ -271,19 +277,31 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	}
 
 	while (count < len - 1) {
+
+		/*
+		 * Get the initial burstcount to ensure TPM is ready to
+		 * accept data, even when waiting for burstcount is disabled.
+		 */
 		burstcnt = get_burstcount(chip);
 		if (burstcnt < 0) {
 			dev_err(&chip->dev, "Unable to read burstcount\n");
 			rc = burstcnt;
 			goto out_err;
 		}
-		burstcnt = min_t(int, burstcnt, len - count - 1);
+
+		if (ignore_burst_count)
+			sendcnt = len - 1;
+		else
+			sendcnt = min_t(int, burstcnt, len - count - 1);
+
 		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
-					 burstcnt, buf + count);
+					 sendcnt, buf + count);
 		if (rc < 0)
 			goto out_err;
 
-		count += burstcnt;
+		count += sendcnt;
+		if (ignore_burst_count)
+			continue;
 
 		if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 					&priv->int_queue, false) < 0) {
-- 
2.13.3
