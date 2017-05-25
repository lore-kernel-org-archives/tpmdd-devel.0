From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v3] tpm: vtpm_proxy: Suppress error logging when in closed state
Date: Thu, 25 May 2017 18:29:13 -0400
Message-ID: <1495751353-28500-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Suppress the error logging when the core TPM driver sends commands
to the VTPM proxy driver and -EPIPE is returned in case the VTPM
proxy driver is 'closed' (closed anonymous file descriptor).  This
error code is only returned by the send function and by tpm_transmit
when the VTPM proxy driver is being used.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm-interface.c | 5 +++--
 drivers/char/tpm/tpm2-cmd.c      | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d711186..d2b4df6 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -430,8 +430,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
-		dev_err(&chip->dev,
-			"tpm_transmit: tpm_send: error %d\n", rc);
+		if (rc != -EPIPE)
+			dev_err(&chip->dev,
+				"%s: tpm_send: error %d\n", __func__, rc);
 		goto out;
 	}
 
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 3ee6883..3a99643 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -840,7 +840,7 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
 	/* In places where shutdown command is sent there's no much we can do
 	 * except print the error code on a system failure.
 	 */
-	if (rc < 0)
+	if (rc < 0 && rc != -EPIPE)
 		dev_warn(&chip->dev, "transmit returned %d while stopping the TPM",
 			 rc);
 }
-- 
2.4.3

