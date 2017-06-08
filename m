From: Azhar Shaikh <azhar.shaikh@intel.com>
Subject: [PATCH v4] tpm: Enable CLKRUN protocol for Braswell systems
Date: Thu,  8 Jun 2017 16:46:33 -0700
Message-ID: <1496965593-187931-1-git-send-email-azhar.shaikh@intel.com>
References: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
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

Changes from v3:
- Move the code under #ifdef CONFIG_X86 and create stub functions for everything else
- Rename the functions disable_lpc_clk_run() -> tpm_platform_begin_xfer() and
- enable_lpc_clk_run() -> tpm_platform_end_xfer()
- Remove wmb()

 drivers/char/tpm/tpm.h     |   4 ++
 drivers/char/tpm/tpm_tis.c | 112 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

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
index c7e1384f1b08..ce6f1a8b0510 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -89,13 +89,93 @@ static inline int is_itpm(struct acpi_device *dev)
 }
 #endif
 
+#ifdef CONFIG_X86
+#define INTEL_LEGACY_BLK_BASE_ADDR      0xFED08000
+#define ILB_REMAP_SIZE			0x100
+#define LPC_CNTRL_REG_OFFSET            0x84
+#define LPC_CLKRUN_EN                   (1 << 2)
+
+void __iomem *ilb_base_addr;
+
+static inline bool is_bsw(void)
+{
+	return ((boot_cpu_data.x86_model == INTEL_FAM6_ATOM_AIRMONT) ? 1 : 0);
+}
+
+/**
+ * tpm_platform_begin_xfer() - clear LPC CLKRUN_EN i.e. clocks will be running
+ */
+static void tpm_platform_begin_xfer(void)
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
+	outb(0xCC, 0x80);
+
+}
+
+/**
+ * tpm_platform_end_xfer() - set LPC CLKRUN_EN i.e. clocks can be turned off
+ */
+static void tpm_platform_end_xfer(void)
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
+	outb(0xCC, 0x80);
+
+}
+#else
+static inline bool is_bsw(void)
+{
+	return false;
+}
+
+static void tpm_platform_begin_xfer(void)
+{
+}
+
+static void tpm_platform_end_xfer(void)
+{
+}
+#endif
+
 static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 			      u8 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	tpm_platform_begin_xfer();
+
 	while (len--)
 		*result++ = ioread8(phy->iobase + addr);
+
+	tpm_platform_end_xfer();
+
 	return 0;
 }
 
@@ -104,8 +184,13 @@ static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	tpm_platform_begin_xfer();
+
 	while (len--)
 		iowrite8(*value++, phy->iobase + addr);
+
+	tpm_platform_end_xfer();
+
 	return 0;
 }
 
@@ -113,7 +198,12 @@ static int tpm_tcg_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	tpm_platform_begin_xfer();
+
 	*result = ioread16(phy->iobase + addr);
+
+	tpm_platform_end_xfer();
+
 	return 0;
 }
 
@@ -121,7 +211,12 @@ static int tpm_tcg_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	tpm_platform_begin_xfer();
+
 	*result = ioread32(phy->iobase + addr);
+
+	tpm_platform_end_xfer();
+
 	return 0;
 }
 
@@ -129,7 +224,12 @@ static int tpm_tcg_write32(struct tpm_tis_data *data, u32 addr, u32 value)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
+	tpm_platform_begin_xfer();
+
 	iowrite32(value, phy->iobase + addr);
+
+	tpm_platform_end_xfer();
+
 	return 0;
 }
 
@@ -191,6 +291,12 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 		acpi_dev_handle = ACPI_HANDLE(&pnp_dev->dev);
 	}
 
+#ifdef CONFIG_X86
+	if (is_bsw())
+		ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
+					ILB_REMAP_SIZE);
+#endif
+
 	return tpm_tis_init(&pnp_dev->dev, &tpm_info, acpi_dev_handle);
 }
 
@@ -214,6 +320,12 @@ static void tpm_tis_pnp_remove(struct pnp_dev *dev)
 
 	tpm_chip_unregister(chip);
 	tpm_tis_remove(chip);
+
+#ifdef CONFIG_X86
+	if (is_bsw())
+		iounmap(ilb_base_addr);
+#endif
+
 }
 
 static struct pnp_driver tis_pnp_driver = {
-- 
1.9.1
