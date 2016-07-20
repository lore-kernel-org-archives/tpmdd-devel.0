From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix a race condition tpm2_unseal_trusted()
Date: Wed, 20 Jul 2016 03:16:32 +0300
Message-ID: <1468973792-17598-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Unseal and load operations should be done as an atomic unit. This
commit fixes the issue by moving TPM mutex handling to tpm_try_get_ops()
and tpm_put_ops(), which is probably more logical place for it anyway.

Fixes: 954650efb79f ("tpm: seal/unseal for TPM 2.0")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-chip.c      | 2 ++
 drivers/char/tpm/tpm-interface.c | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index e595013..9749f59 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -56,6 +56,7 @@ int tpm_try_get_ops(struct tpm_chip *chip)
 	if (!chip->ops)
 		goto out_lock;
 
+	mutex_lock(&chip->tpm_mutex);
 	return 0;
 out_lock:
 	up_read(&chip->ops_sem);
@@ -73,6 +74,7 @@ EXPORT_SYMBOL_GPL(tpm_try_get_ops);
  */
 void tpm_put_ops(struct tpm_chip *chip)
 {
+	mutex_unlock(&chip->tpm_mutex);
 	up_read(&chip->ops_sem);
 	put_device(&chip->dev);
 }
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1abe2d7..a2a9c36 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -350,8 +350,6 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		return -E2BIG;
 	}
 
-	mutex_lock(&chip->tpm_mutex);
-
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
 		dev_err(&chip->dev,
@@ -393,7 +391,6 @@ out_recv:
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
-	mutex_unlock(&chip->tpm_mutex);
 	return rc;
 }
 
-- 
2.7.4

