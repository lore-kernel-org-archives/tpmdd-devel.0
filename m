From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0111/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:41:29 +0800
Message-ID: <20160802104129.21155-1-baolex.ni@intel.com>
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
 drivers/char/tpm/tpm-interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index e2fa89c..d41261d 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -44,7 +44,7 @@
  * with an extend to the selected _unused_ non-volatile pcr.
  */
 static int tpm_suspend_pcr;
-module_param_named(suspend_pcr, tpm_suspend_pcr, uint, 0644);
+module_param_named(suspend_pcr, tpm_suspend_pcr, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(suspend_pcr,
 		 "PCR to use for dummy writes to faciltate flush on suspend.");
 
-- 
2.9.2
