From: Azhar Shaikh <azhar.shaikh@intel.com>
Subject: [PATCH] tpm: Enable CLKRUN protocol for Braswell systems
Date: Thu,  1 Jun 2017 12:13:52 -0700
Message-ID: <1496344432-76640-1-git-send-email-azhar.shaikh@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, azhar.shaikh@intel.com
List-Id: tpmdd-devel@lists.sourceforge.net

To overcome a hardware limitation on Intel Braswell systems,
disable CLKRUN protocol during TPM transactions and re-enable
once the transaction is completed.

Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
---
 drivers/char/tpm/tpm.h     | 20 +++++++++++
 drivers/char/tpm/tpm_tis.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4b4c8dee3096..98032a22317e 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -36,6 +36,10 @@
 #include <linux/highmem.h>
 #include <crypto/hash_info.h>
 
+#ifdef CONFIG_X86
+#include <asm/intel-family.h>
+#endif
+
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
 	TPM_BUFSIZE = 4096,
@@ -436,6 +440,22 @@ struct tpm_buf {
 	u8 *data;
 };
 
+#define INTEL_LEGACY_BLK_BASE_ADDR	0xFED08000
+#define LPC_CNTRL_REG_OFFSET		0x84
+#define LPC_CLKRUN_EN			(1 << 2)
+
+#ifdef CONFIG_X86
+static inline bool is_bsw(void)
+{
+	return ((boot_cpu_data.x86_model == INTEL_FAM6_ATOM_AIRMONT) ? 1 : 0);
+}
+#else
+static inline bool is_bsw(void)
+{
+	return false;
+}
+#endif
+
 static inline int tpm_buf_init(struct tpm_buf *buf, u16 tag, u32 ordinal)
 {
 	struct tpm_input_header *head;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7e1384f1b08..25ead56382c0 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -89,13 +89,70 @@ static inline int is_itpm(struct acpi_device *dev)
 }
 #endif
 
+/**
+ * disable_lpc_clk_run() - clear LPC CLKRUN_EN i.e. clocks will be free running
+ */
+static void disable_lpc_clk_run(void)
+{
+	u32 clkrun_val;
+	void __iomem *ilb_base_addr = NULL;
+
+	ilb_base_addr = (void __iomem *)
+		kmap_atomic_pfn(INTEL_LEGACY_BLK_BASE_ADDR >> PAGE_SHIFT);
+
+	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+
+	/* Disable LPC CLKRUN# */
+	clkrun_val &= ~LPC_CLKRUN_EN;
+	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+
+	kunmap_atomic(ilb_base_addr);
+	/*
+	 * Write any random value on port 0x80 which is on LPC, to make
+	 * sure LPC clock is running before sending any TPM command.
+	 */
+	outb(0x80, 0xCC);
+}
+
+/**
+ * enable_lpc_clk_run() - set LPC CLKRUN_EN i.e. clocks can be turned off
+ */
+static void enable_lpc_clk_run(void)
+{
+	u32 clkrun_val;
+	void __iomem *ilb_base_addr = NULL;
+
+	ilb_base_addr = (void __iomem *)
+		kmap_atomic_pfn(INTEL_LEGACY_BLK_BASE_ADDR >> PAGE_SHIFT);
+
+	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+
+	/* Enable LPC CLKRUN# */
+	clkrun_val |= LPC_CLKRUN_EN;
+	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+
+	kunmap_atomic(ilb_base_addr);
+	/*
+	 * Write any random value on port 0x80 which is on LPC, to make
+	 * sure LPC clock is running before sending any TPM command.
+	 */
+	outb(0x80, 0xCC);
+}
+
 static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 			      u8 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	if (is_bsw())
+		disable_lpc_clk_run();
+
 	while (len--)
 		*result++ = ioread8(phy->iobase + addr);
+
+	if (is_bsw())
+		enable_lpc_clk_run();
+
 	return 0;
 }
 
@@ -104,8 +161,15 @@ static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	if (is_bsw())
+		disable_lpc_clk_run();
+
 	while (len--)
 		iowrite8(*value++, phy->iobase + addr);
+
+	if (is_bsw())
+		enable_lpc_clk_run();
+
 	return 0;
 }
 
@@ -113,7 +177,14 @@ static int tpm_tcg_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	if (is_bsw())
+		disable_lpc_clk_run();
+
 	*result = ioread16(phy->iobase + addr);
+
+	if (is_bsw())
+		enable_lpc_clk_run();
+
 	return 0;
 }
 
@@ -121,7 +192,14 @@ static int tpm_tcg_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	if (is_bsw())
+		disable_lpc_clk_run();
+
 	*result = ioread32(phy->iobase + addr);
+
+	if (is_bsw())
+		enable_lpc_clk_run();
+
 	return 0;
 }
 
@@ -129,7 +207,14 @@ static int tpm_tcg_write32(struct tpm_tis_data *data, u32 addr, u32 value)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	if (is_bsw())
+		disable_lpc_clk_run();
+
 	iowrite32(value, phy->iobase + addr);
+
+	if (is_bsw())
+		enable_lpc_clk_run();
+
 	return 0;
 }
 
-- 
1.9.1

