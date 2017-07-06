From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] tpm: tpm_crb: constify acpi_device_id.
Date: Thu,  6 Jul 2017 23:18:39 +0530
Message-ID: <8a670ac215126b76d72861319a0d45e17759ad66.1499363107.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   4198	    608	      0	   4806	   12c6	drivers/char/tpm/tpm_crb.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   4262	    520	      0	   4782	   12ae	drivers/char/tpm/tpm_crb.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/char/tpm/tpm_crb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index b917b9d..bf7189e 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -665,7 +665,7 @@ static const struct dev_pm_ops crb_pm = {
 	SET_RUNTIME_PM_OPS(crb_pm_runtime_suspend, crb_pm_runtime_resume, NULL)
 };
 
-static struct acpi_device_id crb_device_ids[] = {
+static const struct acpi_device_id crb_device_ids[] = {
 	{"MSFT0101", 0},
 	{"", 0},
 };
-- 
2.7.4
