From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 05/12] tpm_tis: Extend low-level interface
	to support proper return codes
Date: Sat, 16 Apr 2016 08:35:35 +0200
Message-ID: <1460788542-2455-6-git-send-email-christophe-h.ricard@st.com>
References: <1460788542-2455-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460788542-2455-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

Though the ioread/iowrite calls cannot fail, other implementations of this
interface might want to return error codes if their communication fails.

This follows the usual pattern of negative values representing errors and
zero representing success. Positive values are not used (yet).

Errors are passed back to the caller if possible. If the interface of a
function does not allow that, it tries to do the most sensible thing it
can, but this might also mean ignoring the error in this instance.

Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c      | 212 ++++++++++++++++++++++++++++++----------
 drivers/char/tpm/tpm_tis_core.h |  44 ++++-----
 2 files changed, 181 insertions(+), 75 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 6df7ddc..87cbad5 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -132,9 +132,15 @@ static inline int is_itpm(struct acpi_device *dev)
 static int wait_startup(struct tpm_chip *chip, int l)
 {
 	unsigned long stop = jiffies + chip->timeout_a;
+	int rc;
+	u8 access;
+
 	do {
-		if (tpm_read8(chip, TPM_ACCESS(l)) &
-		    TPM_ACCESS_VALID)
+		rc = tpm_read8(chip, TPM_ACCESS(l), &access);
+		if (rc < 0)
+			return rc;
+
+		if (access & TPM_ACCESS_VALID)
 			return 0;
 		msleep(TPM_TIMEOUT);
 	} while (time_before(jiffies, stop));
@@ -144,9 +150,14 @@ static int wait_startup(struct tpm_chip *chip, int l)
 static int check_locality(struct tpm_chip *chip, int l)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+	u8 access;
 
-	if ((tpm_read8(chip, TPM_ACCESS(l)) &
-	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
+	rc = tpm_read8(chip, TPM_ACCESS(l), &access);
+	if (rc < 0)
+		return rc;
+
+	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
 		return priv->locality = l;
 
@@ -155,7 +166,14 @@ static int check_locality(struct tpm_chip *chip, int l)
 
 static void release_locality(struct tpm_chip *chip, int l, int force)
 {
-	if (force || (tpm_read8(chip, TPM_ACCESS(l)) &
+	int rc;
+	u8 access;
+
+	rc = tpm_read8(chip, TPM_ACCESS(l), &access);
+	if (rc < 0)
+		return;
+
+	if (force || (access &
 		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
 	    (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
 		tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);
@@ -171,7 +189,9 @@ static int request_locality(struct tpm_chip *chip, int l)
 	if (check_locality(chip, l) >= 0)
 		return l;
 
-	tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
+	rc = tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
+	if (rc < 0)
+		return rc;
 
 	stop = jiffies + chip->timeout_a;
 
@@ -205,8 +225,14 @@ again:
 static u8 tpm_tis_status(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+	u8 status;
+
+	rc = tpm_read8(chip, TPM_STS(priv->locality), &status);
+	if (rc < 0)
+		return 0;
 
-	return tpm_read8(chip, TPM_STS(priv->locality));
+	return status;
 }
 
 static void tpm_tis_ready(struct tpm_chip *chip)
@@ -221,14 +247,23 @@ static int get_burstcount(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	unsigned long stop;
-	int burstcnt;
+	int burstcnt, rc;
+	u8 value;
 
 	/* wait for burstcount */
 	/* which timeout value, spec has 2 answers (c & d) */
 	stop = jiffies + chip->timeout_d;
 	do {
-		burstcnt = tpm_read8(chip, TPM_STS(priv->locality) + 1);
-		burstcnt += tpm_read8(chip, TPM_STS(priv->locality) + 2) << 8;
+		rc = tpm_read8(chip, TPM_STS(priv->locality) + 1, &value);
+		if (rc < 0)
+			return rc;
+
+		burstcnt = value;
+		rc = tpm_read8(chip, TPM_STS(priv->locality) + 2, &value);
+		if (rc < 0)
+			return rc;
+
+		burstcnt += value << 8;
 		if (burstcnt)
 			return burstcnt;
 		msleep(TPM_TIMEOUT);
@@ -239,15 +274,19 @@ static int get_burstcount(struct tpm_chip *chip)
 static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int size = 0, burstcnt;
+	int size = 0, burstcnt, rc;
+
 	while (size < count &&
 	       wait_for_tpm_stat(chip,
 				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 				 chip->timeout_c,
 				 &priv->read_queue, true) == 0) {
 		burstcnt = min_t(int, get_burstcount(chip), count - size);
-		tpm_read_bytes(chip, TPM_DATA_FIFO(priv->locality),
-			       burstcnt, buf + size);
+		rc = tpm_read_bytes(chip, TPM_DATA_FIFO(priv->locality),
+				    burstcnt, buf + size);
+		if (rc < 0)
+			return rc;
+
 		size += burstcnt;
 	}
 	return size;
@@ -331,8 +370,11 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 
 	while (count < len - 1) {
 		burstcnt = min_t(int, get_burstcount(chip), len - count - 1);
-		tpm_write_bytes(chip, TPM_DATA_FIFO(priv->locality),
-				burstcnt, buf + count);
+		rc = tpm_write_bytes(chip, TPM_DATA_FIFO(priv->locality),
+				     burstcnt, buf + count);
+		if (rc < 0)
+			goto out_err;
+
 		count += burstcnt;
 
 		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
@@ -345,7 +387,9 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	}
 
 	/* write last byte */
-	tpm_write8(chip, TPM_DATA_FIFO(priv->locality), buf[count]);
+	rc = tpm_write8(chip, TPM_DATA_FIFO(priv->locality), buf[count]);
+	if (rc < 0)
+		goto out_err;
 
 	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 			  &priv->int_queue, false);
@@ -367,8 +411,12 @@ static void disable_interrupts(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	u32 intmask;
+	int rc;
+
+	rc = tpm_read32(chip, TPM_INT_ENABLE(priv->locality), &intmask);
+	if (rc < 0)
+		intmask = 0;
 
-	intmask = tpm_read32(chip, TPM_INT_ENABLE(priv->locality));
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
 	tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
 
@@ -394,7 +442,9 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 		return rc;
 
 	/* go and do it */
-	tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_GO);
+	rc = tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_GO);
+	if (rc < 0)
+		return rc;
 
 	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
@@ -455,10 +505,12 @@ static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
 static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 				    unsigned long *timeout_cap)
 {
-	int i;
+	int i, rc;
 	u32 did_vid;
 
-	did_vid = tpm_read32(chip, TPM_DID_VID(0));
+	rc = tpm_read32(chip, TPM_DID_VID(0), &did_vid);
+	if (rc < 0)
+		return rc;
 
 	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
 		if (vendor_timeout_overrides[i].did_vid != did_vid)
@@ -486,7 +538,11 @@ static int probe_itpm(struct tpm_chip *chip)
 	};
 	size_t len = sizeof(cmd_getticks);
 	bool rem_itpm = itpm;
-	u16 vendor = tpm_read16(chip, TPM_DID_VID(0));
+	u16 vendor;
+
+	rc = tpm_read16(chip, TPM_DID_VID(0), &vendor);
+	if (rc < 0)
+		return rc;
 
 	/* probe only iTPMS */
 	if (vendor != TPM_VID_INTEL)
@@ -544,48 +600,53 @@ static const struct tpm_class_ops tpm_tis = {
 	.req_canceled = tpm_tis_req_canceled,
 };
 
-static void tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
-			       u8 *result)
+static int tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+			      u8 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 
 	while (len--)
 		*result++ = ioread8(phy->iobase + addr);
+	return 0;
 }
 
-static void tpm_mem_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
-				u8 *value)
+static int tpm_mem_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+			       u8 *value)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 
 	while (len--)
 		iowrite8(*value++, phy->iobase + addr);
+	return 0;
 }
 
-static u16 tpm_mem_read16(struct tpm_chip *chip, u32 addr)
+static int tpm_mem_read16(struct tpm_chip *chip, u32 addr, u16 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 
-	return ioread16(phy->iobase + addr);
+	*result = ioread16(phy->iobase + addr);
+	return 0;
 }
 
-static u32 tpm_mem_read32(struct tpm_chip *chip, u32 addr)
+static int tpm_mem_read32(struct tpm_chip *chip, u32 addr, u32 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 
-	return ioread32(phy->iobase + addr);
+	*result = ioread32(phy->iobase + addr);
+	return 0;
 }
 
-static void tpm_mem_write32(struct tpm_chip *chip, u32 addr, u32 value)
+static int tpm_mem_write32(struct tpm_chip *chip, u32 addr, u32 value)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 
 	iowrite32(value, phy->iobase + addr);
+	return 0;
 }
 
 static const struct tpm_tis_phy_ops tpm_mem = {
@@ -601,9 +662,11 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	struct tpm_chip *chip = dev_id;
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	u32 interrupt;
-	int i;
+	int i, rc;
 
-	interrupt = tpm_read32(chip, TPM_INT_STATUS(priv->locality));
+	rc = tpm_read32(chip, TPM_INT_STATUS(priv->locality), &interrupt);
+	if (rc < 0)
+		return IRQ_NONE;
 
 	if (interrupt == 0)
 		return IRQ_NONE;
@@ -621,8 +684,11 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 		wake_up_interruptible(&priv->int_queue);
 
 	/* Clear interrupts handled with TPM_EOI */
-	tpm_write32(chip, TPM_INT_STATUS(priv->locality), interrupt);
-	tpm_read32(chip, TPM_INT_STATUS(priv->locality));
+	rc = tpm_write32(chip, TPM_INT_STATUS(priv->locality), interrupt);
+	if (rc < 0)
+		return IRQ_NONE;
+
+	tpm_read32(chip, TPM_INT_STATUS(priv->locality), &interrupt);
 	return IRQ_HANDLED;
 }
 
@@ -635,6 +701,8 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	u8 original_int_vec;
+	int rc;
+	u32 int_status;
 
 	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
 			     dev_name(&chip->dev), chip) != 0) {
@@ -644,16 +712,28 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	}
 	priv->irq = irq;
 
-	original_int_vec = tpm_read8(chip, TPM_INT_VECTOR(priv->locality));
-	tpm_write8(chip, TPM_INT_VECTOR(priv->locality), irq);
+	rc = tpm_read8(chip, TPM_INT_VECTOR(priv->locality), &original_int_vec);
+	if (rc < 0)
+		return rc;
+
+	rc = tpm_write8(chip, TPM_INT_VECTOR(priv->locality), irq);
+	if (rc < 0)
+		return rc;
+
+	rc = tpm_read32(chip, TPM_INT_STATUS(priv->locality), &int_status);
+	if (rc < 0)
+		return rc;
 
 	/* Clear all existing */
-	tpm_write32(chip, TPM_INT_STATUS(priv->locality),
-		    tpm_read32(chip, TPM_INT_STATUS(priv->locality)));
+	rc = tpm_write32(chip, TPM_INT_STATUS(priv->locality), int_status);
+	if (rc < 0)
+		return rc;
 
 	/* Turn on */
-	tpm_write32(chip, TPM_INT_ENABLE(priv->locality),
-		    intmask | TPM_GLOBAL_INT_ENABLE);
+	rc = tpm_write32(chip, TPM_INT_ENABLE(priv->locality),
+			 intmask | TPM_GLOBAL_INT_ENABLE);
+	if (rc < 0)
+		return rc;
 
 	priv->irq_tested = false;
 
@@ -669,8 +749,10 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	 * will call disable_irq which undoes all of the above.
 	 */
 	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
-		tpm_write8(chip, TPM_INT_VECTOR(priv->locality),
-			   original_int_vec);
+		rc = tpm_write8(chip, TPM_INT_VECTOR(priv->locality),
+				original_int_vec);
+		if (rc < 0)
+			return rc;
 
 		return 1;
 	}
@@ -686,9 +768,11 @@ static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	u8 original_int_vec;
-	int i;
+	int i, rc;
 
-	original_int_vec = tpm_read8(chip, TPM_INT_VECTOR(priv->locality));
+	rc = tpm_read8(chip, TPM_INT_VECTOR(priv->locality), &original_int_vec);
+	if (rc < 0)
+		return;
 
 	if (!original_int_vec) {
 		if (IS_ENABLED(CONFIG_X86))
@@ -709,8 +793,14 @@ static void tpm_tis_remove(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	u32 reg = TPM_INT_ENABLE(priv->locality);
+	u32 interrupt;
+	int rc;
 
-	tpm_write32(chip, reg, ~TPM_GLOBAL_INT_ENABLE & tpm_read32(chip, reg));
+	rc = tpm_read32(chip, reg, &interrupt);
+	if (rc < 0)
+		interrupt = 0;
+
+	tpm_write32(chip, reg, ~TPM_GLOBAL_INT_ENABLE & interrupt);
 	release_locality(chip, priv->locality, 1);
 }
 
@@ -718,6 +808,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 			acpi_handle acpi_dev_handle)
 {
 	u32 vendor, intfcaps, intmask;
+	u8 rid;
 	int rc, probe;
 	struct tpm_chip *chip;
 	struct tpm_tis_lpc_phy *phy;
@@ -754,7 +845,10 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	}
 
 	/* Take control of the TPM's interrupt hardware and shut it off */
-	intmask = tpm_read32(chip, TPM_INT_ENABLE(phy->priv.locality));
+	rc = tpm_read32(chip, TPM_INT_ENABLE(phy->priv.locality), &intmask);
+	if (rc < 0)
+		goto out_err;
+
 	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
 		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
@@ -769,12 +863,19 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	if (rc)
 		goto out_err;
 
-	vendor = tpm_read32(chip, TPM_DID_VID(0));
+	rc = tpm_read32(chip, TPM_DID_VID(0), &vendor);
+	if (rc < 0)
+		goto out_err;
+
 	phy->priv.manufacturer_id = vendor;
 
+	rc = tpm_read8(chip, TPM_RID(0), &rid);
+	if (rc < 0)
+		goto out_err;
+
 	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
-		 vendor >> 16, tpm_read8(chip, TPM_RID(0)));
+		 vendor >> 16, rid);
 
 	if (!itpm) {
 		probe = probe_itpm(chip);
@@ -788,9 +889,11 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	if (itpm)
 		dev_info(dev, "Intel iTPM workaround enabled\n");
 
-
 	/* Figure out the capabilities */
-	intfcaps = tpm_read32(chip, TPM_INTF_CAPS(phy->priv.locality));
+	rc = tpm_read32(chip, TPM_INTF_CAPS(phy->priv.locality), &intfcaps);
+	if (rc < 0)
+		goto out_err;
+
 	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
 		intfcaps);
 	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
@@ -870,12 +973,17 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	u32 intmask;
+	int rc;
 
 	/* reenable interrupts that device may have lost or
 	   BIOS/firmware may have disabled */
-	tpm_write8(chip, TPM_INT_VECTOR(priv->locality), priv->irq);
+	rc = tpm_write8(chip, TPM_INT_VECTOR(priv->locality), priv->irq);
+	if (rc < 0)
+		return;
 
-	intmask = tpm_read32(chip, TPM_INT_ENABLE(priv->locality));
+	rc = tpm_read32(chip, TPM_INT_ENABLE(priv->locality), &intmask);
+	if (rc < 0)
+		return;
 
 	intmask |= TPM_INTF_CMD_READY_INT
 	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 3e066eb..9dd6b41 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -26,13 +26,13 @@
 #include "tpm.h"
 
 struct tpm_tis_phy_ops {
-	void (*read_bytes)(struct tpm_chip *chip, u32 addr, u16 len,
-			   u8 *result);
-	void (*write_bytes)(struct tpm_chip *chip, u32 addr, u16 len,
-			    u8 *value);
-	u16 (*read16)(struct tpm_chip *chip, u32 addr);
-	u32 (*read32)(struct tpm_chip *chip, u32 addr);
-	void (*write32)(struct tpm_chip *chip, u32 addr, u32 src);
+	int (*read_bytes)(struct tpm_chip *chip, u32 addr, u16 len,
+			  u8 *result);
+	int (*write_bytes)(struct tpm_chip *chip, u32 addr, u16 len,
+			   u8 *value);
+	int (*read16)(struct tpm_chip *chip, u32 addr, u16 *result);
+	int (*read32)(struct tpm_chip *chip, u32 addr, u32 *result);
+	int (*write32)(struct tpm_chip *chip, u32 addr, u32 src);
 };
 
 struct tpm_tis_data {
@@ -45,57 +45,55 @@ struct tpm_tis_data {
 	const struct tpm_tis_phy_ops *phy_ops;
 };
 
-static inline void tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+static inline int tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
 				  u8 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	priv->phy_ops->read_bytes(chip, addr, len, result);
+	return priv->phy_ops->read_bytes(chip, addr, len, result);
 }
 
-static inline u8 tpm_read8(struct tpm_chip *chip, u32 addr)
+static inline int tpm_read8(struct tpm_chip *chip, u32 addr, u8 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	u8 result;
 
-	priv->phy_ops->read_bytes(chip, addr, 1, &result);
-	return result;
+	return priv->phy_ops->read_bytes(chip, addr, 1, result);
 }
 
-static inline u16 tpm_read16(struct tpm_chip *chip, u32 addr)
+static inline int tpm_read16(struct tpm_chip *chip, u32 addr, u16 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	return priv->phy_ops->read16(chip, addr);
+	return priv->phy_ops->read16(chip, addr, result);
 }
 
-static inline u32 tpm_read32(struct tpm_chip *chip, u32 addr)
+static inline int tpm_read32(struct tpm_chip *chip, u32 addr, u32 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	return priv->phy_ops->read32(chip, addr);
+	return priv->phy_ops->read32(chip, addr, result);
 }
 
-static inline void tpm_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
+static inline int tpm_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
 				   u8 *value)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	priv->phy_ops->write_bytes(chip, addr, len, value);
+	return priv->phy_ops->write_bytes(chip, addr, len, value);
 }
 
-static inline void tpm_write8(struct tpm_chip *chip, u32 addr, u8 value)
+static inline int tpm_write8(struct tpm_chip *chip, u32 addr, u8 value)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	priv->phy_ops->write_bytes(chip, addr, 1, &value);
+	return priv->phy_ops->write_bytes(chip, addr, 1, &value);
 }
 
-static inline void tpm_write32(struct tpm_chip *chip, u32 addr, u32 value)
+static inline int tpm_write32(struct tpm_chip *chip, u32 addr, u32 value)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	priv->phy_ops->write32(chip, addr, value);
+	return priv->phy_ops->write32(chip, addr, value);
 }
 
 #endif
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
