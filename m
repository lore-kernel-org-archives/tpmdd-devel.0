From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: drop the field 'time_expired' from struct tpm_chip
Date: Wed, 23 Mar 2016 08:23:39 +0200
Message-ID: <1458714219-26721-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Removed the field because it is not used for anything.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 09302ab..3c4e5eb 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -175,7 +175,6 @@ struct tpm_chip {
 
 	int dev_num;		/* /dev/tpm# */
 	unsigned long is_open;	/* only one allowed */
-	int time_expired;
 
 	struct mutex tpm_mutex;	/* tpm is processing */
 
-- 
2.7.3
