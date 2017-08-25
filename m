From: Colin King <colin.king@canonical.com>
Subject: [PATCH] tpm_tis: make array cmd_getticks static const to shink object code size
Date: Fri, 25 Aug 2017 17:45:05 +0100
Message-ID: <20170825164505.23447-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Colin Ian King <colin.king@canonical.com>

Don't populate array cmd_getticks on the stack, instead make it static
const.  Makes the object code smaller by over 160 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  18813	   3152	    128	  22093	   564d	drivers/char/tpm/tpm_tis_core.o

After:
   text	   data	    bss	    dec	    hex	filename
  18554	   3248	    128	  21930	   55aa	drivers/char/tpm/tpm_tis_core.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/char/tpm/tpm_tis_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 63bc6c3b949e..1e957e923d21 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -445,7 +445,7 @@ static int probe_itpm(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	int rc = 0;
-	u8 cmd_getticks[] = {
+	static const u8 cmd_getticks[] = {
 		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
 		0x00, 0x00, 0x00, 0xf1
 	};
-- 
2.14.1
