From: Azhar Shaikh <azhar.shaikh@intel.com>
Subject: [PATCH v3] tpm: Enable CLKRUN protocol for Braswell systems
Date: Wed,  7 Jun 2017 14:23:30 -0700
Message-ID: <1496870610-29462-1-git-send-email-azhar.shaikh@intel.com>
References: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, azhar.shaikh@intel.com
List-Id: tpmdd-devel@lists.sourceforge.net

To overcome a hardware limitation on Intel Braswell systems,
disable CLKRUN protocol during TPM transactions and re-enable
once the transaction is completed.

Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
---
Changes from v1:
- Add CONFIG_X86 around disable_lpc_clk_run () and enable_lpc_clk_run() to avoid
- build breakage on architectures which do not implement kmap_atomic_pfn()

Changes from v2:
- Use ioremap()/iounmap() instead of kmap_atomic_pfn()/kunmap_atomic()
- Move is_bsw() and all macros from tpm.h to tpm_tis.c file.
- Add the is_bsw() check in disable_lpc_clk_run() and enable_lpc_clk_run()
- instead of adding it in each read/write API.

 drivers/char/tpm/tpm.h     |   4 ++
 drivers/char/tpm/tpm_tis.c | 103 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4b4c8dee3096..6b769fbc4407 100644
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
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7e1384f1b08..6e32b4c7c70d 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -89,13 +89,89 @@ static inline int is_itpm(struct acpi_device *dev)
 }
 #endif
 
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
+#define INTEL_LEGACY_BLK_BASE_ADDR      0xFED08000
+#define ILB_REMAP_SIZE			0x100
+#define LPC_CNTRL_REG_OFFSET            0x84
+#define LPC_CLKRUN_EN                   (1 << 2)
+
+void __iomem *ilb_base_addr;
+
+/**
+ * disable_lpc_clk_run() - clear LPC CLKRUN_EN i.e. clocks will be free running
+ */
+static void disable_lpc_clk_run(void)
+{
+	u32 clkrun_val;
+
+	if (!is_bsw())
+		return;
+
+	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+
+	/* Disable LPC CLKRUN# */
+	clkrun_val &= ~LPC_CLKRUN_EN;
+	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+
+	/*
+	 * Write any random value on port 0x80 which is on LPC, to make
+	 * sure LPC clock is running before sending any TPM command.
+	 */
+	outb(0x80, 0xCC);
+
+	/* Make sure the above write is completed */
+	wmb();
+}
+
+/**
+ * enable_lpc_clk_run() - set LPC CLKRUN_EN i.e. clocks can be turned off
+ */
+static void enable_lpc_clk_run(void)
+{
+	u32 clkrun_val;
+
+	if (!is_bsw())
+		return;
+
+	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+
+	/* Enable LPC CLKRUN# */
+	clkrun_val |= LPC_CLKRUN_EN;
+	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
+
+	/*
+	 * Write any random value on port 0x80 which is on LPC, to make
+	 * sure LPC clock is running before sending any TPM command.
+	 */
+	outb(0x80, 0xCC);
+
+	/* Make sure the above write is completed */
+	wmb();
+}
+
 static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 			      u8 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	disable_lpc_clk_run();
+
 	while (len--)
 		*result++ = ioread8(phy->iobase + addr);
+
+	enable_lpc_clk_run();
+
 	return 0;
 }
 
@@ -104,8 +180,13 @@ static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	disable_lpc_clk_run();
+
 	while (len--)
 		iowrite8(*value++, phy->iobase + addr);
+
+	enable_lpc_clk_run();
+
 	return 0;
 }
 
@@ -113,7 +194,12 @@ static int tpm_tcg_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	disable_lpc_clk_run();
+
 	*result = ioread16(phy->iobase + addr);
+
+	enable_lpc_clk_run();
+
 	return 0;
 }
 
@@ -121,7 +207,12 @@ static int tpm_tcg_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	disable_lpc_clk_run();
+
 	*result = ioread32(phy->iobase + addr);
+
+	enable_lpc_clk_run();
+
 	return 0;
 }
 
@@ -129,7 +220,12 @@ static int tpm_tcg_write32(struct tpm_tis_data *data, u32 addr, u32 value)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	disable_lpc_clk_run();
+
 	iowrite32(value, phy->iobase + addr);
+
+	enable_lpc_clk_run();
+
 	return 0;
 }
 
@@ -191,6 +287,10 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 		acpi_dev_handle = ACPI_HANDLE(&pnp_dev->dev);
 	}
 
+	if (is_bsw())
+		ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
+					ILB_REMAP_SIZE);
+
 	return tpm_tis_init(&pnp_dev->dev, &tpm_info, acpi_dev_handle);
 }
 
@@ -214,6 +314,9 @@ static void tpm_tis_pnp_remove(struct pnp_dev *dev)
 
 	tpm_chip_unregister(chip);
 	tpm_tis_remove(chip);
+
+	if (is_bsw())
+		iounmap(ilb_base_addr);
 }
 
 static struct pnp_driver tis_pnp_driver = {
-- 
1.9.1

