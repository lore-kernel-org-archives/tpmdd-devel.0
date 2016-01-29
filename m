From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm, tpm_crb: fix control area resource mapping
Date: Thu, 28 Jan 2016 23:13:59 -0800
Message-ID: <1454051639-15961-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Control area does not always fall in the range of memory resource given
by the ACPI object. This patch fixes the issue by ioremapping the
buffers if this is the case.

Fixes: bb76f9ba49 ("tpm_crb: Use devm_ioremap_resource")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_crb.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 8e46e40..a9688c7 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -233,27 +233,23 @@ static int crb_check_resource(struct acpi_resource *ares, void *data)
 	return 1;
 }
 
-static void __iomem *crb_access(struct device *dev, struct crb_priv *priv,
-				u64 start, u32 size)
+static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
+				 u64 start, u32 size)
 {
-	struct resource tmp = {};
-
-	tmp.start = start;
-	tmp.end = start + size - 1;
-	tmp.flags = IORESOURCE_MEM;
+	struct resource new_res = {
+		.start	= start,
+		.end	= size - 1,
+		.flags	= IORESOURCE_MEM,
+	};
 
 	/* Detect a 64 bit address on a 32 bit system */
-	if (start != tmp.start)
+	if (start != new_res.start)
 		return ERR_PTR(-EINVAL);
 
-	if (!resource_contains(&priv->res, &tmp)) {
-		dev_err(dev,
-			FW_BUG "TPM2 ACPI sub resource %pR is not in the device's region of %pR\n",
-			&tmp, &priv->res);
-		return ERR_PTR(-EINVAL);
-	}
+	if (!resource_contains(&priv->res, &new_res))
+		return devm_ioremap_resource(dev, &new_res);
 
-	return priv->iobase + (tmp.start - priv->res.start);
+	return priv->iobase + (new_res.start - priv->res.start);
 }
 
 static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
@@ -281,19 +277,19 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	if (IS_ERR(priv->iobase))
 		return PTR_ERR(priv->iobase);
 
-	priv->cca = crb_access(dev, priv, buf->control_address, 0x1000);
+	priv->cca = crb_map_res(dev, priv, buf->control_address, 0x1000);
 	if (IS_ERR(priv->cca))
 		return PTR_ERR(priv->cca);
 
-	pa = ((u64)ioread32(&priv->cca->cmd_pa_high) << 32) |
-	     (u64)ioread32(&priv->cca->cmd_pa_low);
-	priv->cmd = crb_access(dev, priv, pa, ioread32(&priv->cca->cmd_size));
+	pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
+	      (u64) ioread32(&priv->cca->cmd_pa_low);
+	priv->cmd = crb_map_res(dev, priv, pa, ioread32(&priv->cca->cmd_size));
 	if (IS_ERR(priv->cmd))
 		return PTR_ERR(priv->cmd);
 
 	memcpy_fromio(&pa, &priv->cca->rsp_pa, 8);
 	pa = le64_to_cpu(pa);
-	priv->rsp = crb_access(dev, priv, pa, ioread32(&priv->cca->rsp_size));
+	priv->rsp = crb_map_res(dev, priv, pa, ioread32(&priv->cca->rsp_size));
 	return PTR_ERR_OR_ZERO(priv->rsp);
 }
 
-- 
2.7.0.rc3
