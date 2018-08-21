From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/23] TPMLIB: Put banner comments on public
 TPM library functions
Date: Tue, 21 Aug 2018 16:58:03 +0100
Message-ID: <153486708356.13066.15616902542019684189.stgit@warthog.procyon.org.uk>
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

Put banner comments on public TPM library functions and, if necessary, rename
the arguments to make them more obvious.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |  126 ++++++++++++++++++++++++++++------------
 include/linux/tpm.h            |   19 ++++++
 2 files changed, 105 insertions(+), 40 deletions(-)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index 41fe4247a4c8..7d1f55413f02 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -66,8 +66,17 @@ static int TSS_sha1(const unsigned char *data, unsigned int datalen,
 	return ret;
 }
 
-static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
-		       unsigned int keylen, ...)
+/**
+ * TSS_rawhmac - Generate a HMAC(SHA1) from raw data
+ * @digest: Result buffer - must be SHA1_DIGEST_SIZE in size
+ * @key: The key to use in the HMAC generation
+ * @keylen: The size of @key
+ * @...: Pairs of size and pointer of data elements to load into hmac
+ * @0,0: Terminator
+ */
+static int TSS_rawhmac(unsigned char *digest,
+		       const unsigned char *key, unsigned keylen,
+		       ...)
 {
 	struct tpm_sdesc *sdesc;
 	va_list argp;
@@ -110,7 +119,17 @@ out:
 	return ret;
 }
 
-/*
+/**
+ * TSS_authhmac - Calculate authorisation info to send to TPM
+ * @digest: Result buffer - must be SHA1_DIGEST_SIZE in size
+ * @key: The key to use in the HMAC generation
+ * @keylen: The size of @key
+ * @h1: Even nonce
+ * @h2: Odd nonce
+ * @h3: Continuation flag
+ * @...: Pairs of size and pointer of data elements to load into hash
+ * @0,0: Terminator
+ *
  * calculate authorization info fields to send to TPM
  */
 static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
@@ -378,8 +397,8 @@ static int tpm_send_dump(struct tpm_chip *chip,
  */
 static int tpm_create_osap(struct tpm_chip *chip,
 			   struct tpm_buf *tb, struct tpm_osapsess *s,
-			   const unsigned char *key, uint16_t type,
-			   uint32_t handle)
+			   const unsigned char *keyauth,
+			   enum tpm_entity_type keytype, uint32_t keyhandle)
 {
 	unsigned char enonce[TPM_NONCE_SIZE];
 	unsigned char ononce[TPM_NONCE_SIZE];
@@ -393,8 +412,8 @@ static int tpm_create_osap(struct tpm_chip *chip,
 	store16(tb, TPM_TAG_RQU_COMMAND);
 	store32(tb, TPM_OSAP_SIZE);
 	store32(tb, TPM_ORD_OSAP);
-	store16(tb, type);
-	store32(tb, handle);
+	store16(tb, keytype);
+	store32(tb, keyhandle);
 	storebytes(tb, ononce, TPM_NONCE_SIZE);
 
 	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
@@ -407,7 +426,7 @@ static int tpm_create_osap(struct tpm_chip *chip,
 	       TPM_NONCE_SIZE);
 	memcpy(enonce, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t) +
 				  TPM_NONCE_SIZE]), TPM_NONCE_SIZE);
-	return TSS_rawhmac(s->secret, key, SHA1_DIGEST_SIZE,
+	return TSS_rawhmac(s->secret, keyauth, SHA1_DIGEST_SIZE,
 			   TPM_NONCE_SIZE, enonce,
 			   TPM_NONCE_SIZE, ononce,
 			   0, 0);
@@ -444,15 +463,33 @@ struct tpm_digests {
 	unsigned char nonceodd[TPM_NONCE_SIZE];
 };
 
-/*
- * Have the TPM seal(encrypt) the trusted key, possibly based on
- * Platform Configuration Registers (PCRs). AUTH1 for sealing key.
+/**
+ * tpm_seal - Encrypt one key according to another plus PCR state
+ * @chip: The chip to use
+ * @tb: Large scratch buffer for I/O
+ * @keytype: Type of entity attached to @keyhandle
+ * @keyhandle: TPM-resident key used to encrypt
+ * @keyauth: 'Password' to use the key.
+ * @rawdata: Data to be encrypted
+ * @rawlen: Length of @rawdata
+ * @encbuffer: Buffer to hold the encrypted data (max SHA1_DIGEST_SIZE)
+ * @_enclen: Where to place the size of the encrypted data
+ * @encauth: 'Password' to use to encrypt authorisation key
+ * @pcrinfo: Information on PCR register values to seal to
+ * @pcrinfosize: size of @pcrinfo
+ *
+ * Have the TPM seal (encrypt) the data in the data buffer.  The encryption is
+ * based on a key already resident in the TPM and may also include the state of
+ * one or more Platform Configuration Registers (PCRs).
+ *
+ * AUTH1 is used for sealing key.
  */
-int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
+int tpm_seal(struct tpm_chip *chip,
+	     struct tpm_buf *tb, enum tpm_entity_type keytype,
 	     uint32_t keyhandle, const unsigned char *keyauth,
-	     const unsigned char *data, uint32_t datalen,
-	     unsigned char *blob, uint32_t *bloblen,
-	     const unsigned char *blobauth,
+	     const unsigned char *rawdata, uint32_t rawlen,
+	     unsigned char *encbuffer, uint32_t *_enclen,
+	     const unsigned char *encauth,
 	     const unsigned char *pcrinfo, uint32_t pcrinfosize)
 {
 	struct tpm_osapsess sess;
@@ -489,13 +526,13 @@ int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 	if (ret != TPM_NONCE_SIZE)
 		goto out;
 	ordinal = htonl(TPM_ORD_SEAL);
-	datsize = htonl(datalen);
+	datsize = htonl(rawlen);
 	pcrsize = htonl(pcrinfosize);
 	cont = 0;
 
 	/* encrypt data authorization key */
 	for (i = 0; i < SHA1_DIGEST_SIZE; ++i)
-		td->encauth[i] = td->xorhash[i] ^ blobauth[i];
+		td->encauth[i] = td->xorhash[i] ^ encauth[i];
 
 	/* calculate authorization HMAC value */
 	if (pcrinfosize == 0) {
@@ -506,7 +543,7 @@ int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 				   SHA1_DIGEST_SIZE, td->encauth,
 				   sizeof(uint32_t), &pcrsize,
 				   sizeof(uint32_t), &datsize,
-				   datalen, data,
+				   rawlen, rawdata,
 				   0, 0);
 	} else {
 		/* pcr info specified */
@@ -517,7 +554,7 @@ int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 				   sizeof(uint32_t), &pcrsize,
 				   pcrinfosize, pcrinfo,
 				   sizeof(uint32_t), &datsize,
-				   datalen, data,
+				   rawlen, rawdata,
 				   0, 0);
 	}
 	if (ret < 0)
@@ -526,14 +563,14 @@ int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 	/* build and send the TPM request packet */
 	INIT_BUF(tb);
 	store16(tb, TPM_TAG_RQU_AUTH1_COMMAND);
-	store32(tb, TPM_SEAL_SIZE + pcrinfosize + datalen);
+	store32(tb, TPM_SEAL_SIZE + pcrinfosize + rawlen);
 	store32(tb, TPM_ORD_SEAL);
 	store32(tb, keyhandle);
 	storebytes(tb, td->encauth, SHA1_DIGEST_SIZE);
 	store32(tb, pcrinfosize);
 	storebytes(tb, pcrinfo, pcrinfosize);
-	store32(tb, datalen);
-	storebytes(tb, data, datalen);
+	store32(tb, rawlen);
+	storebytes(tb, rawdata, rawlen);
 	store32(tb, sess.handle);
 	storebytes(tb, td->nonceodd, TPM_NONCE_SIZE);
 	store8(tb, cont);
@@ -544,7 +581,7 @@ int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 	if (ret < 0)
 		goto out;
 
-	/* calculate the size of the returned Blob */
+	/* calculate the size of the returned encrypted data */
 	sealinfosize = LOAD32(tb->data, TPM_DATA_OFFSET + sizeof(uint32_t));
 	encdatasize = LOAD32(tb->data, TPM_DATA_OFFSET + sizeof(uint32_t) +
 			     sizeof(uint32_t) + sealinfosize);
@@ -557,10 +594,10 @@ int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
 			     storedsize, TPM_DATA_OFFSET,
 			     0, 0);
 
-	/* copy the returned blob to caller */
+	/* copy the encrypted data to caller's buffer */
 	if (!ret) {
-		memcpy(blob, tb->data + TPM_DATA_OFFSET, storedsize);
-		*bloblen = storedsize;
+		memcpy(encbuffer, tb->data + TPM_DATA_OFFSET, storedsize);
+		*_enclen = storedsize;
 	}
 out:
 	kfree(td);
@@ -568,14 +605,25 @@ out:
 }
 EXPORT_SYMBOL_GPL(tpm_seal);
 
-/*
+/**
+ * tpm_unseal - Encrypt one key according to another plus PCR state
+ * @chip: The chip to use
+ * @tb: Large scratch buffer for I/O
+ * @keyhandle: TPM-resident key used to decrypt
+ * @keyauth: HMAC key
+ * @encdata: Data to be decrypted
+ * @enclen: Length of @encdata
+ * @decauth: Data to use to decrypt the authorisation key
+ * @rawbuffer: Buffer to hold the decrypted data (max SHA1_DIGEST_SIZE)
+ * @_rawlen: Where to place the size of the decrypted data
+ *
  * use the AUTH2_COMMAND form of unseal, to authorize both key and blob
  */
 int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	       uint32_t keyhandle, const unsigned char *keyauth,
-	       const unsigned char *blob, int bloblen,
-	       const unsigned char *blobauth,
-	       unsigned char *data, unsigned int *datalen)
+	       const unsigned char *encdata, int enclen,
+	       const unsigned char *decauth,
+	       unsigned char *rawbuffer, unsigned int *_rawlen)
 {
 	unsigned char nonceodd[TPM_NONCE_SIZE];
 	unsigned char enonce1[TPM_NONCE_SIZE];
@@ -611,14 +659,14 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
 			   enonce1, nonceodd, cont,
 			   sizeof(uint32_t), &ordinal,
-			   bloblen, blob,
+			   enclen, encdata,
 			   0, 0);
 	if (ret < 0)
 		return ret;
-	ret = TSS_authhmac(authdata2, blobauth, TPM_NONCE_SIZE,
+	ret = TSS_authhmac(authdata2, decauth, TPM_NONCE_SIZE,
 			   enonce2, nonceodd, cont,
 			   sizeof(uint32_t), &ordinal,
-			   bloblen, blob,
+			   enclen, encdata,
 			   0, 0);
 	if (ret < 0)
 		return ret;
@@ -626,10 +674,10 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	/* build and send TPM request packet */
 	INIT_BUF(tb);
 	store16(tb, TPM_TAG_RQU_AUTH2_COMMAND);
-	store32(tb, TPM_UNSEAL_SIZE + bloblen);
+	store32(tb, TPM_UNSEAL_SIZE + enclen);
 	store32(tb, TPM_ORD_UNSEAL);
 	store32(tb, keyhandle);
-	storebytes(tb, blob, bloblen);
+	storebytes(tb, encdata, enclen);
 	store32(tb, authhandle1);
 	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
 	store8(tb, cont);
@@ -646,18 +694,18 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 		return ret;
 	}
 
-	*datalen = LOAD32(tb->data, TPM_DATA_OFFSET);
+	*_rawlen = LOAD32(tb->data, TPM_DATA_OFFSET);
 	ret = TSS_checkhmac2(tb->data, ordinal, nonceodd,
 			     keyauth, SHA1_DIGEST_SIZE,
-			     blobauth, SHA1_DIGEST_SIZE,
+			     decauth, SHA1_DIGEST_SIZE,
 			     sizeof(uint32_t), TPM_DATA_OFFSET,
-			     *datalen, TPM_DATA_OFFSET + sizeof(uint32_t),
+			     *_rawlen, TPM_DATA_OFFSET + sizeof(uint32_t),
 			     0, 0);
 	if (ret < 0) {
 		pr_info("TSS_checkhmac2 failed (%d)\n", ret);
 		return ret;
 	}
-	memcpy(data, tb->data + TPM_DATA_OFFSET + sizeof(uint32_t), *datalen);
+	memcpy(rawbuffer, tb->data + TPM_DATA_OFFSET + sizeof(uint32_t), *_rawlen);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_unseal);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index b08539920f76..cbd13e03a869 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -93,6 +93,22 @@ static inline int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max) {
 #define TPM_RETURN_OFFSET		6
 #define TPM_DATA_OFFSET			10
 
+enum tpm_entity_type {
+	TPM_ET_KEYHANDLE		= 0x01,
+	TPM_ET_OWNER			= 0x02,
+	TPM_ET_DATA			= 0x03,
+	TPM_ET_SRK			= 0x04,
+	TPM_ET_KEY			= 0x05,
+	TPM_ET_REVOKE			= 0x06,
+	TPM_ET_DEL_OWNER_BLOB		= 0x07,
+	TPM_ET_DEL_ROW			= 0x08,
+	TPM_ET_DEL_KEY_BLOB		= 0x09,
+	TPM_ET_COUNTER			= 0x0a,
+	TPM_ET_NV			= 0x0b,
+	TPM_ET_OPERATOR			= 0x0c,
+	TPM_ET_RESERVED_HANDLE		= 0x40,
+};
+
 struct tpm_buf {
 	int len;
 	unsigned char data[MAX_BUF_SIZE];
@@ -103,7 +119,8 @@ struct tpm_buf {
 extern int tpm_library_use(void);
 extern void tpm_library_unuse(void);
 
-extern int tpm_seal(struct tpm_chip *chip, struct tpm_buf *tb, uint16_t keytype,
+extern int tpm_seal(struct tpm_chip *chip,
+		    struct tpm_buf *tb, enum tpm_entity_type keytype,
 		    uint32_t keyhandle, const unsigned char *keyauth,
 		    const unsigned char *data, uint32_t datalen,
 		    unsigned char *blob, uint32_t *bloblen,


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
