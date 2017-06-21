From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 6/6] tpm: pass multiple digests to tpm_pcr_extend()
Date: Wed, 21 Jun 2017 16:29:41 +0200
Message-ID: <20170621142941.32674-7-roberto.sassu@huawei.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170621142941.32674-1-roberto.sassu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

This patch modifies the parameters of tpm_pcr_extend() by replacing the
SHA1 digest with an array of digests and the number of array elements.

This completes the changes necessary to correctly extend PCRs of a TPM 2.0.
Each PCR bank will be extended with a digest calculated with the PCR bank
algorithm. If the digest for a PCR bank has not been provided, the TPM
driver pads/truncates the first digest, to extend that bank. TPM users
should indicate in the event log in which sequence digests were passed
to the TPM driver (if they didn't provide all the digests), or should
pass to the driver a digest for each PCR bank.

Callers of tpm_pcr_extend(), pcrlock() and ima_pcr_extend(), have been
modified to pass the new arguments. They pass to tpm_pcr_extend() an array
with one element, containing the same SHA1 digest they were passing before
this patch.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 drivers/char/tpm/tpm-interface.c   | 51 ++++++++++++++++++++++++++++++++------
 drivers/char/tpm/tpm.h             |  6 -----
 include/linux/tpm.h                | 12 +++++++--
 security/integrity/ima/ima_queue.c |  4 ++-
 security/keys/trusted.c            |  6 ++---
 5 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index cf0cdb2..3b0d7a2 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -871,44 +871,79 @@ static int tpm1_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash,
 	return rc;
 }
 
+static u32 tpm_get_digest_size(struct tpm_chip *chip, enum tpm2_algorithms algo)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(chip->active_banks) &&
+	     chip->active_banks[i].alg_id != TPM2_ALG_ERROR; i++)
+		if (chip->active_banks[i].alg_id == algo)
+			return chip->active_banks[i].digest_size;
+
+	/* Callers should have checked which algorithms the TPM supports,
+	 * or should have provided a SHA1 digest, which is always supported.
+	 * If the passed algorithm is unknown, return the size of SHA1.
+	 */
+	return hash_digest_size[HASH_ALGO_SHA1];
+}
+
 /**
  * tpm_pcr_extend - extend pcr value with hash
  * @chip_num:	tpm idx # or AN&
  * @pcr_idx:	pcr idx to extend
- * @hash:	hash value used to extend pcr value
+ * @count:	number of digests
+ * @digests:	array of digests
  *
  * The TPM driver should be built-in, but for whatever reason it
  * isn't, protect against the chip disappearing, by incrementing
  * the module usage count.
  */
-int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
+int tpm_pcr_extend(u32 chip_num, int pcr_idx, u32 count,
+		   struct tpm2_digest *digests)
 {
 	int rc;
 	struct tpm_chip *chip;
 	struct tpm2_digest digest_list[ARRAY_SIZE(chip->active_banks)];
-	u32 count = 0;
-	int i;
+	u32 first_digest_size;
+	int i, j;
+
+	if (count == 0)
+		return -EINVAL;
 
 	chip = tpm_chip_find_get(chip_num);
 	if (chip == NULL)
 		return -ENODEV;
 
+	first_digest_size = tpm_get_digest_size(chip, digests[0].alg_id);
+
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		memset(digest_list, 0, sizeof(digest_list));
 
 		for (i = 0; i < ARRAY_SIZE(chip->active_banks) &&
 		     chip->active_banks[i].alg_id != TPM2_ALG_ERROR; i++) {
+			struct tpm_pcr_bank_info *bank = &chip->active_banks[i];
+			u8 *cur_digest = digests[0].digest;
+			u32 cur_digest_size = first_digest_size;
+
+			for (j = 0; j < count; j++) {
+				if (digests[j].alg_id == bank->alg_id) {
+					cur_digest = digests[j].digest;
+					cur_digest_size = bank->digest_size;
+					break;
+				}
+			}
+
 			digest_list[i].alg_id = chip->active_banks[i].alg_id;
-			memcpy(digest_list[i].digest, hash, TPM_DIGEST_SIZE);
-			count++;
+			memcpy(digest_list[i].digest, cur_digest,
+			       cur_digest_size);
 		}
 
-		rc = tpm2_pcr_extend(chip, pcr_idx, count, digest_list);
+		rc = tpm2_pcr_extend(chip, pcr_idx, i, digest_list);
 		tpm_put_ops(chip);
 		return rc;
 	}
 
-	rc = tpm1_pcr_extend(chip, pcr_idx, hash,
+	rc = tpm1_pcr_extend(chip, pcr_idx, digests[0].digest,
 			     "attempting extend a PCR value");
 	tpm_put_ops(chip);
 	return rc;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 75ec0d1..7c2f30b 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -34,7 +34,6 @@
 #include <linux/acpi.h>
 #include <linux/cdev.h>
 #include <linux/highmem.h>
-#include <crypto/hash_info.h>
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
@@ -386,11 +385,6 @@ struct tpm_cmd_t {
 	tpm_cmd_params	params;
 } __packed;
 
-struct tpm2_digest {
-	u16 alg_id;
-	u8 digest[SHA512_DIGEST_SIZE];
-} __packed;
-
 /* A string buffer type for constructing TPM commands. This is based on the
  * ideas of string buffer code in security/keys/trusted.h but is heap based
  * in order to keep the stack usage minimal.
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 49ec8fc..254d632 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -36,6 +36,11 @@ struct tpm_chip;
 struct trusted_key_payload;
 struct trusted_key_options;
 
+struct tpm2_digest {
+	u16 alg_id;
+	u8 digest[SHA512_DIGEST_SIZE];
+} __packed;
+
 enum TPM_OPS_FLAGS {
 	TPM_OPS_AUTO_STARTUP = BIT(0),
 };
@@ -76,7 +81,8 @@ struct tpm_pcr_bank_info {
 
 extern int tpm_is_tpm2(u32 chip_num);
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
-extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, u32 count,
+			  struct tpm2_digest *digests);
 extern int tpm_get_pcr_banks_info(u32 chip_num,
 				  struct tpm_pcr_bank_info *active_banks);
 extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
@@ -95,7 +101,9 @@ static inline int tpm_is_tpm2(u32 chip_num)
 static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 	return -ENODEV;
 }
-static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
+static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, u32 count,
+				 struct tpm2_digest *digests)
+{
 	return -ENODEV;
 }
 static inline int tpm_get_pcr_banks_info(u32 chip_num,
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index d9aa5ab..f628968 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -140,12 +140,14 @@ unsigned long ima_get_binary_runtime_size(void)
 
 static int ima_pcr_extend(const u8 *hash, int pcr)
 {
+	struct tpm2_digest digestarg = {.alg_id = TPM2_ALG_SHA1};
 	int result = 0;
 
 	if (!ima_used_chip)
 		return result;
 
-	result = tpm_pcr_extend(TPM_ANY_NUM, pcr, hash);
+	memcpy(digestarg.digest, hash, IMA_DIGEST_SIZE);
+	result = tpm_pcr_extend(TPM_ANY_NUM, pcr, 1, &digestarg);
 	if (result != 0)
 		pr_err("Error Communicating to TPM chip, result: %d\n", result);
 	return result;
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 435e86e..d6c0db8 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -377,15 +377,15 @@ static int trusted_tpm_send(const u32 chip_num, unsigned char *cmd,
  */
 static int pcrlock(const int pcrnum)
 {
-	unsigned char hash[SHA1_DIGEST_SIZE];
+	struct tpm2_digest digestarg = {.alg_id = TPM2_ALG_SHA1};
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
+	ret = tpm_get_random(TPM_ANY_NUM, digestarg.digest, SHA1_DIGEST_SIZE);
 	if (ret != SHA1_DIGEST_SIZE)
 		return ret;
-	return tpm_pcr_extend(TPM_ANY_NUM, pcrnum, hash) ? -EINVAL : 0;
+	return tpm_pcr_extend(TPM_ANY_NUM, pcrnum, 1, &digestarg) ? -EINVAL : 0;
 }
 
 /*
-- 
2.9.3
