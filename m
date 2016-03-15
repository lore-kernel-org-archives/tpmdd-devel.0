From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm_crb: drop struct resource res from struct
	crb_priv
Date: Tue, 15 Mar 2016 23:36:40 +0200
Message-ID: <1458077800-22594-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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

The iomem resource is needed only temporarily so it is better to pass
it on instead of storing it permanently. Named the variable as io_res
so that the code better documents itself.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index a12b319..8e02c44 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -77,7 +77,6 @@ enum crb_flags {
 
 struct crb_priv {
 	unsigned int flags;
-	struct resource res;
 	void __iomem *iobase;
 	struct crb_control_area __iomem *cca;
 	u8 __iomem *cmd;
@@ -224,19 +223,19 @@ static int crb_init(struct acpi_device *device, struct crb_priv *priv)
 
 static int crb_check_resource(struct acpi_resource *ares, void *data)
 {
-	struct crb_priv *priv = data;
+	struct resource *io_res = data;
 	struct resource res;
 
 	if (acpi_dev_resource_memory(ares, &res)) {
-		priv->res = res;
-		priv->res.name = NULL;
+		*io_res = res;
+		io_res->name = NULL;
 	}
 
 	return 1;
 }
 
 static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
-				 u64 start, u32 size)
+				 struct resource *io_res, u64 start, u32 size)
 {
 	struct resource new_res = {
 		.start	= start,
@@ -248,50 +247,54 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
 	if (start != new_res.start)
 		return ERR_PTR(-EINVAL);
 
-	if (!resource_contains(&priv->res, &new_res))
+	if (!resource_contains(io_res, &new_res))
 		return devm_ioremap_resource(dev, &new_res);
 
-	return priv->iobase + (new_res.start - priv->res.start);
+	return priv->iobase + (new_res.start - io_res->start);
 }
 
 static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 		      struct acpi_table_tpm2 *buf)
 {
 	struct list_head resources;
+	struct resource io_res;
 	struct device *dev = &device->dev;
 	u64 pa;
 	int ret;
 
 	INIT_LIST_HEAD(&resources);
 	ret = acpi_dev_get_resources(device, &resources, crb_check_resource,
-				     priv);
+				     &io_res);
 	if (ret < 0)
 		return ret;
 	acpi_dev_free_resource_list(&resources);
 
-	if (resource_type(&priv->res) != IORESOURCE_MEM) {
+	if (resource_type(&io_res) != IORESOURCE_MEM) {
 		dev_err(dev,
 			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
 		return -EINVAL;
 	}
 
-	priv->iobase = devm_ioremap_resource(dev, &priv->res);
+	priv->iobase = devm_ioremap_resource(dev, &io_res);
 	if (IS_ERR(priv->iobase))
 		return PTR_ERR(priv->iobase);
 
-	priv->cca = crb_map_res(dev, priv, buf->control_address, 0x1000);
+	priv->cca = crb_map_res(dev, priv, &io_res, buf->control_address,
+				0x1000);
 	if (IS_ERR(priv->cca))
 		return PTR_ERR(priv->cca);
 
 	pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
 	      (u64) ioread32(&priv->cca->cmd_pa_low);
-	priv->cmd = crb_map_res(dev, priv, pa, ioread32(&priv->cca->cmd_size));
+	priv->cmd = crb_map_res(dev, priv, &io_res, pa,
+				ioread32(&priv->cca->cmd_size));
 	if (IS_ERR(priv->cmd))
 		return PTR_ERR(priv->cmd);
 
 	memcpy_fromio(&pa, &priv->cca->rsp_pa, 8);
 	pa = le64_to_cpu(pa);
-	priv->rsp = crb_map_res(dev, priv, pa, ioread32(&priv->cca->rsp_size));
+	priv->rsp = crb_map_res(dev, priv, &io_res, pa,
+				ioread32(&priv->cca->rsp_size));
 	return PTR_ERR_OR_ZERO(priv->rsp);
 }
 
-- 
2.7.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785231&iu=/4140
