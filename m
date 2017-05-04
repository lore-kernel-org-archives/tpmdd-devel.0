From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 3/3] tpm_tis: Consolidate the platform and
	acpi probe flow
Date: Thu,  4 May 2017 09:53:25 -0600
Message-ID: <1493913205-18276-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1493913205-18276-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1493913205-18276-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Now that the platform device was merged for OF support we can use the
platform device to match ACPI devices as well and run everything
through tpm_tis_init.

pnp_acpi_device is replaced with ACPI_COMPANION, and ACPI_HANDLE is
pushed further down.

platform_get_resource is used instead of acpi_dev_get_resources.

The itpm global module parameter is no longer changed during itpm
detection, instead the phy specific bit is set directly.

Tested-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 167 +++++++++++++++------------------------------
 1 file changed, 54 insertions(+), 113 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 1807b284326b88..54d90e31a7b690 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -80,6 +80,8 @@ static int has_hid(struct acpi_device *dev, const char *hid)
 
 static inline int is_itpm(struct acpi_device *dev)
 {
+	if (!dev)
+		return 0;
 	return has_hid(dev, "INTC0102");
 }
 #else
@@ -89,6 +91,47 @@ static inline int is_itpm(struct acpi_device *dev)
 }
 #endif
 
+#if defined(CONFIG_ACPI)
+#define DEVICE_IS_TPM2 1
+
+static const struct acpi_device_id tpm_acpi_tbl[] = {
+	{"MSFT0101", DEVICE_IS_TPM2},
+	{},
+};
+MODULE_DEVICE_TABLE(acpi, tpm_acpi_tbl);
+
+static int check_acpi_tpm2(struct device *dev)
+{
+	const struct acpi_device_id *aid = acpi_match_device(tpm_acpi_tbl, dev);
+	struct acpi_table_tpm2 *tbl;
+	acpi_status st;
+
+	if (!aid || aid->driver_data != DEVICE_IS_TPM2)
+		return 0;
+
+	/* If the ACPI TPM2 signature is matched then a global ACPI_SIG_TPM2
+	 * table is mandatory
+	 */
+	st =
+	    acpi_get_table(ACPI_SIG_TPM2, 1, (struct acpi_table_header **)&tbl);
+	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
+		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
+		return -EINVAL;
+	}
+
+	/* The tpm2_crb driver handles this device */
+	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
+		return -ENODEV;
+
+	return 0;
+}
+#else
+static int check_acpi_tpm2(struct acpi_device *dev)
+{
+	return 0;
+}
+#endif
+
 static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 			      u8 *result)
 {
@@ -141,11 +184,15 @@ static const struct tpm_tis_phy_ops tpm_tcg = {
 	.write32 = tpm_tcg_write32,
 };
 
-static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
-			acpi_handle acpi_dev_handle)
+static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info)
 {
 	struct tpm_tis_tcg_phy *phy;
 	int irq = -1;
+	int rc;
+
+	rc = check_acpi_tpm2(dev);
+	if (rc)
+		return rc;
 
 	phy = devm_kzalloc(dev, sizeof(struct tpm_tis_tcg_phy), GFP_KERNEL);
 	if (phy == NULL)
@@ -158,11 +205,11 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	if (interrupts)
 		irq = tpm_info->irq;
 
-	if (itpm)
+	if (itpm || is_itpm(ACPI_COMPANION(dev)))
 		phy->priv.flags |= TPM_TIS_ITPM_WORKAROUND;
 
 	return tpm_tis_core_init(dev, &phy->priv, irq, &tpm_tcg,
-				 acpi_dev_handle);
+				 ACPI_HANDLE(dev));
 }
 
 static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
@@ -171,7 +218,6 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 			    const struct pnp_device_id *pnp_id)
 {
 	struct tpm_info tpm_info = {};
-	acpi_handle acpi_dev_handle = NULL;
 	struct resource *res;
 
 	res = pnp_get_resource(pnp_dev, IORESOURCE_MEM, 0);
@@ -184,14 +230,7 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 	else
 		tpm_info.irq = -1;
 
-	if (pnp_acpi_device(pnp_dev)) {
-		if (is_itpm(pnp_acpi_device(pnp_dev)))
-			itpm = true;
-
-		acpi_dev_handle = ACPI_HANDLE(&pnp_dev->dev);
-	}
-
-	return tpm_tis_init(&pnp_dev->dev, &tpm_info, acpi_dev_handle);
+	return tpm_tis_init(&pnp_dev->dev, &tpm_info);
 }
 
 static struct pnp_device_id tpm_pnp_tbl[] = {
@@ -231,93 +270,6 @@ module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
 		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
 
-#ifdef CONFIG_ACPI
-static int tpm_check_resource(struct acpi_resource *ares, void *data)
-{
-	struct tpm_info *tpm_info = (struct tpm_info *) data;
-	struct resource res;
-
-	if (acpi_dev_resource_interrupt(ares, 0, &res))
-		tpm_info->irq = res.start;
-	else if (acpi_dev_resource_memory(ares, &res)) {
-		tpm_info->res = res;
-		tpm_info->res.name = NULL;
-	}
-
-	return 1;
-}
-
-static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
-{
-	struct acpi_table_tpm2 *tbl;
-	acpi_status st;
-	struct list_head resources;
-	struct tpm_info tpm_info = {};
-	int ret;
-
-	st = acpi_get_table(ACPI_SIG_TPM2, 1,
-			    (struct acpi_table_header **) &tbl);
-	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
-		dev_err(&acpi_dev->dev,
-			FW_BUG "failed to get TPM2 ACPI table\n");
-		return -EINVAL;
-	}
-
-	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
-		return -ENODEV;
-
-	INIT_LIST_HEAD(&resources);
-	tpm_info.irq = -1;
-	ret = acpi_dev_get_resources(acpi_dev, &resources, tpm_check_resource,
-				     &tpm_info);
-	if (ret < 0)
-		return ret;
-
-	acpi_dev_free_resource_list(&resources);
-
-	if (resource_type(&tpm_info.res) != IORESOURCE_MEM) {
-		dev_err(&acpi_dev->dev,
-			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
-		return -EINVAL;
-	}
-
-	if (is_itpm(acpi_dev))
-		itpm = true;
-
-	return tpm_tis_init(&acpi_dev->dev, &tpm_info, acpi_dev->handle);
-}
-
-static int tpm_tis_acpi_remove(struct acpi_device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(&dev->dev);
-
-	tpm_chip_unregister(chip);
-	tpm_tis_remove(chip);
-
-	return 0;
-}
-
-static struct acpi_device_id tpm_acpi_tbl[] = {
-	{"MSFT0101", 0},	/* TPM 2.0 */
-	/* Add new here */
-	{"", 0},		/* User Specified */
-	{"", 0}			/* Terminator */
-};
-MODULE_DEVICE_TABLE(acpi, tpm_acpi_tbl);
-
-static struct acpi_driver tis_acpi_driver = {
-	.name = "tpm_tis",
-	.ids = tpm_acpi_tbl,
-	.ops = {
-		.add = tpm_tis_acpi_init,
-		.remove = tpm_tis_acpi_remove,
-	},
-	.drv = {
-		.pm = &tpm_tis_pm,
-	},
-};
-#endif
-
 static struct platform_device *force_pdev;
 
 static int tpm_tis_plat_probe(struct platform_device *pdev)
@@ -341,7 +293,7 @@ static int tpm_tis_plat_probe(struct platform_device *pdev)
 			tpm_info.irq = 0;
 	}
 
-	return tpm_tis_init(&pdev->dev, &tpm_info, NULL);
+	return tpm_tis_init(&pdev->dev, &tpm_info);
 }
 
 static int tpm_tis_plat_remove(struct platform_device *pdev)
@@ -369,6 +321,7 @@ static struct platform_driver tis_drv = {
 		.name		= "tpm_tis",
 		.pm		= &tpm_tis_pm,
 		.of_match_table = of_match_ptr(tis_of_platform_match),
+		.acpi_match_table = ACPI_PTR(tpm_acpi_tbl),
 	},
 };
 
@@ -411,11 +364,6 @@ static int __init init_tis(void)
 	if (rc)
 		goto err_platform;
 
-#ifdef CONFIG_ACPI
-	rc = acpi_bus_register_driver(&tis_acpi_driver);
-	if (rc)
-		goto err_acpi;
-#endif
 
 	if (IS_ENABLED(CONFIG_PNP)) {
 		rc = pnp_register_driver(&tis_pnp_driver);
@@ -426,10 +374,6 @@ static int __init init_tis(void)
 	return 0;
 
 err_pnp:
-#ifdef CONFIG_ACPI
-	acpi_bus_unregister_driver(&tis_acpi_driver);
-err_acpi:
-#endif
 	platform_driver_unregister(&tis_drv);
 err_platform:
 	if (force_pdev)
@@ -441,9 +385,6 @@ static int __init init_tis(void)
 static void __exit cleanup_tis(void)
 {
 	pnp_unregister_driver(&tis_pnp_driver);
-#ifdef CONFIG_ACPI
-	acpi_bus_unregister_driver(&tis_acpi_driver);
-#endif
 	platform_driver_unregister(&tis_drv);
 
 	if (force_pdev)
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
