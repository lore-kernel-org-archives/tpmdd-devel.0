From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v1] tpm/st33zp24: Switch to
 devm_acpi_dev_add_driver_gpios()
Date: Mon, 12 Jun 2017 18:44:16 +0300
Message-ID: <20170612154416.82847-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Switch to use managed variant of acpi_dev_add_driver_gpios() to simplify
error path and fix potentially wrong assignment if ->probe() fails.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/st33zp24/i2c.c | 3 +--
 drivers/char/tpm/st33zp24/spi.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/i2c.c b/drivers/char/tpm/st33zp24/i2c.c
index 1b10e38f214e..be5d1abd3e8e 100644
--- a/drivers/char/tpm/st33zp24/i2c.c
+++ b/drivers/char/tpm/st33zp24/i2c.c
@@ -127,7 +127,7 @@ static int st33zp24_i2c_acpi_request_resources(struct i2c_client *client)
 	struct device *dev = &client->dev;
 	int ret;
 
-	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_st33zp24_gpios);
+	ret = devm_acpi_dev_add_driver_gpios(dev, acpi_st33zp24_gpios);
 	if (ret)
 		return ret;
 
@@ -285,7 +285,6 @@ static int st33zp24_i2c_remove(struct i2c_client *client)
 	if (ret)
 		return ret;
 
-	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&client->dev));
 	return 0;
 }
 
diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index c69d15198f84..0fc4f20b5f83 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -246,7 +246,7 @@ static int st33zp24_spi_acpi_request_resources(struct spi_device *spi_dev)
 	struct device *dev = &spi_dev->dev;
 	int ret;
 
-	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_st33zp24_gpios);
+	ret = devm_acpi_dev_add_driver_gpios(dev, acpi_st33zp24_gpios);
 	if (ret)
 		return ret;
 
@@ -402,7 +402,6 @@ static int st33zp24_spi_remove(struct spi_device *dev)
 	if (ret)
 		return ret;
 
-	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&dev->dev));
 	return 0;
 }
 
-- 
2.11.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
