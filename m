From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 2/2] tpm: enhance TPM 2.0 PCR extend to
	support multiple banks
Date: Sat,  8 Oct 2016 22:15:57 -0400
Message-ID: <1475979357-1167-3-git-send-email-nayna@linux.vnet.ibm.com>
References: <1475979357-1167-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1475979357-1167-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Like TPM 1.2, the current device driver for TPM 2.0 supports
extending only to the SHA1 PCR bank. But the TPM 2.0 supports multiple
PCR banks and the specification recommends extending to all active PCR
banks, this patch enhances the existing device driver support for
TPM 2.0 extend function and its in-kernel interface to extend to all
active PCR banks.

The existing in-kernel interface expects only a SHA1 digest.
Hence, to extend all active PCR banks with differing digest sizes
for TPM 2.0, the SHA1 digest is padded with trailing 0's as needed.

Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 17 ++++++++--
 drivers/char/tpm/tpm2-cmd.c      | 71 ++++++++++++++++++++++++++--------------
 drivers/char/tpm/tpm2.h          | 18 ++++++++++
 3 files changed, 79 insertions(+), 27 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 7743e8a..5dd5005 100644
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
@@ -32,6 +33,7 @@
 #include <linux/pm_runtime.h>
 
 #include "tpm.h"
+#include "tpm2.h"
 #include "tpm_eventlog.h"
 
 #define TPM_MAX_ORDINAL 243
@@ -752,7 +754,7 @@ static const struct tpm_input_header pcrextend_header = {
 int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 {
 	struct tpm_cmd_t cmd;
-	int rc;
+	int i, rc;
 	struct tpm_chip *chip;
 
 	chip = tpm_chip_find_get(chip_num);
@@ -760,7 +762,18 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 		return -ENODEV;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
+		struct tpml_digest_values d_values;
+
+		memset(&d_values, 0, sizeof(d_values));
+
+		for (i = 0; i < chip->no_of_active_banks; i++) {
+			d_values.digests[i].alg_id =
+				chip->active_banks[i];
+			memcpy(d_values.digests[i].digest, hash,
+			       TPM_DIGEST_SIZE);
+			d_values.count++;
+		}
+		rc = tpm2_pcr_extend(chip, pcr_idx, &d_values);
 		tpm_put_ops(chip);
 		return rc;
 	}
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index c597cf3c..8ba2992 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -16,6 +16,7 @@
  */
 
 #include "tpm.h"
+#include "tpm2.h"
 #include <crypto/hash_info.h>
 #include <keys/trusted-type.h>
 
@@ -53,22 +54,6 @@ struct tpm2_pcr_read_out {
 	u8	digest[TPM_DIGEST_SIZE];
 } __packed;
 
-struct tpm2_null_auth_area {
-	__be32			handle;
-	__be16			nonce_size;
-	u8			attributes;
-	__be16			auth_size;
-} __packed;
-
-struct tpm2_pcr_extend_in {
-	__be32				pcr_idx;
-	__be32				auth_area_size;
-	struct tpm2_null_auth_area	auth_area;
-	__be32				digest_cnt;
-	__be16				hash_alg;
-	u8				digest[TPM_DIGEST_SIZE];
-} __packed;
-
 struct tpm2_get_tpm_pt_in {
 	__be32	cap_id;
 	__be32	property_id;
@@ -300,38 +285,74 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 static const struct tpm_input_header tpm2_pcrextend_header = {
 	.tag = cpu_to_be16(TPM2_ST_SESSIONS),
-	.length = cpu_to_be32(TPM2_GET_PCREXTEND_IN_SIZE),
 	.ordinal = cpu_to_be32(TPM2_CC_PCR_EXTEND)
 };
 
 /**
  * tpm2_pcr_extend() - extend a PCR value
- * @chip:	TPM chip to use.
- * @pcr_idx:	index of the PCR.
- * @hash:	hash value to use for the extend operation.
+ * @chip:		TPM chip to use.
+ * @pcr_idx:		index of the PCR.
+ * @digest_values:	list of hash values to be extended.
  *
  * 0 is returned when the operation is successful. If a negative number is
  * returned it remarks a POSIX error code. If a positive number is returned
  * it remarks a TPM error.
  */
-int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
+int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx,
+		    struct tpml_digest_values *digest_list)
 {
 	struct tpm2_cmd cmd;
-	int rc;
+	int i, j, rc;
+	void *marker;
+	size_t size;
+	u32 halg_size;
+	u16 halg;
 
 	cmd.header.in = tpm2_pcrextend_header;
+	size = sizeof(struct tpm_input_header);
+
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
+	size = size + sizeof(cmd.params.pcrextend_in.pcr_idx);
+
 	cmd.params.pcrextend_in.auth_area_size =
 		cpu_to_be32(sizeof(struct tpm2_null_auth_area));
+	size = size + sizeof(cmd.params.pcrextend_in.auth_area_size);
+
 	cmd.params.pcrextend_in.auth_area.handle =
 		cpu_to_be32(TPM2_RS_PW);
 	cmd.params.pcrextend_in.auth_area.nonce_size = 0;
 	cmd.params.pcrextend_in.auth_area.attributes = 0;
 	cmd.params.pcrextend_in.auth_area.auth_size = 0;
-	cmd.params.pcrextend_in.digest_cnt = cpu_to_be32(1);
-	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
-	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
+	size = size + sizeof(cmd.params.pcrextend_in.auth_area);
+
+	cmd.params.pcrextend_in.digests.count =
+		cpu_to_be32(digest_list->count);
+	size = size + sizeof(cmd.params.pcrextend_in.digests.count);
+	marker = &cmd.params.pcrextend_in.digests.digests[0];
+
+	for (i = 0; i < digest_list->count; i++) {
+		for (j = 0; j < ARRAY_SIZE(tpm2_hash_map); j++) {
+
+			if (digest_list->digests[i].alg_id !=
+			    tpm2_hash_map[j].tpm_id)
+				continue;
+
+			halg_size = sizeof(digest_list->digests[i].alg_id);
+			halg = cpu_to_be16(digest_list->digests[i].alg_id);
+			memcpy(marker, &halg, halg_size);
+			marker = marker + halg_size;
+			size = size + halg_size;
+
+			memcpy(marker, &digest_list->digests[i].digest,
+			       hash_digest_size[tpm2_hash_map[j].crypto_id]);
+			marker = marker +
+				hash_digest_size[tpm2_hash_map[j].crypto_id];
+			size = size +
+				hash_digest_size[tpm2_hash_map[j].crypto_id];
+		}
+	}
 
+	cmd.header.in.length = cpu_to_be32(size);
 	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
 			      "attempting extend a PCR value");
 
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index 919fb05..0b1a107 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -74,6 +74,22 @@ struct tcg_pcr_event2 {
 	struct tcg_event_field		event;
 } __packed;
 
+/* Auth Area Structure. */
+struct tpm2_null_auth_area {
+	__be32		handle;
+	__be16		nonce_size;
+	u8		attributes;
+	__be16		auth_size;
+} __packed;
+
+/* Crypto agile extend format. */
+struct tpm2_pcr_extend_in {
+	__be32				pcr_idx;
+	__be32				auth_area_size;
+	struct tpm2_null_auth_area	auth_area;
+	struct tpml_digest_values	digests;
+} __packed;
+
 struct tpm2_get_cap_in {
 	__be32 cap_id;
 	__be32 property_id;
@@ -108,6 +124,8 @@ struct tpm2_get_cap_out {
 extern const struct seq_operations tpm2_binary_b_measurments_seqops;
 
 extern int tpm2_get_active_pcr_banks(struct tpm_chip *chip);
+extern int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx,
+			   struct tpml_digest_values *digest_values);
 extern int tpm2_get_capability(struct tpm_chip *chip, struct tpm2_get_cap_in
 	*cap_in, struct tpm2_get_cap_out *cap_out);
 
-- 
2.5.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
