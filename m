From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 03/12] tpm_tis: Introduce intermediate
	layer for TPM access
Date: Wed, 13 Apr 2016 21:55:42 +0200
Message-ID: <1460577351-24632-4-git-send-email-christophe-h.ricard@st.com>
References: <1460577351-24632-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460577351-24632-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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
 drivers/char/tpm/tpm_tis.c      | 207 ++++++++++++++++++++++------------------
 drivers/char/tpm/tpm_tis_core.h |  65 +++++++++++++
 2 files changed, 179 insertions(+), 93 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 3b84ade..9f6d100 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -127,10 +127,9 @@ static inline int is_itpm(struct acpi_device *dev)
 static int wait_startup(struct tpm_chip *chip, int l)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	unsigned long stop = jiffies + chip->timeout_a;
 	do {
-		if (ioread8(priv->iobase + TPM_ACCESS(l)) &
+		if (tpm_read8(chip, TPM_ACCESS(l)) &
 		    TPM_ACCESS_VALID)
 			return 0;
 		msleep(TPM_TIMEOUT);
@@ -141,9 +140,8 @@ static int wait_startup(struct tpm_chip *chip, int l)
 static int check_locality(struct tpm_chip *chip, int l)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 
-	if ((ioread8(priv->iobase + TPM_ACCESS(l)) &
+	if ((tpm_read8(chip, TPM_ACCESS(l)) &
 	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
 		return priv->locality = l;
@@ -154,27 +152,24 @@ static int check_locality(struct tpm_chip *chip, int l)
 static void release_locality(struct tpm_chip *chip, int l, int force)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
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
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	unsigned long stop, timeout;
 	long rc;
 
 	if (check_locality(chip, l) >= 0)
 		return l;
 
-	iowrite8(TPM_ACCESS_REQUEST_USE,
-		 priv->iobase + TPM_ACCESS(l));
+	tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
+
 
 	stop = jiffies + chip->timeout_a;
 
@@ -208,26 +203,21 @@ again:
 static u8 tpm_tis_status(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 
-	return ioread8(priv->iobase +
-		       TPM_STS(priv->locality));
+	return tpm_read8(chip, TPM_STS(priv->locality));
 }
 
 static void tpm_tis_ready(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 
 	/* this causes the current command to be aborted */
-	iowrite8(TPM_STS_COMMAND_READY,
-		 priv->iobase + TPM_STS(priv->locality));
+	tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_COMMAND_READY);
 }
 
 static int get_burstcount(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	unsigned long stop;
 	int burstcnt;
 
@@ -235,11 +225,8 @@ static int get_burstcount(struct tpm_chip *chip)
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
@@ -250,18 +237,16 @@ static int get_burstcount(struct tpm_chip *chip)
 static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	int size = 0, burstcnt;
 	while (size < count &&
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
@@ -325,7 +310,6 @@ MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
 static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	int rc, status, burstcnt;
 	size_t count = 0;
 
@@ -344,12 +328,10 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
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
@@ -361,8 +343,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	}
 
 	/* write last byte */
-	iowrite8(buf[count],
-		 priv->iobase + TPM_DATA_FIFO(priv->locality));
+	tpm_write8(chip, TPM_DATA_FIFO(priv->locality), buf[count]);
 	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 			  &priv->int_queue, false);
 	status = tpm_tis_status(chip);
@@ -382,15 +363,12 @@ out_err:
 static void disable_interrupts(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
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
@@ -413,9 +391,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 		return rc;
 
 	/* go and do it */
-	iowrite8(TPM_STS_GO,
-		 priv->iobase + TPM_STS(priv->locality));
-
+	tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_GO);
 	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 
@@ -476,11 +452,10 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 				    unsigned long *timeout_cap)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	int i;
 	u32 did_vid;
 
-	did_vid = ioread32(priv->iobase + TPM_DID_VID(0));
+	did_vid = tpm_read32(chip, TPM_DID_VID(0));
 
 	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
 		if (vendor_timeout_overrides[i].did_vid != did_vid)
@@ -501,7 +476,6 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 static int probe_itpm(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	int rc = 0;
 	u8 cmd_getticks[] = {
 		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
@@ -509,7 +483,7 @@ static int probe_itpm(struct tpm_chip *chip)
 	};
 	size_t len = sizeof(cmd_getticks);
 	bool rem_itpm = itpm;
-	u16 vendor = ioread16(priv->iobase + TPM_DID_VID(0));
+	u16 vendor = tpm_read16(chip, TPM_DID_VID(0));
 
 	/* probe only iTPMS */
 	if (vendor != TPM_VID_INTEL)
@@ -567,16 +541,75 @@ static const struct tpm_class_ops tpm_tis = {
 	.req_canceled = tpm_tis_req_canceled,
 };
 
+static void tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+			       u8 *result)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
+
+	while (len--)
+		*result++ = ioread8(priv->iobase + addr);
+}
+
+static void tpm_mem_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+				u8 *value)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
+
+	while (len--)
+		iowrite8(*value++, priv->iobase + addr);
+}
+
+static u16 tpm_mem_read16(struct tpm_chip *chip, u32 addr)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
+
+	return ioread16(priv->iobase + addr);
+}
+
+static void tpm_mem_write16(struct tpm_chip *chip, u32 addr, u16 value)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
+
+	iowrite16(value, priv->iobase + addr);
+}
+
+static u32 tpm_mem_read32(struct tpm_chip *chip, u32 addr)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
+
+	return ioread32(priv->iobase + addr);
+}
+
+static void tpm_mem_write32(struct tpm_chip *chip, u32 addr, u32 value)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
+
+	iowrite32(value, priv->iobase + addr);
+}
+
+static const struct tpm_tis_class_lowlevel tpm_mem = {
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
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	u32 interrupt;
 	int i;
 
-	interrupt = ioread32(priv->iobase +
-			     TPM_INT_STATUS(priv->locality));
+	interrupt = tpm_read32(chip, TPM_INT_STATUS(priv->locality));
 
 	if (interrupt == 0)
 		return IRQ_NONE;
@@ -594,10 +627,9 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
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
 
@@ -609,7 +641,6 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 				    int flags, int irq)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	u8 original_int_vec;
 
 	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
@@ -620,19 +651,16 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
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
 
@@ -648,8 +676,9 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
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
 
@@ -663,12 +692,10 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
 	u8 original_int_vec;
 	int i;
 
-	original_int_vec = ioread8(priv->iobase +
-				   TPM_INT_VECTOR(priv->locality));
+	original_int_vec = tpm_read8(chip, TPM_INT_VECTOR(priv->locality));
 
 	if (!original_int_vec) {
 		if (IS_ENABLED(CONFIG_X86))
@@ -688,13 +715,12 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
 static void tpm_tis_remove(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	struct tpm_tis_phy *phy = priv->phy_id;
-	void __iomem *reg = priv->iobase + TPM_INT_ENABLE(priv->locality);
+	u32 reg = TPM_INT_ENABLE(priv->locality);
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
 
-	iowrite32(~TPM_GLOBAL_INT_ENABLE & ioread32(reg), reg);
+	tpm_write32(chip, reg, ~TPM_GLOBAL_INT_ENABLE & tpm_read32(chip, reg));
 	release_locality(chip, priv->locality, 1);
 }
 
@@ -727,6 +753,8 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	if (IS_ERR(priv->iobase))
 		return PTR_ERR(priv->iobase);
 
+	priv->lowlevel = &tpm_mem;
+
 	/* Maximum timeouts */
 	chip->timeout_a = TIS_TIMEOUT_A_MAX;
 	chip->timeout_b = TIS_TIMEOUT_B_MAX;
@@ -742,13 +770,11 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
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
@@ -759,12 +785,12 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
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
@@ -780,9 +806,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 
 
 	/* Figure out the capabilities */
-	intfcaps =
-	    ioread32(priv->iobase +
-		     TPM_INTF_CAPS(priv->locality));
+	intfcaps = tpm_read32(chip, TPM_INTF_CAPS(priv->locality));
 	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
 		intfcaps);
 	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
@@ -865,18 +889,15 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 
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
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 20f50e5..667a64e 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -25,6 +25,17 @@
 
 #include "tpm.h"
 
+struct tpm_tis_class_lowlevel {
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
 struct tpm_tis_data {
 	u16 manufacturer_id;
 	int locality;
@@ -32,7 +43,61 @@ struct tpm_tis_data {
 	bool irq_tested;
 	wait_queue_head_t int_queue;
 	wait_queue_head_t read_queue;
+	const struct tpm_tis_class_lowlevel *lowlevel;
 	void *phy_id;
 };
 
+static inline void tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+				  u8 *result)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	priv->lowlevel->read_bytes(chip, addr, len, result);
+}
+
+static inline u8 tpm_read8(struct tpm_chip *chip, u32 addr)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	u8 result;
+
+	priv->lowlevel->read_bytes(chip, addr, 1, &result);
+	return result;
+}
+
+static inline u16 tpm_read16(struct tpm_chip *chip, u32 addr)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	return priv->lowlevel->read16(chip, addr);
+}
+
+static inline u32 tpm_read32(struct tpm_chip *chip, u32 addr)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	return priv->lowlevel->read32(chip, addr);
+}
+
+static inline void tpm_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+				   u8 *value)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	priv->lowlevel->write_bytes(chip, addr, len, value);
+}
+
+static inline void tpm_write8(struct tpm_chip *chip, u32 addr, u8 value)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	priv->lowlevel->write_bytes(chip, addr, 1, &value);
+}
+
+static inline void tpm_write32(struct tpm_chip *chip, u32 addr, u32 value)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	priv->lowlevel->write32(chip, addr, value);
+}
+
 #endif
-- 
2.5.0


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
