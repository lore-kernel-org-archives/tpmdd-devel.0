From: Colin King <colin.king@canonical.com>
Subject: [PATCH] tpm: return -ENODEV if np is not set
Date: Tue, 15 Nov 2016 13:27:22 +0000
Message-ID: <20161115132722.6963-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Colin Ian King <colin.king@canonical.com>

device_node np contains a garbage value from the stack and it
is only set if chip->dev.parent->of_node is not null.  Thus the
check for a null np won't spot a garbage value of np from the
stack if chip->dev.parent->of_node is null and if np contains
an garbage non-null value.

I believe the correct fix is to return -ENODEV if and only if
chip->dev.parent->of_node is null.

Found with static analysis by CoverityScan, CID 1377755

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/char/tpm/tpm_of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 3af829f..1426590 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -31,7 +31,7 @@ int read_log_of(struct tpm_chip *chip)
 	log = &chip->log;
 	if (chip->dev.parent->of_node)
 		np = chip->dev.parent->of_node;
-	if (!np)
+	else
 		return -ENODEV;
 
 	sizep = of_get_property(np, "linux,sml-size", NULL);
-- 
2.10.2
