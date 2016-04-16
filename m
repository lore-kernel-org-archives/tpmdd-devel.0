From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 07/12] tpm: Manage itpm workaround with tis
	specific data_expect bit
Date: Sat, 16 Apr 2016 08:35:37 +0200
Message-ID: <1460788542-2455-8-git-send-email-christophe-h.ricard@st.com>
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

In order to keep this itpm workaround available after the tpm_tis rework,
we are changing the way it is managed by using a tpm_tis_phy_ops structure
allowing to manage TPM_STS_EXPECT_DATA bit behavior according to different
TPM vendor.

Those 2 fields might be used only for tpm_tis (lpc) phy in the future.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c      | 16 +++++++++++++---
 drivers/char/tpm/tpm_tis_core.h |  3 +++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 87cbad5..ea95a82 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -380,7 +380,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 				  &priv->int_queue, false);
 		status = tpm_tis_status(chip);
-		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
+		if ((status & priv->data_expect_mask) !=
+			      priv->data_expect_val) {
 			rc = -EIO;
 			goto out_err;
 		}
@@ -394,7 +395,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 			  &priv->int_queue, false);
 	status = tpm_tis_status(chip);
-	if ((status & TPM_STS_DATA_EXPECT) != 0) {
+	if ((status & priv->data_expect_mask) == priv->data_expect_val) {
 		rc = -EIO;
 		goto out_err;
 	}
@@ -531,6 +532,8 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 static int probe_itpm(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	u8 data_expect_mask = priv->data_expect_mask;
+	u8 data_expect_val = priv->data_expect_val;
 	int rc = 0;
 	u8 cmd_getticks[] = {
 		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
@@ -558,13 +561,18 @@ static int probe_itpm(struct tpm_chip *chip)
 	release_locality(chip, priv->locality, 0);
 
 	itpm = true;
+	priv->data_expect_mask = 0;
+	priv->data_expect_val = 0;
 
 	rc = tpm_tis_send_data(chip, cmd_getticks, len);
 	if (rc == 0) {
 		dev_info(&chip->dev, "Detected an iTPM.\n");
 		rc = 1;
-	} else
+	} else {
+		priv->data_expect_mask = data_expect_mask;
+		priv->data_expect_val = data_expect_val;
 		rc = -EFAULT;
+	}
 
 out:
 	itpm = rem_itpm;
@@ -836,6 +844,8 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	chip->timeout_b = TIS_TIMEOUT_B_MAX;
 	chip->timeout_c = TIS_TIMEOUT_C_MAX;
 	chip->timeout_d = TIS_TIMEOUT_D_MAX;
+	phy->priv.data_expect_val = TPM_STS_DATA_EXPECT;
+	phy->priv.data_expect_mask = TPM_STS_DATA_EXPECT;
 
 	dev_set_drvdata(&chip->dev, &phy->priv);
 
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 4074c98..c9d7b38 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -33,10 +33,13 @@ struct tpm_tis_phy_ops {
 	int (*read16)(struct tpm_chip *chip, u32 addr, u16 *result);
 	int (*read32)(struct tpm_chip *chip, u32 addr, u32 *result);
 	int (*write32)(struct tpm_chip *chip, u32 addr, u32 src);
+	int (*post_probe)(struct tpm_chip *chip);
 };
 
 struct tpm_tis_data {
 	u16 manufacturer_id;
+	u8 data_expect_mask;
+	u8 data_expect_val;
 	int locality;
 	int irq;
 	bool irq_tested;
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
