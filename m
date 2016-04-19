From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm_crb: fix mapping of the buffers
Date: Tue, 19 Apr 2016 12:54:18 +0300
Message-ID: <1461059658-8884-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On my Lenovo x250 the following situation occurs:

[18697.813871] tpm_crb MSFT0101:00: can't request region for resource
[mem 0xacdff080-0xacdfffff]

The mapping of the control area overlaps the mapping of the command
buffer. The control area is mapped over page, which is not right. It
should mapped over sizeof(struct crb_control_area).

Fixing this issue unmasks another issue. Command and response buffers
can overlap and they do interleave on this machine. According to the PTP
specification the overlapping means that they are mapped to the same
buffer.

The commit has been also on a Haswell NUC where things worked before
applying this fix so that the both code paths for response buffer
initialization are tested.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: 1bd047be37d9 ("tpm_crb: Use devm_ioremap_resource")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 733cd0e..5afe684 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -259,7 +259,10 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	struct list_head resources;
 	struct resource io_res;
 	struct device *dev = &device->dev;
-	u64 pa;
+	u64 cmd_pa;
+	u32 cmd_size;
+	u64 rsp_pa;
+	u32 rsp_size;
 	int ret;
 
 	INIT_LIST_HEAD(&resources);
@@ -280,22 +283,36 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 		return PTR_ERR(priv->iobase);
 
 	priv->cca = crb_map_res(dev, priv, &io_res, buf->control_address,
-				0x1000);
+				sizeof(struct crb_control_area));
 	if (IS_ERR(priv->cca))
 		return PTR_ERR(priv->cca);
 
-	pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
-	      (u64) ioread32(&priv->cca->cmd_pa_low);
-	priv->cmd = crb_map_res(dev, priv, &io_res, pa,
-				ioread32(&priv->cca->cmd_size));
+	cmd_pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
+		  (u64) ioread32(&priv->cca->cmd_pa_low);
+	cmd_size = ioread32(&priv->cca->cmd_size);
+	priv->cmd = crb_map_res(dev, priv, &io_res, cmd_pa, cmd_size);
 	if (IS_ERR(priv->cmd))
 		return PTR_ERR(priv->cmd);
 
-	memcpy_fromio(&pa, &priv->cca->rsp_pa, 8);
-	pa = le64_to_cpu(pa);
-	priv->rsp = crb_map_res(dev, priv, &io_res, pa,
-				ioread32(&priv->cca->rsp_size));
-	return PTR_ERR_OR_ZERO(priv->rsp);
+	memcpy_fromio(&rsp_pa, &priv->cca->rsp_pa, 8);
+	rsp_pa = le64_to_cpu(rsp_pa);
+	rsp_size = ioread32(&priv->cca->rsp_size);
+
+	if (cmd_pa != rsp_pa) {
+		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
+		return PTR_ERR_OR_ZERO(priv->rsp);
+	}
+
+	/* According to the PTP specification, overlapping command and response
+	 * buffer sizes must be identical.
+	 */
+	if (cmd_size != rsp_size) {
+		dev_err(dev, FW_BUG "overlapping command and response buffer sizes are not identical");
+		return -EINVAL;
+	}
+
+	priv->rsp = priv->cmd;
+	return 0;
 }
 
 static int crb_acpi_add(struct acpi_device *device)
-- 
2.7.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
