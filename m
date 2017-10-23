From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: remove chip_num parameter from in-kernel API
Date: Mon, 23 Oct 2017 14:38:14 +0200
Message-ID: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, David Safford <safford@us.ibm.com>, David Howells <dhowells@redhat.com>, Jerry Snitselaar <jsnitsel@redhat.com>, "open list:HARDWARE RANDOM NUMBER
        GENERATOR CORE" <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>linux
List-Id: tpmdd-devel@lists.sourceforge.net

The reasoning is simple and obvious. Since every call site passes the
value TPM_ANY_NUM (0xFFFF) the parameter does not have right to exist.
Refined the documentation of the corresponding functions.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/hw_random/tpm-rng.c    |  2 +-
 drivers/char/tpm/tpm-chip.c         | 38 ++++++++--------
 drivers/char/tpm/tpm-interface.c    | 87 ++++++++++++++++++-------------------
 drivers/char/tpm/tpm.h              |  2 +-
 include/linux/tpm.h                 | 43 ++++++++----------
 security/integrity/ima/ima_crypto.c |  2 +-
 security/integrity/ima/ima_init.c   |  2 +-
 security/integrity/ima/ima_queue.c  |  2 +-
 security/keys/trusted.c             | 35 ++++++++-------
 9 files changed, 101 insertions(+), 112 deletions(-)

diff --git a/drivers/char/hw_random/tpm-rng.c b/drivers/char/hw_random/tpm-rng.c
index d6d448266f07..8823efcddab8 100644
--- a/drivers/char/hw_random/tpm-rng.c
+++ b/drivers/char/hw_random/tpm-rng.c
@@ -25,7 +25,7 @@
 
 static int tpm_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
-	return tpm_get_random(TPM_ANY_NUM, data, max);
+	return tpm_get_random(data, max);
 }
 
 static struct hwrng tpm_rng = {
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index a114e8f7fb90..ec351111643b 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -81,34 +81,32 @@ void tpm_put_ops(struct tpm_chip *chip)
 EXPORT_SYMBOL_GPL(tpm_put_ops);
 
 /**
- * tpm_chip_find_get() - return tpm_chip for a given chip number
- * @chip_num: id to find
+ * tpm_chip_find_get() - reserved the first available TPM chip
  *
- * The return'd chip has been tpm_try_get_ops'd and must be released via
- * tpm_put_ops
+ * Finds the first available TPM chip and reserves its class device and
+ * operations.
+ *
+ * Return: a reserved &struct tpm_chip instance
  */
-struct tpm_chip *tpm_chip_find_get(int chip_num)
+struct tpm_chip *tpm_chip_find_get(void)
 {
-	struct tpm_chip *chip, *res = NULL;
+	struct tpm_chip *chip;
+	struct tpm_chip *res = NULL;
 	int chip_prev;
+	int chip_num;
 
 	mutex_lock(&idr_lock);
 
-	if (chip_num == TPM_ANY_NUM) {
-		chip_num = 0;
-		do {
-			chip_prev = chip_num;
-			chip = idr_get_next(&dev_nums_idr, &chip_num);
-			if (chip && !tpm_try_get_ops(chip)) {
-				res = chip;
-				break;
-			}
-		} while (chip_prev != chip_num);
-	} else {
-		chip = idr_find(&dev_nums_idr, chip_num);
-		if (chip && !tpm_try_get_ops(chip))
+	chip_num = 0;
+
+	do {
+		chip_prev = chip_num;
+		chip = idr_get_next(&dev_nums_idr, &chip_num);
+		if (chip && !tpm_try_get_ops(chip)) {
 			res = chip;
-	}
+			break;
+		}
+	} while (chip_prev != chip_num);
 
 	mutex_unlock(&idr_lock);
 
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d8e2e5bca903..b3907d3556ce 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -802,18 +802,19 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 }
 
 /**
- * tpm_is_tpm2 - is the chip a TPM2 chip?
- * @chip_num:	tpm idx # or ANY
+ * tpm_is_tpm2 - do we a have a TPM2 chip?
  *
- * Returns < 0 on error, and 1 or 0 on success depending whether the chip
- * is a TPM2 chip.
+ * Return:
+ *     1 if we have a TPM2 chip.
+ *     0 if we don't have a TPM2 chip.
+ *     A negative number for system errors (errno).
  */
-int tpm_is_tpm2(u32 chip_num)
+int tpm_is_tpm2(void)
 {
 	struct tpm_chip *chip;
 	int rc;
 
-	chip = tpm_chip_find_get(chip_num);
+	chip = tpm_chip_find_get();
 	if (chip == NULL)
 		return -ENODEV;
 
@@ -826,22 +827,18 @@ int tpm_is_tpm2(u32 chip_num)
 EXPORT_SYMBOL_GPL(tpm_is_tpm2);
 
 /**
- * tpm_pcr_read - read a pcr value
- * @chip_num:	tpm idx # or ANY
- * @pcr_idx:	pcr idx to retrieve
- * @res_buf:	TPM_PCR value
- *		size of res_buf is 20 bytes (or NULL if you don't care)
+ * tpm_pcr_read - read a PCR value from SHA1 bank
+ * @pcr_idx:	the PCR to be retrieved
+ * @res_buf:	the value of the PCR
  *
- * The TPM driver should be built-in, but for whatever reason it
- * isn't, protect against the chip disappearing, by incrementing
- * the module usage count.
+ * Return: same as with tpm_transmit_cmd()
  */
-int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
+int tpm_pcr_read(int pcr_idx, u8 *res_buf)
 {
 	struct tpm_chip *chip;
 	int rc;
 
-	chip = tpm_chip_find_get(chip_num);
+	chip = tpm_chip_find_get();
 	if (chip == NULL)
 		return -ENODEV;
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
@@ -882,16 +879,17 @@ static int tpm1_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash,
 }
 
 /**
- * tpm_pcr_extend - extend pcr value with hash
- * @chip_num:	tpm idx # or AN&
- * @pcr_idx:	pcr idx to extend
- * @hash:	hash value used to extend pcr value
+ * tpm_pcr_extend - extend a PCR value in SHA1 bank.
+ * @pcr_idx:	the PCR to be retrieved
+ * @hash:	the hash value used to extend the PCR value
+ *
+ * Note: with TPM 2.0 extends also those banks with a known digest size to the
+ * cryto subsystem in order to prevent malicious use of those PCR banks. In the
+ * future we should dynamically determine digest sizes.
  *
- * The TPM driver should be built-in, but for whatever reason it
- * isn't, protect against the chip disappearing, by incrementing
- * the module usage count.
+ * Return: same as with tpm_transmit_cmd()
  */
-int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
+int tpm_pcr_extend(int pcr_idx, const u8 *hash)
 {
 	int rc;
 	struct tpm_chip *chip;
@@ -899,7 +897,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	u32 count = 0;
 	int i;
 
-	chip = tpm_chip_find_get(chip_num);
+	chip = tpm_chip_find_get();
 	if (chip == NULL)
 		return -ENODEV;
 
@@ -1012,12 +1010,12 @@ int tpm1_auto_startup(struct tpm_chip *chip)
 	return rc;
 }
 
-int tpm_send(u32 chip_num, void *cmd, size_t buflen)
+int tpm_send(void *cmd, size_t buflen)
 {
 	struct tpm_chip *chip;
 	int rc;
 
-	chip = tpm_chip_find_get(chip_num);
+	chip = tpm_chip_find_get();
 	if (chip == NULL)
 		return -ENODEV;
 
@@ -1120,14 +1118,13 @@ static const struct tpm_input_header tpm_getrandom_header = {
 };
 
 /**
- * tpm_get_random() - Get random bytes from the tpm's RNG
- * @chip_num: A specific chip number for the request or TPM_ANY_NUM
+ * tpm_get_random() - acquire random bytes
  * @out: destination buffer for the random bytes
  * @max: the max number of bytes to write to @out
  *
- * Returns < 0 on error and the number of bytes read on success
+ * Return: same as with tpm_transmit_cmd()
  */
-int tpm_get_random(u32 chip_num, u8 *out, size_t max)
+int tpm_get_random(u8 *out, size_t max)
 {
 	struct tpm_chip *chip;
 	struct tpm_cmd_t tpm_cmd;
@@ -1138,7 +1135,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
 		return -EINVAL;
 
-	chip = tpm_chip_find_get(chip_num);
+	chip = tpm_chip_find_get();
 	if (chip == NULL)
 		return -ENODEV;
 
@@ -1181,21 +1178,22 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 EXPORT_SYMBOL_GPL(tpm_get_random);
 
 /**
- * tpm_seal_trusted() - seal a trusted key
- * @chip_num: A specific chip number for the request or TPM_ANY_NUM
+ * tpm_seal_trusted() - seal a trusted key payload
  * @options: authentication values and other options
  * @payload: the key data in clear and encrypted form
  *
- * Returns < 0 on error and 0 on success. At the moment, only TPM 2.0 chips
- * are supported.
+ * Note: at the moment, only TPM 2.0 chip are supported. TPM 1.x implementation
+ * is still located in the keyring subsystem.
+ *
+ * Return: same as with tpm_transmit_cmd()
  */
-int tpm_seal_trusted(u32 chip_num, struct trusted_key_payload *payload,
+int tpm_seal_trusted(struct trusted_key_payload *payload,
 		     struct trusted_key_options *options)
 {
 	struct tpm_chip *chip;
 	int rc;
 
-	chip = tpm_chip_find_get(chip_num);
+	chip = tpm_chip_find_get();
 	if (chip == NULL || !(chip->flags & TPM_CHIP_FLAG_TPM2))
 		return -ENODEV;
 
@@ -1207,21 +1205,22 @@ int tpm_seal_trusted(u32 chip_num, struct trusted_key_payload *payload,
 EXPORT_SYMBOL_GPL(tpm_seal_trusted);
 
 /**
- * tpm_unseal_trusted() - unseal a trusted key
- * @chip_num: A specific chip number for the request or TPM_ANY_NUM
+ * tpm_unseal_trusted() - unseal a trusted key payload
  * @options: authentication values and other options
  * @payload: the key data in clear and encrypted form
  *
- * Returns < 0 on error and 0 on success. At the moment, only TPM 2.0 chips
- * are supported.
+ * Note: at the moment, only TPM 2.0 chip are supported. TPM 1.x implementation
+ * is still located in the keyring subsystem.
+ *
+ * Return: same as with tpm_transmit_cmd()
  */
-int tpm_unseal_trusted(u32 chip_num, struct trusted_key_payload *payload,
+int tpm_unseal_trusted(struct trusted_key_payload *payload,
 		       struct trusted_key_options *options)
 {
 	struct tpm_chip *chip;
 	int rc;
 
-	chip = tpm_chip_find_get(chip_num);
+	chip = tpm_chip_find_get();
 	if (chip == NULL || !(chip->flags & TPM_CHIP_FLAG_TPM2))
 		return -ENODEV;
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index c1866cc02e30..269c32bb3af0 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -516,7 +516,7 @@ static inline void tpm_msleep(unsigned int delay_msec)
 		     delay_msec * 1000);
 };
 
-struct tpm_chip *tpm_chip_find_get(int chip_num);
+struct tpm_chip *tpm_chip_find_get(void);
 __must_check int tpm_try_get_ops(struct tpm_chip *chip);
 void tpm_put_ops(struct tpm_chip *chip);
 
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 5a090f5ab335..54cd6d903d31 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -24,11 +24,6 @@
 
 #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
 
-/*
- * Chip num is this value or a valid tpm idx
- */
-#define	TPM_ANY_NUM 0xFFFF
-
 struct tpm_chip;
 struct trusted_key_payload;
 struct trusted_key_options;
@@ -53,44 +48,42 @@ struct tpm_class_ops {
 };
 
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
-
-extern int tpm_is_tpm2(u32 chip_num);
-extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
-extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
-extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
-extern int tpm_get_random(u32 chip_num, u8 *data, size_t max);
-extern int tpm_seal_trusted(u32 chip_num,
-			    struct trusted_key_payload *payload,
+extern int tpm_is_tpm2(void);
+extern int tpm_pcr_read(int pcr_idx, u8 *res_buf);
+extern int tpm_pcr_extend(int pcr_idx, const u8 *hash);
+extern int tpm_send(void *cmd, size_t buflen);
+extern int tpm_get_random(u8 *data, size_t max);
+extern int tpm_seal_trusted(struct trusted_key_payload *payload,
 			    struct trusted_key_options *options);
-extern int tpm_unseal_trusted(u32 chip_num,
-			      struct trusted_key_payload *payload,
+extern int tpm_unseal_trusted(struct trusted_key_payload *payload,
 			      struct trusted_key_options *options);
 #else
-static inline int tpm_is_tpm2(u32 chip_num)
+static inline int tpm_is_tpm2(void)
 {
 	return -ENODEV;
 }
-static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
+static inline int tpm_pcr_read(int pcr_idx, u8 *res_buf)
+{
 	return -ENODEV;
 }
-static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
+static inline int tpm_pcr_extend(int pcr_idx, const u8 *hash)
+{
 	return -ENODEV;
 }
-static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
+static inline int tpm_send(void *cmd, size_t buflen)
+{
 	return -ENODEV;
 }
-static inline int tpm_get_random(u32 chip_num, u8 *data, size_t max) {
+static inline int tpm_get_random(u8 *data, size_t max)
+{
 	return -ENODEV;
 }
-
-static inline int tpm_seal_trusted(u32 chip_num,
-				   struct trusted_key_payload *payload,
+static inline int tpm_seal_trusted(struct trusted_key_payload *payload,
 				   struct trusted_key_options *options)
 {
 	return -ENODEV;
 }
-static inline int tpm_unseal_trusted(u32 chip_num,
-				     struct trusted_key_payload *payload,
+static inline int tpm_unseal_trusted(struct trusted_key_payload *payload,
 				     struct trusted_key_options *options)
 {
 	return -ENODEV;
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 802d5d20f36f..b5828bafab26 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -644,7 +644,7 @@ static void __init ima_pcrread(int idx, u8 *pcr)
 	if (!ima_used_chip)
 		return;
 
-	if (tpm_pcr_read(TPM_ANY_NUM, idx, pcr) != 0)
+	if (tpm_pcr_read(idx, pcr) != 0)
 		pr_err("Error Communicating to TPM chip\n");
 }
 
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 2967d497a665..21be72f604cd 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -110,7 +110,7 @@ int __init ima_init(void)
 	int rc;
 
 	ima_used_chip = 0;
-	rc = tpm_pcr_read(TPM_ANY_NUM, 0, pcr_i);
+	rc = tpm_pcr_read(0, pcr_i);
 	if (rc == 0)
 		ima_used_chip = 1;
 
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index a02a86d51102..d33966ff210d 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -145,7 +145,7 @@ static int ima_pcr_extend(const u8 *hash, int pcr)
 	if (!ima_used_chip)
 		return result;
 
-	result = tpm_pcr_extend(TPM_ANY_NUM, pcr, hash);
+	result = tpm_pcr_extend(pcr, hash);
 	if (result != 0)
 		pr_err("Error Communicating to TPM chip, result: %d\n", result);
 	return result;
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index ddfaebf60fc8..f912b5bffdad 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -355,13 +355,12 @@ static int TSS_checkhmac2(unsigned char *buffer,
  * For key specific tpm requests, we will generate and send our
  * own TPM command packets using the drivers send function.
  */
-static int trusted_tpm_send(const u32 chip_num, unsigned char *cmd,
-			    size_t buflen)
+static int trusted_tpm_send(unsigned char *cmd, size_t buflen)
 {
 	int rc;
 
 	dump_tpm_buf(cmd);
-	rc = tpm_send(chip_num, cmd, buflen);
+	rc = tpm_send(cmd, buflen);
 	dump_tpm_buf(cmd);
 	if (rc > 0)
 		/* Can't return positive return codes values to keyctl */
@@ -382,10 +381,10 @@ static int pcrlock(const int pcrnum)
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
+	ret = tpm_get_random(hash, SHA1_DIGEST_SIZE);
 	if (ret != SHA1_DIGEST_SIZE)
 		return ret;
-	return tpm_pcr_extend(TPM_ANY_NUM, pcrnum, hash) ? -EINVAL : 0;
+	return tpm_pcr_extend(pcrnum, hash) ? -EINVAL : 0;
 }
 
 /*
@@ -398,7 +397,7 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
 	unsigned char ononce[TPM_NONCE_SIZE];
 	int ret;
 
-	ret = tpm_get_random(TPM_ANY_NUM, ononce, TPM_NONCE_SIZE);
+	ret = tpm_get_random(ononce, TPM_NONCE_SIZE);
 	if (ret != TPM_NONCE_SIZE)
 		return ret;
 
@@ -410,7 +409,7 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
 	store32(tb, handle);
 	storebytes(tb, ononce, TPM_NONCE_SIZE);
 
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(tb->data, MAX_BUF_SIZE);
 	if (ret < 0)
 		return ret;
 
@@ -434,7 +433,7 @@ static int oiap(struct tpm_buf *tb, uint32_t *handle, unsigned char *nonce)
 	store16(tb, TPM_TAG_RQU_COMMAND);
 	store32(tb, TPM_OIAP_SIZE);
 	store32(tb, TPM_ORD_OIAP);
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(tb->data, MAX_BUF_SIZE);
 	if (ret < 0)
 		return ret;
 
@@ -493,7 +492,7 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 	if (ret < 0)
 		goto out;
 
-	ret = tpm_get_random(TPM_ANY_NUM, td->nonceodd, TPM_NONCE_SIZE);
+	ret = tpm_get_random(td->nonceodd, TPM_NONCE_SIZE);
 	if (ret != TPM_NONCE_SIZE)
 		goto out;
 	ordinal = htonl(TPM_ORD_SEAL);
@@ -542,7 +541,7 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 	store8(tb, cont);
 	storebytes(tb, td->pubauth, SHA1_DIGEST_SIZE);
 
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(tb->data, MAX_BUF_SIZE);
 	if (ret < 0)
 		goto out;
 
@@ -603,7 +602,7 @@ static int tpm_unseal(struct tpm_buf *tb,
 
 	ordinal = htonl(TPM_ORD_UNSEAL);
 	keyhndl = htonl(SRKHANDLE);
-	ret = tpm_get_random(TPM_ANY_NUM, nonceodd, TPM_NONCE_SIZE);
+	ret = tpm_get_random(nonceodd, TPM_NONCE_SIZE);
 	if (ret != TPM_NONCE_SIZE) {
 		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
 		return ret;
@@ -635,7 +634,7 @@ static int tpm_unseal(struct tpm_buf *tb,
 	store8(tb, cont);
 	storebytes(tb, authdata2, SHA1_DIGEST_SIZE);
 
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(tb->data, MAX_BUF_SIZE);
 	if (ret < 0) {
 		pr_info("trusted_key: authhmac failed (%d)\n", ret);
 		return ret;
@@ -748,7 +747,7 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 	int i;
 	int tpm2;
 
-	tpm2 = tpm_is_tpm2(TPM_ANY_NUM);
+	tpm2 = tpm_is_tpm2();
 	if (tpm2 < 0)
 		return tpm2;
 
@@ -917,7 +916,7 @@ static struct trusted_key_options *trusted_options_alloc(void)
 	struct trusted_key_options *options;
 	int tpm2;
 
-	tpm2 = tpm_is_tpm2(TPM_ANY_NUM);
+	tpm2 = tpm_is_tpm2();
 	if (tpm2 < 0)
 		return NULL;
 
@@ -967,7 +966,7 @@ static int trusted_instantiate(struct key *key,
 	size_t key_len;
 	int tpm2;
 
-	tpm2 = tpm_is_tpm2(TPM_ANY_NUM);
+	tpm2 = tpm_is_tpm2();
 	if (tpm2 < 0)
 		return tpm2;
 
@@ -1008,7 +1007,7 @@ static int trusted_instantiate(struct key *key,
 	switch (key_cmd) {
 	case Opt_load:
 		if (tpm2)
-			ret = tpm_unseal_trusted(TPM_ANY_NUM, payload, options);
+			ret = tpm_unseal_trusted(payload, options);
 		else
 			ret = key_unseal(payload, options);
 		dump_payload(payload);
@@ -1018,13 +1017,13 @@ static int trusted_instantiate(struct key *key,
 		break;
 	case Opt_new:
 		key_len = payload->key_len;
-		ret = tpm_get_random(TPM_ANY_NUM, payload->key, key_len);
+		ret = tpm_get_random(payload->key, key_len);
 		if (ret != key_len) {
 			pr_info("trusted_key: key_create failed (%d)\n", ret);
 			goto out;
 		}
 		if (tpm2)
-			ret = tpm_seal_trusted(TPM_ANY_NUM, payload, options);
+			ret = tpm_seal_trusted(payload, options);
 		else
 			ret = key_seal(payload, options);
 		if (ret < 0)
-- 
2.14.1
