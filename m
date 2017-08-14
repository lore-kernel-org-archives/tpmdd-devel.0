From: Haris Okanovic <haris.okanovic@ni.com>
Subject: [PATCH] tpm_tis: fix stall after iowrite*()s
Date: Mon, 14 Aug 2017 17:53:47 -0500
Message-ID: <20170814225347.30670-1-haris.okanovic@ni.com>
References: <20170804215651.29247-1-haris.okanovic@ni.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170804215651.29247-1-haris.okanovic@ni.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tpmdd-devel@lists.sourceforge.net, haris.okanovic@ni.com, harisokn@gmail.com, julia.cartwright@ni.com, gratian.crisan@ni.com, scott.hartman@ni.com, chris.graf@ni.com, brad.mouring@ni.com, jonathan.david@ni.com, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, eric.gardiner@ni.com
List-Id: tpmdd-devel@lists.sourceforge.net

ioread8() operations to TPM MMIO addresses can stall the cpu when
immediately following a sequence of iowrite*()'s to the same region.

For example, cyclitest measures ~400us latency spikes when a non-RT
usermode application communicates with an SPI-based TPM chip (Intel Atom
E3940 system, PREEMPT_RT_FULL kernel). The spikes are caused by a
stalling ioread8() operation following a sequence of 30+ iowrite8()s to
the same address. I believe this happens because the write sequence is
buffered (in cpu or somewhere along the bus), and gets flushed on the
first LOAD instruction (ioread*()) that follows.

The enclosed change appears to fix this issue: read the TPM chip's
access register (status code) after every iowrite*() operation to
amortize the cost of flushing data to chip across multiple instructions.

Signed-off-by: Haris Okanovic <haris.okanovic@ni.com>
---
https://patchwork.kernel.org/patch/9882119/
https://github.com/harisokanovic/linux/tree/dev/hokanovi/tpm-latency-spike-fix
---
 drivers/char/tpm/tpm_tis.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7e1384f1b08..3be2755d0514 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -52,6 +52,22 @@ static inline struct tpm_tis_tcg_phy *to_tpm_tis_tcg_phy(struct tpm_tis_data *da
 	return container_of(data, struct tpm_tis_tcg_phy, priv);
 }
 
+static inline void tpm_tis_iowrite8(u8 b, void __iomem *iobase, u32 addr)
+{
+	iowrite8(b, iobase + addr);
+#ifdef CONFIG_PREEMPT_RT_FULL
+	ioread8(iobase + TPM_ACCESS(0));
+#endif
+}
+
+static inline void tpm_tis_iowrite32(u32 b, void __iomem *iobase, u32 addr)
+{
+	iowrite32(b, iobase + addr);
+#ifdef CONFIG_PREEMPT_RT_FULL
+	ioread8(iobase + TPM_ACCESS(0));
+#endif
+}
+
 static bool interrupts = true;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
@@ -105,7 +121,7 @@ static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
 	while (len--)
-		iowrite8(*value++, phy->iobase + addr);
+		tpm_tis_iowrite8(*value++, phy->iobase, addr);
 	return 0;
 }
 
@@ -129,7 +145,7 @@ static int tpm_tcg_write32(struct tpm_tis_data *data, u32 addr, u32 value)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	iowrite32(value, phy->iobase + addr);
+	tpm_tis_iowrite32(value, phy->iobase, addr);
 	return 0;
 }
 
-- 
2.13.2
