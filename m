From: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] tpm_ts: Consolidate the platform and acpi
	probe flow
Date: Wed, 3 May 2017 14:01:59 -0700
Message-ID: <20170503210159.ook77o4myjebl4xr@rhwork>
References: <20170503164857.GA20369@obsidianresearch.com>
Reply-To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170503164857.GA20369-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed May 03 17, Jason Gunthorpe wrote:
>Now that the platform device was merged for OF support we can use the
>platform device to match ACPI devices as well and run everything
>through tpm_tis_init.
>
>pnp_acpi_device is replaced with ACPI_COMPANION, and ACPI_HANDLE is
>pushed further down.
>
>platform_get_resource is used instead of acpi_dev_get_resources.
>
>The itpm global module parameter is no longer changed during itpm
>detection, instead the phy specific bit is set directly.
>
>Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>---
> drivers/char/tpm/tpm_tis.c | 167 +++++++++++++++------------------------------
> 1 file changed, 54 insertions(+), 113 deletions(-)
>
>Jarkko,
>
>As discussed, here is a patch that combines the ACPI and platform
>drivers into one.
>
>I do not have ACPI hardware so this is only compile tested, perhaps
>you are able to test it, particularly with a CRB device would be
>intersting to check that the acpi_match_device/etc transformation is
>working properly.
>
>diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
>index c7e1384f1b0802..ddad56a4a958f1 100644
>--- a/drivers/char/tpm/tpm_tis.c
>+++ b/drivers/char/tpm/tpm_tis.c
>@@ -80,6 +80,8 @@ static int has_hid(struct acpi_device *dev, const char *hid)
>
> static inline int is_itpm(struct acpi_device *dev)
> {
>+	if (!dev)
>+		return 0;
> 	return has_hid(dev, "INTC0102");
> }
> #else
>@@ -89,6 +91,47 @@ static inline int is_itpm(struct acpi_device *dev)
> }
> #endif
>
>+#if defined(CONFIG_ACPI)
>+#define DEVICE_IS_TPM2 1
>+
>+static const struct acpi_device_id tpm_acpi_tbl[] = {
>+	{"MSFT0101", DEVICE_IS_TPM2},
>+	{},
>+};
>+MODULE_DEVICE_TABLE(acpi, tpm_acpi_tbl);
>+
>+static int check_acpi_tpm2(struct device *dev)
>+{
>+	const struct acpi_device_id *aid = acpi_match_device(tpm_acpi_tbl, dev);
>+	struct acpi_table_tpm2 *tbl;
>+	acpi_status st;
>+
>+	if (!aid || aid->driver_data != DEVICE_IS_TPM2)
>+		return 0;
>+
>+	/* If the ACPI TPM2 signature is matched then a global ACPI_SIG_TPM2
>+	 * table is mandatory
>+	 */
>+	st =
>+	    acpi_get_table(ACPI_SIG_TPM2, 1, (struct acpi_table_header **)&tbl);
>+	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
>+		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
>+		return -EINVAL;
>+	}
>+
>+	/* The tpm2_crb driver handles this device */
>+	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
>+		return -ENODEV;
>+
>+	return 0;
>+}
>+#else
>+static int check_acpi_tpm2(struct acpi_device *dev)
>+{
>+	return 0;
>+}
>+#endif
>+
> static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
> 			      u8 *result)
> {
>@@ -141,11 +184,15 @@ static const struct tpm_tis_phy_ops tpm_tcg = {
> 	.write32 = tpm_tcg_write32,
> };
>
>-static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>-			acpi_handle acpi_dev_handle)
>+static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info)
> {
> 	struct tpm_tis_tcg_phy *phy;
> 	int irq = -1;
>+	int rc;
>+
>+	rc = check_acpi_tpm2(dev);
>+	if (rc)
>+		return rc;
>
> 	phy = devm_kzalloc(dev, sizeof(struct tpm_tis_tcg_phy), GFP_KERNEL);
> 	if (phy == NULL)
>@@ -158,11 +205,11 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
> 	if (interrupts)
> 		irq = tpm_info->irq;
>
>-	if (itpm)
>+	if (itpm || is_itpm(ACPI_COMPANION(dev)))
> 		phy->priv.flags |= TPM_TIS_ITPM_WORKAROUND;
>
> 	return tpm_tis_core_init(dev, &phy->priv, irq, &tpm_tcg,
>-				 acpi_dev_handle);
>+				 ACPI_HANDLE(dev));
> }
>
> static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
>@@ -171,7 +218,6 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
> 			    const struct pnp_device_id *pnp_id)
> {
> 	struct tpm_info tpm_info = {};
>-	acpi_handle acpi_dev_handle = NULL;
> 	struct resource *res;
>
> 	res = pnp_get_resource(pnp_dev, IORESOURCE_MEM, 0);
>@@ -184,14 +230,7 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
> 	else
> 		tpm_info.irq = -1;
>
>-	if (pnp_acpi_device(pnp_dev)) {
>-		if (is_itpm(pnp_acpi_device(pnp_dev)))
>-			itpm = true;
>-
>-		acpi_dev_handle = ACPI_HANDLE(&pnp_dev->dev);
>-	}
>-
>-	return tpm_tis_init(&pnp_dev->dev, &tpm_info, acpi_dev_handle);
>+	return tpm_tis_init(&pnp_dev->dev, &tpm_info);
> }
>
> static struct pnp_device_id tpm_pnp_tbl[] = {
>@@ -231,93 +270,6 @@ module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
> 		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
> MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
>
>-#ifdef CONFIG_ACPI
>-static int tpm_check_resource(struct acpi_resource *ares, void *data)
>-{
>-	struct tpm_info *tpm_info = (struct tpm_info *) data;
>-	struct resource res;
>-
>-	if (acpi_dev_resource_interrupt(ares, 0, &res))
>-		tpm_info->irq = res.start;
>-	else if (acpi_dev_resource_memory(ares, &res)) {
>-		tpm_info->res = res;
>-		tpm_info->res.name = NULL;
>-	}
>-
>-	return 1;
>-}
>-
>-static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
>-{
>-	struct acpi_table_tpm2 *tbl;
>-	acpi_status st;
>-	struct list_head resources;
>-	struct tpm_info tpm_info = {};
>-	int ret;
>-
>-	st = acpi_get_table(ACPI_SIG_TPM2, 1,
>-			    (struct acpi_table_header **) &tbl);
>-	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
>-		dev_err(&acpi_dev->dev,
>-			FW_BUG "failed to get TPM2 ACPI table\n");
>-		return -EINVAL;
>-	}
>-
>-	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
>-		return -ENODEV;
>-
>-	INIT_LIST_HEAD(&resources);
>-	tpm_info.irq = -1;
>-	ret = acpi_dev_get_resources(acpi_dev, &resources, tpm_check_resource,
>-				     &tpm_info);
>-	if (ret < 0)
>-		return ret;
>-
>-	acpi_dev_free_resource_list(&resources);
>-
>-	if (resource_type(&tpm_info.res) != IORESOURCE_MEM) {
>-		dev_err(&acpi_dev->dev,
>-			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
>-		return -EINVAL;
>-	}
>-
>-	if (is_itpm(acpi_dev))
>-		itpm = true;
>-
>-	return tpm_tis_init(&acpi_dev->dev, &tpm_info, acpi_dev->handle);
>-}
>-
>-static int tpm_tis_acpi_remove(struct acpi_device *dev)
>-{
>-	struct tpm_chip *chip = dev_get_drvdata(&dev->dev);
>-
>-	tpm_chip_unregister(chip);
>-	tpm_tis_remove(chip);
>-
>-	return 0;
>-}
>-
>-static struct acpi_device_id tpm_acpi_tbl[] = {
>-	{"MSFT0101", 0},	/* TPM 2.0 */
>-	/* Add new here */
>-	{"", 0},		/* User Specified */
>-	{"", 0}			/* Terminator */
>-};
>-MODULE_DEVICE_TABLE(acpi, tpm_acpi_tbl);
>-
>-static struct acpi_driver tis_acpi_driver = {
>-	.name = "tpm_tis",
>-	.ids = tpm_acpi_tbl,
>-	.ops = {
>-		.add = tpm_tis_acpi_init,
>-		.remove = tpm_tis_acpi_remove,
>-	},
>-	.drv = {
>-		.pm = &tpm_tis_pm,
>-	},
>-};
>-#endif
>-
> static struct platform_device *force_pdev;
>
> static int tpm_tis_plat_probe(struct platform_device *pdev)
>@@ -343,7 +295,7 @@ static int tpm_tis_plat_probe(struct platform_device *pdev)
> 			tpm_info.irq = 0;
> 	}
>
>-	return tpm_tis_init(&pdev->dev, &tpm_info, NULL);
>+	return tpm_tis_init(&pdev->dev, &tpm_info);
> }
>
> static int tpm_tis_plat_remove(struct platform_device *pdev)
>@@ -371,6 +323,7 @@ static struct platform_driver tis_drv = {
> 		.name		= "tpm_tis",
> 		.pm		= &tpm_tis_pm,
> 		.of_match_table = of_match_ptr(tis_of_platform_match),
>+		.acpi_match_table = ACPI_PTR(tpm_acpi_tbl),
> 	},
> };
>
>@@ -413,11 +366,6 @@ static int __init init_tis(void)
> 	if (rc)
> 		goto err_platform;
>
>-#ifdef CONFIG_ACPI
>-	rc = acpi_bus_register_driver(&tis_acpi_driver);
>-	if (rc)
>-		goto err_acpi;
>-#endif
>
> 	if (IS_ENABLED(CONFIG_PNP)) {
> 		rc = pnp_register_driver(&tis_pnp_driver);
>@@ -428,10 +376,6 @@ static int __init init_tis(void)
> 	return 0;
>
> err_pnp:
>-#ifdef CONFIG_ACPI
>-	acpi_bus_unregister_driver(&tis_acpi_driver);
>-err_acpi:
>-#endif
> 	platform_driver_unregister(&tis_drv);
> err_platform:
> 	if (force_pdev)
>@@ -443,9 +387,6 @@ static int __init init_tis(void)
> static void __exit cleanup_tis(void)
> {
> 	pnp_unregister_driver(&tis_pnp_driver);
>-#ifdef CONFIG_ACPI
>-	acpi_bus_unregister_driver(&tis_acpi_driver);
>-#endif
> 	platform_driver_unregister(&tis_drv);
>
> 	if (force_pdev)
>-- 
>2.7.4


I haven't had a chance to dig into it yet, but I'm seeing this with the patch on top of tpmdd/next:

[    1.041046] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)
[    1.293032] genirq: Flags mismatch irq 9. 00000000 (tpm0) vs. 00000080 (acpi)
[    1.293059] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.11.0-rc4+ #2
[    1.293060] Hardware name:                  /NUC5i5MYBE, BIOS MYBDWi5v.86A.0034.2017.0116.2148 01/16/2017
[    1.293060] Call Trace:
[    1.293066]  dump_stack+0x63/0x86
[    1.293068]  __setup_irq+0x5c2/0x610
[    1.293070]  request_threaded_irq+0x10b/0x1a0
[    1.293072]  ? tpm_tis_send+0x110/0x110
[    1.293074]  devm_request_threaded_irq+0x69/0xc0
[    1.293075]  tpm_tis_probe_irq_single+0x4d/0x1b0
[    1.293076]  ? tpm_tcg_read_bytes+0x39/0x50
[    1.293077]  tpm_tis_core_init+0x472/0x650
[    1.293079]  tpm_tis_init.part.1+0x96/0x110
[    1.293080]  tpm_tis_plat_probe+0xb0/0xf0
[    1.293082]  platform_drv_probe+0x3b/0xa0
[    1.293083]  ? device_links_check_suppliers+0x6b/0xc0
[    1.293086]  driver_probe_device+0x1c8/0x460
[    1.293088]  __driver_attach+0xd1/0xf0
[    1.293089]  ? driver_probe_device+0x460/0x460
[    1.293091]  bus_for_each_dev+0x60/0xa0
[    1.293093]  driver_attach+0x1e/0x20
[    1.293094]  bus_add_driver+0x1c3/0x280
[    1.293097]  ? set_debug_rodata+0x12/0x12
[    1.293098]  driver_register+0x60/0xe0
[    1.293099]  ? tpm_init+0xd1/0xd1
[    1.293101]  __platform_driver_register+0x36/0x40
[    1.293102]  init_tis+0x6b/0xa9
[    1.293103]  ? kobject_uevent+0xb/0x10
[    1.293106]  ? driver_register+0x8e/0xe0
[    1.293108]  ? agp_sis_init+0x2a/0x2a
[    1.293110]  ? __pci_register_driver+0x4c/0x50
[    1.293111]  ? tpm_init+0xd1/0xd1
[    1.293113]  do_one_initcall+0x52/0x1a0
[    1.293114]  ? set_debug_rodata+0x12/0x12
[    1.293116]  kernel_init_freeable+0x190/0x218
[    1.293118]  ? rest_init+0x80/0x80
[    1.293119]  kernel_init+0xe/0x100
[    1.293121]  ret_from_fork+0x2c/0x40
[    1.293124] tpm tpm0: Unable to request irq: 9 for probe


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
