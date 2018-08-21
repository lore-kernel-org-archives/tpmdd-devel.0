From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/23] TPMLIB: Do some source cleanups
Date: Tue, 21 Aug 2018 16:57:50 +0100
Message-ID: <153486707011.13066.14435967283392358361.stgit@warthog.procyon.org.uk>
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

Clean up the TPM library file that was split out of trusted keys.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |  187 +++++++++++++++++++++++-----------------
 drivers/char/tpm/tpm-library.h |   14 +--
 include/linux/tpm.h            |    4 -
 security/keys/trusted.c        |    6 +
 4 files changed, 121 insertions(+), 90 deletions(-)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index 1be4f71cabcb..e4cfc1f090e1 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -8,44 +8,36 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, version 2 of the License.
- *
- * See Documentation/security/keys-trusted-encrypted.txt
  */
 
-#include <linux/uaccess.h>
-#include <linux/module.h>
-#include <linux/init.h>
+#define pr_fmt(fmt) "TPMLIB: "fmt
 #include <linux/slab.h>
-#include <linux/parser.h>
-#include <linux/string.h>
 #include <linux/err.h>
-#include <keys/user-type.h>
-#include <keys/trusted-type.h>
-#include <linux/key-type.h>
-#include <linux/rcupdate.h>
+#include <linux/mutex.h>
 #include <linux/crypto.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
-#include <linux/capability.h>
 #include <linux/tpm.h>
 #include <linux/tpm_command.h>
 
 #include "tpm-library.h"
 
-static const char hmac_alg[] = "hmac(sha1)";
-static const char hash_alg[] = "sha1";
+static const char tpm_hmac_alg[] = "hmac(sha1)";
+static const char tpm_hash_alg[] = "sha1";
 
-struct sdesc {
+struct tpm_sdesc {
 	struct shash_desc shash;
 	char ctx[];
 };
 
-static struct crypto_shash *hashalg;
-static struct crypto_shash *hmacalg;
+static DEFINE_MUTEX(tpm_library_init_mutex);
+static atomic_t tpm_library_usage;
+static struct crypto_shash *tpm_hashalg;
+static struct crypto_shash *tpm_hmacalg;
 
-static struct sdesc *init_sdesc(struct crypto_shash *alg)
+static struct tpm_sdesc *tpm_init_sdesc(struct crypto_shash *alg)
 {
-	struct sdesc *sdesc;
+	struct tpm_sdesc *sdesc;
 	int size;
 
 	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
@@ -60,12 +52,12 @@ static struct sdesc *init_sdesc(struct crypto_shash *alg)
 static int TSS_sha1(const unsigned char *data, unsigned int datalen,
 		    unsigned char *digest)
 {
-	struct sdesc *sdesc;
+	struct tpm_sdesc *sdesc;
 	int ret;
 
-	sdesc = init_sdesc(hashalg);
+	sdesc = tpm_init_sdesc(tpm_hashalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		pr_info("Can't alloc %s\n", tpm_hash_alg);
 		return PTR_ERR(sdesc);
 	}
 
@@ -77,19 +69,19 @@ static int TSS_sha1(const unsigned char *data, unsigned int datalen,
 static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
 		       unsigned int keylen, ...)
 {
-	struct sdesc *sdesc;
+	struct tpm_sdesc *sdesc;
 	va_list argp;
 	unsigned int dlen;
 	unsigned char *data;
 	int ret;
 
-	sdesc = init_sdesc(hmacalg);
+	sdesc = tpm_init_sdesc(tpm_hmacalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hmac_alg);
+		pr_info("Can't alloc %s\n", tpm_hmac_alg);
 		return PTR_ERR(sdesc);
 	}
 
-	ret = crypto_shash_setkey(hmacalg, key, keylen);
+	ret = crypto_shash_setkey(tpm_hmacalg, key, keylen);
 	if (ret < 0)
 		goto out;
 	ret = crypto_shash_init(&sdesc->shash);
@@ -126,16 +118,16 @@ static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 			unsigned char *h2, unsigned char h3, ...)
 {
 	unsigned char paramdigest[SHA1_DIGEST_SIZE];
-	struct sdesc *sdesc;
+	struct tpm_sdesc *sdesc;
 	unsigned int dlen;
 	unsigned char *data;
 	unsigned char c;
 	int ret;
 	va_list argp;
 
-	sdesc = init_sdesc(hashalg);
+	sdesc = tpm_init_sdesc(tpm_hashalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		pr_info("Can't alloc %s\n", tpm_hash_alg);
 		return PTR_ERR(sdesc);
 	}
 
@@ -187,7 +179,7 @@ static int TSS_checkhmac1(unsigned char *buffer,
 	unsigned char *authdata;
 	unsigned char testhmac[SHA1_DIGEST_SIZE];
 	unsigned char paramdigest[SHA1_DIGEST_SIZE];
-	struct sdesc *sdesc;
+	struct tpm_sdesc *sdesc;
 	unsigned int dlen;
 	unsigned int dpos;
 	va_list argp;
@@ -205,9 +197,9 @@ static int TSS_checkhmac1(unsigned char *buffer,
 	continueflag = authdata - 1;
 	enonce = continueflag - TPM_NONCE_SIZE;
 
-	sdesc = init_sdesc(hashalg);
+	sdesc = tpm_init_sdesc(tpm_hashalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		pr_info("Can't alloc %s\n", tpm_hash_alg);
 		return PTR_ERR(sdesc);
 	}
 	ret = crypto_shash_init(&sdesc->shash);
@@ -274,7 +266,7 @@ static int TSS_checkhmac2(unsigned char *buffer,
 	unsigned char testhmac1[SHA1_DIGEST_SIZE];
 	unsigned char testhmac2[SHA1_DIGEST_SIZE];
 	unsigned char paramdigest[SHA1_DIGEST_SIZE];
-	struct sdesc *sdesc;
+	struct tpm_sdesc *sdesc;
 	unsigned int dlen;
 	unsigned int dpos;
 	va_list argp;
@@ -297,9 +289,9 @@ static int TSS_checkhmac2(unsigned char *buffer,
 	enonce1 = continueflag1 - TPM_NONCE_SIZE;
 	enonce2 = continueflag2 - TPM_NONCE_SIZE;
 
-	sdesc = init_sdesc(hashalg);
+	sdesc = tpm_init_sdesc(tpm_hashalg);
 	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		pr_info("Can't alloc %s\n", tpm_hash_alg);
 		return PTR_ERR(sdesc);
 	}
 	ret = crypto_shash_init(&sdesc->shash);
@@ -355,8 +347,8 @@ out:
  * For key specific tpm requests, we will generate and send our
  * own TPM command packets using the drivers send function.
  */
-static int trusted_tpm_send(struct tpm_chip *chip, unsigned char *cmd,
-			    size_t buflen, const char *desc)
+static int tpm_send_dump(struct tpm_chip *chip,
+			 unsigned char *cmd, size_t buflen, const char *desc)
 {
 	int rc;
 
@@ -372,9 +364,10 @@ static int trusted_tpm_send(struct tpm_chip *chip, unsigned char *cmd,
 /*
  * Create an object specific authorisation protocol (OSAP) session
  */
-static int osap(struct tpm_chip *chip,
-		struct tpm_buf *tb, struct osapsess *s,
-		const unsigned char *key, uint16_t type, uint32_t handle)
+static int tpm_create_osap(struct tpm_chip *chip,
+			   struct tpm_buf *tb, struct tpm_osapsess *s,
+			   const unsigned char *key, uint16_t type,
+			   uint32_t handle)
 {
 	unsigned char enonce[TPM_NONCE_SIZE];
 	unsigned char ononce[TPM_NONCE_SIZE];
@@ -392,8 +385,8 @@ static int osap(struct tpm_chip *chip,
 	store32(tb, handle);
 	storebytes(tb, ononce, TPM_NONCE_SIZE);
 
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
-			       "creating OSAP session");
+	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
+			    "creating OSAP session");
 	if (ret < 0)
 		return ret;
 
@@ -409,8 +402,8 @@ static int osap(struct tpm_chip *chip,
 /*
  * Create an object independent authorisation protocol (oiap) session
  */
-static int oiap(struct tpm_chip *chip, struct tpm_buf *tb, uint32_t *handle,
-		unsigned char *nonce)
+static int tpm_create_oiap(struct tpm_chip *chip, struct tpm_buf *tb,
+			   uint32_t *handle, unsigned char *nonce)
 {
 	int ret;
 
@@ -418,8 +411,8 @@ static int oiap(struct tpm_chip *chip, struct tpm_buf *tb, uint32_t *handle,
 	store16(tb, TPM_TAG_RQU_COMMAND);
 	store32(tb, TPM_OIAP_SIZE);
 	store32(tb, TPM_ORD_OIAP);
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
-			       "creating OIAP session");
+	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
+			    "creating OIAP session");
 	if (ret < 0)
 		return ret;
 
@@ -448,7 +441,7 @@ int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 	     const unsigned char *blobauth,
 	     const unsigned char *pcrinfo, uint32_t pcrinfosize)
 {
-	struct osapsess sess;
+	struct tpm_osapsess sess;
 	struct tpm_digests *td;
 	unsigned char cont;
 	uint32_t ordinal;
@@ -466,7 +459,7 @@ int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 		return -ENOMEM;
 
 	/* get session for sealing key */
-	ret = osap(chip, tb, &sess, keyauth, keytype, keyhandle);
+	ret = tpm_create_osap(chip, tb, &sess, keyauth, keytype, keyhandle);
 	if (ret < 0)
 		goto out;
 	dump_sess(&sess);
@@ -527,8 +520,8 @@ int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 	store8(tb, cont);
 	storebytes(tb, td->pubauth, SHA1_DIGEST_SIZE);
 
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
-			       "sealing data");
+	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
+			    "sealing data");
 	if (ret < 0)
 		goto out;
 
@@ -577,14 +570,14 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	int ret;
 
 	/* sessions for unsealing key and data */
-	ret = oiap(chip, tb, &authhandle1, enonce1);
+	ret = tpm_create_oiap(chip, tb, &authhandle1, enonce1);
 	if (ret < 0) {
-		pr_info("trusted_key: oiap failed (%d)\n", ret);
+		pr_info("Failed to create OIAP 1 (%d)\n", ret);
 		return ret;
 	}
-	ret = oiap(chip, tb, &authhandle2, enonce2);
+	ret = tpm_create_oiap(chip, tb, &authhandle2, enonce2);
 	if (ret < 0) {
-		pr_info("trusted_key: oiap failed (%d)\n", ret);
+		pr_info("Failed to create OIAP 2 (%d)\n", ret);
 		return ret;
 	}
 
@@ -592,7 +585,7 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	keyhndl = htonl(SRKHANDLE);
 	ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
 	if (ret != TPM_NONCE_SIZE) {
-		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
+		pr_info("tpm_get_random failed (%d)\n", ret);
 		return ret;
 	}
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
@@ -622,10 +615,10 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	store8(tb, cont);
 	storebytes(tb, authdata2, SHA1_DIGEST_SIZE);
 
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
-			       "unsealing data");
+	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
+			    "unsealing data");
 	if (ret < 0) {
-		pr_info("trusted_key: authhmac failed (%d)\n", ret);
+		pr_info("authhmac failed (%d)\n", ret);
 		return ret;
 	}
 
@@ -637,7 +630,7 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 			     *datalen, TPM_DATA_OFFSET + sizeof(uint32_t), 0,
 			     0);
 	if (ret < 0) {
-		pr_info("trusted_key: TSS_checkhmac2 failed (%d)\n", ret);
+		pr_info("TSS_checkhmac2 failed (%d)\n", ret);
 		return ret;
 	}
 	memcpy(data, tb->data + TPM_DATA_OFFSET + sizeof(uint32_t), *datalen);
@@ -645,38 +638,76 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 }
 EXPORT_SYMBOL_GPL(tpm_unseal);
 
-void trusted_shash_release(void)
-{
-	if (hashalg)
-		crypto_free_shash(hashalg);
-	if (hmacalg)
-		crypto_free_shash(hmacalg);
-}
-EXPORT_SYMBOL_GPL(trusted_shash_release);
-
-int trusted_shash_alloc(void)
+/**
+ * tpm_library_use - Tell the TPM library we want to make use of it
+ *
+ * Tell the TPM library that we want to make use of it, allowing it to
+ * allocate the resources it needs.
+ */
+int tpm_library_use(void)
 {
+	struct crypto_shash *hashalg = NULL;
+	struct crypto_shash *hmacalg = NULL;
 	int ret;
 
-	hmacalg = crypto_alloc_shash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
+	if (atomic_inc_not_zero(&tpm_library_usage))
+		return 0;
+
+	/* We don't want to hold a mutex whilst allocating a crypto
+	 * object as it may have to call up to userspace.
+	 */
+	hmacalg = crypto_alloc_shash(tpm_hmac_alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hmacalg)) {
-		pr_info("trusted_key: could not allocate crypto %s\n",
-			hmac_alg);
-		return PTR_ERR(hmacalg);
+		pr_info("Could not allocate crypto %s\n", tpm_hmac_alg);
+		ret = PTR_ERR(hmacalg);
+		goto hmacalg_fail;
 	}
 
-	hashalg = crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
+	hashalg = crypto_alloc_shash(tpm_hash_alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hashalg)) {
-		pr_info("trusted_key: could not allocate crypto %s\n",
-			hash_alg);
+		pr_info("Could not allocate crypto %s\n", tpm_hash_alg);
 		ret = PTR_ERR(hashalg);
 		goto hashalg_fail;
 	}
 
+	mutex_lock(&tpm_library_init_mutex);
+
+	if (atomic_inc_return(&tpm_library_usage) == 1) {
+		tpm_hmacalg = hmacalg;
+		tpm_hashalg = hashalg;
+	} else {
+		crypto_free_shash(hashalg);
+		crypto_free_shash(hmacalg);
+	}
+
+	mutex_unlock(&tpm_library_init_mutex);
 	return 0;
 
 hashalg_fail:
-	crypto_free_shash(hmacalg);
+	crypto_free_shash(tpm_hmacalg);
+hmacalg_fail:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(trusted_shash_alloc);
+EXPORT_SYMBOL_GPL(tpm_library_use);
+
+/**
+ * tpm_library_unuse - Tell the TPM library we've finished with it
+ *
+ * Tell the TPM library we've finished with it, allowing it to free the
+ * resources it had allocated.
+ */
+void tpm_library_unuse(void)
+{
+	if (atomic_add_unless(&tpm_library_usage, -1, 1))
+		return;
+
+	mutex_lock(&tpm_library_init_mutex);
+
+	if (atomic_dec_and_test(&tpm_library_usage)) {
+		crypto_free_shash(tpm_hashalg);
+		crypto_free_shash(tpm_hmacalg);
+	}
+
+	mutex_unlock(&tpm_library_init_mutex);
+}
+EXPORT_SYMBOL_GPL(tpm_library_unuse);
diff --git a/drivers/char/tpm/tpm-library.h b/drivers/char/tpm/tpm-library.h
index eec1dfe26c2a..6f7571cc6d6c 100644
--- a/drivers/char/tpm/tpm-library.h
+++ b/drivers/char/tpm/tpm-library.h
@@ -15,7 +15,7 @@
 #define LOAD32N(buffer, offset)	(*(uint32_t *)&buffer[offset])
 #define LOAD16(buffer, offset)	(ntohs(*(uint16_t *)&buffer[offset]))
 
-struct osapsess {
+struct tpm_osapsess {
 	uint32_t handle;
 	unsigned char secret[SHA1_DIGEST_SIZE];
 	unsigned char enonce[TPM_NONCE_SIZE];
@@ -51,14 +51,14 @@ static inline void storebytes(struct tpm_buf *buf, const unsigned char *in,
 #define TPM_DEBUG 0
 
 #ifdef TPM_DEBUG
-static inline void dump_sess(struct osapsess *s)
+static inline void dump_sess(struct tpm_osapsess *s)
 {
-	print_hex_dump(KERN_INFO, "trusted-key: handle ", DUMP_PREFIX_NONE,
+	print_hex_dump(KERN_INFO, "handle ", DUMP_PREFIX_NONE,
 		       16, 1, &s->handle, 4, 0);
-	pr_info("trusted-key: secret:\n");
+	pr_info("secret:\n");
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
 		       16, 1, &s->secret, SHA1_DIGEST_SIZE, 0);
-	pr_info("trusted-key: enonce:\n");
+	pr_info("enonce:\n");
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
 		       16, 1, &s->enonce, SHA1_DIGEST_SIZE, 0);
 }
@@ -67,13 +67,13 @@ static inline void dump_tpm_buf(unsigned char *buf)
 {
 	int len;
 
-	pr_info("\ntrusted-key: tpm buffer\n");
+	pr_info("\ntpm buffer\n");
 	len = LOAD32(buf, TPM_SIZE_OFFSET);
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, buf, len, 0);
 }
 
 #else
-static inline void dump_sess(struct osapsess *s)
+static inline void dump_sess(struct tpm_osapsess *s)
 {
 }
 
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 5d8caf56c272..b08539920f76 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -100,8 +100,8 @@ struct tpm_buf {
 
 #define INIT_BUF(tb) (tb->len = 0)
 
-extern void trusted_shash_release(void);
-extern int trusted_shash_alloc(void);
+extern int tpm_library_use(void);
+extern void tpm_library_unuse(void);
 
 extern int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 		    uint32_t keyhandle, const unsigned char *keyauth,
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 83c6a485e62a..3afb152a6ae2 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -521,19 +521,19 @@ static int __init init_trusted(void)
 {
 	int ret;
 
-	ret = trusted_shash_alloc();
+	ret = tpm_library_use();
 	if (ret < 0)
 		return ret;
 	ret = register_key_type(&key_type_trusted);
 	if (ret < 0)
-		trusted_shash_release();
+		tpm_library_unuse();
 	return ret;
 }
 
 static void __exit cleanup_trusted(void)
 {
-	trusted_shash_release();
 	unregister_key_type(&key_type_trusted);
+	tpm_library_unuse();
 }
 
 late_initcall(init_trusted);


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
