From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/23] TPMLIB: Use __be32 rather than int32_t
 and use cpu_to_beX() and co.
Date: Tue, 21 Aug 2018 16:58:30 +0100
Message-ID: <153486711068.13066.16019818060381526218.stgit@warthog.procyon.org.uk>
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

Use __be32 rather than int32_t and use cpu_to_beX() and co. rather than
htonl() and co.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |   58 ++++++++++++++++++----------------------
 drivers/char/tpm/tpm-library.h |   14 +++++-----
 2 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index 1eea483cf36b..f14980be5ebb 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -201,15 +201,14 @@ out:
  * verify the AUTH1_COMMAND (Seal) result from TPM
  */
 static int TSS_checkhmac1(unsigned char *buffer,
-			  const uint32_t command,
+			  __be32 ordinal,
 			  const struct tpm_odd_nonce *ononce,
 			  const unsigned char *key, unsigned keylen,
 			  ...)
 {
 	uint32_t bufsize;
 	uint16_t tag;
-	uint32_t ordinal;
-	uint32_t result;
+	__be32 result;
 	struct tpm_even_nonce *enonce;
 	unsigned char *continueflag;
 	unsigned char *authdata;
@@ -223,8 +222,7 @@ static int TSS_checkhmac1(unsigned char *buffer,
 
 	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
 	tag = LOAD16(buffer, 0);
-	ordinal = command;
-	result = LOAD32N(buffer, TPM_RETURN_OFFSET);
+	result = LOAD32BE(buffer, TPM_RETURN_OFFSET);
 	if (tag == TPM_TAG_RSP_COMMAND)
 		return 0;
 	if (tag != TPM_TAG_RSP_AUTH1_COMMAND)
@@ -246,7 +244,7 @@ static int TSS_checkhmac1(unsigned char *buffer,
 	if (ret < 0)
 		goto out;
 	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&ordinal,
-				  sizeof ordinal);
+				  sizeof(ordinal));
 	if (ret < 0)
 		goto out;
 	va_start(argp, keylen);
@@ -285,7 +283,7 @@ out:
  * verify the AUTH2_COMMAND (unseal) result from TPM
  */
 static int TSS_checkhmac2(const unsigned char *buffer,
-			  const uint32_t command,
+			  __be32 ordinal,
 			  const struct tpm_odd_nonce *ononce,
 			  const unsigned char *key1, unsigned keylen1,
 			  const unsigned char *key2, unsigned keylen2,
@@ -293,8 +291,7 @@ static int TSS_checkhmac2(const unsigned char *buffer,
 {
 	uint32_t bufsize;
 	uint16_t tag;
-	uint32_t ordinal;
-	uint32_t result;
+	__be32 result;
 	const struct tpm_even_nonce *enonce1;
 	const unsigned char *continueflag1;
 	const unsigned char *authdata1;
@@ -312,8 +309,7 @@ static int TSS_checkhmac2(const unsigned char *buffer,
 
 	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
 	tag = LOAD16(buffer, 0);
-	ordinal = command;
-	result = LOAD32N(buffer, TPM_RETURN_OFFSET);
+	result = LOAD32BE(buffer, TPM_RETURN_OFFSET);
 
 	if (tag == TPM_TAG_RSP_COMMAND)
 		return 0;
@@ -336,11 +332,11 @@ static int TSS_checkhmac2(const unsigned char *buffer,
 	if (ret < 0)
 		goto out;
 	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&result,
-				  sizeof result);
+				  sizeof(result));
 	if (ret < 0)
 		goto out;
 	ret = crypto_shash_update(&sdesc->shash, (const u8 *)&ordinal,
-				  sizeof ordinal);
+				  sizeof(ordinal));
 	if (ret < 0)
 		goto out;
 
@@ -508,9 +504,9 @@ int tpm_seal(struct tpm_chip *chip,
 	struct tpm_osapsess sess;
 	struct tpm_digests *td;
 	unsigned char cont;
-	uint32_t ordinal;
-	uint32_t pcrsize;
-	uint32_t datsize;
+	__be32 ordinal_be;
+	__be32 rawlen_be;
+	__be32 pcrinfosize_be;
 	int sealinfosize;
 	int encdatasize;
 	int storedsize;
@@ -538,9 +534,9 @@ int tpm_seal(struct tpm_chip *chip,
 	ret = tpm_gen_odd_nonce(chip, &td->ononce);
 	if (ret < 0)
 		goto out;
-	ordinal = htonl(TPM_ORD_SEAL);
-	datsize = htonl(rawlen);
-	pcrsize = htonl(pcrinfosize);
+	ordinal_be	= cpu_to_be32(TPM_ORD_SEAL);
+	rawlen_be	= cpu_to_be32(rawlen);
+	pcrinfosize_be	= cpu_to_be32(pcrinfosize);
 	cont = 0;
 
 	/* encrypt data authorization key */
@@ -552,21 +548,21 @@ int tpm_seal(struct tpm_chip *chip,
 		/* no pcr info specified */
 		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
 				   &sess.enonce, &td->ononce, cont,
-				   sizeof(uint32_t), &ordinal,
+				   sizeof(__be32), &ordinal_be,
 				   SHA1_DIGEST_SIZE, td->encauth,
-				   sizeof(uint32_t), &pcrsize,
-				   sizeof(uint32_t), &datsize,
+				   sizeof(__be32), &pcrinfosize_be,
+				   sizeof(__be32), &rawlen_be,
 				   rawlen, rawdata,
 				   0, 0);
 	} else {
 		/* pcr info specified */
 		ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
 				   &sess.enonce, &td->ononce, cont,
-				   sizeof(uint32_t), &ordinal,
+				   sizeof(__be32), &ordinal_be,
 				   SHA1_DIGEST_SIZE, td->encauth,
-				   sizeof(uint32_t), &pcrsize,
+				   sizeof(__be32), &pcrinfosize_be,
 				   pcrinfosize, pcrinfo,
-				   sizeof(uint32_t), &datsize,
+				   sizeof(__be32), &rawlen_be,
 				   rawlen, rawdata,
 				   0, 0);
 	}
@@ -602,7 +598,7 @@ int tpm_seal(struct tpm_chip *chip,
 	    sizeof(uint32_t) + encdatasize;
 
 	/* check the HMAC in the response */
-	ret = TSS_checkhmac1(tb->data, ordinal, &td->ononce,
+	ret = TSS_checkhmac1(tb->data, ordinal_be, &td->ononce,
 			     sess.secret, SHA1_DIGEST_SIZE,
 			     storedsize, TPM_DATA_OFFSET,
 			     0, 0);
@@ -646,8 +642,7 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	uint32_t authhandle1 = 0;
 	uint32_t authhandle2 = 0;
 	unsigned char cont = 0;
-	uint32_t ordinal;
-	uint32_t keyhndl;
+	__be32 ordinal;
 	int ret;
 
 	/* sessions for unsealing key and data */
@@ -662,21 +657,20 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 		return ret;
 	}
 
-	ordinal = htonl(TPM_ORD_UNSEAL);
-	keyhndl = htonl(SRKHANDLE);
+	ordinal = cpu_to_be32(TPM_ORD_UNSEAL);
 	ret = tpm_gen_odd_nonce(chip, &ononce);
 	if (ret < 0)
 		return ret;
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
 			   &enonce1, &ononce, cont,
-			   sizeof(uint32_t), &ordinal,
+			   sizeof(__be32), &ordinal,
 			   enclen, encdata,
 			   0, 0);
 	if (ret < 0)
 		return ret;
 	ret = TSS_authhmac(authdata2, decauth, TPM_NONCE_SIZE,
 			   &enonce2, &ononce, cont,
-			   sizeof(uint32_t), &ordinal,
+			   sizeof(__be32), &ordinal,
 			   enclen, encdata,
 			   0, 0);
 	if (ret < 0)
diff --git a/drivers/char/tpm/tpm-library.h b/drivers/char/tpm/tpm-library.h
index 861e67df27fc..c12d451704a2 100644
--- a/drivers/char/tpm/tpm-library.h
+++ b/drivers/char/tpm/tpm-library.h
@@ -11,9 +11,9 @@
  */
 
 
-#define LOAD32(buffer, offset)	(ntohl(*(uint32_t *)&buffer[offset]))
-#define LOAD32N(buffer, offset)	(*(uint32_t *)&buffer[offset])
-#define LOAD16(buffer, offset)	(ntohs(*(uint16_t *)&buffer[offset]))
+#define LOAD32BE(buffer, offset) (*(__be32 *)&buffer[(offset)])
+#define LOAD16(buffer, offset)	(be16_to_cpu(*(__be16 *)&buffer[(offset)]))
+#define LOAD32(buffer, offset)	(be32_to_cpu(LOAD32BE(buffer, (offset))))
 
 struct tpm_even_nonce {
 	unsigned char data[TPM_NONCE_SIZE];
@@ -36,14 +36,14 @@ static inline void store_8(struct tpm_buf *buf, unsigned char value)
 
 static inline void store16(struct tpm_buf *buf, uint16_t value)
 {
-	*(uint16_t *)&buf->data[buf->len] = htons(value);
-	buf->len += sizeof value;
+	*(__be16 *)&buf->data[buf->len] = cpu_to_be16(value);
+	buf->len += sizeof(value);
 }
 
 static inline void store32(struct tpm_buf *buf, uint32_t value)
 {
-	*(uint32_t *)&buf->data[buf->len] = htonl(value);
-	buf->len += sizeof value;
+	*(__be32 *)&buf->data[buf->len] = cpu_to_be32(value);
+	buf->len += sizeof(value);
 }
 
 static inline void store_s(struct tpm_buf *buf, const void *in, int len)


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
