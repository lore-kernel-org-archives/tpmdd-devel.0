From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH v2] tpm: use devm_add_action_or_reset
Date: Sat, 30 Apr 2016 17:58:06 +0100
Message-ID: <1462035486-26463-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

If devm_add_action() fails we are explicitly calling the cleanup function
in the error path. Lets use the helper function devm_add_action_or_reset()
and return directly as we know the cleanup has been done by the helper.

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---

v2: rebased against the current charmisc-testing branch.

 drivers/char/tpm/tpm-chip.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 274dd01..4c2deea 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -137,11 +137,10 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	chip->cdev.owner = chip->pdev->driver->owner;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
-	rc = devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
-	if (rc) {
-		put_device(&chip->dev);
+	rc = devm_add_action_or_reset(dev, (void (*)(void *)) put_device,
+				      &chip->dev);
+	if (rc)
 		return ERR_PTR(rc);
-	}
 
 	return chip;
 }
-- 
1.9.1
