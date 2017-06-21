From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 5/6] tpm: introduce tpm_get_pcr_banks_info()
Date: Wed, 21 Jun 2017 16:29:40 +0200
Message-ID: <20170621142941.32674-6-roberto.sassu@huawei.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170621142941.32674-1-roberto.sassu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

This function copies the array of tpm_pcr_bank_info structures to the
memory address specified by the caller. It assumes that the caller
allocated an array with the same number of elements of the active_banks
array (member of the tpm_chip structure). This number is defined in
include/linux/tpm.h (TPM_ACTIVE_BANKS_MAX definition).

A tpm_pcr_bank_info structure is also returned if the TPM version is 1.2.
The advantage of this choice is that the code for extending a PCR with
multiple digests will work regardless of the TPM version.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 drivers/char/tpm/tpm-interface.c | 33 +++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h           |  2 +-
 include/linux/tpm.h              |  8 ++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index a11598a..cf0cdb2 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -916,6 +916,39 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 
 /**
+ * tpm_get_pcr_banks_info() - get PCR banks information
+ * @chip_num:		tpm idx # or ANY
+ * @active_banks:	array of tpm_pcr_bank_info structures
+ *
+ * Return: < 0 on error, and the number of active PCR banks on success.
+ */
+int tpm_get_pcr_banks_info(u32 chip_num, struct tpm_pcr_bank_info *active_banks)
+{
+	struct tpm_chip *chip;
+	int count = 1;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+		active_banks[0].alg_id = TPM2_ALG_SHA1;
+		active_banks[0].crypto_id = HASH_ALGO_SHA1;
+		active_banks[0].digest_size = hash_digest_size[HASH_ALGO_SHA1];
+		goto out;
+	}
+
+	for (count = 0; count < ARRAY_SIZE(chip->active_banks) &&
+	     chip->active_banks[count].alg_id != TPM2_ALG_ERROR; count++)
+		memcpy(&active_banks[count], &chip->active_banks[count],
+		       sizeof(*active_banks));
+out:
+	tpm_put_ops(chip);
+	return count;
+}
+EXPORT_SYMBOL_GPL(tpm_get_pcr_banks_info);
+
+/**
  * tpm_do_selftest - have the TPM continue its selftest and wait until it
  *                   can receive further commands
  * @chip: TPM chip to use
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index d285bc6..75ec0d1 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -208,7 +208,7 @@ struct tpm_chip {
 	const struct attribute_group *groups[3];
 	unsigned int groups_cnt;
 
-	struct tpm_pcr_bank_info active_banks[7];
+	struct tpm_pcr_bank_info active_banks[TPM_ACTIVE_BANKS_MAX];
 #ifdef CONFIG_ACPI
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index ff06738..49ec8fc 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -25,6 +25,7 @@
 #include <crypto/hash_info.h>
 
 #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
+#define TPM_ACTIVE_BANKS_MAX 7	/* Max num of active banks for TPM 2.0 */
 
 /*
  * Chip num is this value or a valid tpm idx
@@ -76,6 +77,8 @@ struct tpm_pcr_bank_info {
 extern int tpm_is_tpm2(u32 chip_num);
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+extern int tpm_get_pcr_banks_info(u32 chip_num,
+				  struct tpm_pcr_bank_info *active_banks);
 extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
 extern int tpm_get_random(u32 chip_num, u8 *data, size_t max);
 extern int tpm_seal_trusted(u32 chip_num,
@@ -95,6 +98,11 @@ static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
 	return -ENODEV;
 }
+static inline int tpm_get_pcr_banks_info(u32 chip_num,
+					 struct tpm_pcr_bank_info *active_banks)
+{
+	return -ENODEV;
+}
 static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
 	return -ENODEV;
 }
-- 
2.9.3
