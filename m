From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: check for TPM_CHIP_FLAG_TPM2 before calling tpm2_shutdown()
Date: Mon, 25 Apr 2016 12:21:30 +0300
Message-ID: <1461576090-24813-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reported-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm-chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index a12db8e..1965dc7 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -270,7 +270,8 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 
 	/* Make the driver uncallable. */
 	down_write(&chip->ops_sem);
-	tpm2_shutdown(chip, TPM2_SU_CLEAR);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_shutdown(chip, TPM2_SU_CLEAR);
 	chip->ops = NULL;
 	up_write(&chip->ops_sem);
 }
-- 
2.7.4

