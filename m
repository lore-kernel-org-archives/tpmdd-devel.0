From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 18/23] TPMLIB: Encapsulate XOR-based
 encryption with authkey derivative
Date: Tue, 21 Aug 2018 16:58:51 +0100
Message-ID: <153486713189.13066.10919642243213217779.stgit@warthog.procyon.org.uk>
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

Encapsulate XOR-based encryption with a symmetric key derived from the authkey
so that it can be used in multiple functions.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |   42 +++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index 329b5c3f23a2..9234a2e7608f 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -489,6 +489,30 @@ struct tpm_digests {
 	struct tpm_odd_nonce ononce;
 };
 
+/*
+ * Calculate an XOR-based symmetric key that can be used to encrypt protected
+ * data.  The key is left in td->xorhash.
+ */
+static int tpm_calc_symmetric_authkey(struct tpm_digests *td,
+				      const u8 *secret,
+				      const struct tpm_even_nonce *enonce)
+{
+	memcpy(td->xorwork, secret, SHA1_DIGEST_SIZE);
+	memcpy(td->xorwork + SHA1_DIGEST_SIZE, enonce->data, SHA1_DIGEST_SIZE);
+	return TSS_sha1(td->xorwork, SHA1_DIGEST_SIZE * 2, td->xorhash);
+}
+
+/*
+ * Encrypt/decrypt data with a previously calculated XOR-based symmetric key.
+ */
+static void tpm_crypt_with_authkey(const struct tpm_digests *td,
+				   const u8 *data, u8 *buffer)
+{
+	int i;
+	for (i = 0; i < SHA1_DIGEST_SIZE; ++i)
+		buffer[i] = td->xorhash[i] ^ data[i];
+}
+
 /**
  * tpm_seal - Encrypt one key according to another plus PCR state
  * @chip: The chip to use
@@ -528,7 +552,6 @@ int tpm_seal(struct tpm_chip *chip,
 	int encdatasize;
 	int storedsize;
 	int ret;
-	int i;
 
 	/* alloc some work space for all the hashes */
 	td = kmalloc(sizeof *td, GFP_KERNEL);
@@ -541,13 +564,18 @@ int tpm_seal(struct tpm_chip *chip,
 		goto out;
 	dump_sess(&sess);
 
-	/* calculate encrypted authorization value */
-	memcpy(td->xorwork, sess.secret, SHA1_DIGEST_SIZE);
-	memcpy(td->xorwork + SHA1_DIGEST_SIZE, sess.enonce.data, SHA1_DIGEST_SIZE);
-	ret = TSS_sha1(td->xorwork, SHA1_DIGEST_SIZE * 2, td->xorhash);
+	/* We need to pass a 'password' to the TPM with which it will encrypt
+	 * the sealed data before returning it.  So that the password doesn't
+	 * travel to the TPM in the clear, we generate a symmetric key from the
+	 * negotiated and encrypted session data and encrypt the password with
+	 * that.
+	 */
+	ret = tpm_calc_symmetric_authkey(td, sess.secret, &sess.enonce);
 	if (ret < 0)
 		goto out;
+	tpm_crypt_with_authkey(td, encauth, td->encauth);
 
+	/* Set up the parameters we will be sending */
 	ret = tpm_gen_odd_nonce(chip, &td->ononce);
 	if (ret < 0)
 		goto out;
@@ -556,10 +584,6 @@ int tpm_seal(struct tpm_chip *chip,
 	pcrinfosize_be	= cpu_to_be32(pcrinfosize);
 	cont = 0;
 
-	/* encrypt data authorization key */
-	for (i = 0; i < SHA1_DIGEST_SIZE; ++i)
-		td->encauth[i] = td->xorhash[i] ^ encauth[i];
-
 	/* calculate authorization HMAC value */
 	BUG_ON(!pcrinfo);
 	ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
