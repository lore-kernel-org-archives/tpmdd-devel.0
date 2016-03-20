From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/12] tpm/tpm_tis: Split tpm_tis driver into
	a core and TCG TIS compliant phy
Date: Sun, 20 Mar 2016 20:34:39 +0100
Message-ID: <1458502483-16887-9-git-send-email-christophe-h.ricard@st.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1458502483-16887-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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
 drivers/char/tpm/Makefile       |   2 +-
 drivers/char/tpm/tpm.h          |   2 +
 drivers/char/tpm/tpm_tis.c      | 803 +++-------------------------------------
 drivers/char/tpm/tpm_tis_core.c | 728 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_tis_core.h | 166 +++++++++
 include/linux/tpm.h             |   4 +
 6 files changed, 954 insertions(+), 751 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_tis_core.c
 create mode 100644 drivers/char/tpm/tpm_tis_core.h

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 56e8f1f..c6a4cea 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o tpm_tis_core.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 6a973b9..3ec04f4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -142,6 +142,7 @@ struct tpm_vendor_specific {
 
 	int region_size;
 	int have_region;
+	bool itpm;
 
 	struct list_head list;
 	int locality;
@@ -149,6 +150,7 @@ struct tpm_vendor_specific {
 	bool timeout_adjusted;
 	unsigned long duration[3]; /* jiffies */
 	bool duration_adjusted;
+	bool irq_tested;
 	void *priv;
 
 	wait_queue_head_t read_queue;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 607fa3f..eb86667 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -19,6 +19,7 @@
  * published by the Free Software Foundation, version 2 of the
  * License.
  */
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -29,40 +30,49 @@
 #include <linux/acpi.h>
 #include <linux/freezer.h>
 #include "tpm.h"
+#include "tpm_tis_core.h"
 
-enum tis_access {
-	TPM_ACCESS_VALID = 0x80,
-	TPM_ACCESS_ACTIVE_LOCALITY = 0x20,
-	TPM_ACCESS_REQUEST_PENDING = 0x04,
-	TPM_ACCESS_REQUEST_USE = 0x02,
-};
+static int read_mem_bytes(struct tpm_chip *chip, u32 addr, size_t len, u8 size,
+			  u8 *result)
+{
+	int i;
 
-enum tis_status {
-	TPM_STS_VALID = 0x80,
-	TPM_STS_COMMAND_READY = 0x40,
-	TPM_STS_GO = 0x20,
-	TPM_STS_DATA_AVAIL = 0x10,
-	TPM_STS_DATA_EXPECT = 0x08,
-};
+	switch (size) {
+	case 4:
+		*(u32 *)result = ioread32(chip->vendor.iobase + addr);
+	break;
+	case 2:
+		*(u16 *)result = ioread16(chip->vendor.iobase + addr);
+	break;
+	case 1:
+	default:
+		for (i = 0; i < len; i++)
+			result[i] = ioread8(chip->vendor.iobase + addr);
+	}
 
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
+	return 0;
+}
 
-enum tis_defaults {
-	TIS_MEM_LEN = 0x5000,
-	TIS_SHORT_TIMEOUT = 750,	/* ms */
-	TIS_LONG_TIMEOUT = 2000,	/* 2 sec */
-};
+static int write_mem_bytes(struct tpm_chip *chip, u32 addr, size_t len, u8 size,
+			   u8 *value)
+{
+	int i;
+
+	switch (size) {
+	case 4:
+		iowrite32(*(u32 *)value, chip->vendor.iobase + addr);
+	break;
+	case 2:
+		iowrite16(*(u16 *)value, chip->vendor.iobase + addr);
+	break;
+	case 1:
+	default:
+		for (i = 0 ; i < len; i++)
+			iowrite8(value[i], chip->vendor.iobase + addr);
+	}
+
+	return 0;
+}
 
 struct tpm_info {
 	struct resource res;
@@ -73,38 +83,14 @@ struct tpm_info {
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
-struct priv_data {
-	bool irq_tested;
-};
-
 #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
 static int has_hid(struct acpi_device *dev, const char *hid)
 {
 	struct acpi_hardware_id *id;
 
 	list_for_each_entry(id, &dev->pnp.ids, list)
-		if (!strcmp(hid, id->id))
-			return 1;
+	if (!strcmp(hid, id->id))
+		return 1;
 
 	return 0;
 }
@@ -120,409 +106,10 @@ static inline int is_itpm(struct acpi_device *dev)
 }
 #endif
 
-/* Before we attempt to access the TPM we must see that the valid bit is set.
- * The specification says that this bit is 0 at reset and remains 0 until the
- * 'TPM has gone through its self test and initialization and has established
- * correct values in the other bits.' */
-static int wait_startup(struct tpm_chip *chip, int l)
-{
-	unsigned long stop = jiffies + chip->vendor.timeout_a;
-	do {
-		if (ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
-		    TPM_ACCESS_VALID)
-			return 0;
-		msleep(TPM_TIMEOUT);
-	} while (time_before(jiffies, stop));
-	return -1;
-}
-
-static int check_locality(struct tpm_chip *chip, int l)
-{
-	if ((ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
-	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
-	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
-		return chip->vendor.locality = l;
-
-	return -1;
-}
-
-static void release_locality(struct tpm_chip *chip, int l, int force)
-{
-	if (force || (ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
-		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
-	    (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
-		iowrite8(TPM_ACCESS_ACTIVE_LOCALITY,
-			 chip->vendor.iobase + TPM_ACCESS(l));
-}
-
-static int request_locality(struct tpm_chip *chip, int l)
-{
-	unsigned long stop, timeout;
-	long rc;
-
-	if (check_locality(chip, l) >= 0)
-		return l;
-
-	iowrite8(TPM_ACCESS_REQUEST_USE,
-		 chip->vendor.iobase + TPM_ACCESS(l));
-
-	stop = jiffies + chip->vendor.timeout_a;
-
-	if (chip->vendor.irq) {
-again:
-		timeout = stop - jiffies;
-		if ((long)timeout <= 0)
-			return -1;
-		rc = wait_event_interruptible_timeout(chip->vendor.int_queue,
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
-	return ioread8(chip->vendor.iobase +
-		       TPM_STS(chip->vendor.locality));
-}
-
-static void tpm_tis_ready(struct tpm_chip *chip)
-{
-	/* this causes the current command to be aborted */
-	iowrite8(TPM_STS_COMMAND_READY,
-		 chip->vendor.iobase + TPM_STS(chip->vendor.locality));
-}
-
-static int get_burstcount(struct tpm_chip *chip)
-{
-	unsigned long stop;
-	int burstcnt;
-
-	/* wait for burstcount */
-	/* which timeout value, spec has 2 answers (c & d) */
-	stop = jiffies + chip->vendor.timeout_d;
-	do {
-		burstcnt = ioread8(chip->vendor.iobase +
-				   TPM_STS(chip->vendor.locality) + 1);
-		burstcnt += ioread8(chip->vendor.iobase +
-				    TPM_STS(chip->vendor.locality) +
-				    2) << 8;
-		if (burstcnt)
-			return burstcnt;
-		msleep(TPM_TIMEOUT);
-	} while (time_before(jiffies, stop));
-	return -EBUSY;
-}
-
-static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
-{
-	int size = 0, burstcnt;
-	while (size < count &&
-	       wait_for_tpm_stat(chip,
-				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-				 chip->vendor.timeout_c,
-				 &chip->vendor.read_queue, true)
-	       == 0) {
-		burstcnt = get_burstcount(chip);
-		for (; burstcnt > 0 && size < count; burstcnt--)
-			buf[size++] = ioread8(chip->vendor.iobase +
-					      TPM_DATA_FIFO(chip->vendor.
-							    locality));
-	}
-	return size;
-}
-
-static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
-{
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
-	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
-			  &chip->vendor.int_queue, false);
-	status = tpm_tis_status(chip);
-	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
-		dev_err(&chip->dev, "Error left over data\n");
-		size = -EIO;
-		goto out;
-	}
-
-out:
-	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
-	return size;
-}
-
 static bool itpm;
 module_param(itpm, bool, 0444);
 MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
 
-/*
- * If interrupts are used (signaled by an irq set in the vendor structure)
- * tpm.c can skip polling for the data to be available as the interrupt is
- * waited for here
- */
-static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
-{
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
-		    (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
-		     &chip->vendor.int_queue, false) < 0) {
-			rc = -ETIME;
-			goto out_err;
-		}
-	}
-
-	while (count < len - 1) {
-		burstcnt = get_burstcount(chip);
-		for (; burstcnt > 0 && count < len - 1; burstcnt--) {
-			iowrite8(buf[count], chip->vendor.iobase +
-				 TPM_DATA_FIFO(chip->vendor.locality));
-			count++;
-		}
-
-		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
-				  &chip->vendor.int_queue, false);
-		status = tpm_tis_status(chip);
-		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
-			rc = -EIO;
-			goto out_err;
-		}
-	}
-
-	/* write last byte */
-	iowrite8(buf[count],
-		 chip->vendor.iobase + TPM_DATA_FIFO(chip->vendor.locality));
-	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
-			  &chip->vendor.int_queue, false);
-	status = tpm_tis_status(chip);
-	if ((status & TPM_STS_DATA_EXPECT) != 0) {
-		rc = -EIO;
-		goto out_err;
-	}
-
-	return 0;
-
-out_err:
-	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
-	return rc;
-}
-
-static void disable_interrupts(struct tpm_chip *chip)
-{
-	u32 intmask;
-
-	intmask =
-	    ioread32(chip->vendor.iobase +
-		     TPM_INT_ENABLE(chip->vendor.locality));
-	intmask &= ~TPM_GLOBAL_INT_ENABLE;
-	iowrite32(intmask,
-		  chip->vendor.iobase +
-		  TPM_INT_ENABLE(chip->vendor.locality));
-	devm_free_irq(&chip->dev, chip->vendor.irq, chip);
-	chip->vendor.irq = 0;
-}
-
-/*
- * If interrupts are used (signaled by an irq set in the vendor structure)
- * tpm.c can skip polling for the data to be available as the interrupt is
- * waited for here
- */
-static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
-{
-	int rc;
-	u32 ordinal;
-	unsigned long dur;
-
-	rc = tpm_tis_send_data(chip, buf, len);
-	if (rc < 0)
-		return rc;
-
-	/* go and do it */
-	iowrite8(TPM_STS_GO,
-		 chip->vendor.iobase + TPM_STS(chip->vendor.locality));
-
-	if (chip->vendor.irq) {
-		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
-
-		if (chip->flags & TPM_CHIP_FLAG_TPM2)
-			dur = tpm2_calc_ordinal_duration(chip, ordinal);
-		else
-			dur = tpm_calc_ordinal_duration(chip, ordinal);
-
-		if (wait_for_tpm_stat
-		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
-		     &chip->vendor.read_queue, false) < 0) {
-			rc = -ETIME;
-			goto out_err;
-		}
-	}
-	return len;
-out_err:
-	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
-	return rc;
-}
-
-static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
-{
-	int rc, irq;
-	struct priv_data *priv = chip->vendor.priv;
-
-	if (!chip->vendor.irq || priv->irq_tested)
-		return tpm_tis_send_main(chip, buf, len);
-
-	/* Verify receipt of the expected IRQ */
-	irq = chip->vendor.irq;
-	chip->vendor.irq = 0;
-	rc = tpm_tis_send_main(chip, buf, len);
-	chip->vendor.irq = irq;
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
-	int i;
-	u32 did_vid;
-
-	did_vid = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
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
-/*
- * Early probing for iTPM with STS_DATA_EXPECT flaw.
- * Try sending command without itpm flag set and if that
- * fails, repeat with itpm flag set.
- */
-static int probe_itpm(struct tpm_chip *chip)
-{
-	int rc = 0;
-	u8 cmd_getticks[] = {
-		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
-		0x00, 0x00, 0x00, 0xf1
-	};
-	size_t len = sizeof(cmd_getticks);
-	bool rem_itpm = itpm;
-	u16 vendor = ioread16(chip->vendor.iobase + TPM_DID_VID(0));
-
-	/* probe only iTPMS */
-	if (vendor != TPM_VID_INTEL)
-		return 0;
-
-	itpm = false;
-
-	rc = tpm_tis_send_data(chip, cmd_getticks, len);
-	if (rc == 0)
-		goto out;
-
-	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
-
-	itpm = true;
-
-	rc = tpm_tis_send_data(chip, cmd_getticks, len);
-	if (rc == 0) {
-		dev_info(&chip->dev, "Detected an iTPM.\n");
-		rc = 1;
-	} else
-		rc = -EFAULT;
-
-out:
-	itpm = rem_itpm;
-	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
-
-	return rc;
-}
-
-static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
-{
-	switch (chip->vendor.manufacturer_id) {
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
 static const struct tpm_class_ops tpm_tis = {
 	.status = tpm_tis_status,
 	.recv = tpm_tis_recv,
@@ -532,153 +119,24 @@ static const struct tpm_class_ops tpm_tis = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_tis_req_canceled,
+	.read_bytes = read_mem_bytes,
+	.write_bytes = write_mem_bytes,
 };
 
-static irqreturn_t tis_int_handler(int dummy, void *dev_id)
-{
-	struct tpm_chip *chip = dev_id;
-	u32 interrupt;
-	int i;
-
-	interrupt = ioread32(chip->vendor.iobase +
-			     TPM_INT_STATUS(chip->vendor.locality));
-
-	if (interrupt == 0)
-		return IRQ_NONE;
-
-	((struct priv_data *)chip->vendor.priv)->irq_tested = true;
-	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
-		wake_up_interruptible(&chip->vendor.read_queue);
-	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
-		for (i = 0; i < 5; i++)
-			if (check_locality(chip, i) >= 0)
-				break;
-	if (interrupt &
-	    (TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_STS_VALID_INT |
-	     TPM_INTF_CMD_READY_INT))
-		wake_up_interruptible(&chip->vendor.int_queue);
-
-	/* Clear interrupts handled with TPM_EOI */
-	iowrite32(interrupt,
-		  chip->vendor.iobase +
-		  TPM_INT_STATUS(chip->vendor.locality));
-	ioread32(chip->vendor.iobase + TPM_INT_STATUS(chip->vendor.locality));
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
-	struct priv_data *priv = chip->vendor.priv;
-	u8 original_int_vec;
-
-	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
-			     dev_name(&chip->dev), chip) != 0) {
-		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
-			 irq);
-		return -1;
-	}
-	chip->vendor.irq = irq;
-
-	original_int_vec = ioread8(chip->vendor.iobase +
-				   TPM_INT_VECTOR(chip->vendor.locality));
-	iowrite8(irq,
-		 chip->vendor.iobase + TPM_INT_VECTOR(chip->vendor.locality));
-
-	/* Clear all existing */
-	iowrite32(ioread32(chip->vendor.iobase +
-			   TPM_INT_STATUS(chip->vendor.locality)),
-		  chip->vendor.iobase + TPM_INT_STATUS(chip->vendor.locality));
-
-	/* Turn on */
-	iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,
-		  chip->vendor.iobase + TPM_INT_ENABLE(chip->vendor.locality));
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
-	if (!chip->vendor.irq) {
-		iowrite8(original_int_vec,
-			 chip->vendor.iobase +
-			     TPM_INT_VECTOR(chip->vendor.locality));
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
-	u8 original_int_vec;
-	int i;
-
-	original_int_vec = ioread8(chip->vendor.iobase +
-				   TPM_INT_VECTOR(chip->vendor.locality));
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
 static bool interrupts = true;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
-static void tpm_tis_remove(struct tpm_chip *chip)
-{
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		tpm2_shutdown(chip, TPM2_SU_CLEAR);
-
-	iowrite32(~TPM_GLOBAL_INT_ENABLE &
-		  ioread32(chip->vendor.iobase +
-			   TPM_INT_ENABLE(chip->vendor.
-					  locality)),
-		  chip->vendor.iobase +
-		  TPM_INT_ENABLE(chip->vendor.locality));
-	release_locality(chip, chip->vendor.locality, 1);
-}
-
 static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 			acpi_handle acpi_dev_handle)
 {
-	u32 vendor, intfcaps, intmask;
-	int rc, probe;
+	int ret, irq = tpm_info->irq;
 	struct tpm_chip *chip;
-	struct priv_data *priv;
-
-	priv = devm_kzalloc(dev, sizeof(struct priv_data), GFP_KERNEL);
-	if (priv == NULL)
-		return -ENOMEM;
 
 	chip = tpmm_chip_alloc(dev, &tpm_tis);
 	if (IS_ERR(chip))
 		return PTR_ERR(chip);
 
-	tpm_set_vendordata(chip, priv);
 #ifdef CONFIG_ACPI
 	chip->acpi_dev_handle = acpi_dev_handle;
 #endif
@@ -687,177 +145,22 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	if (IS_ERR(chip->vendor.iobase))
 		return PTR_ERR(chip->vendor.iobase);
 
-	/* Maximum timeouts */
-	chip->vendor.timeout_a = TIS_TIMEOUT_A_MAX;
-	chip->vendor.timeout_b = TIS_TIMEOUT_B_MAX;
-	chip->vendor.timeout_c = TIS_TIMEOUT_C_MAX;
-	chip->vendor.timeout_d = TIS_TIMEOUT_D_MAX;
-
-	if (wait_startup(chip, 0) != 0) {
-		rc = -ENODEV;
-		goto out_err;
-	}
+	chip->vendor.itpm = itpm;
 
-	/* Take control of the TPM's interrupt hardware and shut it off */
-	intmask = ioread32(chip->vendor.iobase +
-			   TPM_INT_ENABLE(chip->vendor.locality));
-	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
-		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
-	intmask &= ~TPM_GLOBAL_INT_ENABLE;
-	iowrite32(intmask,
-		  chip->vendor.iobase + TPM_INT_ENABLE(chip->vendor.locality));
-
-	if (request_locality(chip, 0) != 0) {
-		rc = -ENODEV;
-		goto out_err;
-	}
+	if (!interrupts)
+		irq = -1;
 
-	rc = tpm2_probe(chip);
-	if (rc)
+	ret = tpm_tis_init_core(dev, chip, irq, IRQF_SHARED);
+	if (ret < 0)
 		goto out_err;
 
-	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
-	chip->vendor.manufacturer_id = vendor;
-
-	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
-		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
-		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
-
-	if (!itpm) {
-		probe = probe_itpm(chip);
-		if (probe < 0) {
-			rc = -ENODEV;
-			goto out_err;
-		}
-		itpm = !!probe;
-	}
-
-	if (itpm)
-		dev_info(dev, "Intel iTPM workaround enabled\n");
-
-
-	/* Figure out the capabilities */
-	intfcaps =
-	    ioread32(chip->vendor.iobase +
-		     TPM_INTF_CAPS(chip->vendor.locality));
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
+	return ret;
 
-	/* INTERRUPT Setup */
-	init_waitqueue_head(&chip->vendor.read_queue);
-	init_waitqueue_head(&chip->vendor.int_queue);
-	if (interrupts && tpm_info->irq != -1) {
-		if (tpm_info->irq) {
-			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
-						 tpm_info->irq);
-			if (!chip->vendor.irq)
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
 out_err:
 	tpm_tis_remove(chip);
-	return rc;
-}
-
-#ifdef CONFIG_PM_SLEEP
-static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
-{
-	u32 intmask;
-
-	/* reenable interrupts that device may have lost or
-	   BIOS/firmware may have disabled */
-	iowrite8(chip->vendor.irq, chip->vendor.iobase +
-		 TPM_INT_VECTOR(chip->vendor.locality));
-
-	intmask =
-	    ioread32(chip->vendor.iobase +
-		     TPM_INT_ENABLE(chip->vendor.locality));
-
-	intmask |= TPM_INTF_CMD_READY_INT
-	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
-	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
-
-	iowrite32(intmask,
-		  chip->vendor.iobase + TPM_INT_ENABLE(chip->vendor.locality));
+	return ret;
 }
 
-static int tpm_tis_resume(struct device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	int ret;
-
-	if (chip->vendor.irq)
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
@@ -919,7 +222,7 @@ static struct pnp_driver tis_pnp_driver = {
 	},
 };
 
-#define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
+#define TIS_HID_USR_IDX (sizeof(tpm_pnp_tbl) / sizeof(struct pnp_device_id) - 2)
 module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
 		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
new file mode 100644
index 0000000..b9cc61f
--- /dev/null
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -0,0 +1,728 @@
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
+
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
+struct tpm_info {
+	struct resource res;
+	/* irq > 0 means: use irq $irq;
+	 * irq = 0 means: autoprobe for an irq;
+	 * irq = -1 means: no irq support
+	 */
+	int irq;
+};
+
+/* Before we attempt to access the TPM we must see that the valid bit is set.
+ * The specification says that this bit is 0 at reset and remains 0 until the
+ * 'TPM has gone through its self test and initialization and has established
+ * correct values in the other bits.'
+ */
+static int wait_startup(struct tpm_chip *chip, int l)
+{
+	unsigned long stop = jiffies + chip->vendor.timeout_a;
+
+	do {
+		if (tpm_read_byte(chip, TPM_ACCESS(l)) & TPM_ACCESS_VALID)
+			return 0;
+		msleep(TPM_TIMEOUT);
+	} while (time_before(jiffies, stop));
+	return -1;
+}
+
+static int check_locality(struct tpm_chip *chip, int l)
+{
+	if ((tpm_read_byte(chip, TPM_ACCESS(l)) &
+	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
+	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
+		return chip->vendor.locality = l;
+
+	return -1;
+}
+
+static void release_locality(struct tpm_chip *chip, int l, int force)
+{
+	if (force || (tpm_read_byte(chip, TPM_ACCESS(l)) &
+		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
+	    (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
+		tpm_write_byte(chip, TPM_ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);
+}
+
+static int request_locality(struct tpm_chip *chip, int l)
+{
+	unsigned long stop, timeout;
+	long rc;
+
+	if (check_locality(chip, l) >= 0)
+		return l;
+
+	tpm_write_byte(chip, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
+
+	stop = jiffies + chip->vendor.timeout_a;
+
+	if (chip->vendor.irq) {
+again:
+		timeout = stop - jiffies;
+		if ((long)timeout <= 0)
+			return -1;
+		rc = wait_event_interruptible_timeout(chip->vendor.int_queue,
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
+u8 tpm_tis_status(struct tpm_chip *chip)
+{
+	return tpm_read_byte(chip, TPM_STS(chip->vendor.locality));
+}
+EXPORT_SYMBOL(tpm_tis_status);
+
+void tpm_tis_ready(struct tpm_chip *chip)
+{
+	/* this causes the current command to be aborted */
+	tpm_write_byte(chip, TPM_STS(chip->vendor.locality),
+		       TPM_STS_COMMAND_READY);
+}
+EXPORT_SYMBOL(tpm_tis_ready);
+
+static int get_burstcount(struct tpm_chip *chip)
+{
+	unsigned long stop;
+	int burstcnt, status;
+	u8 temp;
+
+	/* wait for burstcount */
+	/* which timeout value, spec has 2 answers (c & d) */
+	stop = jiffies + chip->vendor.timeout_d;
+	do {
+		status = tpm_read_bytes(chip, TPM_STS(chip->vendor.locality) +
+					1, 1, &temp);
+		if (status < 0)
+			return -EBUSY;
+
+		burstcnt = temp;
+		status = tpm_read_bytes(chip, TPM_STS(chip->vendor.locality) +
+					2, 1, &temp);
+		if (status < 0)
+			return -EBUSY;
+
+		burstcnt |= temp << 8;
+
+		if (burstcnt)
+			return burstcnt;
+		msleep(TPM_TIMEOUT);
+	} while (time_before(jiffies, stop));
+	return -EBUSY;
+}
+
+static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	int size = 0, burstcnt, transfer_size, ret;
+
+	while (size < count &&
+		wait_for_tpm_stat(chip,
+				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+				 chip->vendor.timeout_c,
+				 &chip->vendor.read_queue, true) == 0) {
+		burstcnt = get_burstcount(chip);
+
+		transfer_size = min_t(size_t, (count - size), burstcnt);
+
+		ret = tpm_read_bytes(chip, TPM_DATA_FIFO(chip->vendor.locality),
+				     transfer_size, &buf[size]);
+		if (ret < 0)
+			return ret;
+
+		size += transfer_size;
+	}
+
+	return size;
+}
+
+int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	int size = 0;
+	int expected, status;
+
+	if (count < TPM_HEADER_SIZE) {
+		size = -EIO;
+		goto out;
+	}
+
+	/* read first 10 bytes, including tag, paramsize, and result */
+	size = recv_data(chip, buf, TPM_HEADER_SIZE);
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
+	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
+			  &chip->vendor.int_queue, false);
+	status = tpm_tis_status(chip);
+	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
+		dev_err(&chip->dev, "Error left over data\n");
+		size = -EIO;
+		goto out;
+	}
+
+out:
+	tpm_tis_ready(chip);
+	release_locality(chip, chip->vendor.locality, 0);
+	return size;
+}
+EXPORT_SYMBOL(tpm_tis_recv);
+
+/*
+ * If interrupts are used (signaled by an irq set in the vendor structure)
+ * tpm.c can skip polling for the data to be available as the interrupt is
+ * waited for here
+ */
+static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	int rc, status, burstcnt, transfer_size;
+	size_t count = 0;
+
+	if (request_locality(chip, 0) < 0)
+		return -EBUSY;
+
+	status = tpm_tis_status(chip);
+	if ((status & TPM_STS_COMMAND_READY) == 0) {
+		tpm_tis_ready(chip);
+		if (wait_for_tpm_stat
+		    (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
+		     &chip->vendor.int_queue, false) < 0) {
+			rc = -ETIME;
+			goto out_err;
+		}
+	}
+
+	while (count < len - 1) {
+		burstcnt = get_burstcount(chip);
+		transfer_size = min_t(size_t, len - count - 1, burstcnt);
+
+		rc = tpm_write_bytes(chip, TPM_DATA_FIFO(chip->vendor.locality),
+				     transfer_size, &buf[count]);
+		if (rc < 0)
+			goto out_err;
+
+		count += transfer_size;
+
+		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
+				  &chip->vendor.int_queue, false);
+		status = tpm_tis_status(chip);
+		if (!chip->vendor.itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
+			rc = -EIO;
+			goto out_err;
+		}
+	}
+
+	/* write last byte */
+	tpm_write_byte(chip, TPM_DATA_FIFO(chip->vendor.locality), buf[count]);
+	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
+			  &chip->vendor.int_queue, false);
+	status = tpm_tis_status(chip);
+	if ((status & TPM_STS_DATA_EXPECT) != 0) {
+		rc = -EIO;
+		goto out_err;
+	}
+
+	return 0;
+
+out_err:
+	tpm_tis_ready(chip);
+	release_locality(chip, chip->vendor.locality, 0);
+	return rc;
+}
+
+static void disable_interrupts(struct tpm_chip *chip)
+{
+	u32 intmask;
+
+	intmask = tpm_read_dword(chip, TPM_INT_ENABLE(chip->vendor.locality));
+	intmask &= ~TPM_GLOBAL_INT_ENABLE;
+	tpm_write_dword(chip, TPM_INT_ENABLE(chip->vendor.locality), intmask);
+	devm_free_irq(&chip->dev, chip->vendor.irq, chip);
+	chip->vendor.irq = 0;
+}
+
+/*
+ * If interrupts are used (signaled by an irq set in the vendor structure)
+ * tpm.c can skip polling for the data to be available as the interrupt is
+ * waited for here
+ */
+static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	int rc;
+	u32 ordinal;
+	unsigned long dur;
+
+	rc = tpm_tis_send_data(chip, buf, len);
+	if (rc < 0)
+		return rc;
+
+	/* go and do it */
+	tpm_write_byte(chip, TPM_STS(chip->vendor.locality), TPM_STS_GO);
+
+	if (chip->vendor.irq) {
+		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+
+		if (chip->flags & TPM_CHIP_FLAG_TPM2)
+			dur = tpm2_calc_ordinal_duration(chip, ordinal);
+		else
+			dur = tpm_calc_ordinal_duration(chip, ordinal);
+
+		if (wait_for_tpm_stat
+		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
+		     &chip->vendor.read_queue, false) < 0) {
+			rc = -ETIME;
+			goto out_err;
+		}
+	}
+	return len;
+out_err:
+	tpm_tis_ready(chip);
+	release_locality(chip, chip->vendor.locality, 0);
+	return rc;
+}
+
+int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	int rc, irq;
+
+	if (!chip->vendor.irq || chip->vendor.irq_tested)
+		return tpm_tis_send_main(chip, buf, len);
+
+	/* Verify receipt of the expected IRQ */
+	irq = chip->vendor.irq;
+	chip->vendor.irq = 0;
+	rc = tpm_tis_send_main(chip, buf, len);
+	chip->vendor.irq = irq;
+	if (!chip->vendor.irq_tested)
+		msleep(1);
+	if (!chip->vendor.irq_tested)
+		disable_interrupts(chip);
+	chip->vendor.irq_tested = true;
+	return rc;
+}
+EXPORT_SYMBOL(tpm_tis_send);
+
+bool tpm_tis_update_timeouts(struct tpm_chip *chip, unsigned long *timeout_cap)
+{
+	int i;
+	u32 did_vid;
+
+	did_vid = tpm_read_dword(chip, TPM_DID_VID(0));
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
+EXPORT_SYMBOL(tpm_tis_update_timeouts);
+
+/*
+ * Early probing for iTPM with STS_DATA_EXPECT flaw.
+ * Try sending command without itpm flag set and if that
+ * fails, repeat with itpm flag set.
+ */
+static int probe_itpm(struct tpm_chip *chip)
+{
+	int rc = 0;
+	u8 cmd_getticks[] = {
+		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
+		0x00, 0x00, 0x00, 0xf1
+	};
+	size_t len = sizeof(cmd_getticks);
+	bool rem_itpm = chip->vendor.itpm;
+	u16 vendor = tpm_read_word(chip, TPM_DID_VID(0));
+
+	/* probe only iTPMS */
+	if (vendor != TPM_VID_INTEL)
+		return 0;
+
+	chip->vendor.itpm = false;
+
+	rc = tpm_tis_send_data(chip, cmd_getticks, len);
+	if (rc == 0)
+		goto out;
+
+	tpm_tis_ready(chip);
+	release_locality(chip, chip->vendor.locality, 0);
+
+	chip->vendor.itpm = true;
+
+	rc = tpm_tis_send_data(chip, cmd_getticks, len);
+	if (rc == 0) {
+		dev_info(&chip->dev, "Detected an iTPM.\n");
+		rc = 1;
+	} else {
+		rc = -EFAULT;
+	}
+
+out:
+	chip->vendor.itpm = rem_itpm;
+	tpm_tis_ready(chip);
+	release_locality(chip, chip->vendor.locality, 0);
+
+	return rc;
+}
+
+bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
+{
+	switch (chip->vendor.manufacturer_id) {
+	case TPM_VID_WINBOND:
+		return ((status == TPM_STS_VALID) ||
+			(status == (TPM_STS_VALID | TPM_STS_COMMAND_READY)));
+	case TPM_VID_STM:
+		return (status == (TPM_STS_VALID | TPM_STS_COMMAND_READY));
+	default:
+		return (status == TPM_STS_COMMAND_READY);
+	}
+}
+EXPORT_SYMBOL(tpm_tis_req_canceled);
+
+static irqreturn_t tis_int_handler(int dummy, void *dev_id)
+{
+	struct tpm_chip *chip = dev_id;
+	u32 interrupt;
+	int i;
+
+	interrupt = tpm_read_dword(chip, TPM_INT_STATUS(chip->vendor.locality));
+
+	if (interrupt == 0)
+		return IRQ_NONE;
+
+	chip->vendor.irq_tested = true;
+	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
+		wake_up_interruptible(&chip->vendor.read_queue);
+	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
+		for (i = 0; i < 5; i++)
+			if (check_locality(chip, i) >= 0)
+				break;
+	if (interrupt &
+	    (TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_STS_VALID_INT |
+	     TPM_INTF_CMD_READY_INT))
+		wake_up_interruptible(&chip->vendor.int_queue);
+
+	/* Clear interrupts handled with TPM_EOI */
+	tpm_write_dword(chip, TPM_INT_STATUS(chip->vendor.locality), interrupt);
+	tpm_read_dword(chip, TPM_INT_STATUS(chip->vendor.locality));
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
+	u8 original_int_vec;
+
+	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
+			     dev_name(&chip->dev), chip) != 0) {
+		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
+			 irq);
+		return -1;
+	}
+	chip->vendor.irq = irq;
+
+	original_int_vec = tpm_read_byte(chip, TPM_INT_VECTOR(chip->vendor.locality));
+	tpm_write_byte(chip, TPM_INT_VECTOR(chip->vendor.locality), irq);
+
+	/* Clear all existing */
+	tpm_write_dword(chip, TPM_INT_STATUS(chip->vendor.locality),
+			tpm_read_dword(chip, TPM_INT_STATUS(chip->vendor.locality)));
+
+	/* Turn on */
+	tpm_write_dword(chip, TPM_INT_ENABLE(chip->vendor.locality),
+			intmask | TPM_GLOBAL_INT_ENABLE);
+
+	chip->vendor.irq_tested = false;
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
+	if (!chip->vendor.irq) {
+		tpm_write_byte(chip, TPM_INT_VECTOR(chip->vendor.locality),
+			       original_int_vec);
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
+	u8 original_int_vec;
+	int i;
+
+	original_int_vec = tpm_read_byte(chip,
+					 TPM_INT_VECTOR(chip->vendor.locality));
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
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_shutdown(chip, TPM2_SU_CLEAR);
+
+	tpm_write_dword(chip, TPM_INT_ENABLE(chip->vendor.locality),
+			~TPM_GLOBAL_INT_ENABLE &
+			tpm_read_dword(chip,
+				       TPM_INT_ENABLE(chip->vendor.locality)));
+	release_locality(chip, chip->vendor.locality, 1);
+}
+EXPORT_SYMBOL(tpm_tis_remove);
+
+int tpm_tis_init_core(struct device *dev, struct tpm_chip *chip,
+		      int irq, int irq_flags)
+{
+	u32 vendor, intfcaps, intmask;
+	int rc, probe;
+
+	/* Maximum timeouts */
+	chip->vendor.timeout_a = TIS_TIMEOUT_A_MAX;
+	chip->vendor.timeout_b = TIS_TIMEOUT_B_MAX;
+	chip->vendor.timeout_c = TIS_TIMEOUT_C_MAX;
+	chip->vendor.timeout_d = TIS_TIMEOUT_D_MAX;
+
+	if (wait_startup(chip, 0) != 0) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	/* Take control of the TPM's interrupt hardware and shut it off */
+	intmask = tpm_read_dword(chip, TPM_INT_ENABLE(chip->vendor.locality));
+	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
+		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
+	intmask &= ~TPM_GLOBAL_INT_ENABLE;
+	tpm_write_dword(chip, TPM_INT_ENABLE(chip->vendor.locality), intmask);
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
+	vendor = tpm_read_dword(chip, TPM_DID_VID(0));
+	chip->vendor.manufacturer_id = vendor;
+
+	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
+		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
+		 vendor >> 16, tpm_read_byte(chip, TPM_RID(0)));
+
+	if (!chip->vendor.itpm) {
+		probe = probe_itpm(chip);
+		if (probe < 0) {
+			rc = -ENODEV;
+			goto out_err;
+		}
+		chip->vendor.itpm = !!probe;
+	}
+
+	if (chip->vendor.itpm)
+		dev_info(dev, "Intel iTPM workaround enabled\n");
+
+	/* Figure out the capabilities */
+	intfcaps = tpm_read_dword(chip, TPM_INTF_CAPS(chip->vendor.locality));
+	dev_dbg(dev, "TPM interface capabilities (0x%x):\n", intfcaps);
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
+	init_waitqueue_head(&chip->vendor.read_queue);
+	init_waitqueue_head(&chip->vendor.int_queue);
+	if (irq > 0) {
+		tpm_tis_probe_irq_single(chip, intmask, irq_flags, irq);
+		if (!chip->vendor.irq)
+			dev_err(&chip->dev, FW_BUG
+				"TPM interrupt not working, polling instead\n");
+	} else if (irq != -1) {
+		tpm_tis_probe_irq(chip, intmask);
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
+
+out_err:
+	return rc;
+}
+EXPORT_SYMBOL(tpm_tis_init_core);
+
+#ifdef CONFIG_PM_SLEEP
+static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
+{
+	u32 intmask;
+
+	/* reenable interrupts that device may have lost or
+	 * BIOS/firmware may have disabled
+	 */
+	tpm_write_byte(chip, TPM_INT_VECTOR(chip->vendor.locality), chip->vendor.irq);
+
+
+	intmask = tpm_read_dword(chip, TPM_INT_ENABLE(chip->vendor.locality));
+
+	intmask |= TPM_INTF_CMD_READY_INT
+	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
+	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
+
+	tpm_write_dword(chip, TPM_INT_ENABLE(chip->vendor.locality), intmask);
+}
+
+int tpm_tis_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	int ret;
+
+	if (chip->vendor.irq)
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
+EXPORT_SYMBOL(tpm_tis_resume);
+#endif
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
new file mode 100644
index 0000000..2e2d188
--- /dev/null
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -0,0 +1,166 @@
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
+
+#ifndef __TPM_TIS_CORE_H
+#define __TPM_TIS_CORE_H
+
+#include "tpm.h"
+
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
+	TPM_STS_RESPONSE_RETRY = 0x02,
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
+	TIS_MEM_BASE = 0xFED40000,
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
+struct tis_vendor_timeout_override {
+	u32 did_vid;
+	unsigned long timeout_us[4];
+};
+
+static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
+	/* Atmel 3204 */
+	{ 0x32041114, { (TIS_SHORT_TIMEOUT * 1000), (TIS_LONG_TIMEOUT * 1000),
+			(TIS_SHORT_TIMEOUT * 1000), (TIS_SHORT_TIMEOUT * 1000) } },
+};
+
+u8 tpm_tis_status(struct tpm_chip *chip);
+void tpm_tis_ready(struct tpm_chip *chip);
+int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count);
+int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len);
+bool tpm_tis_update_timeouts(struct tpm_chip *chip,
+				    unsigned long *timeout_cap);
+bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status);
+int tpm_tis_resume(struct device *dev);
+void tpm_tis_remove(struct tpm_chip *chip);
+
+/* Helpers - read */
+static inline int tpm_read_bytes(struct tpm_chip *chip, u32 addr,
+				 size_t len, u8 *res)
+{
+	return chip->ops->read_bytes(chip, addr, len, 1, res);
+}
+static inline u8 tpm_read_byte(struct tpm_chip *chip, u32 addr)
+{
+	u8 res;
+
+	chip->ops->read_bytes(chip, addr, 1, sizeof(u8), &res);
+
+	return res;
+}
+
+static inline u16 tpm_read_word(struct tpm_chip *chip, u32 addr)
+{
+	u16 res;
+
+	chip->ops->read_bytes(chip, addr, 1, sizeof(u16), (u8 *)&res);
+	return res;
+}
+
+static inline u32 tpm_read_dword(struct tpm_chip *chip, u32 addr)
+{
+	u32 res;
+
+	chip->ops->read_bytes(chip, addr, 1, sizeof(u32), (u8 *)&res);
+	return res;
+}
+
+/* Helpers - write */
+static inline int tpm_write_bytes(struct tpm_chip *chip, u32 addr,
+				  size_t len, u8 *value)
+{
+	return chip->ops->write_bytes(chip, addr, 1, len, value);
+}
+
+static inline int tpm_write_byte(struct tpm_chip *chip, u32 addr, u8 value)
+{
+	u8 tmp = value;
+
+	return chip->ops->write_bytes(chip, addr, 1, sizeof(u8), &tmp);
+}
+
+static inline int tpm_write_word(struct tpm_chip *chip, u32 addr, u16 value)
+{
+	u32 tmp = value;
+
+	return chip->ops->write_bytes(chip, addr, 1, sizeof(u16), (u8 *)&tmp);
+}
+
+static inline int tpm_write_dword(struct tpm_chip *chip, u32 addr, u32 value)
+{
+	u32 tmp = value;
+
+	return chip->ops->write_bytes(chip, addr, 1, sizeof(u32), (u8 *)&tmp);
+}
+
+int tpm_tis_init_core(struct device *dev, struct tpm_chip *chip,
+		      int irq, int irq_flags);
+#endif
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 706e63e..f78e4fc 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -44,6 +44,10 @@ struct tpm_class_ops {
 	bool (*update_timeouts)(struct tpm_chip *chip,
 				unsigned long *timeout_cap);
 
+	int (*read_bytes)(struct tpm_chip *chip, u32 addr, size_t len,
+			  u8 size, u8 *dst);
+	int (*write_bytes)(struct tpm_chip *chip, u32 addr, size_t len,
+			   u8 size, u8 *src);
 };
 
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
-- 
2.5.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785231&iu=/4140
