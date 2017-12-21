From: Azhar Shaikh <azhar.shaikh@intel.com>
Subject: [PATCH] tpm: Fix the driver cleanup code
Date: Thu, 21 Dec 2017 12:17:02 -0800
Message-ID: <1513887422-123222-1-git-send-email-azhar.shaikh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, jgg@ziepe.ca, javierm@redhat.com, peterhuewe@gmx.de
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, azhar.shaikh@intel.com
List-Id: tpmdd-devel@lists.sourceforge.net

Commit 3c1701339284353c41 ("tpm: Keep CLKRUN enabled throughout
the duration of transmit_cmd()") added code which accessed
chip->ops, even after it was set to NULL in tpm_del_char_device(),
called from tpm_chip_unregister() in error / driver exit paths.
So fix this code.

Fixes: 3c1701339284353c41 ("tpm: Keep CLKRUN enabled throughout
the duration of transmit_cmd()")

Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
---
 drivers/char/tpm/tpm-chip.c     |  5 +++++
 drivers/char/tpm/tpm.h          |  1 +
 drivers/char/tpm/tpm_tis.c      |  8 ++------
 drivers/char/tpm/tpm_tis_core.c | 23 +++++++++++++++--------
 drivers/char/tpm/tpm_tis_spi.c  |  1 +
 5 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 0a62c19937b6..c88ec9a32a7e 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -346,6 +346,10 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 	down_write(&chip->ops_sem);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
+	if (chip->flags & TPM_CHIP_FLAG_DO_NOT_CLEAR_OPS) {
+		up_write(&chip->ops_sem);
+		return;
+	}
 	chip->ops = NULL;
 	up_write(&chip->ops_sem);
 }
@@ -454,6 +458,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 
 	rc = tpm_add_legacy_sysfs(chip);
 	if (rc) {
+		chip->flags |= TPM_CHIP_FLAG_DO_NOT_CLEAR_OPS;
 		tpm_chip_unregister(chip);
 		return rc;
 	}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index f895fba4e20d..dc2a532649e0 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -183,6 +183,7 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
 	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= BIT(4),
 	TPM_CHIP_FLAG_ALWAYS_POWERED	= BIT(5),
+	TPM_CHIP_FLAG_DO_NOT_CLEAR_OPS	= BIT(6),
 };
 
 struct tpm_bios_log {
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index d29add49b033..a146ef4e499b 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -273,11 +273,9 @@ static void tpm_tis_pnp_remove(struct pnp_dev *dev)
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
+	chip->flags |= TPM_CHIP_FLAG_DO_NOT_CLEAR_OPS;
 	tpm_chip_unregister(chip);
 	tpm_tis_remove(chip);
-	if (is_bsw())
-		iounmap(priv->ilb_base_addr);
-
 }
 
 static struct pnp_driver tis_pnp_driver = {
@@ -326,12 +324,10 @@ static int tpm_tis_plat_remove(struct platform_device *pdev)
 	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
+	chip->flags |= TPM_CHIP_FLAG_DO_NOT_CLEAR_OPS;
 	tpm_chip_unregister(chip);
 	tpm_tis_remove(chip);
 
-	if (is_bsw())
-		iounmap(priv->ilb_base_addr);
-
 	return 0;
 }
 
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index c2227983ed88..d9099281fc2e 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -727,6 +727,14 @@ void tpm_tis_remove(struct tpm_chip *chip)
 
 	if (chip->ops->clk_enable != NULL)
 		chip->ops->clk_enable(chip, false);
+
+	if (chip->flags & TPM_CHIP_FLAG_DO_NOT_CLEAR_OPS) {
+		down_write(&chip->ops_sem);
+		chip->ops = NULL;
+		up_write(&chip->ops_sem);
+	}
+	if (priv->ilb_base_addr)
+		iounmap(priv->ilb_base_addr);
 }
 EXPORT_SYMBOL_GPL(tpm_tis_remove);
 
@@ -922,21 +930,20 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	}
 
 	rc = tpm_chip_register(chip);
-	if (rc && is_bsw())
-		iounmap(priv->ilb_base_addr);
+	if (rc)
+		goto out_err;
 
 	if (chip->ops->clk_enable != NULL)
 		chip->ops->clk_enable(chip, false);
 
-	return rc;
-out_err:
-	tpm_tis_remove(chip);
-	if (is_bsw())
-		iounmap(priv->ilb_base_addr);
+	return 0;
 
-	if (chip->ops->clk_enable != NULL)
+out_err:
+	if ((chip->ops != NULL) && (chip->ops->clk_enable != NULL))
 		chip->ops->clk_enable(chip, false);
 
+	tpm_tis_remove(chip);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_tis_core_init);
diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index 424ff2fde1f2..79c18cfc6519 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -221,6 +221,7 @@ static int tpm_tis_spi_remove(struct spi_device *dev)
 {
 	struct tpm_chip *chip = spi_get_drvdata(dev);
 
+	chip->flags |= TPM_CHIP_FLAG_DO_NOT_CLEAR_OPS;
 	tpm_chip_unregister(chip);
 	tpm_tis_remove(chip);
 	return 0;
-- 
1.9.1
