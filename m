From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] tpm: Move irqs field from
	tpm_vendor_specific to tpm_chip structure
Date: Wed, 23 Mar 2016 21:17:19 +0100
Message-ID: <1458764240-24185-5-git-send-email-christophe-h.ricard@st.com>
References: <1458764240-24185-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1458764240-24185-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

In order to complete the tpm_vendor_specific cleanup structure move irqs
specific fields to tpm_chip. It make sense to be in this place as those
fields are part of the tpm properties.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 26 +++++++++++++-------------
 drivers/char/tpm/tpm-interface.c     |  4 ++--
 drivers/char/tpm/tpm.h               |  7 +++----
 drivers/char/tpm/tpm_i2c_atmel.c     |  2 +-
 drivers/char/tpm/tpm_i2c_infineon.c  |  2 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c   | 28 ++++++++++++++--------------
 drivers/char/tpm/tpm_tis.c           |  8 ++++----
 drivers/char/tpm/xen-tpmfront.c      | 10 +++++-----
 8 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 9e91ca7..82dc4d11 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -288,10 +288,10 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 
 	stop = jiffies + timeout;
 
-	if (chip->vendor.irq) {
+	if (chip->irq) {
 		cur_intrs = tpm_dev->intrs;
 		clear_interruption(tpm_dev);
-		enable_irq(chip->vendor.irq);
+		enable_irq(chip->irq);
 
 		do {
 			if (ret == -ERESTARTSYS && freezing(current))
@@ -314,7 +314,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 			}
 		} while (ret == -ERESTARTSYS && freezing(current));
 
-		disable_irq_nosync(chip->vendor.irq);
+		disable_irq_nosync(chip->irq);
 
 	} else {
 		do {
@@ -346,7 +346,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 	       wait_for_stat(chip,
 			     TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 			     chip->vendor.timeout_c,
-			     &chip->vendor.read_queue, true) == 0) {
+			     &chip->read_queue, true) == 0) {
 		burstcnt = get_burstcount(chip);
 		if (burstcnt < 0)
 			return burstcnt;
@@ -375,8 +375,8 @@ static irqreturn_t tpm_ioserirq_handler(int irq, void *dev_id)
 	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
 
 	tpm_dev->intrs++;
-	wake_up_interruptible(&chip->vendor.read_queue);
-	disable_irq_nosync(chip->vendor.irq);
+	wake_up_interruptible(&chip->read_queue);
+	disable_irq_nosync(chip->irq);
 
 	return IRQ_HANDLED;
 } /* tpm_ioserirq_handler() */
@@ -415,7 +415,7 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 		st33zp24_cancel(chip);
 		if (wait_for_stat
 		    (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
-		     &chip->vendor.read_queue, false) < 0) {
+		     &chip->read_queue, false) < 0) {
 			ret = -ETIME;
 			goto out_err;
 		}
@@ -456,12 +456,12 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 	if (ret < 0)
 		goto out_err;
 
-	if (chip->vendor.irq) {
+	if (chip->irq) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 
 		ret = wait_for_stat(chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 				tpm_calc_ordinal_duration(chip, ordinal),
-				&chip->vendor.read_queue, false);
+				&chip->read_queue, false);
 		if (ret < 0)
 			goto out_err;
 	}
@@ -578,7 +578,7 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
 
 	if (irq) {
 		/* INTERRUPT Setup */
-		init_waitqueue_head(&chip->vendor.read_queue);
+		init_waitqueue_head(&chip->read_queue);
 		tpm_dev->intrs = 0;
 
 		if (request_locality(chip) != LOCALITY0) {
@@ -611,9 +611,9 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
 		if (ret < 0)
 			goto _tpm_clean_answer;
 
-		chip->vendor.irq = irq;
+		chip->irq = irq;
 
-		disable_irq_nosync(chip->vendor.irq);
+		disable_irq_nosync(chip->irq);
 
 		tpm_gen_interrupt(chip);
 	}
@@ -681,7 +681,7 @@ int st33zp24_pm_resume(struct device *dev)
 		gpio_set_value(tpm_dev->io_lpcpd, 1);
 		ret = wait_for_stat(chip,
 				TPM_STS_VALID, chip->vendor.timeout_b,
-				&chip->vendor.read_queue, false);
+				&chip->read_queue, false);
 	} else {
 		ret = tpm_pm_resume(dev);
 		if (!ret)
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 5397b64..158ddee 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -359,7 +359,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		goto out;
 	}
 
-	if (chip->vendor.irq)
+	if (chip->irq)
 		goto out_recv;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
@@ -890,7 +890,7 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 
 	stop = jiffies + timeout;
 
-	if (chip->vendor.irq) {
+	if (chip->irq) {
 again:
 		timeout = stop - jiffies;
 		if ((long)timeout <= 0)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 06d5c2a..ed837c1 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -131,15 +131,11 @@ enum tpm2_startup_types {
 struct tpm_chip;
 
 struct tpm_vendor_specific {
-	int irq;
-
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
 	bool timeout_adjusted;
 	unsigned long duration[3]; /* jiffies */
 	bool duration_adjusted;
-
-	wait_queue_head_t read_queue;
 };
 
 #define TPM_VPRIV(c)     ((c)->priv)
@@ -159,6 +155,9 @@ struct tpm_chip {
 	struct device dev;
 	struct cdev cdev;
 	void *priv;
+	int irq;
+
+	wait_queue_head_t read_queue;
 
 	/* A driver callback under ops cannot be run unless ops_sem is held
 	 * (sometimes implicitly, eg for the sysfs code). ops becomes null
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 92cd080..e76004f 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -173,7 +173,7 @@ static int i2c_atmel_probe(struct i2c_client *client,
 	chip->vendor.timeout_b = msecs_to_jiffies(TPM_I2C_LONG_TIMEOUT);
 	chip->vendor.timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
 	chip->vendor.timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
-	chip->vendor.irq = 0;
+	chip->irq = 0;
 
 	/* There is no known way to probe for this device, and all version
 	 * information seems to be read via TPM commands. Thus we rely on the
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index e74f1c1..959a025 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -586,7 +586,7 @@ static int tpm_tis_i2c_init(struct device *dev)
 		return PTR_ERR(chip);
 
 	/* Disable interrupts */
-	chip->vendor.irq = 0;
+	chip->irq = 0;
 
 	/* Default timeouts */
 	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index a9c6b2d..88c1a7e 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -176,12 +176,12 @@ static bool i2c_nuvoton_check_status(struct tpm_chip *chip, u8 mask, u8 value)
 static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
 				     u32 timeout, wait_queue_head_t *queue)
 {
-	if (chip->vendor.irq && queue) {
+	if (chip->irq && queue) {
 		s32 rc;
 		struct priv_data *priv = chip->priv;
 		unsigned int cur_intrs = priv->intrs;
 
-		enable_irq(chip->vendor.irq);
+		enable_irq(chip->irq);
 		rc = wait_event_interruptible_timeout(*queue,
 						      cur_intrs != priv->intrs,
 						      timeout);
@@ -237,7 +237,7 @@ static int i2c_nuvoton_recv_data(struct i2c_client *client,
 	while (size < count &&
 	       i2c_nuvoton_wait_for_data_avail(chip,
 					       chip->vendor.timeout_c,
-					       &chip->vendor.read_queue) == 0) {
+					       &chip->read_queue) == 0) {
 		burst_count = i2c_nuvoton_get_burstcount(client, chip);
 		if (burst_count < 0) {
 			dev_err(&chip->dev,
@@ -285,7 +285,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		 * tag, paramsize, and result
 		 */
 		status = i2c_nuvoton_wait_for_data_avail(
-			chip, chip->vendor.timeout_c, &chip->vendor.read_queue);
+			chip, chip->vendor.timeout_c, &chip->read_queue);
 		if (status != 0) {
 			dev_err(dev, "%s() timeout on dataAvail\n", __func__);
 			size = -ETIMEDOUT;
@@ -439,7 +439,7 @@ static int i2c_nuvoton_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	rc = i2c_nuvoton_wait_for_data_avail(chip,
 					     tpm_calc_ordinal_duration(chip,
 								       ordinal),
-					     &chip->vendor.read_queue);
+					     &chip->read_queue);
 	if (rc) {
 		dev_err(dev, "%s() timeout command duration\n", __func__);
 		i2c_nuvoton_ready(chip);
@@ -476,8 +476,8 @@ static irqreturn_t i2c_nuvoton_int_handler(int dummy, void *dev_id)
 	struct priv_data *priv = chip->priv;
 
 	priv->intrs++;
-	wake_up(&chip->vendor.read_queue);
-	disable_irq_nosync(chip->vendor.irq);
+	wake_up(&chip->read_queue);
+	disable_irq_nosync(chip->irq);
 	return IRQ_HANDLED;
 }
 
@@ -539,7 +539,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 	if (!chip->priv)
 		return -ENOMEM;
 
-	init_waitqueue_head(&chip->vendor.read_queue);
+	init_waitqueue_head(&chip->read_queue);
 
 	/* Default timeouts */
 	chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
@@ -552,19 +552,19 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 	 *   TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT
 	 * The IRQ should be set in the i2c_board_info (which is done
 	 * automatically in of_i2c_register_devices, for device tree users */
-	chip->vendor.irq = client->irq;
+	chip->irq = client->irq;
 
-	if (chip->vendor.irq) {
-		dev_dbg(dev, "%s() chip-vendor.irq\n", __func__);
-		rc = devm_request_irq(dev, chip->vendor.irq,
+	if (chip->irq) {
+		dev_dbg(dev, "%s() chip-irq\n", __func__);
+		rc = devm_request_irq(dev, chip->irq,
 				      i2c_nuvoton_int_handler,
 				      IRQF_TRIGGER_LOW,
 				      dev_name(&chip->dev),
 				      chip);
 		if (rc) {
 			dev_err(dev, "%s() Unable to request irq: %d for use\n",
-				__func__, chip->vendor.irq);
-			chip->vendor.irq = 0;
+				__func__, chip->irq);
+			chip->irq = 0;
 		} else {
 			/* Clear any pending interrupt */
 			i2c_nuvoton_ready(chip);
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 96cb824..ba00499 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -251,7 +251,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 	       wait_for_tpm_stat(chip,
 				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 				 chip->vendor.timeout_c,
-				 &chip->vendor.read_queue, true)
+				 &chip->read_queue, true)
 	       == 0) {
 		burstcnt = get_burstcount(chip);
 		for (; burstcnt > 0 && size < count; burstcnt--)
@@ -419,7 +419,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 
 		if (wait_for_tpm_stat
 		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
-		     &chip->vendor.read_queue, false) < 0) {
+		     &chip->read_queue, false) < 0) {
 			rc = -ETIME;
 			goto out_err;
 		}
@@ -571,7 +571,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 
 	((struct priv_data *)chip->priv)->irq_tested = true;
 	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
-		wake_up_interruptible(&chip->vendor.read_queue);
+		wake_up_interruptible(&chip->read_queue);
 	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
 		for (i = 0; i < 5; i++)
 			if (check_locality(chip, i) >= 0)
@@ -796,7 +796,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	}
 
 	/* INTERRUPT Setup */
-	init_waitqueue_head(&chip->vendor.read_queue);
+	init_waitqueue_head(&chip->read_queue);
 	init_waitqueue_head(&priv->int_queue);
 	if (interrupts && tpm_info->irq != -1) {
 		if (tpm_info->irq) {
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index 3111f27..0af9809 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -88,7 +88,7 @@ static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	/* Wait for completion of any existing command or cancellation */
 	if (wait_for_tpm_stat(chip, VTPM_STATUS_IDLE, chip->vendor.timeout_c,
-			&chip->vendor.read_queue, true) < 0) {
+			&chip->read_queue, true) < 0) {
 		vtpm_cancel(chip);
 		return -ETIME;
 	}
@@ -104,7 +104,7 @@ static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 	duration = tpm_calc_ordinal_duration(chip, ordinal);
 
 	if (wait_for_tpm_stat(chip, VTPM_STATUS_IDLE, duration,
-			&chip->vendor.read_queue, true) < 0) {
+			&chip->read_queue, true) < 0) {
 		/* got a signal or timeout, try to cancel */
 		vtpm_cancel(chip);
 		return -ETIME;
@@ -125,7 +125,7 @@ static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	/* In theory the wait at the end of _send makes this one unnecessary */
 	if (wait_for_tpm_stat(chip, VTPM_STATUS_RESULT, chip->vendor.timeout_c,
-			&chip->vendor.read_queue, true) < 0) {
+			&chip->read_queue, true) < 0) {
 		vtpm_cancel(chip);
 		return -ETIME;
 	}
@@ -161,7 +161,7 @@ static irqreturn_t tpmif_interrupt(int dummy, void *dev_id)
 	switch (priv->shr->state) {
 	case VTPM_STATE_IDLE:
 	case VTPM_STATE_FINISH:
-		wake_up_interruptible(&priv->chip->vendor.read_queue);
+		wake_up_interruptible(&priv->chip->read_queue);
 		break;
 	case VTPM_STATE_SUBMIT:
 	case VTPM_STATE_CANCEL:
@@ -179,7 +179,7 @@ static int setup_chip(struct device *dev, struct tpm_private *priv)
 	if (IS_ERR(chip))
 		return PTR_ERR(chip);
 
-	init_waitqueue_head(&chip->vendor.read_queue);
+	init_waitqueue_head(&chip->read_queue);
 
 	priv->chip = chip;
 	TPM_VPRIV(chip) = priv;
-- 
2.5.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
