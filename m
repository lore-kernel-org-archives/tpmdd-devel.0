From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix crash in tpm_tis
Date: Thu,  7 Apr 2016 15:56:10 +0300
Message-ID: <1460033770-20586-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

rmmod crashes the driver because tpm_chip_unregister() already sets ops
to NULL. Release ops in tpm_dev_release() so that tpm2_shutdown() can be
cleanly executed and also because it is symmetrical where they are
allocated (in tpmm_chip_alloc()).

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Fixes: 4d3eac5e156a ("tpm: Provide strong locking for device removal")
---
 drivers/char/tpm/tpm-chip.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index f62c851..5241bc4 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -127,6 +127,11 @@ static void tpm_dev_release(struct device *dev)
 	idr_remove(&dev_nums_idr, chip->dev_num);
 	mutex_unlock(&idr_lock);
 
+	/* Make the driver uncallable. */
+	down_write(&chip->ops_sem);
+	chip->ops = NULL;
+	up_write(&chip->ops_sem);
+
 	kfree(chip);
 }
 
@@ -266,11 +271,6 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 	mutex_lock(&idr_lock);
 	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
 	mutex_unlock(&idr_lock);
-
-	/* Make the driver uncallable. */
-	down_write(&chip->ops_sem);
-	chip->ops = NULL;
-	up_write(&chip->ops_sem);
 }
 
 static int tpm1_chip_register(struct tpm_chip *chip)
-- 
1.9.1
