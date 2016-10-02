From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] tpm: don't destroy chip device prematurely
Date: Sun,  2 Oct 2016 10:39:31 +0300
Message-ID: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

In tpm_del_char_device device_del is called
prior to tpm2_shutdown where it is still used.

Fortunately, so far chip->dev was used only for printouts
int tpm2_shutdown flow, hence system didn't crash. But with
the introduction of runtime power management it will result in
shutting down the parent device while it still in use.

Fixes: 20e0152393b41 ("tpm: fix crash in tpm_tis deinitialization")
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/char/tpm/tpm-chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index e5950131bd90..b1cb0aae8e66 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -261,7 +261,6 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 static void tpm_del_char_device(struct tpm_chip *chip)
 {
 	cdev_del(&chip->cdev);
-	device_del(&chip->dev);
 
 	/* Make the chip unavailable. */
 	mutex_lock(&idr_lock);
@@ -274,6 +273,8 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
 	chip->ops = NULL;
 	up_write(&chip->ops_sem);
+
+	device_del(&chip->dev);
 }
 
 static int tpm1_chip_register(struct tpm_chip *chip)
-- 
2.7.4
