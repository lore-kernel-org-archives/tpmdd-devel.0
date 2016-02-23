From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 10/12] tpm: st33zp24: Add support for acpi
	probing for spi device.
Date: Tue, 23 Feb 2016 22:25:49 +0100
Message-ID: <1456262751-12096-11-git-send-email-christophe-h.ricard@st.com>
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

Add support for acpi probing. SMO3324 is used for st33zp24.
It has been tested with the following acpi node on Minnowboard:

Device (TPM1)
{
	Name (_ADR, Zero)  // _ADR: Address
	Name (_HID, "SMO3324")  // _HID: Hardware ID
	Name (_CID, "SMO3324")  // _CID: Compatible ID
	Name (_DDN, "SMO TPM")  // _DDN: DOS Device Name
	Name (_UID, One)  // _UID: Unique ID
	Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
	{
		Name (SBUF, ResourceTemplate ()
		{
			SpiSerialBus (0, PolarityLow, FourWireMode, 8,
				      ControllerInitiated, 4000000, ClockPolarityLow,
				      ClockPhaseFirst, "\\_SB.SPI1",
				      0x00, ResourceConsumer, ,)
			GpioInt (Edge, ActiveHigh, ExclusiveAndWake, PullNone, 0x0000,
				 "\\_SB.GPO2", 0x00, ResourceConsumer, ,)
			{       // Pin list
				0x0001
			}
			GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutputOnly,
				"\\_SB.GPO2", 0x00, ResourceConsumer, ,)
			{       // Pin list
				0x0002,
			}
		})
		Return (SBUF) /* \_SB_.SPI1.TPM1._CRS.SBUF */
	}
	Method (_STA, 0, NotSerialized)  // _STA: Status
	{
		Return (0x0F)
	}
}

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/spi.c | 49 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index eb351ba..173db72 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -19,8 +19,10 @@
 #include <linux/module.h>
 #include <linux/spi/spi.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of_irq.h>
 #include <linux/of_gpio.h>
+#include <linux/acpi.h>
 #include <linux/tpm.h>
 #include <linux/platform_data/st33zp24.h>
 
@@ -227,6 +229,42 @@ static const struct st33zp24_phy_ops spi_phy_ops = {
 	.recv = st33zp24_spi_recv,
 };
 
+static int st33zp24_spi_acpi_request_resources(struct st33zp24_spi_phy *phy)
+{
+	struct spi_device *spi_dev = phy->spi_device;
+	const struct acpi_device_id *id;
+	struct gpio_desc *gpiod_lpcpd;
+	struct device *dev;
+
+	if (!spi_dev)
+		return -EINVAL;
+
+	dev = &spi_dev->dev;
+
+	/* Match the struct device against a given list of ACPI IDs */
+	id = acpi_match_device(dev->driver->acpi_match_table, dev);
+	if (!id)
+		return -ENODEV;
+
+	/* Get LPCPD GPIO from ACPI */
+	gpiod_lpcpd = devm_gpiod_get_index(dev, "TPM IO LPCPD", 1,
+					   GPIOD_OUT_HIGH);
+	if (IS_ERR(gpiod_lpcpd)) {
+		dev_err(dev, "Failed to retrieve lpcpd-gpios from acpi.\n");
+		phy->io_lpcpd = -1;
+		/*
+		 * lpcpd pin is not specified. This is not an issue as
+		 * power management can be also managed by TPM specific
+		 * commands. So leave with a success status code.
+		 */
+		return 0;
+	}
+
+	phy->io_lpcpd = desc_to_gpio(gpiod_lpcpd);
+
+	return 0;
+}
+
 static int st33zp24_spi_of_request_resources(struct st33zp24_spi_phy *phy)
 {
 	struct device_node *pp;
@@ -328,6 +366,10 @@ static int st33zp24_spi_probe(struct spi_device *dev)
 		ret = st33zp24_spi_request_resources(dev, phy);
 		if (ret)
 			return ret;
+	} else if (ACPI_HANDLE(&dev->dev)) {
+		ret = st33zp24_spi_acpi_request_resources(phy);
+		if (ret)
+			return ret;
 	}
 
 	phy->latency = st33zp24_spi_evaluate_latency(phy);
@@ -362,6 +404,12 @@ static const struct of_device_id of_st33zp24_spi_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_st33zp24_spi_match);
 
+static const struct acpi_device_id st33zp24_spi_acpi_match[] = {
+	{"SMO3324"},
+	{}
+};
+MODULE_DEVICE_TABLE(acpi, st33zp24_spi_acpi_match);
+
 static SIMPLE_DEV_PM_OPS(st33zp24_spi_ops, st33zp24_pm_suspend,
 			 st33zp24_pm_resume);
 
@@ -370,6 +418,7 @@ static struct spi_driver st33zp24_spi_driver = {
 		.name = TPM_ST33_SPI,
 		.pm = &st33zp24_spi_ops,
 		.of_match_table = of_match_ptr(of_st33zp24_spi_match),
+		.acpi_match_table = ACPI_PTR(st33zp24_spi_acpi_match),
 	},
 	.probe = st33zp24_spi_probe,
 	.remove = st33zp24_spi_remove,
-- 
2.5.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
