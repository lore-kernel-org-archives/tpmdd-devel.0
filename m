From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v1] tpm/st33zp24: Add GPIO ACPI mapping table
Date: Mon, 13 Mar 2017 19:38:11 +0200
Message-ID: <20170313173811.21668-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

In order to make GPIO ACPI library stricter prepare users of
gpiod_get_index() to correctly behave when there no mapping is
provided by firmware.

Here we add explicit mapping between _CRS GpioIo() resources and
their names used in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/st33zp24/i2c.c | 23 ++++++++++++++++++++---
 drivers/char/tpm/st33zp24/spi.c | 23 ++++++++++++++++++++---
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/i2c.c b/drivers/char/tpm/st33zp24/i2c.c
index 028a9cd76b63..349fc72447a1 100644
--- a/drivers/char/tpm/st33zp24/i2c.c
+++ b/drivers/char/tpm/st33zp24/i2c.c
@@ -111,6 +111,13 @@ static const struct st33zp24_phy_ops i2c_phy_ops = {
 	.recv = st33zp24_i2c_recv,
 };
 
+static const struct acpi_gpio_params lpcpd_gpios = { 1, 0, false };
+
+static const struct acpi_gpio_mapping acpi_st33zp24_gpios[] = {
+	{ "lpcpd-gpios", &lpcpd_gpios, 1 },
+	{},
+};
+
 static int st33zp24_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct tpm_chip *chip = i2c_get_clientdata(client);
@@ -118,10 +125,14 @@ static int st33zp24_i2c_acpi_request_resources(struct i2c_client *client)
 	struct st33zp24_i2c_phy *phy = tpm_dev->phy_id;
 	struct gpio_desc *gpiod_lpcpd;
 	struct device *dev = &client->dev;
+	int ret;
+
+	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_st33zp24_gpios);
+	if (ret)
+		return ret;
 
 	/* Get LPCPD GPIO from ACPI */
-	gpiod_lpcpd = devm_gpiod_get_index(dev, "TPM IO LPCPD", 1,
-					   GPIOD_OUT_HIGH);
+	gpiod_lpcpd = devm_gpiod_get(dev, "lpcpd", GPIOD_OUT_HIGH);
 	if (IS_ERR(gpiod_lpcpd)) {
 		dev_err(&client->dev,
 			"Failed to retrieve lpcpd-gpios from acpi.\n");
@@ -268,8 +279,14 @@ static int st33zp24_i2c_probe(struct i2c_client *client,
 static int st33zp24_i2c_remove(struct i2c_client *client)
 {
 	struct tpm_chip *chip = i2c_get_clientdata(client);
+	int ret;
 
-	return st33zp24_remove(chip);
+	ret = st33zp24_remove(chip);
+	if (ret)
+		return ret;
+
+	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&dev->dev));
+	return 0;
 }
 
 static const struct i2c_device_id st33zp24_i2c_id[] = {
diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index 9f5a0117098c..c69d15198f84 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -230,6 +230,13 @@ static const struct st33zp24_phy_ops spi_phy_ops = {
 	.recv = st33zp24_spi_recv,
 };
 
+static const struct acpi_gpio_params lpcpd_gpios = { 1, 0, false };
+
+static const struct acpi_gpio_mapping acpi_st33zp24_gpios[] = {
+	{ "lpcpd-gpios", &lpcpd_gpios, 1 },
+	{},
+};
+
 static int st33zp24_spi_acpi_request_resources(struct spi_device *spi_dev)
 {
 	struct tpm_chip *chip = spi_get_drvdata(spi_dev);
@@ -237,10 +244,14 @@ static int st33zp24_spi_acpi_request_resources(struct spi_device *spi_dev)
 	struct st33zp24_spi_phy *phy = tpm_dev->phy_id;
 	struct gpio_desc *gpiod_lpcpd;
 	struct device *dev = &spi_dev->dev;
+	int ret;
+
+	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_st33zp24_gpios);
+	if (ret)
+		return ret;
 
 	/* Get LPCPD GPIO from ACPI */
-	gpiod_lpcpd = devm_gpiod_get_index(dev, "TPM IO LPCPD", 1,
-					   GPIOD_OUT_HIGH);
+	gpiod_lpcpd = devm_gpiod_get(dev, "lpcpd", GPIOD_OUT_HIGH);
 	if (IS_ERR(gpiod_lpcpd)) {
 		dev_err(dev, "Failed to retrieve lpcpd-gpios from acpi.\n");
 		phy->io_lpcpd = -1;
@@ -385,8 +396,14 @@ static int st33zp24_spi_probe(struct spi_device *dev)
 static int st33zp24_spi_remove(struct spi_device *dev)
 {
 	struct tpm_chip *chip = spi_get_drvdata(dev);
+	int ret;
 
-	return st33zp24_remove(chip);
+	ret = st33zp24_remove(chip);
+	if (ret)
+		return ret;
+
+	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&dev->dev));
+	return 0;
 }
 
 static const struct spi_device_id st33zp24_spi_id[] = {
-- 
2.11.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
