From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm_crb: fix mapping of the buffers
Date: Tue, 19 Apr 2016 02:08:00 +0300
Message-ID: <1461020880-10914-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On my Lenovo x250 the following situation occurs:

[18697.813871] tpm_crb MSFT0101:00: can't request region for resource
[mem 0xacdff080-0xacdfffff]

The mapping of the control area interleaves the mapping of the command
buffer. The control area is mapped over page, which is not right. It
should mapped over sizeof(struct crb_control_area).

Fixing this issue unmasks another issue. Command and response buffers
can interleave and they do interleave on this machine.

This commit changes driver to check that the new resource does not
interleave any of the previously mapped resources. If interleaving
happens, the existing mapping is used.

I've also tested this patch on a Haswell NUC where things worked before
applying this fix.

Cc: stable@vger.kernel.org
Fixes: 1bd047be37d9 ("tpm_crb: Use devm_ioremap_resource")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_crb.c | 77 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 56 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 733cd0e..c957d85 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -75,9 +75,18 @@ enum crb_flags {
 	CRB_FL_CRB_START	= BIT(1),
 };
 
+enum crb_res {
+	CRB_RES_IOMEM,
+	CRB_RES_CONTROL,
+	CRB_RES_COMMAND,
+	CRB_RES_RESPONSE,
+	CRB_NR_RESOURCES
+};
+
 struct crb_priv {
 	unsigned int flags;
-	void __iomem *iobase;
+	struct resource res[CRB_NR_RESOURCES];
+	void __iomem *res_ptr[CRB_NR_RESOURCES];
 	struct crb_control_area __iomem *cca;
 	u8 __iomem *cmd;
 	u8 __iomem *rsp;
@@ -234,9 +243,12 @@ static int crb_check_resource(struct acpi_resource *ares, void *data)
 	return 1;
 }
 
-static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
-				 struct resource *io_res, u64 start, u32 size)
+static int crb_map_res(struct device *dev, struct crb_priv *priv,
+		       int res_i, u64 start, u32 size)
 {
+	u8 __iomem *ptr;
+	int i;
+
 	struct resource new_res = {
 		.start	= start,
 		.end	= start + size - 1,
@@ -245,12 +257,25 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
 
 	/* Detect a 64 bit address on a 32 bit system */
 	if (start != new_res.start)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
-	if (!resource_contains(io_res, &new_res))
-		return devm_ioremap_resource(dev, &new_res);
+	for (i = 0; i < CRB_NR_RESOURCES; i++) {
+		if (resource_contains(&priv->res[i], &new_res)) {
+			priv->res[res_i] = new_res;
+			priv->res_ptr[res_i] = priv->res_ptr[i] +
+				(new_res.start - priv->res[i].start);
+			return 0;
+		}
+	}
 
-	return priv->iobase + (new_res.start - io_res->start);
+	ptr = devm_ioremap_resource(dev, &new_res);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	priv->res[res_i] = new_res;
+	priv->res_ptr[res_i] = ptr;
+
+	return 0;
 }
 
 static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
@@ -275,27 +300,37 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 		return -EINVAL;
 	}
 
-	priv->iobase = devm_ioremap_resource(dev, &io_res);
-	if (IS_ERR(priv->iobase))
-		return PTR_ERR(priv->iobase);
+	ret = crb_map_res(dev, priv, CRB_RES_IOMEM, io_res.start,
+			  io_res.end - io_res.start + 1);
+	if (ret)
+		return ret;
 
-	priv->cca = crb_map_res(dev, priv, &io_res, buf->control_address,
-				0x1000);
-	if (IS_ERR(priv->cca))
-		return PTR_ERR(priv->cca);
+	ret = crb_map_res(dev, priv, CRB_RES_CONTROL, buf->control_address,
+			  sizeof(struct crb_control_area));
+	if (ret)
+		return ret;
+
+	priv->cca = priv->res_ptr[CRB_RES_CONTROL];
 
 	pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
 	      (u64) ioread32(&priv->cca->cmd_pa_low);
-	priv->cmd = crb_map_res(dev, priv, &io_res, pa,
-				ioread32(&priv->cca->cmd_size));
-	if (IS_ERR(priv->cmd))
-		return PTR_ERR(priv->cmd);
+	ret = crb_map_res(dev, priv, CRB_RES_COMMAND, pa,
+			  ioread32(&priv->cca->cmd_size));
+	if (ret)
+		return ret;
+
+	priv->cmd = priv->res_ptr[CRB_RES_COMMAND];
 
 	memcpy_fromio(&pa, &priv->cca->rsp_pa, 8);
 	pa = le64_to_cpu(pa);
-	priv->rsp = crb_map_res(dev, priv, &io_res, pa,
-				ioread32(&priv->cca->rsp_size));
-	return PTR_ERR_OR_ZERO(priv->rsp);
+	ret = crb_map_res(dev, priv, CRB_RES_RESPONSE, pa,
+			  ioread32(&priv->cca->rsp_size));
+	if (ret)
+		return ret;
+
+	priv->rsp = priv->res_ptr[CRB_RES_RESPONSE];
+
+	return 0;
 }
 
 static int crb_acpi_add(struct acpi_device *device)
-- 
2.7.4

