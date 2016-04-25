From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] tpm: use devm_add_action_or_reset
Date: Mon, 25 Apr 2016 21:46:38 +0100
Message-ID: <1461617198-32351-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

If devm_add_action() fails we are explicitly calling the cleanup function
in the error path. Lets use the helper function devm_add_action_or_reset()
and return directly as we know the cleanup has been done by the helper.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/char/tpm/tpm-chip.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 5bc530c..aca4505 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -212,11 +212,10 @@ struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
 	if (IS_ERR(chip))
 		return chip;
 
-	rc = devm_add_action(pdev, (void (*)(void *)) put_device, &chip->dev);
-	if (rc) {
-		put_device(&chip->dev);
+	rc = devm_add_action_or_reset(pdev, (void (*)(void *)) put_device,
+				      &chip->dev);
+	if (rc)
 		return ERR_PTR(rc);
-	}
 
 	dev_set_drvdata(pdev, chip);
 
-- 
1.9.1
