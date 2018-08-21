From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/23] TPM: Use struct tpm_chip rather than
 chip number as interface parameter
Date: Tue, 21 Aug 2018 16:57:22 +0100
Message-ID: <153486704294.13066.8818198038331415342.stgit@warthog.procyon.org.uk>
References: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <153486700916.13066.12870860668352070081.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Use struct tpm_chip rather than chip number as interface parameter for most
interface functions.  This allows the client to be sure about the consistency
of what device it uses.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-interface.c    |   76 ++++++++-------------------------
 drivers/char/tpm/tpm-sysfs.c        |    2 -
 include/linux/tpm.h                 |   16 ++++---
 security/integrity/ima/ima.h        |    2 -
 security/integrity/ima/ima_crypto.c |    4 +-
 security/integrity/ima/ima_init.c   |   19 +++++---
 security/integrity/ima/ima_queue.c  |    4 +-
 security/keys/trusted.c             |   80 ++++++++++++++++++++++-------------
 8 files changed, 96 insertions(+), 107 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index b8f1df5b64fe..29c2ce5cfc69 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -678,25 +678,9 @@ static struct tpm_input_header pcrread_header = {
 	.ordinal = TPM_ORDINAL_PCRREAD
 };
 
-int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
-{
-	int rc;
-	struct tpm_cmd_t cmd;
-
-	cmd.header.in = pcrread_header;
-	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
-			  "attempting to read a pcr value");
-
-	if (rc == 0)
-		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
-		       TPM_DIGEST_SIZE);
-	return rc;
-}
-
 /**
  * tpm_pcr_read - read a pcr value
- * @chip_num:	tpm idx # or ANY
+ * @chip:	The chip to pass the request to
  * @pcr_idx:	pcr idx to retrieve
  * @res_buf:	TPM_PCR value
  *		size of res_buf is 20 bytes (or NULL if you don't care)
@@ -705,23 +689,26 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
  * isn't, protect against the chip disappearing, by incrementing
  * the module usage count.
  */
-int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
+int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 {
-	struct tpm_chip *chip;
 	int rc;
+	struct tpm_cmd_t cmd;
 
-	chip = tpm_chip_find_get(chip_num);
-	if (chip == NULL)
-		return -ENODEV;
-	rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
-	tpm_chip_put(chip);
+	cmd.header.in = pcrread_header;
+	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
+	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
+			  "attempting to read a pcr value");
+
+	if (rc == 0)
+		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
+		       TPM_DIGEST_SIZE);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_read);
 
 /**
  * tpm_pcr_extend - extend pcr value with hash
- * @chip_num:	tpm idx # or AN&
+ * @chip:	The chip to pass the request to
  * @pcr_idx:	pcr idx to extend
  * @hash:	hash value used to extend pcr value
  *
@@ -737,24 +724,15 @@ static struct tpm_input_header pcrextend_header = {
 	.ordinal = TPM_ORD_PCR_EXTEND
 };
 
-int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
+int tpm_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
 {
 	struct tpm_cmd_t cmd;
-	int rc;
-	struct tpm_chip *chip;
-
-	chip = tpm_chip_find_get(chip_num);
-	if (chip == NULL)
-		return -ENODEV;
 
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
-			  "attempting extend a PCR value");
-
-	tpm_chip_put(chip);
-	return rc;
+	return transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+			    "attempting extend a PCR value");
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 
@@ -821,19 +799,9 @@ int tpm_do_selftest(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm_do_selftest);
 
-int tpm_send(u32 chip_num, void *cmd, size_t buflen)
+int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen)
 {
-	struct tpm_chip *chip;
-	int rc;
-
-	chip = tpm_chip_find_get(chip_num);
-	if (chip == NULL)
-		return -ENODEV;
-
-	rc = transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
-
-	tpm_chip_put(chip);
-	return rc;
+	return transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
 }
 EXPORT_SYMBOL_GPL(tpm_send);
 
@@ -1010,15 +978,14 @@ static struct tpm_input_header tpm_getrandom_header = {
 
 /**
  * tpm_get_random() - Get random bytes from the tpm's RNG
- * @chip_num: A specific chip number for the request or TPM_ANY_NUM
+ * @chip: The chip to pass the request to
  * @out: destination buffer for the random bytes
  * @max: the max number of bytes to write to @out
  *
  * Returns < 0 on error and the number of bytes read on success
  */
-int tpm_get_random(u32 chip_num, u8 *out, size_t max)
+int tpm_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 {
-	struct tpm_chip *chip;
 	struct tpm_cmd_t tpm_cmd;
 	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA);
 	int err, total = 0, retries = 5;
@@ -1027,10 +994,6 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
 		return -EINVAL;
 
-	chip = tpm_chip_find_get(chip_num);
-	if (chip == NULL)
-		return -ENODEV;
-
 	do {
 		tpm_cmd.header.in = tpm_getrandom_header;
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
@@ -1049,7 +1012,6 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		num_bytes -= recd;
 	} while (retries-- && total < max);
 
-	tpm_chip_put(chip);
 	return total ? total : -EIO;
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 01730a27ae07..507d8ab37ef1 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -120,7 +120,7 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 
 	num_pcrs = be32_to_cpu(cap.num_pcrs);
 	for (i = 0; i < num_pcrs; i++) {
-		rc = tpm_pcr_read_dev(chip, i, digest);
+		rc = tpm_pcr_read(chip, i, digest);
 		if (rc)
 			break;
 		str += sprintf(str, "PCR-%02d: ", i);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 44c8cad7132d..c213e09b7d81 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -49,10 +49,10 @@ struct tpm_class_ops {
 extern struct tpm_chip *tpm_chip_find_get(int chip_num);
 extern void tpm_chip_put(struct tpm_chip *chip);
 
-extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
-extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
-extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
-extern int tpm_get_random(u32 chip_num, u8 *data, size_t max);
+extern int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
+extern int tpm_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
+extern int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen);
+extern int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max);
 #else
 static inline struct tpm_chip *tpm_chip_find_get(int chip_num)
 {
@@ -61,16 +61,16 @@ static inline struct tpm_chip *tpm_chip_find_get(int chip_num)
 static inline void tpm_chip_put(struct tpm_chip *chip)
 {
 }
-static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
+static inline int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf) {
 	return -ENODEV;
 }
-static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
+static inline int tpm_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash) {
 	return -ENODEV;
 }
-static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
+static inline int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen) {
 	return -ENODEV;
 }
-static inline int tpm_get_random(u32 chip_num, u8 *data, size_t max) {
+static inline int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max) {
 	return -ENODEV;
 }
 #endif
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 8e4bb883fc13..8f932e53a449 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -44,8 +44,8 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 #define IMA_TEMPLATE_IMA_FMT "d|n"
 
 /* set during initialization */
+extern struct tpm_chip *ima_tpm;
 extern int ima_initialized;
-extern int ima_used_chip;
 extern int ima_hash_algo;
 extern int ima_appraise;
 
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index d34e7dfc1118..c4631e5bac5a 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -556,10 +556,10 @@ int ima_calc_field_array_hash(struct ima_field_data *field_data,
 
 static void __init ima_pcrread(int idx, u8 *pcr)
 {
-	if (!ima_used_chip)
+	if (!ima_tpm)
 		return;
 
-	if (tpm_pcr_read(TPM_ANY_NUM, idx, pcr) != 0)
+	if (tpm_pcr_read(ima_tpm, idx, pcr) != 0)
 		pr_err("Error Communicating to TPM chip\n");
 }
 
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index e8f9d70a465d..bcad4da9e663 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -26,7 +26,7 @@
 
 /* name for boot aggregate entry */
 static const char *boot_aggregate_name = "boot_aggregate";
-int ima_used_chip;
+struct tpm_chip *ima_tpm;
 
 /* Add the boot aggregate to the IMA measurement list and extend
  * the PCR register.
@@ -62,7 +62,7 @@ static void __init ima_add_boot_aggregate(void)
 	iint->ima_hash->algo = HASH_ALGO_SHA1;
 	iint->ima_hash->length = SHA1_DIGEST_SIZE;
 
-	if (ima_used_chip) {
+	if (ima_tpm) {
 		result = ima_calc_boot_aggregate(&hash.hdr);
 		if (result < 0) {
 			audit_cause = "hashing_error";
@@ -90,12 +90,17 @@ int __init ima_init(void)
 	u8 pcr_i[TPM_DIGEST_SIZE];
 	int rc;
 
-	ima_used_chip = 0;
-	rc = tpm_pcr_read(TPM_ANY_NUM, 0, pcr_i);
-	if (rc == 0)
-		ima_used_chip = 1;
+	ima_tpm = tpm_chip_find_get(TPM_ANY_NUM);
 
-	if (!ima_used_chip)
+	if (ima_tpm) {
+		rc = tpm_pcr_read(ima_tpm, 0, pcr_i);
+		if (rc != 0) {
+			tpm_chip_put(ima_tpm);
+			ima_tpm = NULL;
+		}
+	}
+
+	if (!ima_tpm)
 		pr_info("No TPM chip found, activating TPM-bypass!\n");
 
 	rc = ima_init_crypto();
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index 552705d5a78d..83629075375c 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -93,10 +93,10 @@ static int ima_pcr_extend(const u8 *hash)
 {
 	int result = 0;
 
-	if (!ima_used_chip)
+	if (!ima_tpm)
 		return result;
 
-	result = tpm_pcr_extend(TPM_ANY_NUM, CONFIG_IMA_MEASURE_PCR_IDX, hash);
+	result = tpm_pcr_extend(ima_tpm, CONFIG_IMA_MEASURE_PCR_IDX, hash);
 	if (result != 0)
 		pr_err("Error Communicating to TPM chip, result: %d\n", result);
 	return result;
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index c0594cb07ada..adb0caa5c38d 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -354,13 +354,13 @@ out:
  * For key specific tpm requests, we will generate and send our
  * own TPM command packets using the drivers send function.
  */
-static int trusted_tpm_send(const u32 chip_num, unsigned char *cmd,
+static int trusted_tpm_send(struct tpm_chip *chip, unsigned char *cmd,
 			    size_t buflen)
 {
 	int rc;
 
 	dump_tpm_buf(cmd);
-	rc = tpm_send(chip_num, cmd, buflen);
+	rc = tpm_send(chip, cmd, buflen);
 	dump_tpm_buf(cmd);
 	if (rc > 0)
 		/* Can't return positive return codes values to keyctl */
@@ -374,30 +374,31 @@ static int trusted_tpm_send(const u32 chip_num, unsigned char *cmd,
  * Prevents a trusted key that is sealed to PCRs from being accessed.
  * This uses the tpm driver's extend function.
  */
-static int pcrlock(const int pcrnum)
+static int pcrlock(struct tpm_chip *chip, const int pcrnum)
 {
 	unsigned char hash[SHA1_DIGEST_SIZE];
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
+	ret = tpm_get_random(chip, hash, SHA1_DIGEST_SIZE);
 	if (ret != SHA1_DIGEST_SIZE)
 		return ret;
-	return tpm_pcr_extend(TPM_ANY_NUM, pcrnum, hash) ? -EINVAL : 0;
+	return tpm_pcr_extend(chip, pcrnum, hash) ? -EINVAL : 0;
 }
 
 /*
  * Create an object specific authorisation protocol (OSAP) session
  */
-static int osap(struct tpm_buf *tb, struct osapsess *s,
+static int osap(struct tpm_chip *chip,
+		struct tpm_buf *tb, struct osapsess *s,
 		const unsigned char *key, uint16_t type, uint32_t handle)
 {
 	unsigned char enonce[TPM_NONCE_SIZE];
 	unsigned char ononce[TPM_NONCE_SIZE];
 	int ret;
 
-	ret = tpm_get_random(TPM_ANY_NUM, ononce, TPM_NONCE_SIZE);
+	ret = tpm_get_random(chip, ononce, TPM_NONCE_SIZE);
 	if (ret != TPM_NONCE_SIZE)
 		return ret;
 
@@ -409,7 +410,7 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
 	store32(tb, handle);
 	storebytes(tb, ononce, TPM_NONCE_SIZE);
 
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE);
 	if (ret < 0)
 		return ret;
 
@@ -425,7 +426,8 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
 /*
  * Create an object independent authorisation protocol (oiap) session
  */
-static int oiap(struct tpm_buf *tb, uint32_t *handle, unsigned char *nonce)
+static int oiap(struct tpm_chip *chip, struct tpm_buf *tb, uint32_t *handle,
+		unsigned char *nonce)
 {
 	int ret;
 
@@ -433,7 +435,7 @@ static int oiap(struct tpm_buf *tb, uint32_t *handle, unsigned char *nonce)
 	store16(tb, TPM_TAG_RQU_COMMAND);
 	store32(tb, TPM_OIAP_SIZE);
 	store32(tb, TPM_ORD_OIAP);
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE);
 	if (ret < 0)
 		return ret;
 
@@ -455,7 +457,8 @@ struct tpm_digests {
  * Have the TPM seal(encrypt) the trusted key, possibly based on
  * Platform Configuration Registers (PCRs). AUTH1 for sealing key.
  */
-static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
+static int tpm_seal(struct tpm_chip *chip,
+		    struct tpm_buf *tb, uint16_t keytype,
 		    uint32_t keyhandle, const unsigned char *keyauth,
 		    const unsigned char *data, uint32_t datalen,
 		    unsigned char *blob, uint32_t *bloblen,
@@ -480,7 +483,7 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 		return -ENOMEM;
 
 	/* get session for sealing key */
-	ret = osap(tb, &sess, keyauth, keytype, keyhandle);
+	ret = osap(chip, tb, &sess, keyauth, keytype, keyhandle);
 	if (ret < 0)
 		goto out;
 	dump_sess(&sess);
@@ -492,7 +495,7 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 	if (ret < 0)
 		goto out;
 
-	ret = tpm_get_random(TPM_ANY_NUM, td->nonceodd, TPM_NONCE_SIZE);
+	ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
 	if (ret != TPM_NONCE_SIZE)
 		goto out;
 	ordinal = htonl(TPM_ORD_SEAL);
@@ -541,7 +544,7 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 	store8(tb, cont);
 	storebytes(tb, td->pubauth, SHA1_DIGEST_SIZE);
 
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE);
 	if (ret < 0)
 		goto out;
 
@@ -570,7 +573,7 @@ out:
 /*
  * use the AUTH2_COMMAND form of unseal, to authorize both key and blob
  */
-static int tpm_unseal(struct tpm_buf *tb,
+static int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 		      uint32_t keyhandle, const unsigned char *keyauth,
 		      const unsigned char *blob, int bloblen,
 		      const unsigned char *blobauth,
@@ -589,12 +592,12 @@ static int tpm_unseal(struct tpm_buf *tb,
 	int ret;
 
 	/* sessions for unsealing key and data */
-	ret = oiap(tb, &authhandle1, enonce1);
+	ret = oiap(chip, tb, &authhandle1, enonce1);
 	if (ret < 0) {
 		pr_info("trusted_key: oiap failed (%d)\n", ret);
 		return ret;
 	}
-	ret = oiap(tb, &authhandle2, enonce2);
+	ret = oiap(chip, tb, &authhandle2, enonce2);
 	if (ret < 0) {
 		pr_info("trusted_key: oiap failed (%d)\n", ret);
 		return ret;
@@ -602,7 +605,7 @@ static int tpm_unseal(struct tpm_buf *tb,
 
 	ordinal = htonl(TPM_ORD_UNSEAL);
 	keyhndl = htonl(SRKHANDLE);
-	ret = tpm_get_random(TPM_ANY_NUM, nonceodd, TPM_NONCE_SIZE);
+	ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
 	if (ret != TPM_NONCE_SIZE) {
 		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
 		return ret;
@@ -634,7 +637,7 @@ static int tpm_unseal(struct tpm_buf *tb,
 	store8(tb, cont);
 	storebytes(tb, authdata2, SHA1_DIGEST_SIZE);
 
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE);
 	if (ret < 0) {
 		pr_info("trusted_key: authhmac failed (%d)\n", ret);
 		return ret;
@@ -658,7 +661,8 @@ static int tpm_unseal(struct tpm_buf *tb,
 /*
  * Have the TPM seal(encrypt) the symmetric key
  */
-static int key_seal(struct trusted_key_payload *p,
+static int key_seal(struct tpm_chip *chip,
+		    struct trusted_key_payload *p,
 		    struct trusted_key_options *o)
 {
 	struct tpm_buf *tb;
@@ -671,7 +675,7 @@ static int key_seal(struct trusted_key_payload *p,
 	/* include migratable flag at end of sealed key */
 	p->key[p->key_len] = p->migratable;
 
-	ret = tpm_seal(tb, o->keytype, o->keyhandle, o->keyauth,
+	ret = tpm_seal(chip, tb, o->keytype, o->keyhandle, o->keyauth,
 		       p->key, p->key_len + 1, p->blob, &p->blob_len,
 		       o->blobauth, o->pcrinfo, o->pcrinfo_len);
 	if (ret < 0)
@@ -684,7 +688,8 @@ static int key_seal(struct trusted_key_payload *p,
 /*
  * Have the TPM unseal(decrypt) the symmetric key
  */
-static int key_unseal(struct trusted_key_payload *p,
+static int key_unseal(struct tpm_chip *chip,
+		      struct trusted_key_payload *p,
 		      struct trusted_key_options *o)
 {
 	struct tpm_buf *tb;
@@ -694,7 +699,8 @@ static int key_unseal(struct trusted_key_payload *p,
 	if (!tb)
 		return -ENOMEM;
 
-	ret = tpm_unseal(tb, o->keyhandle, o->keyauth, p->blob, p->blob_len,
+	ret = tpm_unseal(chip, tb, o->keyhandle, o->keyauth,
+			 p->blob, p->blob_len,
 			 o->blobauth, p->key, &p->key_len);
 	if (ret < 0)
 		pr_info("trusted_key: srkunseal failed (%d)\n", ret);
@@ -900,6 +906,7 @@ static int trusted_instantiate(struct key *key,
 {
 	struct trusted_key_payload *payload = NULL;
 	struct trusted_key_options *options = NULL;
+	struct tpm_chip *chip = NULL;
 	size_t datalen = prep->datalen;
 	char *datablob;
 	int ret = 0;
@@ -935,9 +942,14 @@ static int trusted_instantiate(struct key *key,
 	dump_payload(payload);
 	dump_options(options);
 
+	ret = -ENODEV;
+	chip = tpm_chip_find_get(TPM_ANY_NUM);
+	if (!chip)
+		goto out;
+
 	switch (key_cmd) {
 	case Opt_load:
-		ret = key_unseal(payload, options);
+		ret = key_unseal(chip, payload, options);
 		dump_payload(payload);
 		dump_options(options);
 		if (ret < 0)
@@ -945,12 +957,12 @@ static int trusted_instantiate(struct key *key,
 		break;
 	case Opt_new:
 		key_len = payload->key_len;
-		ret = tpm_get_random(TPM_ANY_NUM, payload->key, key_len);
+		ret = tpm_get_random(chip, payload->key, key_len);
 		if (ret != key_len) {
 			pr_info("trusted_key: key_create failed (%d)\n", ret);
 			goto out;
 		}
-		ret = key_seal(payload, options);
+		ret = key_seal(chip, payload, options);
 		if (ret < 0)
 			pr_info("trusted_key: key_seal failed (%d)\n", ret);
 		break;
@@ -958,9 +970,11 @@ static int trusted_instantiate(struct key *key,
 		ret = -EINVAL;
 		goto out;
 	}
+
 	if (!ret && options->pcrlock)
-		ret = pcrlock(options->pcrlock);
+		ret = pcrlock(chip, options->pcrlock);
 out:
+	tpm_chip_put(chip);
 	kfree(datablob);
 	kfree(options);
 	if (!ret)
@@ -987,6 +1001,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	struct trusted_key_payload *p = key->payload.data;
 	struct trusted_key_payload *new_p;
 	struct trusted_key_options *new_o;
+	struct tpm_chip *chip = NULL;
 	size_t datalen = prep->datalen;
 	char *datablob;
 	int ret = 0;
@@ -1018,6 +1033,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 		kfree(new_p);
 		goto out;
 	}
+
 	/* copy old key values, and reseal with new pcrs */
 	new_p->migratable = p->migratable;
 	new_p->key_len = p->key_len;
@@ -1025,14 +1041,19 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	dump_payload(p);
 	dump_payload(new_p);
 
-	ret = key_seal(new_p, new_o);
+	ret = -ENODEV;
+	chip = tpm_chip_find_get(TPM_ANY_NUM);
+	if (!chip)
+		goto out;
+
+	ret = key_seal(chip, new_p, new_o);
 	if (ret < 0) {
 		pr_info("trusted_key: key_seal failed (%d)\n", ret);
 		kfree(new_p);
 		goto out;
 	}
 	if (new_o->pcrlock) {
-		ret = pcrlock(new_o->pcrlock);
+		ret = pcrlock(chip, new_o->pcrlock);
 		if (ret < 0) {
 			pr_info("trusted_key: pcrlock failed (%d)\n", ret);
 			kfree(new_p);
@@ -1042,6 +1063,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	rcu_assign_keypointer(key, new_p);
 	call_rcu(&p->rcu, trusted_rcu_free);
 out:
+	tpm_chip_put(chip);
 	kfree(datablob);
 	kfree(new_o);
 	return ret;


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
