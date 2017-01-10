From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 08/10] tpm: tpm_getcap: check size of response
	before accessing data
Date: Tue, 10 Jan 2017 09:18:18 -0500
Message-ID: <1484057900-17871-8-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1484057900-17871-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Check the size of the response before accessing data in the
response packet. This is to avoid accessing data beyond the
end of the response.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 14 ++++++++++----
 drivers/char/tpm/tpm-sysfs.c     | 24 ++++++++++++++++--------
 drivers/char/tpm/tpm.h           |  2 +-
 drivers/char/tpm/tpm_tis_core.c  |  3 ++-
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 9d6f894..f80df9c 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -470,7 +470,7 @@ static const struct tpm_input_header tpm_getcap_header = {
 };
 
 ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
-		   const char *desc)
+		   const char *desc, size_t exp_rlength)
 {
 	struct tpm_cmd_t tpm_cmd;
 	int rc;
@@ -495,6 +495,9 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 	}
 	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
 			      desc);
+	if (!rc && be32_to_cpu(tpm_cmd.header.out.length) < exp_rlength)
+		return -EFAULT;
+
 	if (!rc)
 		*cap = tpm_cmd.params.getcap_out.cap;
 	return rc;
@@ -548,7 +551,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		return 0;
 	}
 
-	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL);
+	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL,
+	                TPM_HEADER_SIZE + sizeof(cap.timeout));
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
 		   Execute a startup command. */
@@ -557,7 +561,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 			return rc;
 
 		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
-				"attempting to determine the timeouts");
+				"attempting to determine the timeouts",
+				TPM_HEADER_SIZE + sizeof(cap.timeout));
 	}
 	if (rc) {
 		dev_err(&chip->dev,
@@ -608,7 +613,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	chip->timeout_d = usecs_to_jiffies(new_timeout[3]);
 
 	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_DURATION, &cap,
-			"attempting to determine the durations");
+			"attempting to determine the durations",
+			TPM_HEAER_SIZE + sizeof(cap.duration));
 	if (rc)
 		return rc;
 
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 848ad65..73d110d 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -95,7 +95,8 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	rc = tpm_getcap(chip, TPM_CAP_PROP_PCR, &cap,
-			"attempting to determine the number of PCRS");
+			"attempting to determine the number of PCRS",
+			TPM_HEADER_SIZE + sizeof(cap.num_pcrs));
 	if (rc)
 		return 0;
 
@@ -120,7 +121,8 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 
 	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
-			"attempting to determine the permanent enabled state");
+			"attempting to determine the permanent enabled state",
+			TPM_HEADER_SIZE + sizeof(cap.perm_flags));
 	if (rc)
 		return 0;
 
@@ -136,7 +138,8 @@ static ssize_t active_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 
 	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
-			"attempting to determine the permanent active state");
+			"attempting to determine the permanent active state",
+			TPM_HEADER_SIZE + sizeof(cap.perm_flags));
 	if (rc)
 		return 0;
 
@@ -152,7 +155,8 @@ static ssize_t owned_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 
 	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_PROP_OWNER, &cap,
-			"attempting to determine the owner state");
+			"attempting to determine the owner state",
+			TPM_HEADER_SIZE + sizeof(cap.owned));
 	if (rc)
 		return 0;
 
@@ -168,7 +172,8 @@ static ssize_t temp_deactivated_show(struct device *dev,
 	ssize_t rc;
 
 	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_VOL, &cap,
-			"attempting to determine the temporary state");
+			"attempting to determine the temporary state",
+			TPM_HEADER_SIZE + sizeof(cap.stclear_flags));
 	if (rc)
 		return 0;
 
@@ -186,7 +191,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 	char *str = buf;
 
 	rc = tpm_getcap(chip, TPM_CAP_PROP_MANUFACTURER, &cap,
-			"attempting to determine the manufacturer");
+			"attempting to determine the manufacturer",
+			TPM_HEADER_SIZE + sizeof(cap.manufacturer_id));
 	if (rc)
 		return 0;
 	str += sprintf(str, "Manufacturer: 0x%x\n",
@@ -194,7 +200,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 
 	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
 	rc = tpm_getcap(chip, TPM_CAP_VERSION_1_2, &cap,
-			"attempting to determine the 1.2 version");
+			"attempting to determine the 1.2 version",
+			TPM_HEADER_SIZE + sizeof(cap.tpm_version_1_2));
 	if (!rc) {
 		str += sprintf(str,
 			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
@@ -205,7 +212,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 	} else {
 		/* Otherwise just use TPM_STRUCT_VER */
 		rc = tpm_getcap(chip, TPM_CAP_VERSION_1_1, &cap,
-				"attempting to determine the 1.1 version");
+				"attempting to determine the 1.1 version",
+				TPM_HEADER_SIZE + sizeof(cap.tpm_version));
 		if (rc)
 			return 0;
 		str += sprintf(str,
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 1ae9768..8d223bb 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -496,7 +496,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, int len,
 			 unsigned int flags, const char *desc);
 ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
-		   const char *desc);
+		   const char *desc, size_t exp_rlength);
 int tpm_get_timeouts(struct tpm_chip *);
 int tpm1_auto_startup(struct tpm_chip *chip);
 int tpm_do_selftest(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 7993678..5ce2316 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -552,7 +552,8 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
 	else
-		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
+		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc,
+		                  TPM_HEADER_SIZE + sizeof(cap.timeout));
 }
 
 /* Register the IRQ and issue a command that will cause an interrupt. If an
-- 
2.4.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
