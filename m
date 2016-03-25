From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] tpm: drop 'irq' from struct
	tpm_vendor_specific
Date: Fri, 25 Mar 2016 22:25:58 +0100
Message-ID: <1458941160-4437-5-git-send-email-christophe-h.ricard@st.com>
References: <1458941160-4437-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1458941160-4437-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Dropped the field 'irq' from struct tpm_vendor_specific and make it available
to the various private structures in the drivers using irqs.

A dedicated flag TPM_CHIP_FLAG_USES_IRQ is added for the upper layers.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 15 ++++++++-------
 drivers/char/tpm/st33zp24/st33zp24.h |  1 +
 drivers/char/tpm/tpm-interface.c     |  4 ++--
 drivers/char/tpm/tpm.h               |  3 +--
 drivers/char/tpm/tpm_i2c_atmel.c     |  1 -
 drivers/char/tpm/tpm_i2c_infineon.c  |  3 ---
 drivers/char/tpm/tpm_i2c_nuvoton.c   | 21 ++++++++++++---------
 drivers/char/tpm/tpm_tis.c           | 30 +++++++++++++++++-------------
 drivers/char/tpm/xen-tpmfront.c      |  7 ++++---
 9 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 3c0625c..7a5de0e 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -268,10 +268,10 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 
 	stop = jiffies + timeout;
 
-	if (chip->vendor.irq) {
+	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ) {
 		cur_intrs = tpm_dev->intrs;
 		clear_interruption(tpm_dev);
-		enable_irq(chip->vendor.irq);
+		enable_irq(tpm_dev->irq);
 
 		do {
 			if (ret == -ERESTARTSYS && freezing(current))
@@ -294,7 +294,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 			}
 		} while (ret == -ERESTARTSYS && freezing(current));
 
-		disable_irq_nosync(chip->vendor.irq);
+		disable_irq_nosync(tpm_dev->irq);
 
 	} else {
 		do {
@@ -352,7 +352,7 @@ static irqreturn_t tpm_ioserirq_handler(int irq, void *dev_id)
 
 	tpm_dev->intrs++;
 	wake_up_interruptible(&chip->vendor.read_queue);
-	disable_irq_nosync(chip->vendor.irq);
+	disable_irq_nosync(tpm_dev->irq);
 
 	return IRQ_HANDLED;
 } /* tpm_ioserirq_handler() */
@@ -430,7 +430,7 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 	if (ret < 0)
 		goto out_err;
 
-	if (chip->vendor.irq) {
+	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 
 		ret = wait_for_stat(chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
@@ -585,9 +585,10 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
 		if (ret < 0)
 			goto _tpm_clean_answer;
 
-		chip->vendor.irq = irq;
+		tpm_dev->irq = irq;
+		chip->flags |= TPM_CHIP_FLAG_USES_IRQ;
 
-		disable_irq_nosync(chip->vendor.irq);
+		disable_irq_nosync(tpm_dev->irq);
 
 		tpm_gen_interrupt(chip);
 	}
diff --git a/drivers/char/tpm/st33zp24/st33zp24.h b/drivers/char/tpm/st33zp24/st33zp24.h
index b242263..b139a8d 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.h
+++ b/drivers/char/tpm/st33zp24/st33zp24.h
@@ -24,6 +24,7 @@
 struct st33zp24_dev {
 	void *phy_id;
 	const struct st33zp24_phy_ops *ops;
+	int irq;
 	u32 intrs;
 	int io_lpcpd;
 };
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 5397b64..0bdd25b 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -359,7 +359,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		goto out;
 	}
 
-	if (chip->vendor.irq)
+	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ)
 		goto out_recv;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
@@ -890,7 +890,7 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 
 	stop = jiffies + timeout;
 
-	if (chip->vendor.irq) {
+	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ) {
 again:
 		timeout = stop - jiffies;
 		if ((long)timeout <= 0)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index c4d3f41..26c8d62 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -131,8 +131,6 @@ enum tpm2_startup_types {
 struct tpm_chip;
 
 struct tpm_vendor_specific {
-	int irq;
-
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
 	bool timeout_adjusted;
@@ -151,6 +149,7 @@ struct tpm_vendor_specific {
 enum tpm_chip_flags {
 	TPM_CHIP_FLAG_REGISTERED	= BIT(0),
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
+	TPM_CHIP_FLAG_USES_IRQ		= BIT(2),
 };
 
 struct tpm_chip {
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index d357065..fe06885 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -172,7 +172,6 @@ static int i2c_atmel_probe(struct i2c_client *client,
 	chip->vendor.timeout_b = msecs_to_jiffies(TPM_I2C_LONG_TIMEOUT);
 	chip->vendor.timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
 	chip->vendor.timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
-	chip->vendor.irq = 0;
 
 	dev_set_drvdata(&chip->dev, priv);
 
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index e74f1c1..093daf9 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -585,9 +585,6 @@ static int tpm_tis_i2c_init(struct device *dev)
 	if (IS_ERR(chip))
 		return PTR_ERR(chip);
 
-	/* Disable interrupts */
-	chip->vendor.irq = 0;
-
 	/* Default timeouts */
 	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
 	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 76ac21d..bf3ba18 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -55,6 +55,7 @@
 #define I2C_DRIVER_NAME "tpm_i2c_nuvoton"
 
 struct priv_data {
+	int irq;
 	unsigned int intrs;
 };
 
@@ -176,12 +177,12 @@ static bool i2c_nuvoton_check_status(struct tpm_chip *chip, u8 mask, u8 value)
 static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
 				     u32 timeout, wait_queue_head_t *queue)
 {
-	if (chip->vendor.irq && queue) {
+	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ && queue) {
 		s32 rc;
 		struct priv_data *priv = dev_get_drvdata(&chip->dev);
 		unsigned int cur_intrs = priv->intrs;
 
-		enable_irq(chip->vendor.irq);
+		enable_irq(priv->irq);
 		rc = wait_event_interruptible_timeout(*queue,
 						      cur_intrs != priv->intrs,
 						      timeout);
@@ -477,7 +478,7 @@ static irqreturn_t i2c_nuvoton_int_handler(int dummy, void *dev_id)
 
 	priv->intrs++;
 	wake_up(&chip->vendor.read_queue);
-	disable_irq_nosync(chip->vendor.irq);
+	disable_irq_nosync(priv->irq);
 	return IRQ_HANDLED;
 }
 
@@ -554,19 +555,21 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 	 *   TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT
 	 * The IRQ should be set in the i2c_board_info (which is done
 	 * automatically in of_i2c_register_devices, for device tree users */
-	chip->vendor.irq = client->irq;
+	chip->flags |= TPM_CHIP_FLAG_USES_IRQ;
+	priv->irq = client->irq;
 
-	if (chip->vendor.irq) {
-		dev_dbg(dev, "%s() chip-vendor.irq\n", __func__);
-		rc = devm_request_irq(dev, chip->vendor.irq,
+	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ) {
+		dev_dbg(dev, "%s() priv->irq\n", __func__);
+		rc = devm_request_irq(dev, client->irq,
 				      i2c_nuvoton_int_handler,
 				      IRQF_TRIGGER_LOW,
 				      dev_name(&chip->dev),
 				      chip);
 		if (rc) {
 			dev_err(dev, "%s() Unable to request irq: %d for use\n",
-				__func__, chip->vendor.irq);
-			chip->vendor.irq = 0;
+				__func__, priv->irq);
+			chip->flags &= ~TPM_CHIP_FLAG_USES_IRQ;
+			priv->irq = 0;
 		} else {
 			/* Clear any pending interrupt */
 			i2c_nuvoton_ready(chip);
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index bf333cf..79edfc3 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -96,6 +96,7 @@ struct tpm_info {
 struct priv_data {
 	void __iomem *iobase;
 	u16 manufacturer_id;
+	int irq;
 	bool irq_tested;
 	wait_queue_head_t int_queue;
 };
@@ -178,7 +179,7 @@ static int request_locality(struct tpm_chip *chip, int l)
 
 	stop = jiffies + chip->vendor.timeout_a;
 
-	if (chip->vendor.irq) {
+	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ) {
 again:
 		timeout = stop - jiffies;
 		if ((long)timeout <= 0)
@@ -386,8 +387,9 @@ static void disable_interrupts(struct tpm_chip *chip)
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
 	iowrite32(intmask,
 		  priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
-	devm_free_irq(&chip->dev, chip->vendor.irq, chip);
-	chip->vendor.irq = 0;
+	devm_free_irq(&chip->dev, priv->irq, chip);
+	priv->irq = 0;
+	chip->flags &= ~TPM_CHIP_FLAG_USES_IRQ;
 }
 
 /*
@@ -410,7 +412,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 	iowrite8(TPM_STS_GO,
 		 priv->iobase + TPM_STS(chip->vendor.locality));
 
-	if (chip->vendor.irq) {
+	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 
 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
@@ -437,14 +439,16 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	int rc, irq;
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 
-	if (!chip->vendor.irq || priv->irq_tested)
+	if (!(chip->flags & TPM_CHIP_FLAG_USES_IRQ) || priv->irq_tested)
 		return tpm_tis_send_main(chip, buf, len);
 
 	/* Verify receipt of the expected IRQ */
-	irq = chip->vendor.irq;
-	chip->vendor.irq = 0;
+	irq = priv->irq;
+	priv->irq = 0;
+	chip->flags &= ~TPM_CHIP_FLAG_USES_IRQ;
 	rc = tpm_tis_send_main(chip, buf, len);
-	chip->vendor.irq = irq;
+	priv->irq = irq;
+	chip->flags |= TPM_CHIP_FLAG_USES_IRQ;
 	if (!priv->irq_tested)
 		msleep(1);
 	if (!priv->irq_tested)
@@ -606,7 +610,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 			 irq);
 		return -1;
 	}
-	chip->vendor.irq = irq;
+	priv->irq = irq;
 
 	original_int_vec = ioread8(priv->iobase +
 				   TPM_INT_VECTOR(chip->vendor.locality));
@@ -635,7 +639,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	/* tpm_tis_send will either confirm the interrupt is working or it
 	 * will call disable_irq which undoes all of the above.
 	 */
-	if (!chip->vendor.irq) {
+	if (!(chip->flags & TPM_CHIP_FLAG_USES_IRQ)) {
 		iowrite8(original_int_vec,
 			 priv->iobase + TPM_INT_VECTOR(chip->vendor.locality));
 		return 1;
@@ -804,7 +808,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 		if (tpm_info->irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 tpm_info->irq);
-			if (!chip->vendor.irq)
+			if (!(chip->flags & TPM_CHIP_FLAG_USES_IRQ))
 				dev_err(&chip->dev, FW_BUG
 					"TPM interrupt not working, polling instead\n");
 		} else
@@ -848,7 +852,7 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 
 	/* reenable interrupts that device may have lost or
 	   BIOS/firmware may have disabled */
-	iowrite8(chip->vendor.irq, priv->iobase +
+	iowrite8(priv->irq, priv->iobase +
 		 TPM_INT_VECTOR(chip->vendor.locality));
 
 	intmask =
@@ -867,7 +871,7 @@ static int tpm_tis_resume(struct device *dev)
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	int ret;
 
-	if (chip->vendor.irq)
+	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ)
 		tpm_tis_reenable_interrupts(chip);
 
 	ret = tpm_pm_resume(dev);
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index efd7d99..a903f86 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -28,6 +28,7 @@ struct tpm_private {
 	unsigned int evtchn;
 	int ring_ref;
 	domid_t backend_id;
+	int irq;
 };
 
 enum status_bits {
@@ -217,7 +218,7 @@ static int setup_ring(struct xenbus_device *dev, struct tpm_private *priv)
 		xenbus_dev_fatal(dev, rv, "allocating TPM irq");
 		return rv;
 	}
-	priv->chip->vendor.irq = rv;
+	priv->irq = rv;
 
  again:
 	rv = xenbus_transaction_start(&xbt);
@@ -277,8 +278,8 @@ static void ring_free(struct tpm_private *priv)
 	else
 		free_page((unsigned long)priv->shr);
 
-	if (priv->chip && priv->chip->vendor.irq)
-		unbind_from_irqhandler(priv->chip->vendor.irq, priv);
+	if (priv->irq)
+		unbind_from_irqhandler(priv->irq, priv);
 
 	kfree(priv);
 }
-- 
2.5.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
