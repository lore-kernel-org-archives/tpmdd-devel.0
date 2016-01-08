From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v4 7/7] tpm_crb: Use devm_ioremap_resource
Date: Thu,  7 Jan 2016 17:36:26 -0700
Message-ID: <1452213386-21460-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1452213386-21460-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1452213386-21460-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

To support the force mode in tpm_tis we need to use resource locking
in tpm_crb as well, via devm_ioremap_resource.

The light restructuring better aligns crb and tis and makes it easier
to see the that new changes make sense.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 157 +++++++++++++++++++++++++++++++--------------
 1 file changed, 108 insertions(+), 49 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 0237006dc4d8..1f844cc63016 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -77,6 +77,8 @@ enum crb_flags {
 
 struct crb_priv {
 	unsigned int flags;
+	struct resource res;
+	void __iomem *iobase;
 	struct crb_control_area __iomem *cca;
 	u8 __iomem *cmd;
 	u8 __iomem *rsp;
@@ -196,22 +198,121 @@ static const struct tpm_class_ops tpm_crb = {
 	.req_complete_val = CRB_STS_COMPLETE,
 };
 
-static int crb_acpi_add(struct acpi_device *device)
+static int crb_init(struct acpi_device *device, struct crb_priv *priv)
 {
 	struct tpm_chip *chip;
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
+static int crb_check_resource(struct acpi_resource *ares, void *data)
+{
+	struct crb_priv *priv = data;
+	struct resource res;
+
+	if (acpi_dev_resource_memory(ares, &res))
+		priv->res = res;
+
+	return 1;
+}
+
+static void __iomem *crb_access(struct device *dev, struct crb_priv *priv,
+				u64 start, u32 size)
+{
+	struct resource tmp = {};
+
+	tmp.start = start;
+	tmp.end = start + size - 1;
+	tmp.flags = IORESOURCE_MEM;
+
+	/* Detect a 64 bit address on a 32 bit system */
+	if (start != tmp.start)
+		return ERR_PTR(-EINVAL);
+
+	if (!resource_contains(&priv->res, &tmp)) {
+		dev_err(dev,
+			FW_BUG "TPM2 ACPI sub resource %pR is not in the device's region of %pR\n",
+			&tmp, &priv->res);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return priv->iobase + (tmp.start - priv->res.start);
+}
+
+static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
+		      struct acpi_table_tpm2 *buf)
+{
+	struct list_head resources;
+	struct device *dev = &device->dev;
+	u64 pa;
+	int ret;
+
+	INIT_LIST_HEAD(&resources);
+	ret = acpi_dev_get_resources(device, &resources, crb_check_resource,
+				     priv);
+	if (ret < 0)
+		return ret;
+	acpi_dev_free_resource_list(&resources);
+
+	if (resource_type(&priv->res) != IORESOURCE_MEM) {
+		dev_err(dev,
+			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
+		return -EINVAL;
+	}
+
+	priv->iobase = devm_ioremap_resource(dev, &priv->res);
+	if (IS_ERR(priv->iobase))
+		return PTR_ERR(priv->iobase);
+
+	priv->cca = crb_access(dev, priv, buf->control_address, 0x1000);
+	if (IS_ERR(priv->cca))
+		return PTR_ERR(priv->cca);
+
+	pa = ((u64)ioread32(&priv->cca->cmd_pa_high) << 32) |
+	     (u64)ioread32(&priv->cca->cmd_pa_low);
+	priv->cmd = crb_access(dev, priv, pa, ioread32(&priv->cca->cmd_size));
+	if (IS_ERR(priv->cmd))
+		return PTR_ERR(priv->cmd);
+
+	memcpy_fromio(&pa, &priv->cca->rsp_pa, 8);
+	pa = le64_to_cpu(pa);
+	priv->rsp = crb_access(dev, priv, pa, ioread32(&priv->cca->rsp_size));
+	if (IS_ERR(priv->rsp))
+		return PTR_ERR(priv->rsp);
+	return 0;
+}
+
+static int crb_acpi_add(struct acpi_device *device)
+{
 	struct acpi_table_tpm2 *buf;
 	struct crb_priv *priv;
 	struct device *dev = &device->dev;
 	acpi_status status;
 	u32 sm;
-	u64 pa;
 	int rc;
 
 	status = acpi_get_table(ACPI_SIG_TPM2, 1,
 				(struct acpi_table_header **) &buf);
 	if (ACPI_FAILURE(status) || buf->header.length < sizeof(*buf)) {
 		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
-		return -ENODEV;
+		return -EINVAL;
 	}
 
 	/* Should the FIFO driver handle this? */
@@ -219,18 +320,9 @@ static int crb_acpi_add(struct acpi_device *device)
 	if (sm == ACPI_TPM2_MEMORY_MAPPED)
 		return -ENODEV;
 
-	chip = tpmm_chip_alloc(dev, &tpm_crb);
-	if (IS_ERR(chip))
-		return PTR_ERR(chip);
-
-	chip->flags = TPM_CHIP_FLAG_TPM2;
-
-	priv = (struct crb_priv *) devm_kzalloc(dev, sizeof(struct crb_priv),
-						GFP_KERNEL);
-	if (!priv) {
-		dev_err(dev, "failed to devm_kzalloc for private data\n");
+	priv = devm_kzalloc(dev, sizeof(struct crb_priv), GFP_KERNEL);
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
 	 * report only ACPI start but in practice seems to require both
@@ -244,44 +336,11 @@ static int crb_acpi_add(struct acpi_device *device)
 	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
 		priv->flags |= CRB_FL_ACPI_START;
 
-	priv->cca = (struct crb_control_area __iomem *)
-		devm_ioremap_nocache(dev, buf->control_address, 0x1000);
-	if (!priv->cca) {
-		dev_err(dev, "ioremap of the control area failed\n");
-		return -ENOMEM;
-	}
-
-	pa = ((u64)ioread32(&priv->cca->cmd_pa_high) << 32) |
-	     (u64)ioread32(&priv->cca->cmd_pa_low);
-	priv->cmd =
-	    devm_ioremap_nocache(dev, pa, ioread32(&priv->cca->cmd_size));
-	if (!priv->cmd) {
-		dev_err(dev, "ioremap of the command buffer failed\n");
-		return -ENOMEM;
-	}
-
-	memcpy_fromio(&pa, &priv->cca->rsp_pa, 8);
-	pa = le64_to_cpu(pa);
-	priv->rsp =
-	    devm_ioremap_nocache(dev, pa, ioread32(&priv->cca->rsp_size));
-	if (!priv->rsp) {
-		dev_err(dev, "ioremap of the response buffer failed\n");
-		return -ENOMEM;
-	}
-
-	chip->vendor.priv = priv;
-
-	rc = tpm_get_timeouts(chip);
-	if (rc)
-		return rc;
-
-	chip->acpi_dev_handle = device->handle;
-
-	rc = tpm2_do_selftest(chip);
+	rc = crb_map_io(device, priv, buf);
 	if (rc)
 		return rc;
 
-	return tpm_chip_register(chip);
+	return crb_init(device, priv);
 }
 
 static int crb_acpi_remove(struct acpi_device *device)
-- 
2.1.4


------------------------------------------------------------------------------
