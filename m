From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] tmp/tpm_crb: fix Intel PTT hw bug during
	idle state
Date: Wed,  7 Sep 2016 13:25:49 +0300
Message-ID: <1473243950-23579-3-git-send-email-tomas.winkler@intel.com>
References: <1473243950-23579-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1473243950-23579-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

There is a HW bug in Skylake, Kabylake, and Broxton PCH Intel PTT device,
where most of the registers in the control area except START, REQUEST,
CANCEL, and LOC_CTRL lost retention when the device is in the idle state.
Hence we need to bring the device to ready state before accessing the
other registers. The fix brings device to ready state before trying to read
command and response buffer addresses in order to remap the for access.

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 98a7fdfe9936..cf9aab698dfe 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -328,6 +328,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	struct list_head resources;
 	struct resource io_res;
 	struct device *dev = &device->dev;
+	u32 pa_high, pa_low;
 	u64 cmd_pa;
 	u32 cmd_size;
 	u64 rsp_pa;
@@ -335,15 +336,14 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	int ret;
 
 	INIT_LIST_HEAD(&resources);
-	ret = acpi_dev_get_resources(device, &resources, crb_check_resource,
-				     &io_res);
+	ret = acpi_dev_get_resources(device, &resources,
+				     crb_check_resource, &io_res);
 	if (ret < 0)
 		return ret;
 	acpi_dev_free_resource_list(&resources);
 
 	if (resource_type(&io_res) != IORESOURCE_MEM) {
-		dev_err(dev,
-			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
+		dev_err(dev, FW_BUG "TPM2 ACPI table does not define a memory resource\n");
 		return -EINVAL;
 	}
 
@@ -356,12 +356,24 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	if (IS_ERR(priv->cca))
 		return PTR_ERR(priv->cca);
 
-	cmd_pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
-		  (u64) ioread32(&priv->cca->cmd_pa_low);
+	/*
+	 * PTT HW bug w/a: wake up the device to access
+	 * possibly not retained registers.
+	 */
+	ret = __crb_cmd_ready(dev, priv);
+	if (ret)
+		return ret;
+
+	pa_high = ioread32(&priv->cca->cmd_pa_high);
+	pa_low  = ioread32(&priv->cca->cmd_pa_low);
+	cmd_pa = ((u64)pa_high << 32) | pa_low;
 	cmd_size = ioread32(&priv->cca->cmd_size);
+
 	priv->cmd = crb_map_res(dev, priv, &io_res, cmd_pa, cmd_size);
-	if (IS_ERR(priv->cmd))
-		return PTR_ERR(priv->cmd);
+	if (IS_ERR(priv->cmd)) {
+		ret = PTR_ERR(priv->cmd);
+		goto out;
+	}
 
 	memcpy_fromio(&rsp_pa, &priv->cca->rsp_pa, 8);
 	rsp_pa = le64_to_cpu(rsp_pa);
@@ -369,7 +381,8 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 
 	if (cmd_pa != rsp_pa) {
 		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
-		return PTR_ERR_OR_ZERO(priv->rsp);
+		ret = PTR_ERR_OR_ZERO(priv->rsp);
+		goto out;
 	}
 
 	/* According to the PTP specification, overlapping command and response
@@ -377,10 +390,14 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	 */
 	if (cmd_size != rsp_size) {
 		dev_err(dev, FW_BUG "overlapping command and response buffer sizes are not identical");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	priv->rsp = priv->cmd;
+
+out:
+	__crb_go_idle(dev, priv);
 	return 0;
 }
 
-- 
2.7.4


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
