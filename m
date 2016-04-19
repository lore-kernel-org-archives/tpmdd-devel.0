From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re:
 0001-added-tpm-2.0-support-to-nuvoton-i2c-driver.patch
Date: Tue, 19 Apr 2016 15:09:50 -0600
Message-ID: <20160419210950.GA28137@obsidianresearch.com>
References: <20160419050442.7048840F8@taln70.nuvoton.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160419050442.7048840F8-1UdtCKOZWuXOzY7siszIiwMMGMOHi2eC@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Andrew Zamansky (NTIL)" <Andrew.Zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Cc: shmulik.hager-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, dan.morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, --@taln70.nuvoton.co.il
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 19, 2016 at 08:04:42AM +0300, Andrew Zamansky (NTIL) wrote:
> >From b1503617a4c2b89f5a366a3d38b303b5de606c59 Mon Sep 17 00:00:00 2001
> From: andrew azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
> Date: Thu, 7 Apr 2016 09:19:57 +0300
> Subject: [PATCH 1/1] added tpm 2.0 support to nuvoton i2c driver
> 
> add tpm 2.0 support to nuvoton i2c tpm driver

Lets not keep duplicating this.

Can you test and use this patch as a pre-requsit for your nuvoton
change?

>From c8e65751b3b9e9337277291cd6bda278ed71939f Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Tue, 19 Apr 2016 15:06:55 -0600
Subject: [PATCH] tpm: Factor out common startup code

Provide some flags in tpm_class_ops to allow drivers to opt-in to the
common startup sequence. This is the sequence used by tpm_tis and
tpm_crb.

All drivers should set this flag.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index a7c99a284724..c2ee30451e41 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -505,6 +505,7 @@ static bool st33zp24_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops st33zp24_tpm = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.send = st33zp24_send,
 	.recv = st33zp24_recv,
 	.cancel = st33zp24_cancel,
@@ -592,9 +593,6 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
 		tpm_gen_interrupt(chip);
 	}
 
-	tpm_get_timeouts(chip);
-	tpm_do_selftest(chip);
-
 	return tpm_chip_register(chip);
 _tpm_clean_answer:
 	dev_info(&chip->dev, "TPM initialization fail\n");
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index f62c8518cd68..fd83f1ade5b9 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -315,6 +315,21 @@ int tpm_chip_register(struct tpm_chip *chip)
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
index 7cba092e3069..059292ba9322 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -844,6 +844,33 @@ int tpm_do_selftest(struct tpm_chip *chip)
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
index 8bc6fb85fb38..d3d3dd2edbe0 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -478,6 +478,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
 			 const char *desc);
 extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
+int tpm1_auto_startup(struct tpm_chip *chip);
 extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
 extern int tpm_pm_suspend(struct device *);
@@ -521,6 +522,7 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
 ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
 			u32 *value, const char *desc);
 
+int tpm2_auto_startup(struct tpm_chip *chip);
 extern int tpm2_startup(struct tpm_chip *chip, u16 startup_type);
 extern void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 9ce80313dae2..b9e782f21001 100644
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
+		rc = tpm2_startup(&chip->dev, TPM2_SU_CLEAR);
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
index 20155d55a62b..bba9209718a2 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -182,6 +182,7 @@ static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops tpm_crb = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = crb_status,
 	.recv = crb_recv,
 	.send = crb_send,
@@ -194,7 +195,6 @@ static const struct tpm_class_ops tpm_crb = {
 static int crb_init(struct acpi_device *device, struct crb_priv *priv)
 {
 	struct tpm_chip *chip;
-	int rc;
 
 	chip = tpmm_chip_alloc(&device->dev, &tpm_crb);
 	if (IS_ERR(chip))
@@ -204,14 +204,6 @@ static int crb_init(struct acpi_device *device, struct crb_priv *priv)
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
index c37aa7259f76..95ce2e9ccdc6 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -141,6 +141,7 @@ static bool i2c_atmel_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops i2c_atmel = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = i2c_atmel_read_status,
 	.recv = i2c_atmel_recv,
 	.send = i2c_atmel_send,
@@ -179,11 +180,6 @@ static int i2c_atmel_probe(struct i2c_client *client,
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
index a426b6f67d2e..62ee44e57ddc 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -567,6 +567,7 @@ static bool tpm_tis_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops tpm_tis_i2c = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = tpm_tis_i2c_status,
 	.recv = tpm_tis_i2c_recv,
 	.send = tpm_tis_i2c_send,
@@ -619,9 +620,6 @@ static int tpm_tis_i2c_init(struct device *dev)
 
 	tpm_dev.chip = chip;
 
-	tpm_get_timeouts(chip);
-	tpm_do_selftest(chip);
-
 	return tpm_chip_register(chip);
 out_release:
 	release_locality(chip, tpm_dev.locality, 1);
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 4e32094b761d..e8ff3623e465 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -461,6 +461,7 @@ static bool i2c_nuvoton_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops tpm_i2c = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = i2c_nuvoton_read_status,
 	.recv = i2c_nuvoton_recv,
 	.send = i2c_nuvoton_send,
@@ -609,12 +610,6 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
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
index 1e45e733df1a..11649824a1a2 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -551,6 +551,7 @@ static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 }
 
 static const struct tpm_class_ops tpm_tis = {
+	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = tpm_tis_status,
 	.recv = tpm_tis_recv,
 	.send = tpm_tis_send,
@@ -812,29 +813,6 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
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
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
