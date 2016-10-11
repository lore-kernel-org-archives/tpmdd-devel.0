From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RFC 1/3] tpm_crb: expand struct
	crb_control_area to struct crb_regs
Date: Tue, 11 Oct 2016 12:23:03 +0300
Message-ID: <1476177787-15003-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1476177787-15003-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1476177787-15003-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

In order to allow to use locality 0, expand the data structure to expose
all of the CRB registers. The address is calculated from the control
area address in order to retain backwards compatibility to ACPI start
based hardware (pre-Skylake).

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 82 ++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 32 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 65040d7..3d021e6 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -52,18 +52,26 @@ enum crb_cancel {
 	CRB_CANCEL_INVOKE	= BIT(0),
 };
 
-struct crb_control_area {
-	u32 req;
-	u32 sts;
-	u32 cancel;
-	u32 start;
-	u32 int_enable;
-	u32 int_sts;
-	u32 cmd_size;
-	u32 cmd_pa_low;
-	u32 cmd_pa_high;
-	u32 rsp_size;
-	u64 rsp_pa;
+struct crb_regs {
+	u32 loc_state;
+	u32 reserved1;
+	u32 loc_ctrl;
+	u32 loc_sts;
+	u8 reserved2[32];
+	u64 intf_id;
+	u64 ctrl_ext;
+	/* the control area */
+	u32 ctrl_req;
+	u32 ctrl_sts;
+	u32 ctrl_cancel;
+	u32 ctrl_start;
+	u32 ctrl_int_enable;
+	u32 ctrl_int_sts;
+	u32 ctrl_cmd_size;
+	u32 ctrl_cmd_pa_low;
+	u32 ctrl_cmd_pa_high;
+	u32 ctrl_rsp_size;
+	u64 ctrl_rsp_pa;
 } __packed;
 
 enum crb_status {
@@ -78,7 +86,7 @@ enum crb_flags {
 struct crb_priv {
 	unsigned int flags;
 	void __iomem *iobase;
-	struct crb_control_area __iomem *cca;
+	struct crb_regs __iomem *regs;
 	u8 __iomem *cmd;
 	u8 __iomem *rsp;
 	u32 cmd_size;
@@ -104,7 +112,7 @@ static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
 	if (priv->flags & CRB_FL_ACPI_START)
 		return 0;
 
-	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->cca->req);
+	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs->ctrl_req);
 	/* we don't really care when this settles */
 
 	return 0;
@@ -128,16 +136,18 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
 					struct crb_priv *priv)
 {
 	ktime_t stop, start;
+	u32 req;
 
 	if (priv->flags & CRB_FL_ACPI_START)
 		return 0;
 
-	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->cca->req);
+	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs->ctrl_req);
 
 	start = ktime_get();
 	stop = ktime_add(start, ms_to_ktime(TPM2_TIMEOUT_C));
 	do {
-		if (!(ioread32(&priv->cca->req) & CRB_CTRL_REQ_CMD_READY)) {
+		req = ioread32(&priv->regs->ctrl_req);
+		if (!(req & CRB_CTRL_REQ_CMD_READY)) {
 			dev_dbg(dev, "cmdReady in %lld usecs\n",
 				ktime_to_us(ktime_sub(ktime_get(), start)));
 			return 0;
@@ -145,7 +155,7 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
 		usleep_range(50, 100);
 	} while (ktime_before(ktime_get(), stop));
 
-	if (ioread32(&priv->cca->req) & CRB_CTRL_REQ_CMD_READY) {
+	if (ioread32(&priv->regs->ctrl_req) & CRB_CTRL_REQ_CMD_READY) {
 		dev_warn(dev, "cmdReady timed out\n");
 		return -ETIME;
 	}
@@ -158,7 +168,7 @@ static u8 crb_status(struct tpm_chip *chip)
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
 	u8 sts = 0;
 
-	if ((ioread32(&priv->cca->start) & CRB_START_INVOKE) !=
+	if ((ioread32(&priv->regs->ctrl_start) & CRB_START_INVOKE) !=
 	    CRB_START_INVOKE)
 		sts |= CRB_DRV_STS_COMPLETE;
 
@@ -174,7 +184,7 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	if (count < 6)
 		return -EIO;
 
-	if (ioread32(&priv->cca->sts) & CRB_CTRL_STS_ERROR)
+	if (ioread32(&priv->regs->ctrl_sts) & CRB_CTRL_STS_ERROR)
 		return -EIO;
 
 	memcpy_fromio(buf, priv->rsp, 6);
@@ -213,7 +223,7 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	/* Zero the cancel register so that the next command will not get
 	 * canceled.
 	 */
-	iowrite32(0, &priv->cca->cancel);
+	iowrite32(0, &priv->regs->ctrl_cancel);
 
 	if (len > priv->cmd_size) {
 		dev_err(&chip->dev, "invalid command count value %zd %d\n",
@@ -227,7 +237,7 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	wmb();
 
 	if (priv->flags & CRB_FL_CRB_START)
-		iowrite32(CRB_START_INVOKE, &priv->cca->start);
+		iowrite32(CRB_START_INVOKE, &priv->regs->ctrl_start);
 
 	if (priv->flags & CRB_FL_ACPI_START)
 		rc = crb_do_acpi_start(chip);
@@ -239,7 +249,7 @@ static void crb_cancel(struct tpm_chip *chip)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
 
-	iowrite32(CRB_CANCEL_INVOKE, &priv->cca->cancel);
+	iowrite32(CRB_CANCEL_INVOKE, &priv->regs->ctrl_cancel);
 
 	if ((priv->flags & CRB_FL_ACPI_START) && crb_do_acpi_start(chip))
 		dev_err(&chip->dev, "ACPI Start failed\n");
@@ -248,7 +258,7 @@ static void crb_cancel(struct tpm_chip *chip)
 static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
-	u32 cancel = ioread32(&priv->cca->cancel);
+	u32 cancel = ioread32(&priv->regs->ctrl_cancel);
 
 	return (cancel & CRB_CANCEL_INVOKE) == CRB_CANCEL_INVOKE;
 }
@@ -302,6 +312,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	struct list_head resources;
 	struct resource io_res;
 	struct device *dev = &device->dev;
+	void *ctrl;
 	u32 pa_high, pa_low;
 	u64 cmd_pa;
 	u32 cmd_size;
@@ -325,10 +336,17 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	if (IS_ERR(priv->iobase))
 		return PTR_ERR(priv->iobase);
 
-	priv->cca = crb_map_res(dev, priv, &io_res, buf->control_address,
-				sizeof(struct crb_control_area));
-	if (IS_ERR(priv->cca))
-		return PTR_ERR(priv->cca);
+	ctrl = crb_map_res(dev, priv, &io_res, buf->control_address,
+			   sizeof(struct crb_regs) -
+			   offsetof(struct crb_regs, ctrl_req));
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	/* The control area always overrlaps IO memory mapped from the ACPI
+	 * object with CRB start only devices. Thus, this is perfectly safe.
+	 */
+	priv->regs = (void *)((unsigned long)ctrl -
+		offsetof(struct crb_regs, ctrl_req));
 
 	/*
 	 * PTT HW bug w/a: wake up the device to access
@@ -338,10 +356,10 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	if (ret)
 		return ret;
 
-	pa_high = ioread32(&priv->cca->cmd_pa_high);
-	pa_low  = ioread32(&priv->cca->cmd_pa_low);
+	pa_high = ioread32(&priv->regs->ctrl_cmd_pa_high);
+	pa_low  = ioread32(&priv->regs->ctrl_cmd_pa_low);
 	cmd_pa = ((u64)pa_high << 32) | pa_low;
-	cmd_size = ioread32(&priv->cca->cmd_size);
+	cmd_size = ioread32(&priv->regs->ctrl_cmd_size);
 
 	dev_dbg(dev, "cmd_hi = %X cmd_low = %X cmd_size %X\n",
 		pa_high, pa_low, cmd_size);
@@ -352,9 +370,9 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 		goto out;
 	}
 
-	memcpy_fromio(&rsp_pa, &priv->cca->rsp_pa, 8);
+	memcpy_fromio(&rsp_pa, &priv->regs->ctrl_rsp_pa, 8);
 	rsp_pa = le64_to_cpu(rsp_pa);
-	rsp_size = ioread32(&priv->cca->rsp_size);
+	rsp_size = ioread32(&priv->regs->ctrl_rsp_size);
 
 	if (cmd_pa != rsp_pa) {
 		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
