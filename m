From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 07/12] tpm: tpm_tis: Add post_probe phy
	handler
Date: Wed, 13 Apr 2016 21:55:46 +0200
Message-ID: <1460577351-24632-8-git-send-email-christophe-h.ricard@st.com>
References: <1460577351-24632-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460577351-24632-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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
 drivers/char/tpm/tpm_tis.c      | 29 +++++++++++++++++++++--------
 drivers/char/tpm/tpm_tis_core.h |  1 +
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a641af0..a82a09f 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -610,6 +610,7 @@ static const struct tpm_class_ops tpm_tis = {
 static struct tpm_tis_phy_ops tis_phy_ops = {
 	.data_expect_mask = TPM_STS_DATA_EXPECT,
 	.data_expect_val = TPM_STS_DATA_EXPECT,
+	.post_probe = tpm_tis_post_probe,
 };
 
 static int tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
@@ -807,6 +808,23 @@ static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
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
 static bool interrupts = true;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
@@ -910,19 +928,14 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
 		 vendor >> 16, rid);
 
-	if (!itpm) {
-		probe = probe_itpm(chip);
-		if (probe < 0) {
+	if (priv->post_probe) {
+		rc = priv->post_probe(chip);
+		if (rc < 0) {
 			rc = -ENODEV;
 			goto out_err;
 		}
-		itpm = !!probe;
 	}
 
-	if (itpm)
-		dev_info(dev, "Intel iTPM workaround enabled\n");
-
-
 	/* Figure out the capabilities */
 	rc = tpm_read32(chip, TPM_INTF_CAPS(priv->locality), &intfcaps);
 	if (rc < 0)
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index cba82f8..dc5c136 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -52,6 +52,7 @@ struct tpm_tis_data {
 	const struct tpm_tis_class_lowlevel *lowlevel;
 	const struct tpm_tis_phy_ops *phy_ops;
 	void *phy_id;
+	int (*post_probe)(struct tpm_chip *chip);
 };
 
 static inline int tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
-- 
2.5.0


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
