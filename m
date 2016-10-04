From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: remove invalid min length check from tpm_do_selftest()
Date: Tue,  4 Oct 2016 13:40:31 +0300
Message-ID: <1475577631-7353-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Removal of this check was not properly amended to the original commit.

Cc: stable@vger.kernel.org
Fixes: 0c541332231e ("tpm: use tpm_pcr_read_dev() in tpm_do_selftest()")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 7743e8a..cb0e57e 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -818,9 +818,6 @@ int tpm_do_selftest(struct tpm_chip *chip)
 			continue;
 		}
 
-		if (rc < TPM_HEADER_SIZE)
-			return -EFAULT;
-
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
 			dev_info(&chip->dev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);
-- 
2.7.4
