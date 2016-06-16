From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: unify tpm_gen_interrupt() and fix error handling
Date: Thu, 16 Jun 2016 12:43:27 +0200
Message-ID: <1466073808-5567-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Migrated into single tpm_gen_interrupt() function and cleaned up the
whole construction in general because it was starting to turn into a
train wreck.

Made the following updates:

* Use tpm_getcap() for TPM 1.x instead of creating an ad-hoc protocol
  message.
* Return the error code back to the caller.
* Updated tpm_tis to fail in the case of a system error.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 25 +++++++++++++++----------
 drivers/char/tpm/tpm.h           |  3 +--
 drivers/char/tpm/tpm2-cmd.c      | 17 -----------------
 drivers/char/tpm/tpm_tis_core.c  |  7 +++----
 4 files changed, 19 insertions(+), 33 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 5e3c1b6..4aeacf3 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -459,18 +459,23 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
 	return rc;
 }
 
-void tpm_gen_interrupt(struct tpm_chip *chip)
+/**
+ * tpm_gen_interrupt -- generate an interrupt by issuing an idempotent command
+ * @chip: TPM chip to use
+ *
+ * Returns 0 on success, < 0 in case of fatal error or a value > 0 representing
+ * a TPM error code.
+ */
+int tpm_gen_interrupt(struct tpm_chip *chip)
 {
-	struct	tpm_cmd_t tpm_cmd;
-	ssize_t rc;
+	const char *desc = "attempting to generate an interrupt";
+	u32 cap2;
+	cap_t cap;
 
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			      "attempting to determine the timeouts");
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
+	else
+		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8890df2..de93535 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -483,7 +483,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
 			 const char *desc);
 extern int tpm_get_timeouts(struct tpm_chip *);
-extern void tpm_gen_interrupt(struct tpm_chip *);
+int tpm_gen_interrupt(struct tpm_chip *);
 extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
 extern int tpm_pm_suspend(struct device *);
@@ -530,6 +530,5 @@ extern int tpm2_startup(struct tpm_chip *chip, u16 startup_type);
 extern void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
 extern int tpm2_do_selftest(struct tpm_chip *chip);
-extern int tpm2_gen_interrupt(struct tpm_chip *chip);
 extern int tpm2_probe(struct tpm_chip *chip);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index a1673dc..77ef027 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -897,23 +897,6 @@ int tpm2_do_selftest(struct tpm_chip *chip)
 EXPORT_SYMBOL_GPL(tpm2_do_selftest);
 
 /**
- * tpm2_gen_interrupt() - generate an interrupt
- * @chip: TPM chip to use
- *
- * 0 is returned when the operation is successful. If a negative number is
- * returned it remarks a POSIX error code. If a positive number is returned
- * it remarks a TPM error.
- */
-int tpm2_gen_interrupt(struct tpm_chip *chip)
-{
-	u32 dummy;
-
-	return tpm2_get_tpm_pt(chip, 0x100, &dummy,
-			       "attempting to generate an interrupt");
-}
-EXPORT_SYMBOL_GPL(tpm2_gen_interrupt);
-
-/**
  * tpm2_probe() - probe TPM 2.0
  * @chip: TPM chip to use
  *
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 03a06b3..79168ca 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -580,10 +580,9 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	/* Generate an interrupt by having the core call through to
 	 * tpm_tis_send
 	 */
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		tpm2_gen_interrupt(chip);
-	else
-		tpm_gen_interrupt(chip);
+	rc = tpm_gen_interrupt(chip);
+	if (rc < 0)
+		return rc;
 
 	/* tpm_tis_send will either confirm the interrupt is working or it
 	 * will call disable_irq which undoes all of the above.
-- 
2.7.4

