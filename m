From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] char: tpm: remove unnecessary NULL check
Date: Tue, 13 Jun 2017 14:55:42 -0500
Message-ID: <20170613195542.GA5677@embeddedgus>
References: <20170613180319.ezszgevmgwno2v5u@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170613180319.ezszgevmgwno2v5u@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Remove unnecessary NULL check.
Pointer _chip_ cannot be NULL in this instance.

Addresses-Coverity-ID: 1397646
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/char/tpm/tpm_atmel.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index 0d322ab..66a1452 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -144,13 +144,11 @@ static void atml_plat_remove(void)
 	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
 	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
 
-	if (chip) {
-		tpm_chip_unregister(chip);
-		if (priv->have_region)
-			atmel_release_region(priv->base, priv->region_size);
-		atmel_put_base_addr(priv->iobase);
-		platform_device_unregister(pdev);
-	}
+	tpm_chip_unregister(chip);
+	if (priv->have_region)
+		atmel_release_region(priv->base, priv->region_size);
+	atmel_put_base_addr(priv->iobase);
+	platform_device_unregister(pdev);
 }
 
 static SIMPLE_DEV_PM_OPS(tpm_atml_pm, tpm_pm_suspend, tpm_pm_resume);
-- 
2.5.0
