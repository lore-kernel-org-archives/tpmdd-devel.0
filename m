From: Haris Okanovic <haris.okanovic-acOepvfBmUk@public.gmane.org>
Subject: [PATCH v2] tpm_tis: fix stall after iowrite*()s
Date: Tue, 15 Aug 2017 15:13:08 -0500
Message-ID: <20170815201308.20024-1-haris.okanovic@ni.com>
References: <20170804215651.29247-1-haris.okanovic@ni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170804215651.29247-1-haris.okanovic-acOepvfBmUk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: haris.okanovic-acOepvfBmUk@public.gmane.org, julia.cartwright-acOepvfBmUk@public.gmane.org, harisokn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, eric.gardiner-acOepvfBmUk@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, jonathan.david-acOepvfBmUk@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, scott.hartman-acOepvfBmUk@public.gmane.org, chris.graf-acOepvfBmUk@public.gmane.org, gratian.crisan-acOepvfBmUk@public.gmane.org, brad.mouring-acOepvfBmUk@public.gmane.org
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

Signed-off-by: Haris Okanovic <haris.okanovic-acOepvfBmUk@public.gmane.org>
---
[PATCH v2] Add tpm_tis_flush() function with comment explaining
the ioread8() after write, per Alexander.

https://patchwork.kernel.org/patch/9882119/
https://github.com/harisokanovic/linux/tree/dev/hokanovi/tpm-latency-spike-fix-v2
---
 drivers/char/tpm/tpm_tis.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7e1384f1b08..3fdec13eba8d 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -52,6 +52,31 @@ static inline struct tpm_tis_tcg_phy *to_tpm_tis_tcg_phy(struct tpm_tis_data *da
 	return container_of(data, struct tpm_tis_tcg_phy, priv);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * Flushes previous write operations to chip so that a subsequent
+ * ioread*()s won't stall a cpu.
+ */
+static inline void tpm_tis_flush(void __iomem *iobase)
+{
+	ioread8(iobase + TPM_ACCESS(0));
+}
+#else
+#define tpm_tis_flush(iobase) do { } while (0)
+#endif
+
+static inline void tpm_tis_iowrite8(u8 b, void __iomem *iobase, u32 addr)
+{
+	iowrite8(b, iobase + addr);
+	tpm_tis_flush(iobase);
+}
+
+static inline void tpm_tis_iowrite32(u32 b, void __iomem *iobase, u32 addr)
+{
+	iowrite32(b, iobase + addr);
+	tpm_tis_flush(iobase);
+}
+
 static bool interrupts = true;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
@@ -105,7 +130,7 @@ static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
 	while (len--)
-		iowrite8(*value++, phy->iobase + addr);
+		tpm_tis_iowrite8(*value++, phy->iobase, addr);
 	return 0;
 }
 
@@ -129,7 +154,7 @@ static int tpm_tcg_write32(struct tpm_tis_data *data, u32 addr, u32 value)
 {
 	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
 
-	iowrite32(value, phy->iobase + addr);
+	tpm_tis_iowrite32(value, phy->iobase, addr);
 	return 0;
 }
 
-- 
2.13.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
