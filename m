From: Azhar Shaikh <azhar.shaikh@intel.com>
Subject: [PATCH v5 2/2] tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()
Date: Mon, 27 Nov 2017 16:04:20 -0800
Message-ID: <1511827460-29941-3-git-send-email-azhar.shaikh@intel.com>
References: <1511827460-29941-1-git-send-email-azhar.shaikh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511827460-29941-1-git-send-email-azhar.shaikh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, peterhuewe@gmx.de
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, azhar.shaikh@intel.com
List-Id: tpmdd-devel@lists.sourceforge.net

Commit 5e572cab92f0bb5 ("tpm: Enable CLKRUN protocol for Braswell
systems") disabled CLKRUN protocol during TPM transactions and re-enabled
once the transaction is completed. But there were still some corner cases
observed where, reading of TPM header failed for savestate command
while going to suspend, which resulted in suspend failure.
To fix this issue keep the CLKRUN protocol disabled for the entire
duration of a single TPM command and not disabling and re-enabling
again for every TPM transaction. For the other TPM accesses outside
the flow of TPM command processing, disable and re-enable CLKRUN protocol
for every TPM access.

Fixes: 5e572cab92f0bb5 ("tpm: Enable CLKRUN protocol for Braswell systems")

Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
---
 drivers/char/tpm/tpm-interface.c |  6 +++
 drivers/char/tpm/tpm_tis.c       | 86 +++++-------------------------------
 drivers/char/tpm/tpm_tis_core.c  | 95 +++++++++++++++++++++++++++++++++++++---
 drivers/char/tpm/tpm_tis_core.h  |  4 ++
 include/linux/tpm.h              |  1 +
 5 files changed, 111 insertions(+), 81 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index ebe0a1d36d8c..6e19e3dd98e4 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -413,6 +413,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	if (chip->dev.parent)
 		pm_runtime_get_sync(chip->dev.parent);
 
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, true);
+
 	/* Store the decision as chip->locality will be changed. */
 	need_locality = chip->locality == -1;
 
@@ -489,6 +492,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 		chip->locality = -1;
 	}
 out_no_locality:
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, false);
+
 	if (chip->dev.parent)
 		pm_runtime_put_sync(chip->dev.parent);
 
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 923f8f2cbaca..d29add49b033 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -133,79 +133,17 @@ static int check_acpi_tpm2(struct device *dev)
 }
 #endif
 
-#ifdef CONFIG_X86
-#define LPC_CNTRL_OFFSET		0x84
-#define LPC_CLKRUN_EN			(1 << 2)
-
-/**
- * tpm_platform_begin_xfer() - clear LPC CLKRUN_EN i.e. clocks will be running
- */
-static void tpm_platform_begin_xfer(struct tpm_tis_data *data)
-{
-	u32 clkrun_val;
-
-	if (!is_bsw())
-		return;
-
-	clkrun_val = ioread32(data->ilb_base_addr + LPC_CNTRL_OFFSET);
-
-	/* Disable LPC CLKRUN# */
-	clkrun_val &= ~LPC_CLKRUN_EN;
-	iowrite32(clkrun_val, data->ilb_base_addr + LPC_CNTRL_OFFSET);
-
-	/*
-	 * Write any random value on port 0x80 which is on LPC, to make
-	 * sure LPC clock is running before sending any TPM command.
-	 */
-	outb(0xCC, 0x80);
-
-}
-
-/**
- * tpm_platform_end_xfer() - set LPC CLKRUN_EN i.e. clocks can be turned off
- */
-static void tpm_platform_end_xfer(struct tpm_tis_data *data)
-{
-	u32 clkrun_val;
-
-	if (!is_bsw())
-		return;
-
-	clkrun_val = ioread32(data->ilb_base_addr + LPC_CNTRL_OFFSET);
-
-	/* Enable LPC CLKRUN# */
-	clkrun_val |= LPC_CLKRUN_EN;
-	iowrite32(clkrun_val, data->ilb_base_addr + LPC_CNTRL_OFFSET);
-
-	/*
-	 * Write any random value on port 0x80 which is on LPC, to make
-	 * sure LPC clock is running before sending any TPM command.
-	 */
-	outb(0xCC, 0x80);
-
-}
-#else
-static void tpm_platform_begin_xfer(struct tpm_tis_data *data)
-{
-}
-
-static void tpm_platform_end_xfer(struct tpm_tis_data *data)
-{
-}
-#endif
-
 static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 			      u8 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer(data);
+	if (is_bsw() && !(data->flags & TPM_TIS_CLK_ENABLE))
+		WARN(1, "CLKRUN not enabled!\n");
 
 	while (len--)
 		*result++ = ioread8(phy->iobase + addr);
 
-	tpm_platform_end_xfer(data);
-
 	return 0;
 }
 
@@ -214,13 +152,12 @@ static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer(data);
+	if (is_bsw() && !(data->flags & TPM_TIS_CLK_ENABLE))
+		WARN(1, "CLKRUN not enabled!\n");
 
 	while (len--)
 		iowrite8(*value++, phy->iobase + addr);
 
-	tpm_platform_end_xfer(data);
-
 	return 0;
 }
 
@@ -228,12 +165,11 @@ static int tpm_tcg_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer(data);
+	if (is_bsw() && !(data->flags & TPM_TIS_CLK_ENABLE))
+		WARN(1, "CLKRUN not enabled!\n");
 
 	*result = ioread16(phy->iobase + addr);
 
-	tpm_platform_end_xfer(data);
-
 	return 0;
 }
 
@@ -241,12 +177,11 @@ static int tpm_tcg_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer(data);
+	if (is_bsw() && !(data->flags & TPM_TIS_CLK_ENABLE))
+		WARN(1, "CLKRUN not enabled!\n");
 
 	*result = ioread32(phy->iobase + addr);
 
-	tpm_platform_end_xfer(data);
-
 	return 0;
 }
 
@@ -254,12 +189,11 @@ static int tpm_tcg_write32(struct tpm_tis_data *data, u32 addr, u32 value)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer(data);
+	if (is_bsw() && !(data->flags & TPM_TIS_CLK_ENABLE))
+		WARN(1, "CLKRUN not enabled!\n");
 
 	iowrite32(value, phy->iobase + addr);
 
-	tpm_platform_end_xfer(data);
-
 	return 0;
 }
 
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index bea151844692..c2227983ed88 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -475,19 +475,28 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 	int i, rc;
 	u32 did_vid;
 
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, true);
+
 	rc = tpm_tis_read32(priv, TPM_DID_VID(0), &did_vid);
 	if (rc < 0)
-		return rc;
+		goto out;
 
 	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
 		if (vendor_timeout_overrides[i].did_vid != did_vid)
 			continue;
 		memcpy(timeout_cap, vendor_timeout_overrides[i].timeout_us,
 		       sizeof(vendor_timeout_overrides[i].timeout_us));
-		return true;
+		rc = true;
 	}
 
-	return false;
+	rc = false;
+
+out:
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, false);
+
+	return rc;
 }
 
 /*
@@ -707,14 +716,71 @@ void tpm_tis_remove(struct tpm_chip *chip)
 	u32 interrupt;
 	int rc;
 
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, true);
+
 	rc = tpm_tis_read32(priv, reg, &interrupt);
 	if (rc < 0)
 		interrupt = 0;
 
 	tpm_tis_write32(priv, reg, ~TPM_GLOBAL_INT_ENABLE & interrupt);
+
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, false);
 }
 EXPORT_SYMBOL_GPL(tpm_tis_remove);
 
+/**
+ * tpm_tis_clkrun_enable() - Keep clkrun protocol disabled for entire duration
+ *                           of a single TPM command
+ * @chip:	TPM chip to use
+ * @value:	1 - Disable CLKRUN protocol, so that clocks are free running
+ *		0 - Enable CLKRUN protocol
+ */
+static void tpm_tis_clkrun_enable(struct tpm_chip *chip, bool value)
+{
+	struct tpm_tis_data *data = dev_get_drvdata(&chip->dev);
+	u32 clkrun_val;
+
+	if (!IS_ENABLED(CONFIG_X86) || !is_bsw())
+		return;
+
+	if (value) {
+		data->flags |= TPM_TIS_CLK_ENABLE;
+		data->clkrun_enabled++;
+		if (data->clkrun_enabled > 1)
+			return;
+		clkrun_val = ioread32(data->ilb_base_addr + LPC_CNTRL_OFFSET);
+
+		/* Disable LPC CLKRUN# */
+		clkrun_val &= ~LPC_CLKRUN_EN;
+		iowrite32(clkrun_val, data->ilb_base_addr + LPC_CNTRL_OFFSET);
+
+		/*
+		 * Write any random value on port 0x80 which is on LPC, to make
+		 * sure LPC clock is running before sending any TPM command.
+		 */
+		outb(0xCC, 0x80);
+	} else {
+		data->clkrun_enabled--;
+		if (data->clkrun_enabled)
+			return;
+
+		clkrun_val = ioread32(data->ilb_base_addr + LPC_CNTRL_OFFSET);
+
+		/* Enable LPC CLKRUN# */
+		clkrun_val |= LPC_CLKRUN_EN;
+		iowrite32(clkrun_val, data->ilb_base_addr + LPC_CNTRL_OFFSET);
+
+		/*
+		 * Write any random value on port 0x80 which is on LPC, to make
+		 * sure LPC clock is running before sending any TPM command.
+		 */
+		outb(0xCC, 0x80);
+		data->flags &= ~TPM_TIS_CLK_ENABLE;
+	}
+}
+
 static const struct tpm_class_ops tpm_tis = {
 	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = tpm_tis_status,
@@ -727,6 +793,7 @@ void tpm_tis_remove(struct tpm_chip *chip)
 	.req_canceled = tpm_tis_req_canceled,
 	.request_locality = request_locality,
 	.relinquish_locality = release_locality,
+	.clk_enable = tpm_tis_clkrun_enable,
 };
 
 int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
@@ -761,6 +828,9 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 			return -ENOMEM;
 	}
 
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, true);
+
 	if (wait_startup(chip, 0) != 0) {
 		rc = -ENODEV;
 		goto out_err;
@@ -855,12 +925,18 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	if (rc && is_bsw())
 		iounmap(priv->ilb_base_addr);
 
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, false);
+
 	return rc;
 out_err:
 	tpm_tis_remove(chip);
 	if (is_bsw())
 		iounmap(priv->ilb_base_addr);
 
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, false);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_tis_core_init);
@@ -872,22 +948,31 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 	u32 intmask;
 	int rc;
 
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, true);
+
 	/* reenable interrupts that device may have lost or
 	 * BIOS/firmware may have disabled
 	 */
 	rc = tpm_tis_write8(priv, TPM_INT_VECTOR(priv->locality), priv->irq);
 	if (rc < 0)
-		return;
+		goto out;
 
 	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
 	if (rc < 0)
-		return;
+		goto out;
 
 	intmask |= TPM_INTF_CMD_READY_INT
 	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
 	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
 
 	tpm_tis_write32(priv, TPM_INT_ENABLE(priv->locality), intmask);
+
+out:
+	if (chip->ops->clk_enable != NULL)
+		chip->ops->clk_enable(chip, false);
+
+	return;
 }
 
 int tpm_tis_resume(struct device *dev)
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 458847f72758..afc50cde1ba6 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -79,11 +79,14 @@ enum tis_defaults {
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
 
+#define LPC_CNTRL_OFFSET		0x84
+#define LPC_CLKRUN_EN			(1 << 2)
 #define INTEL_LEGACY_BLK_BASE_ADDR	0xFED08000
 #define ILB_REMAP_SIZE			0x100
 
 enum tpm_tis_flags {
 	TPM_TIS_ITPM_WORKAROUND		= BIT(0),
+	TPM_TIS_CLK_ENABLE		= BIT(1),
 };
 
 struct tpm_tis_data {
@@ -93,6 +96,7 @@ struct tpm_tis_data {
 	bool irq_tested;
 	unsigned int flags;
 	void __iomem *ilb_base_addr;
+	u16 clkrun_enabled;
 	wait_queue_head_t int_queue;
 	wait_queue_head_t read_queue;
 	const struct tpm_tis_phy_ops *phy_ops;
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 5a090f5ab335..881312d85574 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -50,6 +50,7 @@ struct tpm_class_ops {
 				unsigned long *timeout_cap);
 	int (*request_locality)(struct tpm_chip *chip, int loc);
 	void (*relinquish_locality)(struct tpm_chip *chip, int loc);
+	void (*clk_enable)(struct tpm_chip *chip, bool value);
 };
 
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
-- 
1.9.1
