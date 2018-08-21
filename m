From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 19/23] TPMLIB: Add some debugging code
Date: Tue, 21 Aug 2018 16:58:58 +0100
Message-ID: <153486713849.13066.10617410138420494526.stgit@warthog.procyon.org.uk>
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

Add some pr_devel() statements to make debugging easier.  They only exist
within the kernel if DEBUG is defined.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |   58 ++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index 9234a2e7608f..0676165322a3 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -21,6 +21,8 @@
 #include <linux/tpm_command.h>
 
 #include "tpm-library.h"
+#define kenter(fmt, ...) pr_devel("==>%s("fmt")\n", __func__, ## __VA_ARGS__)
+#define kleave(fmt, ...) pr_devel("<==%s()"fmt"\n", __func__, ## __VA_ARGS__)
 
 static const char tpm_hmac_alg[] = "hmac(sha1)";
 static const char tpm_hash_alg[] = "sha1";
@@ -95,7 +97,7 @@ static int TSS_rawhmac(unsigned char *digest,
 	va_list argp;
 	unsigned int dlen;
 	unsigned char *data;
-	int ret;
+	int ret, s;
 
 	sdesc = tpm_init_sdesc(tpm_hmacalg);
 	if (IS_ERR(sdesc)) {
@@ -111,11 +113,12 @@ static int TSS_rawhmac(unsigned char *digest,
 		goto out;
 
 	va_start(argp, keylen);
-	for (;;) {
+	for (s = 1;; s++) {
 		dlen = va_arg(argp, unsigned int);
 		data = va_arg(argp, unsigned char *);
 		if (!data)
 			break;
+		pr_devel("RAWHMAC %dH1: [%u] %*phN\n", s, dlen, dlen, data);
 		ret = crypto_shash_update(&sdesc->shash, data, dlen);
 		if (ret < 0)
 			break;
@@ -152,7 +155,7 @@ static int TSS_authhmac(unsigned char *digest,
 	struct tpm_sdesc *sdesc;
 	unsigned int dlen;
 	unsigned char *data;
-	int ret;
+	int ret, s;
 	va_list argp;
 
 	sdesc = tpm_init_sdesc(tpm_hashalg);
@@ -165,11 +168,12 @@ static int TSS_authhmac(unsigned char *digest,
 	if (ret < 0)
 		goto out;
 	va_start(argp, cont);
-	for (;;) {
+	for (s = 1;; s++) {
 		dlen = va_arg(argp, unsigned int);
 		data = va_arg(argp, unsigned char *);
 		if (!data)
 			break;
+		pr_devel("AUTHHASH S%d: [%u] %*phN\n", s, dlen, dlen, data);
 		ret = crypto_shash_update(&sdesc->shash, data, dlen);
 		if (ret < 0)
 			break;
@@ -411,6 +415,9 @@ static int tpm_send_dump(struct tpm_chip *chip, struct tpm_buf *cmd,
 {
 	int rc;
 
+	kenter(",{%u,%u},%s",
+	       cmd->len, be32_to_cpu(*(__be32 *)(cmd->data + TPM_SIZE_OFFSET)), desc);
+
 	dump_tpm_buf(cmd);
 	rc = tpm_send_command(chip, cmd->data, MAX_BUF_SIZE, desc);
 	dump_tpm_buf(cmd);
@@ -419,6 +426,7 @@ static int tpm_send_dump(struct tpm_chip *chip, struct tpm_buf *cmd,
 		rc = -EPERM;
 	else
 		SET_BUF_OFFSET(cmd, TPM_DATA_OFFSET);
+	kleave(" = %d [%u]", rc, be32_to_cpu(*(__be32 *)(cmd->data + TPM_SIZE_OFFSET)));
 	return rc;
 }
 
@@ -434,6 +442,8 @@ static int tpm_create_osap(struct tpm_chip *chip,
 	struct tpm_odd_nonce ononce;
 	int ret;
 
+	kenter("");
+
 	ret = tpm_gen_odd_nonce(chip, &ononce);
 	if (ret < 0)
 		return ret;
@@ -448,16 +458,20 @@ static int tpm_create_osap(struct tpm_chip *chip,
 
 	ret = tpm_send_dump(chip, tb, "creating OSAP session");
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	s->handle = LOAD32(tb);
 	LOAD_S(tb, s->enonce.data, TPM_NONCE_SIZE);
 	LOAD_S(tb, enonce.data, TPM_NONCE_SIZE);
 
-	return TSS_rawhmac(s->secret, keyauth, SHA1_DIGEST_SIZE,
-			   TPM_NONCE_SIZE, enonce.data,
-			   TPM_NONCE_SIZE, ononce.data,
-			   0, NULL);
+	/* Calculate the encrypted shared secret */
+	ret = TSS_rawhmac(s->secret, keyauth, SHA1_DIGEST_SIZE,
+			  TPM_NONCE_SIZE, enonce.data,
+			  TPM_NONCE_SIZE, ononce.data,
+			  0, NULL);
+out:
+	kleave(" = %d [%08x]", ret, s->handle);
+	return ret;
 }
 
 /*
@@ -468,6 +482,8 @@ static int tpm_create_oiap(struct tpm_chip *chip, struct tpm_buf *tb,
 {
 	int ret;
 
+	kenter("");
+
 	INIT_BUF(tb);
 	store16(tb, TPM_TAG_RQU_COMMAND);
 	store32(tb, TPM_OIAP_SIZE);
@@ -478,6 +494,7 @@ static int tpm_create_oiap(struct tpm_chip *chip, struct tpm_buf *tb,
 
 	*handle = LOAD32(tb);
 	LOAD_S(tb, enonce->data, TPM_NONCE_SIZE);
+	kleave(" = 0 [%08x]", *handle);
 	return 0;
 }
 
@@ -553,6 +570,8 @@ int tpm_seal(struct tpm_chip *chip,
 	int storedsize;
 	int ret;
 
+	kenter("");
+
 	/* alloc some work space for all the hashes */
 	td = kmalloc(sizeof *td, GFP_KERNEL);
 	if (!td)
@@ -641,6 +660,7 @@ int tpm_seal(struct tpm_chip *chip,
 	}
 out:
 	kfree(td);
+	kleave(" = %d", ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(tpm_seal);
@@ -676,36 +696,38 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	__be32 ordinal;
 	int ret;
 
+	kenter("");
+
 	/* sessions for unsealing key and data */
 	ret = tpm_create_oiap(chip, tb, &authhandle1, &enonce1);
 	if (ret < 0) {
 		pr_info("Failed to create OIAP 1 (%d)\n", ret);
-		return ret;
+		goto out;
 	}
 	ret = tpm_create_oiap(chip, tb, &authhandle2, &enonce2);
 	if (ret < 0) {
 		pr_info("Failed to create OIAP 2 (%d)\n", ret);
-		return ret;
+		goto out;
 	}
 
 	ordinal = cpu_to_be32(TPM_ORD_UNSEAL);
 	ret = tpm_gen_odd_nonce(chip, &ononce);
 	if (ret < 0)
-		return ret;
+		goto out;
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
 			   &enonce1, &ononce, cont,
 			   /* 1S */ sizeof(__be32), &ordinal,
 			   /* 2S */ enclen, encdata,
 			   0, NULL);
 	if (ret < 0)
-		return ret;
+		goto out;
 	ret = TSS_authhmac(authdata2, decauth, TPM_NONCE_SIZE,
 			   &enonce2, &ononce, cont,
 			   /* 1S */ sizeof(__be32), &ordinal,
 			   /* 2S */ enclen, encdata,
 			   0, NULL);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	/* build and send TPM request packet */
 	INIT_BUF(tb);
@@ -726,7 +748,7 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	ret = tpm_send_dump(chip, tb, "unsealing data");
 	if (ret < 0) {
 		pr_info("authhmac failed (%d)\n", ret);
-		return ret;
+		goto out;
 	}
 
 	*_rawlen = LOAD32(tb);
@@ -738,10 +760,12 @@ int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 			     0, 0);
 	if (ret < 0) {
 		pr_info("TSS_checkhmac2 failed (%d)\n", ret);
-		return ret;
+		goto out;
 	}
 	LOAD_S(tb, rawbuffer, *_rawlen);
-	return 0;
+out:
+	kleave(" = %d", ret);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tpm_unseal);
 


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
