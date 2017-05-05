From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 2/5] tpm: introduce tpm_pcr_algo_to_crypto() and tpm_pcr_algo_from_crypto()
Date: Fri, 5 May 2017 16:21:49 +0200
Message-ID: <20170505142152.29795-3-roberto.sassu@huawei.com>
References: <20170505142152.29795-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170505142152.29795-1-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

tpm_pcr_algorithms() returns to its callers the IDs of the hash algorithms
supported by the TPM. This patch introduces tpm_pcr_algo_to_crypto(),
so that the callers can use the crypto subsystem to calculate the digest
to be passed to tpm_pcr_extend().

tpm_pcr_algo_from_crypto(), implemented for completeness, is instead used
by tpm2_seal_trusted() to perform the opposite conversion.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
v2

- fixed return values of tpm2_pcr_algo_to_crypto() and
  tpm2_pcr_algo_from_crypto() if TPM support is disabled in the kernel

 drivers/char/tpm/tpm-interface.c | 51 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2-cmd.c      | 42 +++++++++------------------------
 include/linux/tpm.h              | 13 ++++++++++
 3 files changed, 75 insertions(+), 31 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index b90de3d..aac703e 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -956,6 +956,57 @@ int tpm_pcr_algorithms(u32 chip_num, int count,
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_algorithms);
 
+struct tpm2_hash {
+	unsigned int crypto_id;
+	unsigned int tpm_id;
+};
+
+static struct tpm2_hash tpm2_hash_map[] = {
+	{HASH_ALGO_SHA1, TPM2_ALG_SHA1},
+	{HASH_ALGO_SHA256, TPM2_ALG_SHA256},
+	{HASH_ALGO_SHA384, TPM2_ALG_SHA384},
+	{HASH_ALGO_SHA512, TPM2_ALG_SHA512},
+	{HASH_ALGO_SM3_256, TPM2_ALG_SM3_256},
+};
+
+/**
+ * tpm_pcr_algo_to_crypto() - convert from TPM ID to crypto ID
+ * @tpm_id:	TPM ID
+ *
+ * Return: crypto ID
+ */
+enum hash_algo tpm_pcr_algo_to_crypto(enum tpm2_algorithms tpm_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tpm2_hash_map); i++) {
+		if (tpm_id == tpm2_hash_map[i].tpm_id)
+			return tpm2_hash_map[i].crypto_id;
+	}
+
+	return HASH_ALGO__LAST;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_algo_to_crypto);
+
+/**
+ * tpm_pcr_algo_from_crypto() - convert from crypto ID to TPM ID
+ * @crypto_id:	crypto ID
+ *
+ * Return: TPM ID
+ */
+enum tpm2_algorithms tpm_pcr_algo_from_crypto(enum hash_algo crypto_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tpm2_hash_map); i++) {
+		if (crypto_id == tpm2_hash_map[i].crypto_id)
+			return tpm2_hash_map[i].tpm_id;
+	}
+
+	return TPM2_ALG_ERROR;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_algo_from_crypto);
+
 /**
  * tpm_do_selftest - have the TPM continue its selftest and wait until it
  *                   can receive further commands
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 3ee6883..828a688 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -92,19 +92,6 @@ struct tpm2_cmd {
 	union tpm2_cmd_params	params;
 } __packed;
 
-struct tpm2_hash {
-	unsigned int crypto_id;
-	unsigned int tpm_id;
-};
-
-static struct tpm2_hash tpm2_hash_map[] = {
-	{HASH_ALGO_SHA1, TPM2_ALG_SHA1},
-	{HASH_ALGO_SHA256, TPM2_ALG_SHA256},
-	{HASH_ALGO_SHA384, TPM2_ALG_SHA384},
-	{HASH_ALGO_SHA512, TPM2_ALG_SHA512},
-	{HASH_ALGO_SM3_256, TPM2_ALG_SM3_256},
-};
-
 /*
  * Array with one entry per ordinal defining the maximum amount
  * of time the chip could take to return the result. The values
@@ -301,7 +288,6 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
 	struct tpm2_null_auth_area auth_area;
 	int rc;
 	int i;
-	int j;
 
 	if (count > ARRAY_SIZE(chip->active_banks))
 		return -EINVAL;
@@ -323,14 +309,15 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
 	tpm_buf_append_u32(&buf, count);
 
 	for (i = 0; i < count; i++) {
-		for (j = 0; j < ARRAY_SIZE(tpm2_hash_map); j++) {
-			if (digests[i].alg_id != tpm2_hash_map[j].tpm_id)
-				continue;
-			tpm_buf_append_u16(&buf, digests[i].alg_id);
-			tpm_buf_append(&buf, (const unsigned char
-					      *)&digests[i].digest,
-			       hash_digest_size[tpm2_hash_map[j].crypto_id]);
-		}
+		enum tpm2_algorithms tpm_id = digests[i].alg_id;
+		enum hash_algo crypto_id = tpm_pcr_algo_to_crypto(tpm_id);
+
+		if (crypto_id == HASH_ALGO__LAST)
+			continue;
+
+		tpm_buf_append_u16(&buf, digests[i].alg_id);
+		tpm_buf_append(&buf, (const unsigned char *)&digests[i].digest,
+			       hash_digest_size[crypto_id]);
 	}
 
 	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, 0,
@@ -493,17 +480,10 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	unsigned int blob_len;
 	struct tpm_buf buf;
 	u32 hash, rlength;
-	int i;
 	int rc;
 
-	for (i = 0; i < ARRAY_SIZE(tpm2_hash_map); i++) {
-		if (options->hash == tpm2_hash_map[i].crypto_id) {
-			hash = tpm2_hash_map[i].tpm_id;
-			break;
-		}
-	}
-
-	if (i == ARRAY_SIZE(tpm2_hash_map))
+	hash = tpm_pcr_algo_from_crypto(options->hash);
+	if (hash == TPM2_ALG_ERROR)
 		return -EINVAL;
 
 	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index b0d0061..9ecd12c 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -22,6 +22,8 @@
 #ifndef __LINUX_TPM_H__
 #define __LINUX_TPM_H__
 
+#include <crypto/hash_info.h>
+
 #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
 #define TPM_ACTIVE_BANKS_MAX 7	/* Max num of active banks for TPM 2.0 */
 
@@ -71,6 +73,8 @@ extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
 extern int tpm_pcr_algorithms(u32 chip_num, int count,
 			      enum tpm2_algorithms *algorithms);
+extern enum hash_algo tpm_pcr_algo_to_crypto(enum tpm2_algorithms tpm_id);
+extern enum tpm2_algorithms tpm_pcr_algo_from_crypto(enum hash_algo crypto_id);
 extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
 extern int tpm_get_random(u32 chip_num, u8 *data, size_t max);
 extern int tpm_seal_trusted(u32 chip_num,
@@ -95,6 +99,15 @@ static inline int tpm_pcr_algorithms(u32 chip_num, int count,
 {
 	return -ENODEV;
 }
+static inline enum hash_algo tpm_pcr_algo_to_crypto(enum tpm2_algorithms tpm_id)
+{
+	return HASH_ALGO__LAST;
+}
+static inline enum tpm2_algorithms tpm_pcr_algo_from_crypto(
+						enum hash_algo crypto_id)
+{
+	return TPM2_ALG_ERROR;
+}
 static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
 	return -ENODEV;
 }
-- 
2.9.3

