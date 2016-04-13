From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2] tpm: fix crash in tpm_tis deinitialization
Date: Wed, 13 Apr 2016 10:17:01 +0300
Message-ID: <1460531821-13919-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Fixes: 4d3eac5e156a ("tpm: Provide strong locking for device removal")
---
 drivers/char/tpm/tpm-chip.c | 3 +++
 drivers/char/tpm/tpm_crb.c  | 3 ---
 drivers/char/tpm/tpm_tis.c  | 3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index f62c851..2642cca 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -361,6 +361,9 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	if (!(chip->flags & TPM_CHIP_FLAG_REGISTERED))
 		return;
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_shutdown(chip, TPM2_SU_CLEAR);
+
 	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
 		sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
 
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
