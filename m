From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm_atmel: drop tpm_atmel specific fields
	from tpm_vendor_specific
Date: Wed, 23 Mar 2016 07:10:22 +0200
Message-ID: <1458709822-6677-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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

Introduced a private struct tpm_atmel_priv that contains the variables
have_region and region_size that were previously located in struct
tpm_vendor_specific. These fields were only used by tpm_atmel.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm.h       |  3 ---
 drivers/char/tpm/tpm_atmel.c | 23 +++++++++++++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4764545..cbab4e9 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -136,9 +136,6 @@ struct tpm_vendor_specific {
 
 	int irq;
 
-	int region_size;
-	int have_region;
-
 	struct list_head list;
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index a48a878..affc04b 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -35,6 +35,11 @@ enum tpm_atmel_read_status {
 	ATML_STATUS_READY = 0x08
 };
 
+struct tpm_atmel_priv {
+	int region_size;
+	int have_region;
+};
+
 static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	u8 status, *hdr = buf;
@@ -136,12 +141,13 @@ static struct platform_device *pdev;
 static void atml_plat_remove(void)
 {
 	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
+	struct tpm_atmel_priv *priv = chip->vendor.priv;
 
 	if (chip) {
 		tpm_chip_unregister(chip);
-		if (chip->vendor.have_region)
+		if (priv->have_region)
 			atmel_release_region(chip->vendor.base,
-					     chip->vendor.region_size);
+					     priv->region_size);
 		atmel_put_base_addr(chip->vendor.iobase);
 		platform_device_unregister(pdev);
 	}
@@ -163,6 +169,7 @@ static int __init init_atmel(void)
 	int have_region, region_size;
 	unsigned long base;
 	struct  tpm_chip *chip;
+	struct tpm_atmel_priv *priv;
 
 	rc = platform_driver_register(&atml_drv);
 	if (rc)
@@ -183,6 +190,15 @@ static int __init init_atmel(void)
 		goto err_rel_reg;
 	}
 
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		rc = -ENOMEM;
+		goto err_unreg_dev;
+	}
+
+	priv->have_region = have_region;
+	priv->region_size = region_size;
+
 	chip = tpmm_chip_alloc(&pdev->dev, &tpm_atmel);
 	if (IS_ERR(chip)) {
 		rc = PTR_ERR(chip);
@@ -191,8 +207,7 @@ static int __init init_atmel(void)
 
 	chip->vendor.iobase = iobase;
 	chip->vendor.base = base;
-	chip->vendor.have_region = have_region;
-	chip->vendor.region_size = region_size;
+	chip->vendor.priv = priv;
 
 	rc = tpm_chip_register(chip);
 	if (rc)
-- 
2.7.3


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
