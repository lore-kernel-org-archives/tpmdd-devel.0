From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/10] tpm_tis: Introduce intermediate layer
	for TPM access
Date: Sun, 10 Apr 2016 23:22:57 +0200
Message-ID: <1460323386-16892-2-git-send-email-christophe-h.ricard@st.com>
References: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460323386-16892-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

This splits tpm_tis in a high-level protocol part and a low-level interface
for the actual TPM communication. The low-level interface can then be
implemented by additional drivers to provide access to TPMs using other
mechanisms, for example native I2C or SPI transfers, while still reusing
the same TIS protocol implementation.

Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm.h     |  41 ++++++++++
 drivers/char/tpm/tpm_tis.c | 188 ++++++++++++++++++++++++++-------------------
 include/linux/tpm.h        |  11 +++
 3 files changed, 160 insertions(+), 80 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8bc6fb8..a8f48a2 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -149,6 +149,7 @@ struct tpm_chip {
 	 * when the driver is unregistered, see tpm_try_get_ops.
 	 */
 	struct rw_semaphore ops_sem;
+	const struct tpm_class_lowlevel *lowlevel;
 	const struct tpm_class_ops *ops;
 
 	unsigned int flags;
@@ -466,6 +467,46 @@ static inline void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value)
 	tpm_buf_append(buf, (u8 *) &value2, 4);
 }
 
+static inline void tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+				  u8 *result)
+{
+	chip->lowlevel->read_bytes(chip, addr, len, result);
+}
+
+static inline u8 tpm_read8(struct tpm_chip *chip, u32 addr)
+{
+	u8 result;
+
+	chip->lowlevel->read_bytes(chip, addr, 1, &result);
+	return result;
+}
+
+static inline u16 tpm_read16(struct tpm_chip *chip, u32 addr)
+{
+	return chip->lowlevel->read16(chip, addr);
+}
+
+static inline u32 tpm_read32(struct tpm_chip *chip, u32 addr)
+{
+	return chip->lowlevel->read32(chip, addr);
+}
+
+static inline void tpm_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+				   u8 *value)
+{
+	chip->lowlevel->write_bytes(chip, addr, len, value);
+}
+
+static inline void tpm_write8(struct tpm_chip *chip, u32 addr, u8 value)
+{
+	chip->lowlevel->write_bytes(chip, addr, 1, &value);
+}
+
+static inline void tpm_write32(struct tpm_chip *chip, u32 addr, u32 value)
+{
+	chip->lowlevel->write32(chip, addr, value);
+}
+
 extern struct class *tpm_class;
 extern dev_t tpm_devt;
 extern const struct file_operations tpm_fops;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 1e45e73..eb0b6802 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -132,10 +132,9 @@ static inline int is_itpm(struct acpi_device *dev)
  * correct values in the other bits.' */
 static int wait_startup(struct tpm_chip *chip, int l)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 	unsigned long stop = jiffies + chip->timeout_a;
 	do {
-		if (ioread8(priv->iobase + TPM_ACCESS(l)) &
+		if (tpm_read8(chip, TPM_ACCESS(l)) &
 		    TPM_ACCESS_VALID)
 			return 0;
 		msleep(TPM_TIMEOUT);
@@ -147,7 +146,7 @@ static int check_locality(struct tpm_chip *chip, int l)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 
-	if ((ioread8(priv->iobase + TPM_ACCESS(l)) &
+	if ((tpm_read8(chip, TPM_ACCESS(l)) &
 	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
 		return priv->locality = l;
@@ -157,13 +156,11 @@ static int check_locality(struct tpm_chip *chip, int l)
 
 static void release_locality(struct tpm_chip *chip, int l, int force)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
-
-	if (force || (ioread8(priv->iobase + TPM_ACCESS(l)) &
+	if (force || (tpm_read8(chip, TPM_ACCESS(l)) &
 		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
 	    (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
-		iowrite8(TPM_ACCESS_ACTIVE_LOCALITY,
-			 priv->iobase + TPM_ACCESS(l));
+		tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);
+
 }
 
 static int request_locality(struct tpm_chip *chip, int l)
@@ -175,8 +172,8 @@ static int request_locality(struct tpm_chip *chip, int l)
 	if (check_locality(chip, l) >= 0)
 		return l;
 
-	iowrite8(TPM_ACCESS_REQUEST_USE,
-		 priv->iobase + TPM_ACCESS(l));
+	tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
+
 
 	stop = jiffies + chip->timeout_a;
 
@@ -211,8 +208,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 
-	return ioread8(priv->iobase +
-		       TPM_STS(priv->locality));
+	return tpm_read8(chip, TPM_STS(priv->locality));
 }
 
 static void tpm_tis_ready(struct tpm_chip *chip)
@@ -220,8 +216,7 @@ static void tpm_tis_ready(struct tpm_chip *chip)
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 
 	/* this causes the current command to be aborted */
-	iowrite8(TPM_STS_COMMAND_READY,
-		 priv->iobase + TPM_STS(priv->locality));
+	tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_COMMAND_READY);
 }
 
 static int get_burstcount(struct tpm_chip *chip)
@@ -234,11 +229,8 @@ static int get_burstcount(struct tpm_chip *chip)
 	/* which timeout value, spec has 2 answers (c & d) */
 	stop = jiffies + chip->timeout_d;
 	do {
-		burstcnt = ioread8(priv->iobase +
-				   TPM_STS(priv->locality) + 1);
-		burstcnt += ioread8(priv->iobase +
-				    TPM_STS(priv->locality) +
-				    2) << 8;
+		burstcnt = tpm_read8(chip, TPM_STS(priv->locality) + 1);
+		burstcnt += tpm_read8(chip, TPM_STS(priv->locality) + 2) << 8;
 		if (burstcnt)
 			return burstcnt;
 		msleep(TPM_TIMEOUT);
@@ -254,12 +246,11 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 	       wait_for_tpm_stat(chip,
 				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 				 chip->timeout_c,
-				 &priv->read_queue, true)
-	       == 0) {
-		burstcnt = get_burstcount(chip);
-		for (; burstcnt > 0 && size < count; burstcnt--)
-			buf[size++] = ioread8(priv->iobase +
-					      TPM_DATA_FIFO(priv->locality));
+				 &priv->read_queue, true) == 0) {
+		burstcnt = min_t(int, get_burstcount(chip), count - size);
+		tpm_read_bytes(chip, TPM_DATA_FIFO(priv->locality), burstcnt,
+			       buf + size);
+		size += burstcnt;
 	}
 	return size;
 }
@@ -341,12 +332,10 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	}
 
 	while (count < len - 1) {
-		burstcnt = get_burstcount(chip);
-		for (; burstcnt > 0 && count < len - 1; burstcnt--) {
-			iowrite8(buf[count], priv->iobase +
-				 TPM_DATA_FIFO(priv->locality));
-			count++;
-		}
+		burstcnt = min_t(int, get_burstcount(chip), len - count - 1);
+		tpm_write_bytes(chip, TPM_DATA_FIFO(priv->locality),
+				burstcnt, buf + count);
+		count += burstcnt;
 
 		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 				  &priv->int_queue, false);
@@ -358,8 +347,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	}
 
 	/* write last byte */
-	iowrite8(buf[count],
-		 priv->iobase + TPM_DATA_FIFO(priv->locality));
+	tpm_write8(chip, TPM_DATA_FIFO(priv->locality), buf[count]);
 	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 			  &priv->int_queue, false);
 	status = tpm_tis_status(chip);
@@ -381,12 +369,10 @@ static void disable_interrupts(struct tpm_chip *chip)
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 	u32 intmask;
 
-	intmask =
-	    ioread32(priv->iobase +
-		     TPM_INT_ENABLE(priv->locality));
+	intmask = tpm_read32(chip, TPM_INT_ENABLE(priv->locality));
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
-	iowrite32(intmask,
-		  priv->iobase + TPM_INT_ENABLE(priv->locality));
+	tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
+
 	devm_free_irq(&chip->dev, priv->irq, chip);
 	priv->irq = 0;
 	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
@@ -409,9 +395,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 		return rc;
 
 	/* go and do it */
-	iowrite8(TPM_STS_GO,
-		 priv->iobase + TPM_STS(priv->locality));
-
+	tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_GO);
 	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 
@@ -471,11 +455,10 @@ static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
 static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 				    unsigned long *timeout_cap)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 	int i;
 	u32 did_vid;
 
-	did_vid = ioread32(priv->iobase + TPM_DID_VID(0));
+	did_vid = tpm_read32(chip, TPM_DID_VID(0));
 
 	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
 		if (vendor_timeout_overrides[i].did_vid != did_vid)
@@ -503,7 +486,7 @@ static int probe_itpm(struct tpm_chip *chip)
 	};
 	size_t len = sizeof(cmd_getticks);
 	bool rem_itpm = itpm;
-	u16 vendor = ioread16(priv->iobase + TPM_DID_VID(0));
+	u16 vendor = tpm_read16(chip, TPM_DID_VID(0));
 
 	/* probe only iTPMS */
 	if (vendor != TPM_VID_INTEL)
@@ -561,6 +544,61 @@ static const struct tpm_class_ops tpm_tis = {
 	.req_canceled = tpm_tis_req_canceled,
 };
 
+static void tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+			       u8 *result)
+{
+	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+
+	while (len--)
+		*result++ = ioread8(priv->iobase + addr);
+}
+
+static void tpm_mem_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+				u8 *value)
+{
+	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+
+	while (len--)
+		iowrite8(*value++, priv->iobase + addr);
+}
+
+static u16 tpm_mem_read16(struct tpm_chip *chip, u32 addr)
+{
+	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+
+	return ioread16(priv->iobase + addr);
+}
+
+static void tpm_mem_write16(struct tpm_chip *chip, u32 addr, u16 value)
+{
+	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+
+	iowrite16(value, priv->iobase + addr);
+}
+
+static u32 tpm_mem_read32(struct tpm_chip *chip, u32 addr)
+{
+	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+
+	return ioread32(priv->iobase + addr);
+}
+
+static void tpm_mem_write32(struct tpm_chip *chip, u32 addr, u32 value)
+{
+	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+
+	iowrite32(value, priv->iobase + addr);
+}
+
+static const struct tpm_class_lowlevel tpm_mem = {
+	.read_bytes = tpm_mem_read_bytes,
+	.write_bytes = tpm_mem_write_bytes,
+	.read16 = tpm_mem_read16,
+	.write16 = tpm_mem_write16,
+	.read32 = tpm_mem_read32,
+	.write32 = tpm_mem_write32,
+};
+
 static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
@@ -568,8 +606,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	u32 interrupt;
 	int i;
 
-	interrupt = ioread32(priv->iobase +
-			     TPM_INT_STATUS(priv->locality));
+	interrupt = tpm_read32(chip, TPM_INT_STATUS(priv->locality));
 
 	if (interrupt == 0)
 		return IRQ_NONE;
@@ -587,10 +624,9 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 		wake_up_interruptible(&priv->int_queue);
 
 	/* Clear interrupts handled with TPM_EOI */
-	iowrite32(interrupt,
-		  priv->iobase +
-		  TPM_INT_STATUS(priv->locality));
-	ioread32(priv->iobase + TPM_INT_STATUS(priv->locality));
+	tpm_write32(chip, TPM_INT_STATUS(priv->locality), interrupt);
+
+	tpm_read32(chip, TPM_INT_STATUS(priv->locality));
 	return IRQ_HANDLED;
 }
 
@@ -612,19 +648,16 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	}
 	priv->irq = irq;
 
-	original_int_vec = ioread8(priv->iobase +
-				   TPM_INT_VECTOR(priv->locality));
-	iowrite8(irq,
-		 priv->iobase + TPM_INT_VECTOR(priv->locality));
+	original_int_vec = tpm_read8(chip, TPM_INT_VECTOR(priv->locality));
+	tpm_write8(chip, TPM_INT_VECTOR(priv->locality), irq);
 
 	/* Clear all existing */
-	iowrite32(ioread32(priv->iobase +
-			   TPM_INT_STATUS(priv->locality)),
-		  priv->iobase + TPM_INT_STATUS(priv->locality));
+	tpm_write32(chip, TPM_INT_STATUS(priv->locality),
+		    tpm_read32(chip, TPM_INT_STATUS(priv->locality)));
 
 	/* Turn on */
-	iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,
-		  priv->iobase + TPM_INT_ENABLE(priv->locality));
+	tpm_write32(chip, TPM_INT_ENABLE(priv->locality),
+		    intmask | TPM_GLOBAL_INT_ENABLE);
 
 	priv->irq_tested = false;
 
@@ -640,8 +673,9 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	 * will call disable_irq which undoes all of the above.
 	 */
 	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
-		iowrite8(original_int_vec,
-			 priv->iobase + TPM_INT_VECTOR(priv->locality));
+		tpm_write8(chip, TPM_INT_VECTOR(priv->locality),
+			   original_int_vec);
+
 		return 1;
 	}
 
@@ -658,8 +692,7 @@ static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
 	u8 original_int_vec;
 	int i;
 
-	original_int_vec = ioread8(priv->iobase +
-				   TPM_INT_VECTOR(priv->locality));
+	original_int_vec = tpm_read8(chip, TPM_INT_VECTOR(priv->locality));
 
 	if (!original_int_vec) {
 		if (IS_ENABLED(CONFIG_X86))
@@ -679,12 +712,12 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
 static void tpm_tis_remove(struct tpm_chip *chip)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
-	void __iomem *reg = priv->iobase + TPM_INT_ENABLE(priv->locality);
+	u32 reg = TPM_INT_ENABLE(priv->locality);
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
 
-	iowrite32(~TPM_GLOBAL_INT_ENABLE & ioread32(reg), reg);
+	tpm_write32(chip, reg, ~TPM_GLOBAL_INT_ENABLE & tpm_read32(chip, reg));
 	release_locality(chip, priv->locality, 1);
 }
 
@@ -712,6 +745,8 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	if (IS_ERR(priv->iobase))
 		return PTR_ERR(priv->iobase);
 
+	chip->lowlevel = &tpm_mem;
+
 	/* Maximum timeouts */
 	chip->timeout_a = TIS_TIMEOUT_A_MAX;
 	chip->timeout_b = TIS_TIMEOUT_B_MAX;
@@ -726,13 +761,11 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	}
 
 	/* Take control of the TPM's interrupt hardware and shut it off */
-	intmask = ioread32(priv->iobase +
-			   TPM_INT_ENABLE(priv->locality));
+	intmask = tpm_read32(chip, TPM_INT_ENABLE(priv->locality));
 	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
 		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
-	iowrite32(intmask,
-		  priv->iobase + TPM_INT_ENABLE(priv->locality));
+	tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
 
 	if (request_locality(chip, 0) != 0) {
 		rc = -ENODEV;
@@ -743,12 +776,12 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	if (rc)
 		goto out_err;
 
-	vendor = ioread32(priv->iobase + TPM_DID_VID(0));
+	vendor = tpm_read32(chip, TPM_DID_VID(0));
 	priv->manufacturer_id = vendor;
 
 	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
-		 vendor >> 16, ioread8(priv->iobase + TPM_RID(0)));
+		 vendor >> 16, tpm_read8(chip, TPM_RID(0)));
 
 	if (!itpm) {
 		probe = probe_itpm(chip);
@@ -764,9 +797,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 
 
 	/* Figure out the capabilities */
-	intfcaps =
-	    ioread32(priv->iobase +
-		     TPM_INTF_CAPS(priv->locality));
+	intfcaps = tpm_read32(chip, TPM_INTF_CAPS(priv->locality));
 	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
 		intfcaps);
 	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
@@ -849,18 +880,15 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 
 	/* reenable interrupts that device may have lost or
 	   BIOS/firmware may have disabled */
-	iowrite8(priv->irq, priv->iobase +
-		 TPM_INT_VECTOR(priv->locality));
+	tpm_write8(chip, TPM_INT_VECTOR(priv->locality), priv->irq);
 
-	intmask =
-	    ioread32(priv->iobase + TPM_INT_ENABLE(priv->locality));
+	intmask = tpm_read32(chip, TPM_INT_ENABLE(priv->locality));
 
 	intmask |= TPM_INTF_CMD_READY_INT
 	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
 	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
 
-	iowrite32(intmask,
-		  priv->iobase + TPM_INT_ENABLE(priv->locality));
+	tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
 }
 
 static int tpm_tis_resume(struct device *dev)
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 706e63e..19d5d426 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -46,6 +46,17 @@ struct tpm_class_ops {
 
 };
 
+struct tpm_class_lowlevel {
+	void (*read_bytes)(struct tpm_chip *chip, u32 addr, u16 len,
+			   u8 *result);
+	void (*write_bytes)(struct tpm_chip *chip, u32 addr, u16 len,
+			    u8 *value);
+	u16 (*read16)(struct tpm_chip *chip, u32 addr);
+	void (*write16)(struct tpm_chip *chip, u32 addr, u16 src);
+	u32 (*read32)(struct tpm_chip *chip, u32 addr);
+	void (*write32)(struct tpm_chip *chip, u32 addr, u32 src);
+};
+
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_is_tpm2(u32 chip_num);
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
gampad/clk?id=1444514301&iu=/ca-pub-7940484522588532
