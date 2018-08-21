From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 20/23] TPMLIB: Implement call to
 TPM_CreateWrapKey
Date: Tue, 21 Aug 2018 16:59:05 +0100
Message-ID: <153486714520.13066.16385120783665804621.stgit@warthog.procyon.org.uk>
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

Implement a function to invoke TPM_CreateWrapKey.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |  248 ++++++++++++++++++++++++++++++++++++++++
 include/linux/tpm.h            |   16 ++-
 include/linux/tpm_command.h    |    1 
 3 files changed, 264 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index 0676165322a3..3413abeb3635 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -500,6 +500,7 @@ static int tpm_create_oiap(struct tpm_chip *chip, struct tpm_buf *tb,
 
 struct tpm_digests {
 	unsigned char encauth[SHA1_DIGEST_SIZE];
+	unsigned char encauth2[SHA1_DIGEST_SIZE];
 	unsigned char pubauth[SHA1_DIGEST_SIZE];
 	unsigned char xorwork[SHA1_DIGEST_SIZE * 2];
 	unsigned char xorhash[SHA1_DIGEST_SIZE];
@@ -769,6 +770,253 @@ out:
 }
 EXPORT_SYMBOL_GPL(tpm_unseal);
 
+enum tpm_key_usage {
+	TPM_KEY_SIGNING			= 0x0010,
+	TPM_KEY_STORAGE			= 0x0011,
+	TPM_KEY_IDENTITY		= 0x0012,
+	TPM_KEY_AUTHCHANGE		= 0x0013,
+	TPM_KEY_BIND			= 0x0014,
+	TPM_KEY_LEGACY			= 0x0015,
+	TPM_KEY_MIGRATE			= 0x0016,
+};
+
+enum tpm_algorithm_id {
+	TPM_ALG_RSA			= 0x00000001,
+	TPM_ALG_SHA			= 0x00000004,
+	TPM_ALG_HMAC			= 0x00000005,
+	TPM_ALG_AES128			= 0x00000006,
+	TPM_ALG_MGF1			= 0x00000007,
+	TPM_ALG_AES192			= 0x00000008,
+	TPM_ALG_AES256			= 0x00000009,
+	TPM_ALG_XOR			= 0x0000000a,
+};
+
+enum tpm_enc_scheme {
+	TPM_ES_NONE			= 0x0001,
+	TPM_ES_RSAESPKCSv15		= 0x0002,
+	TPM_ES_RSAESOAEP_SHA1_MGF1	= 0x0003,
+	TPM_ES_SYM_CTR			= 0x0004,
+	TPM_ES_SYM_OFB			= 0x0005,
+};
+
+enum tpm_sig_scheme {
+	TPM_SS_NONE			= 0x0001,
+	TPM_SS_RSAESPKCSv15_SHA1	= 0x0002,
+	TPM_SS_RSAESPKCSv15_DER		= 0x0003,
+	TPM_SS_RSAESPKCSv15_INFO	= 0x0004,
+};
+
+enum tpm_auth_data_usage {
+	TPM_AUTH_NEVER			= 0x00,
+	TPM_AUTH_ALWAYS			= 0x01,
+	TPM_NO_READ_PUBKEY_AUTH		= 0x03,
+};
+
+#define TPM_KEY_REDIRECTION		0x00000001
+#define TPM_KEY_MIGRATABLE		0x00000002
+#define TPM_KEY_ISVOLATILE		0x00000004
+#define TPM_KEY_PCRIGNOREDONREAD	0x00000008
+#define TPM_KEY_MIGRATEAUTHORITY	0x00000010
+
+struct tpm_key {
+	struct tpm_struct_ver {
+		u8	major, minor, rev_major, rev_minor;
+	} ver;
+	__be16		key_usage;		/* enum tpm_key_usage */
+	__be32		key_flags;
+	u8		auth_data_usage;	/* enum tpm_auth_data_usage */
+	struct tpm_key_parms {
+		__be32		algorithm_id;	/* enum tpm_algorithm_id */
+		__be16		enc_scheme;	/* enum tpm_enc_scheme */
+		__be16		sig_scheme;	/* enum tpm_sig_scheme */
+		__be32		parm_size;
+		struct tpm_rsa_key_parms {
+			__be32		key_length;
+			__be32		num_primes;
+			__be32		exponent_size;
+		} __packed rsa;
+	} __packed parms;
+	__be32		pcr_info_size;
+	struct tpm_store_pubkey {
+		__be32		key_length;
+		u8		key_data[0];
+	} __packed pub;
+	__be32		enc_data_size;
+	u8		enc_data[0];
+} __packed;
+
+/**
+ * tpm_create_wrap_key - Generate a new key and return it encrypted
+ * @chip: The chip to use
+ * @tb: Large scratch buffer for I/O
+ * @parent_type: Type of entity attached to @parent_handle
+ * @parent_handle: TPM-resident key used to encrypt
+ * @parent_auth: Parent authorisation HMAC key
+ * @usage_auth: Encrypted usage authdata for the key
+ * @migration_auth: Encrypted migration authdata for the key (or NULL)
+ * @_wrapped_key: Pointer to where to return the wrapped key (kmalloc'd)
+ *
+ * Have the TPM generate a new key and return it encrypted.  The encryption is
+ * based on a key already resident in the TPM and may also include the state of
+ * one or more Platform Configuration Registers (PCRs).
+ *
+ * AUTH1 is used for sealing key.
+ */
+int tpm_create_wrap_key(struct tpm_chip *chip,
+			enum tpm_entity_type parent_type,
+			uint32_t parent_handle,
+			const unsigned char *parent_auth,
+			const unsigned char *usage_auth,
+			const unsigned char *migration_auth,
+			struct tpm_wrapped_key **_wrapped_key)
+{
+	struct tpm_wrapped_key *wrapped_key;
+	struct tpm_osapsess sess;
+	struct tpm_digests *td;
+	struct tpm_buf *tb;
+	struct tpm_key *result;
+	unsigned char cont;
+	__be32 ordinal_be;
+	int key_size;
+	int ret;
+
+	struct tpm_key tpm_key = {
+		.ver			= { 0x01, 0x01, 0x00, 0x00 },
+		.key_usage		= cpu_to_be16(TPM_KEY_SIGNING),
+		.key_flags		= cpu_to_be32(0),
+		.auth_data_usage	= TPM_AUTH_ALWAYS,
+		.parms.algorithm_id	= cpu_to_be32(TPM_ALG_RSA),
+		.parms.enc_scheme	= cpu_to_be16(TPM_ES_RSAESPKCSv15),
+		.parms.sig_scheme	= cpu_to_be16(TPM_SS_RSAESPKCSv15_SHA1),
+		.parms.parm_size	= cpu_to_be32(sizeof(struct tpm_rsa_key_parms)),
+		.parms.rsa.key_length	= cpu_to_be32(2048),
+		.parms.rsa.num_primes	= cpu_to_be32(2),
+		.parms.rsa.exponent_size = cpu_to_be32(0),
+		.pcr_info_size		= cpu_to_be32(0),
+		.pub.key_length		= cpu_to_be32(0),
+		.enc_data_size		= cpu_to_be32(0),
+	};
+
+	kenter("");
+
+	if (migration_auth)
+		tpm_key.key_flags |= cpu_to_be32(TPM_KEY_MIGRATABLE);
+
+	/* alloc some work space */
+	tb = kmalloc(sizeof(*tb) + sizeof(*td), GFP_KERNEL);
+	if (!tb)
+		return -ENOMEM;
+	td = (void *)tb + sizeof(*tb);
+
+	/* Get the encryption session */
+	ret = tpm_create_osap(chip, tb, &sess,
+			      parent_auth, parent_type, parent_handle);
+	if (ret < 0)
+		goto out;
+	dump_sess(&sess);
+
+	/* We need to pass 'passwords' to the TPM with which it will encrypt
+	 * the key before returning it.  So that the passwords don't travel to
+	 * the TPM in the clear, we generate a symmetric key from the
+	 * negotiated and encrypted session data and encrypt the passwords with
+	 * that.
+	 */
+	ret = tpm_calc_symmetric_authkey(td, sess.secret, &sess.enonce);
+	if (ret < 0)
+		goto out;
+	tpm_crypt_with_authkey(td, usage_auth, td->encauth);
+	if (migration_auth)
+		tpm_crypt_with_authkey(td, migration_auth, td->encauth2);
+	else
+		tpm_crypt_with_authkey(td, sess.enonce.data, td->encauth2);
+
+	/* Set up the parameters we will be sending */
+	ret = tpm_gen_odd_nonce(chip, &td->ononce);
+	if (ret < 0)
+		goto out;
+
+	/* calculate authorization HMAC value */
+	ordinal_be = cpu_to_be32(TPM_ORD_CREATEWRAPKEY);
+	cont = 0;
+	ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
+			   &sess.enonce, &td->ononce, cont,
+			   /* 1S */ sizeof(__be32), &ordinal_be,
+			   /* 2S */ SHA1_DIGEST_SIZE, td->encauth,
+			   /* 3S */ SHA1_DIGEST_SIZE, td->encauth2,
+			   /* 4S */ sizeof(tpm_key), &tpm_key,
+			   0, NULL);
+	if (ret < 0)
+		goto out;
+
+	/* build and send the TPM request packet */
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_AUTH1_COMMAND);
+	store32(tb, TPM_DATA_OFFSET + 44 + sizeof(tpm_key) + 45);
+	store32(tb, TPM_ORD_CREATEWRAPKEY);
+	store32(tb, parent_handle);
+	store_s(tb, td->encauth, SHA1_DIGEST_SIZE);
+	store_s(tb, td->encauth2, SHA1_DIGEST_SIZE);
+	store_s(tb, &tpm_key, sizeof(tpm_key));
+	store32(tb, sess.handle);
+	store_s(tb, td->ononce.data, TPM_NONCE_SIZE);
+	store_8(tb, cont);
+	store_s(tb, td->pubauth, SHA1_DIGEST_SIZE);
+
+	ret = tpm_send_dump(chip, tb, "creating key");
+	if (ret < 0)
+		goto out;
+
+	/* We need to work out how big the TPM_KEY or TPM_KEY12 struct we got
+	 * back is.  These structs have several variable-length fields inside
+	 * to make parsing more difficult.  However, they are only followed by
+	 * fixed-length structs...
+	 */
+	SET_BUF_OFFSET(tb, TPM_SIZE_OFFSET);
+	key_size = LOAD32(tb);
+	key_size -= TPM_DATA_OFFSET;
+	key_size -= 2 * TPM_NONCE_SIZE + 1;
+	if (key_size < sizeof(tpm_key)) {
+		ret = -EBADMSG;
+		goto out;
+	}
+
+	/* Check the HMAC in the response */
+	ret = TSS_checkhmac1(tb, ordinal_be, &td->ononce,
+			     sess.secret, SHA1_DIGEST_SIZE,
+			     /* 3S */ key_size, TPM_DATA_OFFSET,
+			     0, NULL);
+	if (ret < 0)
+		goto out;
+
+	/* Parse the key */
+	result = (void *)tb->data + TPM_DATA_OFFSET;
+	ret = -EBADMSG;
+	if (key_size < sizeof(tpm_key) + be32_to_cpu(tpm_key.parms.rsa.key_length) / 8)
+		goto out;
+	if (memcmp(result, &tpm_key, offsetof(struct tpm_key, pub.key_length)) != 0)
+		goto out;
+	if (be32_to_cpu(result->pub.key_length) >
+	    be32_to_cpu(tpm_key.parms.rsa.key_length) / 8)
+		goto out;
+
+	ret = -ENOMEM;
+	wrapped_key = kmalloc(sizeof(struct tpm_wrapped_key) + key_size, GFP_KERNEL);
+	if (!wrapped_key)
+		goto out;
+	wrapped_key->data_len = key_size;
+	wrapped_key->pubkey_offset = offsetof(struct tpm_key, pub.key_data);
+	wrapped_key->pubkey_len = be32_to_cpu(result->pub.key_length);
+	memcpy(wrapped_key->data, result, key_size);
+	*_wrapped_key = wrapped_key;
+	ret = 0;
+
+out:
+	kfree(tb);
+	kleave(" = %d", ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tpm_create_wrap_key);
+
 /**
  * tpm_library_use - Tell the TPM library we want to make use of it
  *
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 398bfaef2325..0bc954ac8266 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -83,7 +83,7 @@ static inline int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max) {
  */
 /* implementation specific TPM constants */
 #define MAX_PCRINFO_SIZE		64
-#define MAX_BUF_SIZE			512
+#define MAX_BUF_SIZE			(2048 - 4)
 #define TPM_GETRANDOM_SIZE		14
 #define TPM_OSAP_SIZE			36
 #define TPM_OIAP_SIZE			10
@@ -133,4 +133,18 @@ extern int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 		      const unsigned char *blobauth,
 		      unsigned char *data, unsigned int *datalen);
 
+struct tpm_wrapped_key {
+	unsigned short data_len;
+	unsigned short pubkey_offset;
+	unsigned short pubkey_len;
+	u8 data[];
+};
+
+extern int tpm_create_wrap_key(struct tpm_chip *chip,
+			       enum tpm_entity_type parent_type,
+			       uint32_t parent_handle,
+			       const unsigned char *parent_auth,
+			       const unsigned char *usage_auth,
+			       const unsigned char *migration_auth,
+			       struct tpm_wrapped_key **_wrapped_key);
 #endif
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index a3e0bb670e62..0417a3db7e8f 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -22,6 +22,7 @@ enum tpm_ordinal {
 	TPM_ORD_PCR_READ		= 21,
 	TPM_ORD_SEAL			= 23,
 	TPM_ORD_UNSEAL			= 24,
+	TPM_ORD_CREATEWRAPKEY		= 31,
 	TPM_ORD_GET_RANDOM		= 70,
 	TPM_ORD_CONTINUE_SELFTEST	= 83,
 	TPM_ORD_GET_CAP			= 101,


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
