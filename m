From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] tpm: introduce tpm_extend_pcr_digests()
Date: Wed, 29 Mar 2017 12:24:52 +0200
Message-ID: <20170329102452.32212-5-roberto.sassu@huawei.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170329102452.32212-1-roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Allow TPM users to provide a digest for each PCR bank,
for the extend operation.

Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 31 +++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h           |  6 ------
 include/linux/tpm.h              | 14 ++++++++++++++
 3 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 44e7c99..99789b2 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -876,6 +876,37 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 
 /**
+ * tpm_pcr_extend_digests - extend pcr banks values with provided digests values
+ * @chip_num:	tpm idx # or ANY
+ * @pcr_idx:	pcr idx to extend
+ * @count:	size of array
+ * @digests:	array of tpm2_digest structures
+ *
+ * The TPM driver should be built-in, but for whatever reason it
+ * isn't, protect against the chip disappearing, by incrementing
+ * the module usage count.
+ */
+int tpm_pcr_extend_digests(u32 chip_num, int pcr_idx, u32 count,
+			   struct tpm2_digest *digests)
+{
+	struct tpm_chip *chip;
+	int rc = -ENODEV;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return rc;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+		goto out;
+
+	rc = tpm2_pcr_extend(chip, pcr_idx, count, digests);
+out:
+	tpm_put_ops(chip);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_extend_digests);
+
+/**
  * tpm_pcr_algorithms - get TPM IDs of active PCR banks algorithms
  * @chip_num:	tpm idx # or ANY
  * @algorithms: array of TPM IDs
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index f15279b..e130b6d 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -34,7 +34,6 @@
 #include <linux/acpi.h>
 #include <linux/cdev.h>
 #include <linux/highmem.h>
-#include <crypto/hash_info.h>
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
@@ -373,11 +372,6 @@ struct tpm_cmd_t {
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
index 6552e43..3e38112 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -22,6 +22,8 @@
 #ifndef __LINUX_TPM_H__
 #define __LINUX_TPM_H__
 
+#include <crypto/hash_info.h>
+
 #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
 #define TPM_ACTIVE_BANKS_MAX 7	/* Max num of active banks for TPM 2.0 */
 
@@ -34,6 +36,11 @@ struct tpm_chip;
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
@@ -70,6 +77,8 @@ extern enum tpm2_algorithms tpm2_pcr_algo_from_crypto(enum hash_algo crypto_id);
 extern int tpm_is_tpm2(u32 chip_num);
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+extern int tpm_pcr_extend_digests(u32 chip_num, int pcr_idx, u32 count,
+				  struct tpm2_digest *digests);
 extern int tpm_pcr_algorithms(u32 chip_num, u32 count,
 			      enum tpm2_algorithms *algorithms);
 extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
@@ -100,6 +109,11 @@ static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
 	return -ENODEV;
 }
+static inline int tpm_pcr_extend_digests(u32 chip_num, int pcr_idx, u32 count,
+					 struct tpm2_digest *digests)
+{
+	return -ENODEV;
+}
 static inline int tpm_pcr_algorithms(u32 chip_num, u32 count,
 				     enum tpm2_algorithms *algorithms)
 {
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
