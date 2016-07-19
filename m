From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v3 1/5] tpm: remove unnecessary externs from tpm.h
Date: Tue, 19 Jul 2016 16:32:45 +0300
Message-ID: <1468935171-7815-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1468935171-7815-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1468935171-7815-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Removed unnecessary externs from tpm.h.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm.h | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 3e32d5b..8b864dd 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -482,26 +482,26 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		     size_t bufsiz);
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
 			 const char *desc);
-extern int tpm_get_timeouts(struct tpm_chip *);
-extern void tpm_gen_interrupt(struct tpm_chip *);
+int tpm_get_timeouts(struct tpm_chip *chip);
+void tpm_gen_interrupt(struct tpm_chip *chip);
 int tpm1_auto_startup(struct tpm_chip *chip);
-extern int tpm_do_selftest(struct tpm_chip *);
-extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
-extern int tpm_pm_suspend(struct device *);
-extern int tpm_pm_resume(struct device *);
-extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
-			     wait_queue_head_t *, bool);
+int tpm_do_selftest(struct tpm_chip *chip);
+unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
+int tpm_pm_suspend(struct device *dev);
+int tpm_pm_resume(struct device *dev);
+int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
+		      wait_queue_head_t *queue, bool check_cancel);
 
 struct tpm_chip *tpm_chip_find_get(int chip_num);
 __must_check int tpm_try_get_ops(struct tpm_chip *chip);
 void tpm_put_ops(struct tpm_chip *chip);
 
-extern struct tpm_chip *tpm_chip_alloc(struct device *dev,
-				       const struct tpm_class_ops *ops);
-extern struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
-				       const struct tpm_class_ops *ops);
-extern int tpm_chip_register(struct tpm_chip *chip);
-extern void tpm_chip_unregister(struct tpm_chip *chip);
+struct tpm_chip *tpm_chip_alloc(struct device *dev,
+				const struct tpm_class_ops *ops);
+struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
+				 const struct tpm_class_ops *ops);
+int tpm_chip_register(struct tpm_chip *chip);
+void tpm_chip_unregister(struct tpm_chip *chip);
 
 void tpm_sysfs_add_device(struct tpm_chip *chip);
 
@@ -528,8 +528,8 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
 			u32 *value, const char *desc);
 
 int tpm2_auto_startup(struct tpm_chip *chip);
-extern void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
-extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
-extern int tpm2_gen_interrupt(struct tpm_chip *chip);
-extern int tpm2_probe(struct tpm_chip *chip);
+void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
+unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
+int tpm2_gen_interrupt(struct tpm_chip *chip);
+int tpm2_probe(struct tpm_chip *chip);
 #endif
-- 
2.7.4

