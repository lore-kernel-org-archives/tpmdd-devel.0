From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/10] tpm: Manage itpm workaround with tis
	specific data_expect bit
Date: Sun, 10 Apr 2016 23:23:00 +0200
Message-ID: <1460323386-16892-5-git-send-email-christophe-h.ricard@st.com>
References: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460323386-16892-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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
 drivers/char/tpm/tpm_tis.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index ee5851e..5b3eb26 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -93,6 +93,11 @@ struct tpm_info {
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
 
+struct tpm_tis_phy_ops {
+	u8 data_expect_mask;
+	u8 data_expect_val;
+};
+
 struct priv_data {
 	void __iomem *iobase;
 	u16 manufacturer_id;
@@ -101,6 +106,7 @@ struct priv_data {
 	bool irq_tested;
 	wait_queue_head_t int_queue;
 	wait_queue_head_t read_queue;
+	struct tpm_tis_phy_ops *phy_ops;
 };
 
 #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
@@ -381,7 +387,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 				  &priv->int_queue, false);
 		status = tpm_tis_status(chip);
-		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
+		if ((status & priv->phy_ops->data_expect_mask) !=
+			      priv->phy_ops->data_expect_val) {
 			rc = -EIO;
 			goto out_err;
 		}
@@ -395,7 +402,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 			  &priv->int_queue, false);
 	status = tpm_tis_status(chip);
-	if ((status & TPM_STS_DATA_EXPECT) != 0) {
+	if ((status & priv->phy_ops->data_expect_mask) ==
+		      priv->phy_ops->data_expect_mask) {
 		rc = -EIO;
 		goto out_err;
 	}
@@ -532,6 +540,8 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 static int probe_itpm(struct tpm_chip *chip)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	u8 data_expect_mask = priv->phy_ops->data_expect_mask;
+	u8 data_expect_val = priv->phy_ops->data_expect_val;
 	int rc = 0;
 	u8 cmd_getticks[] = {
 		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
@@ -559,13 +569,18 @@ static int probe_itpm(struct tpm_chip *chip)
 	release_locality(chip, priv->locality, 0);
 
 	itpm = true;
+	priv->phy_ops->data_expect_mask = 0;
+	priv->phy_ops->data_expect_val = 0;
 
 	rc = tpm_tis_send_data(chip, cmd_getticks, len);
 	if (rc == 0) {
 		dev_info(&chip->dev, "Detected an iTPM.\n");
 		rc = 1;
-	} else
+	} else {
+		priv->phy_ops->data_expect_mask = data_expect_mask;
+		priv->phy_ops->data_expect_val = data_expect_val;
 		rc = -EFAULT;
+	}
 
 out:
 	itpm = rem_itpm;
@@ -601,6 +616,11 @@ static const struct tpm_class_ops tpm_tis = {
 	.req_canceled = tpm_tis_req_canceled,
 };
 
+static struct tpm_tis_phy_ops tis_phy_ops = {
+	.data_expect_mask = TPM_STS_DATA_EXPECT,
+	.data_expect_val = TPM_STS_DATA_EXPECT,
+};
+
 static int tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
 			      u8 *result)
 {
@@ -844,6 +864,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	chip->timeout_b = TIS_TIMEOUT_B_MAX;
 	chip->timeout_c = TIS_TIMEOUT_C_MAX;
 	chip->timeout_d = TIS_TIMEOUT_D_MAX;
+	priv->phy_ops = &tis_phy_ops;
 
 	dev_set_drvdata(&chip->dev, priv);
 
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
gampad/clk?id=1444514301&iu=/ca-pub-7940484522588532
