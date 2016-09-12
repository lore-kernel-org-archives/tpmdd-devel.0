From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 2/4] tmp/tpm_crb: fix Intel PTT hw bug
	during idle state
Date: Mon, 12 Sep 2016 16:04:19 +0300
Message-ID: <1473685461-6540-3-git-send-email-tomas.winkler@intel.com>
References: <1473685461-6540-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1473685461-6540-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

There is a HW bug in Skylake, and Broxton PCH Intel PTT device, where
most of the registers in the control area except START, REQUEST, CANCEL,
and LOC_CTRL lost retention when the device is in the idle state. Hence
we need to bring the device to ready state before accessing the other
registers. The fix brings device to ready state before trying to read
command and response buffer addresses in order to remap the for access.

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
V2: cmd read need to be called also before crb_init as this will run
 self test.
V3: resend.

 drivers/char/tpm/tpm_crb.c | 47 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index b6923a8b3ff7..e945177cf2c8 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -318,6 +318,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	struct list_head resources;
 	struct resource io_res;
 	struct device *dev = &device->dev;
+	u32 pa_high, pa_low;
 	u64 cmd_pa;
 	u32 cmd_size;
 	u64 rsp_pa;
@@ -345,12 +346,27 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	if (IS_ERR(priv->cca))
 		return PTR_ERR(priv->cca);
 
-	cmd_pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
-		  (u64) ioread32(&priv->cca->cmd_pa_low);
+	/*
+	 * PTT HW bug w/a: wake up the device to access
+	 * possibly not retained registers.
+	 */
+	ret = crb_cmd_ready(dev, priv);
+	if (ret)
+		return ret;
+
+	pa_high = ioread32(&priv->cca->cmd_pa_high);
+	pa_low  = ioread32(&priv->cca->cmd_pa_low);
+	cmd_pa = ((u64)pa_high << 32) | pa_low;
 	cmd_size = ioread32(&priv->cca->cmd_size);
+
+	dev_dbg(dev, "cmd_hi = %X cmd_low = %X cmd_size %X\n",
+		pa_high, pa_low, cmd_size);
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
@@ -358,7 +374,8 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 
 	if (cmd_pa != rsp_pa) {
 		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
-		return PTR_ERR_OR_ZERO(priv->rsp);
+		ret = PTR_ERR_OR_ZERO(priv->rsp);
+		goto out;
 	}
 
 	/* According to the PTP specification, overlapping command and response
@@ -366,12 +383,18 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	 */
 	if (cmd_size != rsp_size) {
 		dev_err(dev, FW_BUG "overlapping command and response buffer sizes are not identical");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
+
 	priv->cmd_size = cmd_size;
 
 	priv->rsp = priv->cmd;
-	return 0;
+
+out:
+	crb_go_idle(dev, priv);
+
+	return ret;
 }
 
 static int crb_acpi_add(struct acpi_device *device)
@@ -415,7 +438,15 @@ static int crb_acpi_add(struct acpi_device *device)
 	if (rc)
 		return rc;
 
-	return crb_init(device, priv);
+	rc  = crb_cmd_ready(dev, priv);
+	if (rc)
+		return rc;
+
+	rc = crb_init(device, priv);
+	if (rc)
+		crb_go_idle(dev, priv);
+
+	return rc;
 }
 
 static int crb_acpi_remove(struct acpi_device *device)
-- 
2.7.4


------------------------------------------------------------------------------
