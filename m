From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 2/3] char: tpm: constify attribute_group structures.
Date: Wed,  2 Aug 2017 16:50:14 +0530
Message-ID: <1501672814-2995-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, gregkh@linuxfoundation.org, mark.gross@intel.com, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

attribute_group are not supposed to change at runtime. All functions
working with attribute_group provided by <linux/sysfs.h> work with
const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/char/tpm/tpm_ppi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 86dd852..8e3c062 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -325,7 +325,7 @@ static DEVICE_ATTR(transition_action, S_IRUGO,
 	&dev_attr_tcg_operations.attr,
 	&dev_attr_vs_operations.attr, NULL,
 };
-static struct attribute_group ppi_attr_grp = {
+static const struct attribute_group ppi_attr_grp = {
 	.name = "ppi",
 	.attrs = ppi_attrs
 };
-- 
1.9.1
