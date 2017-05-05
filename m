From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 1/5] tpm: introduce tpm_pcr_algorithms()
Date: Fri, 5 May 2017 16:21:48 +0200
Message-ID: <20170505142152.29795-2-roberto.sassu@huawei.com>
References: <20170505142152.29795-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170505142152.29795-1-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

This function allows TPM users to know which algorithms the TPM supports.
It stores the algorithms in a static array of 'enum tpm2_algorithms',
allocated by the caller. If the array is not large enough, the function
returns an error. Otherwise, it returns the number of algorithms written
to the array. If the TPM version is 1.2, the function writes TPM2_ALG_SHA1
to first element of the array.

Writing the algorithm also for TPM 1.2 has the advantage that callers
can use the API, tpm_pcr_algorithms() and tpm_pcr_extend(), regardless
of the TPM version.

A minor change added to this patch was to make available the size of
the active_banks array, member of the tpm_chip structure, outside
the TPM driver. The array size (TPM_ACTIVE_BANKS_MAX) has been exported
to include/linux/tpm.h.

With this information, callers of tpm_pcr_algorithms() can provide
a static array with enough room for all the algorithms, instead
of receiving the pointer of a dynamic array that they have to free later.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
v2

- tpm_pcr_algorithms() returns supported algorithms also for TPM 1.2

 drivers/char/tpm/tpm-interface.c | 46 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h           | 13 +-----------
 include/linux/tpm.h              | 19 +++++++++++++++++
 3 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 4ed08ab..b90de3d 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -911,6 +911,52 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 
 /**
+ * tpm_pcr_algorithms - get TPM IDs of active PCR banks algorithms
+ * @chip_num:	tpm idx # or ANY
+ * @count:	# of items in algorithms
+ * @algorithms:	array of TPM IDs
+ *
+ * Returns < 0 on error, and the number of active PCR banks on success.
+ *
+ * TPM 1.2 has always one SHA1 bank.
+ */
+int tpm_pcr_algorithms(u32 chip_num, int count,
+		       enum tpm2_algorithms *algorithms)
+{
+	struct tpm_chip *chip;
+	int i;
+
+	if (count <= 0 || algorithms == NULL)
+		return -EINVAL;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+		algorithms[0] = TPM2_ALG_SHA1;
+		tpm_put_ops(chip);
+		return 1;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(chip->active_banks) &&
+	     chip->active_banks[i] != TPM2_ALG_ERROR; i++) {
+		if (i >= count) {
+			dev_dbg(&chip->dev, "%s: insufficient array items %d\n",
+				__func__, count);
+			tpm_put_ops(chip);
+			return -EINVAL;
+		}
+
+		algorithms[i] = chip->active_banks[i];
+	}
+
+	tpm_put_ops(chip);
+	return i;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_algorithms);
+
+/**
  * tpm_do_selftest - have the TPM continue its selftest and wait until it
  *                   can receive further commands
  * @chip: TPM chip to use
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e81d8c7..b22bc25 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -98,17 +98,6 @@ enum tpm2_return_codes {
 	TPM2_RC_REFERENCE_H0	= 0x0910,
 };
 
-enum tpm2_algorithms {
-	TPM2_ALG_ERROR		= 0x0000,
-	TPM2_ALG_SHA1		= 0x0004,
-	TPM2_ALG_KEYEDHASH	= 0x0008,
-	TPM2_ALG_SHA256		= 0x000B,
-	TPM2_ALG_SHA384		= 0x000C,
-	TPM2_ALG_SHA512		= 0x000D,
-	TPM2_ALG_NULL		= 0x0010,
-	TPM2_ALG_SM3_256	= 0x0012,
-};
-
 enum tpm2_command_codes {
 	TPM2_CC_FIRST		= 0x011F,
 	TPM2_CC_SELF_TEST	= 0x0143,
@@ -219,7 +208,7 @@ struct tpm_chip {
 	const struct attribute_group *groups[3];
 	unsigned int groups_cnt;
 
-	u16 active_banks[7];
+	u16 active_banks[TPM_ACTIVE_BANKS_MAX];
 #ifdef CONFIG_ACPI
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 5a090f5..b0d0061 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -23,6 +23,7 @@
 #define __LINUX_TPM_H__
 
 #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
+#define TPM_ACTIVE_BANKS_MAX 7	/* Max num of active banks for TPM 2.0 */
 
 /*
  * Chip num is this value or a valid tpm idx
@@ -37,6 +38,17 @@ enum TPM_OPS_FLAGS {
 	TPM_OPS_AUTO_STARTUP = BIT(0),
 };
 
+enum tpm2_algorithms {
+	TPM2_ALG_ERROR		= 0x0000,
+	TPM2_ALG_SHA1		= 0x0004,
+	TPM2_ALG_KEYEDHASH	= 0x0008,
+	TPM2_ALG_SHA256		= 0x000B,
+	TPM2_ALG_SHA384		= 0x000C,
+	TPM2_ALG_SHA512		= 0x000D,
+	TPM2_ALG_NULL		= 0x0010,
+	TPM2_ALG_SM3_256	= 0x0012,
+};
+
 struct tpm_class_ops {
 	unsigned int flags;
 	const u8 req_complete_mask;
@@ -57,6 +69,8 @@ struct tpm_class_ops {
 extern int tpm_is_tpm2(u32 chip_num);
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+extern int tpm_pcr_algorithms(u32 chip_num, int count,
+			      enum tpm2_algorithms *algorithms);
 extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
 extern int tpm_get_random(u32 chip_num, u8 *data, size_t max);
 extern int tpm_seal_trusted(u32 chip_num,
@@ -76,6 +90,11 @@ static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
 	return -ENODEV;
 }
+static inline int tpm_pcr_algorithms(u32 chip_num, int count,
+				     enum tpm2_algorithms *algorithms)
+{
+	return -ENODEV;
+}
 static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
 	return -ENODEV;
 }
-- 
2.9.3

