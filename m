From: SZ Lin <sz.lin@moxa.com>
Subject: [PATCH 2/5] Fix "ERROR: code indent should use tabs where possible"
Date: Sat, 29 Jul 2017 15:24:30 +0800
Message-ID: <20170729072433.13194-3-sz.lin@moxa.com>
References: <20170729072433.13194-1-sz.lin@moxa.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170729072433.13194-1-sz.lin@moxa.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ashleydlai@gmail.com
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, peterhuewe@gmx.de, tpmdd@selhorst.ne, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, SZ Lin <sz.lin@moxa.com>
List-Id: tpmdd-devel@lists.sourceforge.net

ERROR: code indent should use tabs where possible
+^I^I         "Need to wait for TPM to finish\n");$

Signed-off-by: SZ Lin <sz.lin@moxa.com>
---
 drivers/char/tpm/tpm_ibmvtpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index f01d083eced2..23913fc86158 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -127,7 +127,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	if (ibmvtpm->tpm_processing_cmd) {
 		dev_info(ibmvtpm->dev,
-		         "Need to wait for TPM to finish\n");
+			"Need to wait for TPM to finish\n");
 		/* wait for previous command to finish */
 		sig = wait_event_interruptible(ibmvtpm->wq, !ibmvtpm->tpm_processing_cmd);
 		if (sig)
-- 
2.13.3
