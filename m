From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 08/12] tpm: tpm_tis: Add post_probe phy
	handler
Date: Sat, 16 Apr 2016 08:35:38 +0200
Message-ID: <1460788542-2455-9-git-send-email-christophe-h.ricard@st.com>
References: <1460788542-2455-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460788542-2455-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Add post_probe phy handler in order to execute additional proprietary
operations after tpm2_probe. For the case of tpm_tis using LPC, itpm
workaround probing.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index ea95a82..236f644 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -657,14 +657,6 @@ static int tpm_mem_write32(struct tpm_chip *chip, u32 addr, u32 value)
 	return 0;
 }
 
-static const struct tpm_tis_phy_ops tpm_mem = {
-	.read_bytes = tpm_mem_read_bytes,
-	.write_bytes = tpm_mem_write_bytes,
-	.read16 = tpm_mem_read16,
-	.read32 = tpm_mem_read32,
-	.write32 = tpm_mem_write32,
-};
-
 static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
@@ -793,6 +785,32 @@ static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
 		return;
 }
 
+static int tpm_tis_post_probe(struct tpm_chip *chip)
+{
+	int probe;
+
+	if (!itpm) {
+		probe = probe_itpm(chip);
+		if (probe < 0)
+			return  -ENODEV;
+		itpm = !!probe;
+	}
+
+	if (itpm)
+		dev_info(chip->dev.parent, "Intel iTPM workaround enabled\n");
+
+	return 0;
+}
+
+static const struct tpm_tis_phy_ops tpm_mem = {
+	.read_bytes = tpm_mem_read_bytes,
+	.write_bytes = tpm_mem_write_bytes,
+	.read16 = tpm_mem_read16,
+	.read32 = tpm_mem_read32,
+	.write32 = tpm_mem_write32,
+	.post_probe = tpm_tis_post_probe,
+};
+
 static bool interrupts = true;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
@@ -817,7 +835,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 {
 	u32 vendor, intfcaps, intmask;
 	u8 rid;
-	int rc, probe;
+	int rc;
 	struct tpm_chip *chip;
 	struct tpm_tis_lpc_phy *phy;
 
@@ -887,18 +905,14 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
 		 vendor >> 16, rid);
 
-	if (!itpm) {
-		probe = probe_itpm(chip);
-		if (probe < 0) {
+	if (phy->priv.phy_ops->post_probe) {
+		rc = phy->priv.phy_ops->post_probe(chip);
+		if (rc < 0) {
 			rc = -ENODEV;
 			goto out_err;
 		}
-		itpm = !!probe;
 	}
 
-	if (itpm)
-		dev_info(dev, "Intel iTPM workaround enabled\n");
-
 	/* Figure out the capabilities */
 	rc = tpm_read32(chip, TPM_INTF_CAPS(phy->priv.locality), &intfcaps);
 	if (rc < 0)
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
