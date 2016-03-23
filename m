From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: drop 'base' from struct
	tpm_vendor_specific
Date: Wed, 23 Mar 2016 08:16:09 +0200
Message-ID: <1458713769-11800-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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

Dropped the field 'base' from struct tpm_vendor_specific and migrated
it to the private structures of tpm_atmel and tpm_nsc.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_atmel.c |  6 ++---
 drivers/char/tpm/tpm_atmel.h |  7 ++++--
 drivers/char/tpm/tpm_nsc.c   | 57 +++++++++++++++++++++++++++++---------------
 3 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index affc04b..c6daf6c 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -36,6 +36,7 @@ enum tpm_atmel_read_status {
 };
 
 struct tpm_atmel_priv {
+	unsigned long base;
 	int region_size;
 	int have_region;
 };
@@ -146,8 +147,7 @@ static void atml_plat_remove(void)
 	if (chip) {
 		tpm_chip_unregister(chip);
 		if (priv->have_region)
-			atmel_release_region(chip->vendor.base,
-					     priv->region_size);
+			atmel_release_region(priv->base, priv->region_size);
 		atmel_put_base_addr(chip->vendor.iobase);
 		platform_device_unregister(pdev);
 	}
@@ -196,6 +196,7 @@ static int __init init_atmel(void)
 		goto err_unreg_dev;
 	}
 
+	priv->base = base;
 	priv->have_region = have_region;
 	priv->region_size = region_size;
 
@@ -206,7 +207,6 @@ static int __init init_atmel(void)
 	}
 
 	chip->vendor.iobase = iobase;
-	chip->vendor.base = base;
 	chip->vendor.priv = priv;
 
 	rc = tpm_chip_register(chip);
diff --git a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel.h
index 6c831f9..08607a6 100644
--- a/drivers/char/tpm/tpm_atmel.h
+++ b/drivers/char/tpm/tpm_atmel.h
@@ -22,6 +22,8 @@
  *
  */
 
+#define atmel_get_priv(chip) ((struct tpm_atmel_priv *) chip->vendor.priv)
+
 #ifdef CONFIG_PPC64
 
 #include <asm/prom.h>
@@ -78,8 +80,9 @@ static void __iomem * atmel_get_base_addr(unsigned long *base, int *region_size)
 	return ioremap(*base, *region_size);
 }
 #else
-#define atmel_getb(chip, offset) inb(chip->vendor->base + offset)
-#define atmel_putb(val, chip, offset) outb(val, chip->vendor->base + offset)
+#define atmel_getb(chip, offset) inb(atmel_get_priv(chip)->base + offset)
+#define atmel_putb(val, chip, offset) \
+	outb(val, atmel_get_priv(chip)->base + offset)
 #define atmel_request_region request_region
 #define atmel_release_region release_region
 /* Atmel definitions */
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 766370b..8ccb1d5 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -64,6 +64,13 @@ enum tpm_nsc_cmd_mode {
 	NSC_COMMAND_EOC = 0x03,
 	NSC_COMMAND_CANCEL = 0x22
 };
+
+struct tpm_nsc_priv {
+	unsigned long base;
+};
+
+#define tpm_nsc_get_priv(chip) ((struct tpm_nsc_priv *) chip->vendor.priv)
+
 /*
  * Wait for a certain status to appear
  */
@@ -72,7 +79,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, u8 val, u8 * data)
 	unsigned long stop;
 
 	/* status immediately available check */
-	*data = inb(chip->vendor.base + NSC_STATUS);
+	*data = inb(tpm_nsc_get_priv(chip)->base + NSC_STATUS);
 	if ((*data & mask) == val)
 		return 0;
 
@@ -80,7 +87,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, u8 val, u8 * data)
 	stop = jiffies + 10 * HZ;
 	do {
 		msleep(TPM_TIMEOUT);
-		*data = inb(chip->vendor.base + 1);
+		*data = inb(tpm_nsc_get_priv(chip)->base + 1);
 		if ((*data & mask) == val)
 			return 0;
 	}
@@ -95,9 +102,9 @@ static int nsc_wait_for_ready(struct tpm_chip *chip)
 	unsigned long stop;
 
 	/* status immediately available check */
-	status = inb(chip->vendor.base + NSC_STATUS);
+	status = inb(tpm_nsc_get_priv(chip)->base + NSC_STATUS);
 	if (status & NSC_STATUS_OBF)
-		status = inb(chip->vendor.base + NSC_DATA);
+		status = inb(tpm_nsc_get_priv(chip)->base + NSC_DATA);
 	if (status & NSC_STATUS_RDY)
 		return 0;
 
@@ -105,9 +112,9 @@ static int nsc_wait_for_ready(struct tpm_chip *chip)
 	stop = jiffies + 100;
 	do {
 		msleep(TPM_TIMEOUT);
-		status = inb(chip->vendor.base + NSC_STATUS);
+		status = inb(tpm_nsc_get_priv(chip)->base + NSC_STATUS);
 		if (status & NSC_STATUS_OBF)
-			status = inb(chip->vendor.base + NSC_DATA);
+			status = inb(tpm_nsc_get_priv(chip)->base + NSC_DATA);
 		if (status & NSC_STATUS_RDY)
 			return 0;
 	}
@@ -132,8 +139,9 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 		dev_err(&chip->dev, "F0 timeout\n");
 		return -EIO;
 	}
-	if ((data =
-	     inb(chip->vendor.base + NSC_DATA)) != NSC_COMMAND_NORMAL) {
+
+	data = inb(tpm_nsc_get_priv(chip)->base + NSC_DATA);
+	if (data != NSC_COMMAND_NORMAL) {
 		dev_err(&chip->dev, "not in normal mode (0x%x)\n",
 			data);
 		return -EIO;
@@ -149,7 +157,7 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 		}
 		if (data & NSC_STATUS_F0)
 			break;
-		*p = inb(chip->vendor.base + NSC_DATA);
+		*p = inb(tpm_nsc_get_priv(chip)->base + NSC_DATA);
 	}
 
 	if ((data & NSC_STATUS_F0) == 0 &&
@@ -157,7 +165,9 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 		dev_err(&chip->dev, "F0 not set\n");
 		return -EIO;
 	}
-	if ((data = inb(chip->vendor.base + NSC_DATA)) != NSC_COMMAND_EOC) {
+
+	data = inb(tpm_nsc_get_priv(chip)->base + NSC_DATA);
+	if (data != NSC_COMMAND_EOC) {
 		dev_err(&chip->dev,
 			"expected end of command(0x%x)\n", data);
 		return -EIO;
@@ -183,7 +193,7 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
 	 * fix it. Not sure why this is needed, we followed the flow
 	 * chart in the manual to the letter.
 	 */
-	outb(NSC_COMMAND_CANCEL, chip->vendor.base + NSC_COMMAND);
+	outb(NSC_COMMAND_CANCEL, tpm_nsc_get_priv(chip)->base + NSC_COMMAND);
 
 	if (nsc_wait_for_ready(chip) != 0)
 		return -EIO;
@@ -193,7 +203,7 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
 		return -EIO;
 	}
 
-	outb(NSC_COMMAND_NORMAL, chip->vendor.base + NSC_COMMAND);
+	outb(NSC_COMMAND_NORMAL, tpm_nsc_get_priv(chip)->base + NSC_COMMAND);
 	if (wait_for_stat(chip, NSC_STATUS_IBR, NSC_STATUS_IBR, &data) < 0) {
 		dev_err(&chip->dev, "IBR timeout\n");
 		return -EIO;
@@ -205,26 +215,26 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
 				"IBF timeout (while writing data)\n");
 			return -EIO;
 		}
-		outb(buf[i], chip->vendor.base + NSC_DATA);
+		outb(buf[i], tpm_nsc_get_priv(chip)->base + NSC_DATA);
 	}
 
 	if (wait_for_stat(chip, NSC_STATUS_IBF, 0, &data) < 0) {
 		dev_err(&chip->dev, "IBF timeout\n");
 		return -EIO;
 	}
-	outb(NSC_COMMAND_EOC, chip->vendor.base + NSC_COMMAND);
+	outb(NSC_COMMAND_EOC, tpm_nsc_get_priv(chip)->base + NSC_COMMAND);
 
 	return count;
 }
 
 static void tpm_nsc_cancel(struct tpm_chip *chip)
 {
-	outb(NSC_COMMAND_CANCEL, chip->vendor.base + NSC_COMMAND);
+	outb(NSC_COMMAND_CANCEL, tpm_nsc_get_priv(chip)->base + NSC_COMMAND);
 }
 
 static u8 tpm_nsc_status(struct tpm_chip *chip)
 {
-	return inb(chip->vendor.base + NSC_STATUS);
+	return inb(tpm_nsc_get_priv(chip)->base + NSC_STATUS);
 }
 
 static bool tpm_nsc_req_canceled(struct tpm_chip *chip, u8 status)
@@ -249,7 +259,7 @@ static void tpm_nsc_remove(struct device *dev)
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	tpm_chip_unregister(chip);
-	release_region(chip->vendor.base, 2);
+	release_region(tpm_nsc_get_priv(chip)->base, 2);
 }
 
 static SIMPLE_DEV_PM_OPS(tpm_nsc_pm, tpm_pm_suspend, tpm_pm_resume);
@@ -268,6 +278,7 @@ static int __init init_nsc(void)
 	int nscAddrBase = TPM_ADDR;
 	struct tpm_chip *chip;
 	unsigned long base;
+	struct tpm_nsc_priv *priv;
 
 	/* verify that it is a National part (SID) */
 	if (tpm_read_index(TPM_ADDR, NSC_SID_INDEX) != 0xEF) {
@@ -301,6 +312,14 @@ static int __init init_nsc(void)
 	if ((rc = platform_device_add(pdev)) < 0)
 		goto err_put_dev;
 
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		rc = -ENOMEM;
+		goto err_del_dev;
+	}
+
+	priv->base = base;
+
 	if (request_region(base, 2, "tpm_nsc0") == NULL ) {
 		rc = -EBUSY;
 		goto err_del_dev;
@@ -312,6 +331,8 @@ static int __init init_nsc(void)
 		goto err_rel_reg;
 	}
 
+	chip->vendor.priv = priv;
+
 	rc = tpm_chip_register(chip);
 	if (rc)
 		goto err_rel_reg;
@@ -349,8 +370,6 @@ static int __init init_nsc(void)
 		 "NSC TPM revision %d\n",
 		 tpm_read_index(nscAddrBase, 0x27) & 0x1F);
 
-	chip->vendor.base = base;
-
 	return 0;
 
 err_rel_reg:
-- 
2.7.3


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
