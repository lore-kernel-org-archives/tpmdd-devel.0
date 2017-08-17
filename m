From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] tpm: vtpm: constify vio_device_id
Date: Thu, 17 Aug 2017 23:04:21 +0530
Message-ID: <a9ebcd668f5a7293c3805d0b6b21245f15c80212.1502989694.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ashleydlai@gmail.com, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

vio_device_id are not supposed to change at runtime. All functions
working with vio_device_id provided by <asm/vio.h> work with
const vio_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/char/tpm/tpm_ibmvtpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index f01d083..d2ce46b 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -32,7 +32,7 @@
 
 static const char tpm_ibmvtpm_driver_name[] = "tpm_ibmvtpm";
 
-static struct vio_device_id tpm_ibmvtpm_device_table[] = {
+static const struct vio_device_id tpm_ibmvtpm_device_table[] = {
 	{ "IBM,vtpm", "IBM,vtpm"},
 	{ "", "" }
 };
-- 
2.7.4
