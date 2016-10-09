From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RFC 2/2] tpm: refactor tpm2_get_tpm_pt to
	tpm2_getcap_cmd
Date: Sun,  9 Oct 2016 13:14:16 +0300
Message-ID: <1476008057-2395-3-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1476008057-2395-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1476008057-2395-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Refactored tpm2_get_tpm_pt to tpm2_getcap_cmd, which means that it also
takes capability ID as input. This is required to access
TPM_CAP_HANDLES, which contains metadata needed for swapping transient
data.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm.h          |  6 +++-
 drivers/char/tpm/tpm2-cmd.c     | 64 ++++++++++++++++++++---------------------
 drivers/char/tpm/tpm_tis_core.c |  3 +-
 3 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 0fab6d5..8176f42 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -85,6 +85,10 @@ enum tpm2_capabilities {
 	TPM2_CAP_TPM_PROPERTIES = 6,
 };
 
+enum tpm2_properties {
+	TPM2_PT_FAMILY_INDICATOR	= 0x100,
+};
+
 enum tpm2_startup_types {
 	TPM2_SU_CLEAR	= 0x0000,
 	TPM2_SU_STATE	= 0x0001,
@@ -485,7 +489,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 int tpm2_unseal_trusted(struct tpm_chip *chip,
 			struct trusted_key_payload *payload,
 			struct trusted_key_options *options);
-ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
+ssize_t tpm2_getcap_cmd(struct tpm_chip *chip, u32 cap_id, u32 property_id,
 			u32 *value, const char *desc);
 
 int tpm2_auto_startup(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 2900e18..fcf3d86 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -111,13 +111,13 @@ struct tpm2_pcr_extend_in {
 	u8				digest[TPM_DIGEST_SIZE];
 } __packed;
 
-struct tpm2_get_tpm_pt_in {
+struct tpm2_getcap_in {
 	__be32	cap_id;
 	__be32	property_id;
 	__be32	property_cnt;
 } __packed;
 
-struct tpm2_get_tpm_pt_out {
+struct tpm2_getcap_out {
 	u8	more_data;
 	__be32	subcap_id;
 	__be32	property_cnt;
@@ -140,8 +140,8 @@ union tpm2_cmd_params {
 	struct	tpm2_pcr_read_in	pcrread_in;
 	struct	tpm2_pcr_read_out	pcrread_out;
 	struct	tpm2_pcr_extend_in	pcrextend_in;
-	struct	tpm2_get_tpm_pt_in	get_tpm_pt_in;
-	struct	tpm2_get_tpm_pt_out	get_tpm_pt_out;
+	struct	tpm2_getcap_in		getcap_in;
+	struct	tpm2_getcap_out		getcap_out;
 	struct	tpm2_get_random_in	getrandom_in;
 	struct	tpm2_get_random_out	getrandom_out;
 };
@@ -435,16 +435,6 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 	return total ? total : -EIO;
 }
 
-#define TPM2_GET_TPM_PT_IN_SIZE \
-	(sizeof(struct tpm_input_header) + \
-	 sizeof(struct tpm2_get_tpm_pt_in))
-
-static const struct tpm_input_header tpm2_get_tpm_pt_header = {
-	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
-	.length = cpu_to_be32(TPM2_GET_TPM_PT_IN_SIZE),
-	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
-};
-
 /**
  * Append TPMS_AUTH_COMMAND to the buffer. The buffer must be allocated with
  * tpm_buf_alloc().
@@ -750,35 +740,43 @@ out:
 	return rc;
 }
 
+#define TPM2_GETCAP_IN_SIZE \
+	(sizeof(struct tpm_input_header) + sizeof(struct tpm2_getcap_in))
+
+static const struct tpm_input_header tpm2_getcap_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(TPM2_GETCAP_IN_SIZE),
+	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
+};
+
 /**
- * tpm2_get_tpm_pt() - get value of a TPM_CAP_TPM_PROPERTIES type property
- * @chip:		TPM chip to use.
- * @property_id:	property ID.
- * @value:		output variable.
+ * tpm2_getcap_cmd() - execute a TPM2_GetCapability command
+ * @chip:		TPM chip to use
+ * @cap_id:		capability ID
+ * @property_id:	property ID
+ * @value:		value of the property
  * @desc:		passed to tpm_transmit_cmd()
  *
- * 0 is returned when the operation is successful. If a negative number is
- * returned it remarks a POSIX error code. If a positive number is returned
- * it remarks a TPM error.
+ * Return: same as with tpm_transmit_cmd
  */
-ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
-			const char *desc)
+ssize_t tpm2_getcap_cmd(struct tpm_chip *chip, u32 cap_id, u32 property_id,
+			u32 *value, const char *desc)
 {
 	struct tpm2_cmd cmd;
 	int rc;
 
-	cmd.header.in = tpm2_get_tpm_pt_header;
-	cmd.params.get_tpm_pt_in.cap_id = cpu_to_be32(TPM2_CAP_TPM_PROPERTIES);
-	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(property_id);
-	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
+	cmd.header.in = tpm2_getcap_header;
+	cmd.params.getcap_in.cap_id = cpu_to_be32(cap_id);
+	cmd.params.getcap_in.property_id = cpu_to_be32(property_id);
+	cmd.params.getcap_in.property_cnt = cpu_to_be32(1);
 
 	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, desc);
 	if (!rc)
-		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);
+		*value = be32_to_cpu(cmd.params.getcap_out.value);
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(tpm2_get_tpm_pt);
+EXPORT_SYMBOL_GPL(tpm2_getcap_cmd);
 
 #define TPM2_STARTUP_IN_SIZE \
 	(sizeof(struct tpm_input_header) + \
@@ -978,10 +976,10 @@ int tpm2_probe(struct tpm_chip *chip)
 	struct tpm2_cmd cmd;
 	int rc;
 
-	cmd.header.in = tpm2_get_tpm_pt_header;
-	cmd.params.get_tpm_pt_in.cap_id = cpu_to_be32(TPM2_CAP_TPM_PROPERTIES);
-	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
-	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
+	cmd.header.in = tpm2_getcap_header;
+	cmd.params.getcap_in.cap_id = cpu_to_be32(TPM2_CAP_TPM_PROPERTIES);
+	cmd.params.getcap_in.property_id = cpu_to_be32(TPM2_PT_FAMILY_INDICATOR);
+	cmd.params.getcap_in.property_cnt = cpu_to_be32(1);
 
 	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),  0, NULL);
 	if (rc <  0)
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index e3bf31b..792ccd1 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -528,7 +528,8 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 	cap_t cap;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
+		return tpm2_getcap_cmd(chip, TPM2_CAP_TPM_PROPERTIES,
+				       TPM2_PT_FAMILY_INDICATOR, &cap2, desc);
 	else
 		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
 }
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
