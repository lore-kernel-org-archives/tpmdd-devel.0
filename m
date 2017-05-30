From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] char: tpm: fix potential null pointer dereference
Date: Tue, 30 May 2017 17:05:20 -0500
Message-ID: <20170530220520.GA8713@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: tpmdd-devel@lists.sourceforge.net

NULL check at line 376: if (!chip) {, implies chip might be NULL.
Function dev_get_drvdata() dereference pointer chip.
Move pointer tmp_dev assignment after the NULL check.

Addresses-Coverity-ID: 1397648
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 4d1dc8b..f45e8c7 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -367,7 +367,7 @@ static irqreturn_t tpm_ioserirq_handler(int irq, void *dev_id)
 static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 			 size_t len)
 {
-	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
+	struct st33zp24_dev *tpm_dev;
 	u32 status, i, size, ordinal;
 	int burstcnt = 0;
 	int ret;
@@ -382,6 +382,7 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 	if (ret < 0)
 		return ret;
 
+	tpm_dev = dev_get_drvdata(&chip->dev);
 	status = st33zp24_status(chip);
 	if ((status & TPM_STS_COMMAND_READY) == 0) {
 		st33zp24_cancel(chip);
-- 
2.5.0
