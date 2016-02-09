From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix the cleanup of struct tpm_chip
Date: Tue,  9 Feb 2016 05:30:30 +0200
Message-ID: <1454988630-27942-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

If the initialization fails before tpm_chip_register(), put_device()
will be not called, which causes release callback not to be called.
This patch fixes the issue by adding put_device() to devres list of
the parent device.

Fixes: 313d21eeab ("tpm: device class for tpm")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm-chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 1a9dcee..ea904d1 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -136,6 +136,8 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	chip->cdev.owner = chip->pdev->driver->owner;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
+	devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
+
 	return chip;
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
-- 
2.7.0
