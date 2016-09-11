From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix buffer overflow in /dev/tpm0
Date: Sun, 11 Sep 2016 15:19:00 +0300
Message-ID: <1473596340-11376-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

tpm_write() does not check whether the buffer has at least enough space
for the header before passing it to tpm_transmit() so an overflow can
happen.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index fd863ff..6a67f7f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -337,6 +337,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	u32 count, ordinal;
 	unsigned long stop;
 
+	if (bufsiz < TPM_HEADER_SIZE)
+		return -EINVAL;
+
 	if (bufsiz > TPM_BUFSIZE)
 		bufsiz = TPM_BUFSIZE;
 
-- 
2.7.4
