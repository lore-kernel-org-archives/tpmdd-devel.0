From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/23] TPMLIB: Break TPM bits out of
 security/keys/trusted.c
Date: Tue, 21 Aug 2018 16:57:43 +0100
Message-ID: <153486706322.13066.3105842100625841410.stgit@warthog.procyon.org.uk>
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

Break the TPM bits out of security/keys/trusted.c into their own call wrapper
library.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/Makefile      |    2 
 drivers/char/tpm/tpm-library.c |  682 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-library.h |   83 +++++
 include/linux/tpm.h            |   38 ++
 security/keys/trusted.c        |  646 --------------------------------------
 security/keys/trusted.h        |   80 -----
 6 files changed, 804 insertions(+), 727 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-library.c
 create mode 100644 drivers/char/tpm/tpm-library.h

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index b179052cd81b..cea6a4d05920 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-library.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
new file mode 100644
index 000000000000..1be4f71cabcb
--- /dev/null
+++ b/drivers/char/tpm/tpm-library.c
@@ -0,0 +1,682 @@
+/* TPM call wrapper library.
+ *
+ * Copyright (C) 2010 IBM Corporation
+ *
+ * Author:
+ * David Safford <safford-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * See Documentation/security/keys-trusted-encrypted.txt
+ */
+
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
+#include <linux/string.h>
+#include <linux/err.h>
+#include <keys/user-type.h>
+#include <keys/trusted-type.h>
+#include <linux/key-type.h>
+#include <linux/rcupdate.h>
+#include <linux/crypto.h>
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+#include <linux/capability.h>
+#include <linux/tpm.h>
+#include <linux/tpm_command.h>
+
+#include "tpm-library.h"
+
+static const char hmac_alg[] = "hmac(sha1)";
+static const char hash_alg[] = "sha1";
+
+struct sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+static struct crypto_shash *hashalg;
+static struct crypto_shash *hmacalg;
+
+static struct sdesc *init_sdesc(struct crypto_shash *alg)
+{
+	struct sdesc *sdesc;
+	int size;
+
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc)
+		return ERR_PTR(-ENOMEM);
+	sdesc->shash.tfm = alg;
+	sdesc->shash.flags = 0x0;
+	return sdesc;
+}
+
+static int TSS_sha1(const unsigned char *data, unsigned int datalen,
+		    unsigned char *digest)
+{
+	struct sdesc *sdesc;
+	int ret;
+
+	sdesc = init_sdesc(hashalg);
+	if (IS_ERR(sdesc)) {
+		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		return PTR_ERR(sdesc);
+	}
+
+	ret = crypto_shash_digest(&sdesc->shash, data, datalen, digest);
+	kfree(sdesc);
+	return ret;
+}
+
+static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
+		       unsigned int keylen, ...)
+{
+	struct sdesc *sdesc;
+	va_list argp;
+	unsigned int dlen;
+	unsigned char *data;
+	int ret;
+
+	sdesc = init_sdesc(hmacalg);
+	if (IS_ERR(sdesc)) {
+		pr_info("trusted_key: can't alloc %s\n", hmac_alg);
+		return PTR_ERR(sdesc);
+	}
+
+	ret = crypto_shash_setkey(hmacalg, key, keylen);
+	if (ret < 0)
+		goto out;
+	ret = crypto_shash_init(&sdesc->shash);
+	if (ret < 0)
+		goto out;
+
+	va_start(argp, keylen);
+	for (;;) {
+		dlen = va_arg(argp, unsigned int);
+		if (dlen == 0)
+			break;
+		data = va_arg(argp, unsigned char *);
+		if (data == NULL) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = crypto_shash_update(&sdesc->shash, data, dlen);
+		if (ret < 0)
+			break;
+	}
+	va_end(argp);
+	if (!ret)
+		ret = crypto_shash_final(&sdesc->shash, digest);
+out:
+	kfree(sdesc);
+	return ret;
+}
+
+/*
+ * calculate authorization info fields to send to TPM
+ */
+static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
+			unsigned int keylen, unsigned char *h1,
+			unsigned char *h2, unsigned char h3, ...)
+{
+	unsigned char paramdigest[SHA1_DIGEST_SIZE];
+	struct sdesc *sdesc;
+	unsigned int dlen;
+	unsigned char *data;
+	unsigned char c;
+	int ret;
+	va_list argp;
+
+	sdesc = init_sdesc(hashalg);
+	if (IS_ERR(sdesc)) {
+		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		return PTR_ERR(sdesc);
+	}
+
+	c = h3;
+	ret = crypto_shash_init(&sdesc->shash);
+	if (ret < 0)
+		goto out;
+	va_start(argp, h3);
+	for (;;) {
+		dlen = va_arg(argp, unsigned int);
+		if (dlen == 0)
+			break;
+		data = va_arg(argp, unsigned char *);
+		if (!data) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = crypto_shash_update(&sdesc->shash, data, dlen);
+		if (ret < 0)
+			break;
+	}
+	va_end(argp);
+	if (!ret)
+		ret = crypto_shash_final(&sdesc->shash, paramdigest);
+	if (!ret)
+		ret = TSS_rawhmac(digest, key, keylen, SHA1_DIGEST_SIZE,
+				  paramdigest, TPM_NONCE_SIZE, h1,
+				  TPM_NONCE_SIZE, h2, 1, &c, 0, 0);
+out:
+	kfree(sdesc);
+	return ret;
+}
+
+/*
+ * verify the AUTH1_COMMAND (Seal) result from TPM
+ */
+static int TSS_checkhmac1(unsigned char *buffer,
+			  const uint32_t command,
+			  const unsigned char *ononce,
+			  const unsigned char *key,
+			  unsigned int keylen, ...)
+{
+	uint32_t bufsize;
+	uint16_t tag;
+	uint32_t ordinal;
+	uint32_t result;
+	unsigned char *enonce;
+	unsigned char *continueflag;
+	unsigned char *authdata;
+	unsigned char testhmac[SHA1_DIGEST_SIZE];
+	unsigned char paramdigest[SHA1_DIGEST_SIZE];
+	struct sdesc *sdesc;
+	unsigned int dlen;
+	unsigned int dpos;
+	va_list argp;
+	int ret;
+
+	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
+	tag = LOAD16(buffer, 0);
+	ordinal = command;
+	result = LOAD32N(buffer, TPM_RETURN_OFFSET);
+	if (tag == TPM_TAG_RSP_COMMAND)
+		return 0;
+	if (tag != TPM_TAG_RSP_AUTH1_COMMAND)
+		return -EINVAL;
+	authdata = buffer + bufsize - SHA1_DIGEST_SIZE;
+	continueflag = authdata - 1;
+	enonce = continueflag - TPM_NONCE_SIZE;
+
+	sdesc = init_sdesc(hashalg);
+	if (IS_ERR(sdesc)) {
+		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		return PTR_ERR(sdesc);
+	}
+	ret = crypto_shash_init(&sdesc->shash);
+	if (ret < 0)
+		goto out;
+	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&result,
+				  sizeof result);
+	if (ret < 0)
+		goto out;
+	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&ordinal,
+				  sizeof ordinal);
+	if (ret < 0)
+		goto out;
+	va_start(argp, keylen);
+	for (;;) {
+		dlen = va_arg(argp, unsigned int);
+		if (dlen == 0)
+			break;
+		dpos = va_arg(argp, unsigned int);
+		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
+		if (ret < 0)
+			break;
+	}
+	va_end(argp);
+	if (!ret)
+		ret = crypto_shash_final(&sdesc->shash, paramdigest);
+	if (ret < 0)
+		goto out;
+
+	ret = TSS_rawhmac(testhmac, key, keylen, SHA1_DIGEST_SIZE, paramdigest,
+			  TPM_NONCE_SIZE, enonce, TPM_NONCE_SIZE, ononce,
+			  1, continueflag, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	if (memcmp(testhmac, authdata, SHA1_DIGEST_SIZE))
+		ret = -EINVAL;
+out:
+	kfree(sdesc);
+	return ret;
+}
+
+/*
+ * verify the AUTH2_COMMAND (unseal) result from TPM
+ */
+static int TSS_checkhmac2(unsigned char *buffer,
+			  const uint32_t command,
+			  const unsigned char *ononce,
+			  const unsigned char *key1,
+			  unsigned int keylen1,
+			  const unsigned char *key2,
+			  unsigned int keylen2, ...)
+{
+	uint32_t bufsize;
+	uint16_t tag;
+	uint32_t ordinal;
+	uint32_t result;
+	unsigned char *enonce1;
+	unsigned char *continueflag1;
+	unsigned char *authdata1;
+	unsigned char *enonce2;
+	unsigned char *continueflag2;
+	unsigned char *authdata2;
+	unsigned char testhmac1[SHA1_DIGEST_SIZE];
+	unsigned char testhmac2[SHA1_DIGEST_SIZE];
+	unsigned char paramdigest[SHA1_DIGEST_SIZE];
+	struct sdesc *sdesc;
+	unsigned int dlen;
+	unsigned int dpos;
+	va_list argp;
+	int ret;
+
+	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
+	tag = LOAD16(buffer, 0);
+	ordinal = command;
+	result = LOAD32N(buffer, TPM_RETURN_OFFSET);
+
+	if (tag == TPM_TAG_RSP_COMMAND)
+		return 0;
+	if (tag != TPM_TAG_RSP_AUTH2_COMMAND)
+		return -EINVAL;
+	authdata1 = buffer + bufsize - (SHA1_DIGEST_SIZE + 1
+			+ SHA1_DIGEST_SIZE + SHA1_DIGEST_SIZE);
+	authdata2 = buffer + bufsize - (SHA1_DIGEST_SIZE);
+	continueflag1 = authdata1 - 1;
+	continueflag2 = authdata2 - 1;
+	enonce1 = continueflag1 - TPM_NONCE_SIZE;
+	enonce2 = continueflag2 - TPM_NONCE_SIZE;
+
+	sdesc = init_sdesc(hashalg);
+	if (IS_ERR(sdesc)) {
+		pr_info("trusted_key: can't alloc %s\n", hash_alg);
+		return PTR_ERR(sdesc);
+	}
+	ret = crypto_shash_init(&sdesc->shash);
+	if (ret < 0)
+		goto out;
+	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&result,
+				  sizeof result);
+	if (ret < 0)
+		goto out;
+	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&ordinal,
+				  sizeof ordinal);
+	if (ret < 0)
+		goto out;
+
+	va_start(argp, keylen2);
+	for (;;) {
+		dlen = va_arg(argp, unsigned int);
+		if (dlen == 0)
+			break;
+		dpos = va_arg(argp, unsigned int);
+		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
+		if (ret < 0)
+			break;
+	}
+	va_end(argp);
+	if (!ret)
+		ret = crypto_shash_final(&sdesc->shash, paramdigest);
+	if (ret < 0)
+		goto out;
+
+	ret = TSS_rawhmac(testhmac1, key1, keylen1, SHA1_DIGEST_SIZE,
+			  paramdigest, TPM_NONCE_SIZE, enonce1,
+			  TPM_NONCE_SIZE, ononce, 1, continueflag1, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (memcmp(testhmac1, authdata1, SHA1_DIGEST_SIZE)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	ret = TSS_rawhmac(testhmac2, key2, keylen2, SHA1_DIGEST_SIZE,
+			  paramdigest, TPM_NONCE_SIZE, enonce2,
+			  TPM_NONCE_SIZE, ononce, 1, continueflag2, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (memcmp(testhmac2, authdata2, SHA1_DIGEST_SIZE))
+		ret = -EINVAL;
+out:
+	kfree(sdesc);
+	return ret;
+}
+
+/*
+ * For key specific tpm requests, we will generate and send our
+ * own TPM command packets using the drivers send function.
+ */
+static int trusted_tpm_send(struct tpm_chip *chip, unsigned char *cmd,
+			    size_t buflen, const char *desc)
+{
+	int rc;
+
+	dump_tpm_buf(cmd);
+	rc = tpm_send_command(chip, cmd, buflen, desc);
+	dump_tpm_buf(cmd);
+	if (rc > 0)
+		/* Can't return positive return codes values to keyctl */
+		rc = -EPERM;
+	return rc;
+}
+
+/*
+ * Create an object specific authorisation protocol (OSAP) session
+ */
+static int osap(struct tpm_chip *chip,
+		struct tpm_buf *tb, struct osapsess *s,
+		const unsigned char *key, uint16_t type, uint32_t handle)
+{
+	unsigned char enonce[TPM_NONCE_SIZE];
+	unsigned char ononce[TPM_NONCE_SIZE];
+	int ret;
+
+	ret = tpm_get_random(chip, ononce, TPM_NONCE_SIZE);
+	if (ret != TPM_NONCE_SIZE)
+		return ret;
+
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_COMMAND);
+	store32(tb, TPM_OSAP_SIZE);
+	store32(tb, TPM_ORD_OSAP);
+	store16(tb, type);
+	store32(tb, handle);
+	storebytes(tb, ononce, TPM_NONCE_SIZE);
+
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
+			       "creating OSAP session");
+	if (ret < 0)
+		return ret;
+
+	s->handle = LOAD32(tb->data, TPM_DATA_OFFSET);
+	memcpy(s->enonce, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)]),
+	       TPM_NONCE_SIZE);
+	memcpy(enonce, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t) +
+				  TPM_NONCE_SIZE]), TPM_NONCE_SIZE);
+	return TSS_rawhmac(s->secret, key, SHA1_DIGEST_SIZE, TPM_NONCE_SIZE,
+			   enonce, TPM_NONCE_SIZE, ononce, 0, 0);
+}
+
+/*
+ * Create an object independent authorisation protocol (oiap) session
+ */
+static int oiap(struct tpm_chip *chip, struct tpm_buf *tb, uint32_t *handle,
+		unsigned char *nonce)
+{
+	int ret;
+
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_COMMAND);
+	store32(tb, TPM_OIAP_SIZE);
+	store32(tb, TPM_ORD_OIAP);
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
+			       "creating OIAP session");
+	if (ret < 0)
+		return ret;
+
+	*handle = LOAD32(tb->data, TPM_DATA_OFFSET);
+	memcpy(nonce, &tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)],
+	       TPM_NONCE_SIZE);
+	return 0;
+}
+
+struct tpm_digests {
+	unsigned char encauth[SHA1_DIGEST_SIZE];
+	unsigned char pubauth[SHA1_DIGEST_SIZE];
+	unsigned char xorwork[SHA1_DIGEST_SIZE * 2];
+	unsigned char xorhash[SHA1_DIGEST_SIZE];
+	unsigned char nonceodd[TPM_NONCE_SIZE];
+};
+
+/*
+ * Have the TPM seal(encrypt) the trusted key, possibly based on
+ * Platform Configuration Registers (PCRs). AUTH1 for sealing key.
+ */
+int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
+	     uint32_t keyhandle, const unsigned char *keyauth,
+	     const unsigned char *data, uint32_t datalen,
+	     unsigned char *blob, uint32_t *bloblen,
+	     const unsigned char *blobauth,
+	     const unsigned char *pcrinfo, uint32_t pcrinfosize)
+{
+	struct osapsess sess;
+	struct tpm_digests *td;
+	unsigned char cont;
+	uint32_t ordinal;
+	uint32_t pcrsize;
+	uint32_t datsize;
+	int sealinfosize;
+	int encdatasize;
+	int storedsize;
+	int ret;
+	int i;
+
+	/* alloc some work space for all the hashes */
+	td = kmalloc(sizeof *td, GFP_KERNEL);
+	if (!td)
+		return -ENOMEM;
+
+	/* get session for sealing key */
+	ret = osap(chip, tb, &sess, keyauth, keytype, keyhandle);
+	if (ret < 0)
+		goto out;
+	dump_sess(&sess);
+
+	/* calculate encrypted authorization value */
+	memcpy(td->xorwork, sess.secret, SHA1_DIGEST_SIZE);
+	memcpy(td->xorwork + SHA1_DIGEST_SIZE, sess.enonce, SHA1_DIGEST_SIZE);
+	ret = TSS_sha1(td->xorwork, SHA1_DIGEST_SIZE * 2, td->xorhash);
+	if (ret < 0)
+		goto out;
+
+	ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
+	if (ret != TPM_NONCE_SIZE)
+		goto out;
+	ordinal = htonl(TPM_ORD_SEAL);
+	datsize = htonl(datalen);
+	pcrsize = htonl(pcrinfosize);
+	cont = 0;
+
+	/* encrypt data authorization key */
+	for (i = 0; i < SHA1_DIGEST_SIZE; ++i)
+		td->encauth[i] = td->xorhash[i] ^ blobauth[i];
+
+	/* calculate authorization HMAC value */
+	if (pcrinfosize == 0) {
+		/* no pcr info specified */
+		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
+				   sess.enonce, td->nonceodd, cont,
+				   sizeof(uint32_t), &ordinal, SHA1_DIGEST_SIZE,
+				   td->encauth, sizeof(uint32_t), &pcrsize,
+				   sizeof(uint32_t), &datsize, datalen, data, 0,
+				   0);
+	} else {
+		/* pcr info specified */
+		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
+				   sess.enonce, td->nonceodd, cont,
+				   sizeof(uint32_t), &ordinal, SHA1_DIGEST_SIZE,
+				   td->encauth, sizeof(uint32_t), &pcrsize,
+				   pcrinfosize, pcrinfo, sizeof(uint32_t),
+				   &datsize, datalen, data, 0, 0);
+	}
+	if (ret < 0)
+		goto out;
+
+	/* build and send the TPM request packet */
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_AUTH1_COMMAND);
+	store32(tb, TPM_SEAL_SIZE + pcrinfosize + datalen);
+	store32(tb, TPM_ORD_SEAL);
+	store32(tb, keyhandle);
+	storebytes(tb, td->encauth, SHA1_DIGEST_SIZE);
+	store32(tb, pcrinfosize);
+	storebytes(tb, pcrinfo, pcrinfosize);
+	store32(tb, datalen);
+	storebytes(tb, data, datalen);
+	store32(tb, sess.handle);
+	storebytes(tb, td->nonceodd, TPM_NONCE_SIZE);
+	store8(tb, cont);
+	storebytes(tb, td->pubauth, SHA1_DIGEST_SIZE);
+
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
+			       "sealing data");
+	if (ret < 0)
+		goto out;
+
+	/* calculate the size of the returned Blob */
+	sealinfosize = LOAD32(tb->data, TPM_DATA_OFFSET + sizeof(uint32_t));
+	encdatasize = LOAD32(tb->data, TPM_DATA_OFFSET + sizeof(uint32_t) +
+			     sizeof(uint32_t) + sealinfosize);
+	storedsize = sizeof(uint32_t) + sizeof(uint32_t) + sealinfosize +
+	    sizeof(uint32_t) + encdatasize;
+
+	/* check the HMAC in the response */
+	ret = TSS_checkhmac1(tb->data, ordinal, td->nonceodd, sess.secret,
+			     SHA1_DIGEST_SIZE, storedsize, TPM_DATA_OFFSET, 0,
+			     0);
+
+	/* copy the returned blob to caller */
+	if (!ret) {
+		memcpy(blob, tb->data + TPM_DATA_OFFSET, storedsize);
+		*bloblen = storedsize;
+	}
+out:
+	kfree(td);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tpm_seal);
+
+/*
+ * use the AUTH2_COMMAND form of unseal, to authorize both key and blob
+ */
+int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
+	       uint32_t keyhandle, const unsigned char *keyauth,
+	       const unsigned char *blob, int bloblen,
+	       const unsigned char *blobauth,
+	       unsigned char *data, unsigned int *datalen)
+{
+	unsigned char nonceodd[TPM_NONCE_SIZE];
+	unsigned char enonce1[TPM_NONCE_SIZE];
+	unsigned char enonce2[TPM_NONCE_SIZE];
+	unsigned char authdata1[SHA1_DIGEST_SIZE];
+	unsigned char authdata2[SHA1_DIGEST_SIZE];
+	uint32_t authhandle1 = 0;
+	uint32_t authhandle2 = 0;
+	unsigned char cont = 0;
+	uint32_t ordinal;
+	uint32_t keyhndl;
+	int ret;
+
+	/* sessions for unsealing key and data */
+	ret = oiap(chip, tb, &authhandle1, enonce1);
+	if (ret < 0) {
+		pr_info("trusted_key: oiap failed (%d)\n", ret);
+		return ret;
+	}
+	ret = oiap(chip, tb, &authhandle2, enonce2);
+	if (ret < 0) {
+		pr_info("trusted_key: oiap failed (%d)\n", ret);
+		return ret;
+	}
+
+	ordinal = htonl(TPM_ORD_UNSEAL);
+	keyhndl = htonl(SRKHANDLE);
+	ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
+	if (ret != TPM_NONCE_SIZE) {
+		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
+		return ret;
+	}
+	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
+			   enonce1, nonceodd, cont, sizeof(uint32_t),
+			   &ordinal, bloblen, blob, 0, 0);
+	if (ret < 0)
+		return ret;
+	ret = TSS_authhmac(authdata2, blobauth, TPM_NONCE_SIZE,
+			   enonce2, nonceodd, cont, sizeof(uint32_t),
+			   &ordinal, bloblen, blob, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	/* build and send TPM request packet */
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_AUTH2_COMMAND);
+	store32(tb, TPM_UNSEAL_SIZE + bloblen);
+	store32(tb, TPM_ORD_UNSEAL);
+	store32(tb, keyhandle);
+	storebytes(tb, blob, bloblen);
+	store32(tb, authhandle1);
+	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
+	store8(tb, cont);
+	storebytes(tb, authdata1, SHA1_DIGEST_SIZE);
+	store32(tb, authhandle2);
+	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
+	store8(tb, cont);
+	storebytes(tb, authdata2, SHA1_DIGEST_SIZE);
+
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
+			       "unsealing data");
+	if (ret < 0) {
+		pr_info("trusted_key: authhmac failed (%d)\n", ret);
+		return ret;
+	}
+
+	*datalen = LOAD32(tb->data, TPM_DATA_OFFSET);
+	ret = TSS_checkhmac2(tb->data, ordinal, nonceodd,
+			     keyauth, SHA1_DIGEST_SIZE,
+			     blobauth, SHA1_DIGEST_SIZE,
+			     sizeof(uint32_t), TPM_DATA_OFFSET,
+			     *datalen, TPM_DATA_OFFSET + sizeof(uint32_t), 0,
+			     0);
+	if (ret < 0) {
+		pr_info("trusted_key: TSS_checkhmac2 failed (%d)\n", ret);
+		return ret;
+	}
+	memcpy(data, tb->data + TPM_DATA_OFFSET + sizeof(uint32_t), *datalen);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tpm_unseal);
+
+void trusted_shash_release(void)
+{
+	if (hashalg)
+		crypto_free_shash(hashalg);
+	if (hmacalg)
+		crypto_free_shash(hmacalg);
+}
+EXPORT_SYMBOL_GPL(trusted_shash_release);
+
+int trusted_shash_alloc(void)
+{
+	int ret;
+
+	hmacalg = crypto_alloc_shash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(hmacalg)) {
+		pr_info("trusted_key: could not allocate crypto %s\n",
+			hmac_alg);
+		return PTR_ERR(hmacalg);
+	}
+
+	hashalg = crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(hashalg)) {
+		pr_info("trusted_key: could not allocate crypto %s\n",
+			hash_alg);
+		ret = PTR_ERR(hashalg);
+		goto hashalg_fail;
+	}
+
+	return 0;
+
+hashalg_fail:
+	crypto_free_shash(hmacalg);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(trusted_shash_alloc);
diff --git a/drivers/char/tpm/tpm-library.h b/drivers/char/tpm/tpm-library.h
new file mode 100644
index 000000000000..eec1dfe26c2a
--- /dev/null
+++ b/drivers/char/tpm/tpm-library.h
@@ -0,0 +1,83 @@
+/* TPM call wrapper library internal definitions.
+ *
+ * Copyright (C) 2010 IBM Corporation
+ *
+ * Author:
+ * David Safford <safford-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+
+
+#define LOAD32(buffer, offset)	(ntohl(*(uint32_t *)&buffer[offset]))
+#define LOAD32N(buffer, offset)	(*(uint32_t *)&buffer[offset])
+#define LOAD16(buffer, offset)	(ntohs(*(uint16_t *)&buffer[offset]))
+
+struct osapsess {
+	uint32_t handle;
+	unsigned char secret[SHA1_DIGEST_SIZE];
+	unsigned char enonce[TPM_NONCE_SIZE];
+};
+
+static inline void store8(struct tpm_buf *buf, const unsigned char value)
+{
+	buf->data[buf->len++] = value;
+}
+
+static inline void store16(struct tpm_buf *buf, const uint16_t value)
+{
+	*(uint16_t *) & buf->data[buf->len] = htons(value);
+	buf->len += sizeof value;
+}
+
+static inline void store32(struct tpm_buf *buf, const uint32_t value)
+{
+	*(uint32_t *) & buf->data[buf->len] = htonl(value);
+	buf->len += sizeof value;
+}
+
+static inline void storebytes(struct tpm_buf *buf, const unsigned char *in,
+			      const int len)
+{
+	memcpy(buf->data + buf->len, in, len);
+	buf->len += len;
+}
+
+/*
+ * Debugging
+ */
+#define TPM_DEBUG 0
+
+#ifdef TPM_DEBUG
+static inline void dump_sess(struct osapsess *s)
+{
+	print_hex_dump(KERN_INFO, "trusted-key: handle ", DUMP_PREFIX_NONE,
+		       16, 1, &s->handle, 4, 0);
+	pr_info("trusted-key: secret:\n");
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
+		       16, 1, &s->secret, SHA1_DIGEST_SIZE, 0);
+	pr_info("trusted-key: enonce:\n");
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
+		       16, 1, &s->enonce, SHA1_DIGEST_SIZE, 0);
+}
+
+static inline void dump_tpm_buf(unsigned char *buf)
+{
+	int len;
+
+	pr_info("\ntrusted-key: tpm buffer\n");
+	len = LOAD32(buf, TPM_SIZE_OFFSET);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, buf, len, 0);
+}
+
+#else
+static inline void dump_sess(struct osapsess *s)
+{
+}
+
+static inline void dump_tpm_buf(unsigned char *buf)
+{
+}
+#endif
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index f4e14405f5cf..5d8caf56c272 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -77,4 +77,42 @@ static inline int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max) {
 	return -ENODEV;
 }
 #endif
+
+/*
+ * TPM call library.
+ */
+/* implementation specific TPM constants */
+#define MAX_PCRINFO_SIZE		64
+#define MAX_BUF_SIZE			512
+#define TPM_GETRANDOM_SIZE		14
+#define TPM_OSAP_SIZE			36
+#define TPM_OIAP_SIZE			10
+#define TPM_SEAL_SIZE			87
+#define TPM_UNSEAL_SIZE			104
+#define TPM_SIZE_OFFSET			2
+#define TPM_RETURN_OFFSET		6
+#define TPM_DATA_OFFSET			10
+
+struct tpm_buf {
+	int len;
+	unsigned char data[MAX_BUF_SIZE];
+};
+
+#define INIT_BUF(tb) (tb->len = 0)
+
+extern void trusted_shash_release(void);
+extern int trusted_shash_alloc(void);
+
+extern int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
+		    uint32_t keyhandle, const unsigned char *keyauth,
+		    const unsigned char *data, uint32_t datalen,
+		    unsigned char *blob, uint32_t *bloblen,
+		    const unsigned char *blobauth,
+		    const unsigned char *pcrinfo, uint32_t pcrinfosize);
+extern int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
+		      uint32_t keyhandle, const unsigned char *keyauth,
+		      const unsigned char *blob, int bloblen,
+		      const unsigned char *blobauth,
+		      unsigned char *data, unsigned int *datalen);
+
 #endif
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 943c65b53201..83c6a485e62a 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -31,343 +31,6 @@
 
 #include "trusted.h"
 
-static const char hmac_alg[] = "hmac(sha1)";
-static const char hash_alg[] = "sha1";
-
-struct sdesc {
-	struct shash_desc shash;
-	char ctx[];
-};
-
-static struct crypto_shash *hashalg;
-static struct crypto_shash *hmacalg;
-
-static struct sdesc *init_sdesc(struct crypto_shash *alg)
-{
-	struct sdesc *sdesc;
-	int size;
-
-	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
-	sdesc = kmalloc(size, GFP_KERNEL);
-	if (!sdesc)
-		return ERR_PTR(-ENOMEM);
-	sdesc->shash.tfm = alg;
-	sdesc->shash.flags = 0x0;
-	return sdesc;
-}
-
-static int TSS_sha1(const unsigned char *data, unsigned int datalen,
-		    unsigned char *digest)
-{
-	struct sdesc *sdesc;
-	int ret;
-
-	sdesc = init_sdesc(hashalg);
-	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
-		return PTR_ERR(sdesc);
-	}
-
-	ret = crypto_shash_digest(&sdesc->shash, data, datalen, digest);
-	kfree(sdesc);
-	return ret;
-}
-
-static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
-		       unsigned int keylen, ...)
-{
-	struct sdesc *sdesc;
-	va_list argp;
-	unsigned int dlen;
-	unsigned char *data;
-	int ret;
-
-	sdesc = init_sdesc(hmacalg);
-	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hmac_alg);
-		return PTR_ERR(sdesc);
-	}
-
-	ret = crypto_shash_setkey(hmacalg, key, keylen);
-	if (ret < 0)
-		goto out;
-	ret = crypto_shash_init(&sdesc->shash);
-	if (ret < 0)
-		goto out;
-
-	va_start(argp, keylen);
-	for (;;) {
-		dlen = va_arg(argp, unsigned int);
-		if (dlen == 0)
-			break;
-		data = va_arg(argp, unsigned char *);
-		if (data == NULL) {
-			ret = -EINVAL;
-			break;
-		}
-		ret = crypto_shash_update(&sdesc->shash, data, dlen);
-		if (ret < 0)
-			break;
-	}
-	va_end(argp);
-	if (!ret)
-		ret = crypto_shash_final(&sdesc->shash, digest);
-out:
-	kfree(sdesc);
-	return ret;
-}
-
-/*
- * calculate authorization info fields to send to TPM
- */
-static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
-			unsigned int keylen, unsigned char *h1,
-			unsigned char *h2, unsigned char h3, ...)
-{
-	unsigned char paramdigest[SHA1_DIGEST_SIZE];
-	struct sdesc *sdesc;
-	unsigned int dlen;
-	unsigned char *data;
-	unsigned char c;
-	int ret;
-	va_list argp;
-
-	sdesc = init_sdesc(hashalg);
-	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
-		return PTR_ERR(sdesc);
-	}
-
-	c = h3;
-	ret = crypto_shash_init(&sdesc->shash);
-	if (ret < 0)
-		goto out;
-	va_start(argp, h3);
-	for (;;) {
-		dlen = va_arg(argp, unsigned int);
-		if (dlen == 0)
-			break;
-		data = va_arg(argp, unsigned char *);
-		if (!data) {
-			ret = -EINVAL;
-			break;
-		}
-		ret = crypto_shash_update(&sdesc->shash, data, dlen);
-		if (ret < 0)
-			break;
-	}
-	va_end(argp);
-	if (!ret)
-		ret = crypto_shash_final(&sdesc->shash, paramdigest);
-	if (!ret)
-		ret = TSS_rawhmac(digest, key, keylen, SHA1_DIGEST_SIZE,
-				  paramdigest, TPM_NONCE_SIZE, h1,
-				  TPM_NONCE_SIZE, h2, 1, &c, 0, 0);
-out:
-	kfree(sdesc);
-	return ret;
-}
-
-/*
- * verify the AUTH1_COMMAND (Seal) result from TPM
- */
-static int TSS_checkhmac1(unsigned char *buffer,
-			  const uint32_t command,
-			  const unsigned char *ononce,
-			  const unsigned char *key,
-			  unsigned int keylen, ...)
-{
-	uint32_t bufsize;
-	uint16_t tag;
-	uint32_t ordinal;
-	uint32_t result;
-	unsigned char *enonce;
-	unsigned char *continueflag;
-	unsigned char *authdata;
-	unsigned char testhmac[SHA1_DIGEST_SIZE];
-	unsigned char paramdigest[SHA1_DIGEST_SIZE];
-	struct sdesc *sdesc;
-	unsigned int dlen;
-	unsigned int dpos;
-	va_list argp;
-	int ret;
-
-	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
-	tag = LOAD16(buffer, 0);
-	ordinal = command;
-	result = LOAD32N(buffer, TPM_RETURN_OFFSET);
-	if (tag == TPM_TAG_RSP_COMMAND)
-		return 0;
-	if (tag != TPM_TAG_RSP_AUTH1_COMMAND)
-		return -EINVAL;
-	authdata = buffer + bufsize - SHA1_DIGEST_SIZE;
-	continueflag = authdata - 1;
-	enonce = continueflag - TPM_NONCE_SIZE;
-
-	sdesc = init_sdesc(hashalg);
-	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
-		return PTR_ERR(sdesc);
-	}
-	ret = crypto_shash_init(&sdesc->shash);
-	if (ret < 0)
-		goto out;
-	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&result,
-				  sizeof result);
-	if (ret < 0)
-		goto out;
-	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&ordinal,
-				  sizeof ordinal);
-	if (ret < 0)
-		goto out;
-	va_start(argp, keylen);
-	for (;;) {
-		dlen = va_arg(argp, unsigned int);
-		if (dlen == 0)
-			break;
-		dpos = va_arg(argp, unsigned int);
-		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
-		if (ret < 0)
-			break;
-	}
-	va_end(argp);
-	if (!ret)
-		ret = crypto_shash_final(&sdesc->shash, paramdigest);
-	if (ret < 0)
-		goto out;
-
-	ret = TSS_rawhmac(testhmac, key, keylen, SHA1_DIGEST_SIZE, paramdigest,
-			  TPM_NONCE_SIZE, enonce, TPM_NONCE_SIZE, ononce,
-			  1, continueflag, 0, 0);
-	if (ret < 0)
-		goto out;
-
-	if (memcmp(testhmac, authdata, SHA1_DIGEST_SIZE))
-		ret = -EINVAL;
-out:
-	kfree(sdesc);
-	return ret;
-}
-
-/*
- * verify the AUTH2_COMMAND (unseal) result from TPM
- */
-static int TSS_checkhmac2(unsigned char *buffer,
-			  const uint32_t command,
-			  const unsigned char *ononce,
-			  const unsigned char *key1,
-			  unsigned int keylen1,
-			  const unsigned char *key2,
-			  unsigned int keylen2, ...)
-{
-	uint32_t bufsize;
-	uint16_t tag;
-	uint32_t ordinal;
-	uint32_t result;
-	unsigned char *enonce1;
-	unsigned char *continueflag1;
-	unsigned char *authdata1;
-	unsigned char *enonce2;
-	unsigned char *continueflag2;
-	unsigned char *authdata2;
-	unsigned char testhmac1[SHA1_DIGEST_SIZE];
-	unsigned char testhmac2[SHA1_DIGEST_SIZE];
-	unsigned char paramdigest[SHA1_DIGEST_SIZE];
-	struct sdesc *sdesc;
-	unsigned int dlen;
-	unsigned int dpos;
-	va_list argp;
-	int ret;
-
-	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
-	tag = LOAD16(buffer, 0);
-	ordinal = command;
-	result = LOAD32N(buffer, TPM_RETURN_OFFSET);
-
-	if (tag == TPM_TAG_RSP_COMMAND)
-		return 0;
-	if (tag != TPM_TAG_RSP_AUTH2_COMMAND)
-		return -EINVAL;
-	authdata1 = buffer + bufsize - (SHA1_DIGEST_SIZE + 1
-			+ SHA1_DIGEST_SIZE + SHA1_DIGEST_SIZE);
-	authdata2 = buffer + bufsize - (SHA1_DIGEST_SIZE);
-	continueflag1 = authdata1 - 1;
-	continueflag2 = authdata2 - 1;
-	enonce1 = continueflag1 - TPM_NONCE_SIZE;
-	enonce2 = continueflag2 - TPM_NONCE_SIZE;
-
-	sdesc = init_sdesc(hashalg);
-	if (IS_ERR(sdesc)) {
-		pr_info("trusted_key: can't alloc %s\n", hash_alg);
-		return PTR_ERR(sdesc);
-	}
-	ret = crypto_shash_init(&sdesc->shash);
-	if (ret < 0)
-		goto out;
-	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&result,
-				  sizeof result);
-	if (ret < 0)
-		goto out;
-	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&ordinal,
-				  sizeof ordinal);
-	if (ret < 0)
-		goto out;
-
-	va_start(argp, keylen2);
-	for (;;) {
-		dlen = va_arg(argp, unsigned int);
-		if (dlen == 0)
-			break;
-		dpos = va_arg(argp, unsigned int);
-		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
-		if (ret < 0)
-			break;
-	}
-	va_end(argp);
-	if (!ret)
-		ret = crypto_shash_final(&sdesc->shash, paramdigest);
-	if (ret < 0)
-		goto out;
-
-	ret = TSS_rawhmac(testhmac1, key1, keylen1, SHA1_DIGEST_SIZE,
-			  paramdigest, TPM_NONCE_SIZE, enonce1,
-			  TPM_NONCE_SIZE, ononce, 1, continueflag1, 0, 0);
-	if (ret < 0)
-		goto out;
-	if (memcmp(testhmac1, authdata1, SHA1_DIGEST_SIZE)) {
-		ret = -EINVAL;
-		goto out;
-	}
-	ret = TSS_rawhmac(testhmac2, key2, keylen2, SHA1_DIGEST_SIZE,
-			  paramdigest, TPM_NONCE_SIZE, enonce2,
-			  TPM_NONCE_SIZE, ononce, 1, continueflag2, 0, 0);
-	if (ret < 0)
-		goto out;
-	if (memcmp(testhmac2, authdata2, SHA1_DIGEST_SIZE))
-		ret = -EINVAL;
-out:
-	kfree(sdesc);
-	return ret;
-}
-
-/*
- * For key specific tpm requests, we will generate and send our
- * own TPM command packets using the drivers send function.
- */
-static int trusted_tpm_send(struct tpm_chip *chip, unsigned char *cmd,
-			    size_t buflen, const char *desc)
-{
-	int rc;
-
-	dump_tpm_buf(cmd);
-	rc = tpm_send_command(chip, cmd, buflen, desc);
-	dump_tpm_buf(cmd);
-	if (rc > 0)
-		/* Can't return positive return codes values to keyctl */
-		rc = -EPERM;
-	return rc;
-}
-
 /*
  * Lock a trusted key, by extending a selected PCR.
  *
@@ -387,281 +50,6 @@ static int pcrlock(struct tpm_chip *chip, const int pcrnum)
 	return tpm_pcr_extend(chip, pcrnum, hash) ? -EINVAL : 0;
 }
 
-/*
- * Create an object specific authorisation protocol (OSAP) session
- */
-static int osap(struct tpm_chip *chip,
-		struct tpm_buf *tb, struct osapsess *s,
-		const unsigned char *key, uint16_t type, uint32_t handle)
-{
-	unsigned char enonce[TPM_NONCE_SIZE];
-	unsigned char ononce[TPM_NONCE_SIZE];
-	int ret;
-
-	ret = tpm_get_random(chip, ononce, TPM_NONCE_SIZE);
-	if (ret != TPM_NONCE_SIZE)
-		return ret;
-
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_COMMAND);
-	store32(tb, TPM_OSAP_SIZE);
-	store32(tb, TPM_ORD_OSAP);
-	store16(tb, type);
-	store32(tb, handle);
-	storebytes(tb, ononce, TPM_NONCE_SIZE);
-
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
-			       "creating OSAP session");
-	if (ret < 0)
-		return ret;
-
-	s->handle = LOAD32(tb->data, TPM_DATA_OFFSET);
-	memcpy(s->enonce, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)]),
-	       TPM_NONCE_SIZE);
-	memcpy(enonce, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t) +
-				  TPM_NONCE_SIZE]), TPM_NONCE_SIZE);
-	return TSS_rawhmac(s->secret, key, SHA1_DIGEST_SIZE, TPM_NONCE_SIZE,
-			   enonce, TPM_NONCE_SIZE, ononce, 0, 0);
-}
-
-/*
- * Create an object independent authorisation protocol (oiap) session
- */
-static int oiap(struct tpm_chip *chip, struct tpm_buf *tb, uint32_t *handle,
-		unsigned char *nonce)
-{
-	int ret;
-
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_COMMAND);
-	store32(tb, TPM_OIAP_SIZE);
-	store32(tb, TPM_ORD_OIAP);
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
-			       "creating OIAP session");
-	if (ret < 0)
-		return ret;
-
-	*handle = LOAD32(tb->data, TPM_DATA_OFFSET);
-	memcpy(nonce, &tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)],
-	       TPM_NONCE_SIZE);
-	return 0;
-}
-
-struct tpm_digests {
-	unsigned char encauth[SHA1_DIGEST_SIZE];
-	unsigned char pubauth[SHA1_DIGEST_SIZE];
-	unsigned char xorwork[SHA1_DIGEST_SIZE * 2];
-	unsigned char xorhash[SHA1_DIGEST_SIZE];
-	unsigned char nonceodd[TPM_NONCE_SIZE];
-};
-
-/*
- * Have the TPM seal(encrypt) the trusted key, possibly based on
- * Platform Configuration Registers (PCRs). AUTH1 for sealing key.
- */
-static int tpm_seal(struct tpm_chip *chip,
-		    struct tpm_buf *tb, uint16_t keytype,
-		    uint32_t keyhandle, const unsigned char *keyauth,
-		    const unsigned char *data, uint32_t datalen,
-		    unsigned char *blob, uint32_t *bloblen,
-		    const unsigned char *blobauth,
-		    const unsigned char *pcrinfo, uint32_t pcrinfosize)
-{
-	struct osapsess sess;
-	struct tpm_digests *td;
-	unsigned char cont;
-	uint32_t ordinal;
-	uint32_t pcrsize;
-	uint32_t datsize;
-	int sealinfosize;
-	int encdatasize;
-	int storedsize;
-	int ret;
-	int i;
-
-	/* alloc some work space for all the hashes */
-	td = kmalloc(sizeof *td, GFP_KERNEL);
-	if (!td)
-		return -ENOMEM;
-
-	/* get session for sealing key */
-	ret = osap(chip, tb, &sess, keyauth, keytype, keyhandle);
-	if (ret < 0)
-		goto out;
-	dump_sess(&sess);
-
-	/* calculate encrypted authorization value */
-	memcpy(td->xorwork, sess.secret, SHA1_DIGEST_SIZE);
-	memcpy(td->xorwork + SHA1_DIGEST_SIZE, sess.enonce, SHA1_DIGEST_SIZE);
-	ret = TSS_sha1(td->xorwork, SHA1_DIGEST_SIZE * 2, td->xorhash);
-	if (ret < 0)
-		goto out;
-
-	ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
-	if (ret != TPM_NONCE_SIZE)
-		goto out;
-	ordinal = htonl(TPM_ORD_SEAL);
-	datsize = htonl(datalen);
-	pcrsize = htonl(pcrinfosize);
-	cont = 0;
-
-	/* encrypt data authorization key */
-	for (i = 0; i < SHA1_DIGEST_SIZE; ++i)
-		td->encauth[i] = td->xorhash[i] ^ blobauth[i];
-
-	/* calculate authorization HMAC value */
-	if (pcrinfosize == 0) {
-		/* no pcr info specified */
-		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
-				   sess.enonce, td->nonceodd, cont,
-				   sizeof(uint32_t), &ordinal, SHA1_DIGEST_SIZE,
-				   td->encauth, sizeof(uint32_t), &pcrsize,
-				   sizeof(uint32_t), &datsize, datalen, data, 0,
-				   0);
-	} else {
-		/* pcr info specified */
-		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
-				   sess.enonce, td->nonceodd, cont,
-				   sizeof(uint32_t), &ordinal, SHA1_DIGEST_SIZE,
-				   td->encauth, sizeof(uint32_t), &pcrsize,
-				   pcrinfosize, pcrinfo, sizeof(uint32_t),
-				   &datsize, datalen, data, 0, 0);
-	}
-	if (ret < 0)
-		goto out;
-
-	/* build and send the TPM request packet */
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_AUTH1_COMMAND);
-	store32(tb, TPM_SEAL_SIZE + pcrinfosize + datalen);
-	store32(tb, TPM_ORD_SEAL);
-	store32(tb, keyhandle);
-	storebytes(tb, td->encauth, SHA1_DIGEST_SIZE);
-	store32(tb, pcrinfosize);
-	storebytes(tb, pcrinfo, pcrinfosize);
-	store32(tb, datalen);
-	storebytes(tb, data, datalen);
-	store32(tb, sess.handle);
-	storebytes(tb, td->nonceodd, TPM_NONCE_SIZE);
-	store8(tb, cont);
-	storebytes(tb, td->pubauth, SHA1_DIGEST_SIZE);
-
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
-			       "sealing data");
-	if (ret < 0)
-		goto out;
-
-	/* calculate the size of the returned Blob */
-	sealinfosize = LOAD32(tb->data, TPM_DATA_OFFSET + sizeof(uint32_t));
-	encdatasize = LOAD32(tb->data, TPM_DATA_OFFSET + sizeof(uint32_t) +
-			     sizeof(uint32_t) + sealinfosize);
-	storedsize = sizeof(uint32_t) + sizeof(uint32_t) + sealinfosize +
-	    sizeof(uint32_t) + encdatasize;
-
-	/* check the HMAC in the response */
-	ret = TSS_checkhmac1(tb->data, ordinal, td->nonceodd, sess.secret,
-			     SHA1_DIGEST_SIZE, storedsize, TPM_DATA_OFFSET, 0,
-			     0);
-
-	/* copy the returned blob to caller */
-	if (!ret) {
-		memcpy(blob, tb->data + TPM_DATA_OFFSET, storedsize);
-		*bloblen = storedsize;
-	}
-out:
-	kfree(td);
-	return ret;
-}
-
-/*
- * use the AUTH2_COMMAND form of unseal, to authorize both key and blob
- */
-static int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
-		      uint32_t keyhandle, const unsigned char *keyauth,
-		      const unsigned char *blob, int bloblen,
-		      const unsigned char *blobauth,
-		      unsigned char *data, unsigned int *datalen)
-{
-	unsigned char nonceodd[TPM_NONCE_SIZE];
-	unsigned char enonce1[TPM_NONCE_SIZE];
-	unsigned char enonce2[TPM_NONCE_SIZE];
-	unsigned char authdata1[SHA1_DIGEST_SIZE];
-	unsigned char authdata2[SHA1_DIGEST_SIZE];
-	uint32_t authhandle1 = 0;
-	uint32_t authhandle2 = 0;
-	unsigned char cont = 0;
-	uint32_t ordinal;
-	uint32_t keyhndl;
-	int ret;
-
-	/* sessions for unsealing key and data */
-	ret = oiap(chip, tb, &authhandle1, enonce1);
-	if (ret < 0) {
-		pr_info("trusted_key: oiap failed (%d)\n", ret);
-		return ret;
-	}
-	ret = oiap(chip, tb, &authhandle2, enonce2);
-	if (ret < 0) {
-		pr_info("trusted_key: oiap failed (%d)\n", ret);
-		return ret;
-	}
-
-	ordinal = htonl(TPM_ORD_UNSEAL);
-	keyhndl = htonl(SRKHANDLE);
-	ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
-	if (ret != TPM_NONCE_SIZE) {
-		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
-		return ret;
-	}
-	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
-			   enonce1, nonceodd, cont, sizeof(uint32_t),
-			   &ordinal, bloblen, blob, 0, 0);
-	if (ret < 0)
-		return ret;
-	ret = TSS_authhmac(authdata2, blobauth, TPM_NONCE_SIZE,
-			   enonce2, nonceodd, cont, sizeof(uint32_t),
-			   &ordinal, bloblen, blob, 0, 0);
-	if (ret < 0)
-		return ret;
-
-	/* build and send TPM request packet */
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_AUTH2_COMMAND);
-	store32(tb, TPM_UNSEAL_SIZE + bloblen);
-	store32(tb, TPM_ORD_UNSEAL);
-	store32(tb, keyhandle);
-	storebytes(tb, blob, bloblen);
-	store32(tb, authhandle1);
-	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
-	store8(tb, cont);
-	storebytes(tb, authdata1, SHA1_DIGEST_SIZE);
-	store32(tb, authhandle2);
-	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
-	store8(tb, cont);
-	storebytes(tb, authdata2, SHA1_DIGEST_SIZE);
-
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
-			       "unsealing data");
-	if (ret < 0) {
-		pr_info("trusted_key: authhmac failed (%d)\n", ret);
-		return ret;
-	}
-
-	*datalen = LOAD32(tb->data, TPM_DATA_OFFSET);
-	ret = TSS_checkhmac2(tb->data, ordinal, nonceodd,
-			     keyauth, SHA1_DIGEST_SIZE,
-			     blobauth, SHA1_DIGEST_SIZE,
-			     sizeof(uint32_t), TPM_DATA_OFFSET,
-			     *datalen, TPM_DATA_OFFSET + sizeof(uint32_t), 0,
-			     0);
-	if (ret < 0) {
-		pr_info("trusted_key: TSS_checkhmac2 failed (%d)\n", ret);
-		return ret;
-	}
-	memcpy(data, tb->data + TPM_DATA_OFFSET + sizeof(uint32_t), *datalen);
-	return 0;
-}
-
 /*
  * Have the TPM seal(encrypt) the symmetric key
  */
@@ -1129,40 +517,6 @@ struct key_type key_type_trusted = {
 
 EXPORT_SYMBOL_GPL(key_type_trusted);
 
-static void trusted_shash_release(void)
-{
-	if (hashalg)
-		crypto_free_shash(hashalg);
-	if (hmacalg)
-		crypto_free_shash(hmacalg);
-}
-
-static int __init trusted_shash_alloc(void)
-{
-	int ret;
-
-	hmacalg = crypto_alloc_shash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(hmacalg)) {
-		pr_info("trusted_key: could not allocate crypto %s\n",
-			hmac_alg);
-		return PTR_ERR(hmacalg);
-	}
-
-	hashalg = crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(hashalg)) {
-		pr_info("trusted_key: could not allocate crypto %s\n",
-			hash_alg);
-		ret = PTR_ERR(hashalg);
-		goto hashalg_fail;
-	}
-
-	return 0;
-
-hashalg_fail:
-	crypto_free_shash(hmacalg);
-	return ret;
-}
-
 static int __init init_trusted(void)
 {
 	int ret;
diff --git a/security/keys/trusted.h b/security/keys/trusted.h
index 3249fbd2b653..61fe24d5c6b3 100644
--- a/security/keys/trusted.h
+++ b/security/keys/trusted.h
@@ -1,35 +1,6 @@
 #ifndef __TRUSTED_KEY_H
 #define __TRUSTED_KEY_H
 
-/* implementation specific TPM constants */
-#define MAX_PCRINFO_SIZE		64
-#define MAX_BUF_SIZE			512
-#define TPM_GETRANDOM_SIZE		14
-#define TPM_OSAP_SIZE			36
-#define TPM_OIAP_SIZE			10
-#define TPM_SEAL_SIZE			87
-#define TPM_UNSEAL_SIZE			104
-#define TPM_SIZE_OFFSET			2
-#define TPM_RETURN_OFFSET		6
-#define TPM_DATA_OFFSET			10
-
-#define LOAD32(buffer, offset)	(ntohl(*(uint32_t *)&buffer[offset]))
-#define LOAD32N(buffer, offset)	(*(uint32_t *)&buffer[offset])
-#define LOAD16(buffer, offset)	(ntohs(*(uint16_t *)&buffer[offset]))
-
-struct tpm_buf {
-	int len;
-	unsigned char data[MAX_BUF_SIZE];
-};
-
-#define INIT_BUF(tb) (tb->len = 0)
-
-struct osapsess {
-	uint32_t handle;
-	unsigned char secret[SHA1_DIGEST_SIZE];
-	unsigned char enonce[TPM_NONCE_SIZE];
-};
-
 /* discrete values, but have to store in uint16_t for TPM use */
 enum {
 	SEAL_keytype = 1,
@@ -70,26 +41,6 @@ static inline void dump_payload(struct trusted_key_payload *p)
 	pr_info("trusted_key: migratable %d\n", p->migratable);
 }
 
-static inline void dump_sess(struct osapsess *s)
-{
-	print_hex_dump(KERN_INFO, "trusted-key: handle ", DUMP_PREFIX_NONE,
-		       16, 1, &s->handle, 4, 0);
-	pr_info("trusted-key: secret:\n");
-	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
-		       16, 1, &s->secret, SHA1_DIGEST_SIZE, 0);
-	pr_info("trusted-key: enonce:\n");
-	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
-		       16, 1, &s->enonce, SHA1_DIGEST_SIZE, 0);
-}
-
-static inline void dump_tpm_buf(unsigned char *buf)
-{
-	int len;
-
-	pr_info("\ntrusted-key: tpm buffer\n");
-	len = LOAD32(buf, TPM_SIZE_OFFSET);
-	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, buf, len, 0);
-}
 #else
 static inline void dump_options(struct trusted_key_options *o)
 {
@@ -99,36 +50,5 @@ static inline void dump_payload(struct trusted_key_payload *p)
 {
 }
 
-static inline void dump_sess(struct osapsess *s)
-{
-}
-
-static inline void dump_tpm_buf(unsigned char *buf)
-{
-}
 #endif
-
-static inline void store8(struct tpm_buf *buf, const unsigned char value)
-{
-	buf->data[buf->len++] = value;
-}
-
-static inline void store16(struct tpm_buf *buf, const uint16_t value)
-{
-	*(uint16_t *) & buf->data[buf->len] = htons(value);
-	buf->len += sizeof value;
-}
-
-static inline void store32(struct tpm_buf *buf, const uint32_t value)
-{
-	*(uint32_t *) & buf->data[buf->len] = htonl(value);
-	buf->len += sizeof value;
-}
-
-static inline void storebytes(struct tpm_buf *buf, const unsigned char *in,
-			      const int len)
-{
-	memcpy(buf->data + buf->len, in, len);
-	buf->len += len;
-}
 #endif


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
