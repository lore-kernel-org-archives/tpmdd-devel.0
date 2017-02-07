From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] tpm_tis: fix the error handling of init_tis()
Date: Tue,  7 Feb 2017 15:51:47 +0000
Message-ID: <20170207155147.2581-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Wei Yongjun <weiyongjun1@huawei.com>

Add the missing platform_driver_unregister() and remove the duplicate
platform_device_unregister(force_pdev) in the error handling case.

Fixes: 00194826e6be ("tpm_tis: Clean up the force=1 module parameter")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/tpm/tpm_tis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 7912dad..c7e1384 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -432,7 +432,7 @@ static int __init init_tis(void)
 	acpi_bus_unregister_driver(&tis_acpi_driver);
 err_acpi:
 #endif
-	platform_device_unregister(force_pdev);
+	platform_driver_unregister(&tis_drv);
 err_platform:
 	if (force_pdev)
 		platform_device_unregister(force_pdev);
