From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: move struct tpm_class_ops to drivers/char/tpm/tpm.h
Date: Sat,  3 Sep 2016 00:48:03 +0300
Message-ID: <1472852886-7640-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The struct tpm_class_ops is not used outside the TPM driver. Thus,
it can be safely move to drivers/char/tpm/tpm.h.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm.h | 13 +++++++++++++
 include/linux/tpm.h    | 14 --------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 3e952fb..e1d277d 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -138,6 +138,19 @@ enum tpm2_startup_types {
 
 #define TPM_PPI_VERSION_LEN		3
 
+struct tpm_class_ops {
+	unsigned int flags;
+	const u8 req_complete_mask;
+	const u8 req_complete_val;
+	bool (*req_canceled)(struct tpm_chip *chip, u8 status);
+	int (*recv) (struct tpm_chip *chip, u8 *buf, size_t len);
+	int (*send) (struct tpm_chip *chip, u8 *buf, size_t len);
+	void (*cancel) (struct tpm_chip *chip);
+	u8 (*status) (struct tpm_chip *chip);
+	bool (*update_timeouts)(struct tpm_chip *chip,
+				unsigned long *timeout_cap);
+};
+
 enum tpm_chip_flags {
 	TPM_CHIP_FLAG_REGISTERED	= BIT(0),
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index da158f0..76ba592 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -37,20 +37,6 @@ enum TPM_OPS_FLAGS {
 	TPM_OPS_AUTO_STARTUP = BIT(0),
 };
 
-struct tpm_class_ops {
-	unsigned int flags;
-	const u8 req_complete_mask;
-	const u8 req_complete_val;
-	bool (*req_canceled)(struct tpm_chip *chip, u8 status);
-	int (*recv) (struct tpm_chip *chip, u8 *buf, size_t len);
-	int (*send) (struct tpm_chip *chip, u8 *buf, size_t len);
-	void (*cancel) (struct tpm_chip *chip);
-	u8 (*status) (struct tpm_chip *chip);
-	bool (*update_timeouts)(struct tpm_chip *chip,
-				unsigned long *timeout_cap);
-
-};
-
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_is_tpm2(u32 chip_num);
-- 
2.7.4
