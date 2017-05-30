From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] char: tmp: fix potential null pointer dereference
Date: Tue, 30 May 2017 16:51:23 -0500
Message-ID: <20170530215123.GA7484@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: tpmdd-devel@lists.sourceforge.net

NULL check at line 147: if (chip) {, implies chip might be NULL.
Function dev_get_drvdata() dereference pointer chip.
Move pointer priv assignment inside the IF block that checks
pointer chip.

Addresses-Coverity-ID: 1397646
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/char/tpm/tpm_atmel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index 0d322ab..0826efd 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -142,9 +142,10 @@ static struct platform_device *pdev;
 static void atml_plat_remove(void)
 {
 	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
-	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_atmel_priv *priv;
 
 	if (chip) {
+		priv = dev_get_drvdata(&chip->dev);
 		tpm_chip_unregister(chip);
 		if (priv->have_region)
 			atmel_release_region(priv->base, priv->region_size);
-- 
2.5.0
