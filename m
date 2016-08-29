From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: fix sparse errors caused by tpm enum
	tpm_capabilities
Date: Tue, 30 Aug 2016 02:50:49 +0300
Message-ID: <1472514650-28053-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The enum tpm_capabilites is not a legit constant expression but calls
cpu_to_be32. This commit makes cap_id a separate parameter in order to
provide less confusing API and declares the type as u32. The byter order
conversion is handled internally by tpm1_getcap_cmd.

$ make C=2  M=drivers/char/tpm
  CHECK   drivers/char/tpm/tpm-interface.c
drivers/char/tpm/tpm.h:285:24: error: bad constant expression
drivers/char/tpm/tpm.h:286:24: error: bad constant expression
drivers/char/tpm/tpm.h:287:27: error: bad constant expression
drivers/char/tpm/tpm.h:288:27: error: bad constant expression
drivers/char/tpm/tpm.h:292:28: error: bad constant expression
drivers/char/tpm/tpm.h:293:37: error: bad constant expression
drivers/char/tpm/tpm.h:294:29: error: bad constant expression
drivers/char/tpm/tpm.h:295:28: error: bad constant expression
drivers/char/tpm/tpm.h:296:30: error: bad constant expression
drivers/char/tpm/tpm.h:297:36: error: bad constant expression
drivers/char/tpm/tpm.h:298:37: error: bad constant expression
drivers/char/tpm/tpm-interface.c:444:23: error: incompatible types for operation (==)
drivers/char/tpm/tpm-interface.c:444:23:    left side has type unsigned int [unsigned] [usertype] subcap_id
drivers/char/tpm/tpm-interface.c:444:23:    right side has type bad type
drivers/char/tpm/tpm-interface.c:444:55: error: incompatible types for operation (==)
drivers/char/tpm/tpm-interface.c:444:55:    left side has type unsigned int [unsigned] [usertype] subcap_id
drivers/char/tpm/tpm-interface.c:444:55:    right side has type bad type
drivers/char/tpm/tpm-interface.c:450:31: error: incompatible types for operation (==)
drivers/char/tpm/tpm-interface.c:450:31:    left side has type unsigned int [unsigned] [usertype] subcap_id
drivers/char/tpm/tpm-interface.c:450:31:    right side has type bad type
drivers/char/tpm/tpm-interface.c:451:31: error: incompatible types for operation (==)
drivers/char/tpm/tpm-interface.c:451:31:    left side has type unsigned int [unsigned] [usertype] subcap_id
drivers/char/tpm/tpm-interface.c:451:31:    right side has type bad type

After applying this fix:

$ make C=2  M=drivers/char/tpm
  CHECK   drivers/char/tpm/tpm-interface.c
  drivers/char/tpm/tpm.h:292:28: error: bad constant expression
  drivers/char/tpm/tpm.h:293:37: error: bad constant expression
  drivers/char/tpm/tpm.h:294:29: error: bad constant expression
  drivers/char/tpm/tpm.h:295:28: error: bad constant expression
  drivers/char/tpm/tpm.h:296:30: error: bad constant expression
  drivers/char/tpm/tpm.h:297:36: error: bad constant expression
  drivers/char/tpm/tpm.h:298:37: error: bad constant expression

The remaining errors are caused by tpm_sub_capabilities.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 56 +++++++++++++++++-----------------------
 drivers/char/tpm/tpm-sysfs.c     | 36 ++++++++++++++------------
 drivers/char/tpm/tpm.h           | 14 +++++-----
 drivers/char/tpm/tpm_tis_core.c  |  3 ++-
 4 files changed, 53 insertions(+), 56 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 3edf2e8..332c3b0 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -434,34 +434,40 @@ static const struct tpm_input_header tpm_getcap_header = {
 	.ordinal = TPM_ORD_GET_CAP
 };
 
-ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
-		   const char *desc)
+/**
+ * tpm1_getcap_cmd() - execute a TPM 1.x TPM_GetCapability command
+ * @chip: TPM chip to use
+ * @cap_id: capability
+ * @subcap_id: subcapability
+ * @desc: same as with tpm_transmit_cmd
+ *
+ * Return: same as with tpm_transmit_cmd
+ */
+ssize_t tpm1_getcap_cmd(struct tpm_chip *chip, u32 cap_id, u32 subcap_id,
+			cap_t *cap, const char *desc)
 {
 	struct tpm_cmd_t tpm_cmd;
 	int rc;
 
 	tpm_cmd.header.in = tpm_getcap_header;
-	if (subcap_id == CAP_VERSION_1_1 || subcap_id == CAP_VERSION_1_2) {
-		tpm_cmd.params.getcap_in.cap = subcap_id;
-		/*subcap field not necessary */
+	if (cap_id == TPM1_CAP_VERSION_1_1 ||
+	    cap_id == TPM1_CAP_VERSION_1_2) {
+		tpm_cmd.params.getcap_in.cap = cpu_to_be32(cap_id);
+		/* subcap field not necessary */
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(0);
 		tpm_cmd.header.in.length -= cpu_to_be32(sizeof(__be32));
 	} else {
-		if (subcap_id == TPM_CAP_FLAG_PERM ||
-		    subcap_id == TPM_CAP_FLAG_VOL)
-			tpm_cmd.params.getcap_in.cap = TPM_CAP_FLAG;
-		else
-			tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+		tpm_cmd.params.getcap_in.cap = cpu_to_be32(cap_id);
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = subcap_id;
 	}
 	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
 			      desc);
-	if (!rc)
+	if (!rc && cap)
 		*cap = tpm_cmd.params.getcap_out.cap;
 	return rc;
 }
-EXPORT_SYMBOL_GPL(tpm_getcap);
+EXPORT_SYMBOL_GPL(tpm1_getcap_cmd);
 
 #define TPM_ORD_STARTUP cpu_to_be32(153)
 #define TPM_ST_CLEAR cpu_to_be16(1)
@@ -506,13 +512,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		return 0;
 	}
 
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
-			      NULL);
-
+	rc = tpm1_getcap_cmd(chip, TPM1_CAP_PROP, TPM_CAP_PROP_TIS_TIMEOUT,
+			     NULL, NULL);
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
 		   Execute a startup command. */
@@ -520,12 +521,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		if (tpm_startup(chip, TPM_ST_CLEAR))
 			return rc;
 
-		tpm_cmd.header.in = tpm_getcap_header;
-		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-				      0, NULL);
+		rc = tpm1_getcap_cmd(chip, TPM1_CAP_PROP,
+				     TPM_CAP_PROP_TIS_TIMEOUT, NULL, NULL);
 	}
 	if (rc) {
 		dev_err(&chip->dev,
@@ -581,13 +578,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	chip->timeout_d = usecs_to_jiffies(new_timeout[3]);
 
 duration:
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
-
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
-			      "attempting to determine the durations");
+	rc = tpm1_getcap_cmd(chip, TPM1_CAP_PROP, TPM_CAP_PROP_TIS_TIMEOUT,
+			     NULL, "attempting to determine the durations");
 	if (rc)
 		return rc;
 
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index e1f7236..19b1e05 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -94,8 +94,8 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 	char *str = buf;
 	struct tpm_chip *chip = to_tpm_chip(dev);
 
-	rc = tpm_getcap(chip, TPM_CAP_PROP_PCR, &cap,
-			"attempting to determine the number of PCRS");
+	rc = tpm1_getcap_cmd(chip, TPM1_CAP_PROP, TPM_CAP_PROP_PCR, &cap,
+			     "attempting to determine the number of PCRS");
 	if (rc)
 		return 0;
 
@@ -119,8 +119,9 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
 	cap_t cap;
 	ssize_t rc;
 
-	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
-			"attempting to determine the permanent enabled state");
+	rc = tpm1_getcap_cmd(to_tpm_chip(dev), TPM1_CAP_FLAG, TPM_CAP_FLAG_PERM,
+			     &cap,
+			     "attempting to determine the permanent enabled state");
 	if (rc)
 		return 0;
 
@@ -135,8 +136,9 @@ static ssize_t active_show(struct device *dev, struct device_attribute *attr,
 	cap_t cap;
 	ssize_t rc;
 
-	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
-			"attempting to determine the permanent active state");
+	rc = tpm1_getcap_cmd(to_tpm_chip(dev), TPM1_CAP_FLAG, TPM_CAP_FLAG_PERM,
+			     &cap,
+			     "attempting to determine the permanent active state");
 	if (rc)
 		return 0;
 
@@ -151,8 +153,9 @@ static ssize_t owned_show(struct device *dev, struct device_attribute *attr,
 	cap_t cap;
 	ssize_t rc;
 
-	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_PROP_OWNER, &cap,
-			"attempting to determine the owner state");
+	rc = tpm1_getcap_cmd(to_tpm_chip(dev), TPM1_CAP_PROP,
+			     TPM_CAP_PROP_OWNER, &cap,
+			     "attempting to determine the owner state");
 	if (rc)
 		return 0;
 
@@ -167,8 +170,9 @@ static ssize_t temp_deactivated_show(struct device *dev,
 	cap_t cap;
 	ssize_t rc;
 
-	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_VOL, &cap,
-			"attempting to determine the temporary state");
+	rc = tpm1_getcap_cmd(to_tpm_chip(dev), TPM1_CAP_FLAG, TPM_CAP_FLAG_VOL,
+			     &cap,
+			     "attempting to determine the temporary state");
 	if (rc)
 		return 0;
 
@@ -185,16 +189,16 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 	char *str = buf;
 
-	rc = tpm_getcap(chip, TPM_CAP_PROP_MANUFACTURER, &cap,
-			"attempting to determine the manufacturer");
+	rc = tpm1_getcap_cmd(chip, TPM1_CAP_PROP, TPM_CAP_PROP_MANUFACTURER,
+			     &cap, "attempting to determine the manufacturer");
 	if (rc)
 		return 0;
 	str += sprintf(str, "Manufacturer: 0x%x\n",
 		       be32_to_cpu(cap.manufacturer_id));
 
 	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
-	rc = tpm_getcap(chip, CAP_VERSION_1_2, &cap,
-			"attempting to determine the 1.2 version");
+	rc = tpm1_getcap_cmd(chip, TPM1_CAP_VERSION_1_2, 0, &cap,
+			     "attempting to determine the 1.2 version");
 	if (!rc) {
 		str += sprintf(str,
 			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
@@ -204,8 +208,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 			       cap.tpm_version_1_2.revMinor);
 	} else {
 		/* Otherwise just use TPM_STRUCT_VER */
-		rc = tpm_getcap(chip, CAP_VERSION_1_1, &cap,
-				"attempting to determine the 1.1 version");
+		rc = tpm1_getcap_cmd(chip, TPM1_CAP_VERSION_1_1, 0, &cap,
+				     "attempting to determine the 1.1 version");
 		if (rc)
 			return 0;
 		str += sprintf(str,
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 1d1361a..6a6241a 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -281,11 +281,11 @@ typedef union {
 	struct duration_t duration;
 } cap_t;
 
-enum tpm_capabilities {
-	TPM_CAP_FLAG = cpu_to_be32(4),
-	TPM_CAP_PROP = cpu_to_be32(5),
-	CAP_VERSION_1_1 = cpu_to_be32(0x06),
-	CAP_VERSION_1_2 = cpu_to_be32(0x1A)
+enum tpm1_capabilities {
+	TPM1_CAP_FLAG		= 0x04,
+	TPM1_CAP_PROP		= 0x05,
+	TPM1_CAP_VERSION_1_1	= 0x06,
+	TPM1_CAP_VERSION_1_2	= 0x1A,
 };
 
 enum tpm_sub_capabilities {
@@ -484,8 +484,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 		     unsigned int flags);
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, int len,
 			 unsigned int flags, const char *desc);
-ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
-		   const char *desc);
+ssize_t tpm1_getcap_cmd(struct tpm_chip *chip, u32 cap_id, __be32 subcap_id,
+			cap_t *cap, const char *desc);
 int tpm_get_timeouts(struct tpm_chip *chip);
 int tpm1_auto_startup(struct tpm_chip *chip);
 int tpm_do_selftest(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index f22caf8..a110ad3 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -535,7 +535,8 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
 	else
-		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
+		return tpm1_getcap_cmd(chip, TPM1_CAP_PROP,
+				       TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
 }
 
 /* Register the IRQ and issue a command that will cause an interrupt. If an
-- 
2.7.4


------------------------------------------------------------------------------
