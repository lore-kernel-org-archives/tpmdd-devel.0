From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] char: tpm: remove unnecessary code
Date: Tue, 30 May 2017 19:05:57 -0500
Message-ID: <20170531000557.GA3301@embeddedgus>
References: <20170530174027.Horde.AYiQnLwlE09KhkcqzdNaVTk@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170530174027.Horde.AYiQnLwlE09KhkcqzdNaVTk@gator4166.hostgator.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Remove unnecessary code.
Pointer chip cannot be NULL in st33zp24_send().

Addresses-Coverity-ID: 1397648
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 4d1dc8b..ca74c24 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -373,8 +373,6 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 	int ret;
 	u8 data;
 
-	if (!chip)
-		return -EBUSY;
 	if (len < TPM_HEADER_SIZE)
 		return -EBUSY;
 
-- 
2.5.0
