From: Azhar Shaikh <azhar.shaikh@intel.com>
Subject: [PATCH v4 1/2] tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()
Date: Tue, 21 Nov 2017 14:39:23 -0800
Message-ID: <1511303964-56294-2-git-send-email-azhar.shaikh@intel.com>
References: <1511303964-56294-1-git-send-email-azhar.shaikh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511303964-56294-1-git-send-email-azhar.shaikh@intel.com>
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
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c |  6 ++++++
 drivers/char/tpm/tpm_tis.c       | 44 ++++++++++++++++++++++++----------------
 drivers/char/tpm/tpm_tis_core.c  | 21 +++++++++++++++++++
 drivers/char/tpm/tpm_tis_core.h  |  1 +
 include/linux/tpm.h              |  1 +
 5 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1d6729be4cd6..4661a810eab7 100644
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
index e2d1055fb814..76a7b64195c8 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -46,6 +46,7 @@ struct tpm_info {
 struct tpm_tis_tcg_phy {
 	struct tpm_tis_data priv;
 	void __iomem *iobase;
+	bool begin_xfer_done;
 };
 
 static inline struct tpm_tis_tcg_phy *to_tpm_tis_tcg_phy(struct tpm_tis_data *data)
@@ -148,12 +149,15 @@ static inline bool is_bsw(void)
 
 /**
  * tpm_platform_begin_xfer() - clear LPC CLKRUN_EN i.e. clocks will be running
+ * @data:	struct tpm_tis_data instance
  */
-static void tpm_platform_begin_xfer(void)
+static void tpm_platform_begin_xfer(struct tpm_tis_data *data)
 {
 	u32 clkrun_val;
+	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	if (!is_bsw())
+	if (!is_bsw() || ((data->flags & TPM_TIS_CLK_ENABLE) &&
+					phy->begin_xfer_done))
 		return;
 
 	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
@@ -168,16 +172,21 @@ static void tpm_platform_begin_xfer(void)
 	 */
 	outb(0xCC, 0x80);
 
+	if (!(data->flags & TPM_TIS_CLK_ENABLE))
+		phy->begin_xfer_done = false;
+	else
+		phy->begin_xfer_done = true;
 }
 
 /**
  * tpm_platform_end_xfer() - set LPC CLKRUN_EN i.e. clocks can be turned off
+ * @data:	struct tpm_tis_data instance
  */
-static void tpm_platform_end_xfer(void)
+static void tpm_platform_end_xfer(struct tpm_tis_data *data)
 {
 	u32 clkrun_val;
 
-	if (!is_bsw())
+	if (!is_bsw() || (data->flags & TPM_TIS_CLK_ENABLE))
 		return;
 
 	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
@@ -193,17 +202,16 @@ static void tpm_platform_end_xfer(void)
 	outb(0xCC, 0x80);
 
 }
+
 #else
 static inline bool is_bsw(void)
 {
 	return false;
 }
-
-static void tpm_platform_begin_xfer(void)
+static void tpm_platform_begin_xfer(struct tpm_tis_data *data)
 {
 }
-
-static void tpm_platform_end_xfer(void)
+static void tpm_platform_end_xfer(struct tpm_tis_data *data)
 {
 }
 #endif
@@ -213,12 +221,12 @@ static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer();
+	tpm_platform_begin_xfer(data);
 
 	while (len--)
 		*result++ = ioread8(phy->iobase + addr);
 
-	tpm_platform_end_xfer();
+	tpm_platform_end_xfer(data);
 
 	return 0;
 }
@@ -228,12 +236,12 @@ static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer();
+	tpm_platform_begin_xfer(data);
 
 	while (len--)
 		iowrite8(*value++, phy->iobase + addr);
 
-	tpm_platform_end_xfer();
+	tpm_platform_end_xfer(data);
 
 	return 0;
 }
@@ -242,11 +250,11 @@ static int tpm_tcg_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer();
+	tpm_platform_begin_xfer(data);
 
 	*result = ioread16(phy->iobase + addr);
 
-	tpm_platform_end_xfer();
+	tpm_platform_end_xfer(data);
 
 	return 0;
 }
@@ -255,11 +263,11 @@ static int tpm_tcg_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer();
+	tpm_platform_begin_xfer(data);
 
 	*result = ioread32(phy->iobase + addr);
 
-	tpm_platform_end_xfer();
+	tpm_platform_end_xfer(data);
 
 	return 0;
 }
@@ -268,11 +276,11 @@ static int tpm_tcg_write32(struct tpm_tis_data *data, u32 addr, u32 value)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	tpm_platform_begin_xfer();
+	tpm_platform_begin_xfer(data);
 
 	iowrite32(value, phy->iobase + addr);
 
-	tpm_platform_end_xfer();
+	tpm_platform_end_xfer(data);
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index fdde971bc810..64f5b46f5bf2 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -661,6 +661,26 @@ void tpm_tis_remove(struct tpm_chip *chip)
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
+
+	if (!IS_ENABLED(CONFIG_X86))
+		return;
+
+	if (value)
+		data->flags |= TPM_TIS_CLK_ENABLE;
+	else
+		data->flags &= ~TPM_TIS_CLK_ENABLE;
+}
+
 static const struct tpm_class_ops tpm_tis = {
 	.flags = TPM_OPS_AUTO_STARTUP,
 	.status = tpm_tis_status,
@@ -673,6 +693,7 @@ void tpm_tis_remove(struct tpm_chip *chip)
 	.req_canceled = tpm_tis_req_canceled,
 	.request_locality = request_locality,
 	.relinquish_locality = release_locality,
+	.clk_enable = tpm_tis_clkrun_enable,
 };
 
 int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 6bbac319ff3b..281f744a1a44 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -81,6 +81,7 @@ enum tis_defaults {
 
 enum tpm_tis_flags {
 	TPM_TIS_ITPM_WORKAROUND		= BIT(0),
+	TPM_TIS_CLK_ENABLE		= BIT(1),
 };
 
 struct tpm_tis_data {
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
