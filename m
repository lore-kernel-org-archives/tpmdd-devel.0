From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: Factor out common startup code
Date: Fri, 24 Jun 2016 12:14:37 -0600
Message-ID: <20160624181437.GB14506@obsidianresearch.com>
References: <1466324401-5054-1-git-send-email-andrew.zamansky@nuvoton.com>
	<1466324401-5054-2-git-send-email-andrew.zamansky@nuvoton.com>
	<20160619123923.GA31053@intel.com>
	<20160620210757.GB11746@obsidianresearch.com>
	<20160622122227.GA27577@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2398655082763929170=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160622122227.GA27577-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, azamansk-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============2398655082763929170==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jun 22, 2016 at 03:22:28PM +0300, Jarkko Sakkinen wrote:
> The patch set used TPM2_OPS_PROBE_TPM2 only for nuvoton driver. The more
> recent one used it incorrectly with tpm_tis.

What do you think of this approach?

https://github.com/jgunthorpe/linux/commits/for-andrew

Andrew, does this work for you?

>From 73b0f273285ed512a259aa536968175fb14c3450 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Fri, 24 Jun 2016 12:13:02 -0600
Subject: [PATCH 2/2] tpm: Add TPM 2.0 support to the Nuvoton i2c driver
 (NPCT6xx family)

The command flow is exactly the same, the core simply needs to be
told to enable TPM2 mode when the compatible string indicates a
TPM2.

Signed-off-by: Andrew Azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/devicetree/bindings/i2c/trivial-devices.txt |  1 +
 drivers/char/tpm/tpm_i2c_nuvoton.c                        | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 539874490492..d4f654276cf9 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -62,6 +62,7 @@ national,lm80		Serial Interface ACPI-Compatible Microprocessor System Hardware M
 national,lm85		Temperature sensor with integrated fan control
 national,lm92		±0.33°C Accurate, 12-Bit + Sign Temperature Sensor and Thermal Window Comparator with Two-Wire Interface
 nuvoton,npct501		i2c trusted platform module (TPM)
+nuvoton,npct601		i2c trusted platform module (TPM2)
 nxp,pca9556		Octal SMBus and I2C registered interface
 nxp,pca9557		8-bit I2C-bus and SMBus I/O port with reset
 nxp,pcf8563		Real-time clock/calendar
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index b64effcf3235..2bb6ac9a2695 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -1,5 +1,5 @@
 /******************************************************************************
- * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,
+ * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501/NPCT6XX,
  * based on the TCG TPM Interface Spec version 1.2.
  * Specifications at www.trustedcomputinggroup.org
  *
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
+#include <linux/of_device.h>
 #include "tpm.h"
 
 /* I2C interface offsets */
@@ -54,6 +55,8 @@
 
 #define I2C_DRIVER_NAME "tpm_i2c_nuvoton"
 
+#define OF_IS_TPM2 ((void *)1)
+
 struct priv_data {
 	unsigned int intrs;
 };
@@ -163,7 +166,7 @@ static int i2c_nuvoton_get_burstcount(struct i2c_client *client,
 }
 
 /*
- * WPCT301/NPCT501 SINT# supports only dataAvail
+ * WPCT301/NPCT501/NPCT6XX SINT# supports only dataAvail
  * any call to this function which is not waiting for dataAvail will
  * set queue to NULL to avoid waiting for interrupt
  */
@@ -522,6 +525,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 	int rc;
 	struct tpm_chip *chip;
 	struct device *dev = &client->dev;
+	const struct of_device_id *match;
 	u32 vid = 0;
 
 	rc = get_vid(client, &vid);
@@ -535,6 +539,10 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 	if (IS_ERR(chip))
 		return PTR_ERR(chip);
 
+	match = of_match_device(dev->driver->of_device_id, dev);
+	if (match && match->data == OF_IS_TPM2)
+		chip->flags |= TPM_CHIP_FLAG_TPM2;
+
 	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
 					 GFP_KERNEL);
 	if (!chip->vendor.priv)
@@ -623,6 +631,7 @@ MODULE_DEVICE_TABLE(i2c, i2c_nuvoton_id);
 static const struct of_device_id i2c_nuvoton_of_match[] = {
 	{.compatible = "nuvoton,npct501"},
 	{.compatible = "winbond,wpct301"},
+	{.compatible = "nuvoton,npct601", .data = OF_IS_TPM2},
 	{},
 };
 MODULE_DEVICE_TABLE(of, i2c_nuvoton_of_match);
-- 
2.1.4



--===============2398655082763929170==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
--===============2398655082763929170==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2398655082763929170==--
