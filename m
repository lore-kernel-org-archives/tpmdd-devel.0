From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/23] TPMLIB: Create tpm_{even,
 odd}_nonce structs to represent nonces
Date: Tue, 21 Aug 2018 16:58:10 +0100
Message-ID: <153486709034.13066.6676055815830934254.stgit@warthog.procyon.org.uk>
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

Create a tpm_even_nonce struct and a tpm_odd_nonce struct to represent nonces
in internal routines rather than directly using char arrays.  Having two
separate structures helps keep track of which nonce is used where.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |  151 +++++++++++++++++++++-------------------
 drivers/char/tpm/tpm-library.h |   10 ++-
 2 files changed, 90 insertions(+), 71 deletions(-)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index 7d1f55413f02..1c64282d1d0d 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -35,6 +35,19 @@ static atomic_t tpm_library_usage;
 static struct crypto_shash *tpm_hashalg;
 static struct crypto_shash *tpm_hmacalg;
 
+static int tpm_gen_odd_nonce(struct tpm_chip *chip,
+			     struct tpm_odd_nonce *ononce)
+{
+	int ret;
+
+	ret = tpm_get_random(chip, ononce->data, TPM_NONCE_SIZE);
+	if (ret == TPM_NONCE_SIZE)
+		ret = 0;
+	else
+		pr_info("tpm_get_random failed (%d)\n", ret);
+	return ret;
+}
+
 static struct tpm_sdesc *tpm_init_sdesc(struct crypto_shash *alg)
 {
 	struct tpm_sdesc *sdesc;
@@ -124,23 +137,25 @@ out:
  * @digest: Result buffer - must be SHA1_DIGEST_SIZE in size
  * @key: The key to use in the HMAC generation
  * @keylen: The size of @key
- * @h1: Even nonce
- * @h2: Odd nonce
- * @h3: Continuation flag
+ * @enonce: Even nonce
+ * @ononce: Odd nonce
+ * @cont: Continuation flag
  * @...: Pairs of size and pointer of data elements to load into hash
  * @0,0: Terminator
  *
  * calculate authorization info fields to send to TPM
  */
-static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
-			unsigned int keylen, unsigned char *h1,
-			unsigned char *h2, unsigned char h3, ...)
+static int TSS_authhmac(unsigned char *digest,
+			const unsigned char *key, unsigned keylen,
+			const struct tpm_even_nonce *enonce,
+			const struct tpm_odd_nonce *ononce,
+			unsigned char cont,
+			...)
 {
 	unsigned char paramdigest[SHA1_DIGEST_SIZE];
 	struct tpm_sdesc *sdesc;
 	unsigned int dlen;
 	unsigned char *data;
-	unsigned char c;
 	int ret;
 	va_list argp;
 
@@ -150,11 +165,10 @@ static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 		return PTR_ERR(sdesc);
 	}
 
-	c = h3;
 	ret = crypto_shash_init(&sdesc->shash);
 	if (ret < 0)
 		goto out;
-	va_start(argp, h3);
+	va_start(argp, cont);
 	for (;;) {
 		dlen = va_arg(argp, unsigned int);
 		if (dlen == 0)
@@ -174,9 +188,9 @@ static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 	if (!ret)
 		ret = TSS_rawhmac(digest, key, keylen,
 				  SHA1_DIGEST_SIZE, paramdigest,
-				  TPM_NONCE_SIZE, h1,
-				  TPM_NONCE_SIZE, h2,
-				  1, &c,
+				  TPM_NONCE_SIZE, enonce->data,
+				  TPM_NONCE_SIZE, ononce->data,
+				  1, &cont,
 				  0, 0);
 out:
 	kfree(sdesc);
@@ -188,15 +202,15 @@ out:
  */
 static int TSS_checkhmac1(unsigned char *buffer,
 			  const uint32_t command,
-			  const unsigned char *ononce,
-			  const unsigned char *key,
-			  unsigned int keylen, ...)
+			  const struct tpm_odd_nonce *ononce,
+			  const unsigned char *key, unsigned keylen,
+			  ...)
 {
 	uint32_t bufsize;
 	uint16_t tag;
 	uint32_t ordinal;
 	uint32_t result;
-	unsigned char *enonce;
+	struct tpm_even_nonce *enonce;
 	unsigned char *continueflag;
 	unsigned char *authdata;
 	unsigned char testhmac[SHA1_DIGEST_SIZE];
@@ -217,7 +231,7 @@ static int TSS_checkhmac1(unsigned char *buffer,
 		return -EINVAL;
 	authdata = buffer + bufsize - SHA1_DIGEST_SIZE;
 	continueflag = authdata - 1;
-	enonce = continueflag - TPM_NONCE_SIZE;
+	enonce = (void *)continueflag - TPM_NONCE_SIZE;
 
 	sdesc = tpm_init_sdesc(tpm_hashalg);
 	if (IS_ERR(sdesc)) {
@@ -253,8 +267,8 @@ static int TSS_checkhmac1(unsigned char *buffer,
 
 	ret = TSS_rawhmac(testhmac, key, keylen,
 			  SHA1_DIGEST_SIZE, paramdigest,
-			  TPM_NONCE_SIZE, enonce,
-			  TPM_NONCE_SIZE, ononce,
+			  TPM_NONCE_SIZE, enonce->data,
+			  TPM_NONCE_SIZE, ononce->data,
 			  1, continueflag,
 			  0, 0);
 	if (ret < 0)
@@ -270,24 +284,23 @@ out:
 /*
  * verify the AUTH2_COMMAND (unseal) result from TPM
  */
-static int TSS_checkhmac2(unsigned char *buffer,
+static int TSS_checkhmac2(const unsigned char *buffer,
 			  const uint32_t command,
-			  const unsigned char *ononce,
-			  const unsigned char *key1,
-			  unsigned int keylen1,
-			  const unsigned char *key2,
-			  unsigned int keylen2, ...)
+			  const struct tpm_odd_nonce *ononce,
+			  const unsigned char *key1, unsigned keylen1,
+			  const unsigned char *key2, unsigned keylen2,
+			  ...)
 {
 	uint32_t bufsize;
 	uint16_t tag;
 	uint32_t ordinal;
 	uint32_t result;
-	unsigned char *enonce1;
-	unsigned char *continueflag1;
-	unsigned char *authdata1;
-	unsigned char *enonce2;
-	unsigned char *continueflag2;
-	unsigned char *authdata2;
+	const struct tpm_even_nonce *enonce1;
+	const unsigned char *continueflag1;
+	const unsigned char *authdata1;
+	const struct tpm_even_nonce *enonce2;
+	const unsigned char *continueflag2;
+	const unsigned char *authdata2;
 	unsigned char testhmac1[SHA1_DIGEST_SIZE];
 	unsigned char testhmac2[SHA1_DIGEST_SIZE];
 	unsigned char paramdigest[SHA1_DIGEST_SIZE];
@@ -311,8 +324,8 @@ static int TSS_checkhmac2(unsigned char *buffer,
 	authdata2 = buffer + bufsize - (SHA1_DIGEST_SIZE);
 	continueflag1 = authdata1 - 1;
 	continueflag2 = authdata2 - 1;
-	enonce1 = continueflag1 - TPM_NONCE_SIZE;
-	enonce2 = continueflag2 - TPM_NONCE_SIZE;
+	enonce1 = (const void *)continueflag1 - TPM_NONCE_SIZE;
+	enonce2 = (const void *)continueflag2 - TPM_NONCE_SIZE;
 
 	sdesc = tpm_init_sdesc(tpm_hashalg);
 	if (IS_ERR(sdesc)) {
@@ -349,8 +362,8 @@ static int TSS_checkhmac2(unsigned char *buffer,
 
 	ret = TSS_rawhmac(testhmac1, key1, keylen1,
 			  SHA1_DIGEST_SIZE, paramdigest,
-			  TPM_NONCE_SIZE, enonce1,
-			  TPM_NONCE_SIZE, ononce,
+			  TPM_NONCE_SIZE, enonce1->data,
+			  TPM_NONCE_SIZE, ononce->data,
 			  1, continueflag1,
 			  0, 0);
 	if (ret < 0)
@@ -361,8 +374,8 @@ static int TSS_checkhmac2(unsigned char *buffer,
 	}
 	ret = TSS_rawhmac(testhmac2, key2, keylen2,
 			  SHA1_DIGEST_SIZE, paramdigest,
-			  TPM_NONCE_SIZE, enonce2,
-			  TPM_NONCE_SIZE, ononce,
+			  TPM_NONCE_SIZE, enonce2->data,
+			  TPM_NONCE_SIZE, ononce->data,
 			  1, continueflag2,
 			  0, 0);
 	if (ret < 0)
@@ -400,12 +413,12 @@ static int tpm_create_osap(struct tpm_chip *chip,
 			   const unsigned char *keyauth,
 			   enum tpm_entity_type keytype, uint32_t keyhandle)
 {
-	unsigned char enonce[TPM_NONCE_SIZE];
-	unsigned char ononce[TPM_NONCE_SIZE];
+	struct tpm_even_nonce enonce;
+	struct tpm_odd_nonce ononce;
 	int ret;
 
-	ret = tpm_get_random(chip, ononce, TPM_NONCE_SIZE);
-	if (ret != TPM_NONCE_SIZE)
+	ret = tpm_gen_odd_nonce(chip, &ononce);
+	if (ret < 0)
 		return ret;
 
 	INIT_BUF(tb);
@@ -414,7 +427,7 @@ static int tpm_create_osap(struct tpm_chip *chip,
 	store32(tb, TPM_ORD_OSAP);
 	store16(tb, keytype);
 	store32(tb, keyhandle);
-	storebytes(tb, ononce, TPM_NONCE_SIZE);
+	storebytes(tb, ononce.data, TPM_NONCE_SIZE);
 
 	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
 			    "creating OSAP session");
@@ -422,13 +435,13 @@ static int tpm_create_osap(struct tpm_chip *chip,
 		return ret;
 
 	s->handle = LOAD32(tb->data, TPM_DATA_OFFSET);
-	memcpy(s->enonce, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)]),
+	memcpy(s->enonce.data, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)]),
 	       TPM_NONCE_SIZE);
-	memcpy(enonce, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t) +
+	memcpy(enonce.data, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t) +
 				  TPM_NONCE_SIZE]), TPM_NONCE_SIZE);
 	return TSS_rawhmac(s->secret, keyauth, SHA1_DIGEST_SIZE,
-			   TPM_NONCE_SIZE, enonce,
-			   TPM_NONCE_SIZE, ononce,
+			   TPM_NONCE_SIZE, enonce.data,
+			   TPM_NONCE_SIZE, ononce.data,
 			   0, 0);
 }
 
@@ -436,7 +449,7 @@ static int tpm_create_osap(struct tpm_chip *chip,
  * Create an object independent authorisation protocol (oiap) session
  */
 static int tpm_create_oiap(struct tpm_chip *chip, struct tpm_buf *tb,
-			   uint32_t *handle, unsigned char *nonce)
+			   uint32_t *handle, struct tpm_even_nonce *enonce)
 {
 	int ret;
 
@@ -450,7 +463,7 @@ static int tpm_create_oiap(struct tpm_chip *chip, struct tpm_buf *tb,
 		return ret;
 
 	*handle = LOAD32(tb->data, TPM_DATA_OFFSET);
-	memcpy(nonce, &tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)],
+	memcpy(enonce->data, &tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)],
 	       TPM_NONCE_SIZE);
 	return 0;
 }
@@ -460,7 +473,7 @@ struct tpm_digests {
 	unsigned char pubauth[SHA1_DIGEST_SIZE];
 	unsigned char xorwork[SHA1_DIGEST_SIZE * 2];
 	unsigned char xorhash[SHA1_DIGEST_SIZE];
-	unsigned char nonceodd[TPM_NONCE_SIZE];
+	struct tpm_odd_nonce ononce;
 };
 
 /**
@@ -517,13 +530,13 @@ int tpm_seal(struct tpm_chip *chip,
 
 	/* calculate encrypted authorization value */
 	memcpy(td->xorwork, sess.secret, SHA1_DIGEST_SIZE);
-	memcpy(td->xorwork + SHA1_DIGEST_SIZE, sess.enonce, SHA1_DIGEST_SIZE);
+	memcpy(td->xorwork + SHA1_DIGEST_SIZE, sess.enonce.data, SHA1_DIGEST_SIZE);
 	ret = TSS_sha1(td->xorwork, SHA1_DIGEST_SIZE * 2, td->xorhash);
 	if (ret < 0)
 		goto out;
 
-	ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
-	if (ret != TPM_NONCE_SIZE)
+	ret = tpm_gen_odd_nonce(chip, &td->ononce);
+	if (ret < 0)
 		goto out;
 	ordinal = htonl(TPM_ORD_SEAL);
 	datsize = htonl(rawlen);
@@ -538,7 +551,7 @@ int tpm_seal(struct tpm_chip *chip,
 	if (pcrinfosize == 0) {
 		/* no pcr info specified */
 		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
-				   sess.enonce, td->nonceodd, cont,
+				   &sess.enonce, &td->ononce, cont,
 				   sizeof(uint32_t), &ordinal,
 				   SHA1_DIGEST_SIZE, td->encauth,
 				   sizeof(uint32_t), &pcrsize,
@@ -548,7 +561,7 @@ int tpm_seal(struct tpm_chip *chip,
 	} else {
 		/* pcr info specified */
 		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
-				   sess.enonce, td->nonceodd, cont,
+				   &sess.enonce, &td->ononce, cont,
 				   sizeof(uint32_t), &ordinal,
 				   SHA1_DIGEST_SIZE, td->encauth,
 				   sizeof(uint32_t), &pcrsize,
@@ -572,7 +585,7 @@ int tpm_seal(struct tpm_chip *chip,
 	store32(tb, rawlen);
 	storebytes(tb, rawdata, rawlen);
 	store32(tb, sess.handle);
-	storebytes(tb, td->nonceodd, TPM_NONCE_SIZE);
+	storebytes(tb, td->ononce.data, TPM_NONCE_SIZE);
 	store8(tb, cont);
 	storebytes(tb, td->pubauth, SHA1_DIGEST_SIZE);
 
@@ -589,7 +602,7 @@ int tpm_seal(struct tpm_chip *chip,
 	    sizeof(uint32_t) + encdatasize;
 
 	/* check the HMAC in the response */
-	ret = TSS_checkhmac1(tb->data, ordinal, td->nonceodd,
+	ret = TSS_checkhmac1(tb->data, ordinal, &td->ononce,
 			     sess.secret, SHA1_DIGEST_SIZE,
 			     storedsize, TPM_DATA_OFFSET,
 			     0, 0);
@@ -625,9 +638,9 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	       const unsigned char *decauth,
 	       unsigned char *rawbuffer, unsigned int *_rawlen)
 {
-	unsigned char nonceodd[TPM_NONCE_SIZE];
-	unsigned char enonce1[TPM_NONCE_SIZE];
-	unsigned char enonce2[TPM_NONCE_SIZE];
+	struct tpm_odd_nonce ononce;
+	struct tpm_even_nonce enonce1;
+	struct tpm_even_nonce enonce2;
 	unsigned char authdata1[SHA1_DIGEST_SIZE];
 	unsigned char authdata2[SHA1_DIGEST_SIZE];
 	uint32_t authhandle1 = 0;
@@ -638,12 +651,12 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	int ret;
 
 	/* sessions for unsealing key and data */
-	ret = tpm_create_oiap(chip, tb, &authhandle1, enonce1);
+	ret = tpm_create_oiap(chip, tb, &authhandle1, &enonce1);
 	if (ret < 0) {
 		pr_info("Failed to create OIAP 1 (%d)\n", ret);
 		return ret;
 	}
-	ret = tpm_create_oiap(chip, tb, &authhandle2, enonce2);
+	ret = tpm_create_oiap(chip, tb, &authhandle2, &enonce2);
 	if (ret < 0) {
 		pr_info("Failed to create OIAP 2 (%d)\n", ret);
 		return ret;
@@ -651,20 +664,18 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 
 	ordinal = htonl(TPM_ORD_UNSEAL);
 	keyhndl = htonl(SRKHANDLE);
-	ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
-	if (ret != TPM_NONCE_SIZE) {
-		pr_info("tpm_get_random failed (%d)\n", ret);
+	ret = tpm_gen_odd_nonce(chip, &ononce);
+	if (ret < 0)
 		return ret;
-	}
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
-			   enonce1, nonceodd, cont,
+			   &enonce1, &ononce, cont,
 			   sizeof(uint32_t), &ordinal,
 			   enclen, encdata,
 			   0, 0);
 	if (ret < 0)
 		return ret;
 	ret = TSS_authhmac(authdata2, decauth, TPM_NONCE_SIZE,
-			   enonce2, nonceodd, cont,
+			   &enonce2, &ononce, cont,
 			   sizeof(uint32_t), &ordinal,
 			   enclen, encdata,
 			   0, 0);
@@ -679,11 +690,11 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	store32(tb, keyhandle);
 	storebytes(tb, encdata, enclen);
 	store32(tb, authhandle1);
-	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
+	storebytes(tb, ononce.data, TPM_NONCE_SIZE);
 	store8(tb, cont);
 	storebytes(tb, authdata1, SHA1_DIGEST_SIZE);
 	store32(tb, authhandle2);
-	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
+	storebytes(tb, ononce.data, TPM_NONCE_SIZE);
 	store8(tb, cont);
 	storebytes(tb, authdata2, SHA1_DIGEST_SIZE);
 
@@ -695,7 +706,7 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	}
 
 	*_rawlen = LOAD32(tb->data, TPM_DATA_OFFSET);
-	ret = TSS_checkhmac2(tb->data, ordinal, nonceodd,
+	ret = TSS_checkhmac2(tb->data, ordinal, &ononce,
 			     keyauth, SHA1_DIGEST_SIZE,
 			     decauth, SHA1_DIGEST_SIZE,
 			     sizeof(uint32_t), TPM_DATA_OFFSET,
diff --git a/drivers/char/tpm/tpm-library.h b/drivers/char/tpm/tpm-library.h
index 6f7571cc6d6c..ceb0ea1cd2bb 100644
--- a/drivers/char/tpm/tpm-library.h
+++ b/drivers/char/tpm/tpm-library.h
@@ -15,10 +15,18 @@
 #define LOAD32N(buffer, offset)	(*(uint32_t *)&buffer[offset])
 #define LOAD16(buffer, offset)	(ntohs(*(uint16_t *)&buffer[offset]))
 
+struct tpm_even_nonce {
+	unsigned char data[TPM_NONCE_SIZE];
+};
+
+struct tpm_odd_nonce {
+	unsigned char data[TPM_NONCE_SIZE];
+};
+
 struct tpm_osapsess {
 	uint32_t handle;
 	unsigned char secret[SHA1_DIGEST_SIZE];
-	unsigned char enonce[TPM_NONCE_SIZE];
+	struct tpm_even_nonce enonce;
 };
 
 static inline void store8(struct tpm_buf *buf, const unsigned char value)


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
