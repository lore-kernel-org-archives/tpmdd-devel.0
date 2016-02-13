From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 2/4] tpm: fix: rollback when devm_add_action() fails
Date: Sat, 13 Feb 2016 15:47:05 +0200
Message-ID: <1455371228-20431-3-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1455371228-20431-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455371228-20431-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Call put_device() and return error code if devm_add_action() fails.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reported-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Fixes: 8e0ee3c9faed ("tpm: fix the cleanup of struct tpm_chip")
---
 drivers/char/tpm/tpm-chip.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 2521425..274dd01 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -88,6 +88,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 				 const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
+	int rc;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -136,7 +137,11 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	chip->cdev.owner = chip->pdev->driver->owner;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
-	devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
+	rc = devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
+	if (rc) {
+		put_device(&chip->dev);
+		return ERR_PTR(rc);
+	}
 
 	return chip;
 }
-- 
2.7.0
