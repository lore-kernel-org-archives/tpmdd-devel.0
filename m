From: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: [PATCH] tpm: do not suspend/resume if power stays on
Date: Wed,  1 Mar 2017 12:51:16 +0100
Message-ID: <20170301115116.19696-1-enric.balletbo@collabora.com>
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
To: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

The suspend/resume behavior of the TPM can be controlled
by setting "powered-while-suspended" in the DTS.

Signed-off-by: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
---
 Documentation/devicetree/bindings/tpm/tpm.txt | 25 +++++++++++++++++++++++++
 drivers/char/tpm/tpm_i2c_infineon.c           | 25 ++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/tpm/tpm.txt

diff --git a/Documentation/devicetree/bindings/tpm/tpm.txt b/Documentation/devicetree/bindings/tpm/tpm.txt
new file mode 100644
index 0000000..af4de0d
--- /dev/null
+++ b/Documentation/devicetree/bindings/tpm/tpm.txt
@@ -0,0 +1,25 @@
+TPM (Trusted Platform Module)
+
+A TPM on the I2C bus is a child of the node for the bus.
+
+Required properties:
+- compatible: should be "infineon,<chip>"
+- reg: the I2C address
+
+Optional properties:
+- powered-while-suspended: present when the TPM is left powered on between
+  suspend and resume (makes the suspend/resume callbacks do nothing).
+
+Example:
+	i2c@12C90000 {
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-max-bus-freq = <66000>;
+		gpios = <&gpa1 2 3 3 0>,
+			<&gpa1 3 3 3 0>;
+
+		tpm {
+			compatible = "infineon,slb9635tt";
+			reg = <0x20>;
+			powered-while-suspended;
+		};
+	};
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 62ee44e..19d9522 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -70,6 +70,7 @@ struct tpm_inf_dev {
 	u8 buf[TPM_BUFSIZE + sizeof(u8)]; /* max. buffer size + addr */
 	struct tpm_chip *chip;
 	enum i2c_chip_type chip_type;
+	bool powered_while_suspended;
 };
 
 static struct tpm_inf_dev tpm_dev;
@@ -599,6 +600,11 @@ static int tpm_tis_i2c_init(struct device *dev)
 		goto out_err;
 	}
 
+	if (dev->of_node &&
+	    of_get_property(dev->of_node, "powered-while-suspended", NULL)) {
+		tpm_dev.powered_while_suspended = true;
+	}
+
 	/* read four bytes from DID_VID register */
 	if (iic_tpm_read(TPM_DID_VID(0), (u8 *)&vendor, 4) < 0) {
 		dev_err(dev, "could not read vendor id\n");
@@ -662,7 +668,24 @@ static const struct of_device_id tpm_tis_i2c_of_match[] = {
 MODULE_DEVICE_TABLE(of, tpm_tis_i2c_of_match);
 #endif
 
-static SIMPLE_DEV_PM_OPS(tpm_tis_i2c_ops, tpm_pm_suspend, tpm_pm_resume);
+static int __maybe_unused tpm_tis_i2c_suspend(struct device *dev)
+{
+	if (tpm_dev.powered_while_suspended)
+		return 0;
+
+	return tpm_pm_suspend(dev);
+}
+
+static int __maybe_unused tpm_tis_i2c_resume(struct device *dev)
+{
+	if (tpm_dev.powered_while_suspended)
+		return 0;
+
+	return tpm_pm_resume(dev);
+}
+
+static SIMPLE_DEV_PM_OPS(tpm_tis_i2c_ops, tpm_tis_i2c_suspend,
+			 tpm_tis_i2c_resume);
 
 static int tpm_tis_i2c_probe(struct i2c_client *client,
 			     const struct i2c_device_id *id)
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
