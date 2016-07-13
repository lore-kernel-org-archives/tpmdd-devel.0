From: Ed Swierk <eswierk@skyportsystems.com>
Subject: [PATCH v9 2/5] tpm: Add optional logging of TPM command durations
Date: Wed, 13 Jul 2016 09:19:33 -0700
Message-ID: <1468426776-42762-3-git-send-email-eswierk@skyportsystems.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
 <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, stefanb@us.ibm.com, eswierk@skyportsystems.com
List-Id: tpmdd-devel@lists.sourceforge.net

Some TPMs violate their own advertised command durations. This is much
easier to debug with data about how long each command actually takes
to complete. Add debug messages that can be enabled by running

  echo -n 'module tpm +p' >/sys/kernel/debug/dynamic_debug/control

on a kernel configured with DYNAMIC_DEBUG=y.

Signed-off-by: Ed Swierk <eswierk@skyportsystems.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 5e3c1b6..a4beb53 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -335,13 +335,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 {
 	ssize_t rc;
 	u32 count, ordinal;
-	unsigned long stop;
+	unsigned long start, stop;
 
 	if (bufsiz > TPM_BUFSIZE)
 		bufsiz = TPM_BUFSIZE;
 
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+	dev_dbg(&chip->dev, "starting command %d count %d\n", ordinal, count);
 	if (count == 0)
 		return -ENODATA;
 	if (count > bufsiz) {
@@ -362,18 +363,23 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	if (chip->flags & TPM_CHIP_FLAG_IRQ)
 		goto out_recv;
 
+	start = jiffies;
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		stop = jiffies + tpm2_calc_ordinal_duration(chip, ordinal);
+		stop = start + tpm2_calc_ordinal_duration(chip, ordinal);
 	else
-		stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
+		stop = start + tpm_calc_ordinal_duration(chip, ordinal);
 	do {
 		u8 status = chip->ops->status(chip);
 		if ((status & chip->ops->req_complete_mask) ==
-		    chip->ops->req_complete_val)
+		    chip->ops->req_complete_val) {
+			dev_dbg(&chip->dev, "completed command %d in %d ms\n",
+				ordinal, jiffies_to_msecs(jiffies - start));
 			goto out_recv;
+		}
 
 		if (chip->ops->req_canceled(chip, status)) {
-			dev_err(&chip->dev, "Operation Canceled\n");
+			dev_err(&chip->dev, "canceled command %d after %d ms\n",
+				ordinal, jiffies_to_msecs(jiffies - start));
 			rc = -ECANCELED;
 			goto out;
 		}
@@ -383,7 +389,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	} while (time_before(jiffies, stop));
 
 	chip->ops->cancel(chip);
-	dev_err(&chip->dev, "Operation Timed out\n");
+	dev_err(&chip->dev, "command %d timed out after %d ms\n", ordinal,
+		jiffies_to_msecs(jiffies - start));
 	rc = -ETIME;
 	goto out;
 
-- 
1.9.1
