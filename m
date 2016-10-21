From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: sanitize constant expressions
Date: Sat, 22 Oct 2016 00:39:27 +0300
Message-ID: <20161021213928.14810-1-jarkko.sakkinen@linux.intel.com>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Use cpu_to_b32 at the time it is needed in enum tpm_capabilities and
enum tpm_sub_capabilities in order to be consistent with the other
enums in drivats/char/tpm/tpm.h.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
v2: parameter type of subcap_id to u32
 drivers/char/tpm/tpm-interface.c | 15 +++++++++------
 drivers/char/tpm/tpm-sysfs.c     |  4 ++--
 drivers/char/tpm/tpm.h           | 25 ++++++++++++-------------
 3 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index acf89e8..fa97520 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -442,26 +442,29 @@ static const struct tpm_input_header tpm_getcap_header = {
 	.ordinal = TPM_ORD_GET_CAP
 };
 
-ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
+ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		   const char *desc)
 {
 	struct tpm_cmd_t tpm_cmd;
 	int rc;
 
 	tpm_cmd.header.in = tpm_getcap_header;
-	if (subcap_id == CAP_VERSION_1_1 || subcap_id == CAP_VERSION_1_2) {
-		tpm_cmd.params.getcap_in.cap = subcap_id;
+	if (subcap_id == TPM_CAP_VERSION_1_1 ||
+	    subcap_id == TPM_CAP_VERSION_1_2) {
+		tpm_cmd.params.getcap_in.cap = cpu_to_be32(subcap_id);
 		/*subcap field not necessary */
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(0);
 		tpm_cmd.header.in.length -= cpu_to_be32(sizeof(__be32));
 	} else {
 		if (subcap_id == TPM_CAP_FLAG_PERM ||
 		    subcap_id == TPM_CAP_FLAG_VOL)
-			tpm_cmd.params.getcap_in.cap = TPM_CAP_FLAG;
+			tpm_cmd.params.getcap_in.cap =
+				cpu_to_be32(TPM_CAP_FLAG);
 		else
-			tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+			tpm_cmd.params.getcap_in.cap =
+				cpu_to_be32(TPM_CAP_PROP);
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-		tpm_cmd.params.getcap_in.subcap = subcap_id;
+		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
 	}
 	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
 			      desc);
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index a76ab4a..59a1ead 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -193,7 +193,7 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 		       be32_to_cpu(cap.manufacturer_id));
 
 	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
-	rc = tpm_getcap(chip, CAP_VERSION_1_2, &cap,
+	rc = tpm_getcap(chip, TPM_CAP_VERSION_1_2, &cap,
 			"attempting to determine the 1.2 version");
 	if (!rc) {
 		str += sprintf(str,
@@ -204,7 +204,7 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 			       cap.tpm_version_1_2.revMinor);
 	} else {
 		/* Otherwise just use TPM_STRUCT_VER */
-		rc = tpm_getcap(chip, CAP_VERSION_1_1, &cap,
+		rc = tpm_getcap(chip, TPM_CAP_VERSION_1_1, &cap,
 				"attempting to determine the 1.1 version");
 		if (rc)
 			return 0;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4d183c9..1864932 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -282,21 +282,20 @@ typedef union {
 } cap_t;
 
 enum tpm_capabilities {
-	TPM_CAP_FLAG = cpu_to_be32(4),
-	TPM_CAP_PROP = cpu_to_be32(5),
-	CAP_VERSION_1_1 = cpu_to_be32(0x06),
-	CAP_VERSION_1_2 = cpu_to_be32(0x1A)
+	TPM_CAP_FLAG = 4,
+	TPM_CAP_PROP = 5,
+	TPM_CAP_VERSION_1_1 = 0x06,
+	TPM_CAP_VERSION_1_2 = 0x1A,
 };
 
 enum tpm_sub_capabilities {
-	TPM_CAP_PROP_PCR = cpu_to_be32(0x101),
-	TPM_CAP_PROP_MANUFACTURER = cpu_to_be32(0x103),
-	TPM_CAP_FLAG_PERM = cpu_to_be32(0x108),
-	TPM_CAP_FLAG_VOL = cpu_to_be32(0x109),
-	TPM_CAP_PROP_OWNER = cpu_to_be32(0x111),
-	TPM_CAP_PROP_TIS_TIMEOUT = cpu_to_be32(0x115),
-	TPM_CAP_PROP_TIS_DURATION = cpu_to_be32(0x120),
-
+	TPM_CAP_PROP_PCR = 0x101,
+	TPM_CAP_PROP_MANUFACTURER = 0x103,
+	TPM_CAP_FLAG_PERM = 0x108,
+	TPM_CAP_FLAG_VOL = 0x109,
+	TPM_CAP_PROP_OWNER = 0x111,
+	TPM_CAP_PROP_TIS_TIMEOUT = 0x115,
+	TPM_CAP_PROP_TIS_DURATION = 0x120,
 };
 
 struct	tpm_getcap_params_in {
@@ -484,7 +483,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 		     unsigned int flags);
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, int len,
 			 unsigned int flags, const char *desc);
-ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
+ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		   const char *desc);
 int tpm_get_timeouts(struct tpm_chip *);
 int tpm1_auto_startup(struct tpm_chip *chip);
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
