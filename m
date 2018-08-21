From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 17/23] TPMLIB: Provide a wrapper to load bytes
 out of the reply
Date: Tue, 21 Aug 2018 16:58:45 +0100
Message-ID: <153486712522.13066.16199758850117818658.stgit@warthog.procyon.org.uk>
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

Provide a wrapper for memcpy to load bytes out of the reply, similar to
LOAD32() and friends.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |   87 ++++++++++++++++++++--------------------
 drivers/char/tpm/tpm-library.h |   43 +++++++++++++++++---
 include/linux/tpm.h            |    3 +
 3 files changed, 82 insertions(+), 51 deletions(-)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index 46cd12d30ec6..329b5c3f23a2 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -199,7 +199,7 @@ out:
  * @...: Pairs of size and pointer of data elements to load into hash
  * @0,NULL: Terminator
  */
-static int TSS_checkhmac1(unsigned char *buffer,
+static int TSS_checkhmac1(struct tpm_buf *tb,
 			  __be32 ordinal,
 			  const struct tpm_odd_nonce *ononce,
 			  const unsigned char *key, unsigned keylen,
@@ -219,14 +219,16 @@ static int TSS_checkhmac1(unsigned char *buffer,
 	va_list argp;
 	int ret;
 
-	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
-	tag = LOAD16(buffer, 0);
-	result = LOAD32BE(buffer, TPM_RETURN_OFFSET);
+	SET_BUF_OFFSET(tb, 0);
+	tag = LOAD16(tb);
+	bufsize = LOAD32(tb);
+	result = LOAD32BE(tb);
 	if (tag == TPM_TAG_RSP_COMMAND)
 		return 0;
 	if (tag != TPM_TAG_RSP_AUTH1_COMMAND)
 		return -EINVAL;
-	authdata = buffer + bufsize - SHA1_DIGEST_SIZE;
+
+	authdata = tb->data + bufsize - SHA1_DIGEST_SIZE;
 	continueflag = authdata - 1;
 	enonce = (void *)continueflag - TPM_NONCE_SIZE;
 
@@ -255,7 +257,7 @@ static int TSS_checkhmac1(unsigned char *buffer,
 		dpos = va_arg(argp, unsigned int);
 		if (!dlen && !dpos)
 			break;
-		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
+		ret = crypto_shash_update(&sdesc->shash, tb->data + dpos, dlen);
 		if (ret < 0)
 			break;
 	}
@@ -296,7 +298,7 @@ out:
  *
  * verify the AUTH2_COMMAND (unseal) result from TPM
  */
-static int TSS_checkhmac2(const unsigned char *buffer,
+static int TSS_checkhmac2(struct tpm_buf *tb,
 			  __be32 ordinal,
 			  const struct tpm_odd_nonce *ononce,
 			  const unsigned char *key1, unsigned keylen1,
@@ -321,17 +323,17 @@ static int TSS_checkhmac2(const unsigned char *buffer,
 	va_list argp;
 	int ret;
 
-	bufsize = LOAD32(buffer, TPM_SIZE_OFFSET);
-	tag = LOAD16(buffer, 0);
-	result = LOAD32BE(buffer, TPM_RETURN_OFFSET);
+	bufsize = LOAD32(tb);
+	tag = LOAD16(tb);
+	result = LOAD32BE(tb);
 
 	if (tag == TPM_TAG_RSP_COMMAND)
 		return 0;
 	if (tag != TPM_TAG_RSP_AUTH2_COMMAND)
 		return -EINVAL;
-	authdata1 = buffer + bufsize - (SHA1_DIGEST_SIZE + 1
+	authdata1 = tb->data + bufsize - (SHA1_DIGEST_SIZE + 1
 			+ SHA1_DIGEST_SIZE + SHA1_DIGEST_SIZE);
-	authdata2 = buffer + bufsize - (SHA1_DIGEST_SIZE);
+	authdata2 = tb->data + bufsize - (SHA1_DIGEST_SIZE);
 	continueflag1 = authdata1 - 1;
 	continueflag2 = authdata2 - 1;
 	enonce1 = (const void *)continueflag1 - TPM_NONCE_SIZE;
@@ -363,7 +365,7 @@ static int TSS_checkhmac2(const unsigned char *buffer,
 		dpos = va_arg(argp, unsigned int);
 		if (!dlen && !dpos)
 			break;
-		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
+		ret = crypto_shash_update(&sdesc->shash, tb->data + dpos, dlen);
 		if (ret < 0)
 			break;
 	}
@@ -404,17 +406,19 @@ out:
  * For key specific tpm requests, we will generate and send our
  * own TPM command packets using the drivers send function.
  */
-static int tpm_send_dump(struct tpm_chip *chip,
-			 unsigned char *cmd, size_t buflen, const char *desc)
+static int tpm_send_dump(struct tpm_chip *chip, struct tpm_buf *cmd,
+			 const char *desc)
 {
 	int rc;
 
 	dump_tpm_buf(cmd);
-	rc = tpm_send_command(chip, cmd, buflen, desc);
+	rc = tpm_send_command(chip, cmd->data, MAX_BUF_SIZE, desc);
 	dump_tpm_buf(cmd);
 	if (rc > 0)
 		/* Can't return positive return codes values to keyctl */
 		rc = -EPERM;
+	else
+		SET_BUF_OFFSET(cmd, TPM_DATA_OFFSET);
 	return rc;
 }
 
@@ -442,16 +446,14 @@ static int tpm_create_osap(struct tpm_chip *chip,
 	store32(tb, keyhandle);
 	store_s(tb, ononce.data, TPM_NONCE_SIZE);
 
-	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
-			    "creating OSAP session");
+	ret = tpm_send_dump(chip, tb, "creating OSAP session");
 	if (ret < 0)
 		return ret;
 
-	s->handle = LOAD32(tb->data, TPM_DATA_OFFSET);
-	memcpy(s->enonce.data, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)]),
-	       TPM_NONCE_SIZE);
-	memcpy(enonce.data, &(tb->data[TPM_DATA_OFFSET + sizeof(uint32_t) +
-				  TPM_NONCE_SIZE]), TPM_NONCE_SIZE);
+	s->handle = LOAD32(tb);
+	LOAD_S(tb, s->enonce.data, TPM_NONCE_SIZE);
+	LOAD_S(tb, enonce.data, TPM_NONCE_SIZE);
+
 	return TSS_rawhmac(s->secret, keyauth, SHA1_DIGEST_SIZE,
 			   TPM_NONCE_SIZE, enonce.data,
 			   TPM_NONCE_SIZE, ononce.data,
@@ -470,14 +472,12 @@ static int tpm_create_oiap(struct tpm_chip *chip, struct tpm_buf *tb,
 	store16(tb, TPM_TAG_RQU_COMMAND);
 	store32(tb, TPM_OIAP_SIZE);
 	store32(tb, TPM_ORD_OIAP);
-	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
-			    "creating OIAP session");
+	ret = tpm_send_dump(chip, tb, "creating OIAP session");
 	if (ret < 0)
 		return ret;
 
-	*handle = LOAD32(tb->data, TPM_DATA_OFFSET);
-	memcpy(enonce->data, &tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)],
-	       TPM_NONCE_SIZE);
+	*handle = LOAD32(tb);
+	LOAD_S(tb, enonce->data, TPM_NONCE_SIZE);
 	return 0;
 }
 
@@ -590,27 +590,29 @@ int tpm_seal(struct tpm_chip *chip,
 	store_8(tb, cont);
 	store_s(tb, td->pubauth, SHA1_DIGEST_SIZE);
 
-	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
-			    "sealing data");
+	ret = tpm_send_dump(chip, tb, "sealing data");
 	if (ret < 0)
 		goto out;
 
-	/* calculate the size of the returned encrypted data */
-	sealinfosize = LOAD32(tb->data, TPM_DATA_OFFSET + sizeof(uint32_t));
-	encdatasize = LOAD32(tb->data, TPM_DATA_OFFSET + sizeof(uint32_t) +
-			     sizeof(uint32_t) + sealinfosize);
-	storedsize = sizeof(uint32_t) + sizeof(uint32_t) + sealinfosize +
-	    sizeof(uint32_t) + encdatasize;
+	/* Look inside the TPM_STORED_DATA object to calculate the size of the
+	 * returned encrypted data.
+	 */
+	SET_BUF_OFFSET(tb, TPM_DATA_OFFSET + sizeof(uint32_t));
+	sealinfosize = LOAD32(tb);
+	SET_BUF_OFFSET(tb, TPM_DATA_OFFSET + sizeof(uint32_t) * 2 + sealinfosize);
+	storedsize = sizeof(uint32_t) * 2 + sealinfosize +
+		sizeof(uint32_t) + encdatasize;
 
 	/* check the HMAC in the response */
-	ret = TSS_checkhmac1(tb->data, ordinal_be, &td->ononce,
+	ret = TSS_checkhmac1(tb, ordinal_be, &td->ononce,
 			     sess.secret, SHA1_DIGEST_SIZE,
 			     /* 3S */ storedsize, TPM_DATA_OFFSET,
 			     0, NULL);
 
 	/* copy the encrypted data to caller's buffer */
 	if (!ret) {
-		memcpy(encbuffer, tb->data + TPM_DATA_OFFSET, storedsize);
+		SET_BUF_OFFSET(tb, TPM_DATA_OFFSET);
+		LOAD_S(tb, encbuffer, storedsize);
 		*_enclen = storedsize;
 	}
 out:
@@ -697,15 +699,14 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	store_8(tb, cont);
 	store_s(tb, authdata2, SHA1_DIGEST_SIZE);
 
-	ret = tpm_send_dump(chip, tb->data, MAX_BUF_SIZE,
-			    "unsealing data");
+	ret = tpm_send_dump(chip, tb, "unsealing data");
 	if (ret < 0) {
 		pr_info("authhmac failed (%d)\n", ret);
 		return ret;
 	}
 
-	*_rawlen = LOAD32(tb->data, TPM_DATA_OFFSET);
-	ret = TSS_checkhmac2(tb->data, ordinal, &ononce,
+	*_rawlen = LOAD32(tb);
+	ret = TSS_checkhmac2(tb, ordinal, &ononce,
 			     keyauth, SHA1_DIGEST_SIZE,
 			     decauth, SHA1_DIGEST_SIZE,
 			     /* 3S */ sizeof(uint32_t), TPM_DATA_OFFSET,
@@ -715,7 +716,7 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 		pr_info("TSS_checkhmac2 failed (%d)\n", ret);
 		return ret;
 	}
-	memcpy(rawbuffer, tb->data + TPM_DATA_OFFSET + sizeof(uint32_t), *_rawlen);
+	LOAD_S(tb, rawbuffer, *_rawlen);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_unseal);
diff --git a/drivers/char/tpm/tpm-library.h b/drivers/char/tpm/tpm-library.h
index c12d451704a2..3e288624b8e8 100644
--- a/drivers/char/tpm/tpm-library.h
+++ b/drivers/char/tpm/tpm-library.h
@@ -11,10 +11,6 @@
  */
 
 
-#define LOAD32BE(buffer, offset) (*(__be32 *)&buffer[(offset)])
-#define LOAD16(buffer, offset)	(be16_to_cpu(*(__be16 *)&buffer[(offset)]))
-#define LOAD32(buffer, offset)	(be32_to_cpu(LOAD32BE(buffer, (offset))))
-
 struct tpm_even_nonce {
 	unsigned char data[TPM_NONCE_SIZE];
 };
@@ -29,6 +25,38 @@ struct tpm_osapsess {
 	struct tpm_even_nonce enonce;
 };
 
+static inline void SET_BUF_OFFSET(struct tpm_buf *buffer, unsigned offset)
+{
+	buffer->offset = offset;
+}
+
+static inline uint16_t LOAD16(struct tpm_buf *buffer)
+{
+	__be16 *p = (__be16 *)(buffer->data + buffer->offset);
+	buffer->offset += 2;
+	return be16_to_cpup(p);
+}
+
+static inline __be32 LOAD32BE(struct tpm_buf *buffer)
+{
+	__be32 val = *(__be32 *)(buffer->data + buffer->offset);
+	buffer->offset += 4;
+	return val;
+}
+
+static inline uint32_t LOAD32(struct tpm_buf *buffer)
+{
+	__be32 *p = (__be32 *)(buffer->data + buffer->offset);
+	buffer->offset += 4;
+	return be32_to_cpup(p);
+}
+
+static inline void LOAD_S(struct tpm_buf *buffer, void *data_buffer, size_t amount)
+{
+	memcpy(data_buffer, buffer->data + buffer->offset, amount);
+	buffer->offset += amount;
+}
+
 static inline void store_8(struct tpm_buf *buf, unsigned char value)
 {
 	buf->data[buf->len++] = value;
@@ -70,13 +98,14 @@ static inline void dump_sess(struct tpm_osapsess *s)
 		       16, 1, &s->enonce, SHA1_DIGEST_SIZE, 0);
 }
 
-static inline void dump_tpm_buf(unsigned char *buf)
+static inline void dump_tpm_buf(struct tpm_buf *tb)
 {
 	int len;
 
 	pr_info("\ntpm buffer\n");
-	len = LOAD32(buf, TPM_SIZE_OFFSET);
-	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, buf, len, 0);
+	SET_BUF_OFFSET(tb, TPM_SIZE_OFFSET);
+	len = LOAD32(tb);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, tb->data, len, 0);
 }
 
 #else
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index cbd13e03a869..398bfaef2325 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -110,7 +110,8 @@ enum tpm_entity_type {
 };
 
 struct tpm_buf {
-	int len;
+	unsigned short len;
+	unsigned short offset;
 	unsigned char data[MAX_BUF_SIZE];
 };
 


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
