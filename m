From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2] tpm: Factor out common startup code
Date: Mon, 16 May 2016 12:25:47 -0600
Message-ID: <1463423147-9874-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Provide some flags in tpm_class_ops to allow drivers to opt-in to the
common startup sequence. This is the sequence used by tpm_tis and
tpm_crb.

All drivers should set this flag.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Tested-by: Andrew Zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c |  4 +---
 drivers/char/tpm/tpm-chip.c          | 15 ++++++++++++++
 drivers/char/tpm/tpm-interface.c     | 27 ++++++++++++++++++++++++
 drivers/char/tpm/tpm.h               |  2 ++
 drivers/char/tpm/tpm2-cmd.c          | 40 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_crb.c           | 10 +--------
 drivers/char/tpm/tpm_i2c_atmel.c     |  6 +-----
 drivers/char/tpm/tpm_i2c_infineon.c  |  4 +---
 drivers/char/tpm/tpm_i2c_nuvoton.c   |  7 +------
 drivers/char/tpm/tpm_tis.c           | 24 +---------------------
 include/linux/tpm.h                  |  6 ++++++
 11 files changed, 96 insertions(+), 49 deletions(-)

v2 has a little typo fix From Andrew in the call to tpm2_startup

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 8d626784cd8d..4556c95f83cb 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -532,6 +532,7 @@ static bool st33zp24_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops st33zp24_tpm = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.send = st33zp24_send,
 	.recv = st33zp24_recv,
 	.cancel = st33zp24_cancel,
@@ -618,9 +619,6 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
 		tpm_gen_interrupt(chip);
 	}
 
-	tpm_get_timeouts(chip);
-	tpm_do_selftest(chip);
-
 	return tpm_chip_register(chip);
 _tpm_clean_answer:
 	dev_info(&chip->dev, "TPM initialization fail\n");
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 274dd0123237..9a36cedd94eb 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -223,6 +223,21 @@ int tpm_chip_register(struct tpm_chip *chip)
 {
 	int rc;
 
+	if (chip->ops->flags & TPM_OPS_PROBE_TPM2) {
+		rc = tpm2_probe(chip);
+		if (rc)
+			return rc;
+	}
+
+	if (chip->ops->flags & TPM_OPS_AUTO_STARTUP) {
+		if (chip->flags & TPM_CHIP_FLAG_TPM2)
+			rc = tpm2_auto_startup(chip);
+		else
+			rc = tpm1_auto_startup(chip);
+		if (rc)
+			return rc;
+	}
+
 	rc = tpm1_chip_register(chip);
 	if (rc)
 		return rc;
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index e2fa89c88304..4e6798ab3a90 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -842,6 +842,33 @@ int tpm_do_selftest(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm_do_selftest);
 
+/**
+ * tpm1_auto_startup - Perform the standard automatic TPM initialization
+ *                     sequence
+ * @chip: TPM chip to use
+ *
+ * Returns 0 on success, < 0 in case of fatal error.
+ */
+int tpm1_auto_startup(struct tpm_chip *chip)
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
 int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 {
 	struct tpm_chip *chip;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 28b477e8da6a..a99105f1a5c4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -501,6 +501,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
 			 const char *desc);
 extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
+int tpm1_auto_startup(struct tpm_chip *chip);
 extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
 extern int tpm_pm_suspend(struct device *);
@@ -539,6 +540,7 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
 ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
 			u32 *value, const char *desc);
 
+int tpm2_auto_startup(struct tpm_chip *chip);
 extern int tpm2_startup(struct tpm_chip *chip, u16 startup_type);
 extern void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index b28e4da3d2cf..984190e551a1 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -943,3 +943,43 @@ int tpm2_probe(struct tpm_chip *chip)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm2_probe);
+
+/**
+ * tpm2_auto_startup - Perform the standard automatic TPM initialization
+ *                     sequence
+ * @chip: TPM chip to use
+ *
+ * Returns 0 on success, < 0 in case of fatal error.
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
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index a12b31940344..80c4af05d259 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -189,6 +189,7 @@ static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops tpm_crb = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = crb_status,
 	.recv = crb_recv,
 	.send = crb_send,
@@ -201,7 +202,6 @@ static const struct tpm_class_ops tpm_crb = {
 static int crb_init(struct acpi_device *device, struct crb_priv *priv)
 {
 	struct tpm_chip *chip;
-	int rc;
 
 	chip = tpmm_chip_alloc(&device->dev, &tpm_crb);
 	if (IS_ERR(chip))
@@ -211,14 +211,6 @@ static int crb_init(struct acpi_device *device, struct crb_priv *priv)
 	chip->acpi_dev_handle = device->handle;
 	chip->flags = TPM_CHIP_FLAG_TPM2;
 
-	rc = tpm_get_timeouts(chip);
-	if (rc)
-		return rc;
-
-	rc = tpm2_do_selftest(chip);
-	if (rc)
-		return rc;
-
 	return tpm_chip_register(chip);
 }
 
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 8dfb88b9739c..6f7c73de7c59 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -141,6 +141,7 @@ static bool i2c_atmel_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops i2c_atmel = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = i2c_atmel_read_status,
 	.recv = i2c_atmel_recv,
 	.send = i2c_atmel_send,
@@ -178,11 +179,6 @@ static int i2c_atmel_probe(struct i2c_client *client,
 	/* There is no known way to probe for this device, and all version
 	 * information seems to be read via TPM commands. Thus we rely on the
 	 * TPM startup process in the common code to detect the device. */
-	if (tpm_get_timeouts(chip))
-		return -ENODEV;
-
-	if (tpm_do_selftest(chip))
-		return -ENODEV;
 
 	return tpm_chip_register(chip);
 }
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 63d5d22e9e60..e08633e140cf 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -566,6 +566,7 @@ static bool tpm_tis_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops tpm_tis_i2c = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = tpm_tis_i2c_status,
 	.recv = tpm_tis_i2c_recv,
 	.send = tpm_tis_i2c_send,
@@ -622,9 +623,6 @@ static int tpm_tis_i2c_init(struct device *dev)
 	INIT_LIST_HEAD(&chip->vendor.list);
 	tpm_dev.chip = chip;
 
-	tpm_get_timeouts(chip);
-	tpm_do_selftest(chip);
-
 	return tpm_chip_register(chip);
 out_release:
 	release_locality(chip, chip->vendor.locality, 1);
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 847f1597fe9b..b64effcf3235 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -456,6 +456,7 @@ static bool i2c_nuvoton_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops tpm_i2c = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = i2c_nuvoton_read_status,
 	.recv = i2c_nuvoton_recv,
 	.send = i2c_nuvoton_send,
@@ -601,12 +602,6 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 		}
 	}
 
-	if (tpm_get_timeouts(chip))
-		return -ENODEV;
-
-	if (tpm_do_selftest(chip))
-		return -ENODEV;
-
 	return tpm_chip_register(chip);
 }
 
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a507006728e0..30aff5bab68c 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -524,6 +524,7 @@ static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops tpm_tis = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = tpm_tis_status,
 	.recv = tpm_tis_recv,
 	.send = tpm_tis_send,
@@ -785,29 +786,6 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 			tpm_tis_probe_irq(chip, intmask);
 	}
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		rc = tpm2_do_selftest(chip);
-		if (rc == TPM2_RC_INITIALIZE) {
-			dev_warn(dev, "Firmware has not started TPM\n");
-			rc  = tpm2_startup(chip, TPM2_SU_CLEAR);
-			if (!rc)
-				rc = tpm2_do_selftest(chip);
-		}
-
-		if (rc) {
-			dev_err(dev, "TPM self test failed\n");
-			if (rc > 0)
-				rc = -ENODEV;
-			goto out_err;
-		}
-	} else {
-		if (tpm_do_selftest(chip)) {
-			dev_err(dev, "TPM self test failed\n");
-			rc = -ENODEV;
-			goto out_err;
-		}
-	}
-
 	return tpm_chip_register(chip);
 out_err:
 	tpm_tis_remove(chip);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 706e63eea080..011547097f5b 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -33,7 +33,13 @@ struct tpm_chip;
 struct trusted_key_payload;
 struct trusted_key_options;
 
+enum TPM_OPS_FLAGS {
+	TPM_OPS_PROBE_TPM2 = BIT(0),
+	TPM_OPS_AUTO_STARTUP = BIT(1),
+};
+
 struct tpm_class_ops {
+	unsigned int flags;
 	const u8 req_complete_mask;
 	const u8 req_complete_val;
 	bool (*req_canceled)(struct tpm_chip *chip, u8 status);
-- 
2.1.4


------------------------------------------------------------------------------
Mobile security can be enabling, not merely restricting. Employees who
bring their own devices (BYOD) to work are irked by the imposition of MDM
restrictions. Mobile Device Manager Plus allows you to control only the
apps on BYO-devices by containerizing them, leaving personal data untouched!
https://ad.doubleclick.net/ddm/clk/304595813;131938128;j
