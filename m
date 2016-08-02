From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0112/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:41:34 +0800
Message-ID: <20160802104134.21221-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, hpa@zytor.com, x86@kernel.org
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com, jslaby@suse.cz, peter@korsgaard.com, lee.jones@linaro.org
List-Id: tpmdd-devel@lists.sourceforge.net

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/char/tpm/tpm_tis.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a507006..d9ab2f6 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -294,7 +294,7 @@ out:
 }
 
 static bool itpm;
-module_param(itpm, bool, 0444);
+module_param(itpm, bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
 
 /*
@@ -645,7 +645,7 @@ static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
 }
 
 static bool interrupts = true;
-module_param(interrupts, bool, 0444);
+module_param(interrupts, bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static void tpm_tis_remove(struct tpm_chip *chip)
@@ -921,7 +921,7 @@ static struct pnp_driver tis_pnp_driver = {
 
 #define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
 module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
-		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
+		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
 
 #ifdef CONFIG_ACPI
@@ -1060,7 +1060,7 @@ static struct platform_driver tis_drv = {
 
 static bool force;
 #ifdef CONFIG_X86
-module_param(force, bool, 0444);
+module_param(force, bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
 #endif
 
-- 
2.9.2
