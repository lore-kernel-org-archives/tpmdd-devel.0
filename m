From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: declare tpm2_get_pcr_allocation() as static
Date: Wed, 15 Feb 2017 20:02:28 +0200
Message-ID: <20170215180228.25650-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

There's no need to export tpm2_get_pcr_alloation() because it is only
a helper function for tpm2_auto_startup(). For the same reason it does
not make much sense to maintain documentation for it.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm.h      |  1 -
 drivers/char/tpm/tpm2-cmd.c | 94 ++++++++++++++++++++++-----------------------
 2 files changed, 45 insertions(+), 50 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 6b4e7aa..4937b56 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -554,5 +554,4 @@ int tpm2_auto_startup(struct tpm_chip *chip);
 void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
-ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 10f97e6..881aea9 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -997,61 +997,13 @@ int tpm2_probe(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm2_probe);
 
-/**
- * tpm2_auto_startup - Perform the standard automatic TPM initialization
- *                     sequence
- * @chip: TPM chip to use
- *
- * Returns 0 on success, < 0 in case of fatal error.
- */
-int tpm2_auto_startup(struct tpm_chip *chip)
-{
-	int rc;
-
-	rc = tpm_get_timeouts(chip);
-	if (rc)
-		goto out;
-
-	rc = tpm2_do_selftest(chip);
-	if (rc != 0 && rc != TPM2_RC_INITIALIZE) {
-		dev_err(&chip->dev, "TPM self test failed\n");
-		goto out;
-	}
-
-	if (rc == TPM2_RC_INITIALIZE) {
-		rc = tpm2_startup(chip, TPM2_SU_CLEAR);
-		if (rc)
-			goto out;
-
-		rc = tpm2_do_selftest(chip);
-		if (rc) {
-			dev_err(&chip->dev, "TPM self test failed\n");
-			goto out;
-		}
-	}
-
-	rc = tpm2_get_pcr_allocation(chip);
-
-out:
-	if (rc > 0)
-		rc = -ENODEV;
-	return rc;
-}
-
 struct tpm2_pcr_selection {
 	__be16  hash_alg;
 	u8  size_of_select;
 	u8  pcr_select[3];
 } __packed;
 
-/**
- * tpm2_get_pcr_allocation() - get TPM active PCR banks.
- *
- * @chip: TPM chip to use.
- *
- * Return: Same as with tpm_transmit_cmd.
- */
-ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
+static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
 {
 	struct tpm2_pcr_selection pcr_selection;
 	struct tpm_buf buf;
@@ -1114,3 +1066,47 @@ ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
 
 	return rc;
 }
+
+/**
+ * tpm2_auto_startup - Perform the standard automatic TPM initialization
+ *                     sequence
+ * @chip: TPM chip to use
+ *
+ * Initializes timeout values for operation and command durations, conducts
+ * a self-test and reads the list of active PCR banks.
+ *
+ * Return: 0 on success. Otherwise, a system error code is returned.
+ */
+int tpm2_auto_startup(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = tpm_get_timeouts(chip);
+	if (rc)
+		goto out;
+
+	rc = tpm2_do_selftest(chip);
+	if (rc != 0 && rc != TPM2_RC_INITIALIZE) {
+		dev_err(&chip->dev, "TPM self test failed\n");
+		goto out;
+	}
+
+	if (rc == TPM2_RC_INITIALIZE) {
+		rc = tpm2_startup(chip, TPM2_SU_CLEAR);
+		if (rc)
+			goto out;
+
+		rc = tpm2_do_selftest(chip);
+		if (rc) {
+			dev_err(&chip->dev, "TPM self test failed\n");
+			goto out;
+		}
+	}
+
+	rc = tpm2_get_pcr_allocation(chip);
+
+out:
+	if (rc > 0)
+		rc = -ENODEV;
+	return rc;
+}
-- 
2.9.3
