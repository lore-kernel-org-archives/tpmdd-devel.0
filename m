From: Colin King <colin.king@canonical.com>
Subject: [PATCH][tpm-next] tpm_tis: make ilb_base_addr static
Date: Tue, 20 Jun 2017 11:22:02 +0100
Message-ID: <20170620102202.7132-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Colin Ian King <colin.king@canonical.com>

The pointer ilb_base_addr does not need to be in global scope, so make
it static.

Cleans up sparse warning:
"symbol 'ilb_base_addr' was not declared. Should it be static?"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/char/tpm/tpm_tis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 506e62ca3576..c915d65c1909 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -138,7 +138,7 @@ static int check_acpi_tpm2(struct device *dev)
 #define LPC_CNTRL_REG_OFFSET            0x84
 #define LPC_CLKRUN_EN                   (1 << 2)
 
-void __iomem *ilb_base_addr;
+static void __iomem *ilb_base_addr;
 
 static inline bool is_bsw(void)
 {
-- 
2.11.0
