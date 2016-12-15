From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] tpm/st33zp24: Remove unneeded linux/miscdevice.h include
Date: Thu, 15 Dec 2016 18:10:17 +0100
Message-ID: <20161215171017.30381-1-clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

tpm/st33zp24/st33zp24.c does not use any miscdevice so this patch remove
this unnecessary inclusion.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 6f060c7..e8e0f7c 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -18,7 +18,6 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
-#include <linux/miscdevice.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
-- 
2.10.2
