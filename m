From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 11/12] tpm/tpm_tis: Split tpm_tis driver
	into a core and TCG TIS compliant phy
Date: Sat, 16 Apr 2016 08:35:41 +0200
Message-ID: <1460788542-2455-12-git-send-email-christophe-h.ricard@st.com>
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
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

To avoid code duplication between the old tpm_tis and the new and future
native tcg tis driver(ie: spi, i2c...), the tpm_tis driver was reworked,
so that all common logic is extracted and can be reused from all drivers.

The core methods can also be used from other TIS like drivers.

Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/Kconfig        |   7 +
 drivers/char/tpm/Makefile       |   1 +
 drivers/char/tpm/tpm_tis.c      | 843 +---------------------------------------
 drivers/char/tpm/tpm_tis_core.c | 809 ++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_tis_core.h |  66 ++++
 5 files changed, 902 insertions(+), 824 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_tis_core.c

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 3b84a8b..b217308 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -24,9 +24,16 @@ menuconfig TCG_TPM
 
 if TCG_TPM
 
+config TCG_TIS_CORE
+	tristate
+	---help---
+	TCG TIS TPM core driver. It implements the TPM TCG TIS logic and hooks
+	into the TPM kernel APIs. Physical layers will register against it.
+
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface / TPM 2.0 FIFO Interface"
 	depends on X86
+	select TCG_TIS_CORE
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG TIS 1.2 TPM specification (TPM1.2) or the TCG PTP FIFO
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 56e8f1f..80be5b2 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -12,6 +12,7 @@ ifdef CONFIG_TCG_IBMVTPM
 	tpm-y += tpm_eventlog.o tpm_of.o
 endif
 endif
+obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_TIS_I2C_ATMEL) += tpm_i2c_atmel.o
 obj-$(CONFIG_TCG_TIS_I2C_INFINEON) += tpm_i2c_infineon.o
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 236f644..1243874 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -31,40 +31,6 @@
 #include "tpm.h"
 #include "tpm_tis_core.h"
 
-enum tis_access {
-	TPM_ACCESS_VALID = 0x80,
-	TPM_ACCESS_ACTIVE_LOCALITY = 0x20,
-	TPM_ACCESS_REQUEST_PENDING = 0x04,
-	TPM_ACCESS_REQUEST_USE = 0x02,
-};
-
-enum tis_status {
-	TPM_STS_VALID = 0x80,
-	TPM_STS_COMMAND_READY = 0x40,
-	TPM_STS_GO = 0x20,
-	TPM_STS_DATA_AVAIL = 0x10,
-	TPM_STS_DATA_EXPECT = 0x08,
-};
-
-enum tis_int_flags {
-	TPM_GLOBAL_INT_ENABLE = 0x80000000,
-	TPM_INTF_BURST_COUNT_STATIC = 0x100,
-	TPM_INTF_CMD_READY_INT = 0x080,
-	TPM_INTF_INT_EDGE_FALLING = 0x040,
-	TPM_INTF_INT_EDGE_RISING = 0x020,
-	TPM_INTF_INT_LEVEL_LOW = 0x010,
-	TPM_INTF_INT_LEVEL_HIGH = 0x008,
-	TPM_INTF_LOCALITY_CHANGE_INT = 0x004,
-	TPM_INTF_STS_VALID_INT = 0x002,
-	TPM_INTF_DATA_AVAIL_INT = 0x001,
-};
-
-enum tis_defaults {
-	TIS_MEM_LEN = 0x5000,
-	TIS_SHORT_TIMEOUT = 750,	/* ms */
-	TIS_LONG_TIMEOUT = 2000,	/* 2 sec */
-};
-
 struct tpm_info {
 	struct resource res;
 	/* irq > 0 means: use irq $irq;
@@ -74,31 +40,25 @@ struct tpm_info {
 	int irq;
 };
 
-/* Some timeout values are needed before it is known whether the chip is
- * TPM 1.0 or TPM 2.0.
- */
-#define TIS_TIMEOUT_A_MAX	max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_A)
-#define TIS_TIMEOUT_B_MAX	max(TIS_LONG_TIMEOUT, TPM2_TIMEOUT_B)
-#define TIS_TIMEOUT_C_MAX	max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_C)
-#define TIS_TIMEOUT_D_MAX	max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_D)
-
-#define	TPM_ACCESS(l)			(0x0000 | ((l) << 12))
-#define	TPM_INT_ENABLE(l)		(0x0008 | ((l) << 12))
-#define	TPM_INT_VECTOR(l)		(0x000C | ((l) << 12))
-#define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
-#define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
-#define	TPM_STS(l)			(0x0018 | ((l) << 12))
-#define	TPM_STS3(l)			(0x001b | ((l) << 12))
-#define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
-
-#define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
-#define	TPM_RID(l)			(0x0F04 | ((l) << 12))
-
 struct tpm_tis_lpc_phy {
 	struct tpm_tis_data priv;
 	void __iomem *iobase;
 };
 
+static bool interrupts = true;
+module_param(interrupts, bool, 0444);
+MODULE_PARM_DESC(interrupts, "Enable interrupts");
+
+static bool itpm;
+module_param(itpm, bool, 0444);
+MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
+
+static bool force;
+#ifdef CONFIG_X86
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
+#endif
+
 #define to_tpm_tis_lpc_phy(data) container_of(data, struct tpm_tis_lpc_phy,\
 					      priv)
 
@@ -125,405 +85,6 @@ static inline int is_itpm(struct acpi_device *dev)
 }
 #endif
 
-/* Before we attempt to access the TPM we must see that the valid bit is set.
- * The specification says that this bit is 0 at reset and remains 0 until the
- * 'TPM has gone through its self test and initialization and has established
- * correct values in the other bits.' */
-static int wait_startup(struct tpm_chip *chip, int l)
-{
-	unsigned long stop = jiffies + chip->timeout_a;
-	int rc;
-	u8 access;
-
-	do {
-		rc = tpm_read8(chip, TPM_ACCESS(l), &access);
-		if (rc < 0)
-			return rc;
-
-		if (access & TPM_ACCESS_VALID)
-			return 0;
-		msleep(TPM_TIMEOUT);
-	} while (time_before(jiffies, stop));
-	return -1;
-}
-
-static int check_locality(struct tpm_chip *chip, int l)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int rc;
-	u8 access;
-
-	rc = tpm_read8(chip, TPM_ACCESS(l), &access);
-	if (rc < 0)
-		return rc;
-
-	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
-	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
-		return priv->locality = l;
-
-	return -1;
-}
-
-static void release_locality(struct tpm_chip *chip, int l, int force)
-{
-	int rc;
-	u8 access;
-
-	rc = tpm_read8(chip, TPM_ACCESS(l), &access);
-	if (rc < 0)
-		return;
-
-	if (force || (access &
-		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
-	    (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
-		tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);
-
-}
-
-static int request_locality(struct tpm_chip *chip, int l)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	unsigned long stop, timeout;
-	long rc;
-
-	if (check_locality(chip, l) >= 0)
-		return l;
-
-	rc = tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
-	if (rc < 0)
-		return rc;
-
-	stop = jiffies + chip->timeout_a;
-
-	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
-again:
-		timeout = stop - jiffies;
-		if ((long)timeout <= 0)
-			return -1;
-		rc = wait_event_interruptible_timeout(priv->int_queue,
-						      (check_locality
-						       (chip, l) >= 0),
-						      timeout);
-		if (rc > 0)
-			return l;
-		if (rc == -ERESTARTSYS && freezing(current)) {
-			clear_thread_flag(TIF_SIGPENDING);
-			goto again;
-		}
-	} else {
-		/* wait for burstcount */
-		do {
-			if (check_locality(chip, l) >= 0)
-				return l;
-			msleep(TPM_TIMEOUT);
-		}
-		while (time_before(jiffies, stop));
-	}
-	return -1;
-}
-
-static u8 tpm_tis_status(struct tpm_chip *chip)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int rc;
-	u8 status;
-
-	rc = tpm_read8(chip, TPM_STS(priv->locality), &status);
-	if (rc < 0)
-		return 0;
-
-	return status;
-}
-
-static void tpm_tis_ready(struct tpm_chip *chip)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-
-	/* this causes the current command to be aborted */
-	tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_COMMAND_READY);
-}
-
-static int get_burstcount(struct tpm_chip *chip)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	unsigned long stop;
-	int burstcnt, rc;
-	u8 value;
-
-	/* wait for burstcount */
-	/* which timeout value, spec has 2 answers (c & d) */
-	stop = jiffies + chip->timeout_d;
-	do {
-		rc = tpm_read8(chip, TPM_STS(priv->locality) + 1, &value);
-		if (rc < 0)
-			return rc;
-
-		burstcnt = value;
-		rc = tpm_read8(chip, TPM_STS(priv->locality) + 2, &value);
-		if (rc < 0)
-			return rc;
-
-		burstcnt += value << 8;
-		if (burstcnt)
-			return burstcnt;
-		msleep(TPM_TIMEOUT);
-	} while (time_before(jiffies, stop));
-	return -EBUSY;
-}
-
-static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int size = 0, burstcnt, rc;
-
-	while (size < count &&
-	       wait_for_tpm_stat(chip,
-				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-				 chip->timeout_c,
-				 &priv->read_queue, true) == 0) {
-		burstcnt = min_t(int, get_burstcount(chip), count - size);
-		rc = tpm_read_bytes(chip, TPM_DATA_FIFO(priv->locality),
-				    burstcnt, buf + size);
-		if (rc < 0)
-			return rc;
-
-		size += burstcnt;
-	}
-	return size;
-}
-
-static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int size = 0;
-	int expected, status;
-
-	if (count < TPM_HEADER_SIZE) {
-		size = -EIO;
-		goto out;
-	}
-
-	/* read first 10 bytes, including tag, paramsize, and result */
-	if ((size =
-	     recv_data(chip, buf, TPM_HEADER_SIZE)) < TPM_HEADER_SIZE) {
-		dev_err(&chip->dev, "Unable to read header\n");
-		goto out;
-	}
-
-	expected = be32_to_cpu(*(__be32 *) (buf + 2));
-	if (expected > count) {
-		size = -EIO;
-		goto out;
-	}
-
-	if ((size +=
-	     recv_data(chip, &buf[TPM_HEADER_SIZE],
-		       expected - TPM_HEADER_SIZE)) < expected) {
-		dev_err(&chip->dev, "Unable to read remainder of result\n");
-		size = -ETIME;
-		goto out;
-	}
-
-	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
-			  &priv->int_queue, false);
-	status = tpm_tis_status(chip);
-	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
-		dev_err(&chip->dev, "Error left over data\n");
-		size = -EIO;
-		goto out;
-	}
-
-out:
-	tpm_tis_ready(chip);
-	release_locality(chip, priv->locality, 0);
-	return size;
-}
-
-static bool itpm;
-module_param(itpm, bool, 0444);
-MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
-
-/*
- * If interrupts are used (signaled by an irq set in the vendor structure)
- * tpm.c can skip polling for the data to be available as the interrupt is
- * waited for here
- */
-static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int rc, status, burstcnt;
-	size_t count = 0;
-
-	if (request_locality(chip, 0) < 0)
-		return -EBUSY;
-
-	status = tpm_tis_status(chip);
-	if ((status & TPM_STS_COMMAND_READY) == 0) {
-		tpm_tis_ready(chip);
-		if (wait_for_tpm_stat
-		    (chip, TPM_STS_COMMAND_READY, chip->timeout_b,
-		     &priv->int_queue, false) < 0) {
-			rc = -ETIME;
-			goto out_err;
-		}
-	}
-
-	while (count < len - 1) {
-		burstcnt = min_t(int, get_burstcount(chip), len - count - 1);
-		rc = tpm_write_bytes(chip, TPM_DATA_FIFO(priv->locality),
-				     burstcnt, buf + count);
-		if (rc < 0)
-			goto out_err;
-
-		count += burstcnt;
-
-		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
-				  &priv->int_queue, false);
-		status = tpm_tis_status(chip);
-		if ((status & priv->data_expect_mask) !=
-			      priv->data_expect_val) {
-			rc = -EIO;
-			goto out_err;
-		}
-	}
-
-	/* write last byte */
-	rc = tpm_write8(chip, TPM_DATA_FIFO(priv->locality), buf[count]);
-	if (rc < 0)
-		goto out_err;
-
-	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
-			  &priv->int_queue, false);
-	status = tpm_tis_status(chip);
-	if ((status & priv->data_expect_mask) == priv->data_expect_val) {
-		rc = -EIO;
-		goto out_err;
-	}
-
-	return 0;
-
-out_err:
-	tpm_tis_ready(chip);
-	release_locality(chip, priv->locality, 0);
-	return rc;
-}
-
-static void disable_interrupts(struct tpm_chip *chip)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	u32 intmask;
-	int rc;
-
-	rc = tpm_read32(chip, TPM_INT_ENABLE(priv->locality), &intmask);
-	if (rc < 0)
-		intmask = 0;
-
-	intmask &= ~TPM_GLOBAL_INT_ENABLE;
-	tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
-
-	devm_free_irq(&chip->dev, priv->irq, chip);
-	priv->irq = 0;
-	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
-}
-
-/*
- * If interrupts are used (signaled by an irq set in the vendor structure)
- * tpm.c can skip polling for the data to be available as the interrupt is
- * waited for here
- */
-static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int rc;
-	u32 ordinal;
-	unsigned long dur;
-
-	rc = tpm_tis_send_data(chip, buf, len);
-	if (rc < 0)
-		return rc;
-
-	/* go and do it */
-	rc = tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_GO);
-	if (rc < 0)
-		return rc;
-
-	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
-		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
-
-		if (chip->flags & TPM_CHIP_FLAG_TPM2)
-			dur = tpm2_calc_ordinal_duration(chip, ordinal);
-		else
-			dur = tpm_calc_ordinal_duration(chip, ordinal);
-
-		if (wait_for_tpm_stat
-		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
-		     &priv->read_queue, false) < 0) {
-			rc = -ETIME;
-			goto out_err;
-		}
-	}
-	return len;
-out_err:
-	tpm_tis_ready(chip);
-	release_locality(chip, priv->locality, 0);
-	return rc;
-}
-
-static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int rc, irq;
-
-	if (!(chip->flags & TPM_CHIP_FLAG_IRQ) || priv->irq_tested)
-		return tpm_tis_send_main(chip, buf, len);
-
-	/* Verify receipt of the expected IRQ */
-	irq = priv->irq;
-	priv->irq = 0;
-	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
-	rc = tpm_tis_send_main(chip, buf, len);
-	priv->irq = irq;
-	chip->flags |= TPM_CHIP_FLAG_IRQ;
-	if (!priv->irq_tested)
-		msleep(1);
-	if (!priv->irq_tested)
-		disable_interrupts(chip);
-	priv->irq_tested = true;
-	return rc;
-}
-
-struct tis_vendor_timeout_override {
-	u32 did_vid;
-	unsigned long timeout_us[4];
-};
-
-static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
-	/* Atmel 3204 */
-	{ 0x32041114, { (TIS_SHORT_TIMEOUT*1000), (TIS_LONG_TIMEOUT*1000),
-			(TIS_SHORT_TIMEOUT*1000), (TIS_SHORT_TIMEOUT*1000) } },
-};
-
-static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
-				    unsigned long *timeout_cap)
-{
-	int i, rc;
-	u32 did_vid;
-
-	rc = tpm_read32(chip, TPM_DID_VID(0), &did_vid);
-	if (rc < 0)
-		return rc;
-
-	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
-		if (vendor_timeout_overrides[i].did_vid != did_vid)
-			continue;
-		memcpy(timeout_cap, vendor_timeout_overrides[i].timeout_us,
-		       sizeof(vendor_timeout_overrides[i].timeout_us));
-		return true;
-	}
-
-	return false;
-}
-
 /*
  * Early probing for iTPM with STS_DATA_EXPECT flaw.
  * Try sending command without itpm flag set and if that
@@ -582,32 +143,6 @@ out:
 	return rc;
 }
 
-static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-
-	switch (priv->manufacturer_id) {
-	case TPM_VID_WINBOND:
-		return ((status == TPM_STS_VALID) ||
-			(status == (TPM_STS_VALID | TPM_STS_COMMAND_READY)));
-	case TPM_VID_STM:
-		return (status == (TPM_STS_VALID | TPM_STS_COMMAND_READY));
-	default:
-		return (status == TPM_STS_COMMAND_READY);
-	}
-}
-
-static const struct tpm_class_ops tpm_tis = {
-	.status = tpm_tis_status,
-	.recv = tpm_tis_recv,
-	.send = tpm_tis_send,
-	.cancel = tpm_tis_ready,
-	.update_timeouts = tpm_tis_update_timeouts,
-	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-	.req_canceled = tpm_tis_req_canceled,
-};
-
 static int tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
 			      u8 *result)
 {
@@ -657,134 +192,6 @@ static int tpm_mem_write32(struct tpm_chip *chip, u32 addr, u32 value)
 	return 0;
 }
 
-static irqreturn_t tis_int_handler(int dummy, void *dev_id)
-{
-	struct tpm_chip *chip = dev_id;
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	u32 interrupt;
-	int i, rc;
-
-	rc = tpm_read32(chip, TPM_INT_STATUS(priv->locality), &interrupt);
-	if (rc < 0)
-		return IRQ_NONE;
-
-	if (interrupt == 0)
-		return IRQ_NONE;
-
-	priv->irq_tested = true;
-	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
-		wake_up_interruptible(&priv->read_queue);
-	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
-		for (i = 0; i < 5; i++)
-			if (check_locality(chip, i) >= 0)
-				break;
-	if (interrupt &
-	    (TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_STS_VALID_INT |
-	     TPM_INTF_CMD_READY_INT))
-		wake_up_interruptible(&priv->int_queue);
-
-	/* Clear interrupts handled with TPM_EOI */
-	rc = tpm_write32(chip, TPM_INT_STATUS(priv->locality), interrupt);
-	if (rc < 0)
-		return IRQ_NONE;
-
-	tpm_read32(chip, TPM_INT_STATUS(priv->locality), &interrupt);
-	return IRQ_HANDLED;
-}
-
-/* Register the IRQ and issue a command that will cause an interrupt. If an
- * irq is seen then leave the chip setup for IRQ operation, otherwise reverse
- * everything and leave in polling mode. Returns 0 on success.
- */
-static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
-				    int flags, int irq)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	u8 original_int_vec;
-	int rc;
-	u32 int_status;
-
-	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
-			     dev_name(&chip->dev), chip) != 0) {
-		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
-			 irq);
-		return -1;
-	}
-	priv->irq = irq;
-
-	rc = tpm_read8(chip, TPM_INT_VECTOR(priv->locality), &original_int_vec);
-	if (rc < 0)
-		return rc;
-
-	rc = tpm_write8(chip, TPM_INT_VECTOR(priv->locality), irq);
-	if (rc < 0)
-		return rc;
-
-	rc = tpm_read32(chip, TPM_INT_STATUS(priv->locality), &int_status);
-	if (rc < 0)
-		return rc;
-
-	/* Clear all existing */
-	rc = tpm_write32(chip, TPM_INT_STATUS(priv->locality), int_status);
-	if (rc < 0)
-		return rc;
-
-	/* Turn on */
-	rc = tpm_write32(chip, TPM_INT_ENABLE(priv->locality),
-			 intmask | TPM_GLOBAL_INT_ENABLE);
-	if (rc < 0)
-		return rc;
-
-	priv->irq_tested = false;
-
-	/* Generate an interrupt by having the core call through to
-	 * tpm_tis_send
-	 */
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		tpm2_gen_interrupt(chip);
-	else
-		tpm_gen_interrupt(chip);
-
-	/* tpm_tis_send will either confirm the interrupt is working or it
-	 * will call disable_irq which undoes all of the above.
-	 */
-	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
-		rc = tpm_write8(chip, TPM_INT_VECTOR(priv->locality),
-				original_int_vec);
-		if (rc < 0)
-			return rc;
-
-		return 1;
-	}
-
-	return 0;
-}
-
-/* Try to find the IRQ the TPM is using. This is for legacy x86 systems that
- * do not have ACPI/etc. We typically expect the interrupt to be declared if
- * present.
- */
-static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	u8 original_int_vec;
-	int i, rc;
-
-	rc = tpm_read8(chip, TPM_INT_VECTOR(priv->locality), &original_int_vec);
-	if (rc < 0)
-		return;
-
-	if (!original_int_vec) {
-		if (IS_ENABLED(CONFIG_X86))
-			for (i = 3; i <= 15; i++)
-				if (!tpm_tis_probe_irq_single(chip, intmask, 0,
-							      i))
-					return;
-	} else if (!tpm_tis_probe_irq_single(chip, intmask, 0,
-					     original_int_vec))
-		return;
-}
-
 static int tpm_tis_post_probe(struct tpm_chip *chip)
 {
 	int probe;
@@ -811,233 +218,27 @@ static const struct tpm_tis_phy_ops tpm_mem = {
 	.post_probe = tpm_tis_post_probe,
 };
 
-static bool interrupts = true;
-module_param(interrupts, bool, 0444);
-MODULE_PARM_DESC(interrupts, "Enable interrupts");
-
-static void tpm_tis_remove(struct tpm_chip *chip)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	u32 reg = TPM_INT_ENABLE(priv->locality);
-	u32 interrupt;
-	int rc;
-
-	rc = tpm_read32(chip, reg, &interrupt);
-	if (rc < 0)
-		interrupt = 0;
-
-	tpm_write32(chip, reg, ~TPM_GLOBAL_INT_ENABLE & interrupt);
-	release_locality(chip, priv->locality, 1);
-}
-
 static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 			acpi_handle acpi_dev_handle)
 {
-	u32 vendor, intfcaps, intmask;
-	u8 rid;
-	int rc;
-	struct tpm_chip *chip;
 	struct tpm_tis_lpc_phy *phy;
+	int irq = -1;
 
 	phy = devm_kzalloc(dev, sizeof(struct tpm_tis_lpc_phy), GFP_KERNEL);
 	if (phy == NULL)
 		return -ENOMEM;
 
-	chip = tpmm_chip_alloc(dev, &tpm_tis);
-	if (IS_ERR(chip))
-		return PTR_ERR(chip);
-
-#ifdef CONFIG_ACPI
-	chip->acpi_dev_handle = acpi_dev_handle;
-#endif
-
 	phy->iobase = devm_ioremap_resource(dev, &tpm_info->res);
 	if (IS_ERR(phy->iobase))
 		return PTR_ERR(phy->iobase);
 
-	phy->priv.phy_ops = &tpm_mem;
-
-	/* Maximum timeouts */
-	chip->timeout_a = TIS_TIMEOUT_A_MAX;
-	chip->timeout_b = TIS_TIMEOUT_B_MAX;
-	chip->timeout_c = TIS_TIMEOUT_C_MAX;
-	chip->timeout_d = TIS_TIMEOUT_D_MAX;
-	phy->priv.data_expect_val = TPM_STS_DATA_EXPECT;
-	phy->priv.data_expect_mask = TPM_STS_DATA_EXPECT;
+	if (interrupts)
+		irq = tpm_info->irq;
 
-	dev_set_drvdata(&chip->dev, &phy->priv);
-
-	if (wait_startup(chip, 0) != 0) {
-		rc = -ENODEV;
-		goto out_err;
-	}
-
-	/* Take control of the TPM's interrupt hardware and shut it off */
-	rc = tpm_read32(chip, TPM_INT_ENABLE(phy->priv.locality), &intmask);
-	if (rc < 0)
-		goto out_err;
-
-	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
-		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
-	intmask &= ~TPM_GLOBAL_INT_ENABLE;
-	tpm_write32(chip, TPM_INT_ENABLE(phy->priv.locality), intmask);
-
-	if (request_locality(chip, 0) != 0) {
-		rc = -ENODEV;
-		goto out_err;
-	}
-
-	rc = tpm2_probe(chip);
-	if (rc)
-		goto out_err;
-
-	rc = tpm_read32(chip, TPM_DID_VID(0), &vendor);
-	if (rc < 0)
-		goto out_err;
-
-	phy->priv.manufacturer_id = vendor;
-
-	rc = tpm_read8(chip, TPM_RID(0), &rid);
-	if (rc < 0)
-		goto out_err;
-
-	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
-		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
-		 vendor >> 16, rid);
-
-	if (phy->priv.phy_ops->post_probe) {
-		rc = phy->priv.phy_ops->post_probe(chip);
-		if (rc < 0) {
-			rc = -ENODEV;
-			goto out_err;
-		}
-	}
-
-	/* Figure out the capabilities */
-	rc = tpm_read32(chip, TPM_INTF_CAPS(phy->priv.locality), &intfcaps);
-	if (rc < 0)
-		goto out_err;
-
-	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
-		intfcaps);
-	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
-		dev_dbg(dev, "\tBurst Count Static\n");
-	if (intfcaps & TPM_INTF_CMD_READY_INT)
-		dev_dbg(dev, "\tCommand Ready Int Support\n");
-	if (intfcaps & TPM_INTF_INT_EDGE_FALLING)
-		dev_dbg(dev, "\tInterrupt Edge Falling\n");
-	if (intfcaps & TPM_INTF_INT_EDGE_RISING)
-		dev_dbg(dev, "\tInterrupt Edge Rising\n");
-	if (intfcaps & TPM_INTF_INT_LEVEL_LOW)
-		dev_dbg(dev, "\tInterrupt Level Low\n");
-	if (intfcaps & TPM_INTF_INT_LEVEL_HIGH)
-		dev_dbg(dev, "\tInterrupt Level High\n");
-	if (intfcaps & TPM_INTF_LOCALITY_CHANGE_INT)
-		dev_dbg(dev, "\tLocality Change Int Support\n");
-	if (intfcaps & TPM_INTF_STS_VALID_INT)
-		dev_dbg(dev, "\tSts Valid Int Support\n");
-	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
-		dev_dbg(dev, "\tData Avail Int Support\n");
-
-	/* Very early on issue a command to the TPM in polling mode to make
-	 * sure it works. May as well use that command to set the proper
-	 *  timeouts for the driver.
-	 */
-	if (tpm_get_timeouts(chip)) {
-		dev_err(dev, "Could not get TPM timeouts and durations\n");
-		rc = -ENODEV;
-		goto out_err;
-	}
-
-	/* INTERRUPT Setup */
-	init_waitqueue_head(&phy->priv.read_queue);
-	init_waitqueue_head(&phy->priv.int_queue);
-	if (interrupts && tpm_info->irq != -1) {
-		if (tpm_info->irq) {
-			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
-						 tpm_info->irq);
-			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
-				dev_err(&chip->dev, FW_BUG
-					"TPM interrupt not working, polling instead\n");
-		} else
-			tpm_tis_probe_irq(chip, intmask);
-	}
-
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		rc = tpm2_do_selftest(chip);
-		if (rc == TPM2_RC_INITIALIZE) {
-			dev_warn(dev, "Firmware has not started TPM\n");
-			rc  = tpm2_startup(chip, TPM2_SU_CLEAR);
-			if (!rc)
-				rc = tpm2_do_selftest(chip);
-		}
-
-		if (rc) {
-			dev_err(dev, "TPM self test failed\n");
-			if (rc > 0)
-				rc = -ENODEV;
-			goto out_err;
-		}
-	} else {
-		if (tpm_do_selftest(chip)) {
-			dev_err(dev, "TPM self test failed\n");
-			rc = -ENODEV;
-			goto out_err;
-		}
-	}
-
-	return tpm_chip_register(chip);
-out_err:
-	tpm_tis_remove(chip);
-	return rc;
-}
-
-#ifdef CONFIG_PM_SLEEP
-static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	u32 intmask;
-	int rc;
-
-	/* reenable interrupts that device may have lost or
-	   BIOS/firmware may have disabled */
-	rc = tpm_write8(chip, TPM_INT_VECTOR(priv->locality), priv->irq);
-	if (rc < 0)
-		return;
-
-	rc = tpm_read32(chip, TPM_INT_ENABLE(priv->locality), &intmask);
-	if (rc < 0)
-		return;
-
-	intmask |= TPM_INTF_CMD_READY_INT
-	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
-	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
-
-	tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
+	return tpm_tis_core_init(dev, &phy->priv, irq, &tpm_mem,
+				 acpi_dev_handle);
 }
 
-static int tpm_tis_resume(struct device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	int ret;
-
-	if (chip->flags & TPM_CHIP_FLAG_IRQ)
-		tpm_tis_reenable_interrupts(chip);
-
-	ret = tpm_pm_resume(dev);
-	if (ret)
-		return ret;
-
-	/* TPM 1.2 requires self-test on resume. This function actually returns
-	 * an error code but for unknown reason it isn't handled.
-	 */
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
-		tpm_do_selftest(chip);
-
-	return 0;
-}
-#endif
-
 static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
 
 static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
@@ -1238,12 +439,6 @@ static struct platform_driver tis_drv = {
 	},
 };
 
-static bool force;
-#ifdef CONFIG_X86
-module_param(force, bool, 0444);
-MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
-#endif
-
 static int tpm_tis_force_device(void)
 {
 	struct platform_device *pdev;
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
new file mode 100644
index 0000000..09f7822
--- /dev/null
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -0,0 +1,809 @@
+/*
+ * Copyright (C) 2005, 2006 IBM Corporation
+ * Copyright (C) 2014, 2015 Intel Corporation
+ *
+ * Authors:
+ * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ * Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * This device driver implements the TPM interface as defined in
+ * the TCG TPM Interface Spec version 1.2, revision 1.0.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pnp.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/wait.h>
+#include <linux/acpi.h>
+#include <linux/freezer.h>
+#include "tpm.h"
+#include "tpm_tis_core.h"
+
+/* Before we attempt to access the TPM we must see that the valid bit is set.
+ * The specification says that this bit is 0 at reset and remains 0 until the
+ * 'TPM has gone through its self test and initialization and has established
+ * correct values in the other bits.'
+ */
+static int wait_startup(struct tpm_chip *chip, int l)
+{
+	unsigned long stop = jiffies + chip->timeout_a;
+
+	do {
+		int rc;
+		u8 access;
+
+		rc = tpm_read8(chip, TPM_ACCESS(l), &access);
+		if (rc < 0)
+			return rc;
+
+		if (access & TPM_ACCESS_VALID)
+			return 0;
+		msleep(TPM_TIMEOUT);
+	} while (time_before(jiffies, stop));
+	return -1;
+}
+
+static int check_locality(struct tpm_chip *chip, int l)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+	u8 access;
+
+	rc = tpm_read8(chip, TPM_ACCESS(l), &access);
+	if (rc < 0)
+		return rc;
+
+	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
+	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
+		return priv->locality = l;
+
+	return -1;
+}
+
+void release_locality(struct tpm_chip *chip, int l, int force)
+{
+	int rc;
+	u8 access;
+
+	rc = tpm_read8(chip, TPM_ACCESS(l), &access);
+	if (rc < 0)
+		return;
+
+	if (force || (access &
+		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
+	    (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
+		tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);
+
+}
+EXPORT_SYMBOL_GPL(release_locality);
+
+static int request_locality(struct tpm_chip *chip, int l)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	unsigned long stop, timeout;
+	long rc;
+
+	if (check_locality(chip, l) >= 0)
+		return l;
+
+	rc = tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
+	if (rc < 0)
+		return rc;
+
+	stop = jiffies + chip->timeout_a;
+
+	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
+again:
+		timeout = stop - jiffies;
+		if ((long)timeout <= 0)
+			return -1;
+		rc = wait_event_interruptible_timeout(priv->int_queue,
+						      (check_locality
+						       (chip, l) >= 0),
+						      timeout);
+		if (rc > 0)
+			return l;
+		if (rc == -ERESTARTSYS && freezing(current)) {
+			clear_thread_flag(TIF_SIGPENDING);
+			goto again;
+		}
+	} else {
+		/* wait for burstcount */
+		do {
+			if (check_locality(chip, l) >= 0)
+				return l;
+			msleep(TPM_TIMEOUT);
+		} while (time_before(jiffies, stop));
+	}
+	return -1;
+}
+
+static u8 tpm_tis_status(struct tpm_chip *chip)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+	u8 status;
+
+	rc = tpm_read8(chip, TPM_STS(priv->locality), &status);
+	if (rc < 0)
+		return 0;
+
+	return status;
+}
+
+void tpm_tis_ready(struct tpm_chip *chip)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	/* this causes the current command to be aborted */
+	tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_COMMAND_READY);
+}
+EXPORT_SYMBOL_GPL(tpm_tis_ready);
+
+static int get_burstcount(struct tpm_chip *chip)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	unsigned long stop;
+	int burstcnt, rc;
+	u8 value;
+
+	/* wait for burstcount */
+	/* which timeout value, spec has 2 answers (c & d) */
+	stop = jiffies + chip->timeout_d;
+	do {
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
+		if (burstcnt)
+			return burstcnt;
+		msleep(TPM_TIMEOUT);
+	} while (time_before(jiffies, stop));
+	return -EBUSY;
+}
+
+static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int size = 0, burstcnt, rc;
+
+	while (size < count &&
+	       wait_for_tpm_stat(chip,
+				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+				 chip->timeout_c,
+				 &priv->read_queue, true) == 0) {
+		burstcnt = min_t(int, get_burstcount(chip), count - size);
+
+		rc = tpm_read_bytes(chip, TPM_DATA_FIFO(priv->locality),
+				    burstcnt, buf + size);
+		if (rc < 0)
+			return rc;
+
+		size += burstcnt;
+	}
+	return size;
+}
+
+static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int size = 0;
+	int expected, status;
+
+	if (count < TPM_HEADER_SIZE) {
+		size = -EIO;
+		goto out;
+	}
+
+	size = recv_data(chip, buf, TPM_HEADER_SIZE);
+	/* read first 10 bytes, including tag, paramsize, and result */
+	if (size < TPM_HEADER_SIZE) {
+		dev_err(&chip->dev, "Unable to read header\n");
+		goto out;
+	}
+
+	expected = be32_to_cpu(*(__be32 *) (buf + 2));
+	if (expected > count) {
+		size = -EIO;
+		goto out;
+	}
+
+	size += recv_data(chip, &buf[TPM_HEADER_SIZE],
+			  expected - TPM_HEADER_SIZE);
+	if (size < expected) {
+		dev_err(&chip->dev, "Unable to read remainder of result\n");
+		size = -ETIME;
+		goto out;
+	}
+
+	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
+			  &priv->int_queue, false);
+	status = tpm_tis_status(chip);
+	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
+		dev_err(&chip->dev, "Error left over data\n");
+		size = -EIO;
+		goto out;
+	}
+
+out:
+	tpm_tis_ready(chip);
+	release_locality(chip, priv->locality, 0);
+	return size;
+}
+
+/*
+ * If interrupts are used (signaled by an irq set in the vendor structure)
+ * tpm.c can skip polling for the data to be available as the interrupt is
+ * waited for here
+ */
+int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc, status, burstcnt;
+	size_t count = 0;
+
+	if (request_locality(chip, 0) < 0)
+		return -EBUSY;
+
+	status = tpm_tis_status(chip);
+	if ((status & TPM_STS_COMMAND_READY) == 0) {
+		tpm_tis_ready(chip);
+		if (wait_for_tpm_stat
+		    (chip, TPM_STS_COMMAND_READY, chip->timeout_b,
+		     &priv->int_queue, false) < 0) {
+			rc = -ETIME;
+			goto out_err;
+		}
+	}
+
+	while (count < len - 1) {
+		burstcnt = min_t(int, get_burstcount(chip), len - count - 1);
+		rc = tpm_write_bytes(chip, TPM_DATA_FIFO(priv->locality),
+				     burstcnt, buf + count);
+		if (rc < 0)
+			goto out_err;
+
+		count += burstcnt;
+
+		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
+				  &priv->int_queue, false);
+		status = tpm_tis_status(chip);
+		if ((status & priv->data_expect_mask) !=
+			      priv->data_expect_val) {
+			rc = -EIO;
+			goto out_err;
+		}
+	}
+
+	/* write last byte */
+	rc = tpm_write8(chip, TPM_DATA_FIFO(priv->locality), buf[count]);
+	if (rc < 0)
+		goto out_err;
+
+	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
+			  &priv->int_queue, false);
+	status = tpm_tis_status(chip);
+	if ((status & priv->data_expect_mask) == priv->data_expect_mask) {
+		rc = -EIO;
+		goto out_err;
+	}
+
+	return 0;
+
+out_err:
+	tpm_tis_ready(chip);
+	release_locality(chip, priv->locality, 0);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_tis_send_data);
+
+static void disable_interrupts(struct tpm_chip *chip)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	u32 intmask;
+	int rc;
+
+	rc = tpm_read32(chip, TPM_INT_ENABLE(priv->locality), &intmask);
+	if (rc < 0)
+		intmask = 0;
+
+	intmask &= ~TPM_GLOBAL_INT_ENABLE;
+	rc = tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
+
+	devm_free_irq(&chip->dev, priv->irq, chip);
+	priv->irq = 0;
+	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
+}
+
+/*
+ * If interrupts are used (signaled by an irq set in the vendor structure)
+ * tpm.c can skip polling for the data to be available as the interrupt is
+ * waited for here
+ */
+static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+	u32 ordinal;
+	unsigned long dur;
+
+	rc = tpm_tis_send_data(chip, buf, len);
+	if (rc < 0)
+		return rc;
+
+	/* go and do it */
+	rc = tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_GO);
+	if (rc < 0)
+		goto out_err;
+
+	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
+		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+
+		if (chip->flags & TPM_CHIP_FLAG_TPM2)
+			dur = tpm2_calc_ordinal_duration(chip, ordinal);
+		else
+			dur = tpm_calc_ordinal_duration(chip, ordinal);
+
+		if (wait_for_tpm_stat
+		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
+		     &priv->read_queue, false) < 0) {
+			rc = -ETIME;
+			goto out_err;
+		}
+	}
+	return len;
+out_err:
+	tpm_tis_ready(chip);
+	release_locality(chip, priv->locality, 0);
+	return rc;
+}
+
+static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	int rc, irq;
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	if (!(chip->flags & TPM_CHIP_FLAG_IRQ) || priv->irq_tested)
+		return tpm_tis_send_main(chip, buf, len);
+
+	/* Verify receipt of the expected IRQ */
+	irq = priv->irq;
+	priv->irq = 0;
+	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
+	rc = tpm_tis_send_main(chip, buf, len);
+	priv->irq = irq;
+	chip->flags |= TPM_CHIP_FLAG_IRQ;
+	if (!priv->irq_tested)
+		msleep(1);
+	if (!priv->irq_tested)
+		disable_interrupts(chip);
+	priv->irq_tested = true;
+	return rc;
+}
+
+struct tis_vendor_timeout_override {
+	u32 did_vid;
+	unsigned long timeout_us[4];
+};
+
+static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
+	/* Atmel 3204 */
+	{ 0x32041114, { (TIS_SHORT_TIMEOUT*1000), (TIS_LONG_TIMEOUT*1000),
+			(TIS_SHORT_TIMEOUT*1000), (TIS_SHORT_TIMEOUT*1000) } },
+};
+
+static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
+				    unsigned long *timeout_cap)
+{
+	int i, rc;
+	u32 did_vid;
+
+	rc = tpm_read32(chip, TPM_DID_VID(0), &did_vid);
+	if (rc < 0)
+		return rc;
+
+	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
+		if (vendor_timeout_overrides[i].did_vid != did_vid)
+			continue;
+		memcpy(timeout_cap, vendor_timeout_overrides[i].timeout_us,
+		       sizeof(vendor_timeout_overrides[i].timeout_us));
+		return true;
+	}
+
+	return false;
+}
+
+static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	switch (priv->manufacturer_id) {
+	case TPM_VID_WINBOND:
+		return ((status == TPM_STS_VALID) ||
+			(status == (TPM_STS_VALID | TPM_STS_COMMAND_READY)));
+	case TPM_VID_STM:
+		return (status == (TPM_STS_VALID | TPM_STS_COMMAND_READY));
+	default:
+		return (status == TPM_STS_COMMAND_READY);
+	}
+}
+
+static irqreturn_t tis_int_handler(int dummy, void *dev_id)
+{
+	struct tpm_chip *chip = dev_id;
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	u32 interrupt;
+	int i, rc;
+
+	rc = tpm_read32(chip, TPM_INT_STATUS(priv->locality), &interrupt);
+	if (rc < 0)
+		return IRQ_NONE;
+
+	if (interrupt == 0)
+		return IRQ_NONE;
+
+	priv->irq_tested = true;
+	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
+		wake_up_interruptible(&priv->read_queue);
+	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
+		for (i = 0; i < 5; i++)
+			if (check_locality(chip, i) >= 0)
+				break;
+	if (interrupt &
+	    (TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_STS_VALID_INT |
+	     TPM_INTF_CMD_READY_INT))
+		wake_up_interruptible(&priv->int_queue);
+
+	/* Clear interrupts handled with TPM_EOI */
+	rc = tpm_write32(chip, TPM_INT_STATUS(priv->locality), interrupt);
+	if (rc < 0)
+		return IRQ_NONE;
+
+	tpm_read32(chip, TPM_INT_STATUS(priv->locality), &interrupt);
+	return IRQ_HANDLED;
+}
+
+/* Register the IRQ and issue a command that will cause an interrupt. If an
+ * irq is seen then leave the chip setup for IRQ operation, otherwise reverse
+ * everything and leave in polling mode. Returns 0 on success.
+ */
+static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
+				    int flags, int irq)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	u8 original_int_vec;
+	int rc;
+	u32 int_status;
+
+	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
+			     dev_name(&chip->dev), chip) != 0) {
+		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
+			 irq);
+		return -1;
+	}
+	priv->irq = irq;
+
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
+
+	/* Clear all existing */
+	rc = tpm_write32(chip, TPM_INT_STATUS(priv->locality), int_status);
+	if (rc < 0)
+		return rc;
+
+	/* Turn on */
+	rc = tpm_write32(chip, TPM_INT_ENABLE(priv->locality),
+			 intmask | TPM_GLOBAL_INT_ENABLE);
+	if (rc < 0)
+		return rc;
+
+	priv->irq_tested = false;
+
+	/* Generate an interrupt by having the core call through to
+	 * tpm_tis_send
+	 */
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_gen_interrupt(chip);
+	else
+		tpm_gen_interrupt(chip);
+
+	/* tpm_tis_send will either confirm the interrupt is working or it
+	 * will call disable_irq which undoes all of the above.
+	 */
+	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
+		rc = tpm_write8(chip, original_int_vec,
+				TPM_INT_VECTOR(priv->locality));
+		if (rc < 0)
+			return rc;
+
+		return 1;
+	}
+
+	return 0;
+}
+
+/* Try to find the IRQ the TPM is using. This is for legacy x86 systems that
+ * do not have ACPI/etc. We typically expect the interrupt to be declared if
+ * present.
+ */
+static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	u8 original_int_vec;
+	int i, rc;
+
+	rc = tpm_read8(chip, TPM_INT_VECTOR(priv->locality), &original_int_vec);
+	if (rc < 0)
+		return;
+
+	if (!original_int_vec) {
+		if (IS_ENABLED(CONFIG_X86))
+			for (i = 3; i <= 15; i++)
+				if (!tpm_tis_probe_irq_single(chip, intmask, 0,
+							      i))
+					return;
+	} else if (!tpm_tis_probe_irq_single(chip, intmask, 0,
+					     original_int_vec))
+		return;
+}
+
+void tpm_tis_remove(struct tpm_chip *chip)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	u32 reg = TPM_INT_ENABLE(priv->locality);
+	u32 interrupt;
+	int rc;
+
+	rc = tpm_read32(chip, reg, &interrupt);
+	if (rc < 0)
+		interrupt = 0;
+
+	tpm_write32(chip, reg, ~TPM_GLOBAL_INT_ENABLE & interrupt);
+	release_locality(chip, priv->locality, 1);
+}
+EXPORT_SYMBOL_GPL(tpm_tis_remove);
+
+static const struct tpm_class_ops tpm_tis = {
+	.status = tpm_tis_status,
+	.recv = tpm_tis_recv,
+	.send = tpm_tis_send,
+	.cancel = tpm_tis_ready,
+	.update_timeouts = tpm_tis_update_timeouts,
+	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+	.req_canceled = tpm_tis_req_canceled,
+};
+
+int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
+		      const struct tpm_tis_phy_ops *phy_ops,
+		      acpi_handle acpi_dev_handle)
+{
+	u32 vendor, intfcaps, intmask;
+	u8 rid;
+	int rc;
+	struct tpm_chip *chip;
+
+	chip = tpmm_chip_alloc(dev, &tpm_tis);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
+
+#ifdef CONFIG_ACPI
+	chip->acpi_dev_handle = acpi_dev_handle;
+#endif
+
+	/* Maximum timeouts */
+	chip->timeout_a = TIS_TIMEOUT_A_MAX;
+	chip->timeout_b = TIS_TIMEOUT_B_MAX;
+	chip->timeout_c = TIS_TIMEOUT_C_MAX;
+	chip->timeout_d = TIS_TIMEOUT_D_MAX;
+	priv->data_expect_val = TPM_STS_DATA_EXPECT;
+	priv->data_expect_mask = TPM_STS_DATA_EXPECT;
+	priv->phy_ops = phy_ops;
+	dev_set_drvdata(&chip->dev, priv);
+
+	if (wait_startup(chip, 0) != 0) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	/* Take control of the TPM's interrupt hardware and shut it off */
+	rc = tpm_read32(chip, TPM_INT_ENABLE(priv->locality), &intmask);
+	if (rc < 0)
+		goto out_err;
+
+	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
+		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
+	intmask &= ~TPM_GLOBAL_INT_ENABLE;
+	tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
+
+	if (request_locality(chip, 0) != 0) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	rc = tpm2_probe(chip);
+	if (rc)
+		goto out_err;
+
+	rc = tpm_read32(chip, TPM_DID_VID(0), &vendor);
+	if (rc < 0)
+		goto out_err;
+
+	priv->manufacturer_id = vendor;
+
+	rc = tpm_read8(chip, TPM_RID(0), &rid);
+	if (rc < 0)
+		goto out_err;
+
+	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
+		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
+		 vendor >> 16, rid);
+
+	if (priv->phy_ops && priv->phy_ops->post_probe) {
+		rc = priv->phy_ops->post_probe(chip);
+		if (rc < 0) {
+			rc = -ENODEV;
+			goto out_err;
+		}
+	}
+
+	/* Figure out the capabilities */
+	rc = tpm_read32(chip, TPM_INTF_CAPS(priv->locality), &intfcaps);
+	if (rc < 0)
+		goto out_err;
+
+	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
+		intfcaps);
+	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
+		dev_dbg(dev, "\tBurst Count Static\n");
+	if (intfcaps & TPM_INTF_CMD_READY_INT)
+		dev_dbg(dev, "\tCommand Ready Int Support\n");
+	if (intfcaps & TPM_INTF_INT_EDGE_FALLING)
+		dev_dbg(dev, "\tInterrupt Edge Falling\n");
+	if (intfcaps & TPM_INTF_INT_EDGE_RISING)
+		dev_dbg(dev, "\tInterrupt Edge Rising\n");
+	if (intfcaps & TPM_INTF_INT_LEVEL_LOW)
+		dev_dbg(dev, "\tInterrupt Level Low\n");
+	if (intfcaps & TPM_INTF_INT_LEVEL_HIGH)
+		dev_dbg(dev, "\tInterrupt Level High\n");
+	if (intfcaps & TPM_INTF_LOCALITY_CHANGE_INT)
+		dev_dbg(dev, "\tLocality Change Int Support\n");
+	if (intfcaps & TPM_INTF_STS_VALID_INT)
+		dev_dbg(dev, "\tSts Valid Int Support\n");
+	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
+		dev_dbg(dev, "\tData Avail Int Support\n");
+
+	/* Very early on issue a command to the TPM in polling mode to make
+	 * sure it works. May as well use that command to set the proper
+	 *  timeouts for the driver.
+	 */
+	if (tpm_get_timeouts(chip)) {
+		dev_err(dev, "Could not get TPM timeouts and durations\n");
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	/* INTERRUPT Setup */
+	init_waitqueue_head(&priv->read_queue);
+	init_waitqueue_head(&priv->int_queue);
+	if (irq != -1) {
+		if (irq) {
+			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
+						 irq);
+			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
+				dev_err(&chip->dev, FW_BUG
+					"TPM interrupt not working, polling instead\n");
+		} else {
+			tpm_tis_probe_irq(chip, intmask);
+		}
+	}
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		rc = tpm2_do_selftest(chip);
+		if (rc == TPM2_RC_INITIALIZE) {
+			dev_warn(dev, "Firmware has not started TPM\n");
+			rc  = tpm2_startup(chip, TPM2_SU_CLEAR);
+			if (!rc)
+				rc = tpm2_do_selftest(chip);
+		}
+
+		if (rc) {
+			dev_err(dev, "TPM self test failed\n");
+			if (rc > 0)
+				rc = -ENODEV;
+			goto out_err;
+		}
+	} else {
+		if (tpm_do_selftest(chip)) {
+			dev_err(dev, "TPM self test failed\n");
+			rc = -ENODEV;
+			goto out_err;
+		}
+	}
+
+	return tpm_chip_register(chip);
+out_err:
+	tpm_tis_remove(chip);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_tis_core_init);
+
+#ifdef CONFIG_PM_SLEEP
+static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	u32 intmask;
+	int rc;
+
+	/* reenable interrupts that device may have lost or
+	 * BIOS/firmware may have disabled
+	 */
+	rc = tpm_write8(chip, TPM_INT_VECTOR(priv->locality), priv->irq);
+	if (rc < 0)
+		return;
+
+	rc = tpm_read32(chip, TPM_INT_ENABLE(priv->locality), &intmask);
+	if (rc < 0)
+		return;
+
+	intmask |= TPM_INTF_CMD_READY_INT
+	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
+	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
+
+	tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
+}
+
+int tpm_tis_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	int ret;
+
+	if (chip->flags & TPM_CHIP_FLAG_IRQ)
+		tpm_tis_reenable_interrupts(chip);
+
+	ret = tpm_pm_resume(dev);
+	if (ret)
+		return ret;
+
+	/* TPM 1.2 requires self-test on resume. This function actually returns
+	 * an error code but for unknown reason it isn't handled.
+	 */
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+		tpm_do_selftest(chip);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tpm_tis_resume);
+#endif
+
+MODULE_AUTHOR("Leendert van Doorn (leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org)");
+MODULE_DESCRIPTION("TPM Driver");
+MODULE_VERSION("2.0");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index c9d7b38..02f64a1 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -25,6 +25,60 @@
 
 #include "tpm.h"
 
+enum tis_access {
+	TPM_ACCESS_VALID = 0x80,
+	TPM_ACCESS_ACTIVE_LOCALITY = 0x20,
+	TPM_ACCESS_REQUEST_PENDING = 0x04,
+	TPM_ACCESS_REQUEST_USE = 0x02,
+};
+
+enum tis_status {
+	TPM_STS_VALID = 0x80,
+	TPM_STS_COMMAND_READY = 0x40,
+	TPM_STS_GO = 0x20,
+	TPM_STS_DATA_AVAIL = 0x10,
+	TPM_STS_DATA_EXPECT = 0x08,
+};
+
+enum tis_int_flags {
+	TPM_GLOBAL_INT_ENABLE = 0x80000000,
+	TPM_INTF_BURST_COUNT_STATIC = 0x100,
+	TPM_INTF_CMD_READY_INT = 0x080,
+	TPM_INTF_INT_EDGE_FALLING = 0x040,
+	TPM_INTF_INT_EDGE_RISING = 0x020,
+	TPM_INTF_INT_LEVEL_LOW = 0x010,
+	TPM_INTF_INT_LEVEL_HIGH = 0x008,
+	TPM_INTF_LOCALITY_CHANGE_INT = 0x004,
+	TPM_INTF_STS_VALID_INT = 0x002,
+	TPM_INTF_DATA_AVAIL_INT = 0x001,
+};
+
+enum tis_defaults {
+	TIS_MEM_LEN = 0x5000,
+	TIS_SHORT_TIMEOUT = 750,	/* ms */
+	TIS_LONG_TIMEOUT = 2000,	/* 2 sec */
+};
+
+/* Some timeout values are needed before it is known whether the chip is
+ * TPM 1.0 or TPM 2.0.
+ */
+#define TIS_TIMEOUT_A_MAX	max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_A)
+#define TIS_TIMEOUT_B_MAX	max(TIS_LONG_TIMEOUT, TPM2_TIMEOUT_B)
+#define TIS_TIMEOUT_C_MAX	max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_C)
+#define TIS_TIMEOUT_D_MAX	max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_D)
+
+#define	TPM_ACCESS(l)			(0x0000 | ((l) << 12))
+#define	TPM_INT_ENABLE(l)		(0x0008 | ((l) << 12))
+#define	TPM_INT_VECTOR(l)		(0x000C | ((l) << 12))
+#define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
+#define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
+#define	TPM_STS(l)			(0x0018 | ((l) << 12))
+#define	TPM_STS3(l)			(0x001b | ((l) << 12))
+#define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
+
+#define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
+#define	TPM_RID(l)			(0x0F04 | ((l) << 12))
+
 struct tpm_tis_phy_ops {
 	int (*read_bytes)(struct tpm_chip *chip, u32 addr, u16 len,
 			  u8 *result);
@@ -133,4 +187,16 @@ static inline int tpm_write32(struct tpm_chip *chip, u32 addr, u32 value)
 	return priv->phy_ops->write32(chip, addr, value);
 }
 
+void tpm_tis_ready(struct tpm_chip *chip);
+void release_locality(struct tpm_chip *chip, int l, int force);
+int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len);
+void tpm_tis_remove(struct tpm_chip *chip);
+int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
+		      const struct tpm_tis_phy_ops *phy_ops,
+		      acpi_handle acpi_dev_handle);
+
+#ifdef CONFIG_PM_SLEEP
+int tpm_tis_resume(struct device *dev);
+#endif
+
 #endif
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
