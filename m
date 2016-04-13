From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3] tpm: fix crash in tpm_tis deinitialization
Date: Wed, 13 Apr 2016 10:22:06 +0300
Message-ID: <1460532126-14435-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

rmmod crashes the driver because tpm_chip_unregister() already sets ops
to NULL. This commit fixes the issue by moving tpm2_shutdown() to
tpm_chip_unregister(). This commit is also cleanup because it removes
duplicate code from tpm_crb and tpm_tis to the core.

v2: make sending shutdown command atomic with nulling ops
v3: forgot to amend updates, sorry :(

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Fixes: 4d3eac5e156a ("tpm: Provide strong locking for device removal")
---
 drivers/char/tpm/tpm-chip.c | 1 +
 drivers/char/tpm/tpm.h      | 2 +-
 drivers/char/tpm/tpm2-cmd.c | 1 -
 drivers/char/tpm/tpm_crb.c  | 3 ---
 drivers/char/tpm/tpm_tis.c  | 3 ---
 5 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index f62c851..5bc530c 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -269,6 +269,7 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 
 	/* Make the driver uncallable. */
 	down_write(&chip->ops_sem);
+	tpm2_shutdown(chip, TPM2_SU_CLEAR);
 	chip->ops = NULL;
 	up_write(&chip->ops_sem);
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8bc6fb8..1156b34 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -522,7 +522,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
 			u32 *value, const char *desc);
 
 extern int tpm2_startup(struct tpm_chip *chip, u16 startup_type);
-extern void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
+void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
 extern int tpm2_do_selftest(struct tpm_chip *chip);
 extern int tpm2_gen_interrupt(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 9ce8031..a1673dc 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -773,7 +773,6 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
 		dev_warn(&chip->dev, "transmit returned %d while stopping the TPM",
 			 rc);
 }
-EXPORT_SYMBOL_GPL(tpm2_shutdown);
 
 /*
  * tpm2_calc_ordinal_duration() - maximum duration for a command
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 20155d5..c31b5a7 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -341,9 +341,6 @@ static int crb_acpi_remove(struct acpi_device *device)
 	struct device *dev = &device->dev;
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		tpm2_shutdown(chip, TPM2_SU_CLEAR);
-
 	tpm_chip_unregister(chip);
 
 	return 0;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 1e45e73..a6b2d46 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -681,9 +681,6 @@ static void tpm_tis_remove(struct tpm_chip *chip)
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 	void __iomem *reg = priv->iobase + TPM_INT_ENABLE(priv->locality);
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		tpm2_shutdown(chip, TPM2_SU_CLEAR);
-
 	iowrite32(~TPM_GLOBAL_INT_ENABLE & ioread32(reg), reg);
 	release_locality(chip, priv->locality, 1);
 }
-- 
2.7.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
