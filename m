From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/12] tpm/st33zp24: Remove unneeded CONFIG_OF
	switches
Date: Tue,  9 Feb 2016 10:26:54 +0100
Message-ID: <1455010021-21927-6-git-send-email-christophe-h.ricard@st.com>
References: <1455010021-21927-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455010021-21927-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

DT headers already define NOOP routines when CONFIG_OF is not defined.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/i2c.c | 9 ---------
 drivers/char/tpm/st33zp24/spi.c | 9 ---------
 2 files changed, 18 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/i2c.c b/drivers/char/tpm/st33zp24/i2c.c
index 309d276..a05fbd8 100644
--- a/drivers/char/tpm/st33zp24/i2c.c
+++ b/drivers/char/tpm/st33zp24/i2c.c
@@ -108,7 +108,6 @@ static const struct st33zp24_phy_ops i2c_phy_ops = {
 	.recv = st33zp24_i2c_recv,
 };
 
-#ifdef CONFIG_OF
 static int st33zp24_i2c_of_request_resources(struct st33zp24_i2c_phy *phy)
 {
 	struct device_node *pp;
@@ -146,12 +145,6 @@ static int st33zp24_i2c_of_request_resources(struct st33zp24_i2c_phy *phy)
 
 	return 0;
 }
-#else
-static int st33zp24_i2c_of_request_resources(struct st33zp24_i2c_phy *phy)
-{
-	return -ENODEV;
-}
-#endif
 
 static int st33zp24_i2c_request_resources(struct i2c_client *client,
 					  struct st33zp24_i2c_phy *phy)
@@ -245,13 +238,11 @@ static const struct i2c_device_id st33zp24_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, st33zp24_i2c_id);
 
-#ifdef CONFIG_OF
 static const struct of_device_id of_st33zp24_i2c_match[] = {
 	{ .compatible = "st,st33zp24-i2c", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, of_st33zp24_i2c_match);
-#endif
 
 static SIMPLE_DEV_PM_OPS(st33zp24_i2c_ops, st33zp24_pm_suspend,
 			 st33zp24_pm_resume);
diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index 41c11c9..0af836a 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -221,7 +221,6 @@ static const struct st33zp24_phy_ops spi_phy_ops = {
 	.recv = st33zp24_spi_recv,
 };
 
-#ifdef CONFIG_OF
 static int st33zp24_spi_of_request_resources(struct st33zp24_spi_phy *phy)
 {
 	struct device_node *pp;
@@ -259,12 +258,6 @@ static int st33zp24_spi_of_request_resources(struct st33zp24_spi_phy *phy)
 
 	return 0;
 }
-#else
-static int st33zp24_spi_of_request_resources(struct st33zp24_spi_phy *phy)
-{
-	return -ENODEV;
-}
-#endif
 
 static int st33zp24_spi_request_resources(struct spi_device *dev,
 					  struct st33zp24_spi_phy *phy)
@@ -357,13 +350,11 @@ static const struct spi_device_id st33zp24_spi_id[] = {
 };
 MODULE_DEVICE_TABLE(spi, st33zp24_spi_id);
 
-#ifdef CONFIG_OF
 static const struct of_device_id of_st33zp24_spi_match[] = {
 	{ .compatible = "st,st33zp24-spi", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, of_st33zp24_spi_match);
-#endif
 
 static SIMPLE_DEV_PM_OPS(st33zp24_spi_ops, st33zp24_pm_suspend,
 			 st33zp24_pm_resume);
-- 
2.5.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
