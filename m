From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/23] TPMLIB: Put more comments into the HMAC
 generation functions
Date: Tue, 21 Aug 2018 16:58:38 +0100
Message-ID: <153486711844.13066.4588463993575735370.stgit@warthog.procyon.org.uk>
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

Put more comments into the HMAC generation functions in the TPM call library
so that it's easier to see how it relates to the request and response tables
in the documents.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |  161 +++++++++++++++++++++-------------------
 1 file changed, 83 insertions(+), 78 deletions(-)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index f14980be5ebb..46cd12d30ec6 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -85,7 +85,7 @@ static int TSS_sha1(const unsigned char *data, unsigned int datalen,
  * @key: The key to use in the HMAC generation
  * @keylen: The size of @key
  * @...: Pairs of size and pointer of data elements to load into hmac
- * @0,0: Terminator
+ * @0,NULL: Terminator
  */
 static int TSS_rawhmac(unsigned char *digest,
 		       const unsigned char *key, unsigned keylen,
@@ -113,13 +113,9 @@ static int TSS_rawhmac(unsigned char *digest,
 	va_start(argp, keylen);
 	for (;;) {
 		dlen = va_arg(argp, unsigned int);
-		if (dlen == 0)
-			break;
 		data = va_arg(argp, unsigned char *);
-		if (data == NULL) {
-			ret = -EINVAL;
+		if (!data)
 			break;
-		}
 		ret = crypto_shash_update(&sdesc->shash, data, dlen);
 		if (ret < 0)
 			break;
@@ -141,9 +137,9 @@ out:
  * @ononce: Odd nonce
  * @cont: Continuation flag
  * @...: Pairs of size and pointer of data elements to load into hash
- * @0,0: Terminator
+ * @0,NULL: Terminator
  *
- * calculate authorization info fields to send to TPM
+ * Calculate authorization info fields to send to TPM
  */
 static int TSS_authhmac(unsigned char *digest,
 			const unsigned char *key, unsigned keylen,
@@ -171,13 +167,9 @@ static int TSS_authhmac(unsigned char *digest,
 	va_start(argp, cont);
 	for (;;) {
 		dlen = va_arg(argp, unsigned int);
-		if (dlen == 0)
-			break;
 		data = va_arg(argp, unsigned char *);
-		if (!data) {
-			ret = -EINVAL;
+		if (!data)
 			break;
-		}
 		ret = crypto_shash_update(&sdesc->shash, data, dlen);
 		if (ret < 0)
 			break;
@@ -187,18 +179,25 @@ static int TSS_authhmac(unsigned char *digest,
 		ret = crypto_shash_final(&sdesc->shash, paramdigest);
 	if (!ret)
 		ret = TSS_rawhmac(digest, key, keylen,
-				  SHA1_DIGEST_SIZE, paramdigest,
-				  TPM_NONCE_SIZE, enonce->data,
-				  TPM_NONCE_SIZE, ononce->data,
-				  1, &cont,
-				  0, 0);
+				  /* 1H1 */ SHA1_DIGEST_SIZE, paramdigest,
+				  /* 2H1 */ TPM_NONCE_SIZE, enonce->data,
+				  /* 3H1 */ TPM_NONCE_SIZE, ononce->data,
+				  /* 4H1 */ 1, &cont,
+				  0, NULL);
 out:
 	kfree(sdesc);
 	return ret;
 }
 
-/*
- * verify the AUTH1_COMMAND (Seal) result from TPM
+/**
+ * TSS_checkhmac1 - Verify the result of an AUTH1_COMMAND (eg. Seal)
+ * @digest: Reply buffer
+ * @ordinal: The command ID, BE form
+ * @ononce: Odd nonce
+ * @key: The key to use in the HMAC generation
+ * @keylen: The size of @key
+ * @...: Pairs of size and pointer of data elements to load into hash
+ * @0,NULL: Terminator
  */
 static int TSS_checkhmac1(unsigned char *buffer,
 			  __be32 ordinal,
@@ -231,6 +230,9 @@ static int TSS_checkhmac1(unsigned char *buffer,
 	continueflag = authdata - 1;
 	enonce = (void *)continueflag - TPM_NONCE_SIZE;
 
+	/* Load the 1S, 2S, 3S, ... marked fields into a hash.  The digest
+	 * value is then 1H1 loaded into the HMAC below.
+	 */
 	sdesc = tpm_init_sdesc(tpm_hashalg);
 	if (IS_ERR(sdesc)) {
 		pr_info("Can't alloc %s\n", tpm_hash_alg);
@@ -240,19 +242,19 @@ static int TSS_checkhmac1(unsigned char *buffer,
 	if (ret < 0)
 		goto out;
 	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&result,
-				  sizeof result);
+				  sizeof(result)); /* 1S */
 	if (ret < 0)
 		goto out;
 	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&ordinal,
-				  sizeof(ordinal));
+				  sizeof(ordinal)); /* 2S */
 	if (ret < 0)
 		goto out;
 	va_start(argp, keylen);
 	for (;;) {
 		dlen = va_arg(argp, unsigned int);
-		if (dlen == 0)
-			break;
 		dpos = va_arg(argp, unsigned int);
+		if (!dlen && !dpos)
+			break;
 		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
 		if (ret < 0)
 			break;
@@ -263,12 +265,13 @@ static int TSS_checkhmac1(unsigned char *buffer,
 	if (ret < 0)
 		goto out;
 
+	/* Generate the HMAC digest */
 	ret = TSS_rawhmac(testhmac, key, keylen,
-			  SHA1_DIGEST_SIZE, paramdigest,
-			  TPM_NONCE_SIZE, enonce->data,
-			  TPM_NONCE_SIZE, ononce->data,
-			  1, continueflag,
-			  0, 0);
+			  /* 1H1 */ SHA1_DIGEST_SIZE, paramdigest,
+			  /* 2H1 */ TPM_NONCE_SIZE, enonce->data,
+			  /* 3H1 */ TPM_NONCE_SIZE, ononce->data,
+			  /* 4H1 */ 1, continueflag,
+			  0, NULL);
 	if (ret < 0)
 		goto out;
 
@@ -279,7 +282,18 @@ out:
 	return ret;
 }
 
-/*
+/**
+ * TSS_checkhmac2 - Verify the result of an AUTH2_COMMAND (eg. Unseal)
+ * @digest: Reply buffer
+ * @ordinal: The command ID, BE form
+ * @ononce: Odd nonce
+ * @key1: The key to use in the authorisation session HMAC generation (nH1)
+ * @keylen1: The size of @key1
+ * @key2: The key to use in the data session HMAC generation (nH2)
+ * @keylen2: The size of @key2
+ * @...: Pairs of size and pointer of data elements to load into hash
+ * @0,NULL: Terminator
+ *
  * verify the AUTH2_COMMAND (unseal) result from TPM
  */
 static int TSS_checkhmac2(const unsigned char *buffer,
@@ -323,6 +337,9 @@ static int TSS_checkhmac2(const unsigned char *buffer,
 	enonce1 = (const void *)continueflag1 - TPM_NONCE_SIZE;
 	enonce2 = (const void *)continueflag2 - TPM_NONCE_SIZE;
 
+	/* Load the 1S, 2S, 3S, ... marked fields into a hash.  The digest
+	 * value is then 1H1 loaded into the HMAC below.
+	 */
 	sdesc = tpm_init_sdesc(tpm_hashalg);
 	if (IS_ERR(sdesc)) {
 		pr_info("Can't alloc %s\n", tpm_hash_alg);
@@ -332,20 +349,20 @@ static int TSS_checkhmac2(const unsigned char *buffer,
 	if (ret < 0)
 		goto out;
 	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&result,
-				  sizeof(result));
+				  sizeof(result)); /* 1S */
 	if (ret < 0)
 		goto out;
 	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&ordinal,
-				  sizeof(ordinal));
+				  sizeof(ordinal)); /* 2S */
 	if (ret < 0)
 		goto out;
 
 	va_start(argp, keylen2);
 	for (;;) {
 		dlen = va_arg(argp, unsigned int);
-		if (dlen == 0)
-			break;
 		dpos = va_arg(argp, unsigned int);
+		if (!dlen && !dpos)
+			break;
 		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
 		if (ret < 0)
 			break;
@@ -357,11 +374,11 @@ static int TSS_checkhmac2(const unsigned char *buffer,
 		goto out;
 
 	ret = TSS_rawhmac(testhmac1, key1, keylen1,
-			  SHA1_DIGEST_SIZE, paramdigest,
-			  TPM_NONCE_SIZE, enonce1->data,
-			  TPM_NONCE_SIZE, ononce->data,
-			  1, continueflag1,
-			  0, 0);
+			  /* 1H1 */ SHA1_DIGEST_SIZE, paramdigest,
+			  /* 2H1 */ TPM_NONCE_SIZE, enonce1->data,
+			  /* 3H1 */ TPM_NONCE_SIZE, ononce->data,
+			  /* 4H1 */ 1, continueflag1,
+			  0, NULL);
 	if (ret < 0)
 		goto out;
 	if (memcmp(testhmac1, authdata1, SHA1_DIGEST_SIZE)) {
@@ -369,11 +386,11 @@ static int TSS_checkhmac2(const unsigned char *buffer,
 		goto out;
 	}
 	ret = TSS_rawhmac(testhmac2, key2, keylen2,
-			  SHA1_DIGEST_SIZE, paramdigest,
-			  TPM_NONCE_SIZE, enonce2->data,
-			  TPM_NONCE_SIZE, ononce->data,
-			  1, continueflag2,
-			  0, 0);
+			  /* 1H2 */ SHA1_DIGEST_SIZE, paramdigest,
+			  /* 2H2 */ TPM_NONCE_SIZE, enonce2->data,
+			  /* 3H2 */ TPM_NONCE_SIZE, ononce->data,
+			  /* 4H2 */ 1, continueflag2,
+			  0, NULL);
 	if (ret < 0)
 		goto out;
 	if (memcmp(testhmac2, authdata2, SHA1_DIGEST_SIZE))
@@ -438,7 +455,7 @@ static int tpm_create_osap(struct tpm_chip *chip,
 	return TSS_rawhmac(s->secret, keyauth, SHA1_DIGEST_SIZE,
 			   TPM_NONCE_SIZE, enonce.data,
 			   TPM_NONCE_SIZE, ononce.data,
-			   0, 0);
+			   0, NULL);
 }
 
 /*
@@ -484,7 +501,7 @@ struct tpm_digests {
  * @encbuffer: Buffer to hold the encrypted data (max SHA1_DIGEST_SIZE)
  * @_enclen: Where to place the size of the encrypted data
  * @encauth: 'Password' to use to encrypt authorisation key
- * @pcrinfo: Information on PCR register values to seal to
+ * @pcrinfo: Information on PCR register values to seal to (must not be NULL)
  * @pcrinfosize: size of @pcrinfo
  *
  * Have the TPM seal (encrypt) the data in the data buffer.  The encryption is
@@ -544,28 +561,16 @@ int tpm_seal(struct tpm_chip *chip,
 		td->encauth[i] = td->xorhash[i] ^ encauth[i];
 
 	/* calculate authorization HMAC value */
-	if (pcrinfosize == 0) {
-		/* no pcr info specified */
-		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
-				   &sess.enonce, &td->ononce, cont,
-				   sizeof(__be32), &ordinal_be,
-				   SHA1_DIGEST_SIZE, td->encauth,
-				   sizeof(__be32), &pcrinfosize_be,
-				   sizeof(__be32), &rawlen_be,
-				   rawlen, rawdata,
-				   0, 0);
-	} else {
-		/* pcr info specified */
-		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
-				   &sess.enonce, &td->ononce, cont,
-				   sizeof(__be32), &ordinal_be,
-				   SHA1_DIGEST_SIZE, td->encauth,
-				   sizeof(__be32), &pcrinfosize_be,
-				   pcrinfosize, pcrinfo,
-				   sizeof(__be32), &rawlen_be,
-				   rawlen, rawdata,
-				   0, 0);
-	}
+	BUG_ON(!pcrinfo);
+	ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
+			   &sess.enonce, &td->ononce, cont,
+			   /* 1S */ sizeof(__be32), &ordinal_be,
+			   /* 2S */ SHA1_DIGEST_SIZE, td->encauth,
+			   /* 3S */ sizeof(__be32), &pcrinfosize_be,
+			   /* 4S */ pcrinfosize, pcrinfo,
+			   /* 5S */ sizeof(__be32), &rawlen_be,
+			   /* 6S */ rawlen, rawdata,
+			   0, NULL);
 	if (ret < 0)
 		goto out;
 
@@ -600,8 +605,8 @@ int tpm_seal(struct tpm_chip *chip,
 	/* check the HMAC in the response */
 	ret = TSS_checkhmac1(tb->data, ordinal_be, &td->ononce,
 			     sess.secret, SHA1_DIGEST_SIZE,
-			     storedsize, TPM_DATA_OFFSET,
-			     0, 0);
+			     /* 3S */ storedsize, TPM_DATA_OFFSET,
+			     0, NULL);
 
 	/* copy the encrypted data to caller's buffer */
 	if (!ret) {
@@ -663,16 +668,16 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 		return ret;
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
 			   &enonce1, &ononce, cont,
-			   sizeof(__be32), &ordinal,
-			   enclen, encdata,
-			   0, 0);
+			   /* 1S */ sizeof(__be32), &ordinal,
+			   /* 2S */ enclen, encdata,
+			   0, NULL);
 	if (ret < 0)
 		return ret;
 	ret = TSS_authhmac(authdata2, decauth, TPM_NONCE_SIZE,
 			   &enonce2, &ononce, cont,
-			   sizeof(__be32), &ordinal,
-			   enclen, encdata,
-			   0, 0);
+			   /* 1S */ sizeof(__be32), &ordinal,
+			   /* 2S */ enclen, encdata,
+			   0, NULL);
 	if (ret < 0)
 		return ret;
 
@@ -703,8 +708,8 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	ret = TSS_checkhmac2(tb->data, ordinal, &ononce,
 			     keyauth, SHA1_DIGEST_SIZE,
 			     decauth, SHA1_DIGEST_SIZE,
-			     sizeof(uint32_t), TPM_DATA_OFFSET,
-			     *_rawlen, TPM_DATA_OFFSET + sizeof(uint32_t),
+			     /* 3S */ sizeof(uint32_t), TPM_DATA_OFFSET,
+			     /* 4S */ *_rawlen, TPM_DATA_OFFSET + sizeof(uint32_t),
 			     0, 0);
 	if (ret < 0) {
 		pr_info("TSS_checkhmac2 failed (%d)\n", ret);


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
