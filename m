From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: drop int_queue from tpm_vendor_specific
Date: Tue, 22 Mar 2016 06:20:09 +0200
Message-ID: <1458620409-15603-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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

Drop field int_queue from tpm_vendor_specific as it is used only by
tpm_tis. Probably all of the fields should be eventually dropped and
moved to the private structures of different drivers but it is better to
do this one step at a time in order not to break anything.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm.h             |  1 -
 drivers/char/tpm/tpm_i2c_nuvoton.c |  1 -
 drivers/char/tpm/tpm_tis.c         | 19 ++++++++++++-------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index f197eef..4764545 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -148,7 +148,6 @@ struct tpm_vendor_specific {
 	void *priv;
 
 	wait_queue_head_t read_queue;
-	wait_queue_head_t int_queue;
 
 	u16 manufacturer_id;
 };
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index d61d43f..a43b5f3 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -540,7 +540,6 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	init_waitqueue_head(&chip->vendor.read_queue);
-	init_waitqueue_head(&chip->vendor.int_queue);
 
 	/* Default timeouts */
 	chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index eed3bf5..7d7a776 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -95,6 +95,7 @@ struct tpm_info {
 
 struct priv_data {
 	bool irq_tested;
+	wait_queue_head_t int_queue;
 };
 
 #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
@@ -157,6 +158,7 @@ static void release_locality(struct tpm_chip *chip, int l, int force)
 
 static int request_locality(struct tpm_chip *chip, int l)
 {
+	struct priv_data *priv = chip->vendor.priv;
 	unsigned long stop, timeout;
 	long rc;
 
@@ -173,7 +175,7 @@ again:
 		timeout = stop - jiffies;
 		if ((long)timeout <= 0)
 			return -1;
-		rc = wait_event_interruptible_timeout(chip->vendor.int_queue,
+		rc = wait_event_interruptible_timeout(priv->int_queue,
 						      (check_locality
 						       (chip, l) >= 0),
 						      timeout);
@@ -249,6 +251,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 
 static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
+	struct priv_data *priv = chip->vendor.priv;
 	int size = 0;
 	int expected, status;
 
@@ -279,7 +282,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	}
 
 	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
-			  &chip->vendor.int_queue, false);
+			  &priv->int_queue, false);
 	status = tpm_tis_status(chip);
 	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
 		dev_err(&chip->dev, "Error left over data\n");
@@ -304,6 +307,7 @@ MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
  */
 static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 {
+	struct priv_data *priv = chip->vendor.priv;
 	int rc, status, burstcnt;
 	size_t count = 0;
 
@@ -315,7 +319,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 		tpm_tis_ready(chip);
 		if (wait_for_tpm_stat
 		    (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
-		     &chip->vendor.int_queue, false) < 0) {
+		     &priv->int_queue, false) < 0) {
 			rc = -ETIME;
 			goto out_err;
 		}
@@ -330,7 +334,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 		}
 
 		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
-				  &chip->vendor.int_queue, false);
+				  &priv->int_queue, false);
 		status = tpm_tis_status(chip);
 		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
@@ -342,7 +346,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	iowrite8(buf[count],
 		 chip->vendor.iobase + TPM_DATA_FIFO(chip->vendor.locality));
 	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
-			  &chip->vendor.int_queue, false);
+			  &priv->int_queue, false);
 	status = tpm_tis_status(chip);
 	if ((status & TPM_STS_DATA_EXPECT) != 0) {
 		rc = -EIO;
@@ -537,6 +541,7 @@ static const struct tpm_class_ops tpm_tis = {
 static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
+	struct priv_data *priv = chip->vendor.priv;
 	u32 interrupt;
 	int i;
 
@@ -556,7 +561,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	if (interrupt &
 	    (TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_STS_VALID_INT |
 	     TPM_INTF_CMD_READY_INT))
-		wake_up_interruptible(&chip->vendor.int_queue);
+		wake_up_interruptible(&priv->int_queue);
 
 	/* Clear interrupts handled with TPM_EOI */
 	iowrite32(interrupt,
@@ -773,7 +778,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 
 	/* INTERRUPT Setup */
 	init_waitqueue_head(&chip->vendor.read_queue);
-	init_waitqueue_head(&chip->vendor.int_queue);
+	init_waitqueue_head(&priv->int_queue);
 	if (interrupts && tpm_info->irq != -1) {
 		if (tpm_info->irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
-- 
2.7.3


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
