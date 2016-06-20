From: andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/4 v2] move tpm auto startup functions
Date: Mon, 20 Jun 2016 13:07:08 +0300
Message-ID: <1466417229-16734-4-git-send-email-andrew.zamansky@nuvoton.com>
References: <1466417229-16734-1-git-send-email-andrew.zamansky@nuvoton.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1466417229-16734-1-git-send-email-andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, azamansk-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

move tpm auto startup functions to tpm-chip.c as static functions

Signed-off-by: Andrew Azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c      | 68 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-interface.c | 25 ---------------
 drivers/char/tpm/tpm.h           |  4 ---
 drivers/char/tpm/tpm2-cmd.c      | 38 ----------------------
 4 files changed, 68 insertions(+), 67 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 9a36ced..3ad4e7f 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -208,6 +208,74 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
 	tpm_sysfs_del_device(chip);
 }
 
+/**
+ * tpm1_auto_startup - Perform the standard automatic TPM initialization
+ *                     sequence
+ * @chip: TPM chip to use
+ *
+ * Returns 0 on success, < 0 in case of fatal error.
+ */
+static int tpm1_auto_startup(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = tpm_get_timeouts(chip);
+	if (rc)
+		goto out;
+	rc = tpm_do_selftest(chip);
+	if (rc) {
+		dev_err(&chip->dev, "TPM self test failed\n");
+		goto out;
+	}
+
+	return rc;
+out:
+	if (rc > 0)
+		rc = -ENODEV;
+	return rc;
+}
+
+
+/**
+ * tpm2_auto_startup - Perform the standard automatic TPM initialization
+ *                     sequence
+ * @chip: TPM chip to use
+ *
+ * Returns 0 on success, < 0 in case of fatal error.
+ */
+static int tpm2_auto_startup(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = tpm_get_timeouts(chip);
+	if (rc)
+		goto out;
+
+	rc = tpm2_do_selftest(chip);
+	if (rc != TPM2_RC_INITIALIZE) {
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
+	return rc;
+out:
+	if (rc > 0)
+		rc = -ENODEV;
+	return rc;
+}
+
 /*
  * tpm_chip_register() - create a character device for the TPM chip
  * @chip: TPM chip to use.
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 4e6798a..a716d59 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -842,32 +842,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm_do_selftest);
 
-/**
- * tpm1_auto_startup - Perform the standard automatic TPM initialization
- *                     sequence
- * @chip: TPM chip to use
- *
- * Returns 0 on success, < 0 in case of fatal error.
- */
-int tpm1_auto_startup(struct tpm_chip *chip)
-{
-	int rc;
-
-	rc = tpm_get_timeouts(chip);
-	if (rc)
-		goto out;
-	rc = tpm_do_selftest(chip);
-	if (rc) {
-		dev_err(&chip->dev, "TPM self test failed\n");
-		goto out;
-	}
 
-	return rc;
-out:
-	if (rc > 0)
-		rc = -ENODEV;
-	return rc;
-}
 
 int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 {
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index a99105f..affe506 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -501,7 +501,6 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
 			 const char *desc);
 extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
-int tpm1_auto_startup(struct tpm_chip *chip);
 extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
 extern int tpm_pm_suspend(struct device *);
@@ -537,10 +536,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 int tpm2_unseal_trusted(struct tpm_chip *chip,
 			struct trusted_key_payload *payload,
 			struct trusted_key_options *options);
-ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
-			u32 *value, const char *desc);
 
-int tpm2_auto_startup(struct tpm_chip *chip);
 extern int tpm2_startup(struct tpm_chip *chip, u16 startup_type);
 extern void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 984190e..8221d05 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -944,42 +944,4 @@ int tpm2_probe(struct tpm_chip *chip)
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
 
-	rc = tpm_get_timeouts(chip);
-	if (rc)
-		goto out;
-
-	rc = tpm2_do_selftest(chip);
-	if (rc != TPM2_RC_INITIALIZE) {
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
-	return rc;
-out:
-	if (rc > 0)
-		rc = -ENODEV;
-	return rc;
-}
-- 
1.9.1


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://sdm.link/zohomanageengine
