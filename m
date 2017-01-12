From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 2/2] tpm: enhance TPM 2.0 PCR extend to
	support multiple banks
Date: Thu, 12 Jan 2017 11:58:10 -0500
Message-ID: <1484240290-4306-3-git-send-email-nayna@linux.vnet.ibm.com>
References: <1484240290-4306-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1484240290-4306-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The current TPM 2.0 device driver extends only the SHA1 PCR bank
but the TCG Specification[1] recommends extending all active PCR
banks, to prevent malicious users from setting unused PCR banks with
fake measurements and quoting them.

The existing in-kernel interface(tpm_pcr_extend()) expects only a
SHA1 digest.  To extend all active PCR banks with differing
digest sizes, the SHA1 digest is padded with trailing 0's as needed.

[1] TPM 2.0 Specification referred here is "TCG PC Client Specific
Platform Firmware Profile for TPM 2.0"

Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Kconfig         |  1 +
 drivers/char/tpm/tpm-interface.c | 16 +++++++++-
 drivers/char/tpm/tpm.h           |  3 +-
 drivers/char/tpm/tpm2-cmd.c      | 68 +++++++++++++++++++++++-----------------
 drivers/char/tpm/tpm_eventlog.h  | 18 +++++++++++
 5 files changed, 75 insertions(+), 31 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 277186d..af985cc 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -6,6 +6,7 @@ menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
 	depends on HAS_IOMEM
 	select SECURITYFS
+	select CRYPTO_HASH_INFO
 	---help---
 	  If you have a TPM security chip in your system, which
 	  implements the Trusted Computing Group's specification,
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index fecdd3f..e037dd2 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -7,6 +7,7 @@
  * Dave Safford <safford-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
  * Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
  * Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ * Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
  *
  * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
  *
@@ -759,6 +760,7 @@ static const struct tpm_input_header pcrextend_header = {
 int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 {
 	struct tpm_cmd_t cmd;
+	int i;
 	int rc;
 	struct tpm_chip *chip;
 
@@ -767,7 +769,19 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 		return -ENODEV;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
+		struct tpml_digest_values d_values;
+
+		memset(&d_values, 0, sizeof(d_values));
+
+		for (i = 0; (chip->active_banks[i] != 0) &&
+		     (i < ARRAY_SIZE(chip->active_banks)); i++) {
+			d_values.digests[i].alg_id = chip->active_banks[i];
+			memcpy(d_values.digests[i].digest, hash,
+			       TPM_DIGEST_SIZE);
+			d_values.count++;
+		}
+
+		rc = tpm2_pcr_extend(chip, pcr_idx, &d_values);
 		tpm_put_ops(chip);
 		return rc;
 	}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index dddd573..dd82d58 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -533,7 +533,8 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
 #endif
 
 int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
-int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
+int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx,
+		    struct tpml_digest_values *digests);
 int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
 int tpm2_seal_trusted(struct tpm_chip *chip,
 		      struct trusted_key_payload *payload,
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 87388921..5027a54 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -64,9 +64,7 @@ struct tpm2_pcr_extend_in {
 	__be32				pcr_idx;
 	__be32				auth_area_size;
 	struct tpm2_null_auth_area	auth_area;
-	__be32				digest_cnt;
-	__be16				hash_alg;
-	u8				digest[TPM_DIGEST_SIZE];
+	struct tpml_digest_values       digests;
 } __packed;
 
 struct tpm2_get_tpm_pt_in {
@@ -296,46 +294,58 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	return rc;
 }
 
-#define TPM2_GET_PCREXTEND_IN_SIZE \
-	(sizeof(struct tpm_input_header) + \
-	 sizeof(struct tpm2_pcr_extend_in))
-
-static const struct tpm_input_header tpm2_pcrextend_header = {
-	.tag = cpu_to_be16(TPM2_ST_SESSIONS),
-	.length = cpu_to_be32(TPM2_GET_PCREXTEND_IN_SIZE),
-	.ordinal = cpu_to_be32(TPM2_CC_PCR_EXTEND)
-};
-
 /**
  * tpm2_pcr_extend() - extend a PCR value
  *
  * @chip:	TPM chip to use.
  * @pcr_idx:	index of the PCR.
- * @hash:	hash value to use for the extend operation.
+ * @digests:	list of pcr banks and corresponding hash values to be extended.
  *
  * Return: Same as with tpm_transmit_cmd.
  */
-int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
+int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx,
+		    struct tpml_digest_values *digests)
 {
-	struct tpm2_cmd cmd;
+	struct tpm_buf buf;
+	struct tpm2_null_auth_area auth_area;
 	int rc;
+	int i;
+	int j;
 
-	cmd.header.in = tpm2_pcrextend_header;
-	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
-	cmd.params.pcrextend_in.auth_area_size =
-		cpu_to_be32(sizeof(struct tpm2_null_auth_area));
-	cmd.params.pcrextend_in.auth_area.handle =
-		cpu_to_be32(TPM2_RS_PW);
-	cmd.params.pcrextend_in.auth_area.nonce_size = 0;
-	cmd.params.pcrextend_in.auth_area.attributes = 0;
-	cmd.params.pcrextend_in.auth_area.auth_size = 0;
-	cmd.params.pcrextend_in.digest_cnt = cpu_to_be32(1);
-	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
-	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
+	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_PCR_EXTEND);
+	if (rc)
+		return rc;
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
+	tpm_buf_append_u32(&buf, pcr_idx);
+
+	auth_area.handle = cpu_to_be32(TPM2_RS_PW);
+	auth_area.nonce_size = 0;
+	auth_area.attributes = 0;
+	auth_area.auth_size = 0;
+
+	tpm_buf_append_u32(&buf, sizeof(struct tpm2_null_auth_area));
+	tpm_buf_append(&buf, (const unsigned char *)&auth_area,
+		       sizeof(auth_area));
+	tpm_buf_append_u32(&buf, digests->count);
+
+	for (i = 0; i < digests->count; i++) {
+		for (j = 0; j < ARRAY_SIZE(tpm2_hash_map); j++) {
+			if (digests->digests[i].alg_id !=
+			    tpm2_hash_map[j].tpm_id)
+				continue;
+
+			tpm_buf_append_u16(&buf, digests->digests[i].alg_id);
+			tpm_buf_append(&buf, (const unsigned char
+					      *)&digests->digests[i].digest,
+				hash_digest_size[tpm2_hash_map[j].crypto_id]);
+		}
+	}
+
+	rc = tpm_transmit_cmd(chip, buf.data, tpm_buf_length(&buf), 0,
 			      "attempting extend a PCR value");
 
+	tpm_buf_destroy(&buf);
+
 	return rc;
 }
 
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 1660d74..2e47f4d 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -2,9 +2,12 @@
 #ifndef __TPM_EVENTLOG_H__
 #define __TPM_EVENTLOG_H__
 
+#include <crypto/hash_info.h>
+
 #define TCG_EVENT_NAME_LEN_MAX	255
 #define MAX_TEXT_EVENT		1000	/* Max event string length */
 #define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
+#define TPM2_ACTIVE_PCR_BANKS	3
 
 #ifdef CONFIG_PPC64
 #define do_endian_conversion(x) be32_to_cpu(x)
@@ -73,6 +76,21 @@ enum tcpa_pc_event_ids {
 	HOST_TABLE_OF_DEVICES,
 };
 
+/**
+ * Digest structures for TPM 2.0 as defined in document
+ * Trusted Platform Module Library Part 2: Structures, Family "2.0".
+ */
+
+struct tpmt_ha {
+	u16 alg_id;
+	u8 digest[SHA384_DIGEST_SIZE];
+} __packed;
+
+struct tpml_digest_values {
+	u32 count;
+	struct tpmt_ha digests[TPM2_ACTIVE_PCR_BANKS];
+} __packed;
+
 #if defined(CONFIG_ACPI)
 int tpm_read_log_acpi(struct tpm_chip *chip);
 #else
-- 
2.5.0


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
