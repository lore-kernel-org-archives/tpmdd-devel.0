From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 02/12] tpm/st33zp24/spi: Use functions name
	with st33zp24_spi_ prefix
Date: Tue, 23 Feb 2016 22:25:41 +0100
Message-ID: <1456262751-12096-3-git-send-email-christophe-h.ricard@st.com>
References: <1456262751-12096-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1456262751-12096-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Make sure every function name use st33zp24_spi_ prefix.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/spi.c | 45 +++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index 74c5fcc..f42c443 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -145,7 +145,7 @@ static int st33zp24_spi_send(void *phy_id, u8 tpm_register, u8 *tpm_data,
 } /* st33zp24_spi_send() */
 
 /*
- * read8_recv
+ * st33zp24_spi_read8_recv
  * Recv byte from the TIS register according to the ST33ZP24 SPI protocol.
  * @param: phy_id, the phy description
  * @param: tpm_register, the tpm tis register where the data should be read
@@ -153,7 +153,8 @@ static int st33zp24_spi_send(void *phy_id, u8 tpm_register, u8 *tpm_data,
  * @param: tpm_size, tpm TPM response size to read.
  * @return: should be zero if success else a negative error code.
  */
-static int read8_reg(void *phy_id, u8 tpm_register, u8 *tpm_data, int tpm_size)
+static int st33zp24_spi_read8_reg(void *phy_id, u8 tpm_register, u8 *tpm_data,
+				  int tpm_size)
 {
 	u8 data = 0;
 	int total_length = 0, ret;
@@ -185,7 +186,7 @@ static int read8_reg(void *phy_id, u8 tpm_register, u8 *tpm_data, int tpm_size)
 	}
 
 	return ret;
-} /* read8_reg() */
+} /* st33zp24_spi_read8_reg() */
 
 /*
  * st33zp24_spi_recv
@@ -201,13 +202,13 @@ static int st33zp24_spi_recv(void *phy_id, u8 tpm_register, u8 *tpm_data,
 {
 	int ret;
 
-	ret = read8_reg(phy_id, tpm_register, tpm_data, tpm_size);
+	ret = st33zp24_spi_read8_reg(phy_id, tpm_register, tpm_data, tpm_size);
 	if (!st33zp24_status_to_errno(ret))
 		return tpm_size;
 	return ret;
 } /* st33zp24_spi_recv() */
 
-static int evaluate_latency(void *phy_id)
+static int st33zp24_spi_evaluate_latency(void *phy_id)
 {
 	struct st33zp24_spi_phy *phy = phy_id;
 	int latency = 1, status = 0;
@@ -215,7 +216,8 @@ static int evaluate_latency(void *phy_id)
 
 	while (!status && latency < MAX_SPI_LATENCY) {
 		phy->latency = latency;
-		status = read8_reg(phy_id, TPM_INTF_CAPABILITY, &data, 1);
+		status = st33zp24_spi_read8_reg(phy_id, TPM_INTF_CAPABILITY,
+						&data, 1);
 		latency++;
 	}
 	return latency - 1;
@@ -227,7 +229,7 @@ static const struct st33zp24_phy_ops spi_phy_ops = {
 };
 
 #ifdef CONFIG_OF
-static int tpm_stm_spi_of_request_resources(struct st33zp24_spi_phy *phy)
+static int st33zp24_spi_of_request_resources(struct st33zp24_spi_phy *phy)
 {
 	struct device_node *pp;
 	struct spi_device *dev = phy->spi_device;
@@ -265,14 +267,14 @@ static int tpm_stm_spi_of_request_resources(struct st33zp24_spi_phy *phy)
 	return 0;
 }
 #else
-static int tpm_stm_spi_of_request_resources(struct st33zp24_spi_phy *phy)
+static int st33zp24_spi_of_request_resources(struct st33zp24_spi_phy *phy)
 {
 	return -ENODEV;
 }
 #endif
 
-static int tpm_stm_spi_request_resources(struct spi_device *dev,
-					 struct st33zp24_spi_phy *phy)
+static int st33zp24_spi_request_resources(struct spi_device *dev,
+					  struct st33zp24_spi_phy *phy)
 {
 	struct st33zp24_platform_data *pdata;
 	int ret;
@@ -301,13 +303,12 @@ static int tpm_stm_spi_request_resources(struct spi_device *dev,
 }
 
 /*
- * tpm_st33_spi_probe initialize the TPM device
+ * st33zp24_spi_probe initialize the TPM device
  * @param: dev, the spi_device drescription (TPM SPI description).
  * @return: 0 in case of success.
  *	 or a negative value describing the error.
  */
-static int
-tpm_st33_spi_probe(struct spi_device *dev)
+static int st33zp24_spi_probe(struct spi_device *dev)
 {
 	int ret;
 	struct st33zp24_platform_data *pdata;
@@ -328,11 +329,11 @@ tpm_st33_spi_probe(struct spi_device *dev)
 	phy->spi_device = dev;
 	pdata = dev->dev.platform_data;
 	if (!pdata && dev->dev.of_node) {
-		ret = tpm_stm_spi_of_request_resources(phy);
+		ret = st33zp24_spi_of_request_resources(phy);
 		if (ret)
 			return ret;
 	} else if (pdata) {
-		ret = tpm_stm_spi_request_resources(dev, phy);
+		ret = st33zp24_spi_request_resources(dev, phy);
 		if (ret)
 			return ret;
 	}
@@ -340,7 +341,7 @@ tpm_st33_spi_probe(struct spi_device *dev)
 	phy->spi_xfer.tx_buf = phy->tx_buf;
 	phy->spi_xfer.rx_buf = phy->rx_buf;
 
-	phy->latency = evaluate_latency(phy);
+	phy->latency = st33zp24_spi_evaluate_latency(phy);
 	if (phy->latency <= 0)
 		return -ENODEV;
 
@@ -349,11 +350,11 @@ tpm_st33_spi_probe(struct spi_device *dev)
 }
 
 /*
- * tpm_st33_spi_remove remove the TPM device
+ * st33zp24_spi_remove remove the TPM device
  * @param: client, the spi_device drescription (TPM SPI description).
  * @return: 0 in case of success.
  */
-static int tpm_st33_spi_remove(struct spi_device *dev)
+static int st33zp24_spi_remove(struct spi_device *dev)
 {
 	struct tpm_chip *chip = spi_get_drvdata(dev);
 
@@ -377,18 +378,18 @@ MODULE_DEVICE_TABLE(of, of_st33zp24_spi_match);
 static SIMPLE_DEV_PM_OPS(st33zp24_spi_ops, st33zp24_pm_suspend,
 			 st33zp24_pm_resume);
 
-static struct spi_driver tpm_st33_spi_driver = {
+static struct spi_driver st33zp24_spi_driver = {
 	.driver = {
 		.name = TPM_ST33_SPI,
 		.pm = &st33zp24_spi_ops,
 		.of_match_table = of_match_ptr(of_st33zp24_spi_match),
 	},
-	.probe = tpm_st33_spi_probe,
-	.remove = tpm_st33_spi_remove,
+	.probe = st33zp24_spi_probe,
+	.remove = st33zp24_spi_remove,
 	.id_table = st33zp24_spi_id,
 };
 
-module_spi_driver(tpm_st33_spi_driver);
+module_spi_driver(st33zp24_spi_driver);
 
 MODULE_AUTHOR("TPM support (TPMsupport-nkJGhpqTU55BDgjK7y7TUQ@public.gmane.org)");
 MODULE_DESCRIPTION("STM TPM 1.2 SPI ST33 Driver");
-- 
2.5.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
