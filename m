From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 11/12] tpm/st33zp24/i2c: Change
	xxx_request_resources header
Date: Tue, 23 Feb 2016 22:25:50 +0100
Message-ID: <1456262751-12096-12-git-send-email-christophe-h.ricard@st.com>
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

Simplify st33zp24_i2c_acpi_request_resources, st33zp24_i2c_of_request_resources
and st33zp24_i2c_request_resources to have the same prototype and using
i2c_get_clientdata.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/i2c.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/i2c.c b/drivers/char/tpm/st33zp24/i2c.c
index b20cc2b..f179aad 100644
--- a/drivers/char/tpm/st33zp24/i2c.c
+++ b/drivers/char/tpm/st33zp24/i2c.c
@@ -110,9 +110,9 @@ static const struct st33zp24_phy_ops i2c_phy_ops = {
 	.recv = st33zp24_i2c_recv,
 };
 
-static int st33zp24_i2c_acpi_request_resources(struct st33zp24_i2c_phy *phy)
+static int st33zp24_i2c_acpi_request_resources(struct i2c_client *client)
 {
-	struct i2c_client *client = phy->client;
+	struct st33zp24_i2c_phy *phy = i2c_get_clientdata(client);
 	const struct acpi_device_id *id;
 	struct gpio_desc *gpiod_lpcpd;
 	struct device *dev;
@@ -147,10 +147,10 @@ static int st33zp24_i2c_acpi_request_resources(struct st33zp24_i2c_phy *phy)
 	return 0;
 }
 
-static int st33zp24_i2c_of_request_resources(struct st33zp24_i2c_phy *phy)
+static int st33zp24_i2c_of_request_resources(struct i2c_client *client)
 {
+	struct st33zp24_i2c_phy *phy = i2c_get_clientdata(client);
 	struct device_node *pp;
-	struct i2c_client *client = phy->client;
 	int gpio;
 	int ret;
 
@@ -185,10 +185,10 @@ static int st33zp24_i2c_of_request_resources(struct st33zp24_i2c_phy *phy)
 	return 0;
 }
 
-static int st33zp24_i2c_request_resources(struct i2c_client *client,
-					  struct st33zp24_i2c_phy *phy)
+static int st33zp24_i2c_request_resources(struct i2c_client *client)
 {
 	struct st33zp24_platform_data *pdata;
+	struct st33zp24_i2c_phy *phy = i2c_get_clientdata(client);
 	int ret;
 
 	pdata = client->dev.platform_data;
@@ -244,17 +244,20 @@ static int st33zp24_i2c_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	phy->client = client;
+
+	i2c_set_clientdata(client, phy);
+
 	pdata = client->dev.platform_data;
 	if (!pdata && client->dev.of_node) {
-		ret = st33zp24_i2c_of_request_resources(phy);
+		ret = st33zp24_i2c_of_request_resources(client);
 		if (ret)
 			return ret;
 	} else if (pdata) {
-		ret = st33zp24_i2c_request_resources(client, phy);
+		ret = st33zp24_i2c_request_resources(client);
 		if (ret)
 			return ret;
 	} else if (ACPI_HANDLE(&client->dev)) {
-		ret = st33zp24_i2c_acpi_request_resources(phy);
+		ret = st33zp24_i2c_acpi_request_resources(client);
 		if (ret)
 			return ret;
 	}
-- 
2.5.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
