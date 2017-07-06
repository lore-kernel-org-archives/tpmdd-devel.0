From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] tpm: tpm_tis: constify acpi_device_id.
Date: Thu,  6 Jul 2017 23:22:09 +0530
Message-ID: <71fede87f425d9282e4e3e1ff9c600c2a4969358.1499363481.git.arvind.yadav.cs@gmail.com>
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
   2758	   1089	     10	   3857	    f11	drivers/char/tpm/tpm_tis.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   2854	    993	     10	   3857	    f11	drivers/char/tpm/tpm_tis.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/char/tpm/tpm_tis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7e1384..a66e03e 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -297,7 +297,7 @@ static int tpm_tis_acpi_remove(struct acpi_device *dev)
 	return 0;
 }
 
-static struct acpi_device_id tpm_acpi_tbl[] = {
+static const struct acpi_device_id tpm_acpi_tbl[] = {
 	{"MSFT0101", 0},	/* TPM 2.0 */
 	/* Add new here */
 	{"", 0},		/* User Specified */
-- 
2.7.4
