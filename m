From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v2] tpm: vtpm_proxy: Suppresse error logging when in closed state
Date: Thu, 25 May 2017 17:39:20 -0400
Message-ID: <1495748360-26558-1-git-send-email-stefanb@linux.vnet.ibm.com>
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
 drivers/char/tpm/tpm-interface.c | 4 ++--
 drivers/char/tpm/tpm2-cmd.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d711186..4826fcf 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -429,11 +429,11 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 		goto out;
 
 	rc = chip->ops->send(chip, (u8 *) buf, count);
-	if (rc < 0) {
+	if (rc < 0 && rc != -EPIPE)
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_send: error %d\n", rc);
+	if (rc < 0)
 		goto out;
-	}
 
 	if (chip->flags & TPM_CHIP_FLAG_IRQ)
 		goto out_recv;
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

