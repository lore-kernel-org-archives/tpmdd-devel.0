From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: invalid self test error message
Date: Fri,  2 Sep 2016 08:56:29 +0300
Message-ID: <1472795790-15131-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The driver emits invalid self test error message even though the init
succeeds.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Fixes: cae8b441fc20 ("tpm: Factor out common startup code")
---
 drivers/char/tpm/tpm2-cmd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 955fd26..906c285 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -966,7 +966,7 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 		goto out;
 
 	rc = tpm2_do_selftest(chip);
-	if (rc != TPM2_RC_INITIALIZE) {
+	if (rc != 0 && rc != TPM2_RC_INITIALIZE) {
 		dev_err(&chip->dev, "TPM self test failed\n");
 		goto out;
 	}
@@ -983,7 +983,6 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 		}
 	}
 
-	return rc;
 out:
 	if (rc > 0)
 		rc = -ENODEV;
-- 
2.7.4

