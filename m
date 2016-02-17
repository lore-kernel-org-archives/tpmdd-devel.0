From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm_crb: fix: associate to the correct device
Date: Wed, 17 Feb 2016 13:23:31 +0200
Message-ID: <1455708211-9653-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

At the moment for tpm_crb /proc/iomem shows the HW interface and not the
device using the memory range. This patch fixes the issue by associating
memory mappings to the TPM character device.

The end result is this:

$ cat /proc/iomem|grep MSFT -A2
dbfff000-dbffffff : MSFT0101:00
  dbfff000-dbffffff : tpm0

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 93 ++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 48 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 151689d..e0d9fbe 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -198,30 +198,6 @@ static const struct tpm_class_ops tpm_crb = {
 	.req_complete_val = CRB_STS_COMPLETE,
 };
 
-static int crb_init(struct acpi_device *device, struct crb_priv *priv)
-{
-	struct tpm_chip *chip;
-	int rc;
-
-	chip = tpmm_chip_alloc(&device->dev, &tpm_crb);
-	if (IS_ERR(chip))
-		return PTR_ERR(chip);
-
-	chip->vendor.priv = priv;
-	chip->acpi_dev_handle = device->handle;
-	chip->flags = TPM_CHIP_FLAG_TPM2;
-
-	rc = tpm_get_timeouts(chip);
-	if (rc)
-		return rc;
-
-	rc = tpm2_do_selftest(chip);
-	if (rc)
-		return rc;
-
-	return tpm_chip_register(chip);
-}
-
 static int crb_check_resource(struct acpi_resource *ares, void *data)
 {
 	struct crb_priv *priv = data;
@@ -256,32 +232,15 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
 	return priv->iobase + (new_res.start - priv->res.start);
 }
 
-static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
-		      struct acpi_table_tpm2 *buf)
+static int crb_map_io(struct device *dev, u64 cca_pa, struct crb_priv *priv)
 {
-	struct list_head resources;
-	struct device *dev = &device->dev;
 	u64 pa;
-	int ret;
-
-	INIT_LIST_HEAD(&resources);
-	ret = acpi_dev_get_resources(device, &resources, crb_check_resource,
-				     priv);
-	if (ret < 0)
-		return ret;
-	acpi_dev_free_resource_list(&resources);
-
-	if (resource_type(&priv->res) != IORESOURCE_MEM) {
-		dev_err(dev,
-			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
-		return -EINVAL;
-	}
 
 	priv->iobase = devm_ioremap_resource(dev, &priv->res);
 	if (IS_ERR(priv->iobase))
 		return PTR_ERR(priv->iobase);
 
-	priv->cca = crb_map_res(dev, priv, buf->control_address, 0x1000);
+	priv->cca = crb_map_res(dev, priv, cca_pa, 0x1000);
 	if (IS_ERR(priv->cca))
 		return PTR_ERR(priv->cca);
 
@@ -297,11 +256,41 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	return PTR_ERR_OR_ZERO(priv->rsp);
 }
 
+static int crb_init(struct acpi_device *device, u64 cca_pa,
+		    struct crb_priv *priv)
+{
+	struct tpm_chip *chip;
+	int rc;
+
+	chip = tpmm_chip_alloc(&device->dev, &tpm_crb);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
+
+	chip->vendor.priv = priv;
+	chip->acpi_dev_handle = device->handle;
+	chip->flags = TPM_CHIP_FLAG_TPM2;
+
+	rc = crb_map_io(&chip->dev, cca_pa, priv);
+	if (rc)
+		return rc;
+
+	rc = tpm_get_timeouts(chip);
+	if (rc)
+		return rc;
+
+	rc = tpm2_do_selftest(chip);
+	if (rc)
+		return rc;
+
+	return tpm_chip_register(chip);
+}
+
 static int crb_acpi_add(struct acpi_device *device)
 {
 	struct acpi_table_tpm2 *buf;
 	struct crb_priv *priv;
 	struct device *dev = &device->dev;
+	struct list_head resources;
 	acpi_status status;
 	u32 sm;
 	int rc;
@@ -322,6 +311,18 @@ static int crb_acpi_add(struct acpi_device *device)
 	if (!priv)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&resources);
+	rc = acpi_dev_get_resources(device, &resources, crb_check_resource,
+				    priv);
+	if (rc < 0)
+		return rc;
+	acpi_dev_free_resource_list(&resources);
+
+	if (resource_type(&priv->res) != IORESOURCE_MEM) {
+		dev_err(dev, FW_BUG "The ACPI device does not have a memory resource\n");
+		return -EINVAL;
+	}
+
 	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
 	 * report only ACPI start but in practice seems to require both
 	 * ACPI start and CRB start.
@@ -334,11 +335,7 @@ static int crb_acpi_add(struct acpi_device *device)
 	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
 		priv->flags |= CRB_FL_ACPI_START;
 
-	rc = crb_map_io(device, priv, buf);
-	if (rc)
-		return rc;
-
-	return crb_init(device, priv);
+	return crb_init(device, buf->control_address, priv);
 }
 
 static int crb_acpi_remove(struct acpi_device *device)
-- 
2.7.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
