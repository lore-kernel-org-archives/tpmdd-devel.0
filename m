From: Azhar Shaikh <azhar.shaikh@intel.com>
Subject: [PATCH v4 2/2] tpm_tis: Move ilb_base_addr to tpm_tis_tcg_phy
Date: Tue, 21 Nov 2017 14:39:24 -0800
Message-ID: <1511303964-56294-3-git-send-email-azhar.shaikh@intel.com>
References: <1511303964-56294-1-git-send-email-azhar.shaikh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511303964-56294-1-git-send-email-azhar.shaikh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, peterhuewe@gmx.de
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, azhar.shaikh@intel.com
List-Id: tpmdd-devel@lists.sourceforge.net

Move the static variable ilb_base_addr to tpm_tis_tcg_phy.

Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
---
 drivers/char/tpm/tpm_tis.c | 67 ++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 76a7b64195c8..d87b37c5404b 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -46,6 +46,7 @@ struct tpm_info {
 struct tpm_tis_tcg_phy {
 	struct tpm_tis_data priv;
 	void __iomem *iobase;
+	void __iomem *ilb_base_addr;
 	bool begin_xfer_done;
 };
 
@@ -134,19 +135,22 @@ static int check_acpi_tpm2(struct device *dev)
 }
 #endif
 
+static inline bool is_bsw(void)
+{
 #ifdef CONFIG_X86
+	return ((boot_cpu_data.x86_model == INTEL_FAM6_ATOM_AIRMONT) ? 1 : 0);
+#else
+	return false;
+#endif
+}
+
 #define INTEL_LEGACY_BLK_BASE_ADDR      0xFED08000
 #define ILB_REMAP_SIZE			0x100
+
+#ifdef CONFIG_X86
 #define LPC_CNTRL_REG_OFFSET            0x84
 #define LPC_CLKRUN_EN                   (1 << 2)
 
-static void __iomem *ilb_base_addr;
-
-static inline bool is_bsw(void)
-{
-	return ((boot_cpu_data.x86_model == INTEL_FAM6_ATOM_AIRMONT) ? 1 : 0);
-}
-
 /**
  * tpm_platform_begin_xfer() - clear LPC CLKRUN_EN i.e. clocks will be running
  * @data:	struct tpm_tis_data instance
@@ -160,11 +164,11 @@ static void tpm_platform_begin_xfer(struct tpm_tis_data *data)
 					phy->begin_xfer_done))
 		return;
 
-	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+	clkrun_val = ioread32(phy->ilb_base_addr + LPC_CNTRL_REG_OFFSET);
 
 	/* Disable LPC CLKRUN# */
 	clkrun_val &= ~LPC_CLKRUN_EN;
-	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+	iowrite32(clkrun_val, phy->ilb_base_addr + LPC_CNTRL_REG_OFFSET);
 
 	/*
 	 * Write any random value on port 0x80 which is on LPC, to make
@@ -185,15 +189,16 @@ static void tpm_platform_begin_xfer(struct tpm_tis_data *data)
 static void tpm_platform_end_xfer(struct tpm_tis_data *data)
 {
 	u32 clkrun_val;
+	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
 	if (!is_bsw() || (data->flags & TPM_TIS_CLK_ENABLE))
 		return;
 
-	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+	clkrun_val = ioread32(phy->ilb_base_addr + LPC_CNTRL_REG_OFFSET);
 
 	/* Enable LPC CLKRUN# */
 	clkrun_val |= LPC_CLKRUN_EN;
-	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+	iowrite32(clkrun_val, phy->ilb_base_addr + LPC_CNTRL_REG_OFFSET);
 
 	/*
 	 * Write any random value on port 0x80 which is on LPC, to make
@@ -204,10 +209,6 @@ static void tpm_platform_end_xfer(struct tpm_tis_data *data)
 }
 
 #else
-static inline bool is_bsw(void)
-{
-	return false;
-}
 static void tpm_platform_begin_xfer(struct tpm_tis_data *data)
 {
 }
@@ -311,14 +312,25 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info)
 	if (IS_ERR(phy->iobase))
 		return PTR_ERR(phy->iobase);
 
+	if (is_bsw()) {
+		phy->ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
+					ILB_REMAP_SIZE);
+		if (!phy->ilb_base_addr)
+			return -ENOMEM;
+	}
+
 	if (interrupts)
 		irq = tpm_info->irq;
 
 	if (itpm || is_itpm(ACPI_COMPANION(dev)))
 		phy->priv.flags |= TPM_TIS_ITPM_WORKAROUND;
 
-	return tpm_tis_core_init(dev, &phy->priv, irq, &tpm_tcg,
+	rc = tpm_tis_core_init(dev, &phy->priv, irq, &tpm_tcg,
 				 ACPI_HANDLE(dev));
+	if (rc && is_bsw())
+		iounmap(phy->ilb_base_addr);
+
+	return rc;
 }
 
 static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
@@ -359,9 +371,14 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 static void tpm_tis_pnp_remove(struct pnp_dev *dev)
 {
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
 
 	tpm_chip_unregister(chip);
 	tpm_tis_remove(chip);
+
+	if (is_bsw())
+		iounmap(phy->ilb_base_addr);
 }
 
 static struct pnp_driver tis_pnp_driver = {
@@ -408,10 +425,15 @@ static int tpm_tis_plat_probe(struct platform_device *pdev)
 static int tpm_tis_plat_remove(struct platform_device *pdev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
 
 	tpm_chip_unregister(chip);
 	tpm_tis_remove(chip);
 
+	if (is_bsw())
+		iounmap(phy->ilb_base_addr);
+
 	return 0;
 }
 
@@ -469,11 +491,6 @@ static int __init init_tis(void)
 	if (rc)
 		goto err_force;
 
-#ifdef CONFIG_X86
-	if (is_bsw())
-		ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
-					ILB_REMAP_SIZE);
-#endif
 	rc = platform_driver_register(&tis_drv);
 	if (rc)
 		goto err_platform;
@@ -492,10 +509,6 @@ static int __init init_tis(void)
 err_platform:
 	if (force_pdev)
 		platform_device_unregister(force_pdev);
-#ifdef CONFIG_X86
-	if (is_bsw())
-		iounmap(ilb_base_addr);
-#endif
 err_force:
 	return rc;
 }
@@ -505,10 +518,6 @@ static void __exit cleanup_tis(void)
 	pnp_unregister_driver(&tis_pnp_driver);
 	platform_driver_unregister(&tis_drv);
 
-#ifdef CONFIG_X86
-	if (is_bsw())
-		iounmap(ilb_base_addr);
-#endif
 	if (force_pdev)
 		platform_device_unregister(force_pdev);
 }
-- 
1.9.1
