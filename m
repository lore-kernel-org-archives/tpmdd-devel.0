From: Azhar Shaikh <azhar.shaikh@intel.com>
Subject: [PATCH v2] tpm: Fix the ioremap() call for Braswell systems
Date: Thu, 22 Jun 2017 14:32:01 -0700
Message-ID: <1498167121-77638-1-git-send-email-azhar.shaikh@intel.com>
References: <1498156197-180919-1-git-send-email-azhar.shaikh@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1498156197-180919-1-git-send-email-azhar.shaikh@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, azhar.shaikh@intel.com
List-Id: tpmdd-devel@lists.sourceforge.net

ioremap() for Intel Braswell processors was done in
tpm_tis_pnp_init(). But before this function gets called,
platform driver 'tis_drv' gets registered and its probe function
tpm_tis_plat_probe() is invoked, which does a TPM
access. Now for Braswell processors tpm_platform_begin_xfer()
will do an ioread32() without having a mapped address, which
will lead to a bad I/O access warning.
Hence move the ioremap() call from tpm_tis_pnp_init() to init_tis()
before registering the 'tis_drv' or basically before any TPM access.
Accordingly also move the iounmap() call from tpm_tis_pnp_remove()
to cleanup_tis() after all TPM access are completed.

Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
---
Changes from v1:
- Do error handling in init_ts().
- Update the commit message.

 drivers/char/tpm/tpm_tis.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 506e62ca3576..d97ce22267fb 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -330,12 +330,6 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 	else
 		tpm_info.irq = -1;
 
-#ifdef CONFIG_X86
-	if (is_bsw())
-		ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
-					ILB_REMAP_SIZE);
-#endif
-
 	return tpm_tis_init(&pnp_dev->dev, &tpm_info);
 }
 
@@ -359,12 +353,6 @@ static void tpm_tis_pnp_remove(struct pnp_dev *dev)
 
 	tpm_chip_unregister(chip);
 	tpm_tis_remove(chip);
-
-#ifdef CONFIG_X86
-	if (is_bsw())
-		iounmap(ilb_base_addr);
-#endif
-
 }
 
 static struct pnp_driver tis_pnp_driver = {
@@ -472,6 +460,11 @@ static int __init init_tis(void)
 	if (rc)
 		goto err_force;
 
+#ifdef CONFIG_X86
+	if (is_bsw())
+		ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
+					ILB_REMAP_SIZE);
+#endif
 	rc = platform_driver_register(&tis_drv);
 	if (rc)
 		goto err_platform;
@@ -490,6 +483,10 @@ static int __init init_tis(void)
 err_platform:
 	if (force_pdev)
 		platform_device_unregister(force_pdev);
+#ifdef CONFIG_X86
+	if (is_bsw())
+		iounmap(ilb_base_addr);
+#endif
 err_force:
 	return rc;
 }
@@ -499,6 +496,10 @@ static void __exit cleanup_tis(void)
 	pnp_unregister_driver(&tis_pnp_driver);
 	platform_driver_unregister(&tis_drv);
 
+#ifdef CONFIG_X86
+	if (is_bsw())
+		iounmap(ilb_base_addr);
+#endif
 	if (force_pdev)
 		platform_device_unregister(force_pdev);
 }
-- 
1.9.1

