From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/1] add TPM2 version of create_tpm2_key and
 libtpm2.so engine
Date: Sat, 31 Dec 2016 14:52:43 -0800
Message-ID: <1483224763.2518.24.camel@HansenPartnership.com>
References: <1483224485.2518.20.camel@HansenPartnership.com>
Reply-To: openssl-dev@openssl.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <openssl-dev-bounces@openssl.org>
In-Reply-To: <1483224485.2518.20.camel@HansenPartnership.com>
List-Unsubscribe: <https://mta.openssl.org/mailman/options/openssl-dev>,
 <mailto:openssl-dev-request@openssl.org?subject=unsubscribe>
List-Archive: <http://mta.openssl.org/pipermail/openssl-dev/>
List-Post: <mailto:openssl-dev@openssl.org>
List-Help: <mailto:openssl-dev-request@openssl.org?subject=help>
List-Subscribe: <https://mta.openssl.org/mailman/listinfo/openssl-dev>,
 <mailto:openssl-dev-request@openssl.org?subject=subscribe>
Errors-To: openssl-dev-bounces@openssl.org
Sender: "openssl-dev" <openssl-dev-bounces@openssl.org>
To: tpmdd-devel@lists.sourceforge.net, trousers-tech@lists.sourceforge.net, ibmtpm20tss-users@lists.sourceforge.net, openssl-dev@openssl.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patch adds RSA signing for TPM2 keys.  There's a limitation to the
way TPM2 does signing: it must recognise the OID for the signature. 
 That fails for the MD5-SHA1 signatures of the TLS/SSL certificate
verification protocol, so I'm using RSA_Decrypt for both signing
(encryption) and decryption ... meaning that this only works with TPM
decryption keys.  It is possible to use the prior code, which preserved
the distinction of signing and decryption keys, but only at the expense
of not being able to support SSL or TLS lower than 1.2

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---
v2: - use TPM2_RSA_Decrypt for both decryption and signing operations
    - Add authority processing
    - Add TPM internal key creation
    - allow persistent parents
    - update to use transient connections to the TPM
---
 Makefile.am       |  12 +-
 create_tpm2_key.c | 451 +++++++++++++++++++++++++++++++++++++++++++
 e_tpm2.c          | 559 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tpm2-asn.h        |  59 ++++++
 tpm2-common.c     | 175 +++++++++++++++++
 tpm2-common.h     |  10 +
 6 files changed, 1264 insertions(+), 2 deletions(-)
 create mode 100644 create_tpm2_key.c
 create mode 100644 e_tpm2.c
 create mode 100644 tpm2-asn.h
 create mode 100644 tpm2-common.c
 create mode 100644 tpm2-common.h

diff --git a/Makefile.am b/Makefile.am
index 6695656..fb4f529 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,12 +2,20 @@ SUBDIRS=. test
 
 EXTRA_DIST = README  openssl.cnf.sample
 
-openssl_engine_LTLIBRARIES=libtpm.la
-bin_PROGRAMS=create_tpm_key
+openssl_engine_LTLIBRARIES=libtpm.la libtpm2.la
+bin_PROGRAMS=create_tpm_key create_tpm2_key
 openssl_enginedir=@libdir@/openssl/engines
 
 libtpm_la_LIBADD=-lcrypto -lc -ltspi
 libtpm_la_SOURCES=e_tpm.c e_tpm.h e_tpm_err.c
 
+libtpm2_la_LIBADD=-lcrypto -lc -ltss
+libtpm2_la_SOURCES=e_tpm2.c tpm2-common.c
+libtpm2_la_CFLAGS=-g -Werror
+
 create_tpm_key_SOURCES=create_tpm_key.c
 create_tpm_key_LDADD=-ltspi
+
+create_tpm2_key_SOURCES=create_tpm2_key.c tpm2-common.c
+create_tpm2_key_LDADD=-lcrypto -ltss
+create_tpm2_key_CFLAGS=-Werror
diff --git a/create_tpm2_key.c b/create_tpm2_key.c
new file mode 100644
index 0000000..ca3b38f
--- /dev/null
+++ b/create_tpm2_key.c
@@ -0,0 +1,451 @@
+/*
+ *
+ *   Copyright (C) 2016 James Bottomley <James.Bottomley@HansenPartnership.com>
+ *
+ *   GPLv2
+ */
+
+
+#include <stdio.h>
+#include <getopt.h>
+#include <string.h>
+#include <strings.h>
+#include <errno.h>
+
+#include <openssl/rsa.h>
+#include <openssl/pem.h>
+#include <openssl/evp.h>
+#include <openssl/err.h>
+#include <openssl/rand.h>
+
+#include <tss2/tss.h>
+#include <tss2/tssutils.h>
+#include <tss2/tssmarshal.h>
+
+#include "tpm2-asn.h"
+#include "tpm2-common.h"
+
+static struct option long_options[] = {
+	{"auth", 0, 0, 'a'},
+	{"help", 0, 0, 'h'},
+	{"key-size", 1, 0, 's'},
+	{"name-scheme", 1, 0, 'n'},
+	{"parent-handle", 1, 0, 'p'},
+	{"wrap", 1, 0, 'w'},
+	{0, 0, 0, 0}
+};
+
+static TPM_ALG_ID name_alg = TPM_ALG_SHA256;
+static int name_alg_size = SHA256_DIGEST_SIZE;
+
+void
+usage(char *argv0)
+{
+	fprintf(stderr, "\t%s: create a TPM key and write it to disk\n"
+		"\tusage: %s [options] <filename>\n\n"
+		"\tOptions:\n"
+		"\t\t-a|--auth          require a password for the key [NO]\n"
+		"\t\t-h|--help          print this help message\n"
+		"\t\t-s|--key-size      key size in bits [2048]\n"
+		"\t\t-n|--name-scheme   name algorithm to use sha1 [sha256] sha384 sha512\n"
+		"\t\t-p|--parent-handle persistent handle of parent key\n"
+		"\t\t-w|--wrap [file]   wrap an existing openssl PEM key\n"
+		"\nReport bugs to %s\n",
+		argv0, argv0, PACKAGE_BUGREPORT);
+	exit(-1);
+}
+
+void
+openssl_print_errors()
+{
+	ERR_load_ERR_strings();
+	ERR_load_crypto_strings();
+	ERR_print_errors_fp(stderr);
+}
+
+int
+openssl_write_tpmfile(const char *file, BYTE *pubkey, int pubkey_len,
+		      BYTE *privkey, int privkey_len, int empty_auth,
+		      TPM_HANDLE parent)
+{
+	TSSLOADABLE tssl;
+	BIO *outb;
+
+	/* clear structure so as not to have to set optional parameters */
+	memset(&tssl, 0, sizeof(tssl));
+	if ((outb = BIO_new_file(file, "w")) == NULL) {
+                fprintf(stderr, "Error opening file for write: %s\n", file);
+		return 1;
+	}
+	tssl.type = OBJ_txt2obj(OID_loadableKey, 1);
+	tssl.emptyAuth = empty_auth;
+	if ((parent & 0xff000000) == 0x81000000) {
+		tssl.parent = ASN1_INTEGER_new();
+		ASN1_INTEGER_set(tssl.parent, parent);
+	}
+	tssl.pubkey = ASN1_OCTET_STRING_new();
+	ASN1_STRING_set(tssl.pubkey, pubkey, pubkey_len);
+	tssl.privkey = ASN1_OCTET_STRING_new();
+	ASN1_STRING_set(tssl.privkey, privkey, privkey_len);
+
+	PEM_write_bio_TSSLOADABLE(outb, &tssl);
+	BIO_free(outb);
+	return 0;
+}
+
+EVP_PKEY *
+openssl_read_key(char *filename)
+{
+        BIO *b = NULL;
+	EVP_PKEY *pkey;
+
+        b = BIO_new_file(filename, "r");
+        if (b == NULL) {
+                fprintf(stderr, "Error opening file for read: %s\n", filename);
+                return NULL;
+        }
+
+        if ((pkey = PEM_read_bio_PrivateKey(b, NULL, PEM_def_callback, NULL)) == NULL) {
+                fprintf(stderr, "Reading key %s from disk failed.\n", filename);
+                openssl_print_errors();
+        }
+	BIO_free(b);
+
+        return pkey;
+}
+
+void tpm2_public_template_rsa(TPMT_PUBLIC *pub)
+{
+	pub->type = TPM_ALG_RSA;
+	pub->nameAlg = name_alg;
+	/* note: all our keys are decrypt only.  This is because
+	 * we use the TPM2_RSA_Decrypt operation for both signing
+	 * and decryption (see e_tpm2.c for details) */
+	pub->objectAttributes.val = TPMA_OBJECT_NODA |
+		TPMA_OBJECT_DECRYPT |
+		TPMA_OBJECT_USERWITHAUTH;
+	pub->authPolicy.t.size = 0;
+	pub->parameters.rsaDetail.symmetric.algorithm = TPM_ALG_NULL;
+	pub->parameters.rsaDetail.scheme.scheme = TPM_ALG_NULL;
+}
+
+TPM_RC openssl_to_tpm_public_rsa(TPMT_PUBLIC *pub, EVP_PKEY *pkey)
+{
+	RSA *rsa = EVP_PKEY_get1_RSA(pkey);
+	BIGNUM *n, *e;
+	int size = RSA_size(rsa);
+	unsigned long exp;
+
+	if (size > MAX_RSA_KEY_BYTES)
+		return TPM_RC_KEY_SIZE;
+
+#if OPENSSL_VERSION_NUMBER < 0x10100000
+	n = rsa->n;
+	e = rsa->e;
+#else
+	RSA_get0_key(&n, &e, NULL);
+#endif
+	exp = BN_get_word(e);
+	/* TPM limitations means exponents must be under a word in size */
+	if (exp == 0xffffffffL)
+		return TPM_RC_KEY_SIZE;
+	tpm2_public_template_rsa(pub);
+	pub->parameters.rsaDetail.keyBits = size*8;
+	if (exp == 0x10001)
+		pub->parameters.rsaDetail.exponent = 0;
+	else
+		pub->parameters.rsaDetail.exponent = exp;
+
+	pub->unique.rsa.t.size = BN_bn2bin(n, pub->unique.rsa.t.buffer);
+
+	return 0;
+}
+
+TPM_RC openssl_to_tpm_public(TPM2B_PUBLIC *pub, EVP_PKEY *pkey)
+{
+	TPMT_PUBLIC *tpub = &pub->publicArea;
+	pub->size = sizeof(*pub);
+
+	switch (EVP_PKEY_type(pkey->type)) {
+	case EVP_PKEY_RSA:
+		return openssl_to_tpm_public_rsa(tpub, pkey);
+	default:
+		break;
+	}
+	return TPM_RC_ASYMMETRIC;
+}
+
+TPM_RC openssl_to_tpm_private_rsa(TPMT_SENSITIVE *s, EVP_PKEY *pkey)
+{
+	BIGNUM *q;
+	TPM2B_PRIVATE_KEY_RSA *t2brsa = &s->sensitive.rsa;
+	RSA *rsa = EVP_PKEY_get1_RSA(pkey);
+
+#if OPENSSL_VERSION_NUMBER < 0x10100000
+	q = rsa->q;
+#else
+	BIGNUM *p;
+
+	RSA_get0_factors(rsa, &p, &q);
+#endif
+
+	if (!q)
+		return TPM_RC_ASYMMETRIC;
+
+	s->sensitiveType = TPM_ALG_RSA;
+	s->seedValue.b.size = 0;
+
+	t2brsa->t.size = BN_bn2bin(q, t2brsa->t.buffer);
+	return 0;
+}
+
+TPM_RC openssl_to_tpm_private(TPMT_SENSITIVE *priv, EVP_PKEY *pkey)
+{
+	switch (EVP_PKEY_type(pkey->type)) {
+	case EVP_PKEY_RSA:
+		return openssl_to_tpm_private_rsa(priv, pkey);
+	default:
+		break;
+	}
+	return TPM_RC_ASYMMETRIC;
+}
+
+TPM_RC wrap_key(TPM2B_PRIVATE *priv, const char *password, EVP_PKEY *pkey)
+{
+	TPMT_SENSITIVE s;
+	TPM2B_SENSITIVE b;
+	BYTE *buf;
+	int32_t size;
+	TPM_RC rc;
+
+	memset(&b, 0, sizeof(b));
+	memset(&s, 0, sizeof(s));
+
+	openssl_to_tpm_private(&s, pkey);
+
+	if (password) {
+		int len = strlen(password);
+
+		memcpy(s.authValue.b.buffer, password, len);
+		s.authValue.b.size = len;
+	} else {
+		s.authValue.b.size = 0;
+	}
+	size = sizeof(s);
+	buf = b.b.buffer;
+	rc = TSS_TPMT_SENSITIVE_Marshal(&s, &b.b.size, &buf, &size);
+	if (rc)
+		tpm2_error(rc, "TSS_TPMT_SENSITIVE_Marshal");
+
+	size = sizeof(*priv);
+	buf = priv->b.buffer;
+	priv->b.size = 0;
+	/* no encryption means innerIntegrity and outerIntegrity are
+	* absent, so the TPM2B_PRIVATE is a TPMT_SENSITIVE*/
+	rc = TSS_TPM2B_PRIVATE_Marshal((TPM2B_PRIVATE *)&b, &priv->b.size, &buf, &size);
+	if (rc)
+		tpm2_error(rc, "TSS_TPM2B_PRIVATE_Marshal");
+
+	return TPM_RC_ASYMMETRIC;
+}
+
+int main(int argc, char **argv)
+{
+	char *filename, c, *wrap = NULL, *auth = NULL;
+	int option_index;
+	const char *reason;
+	TSS_CONTEXT *tssContext = NULL;
+	TPM_HANDLE parent = 0;
+	TPM_RC rc = 0;
+	BYTE pubkey[sizeof(TPM2B_PUBLIC)],privkey[sizeof(TPM2B_PRIVATE)], *buffer;
+	uint16_t pubkey_len, privkey_len;
+	int32_t size, key_size = 0;
+	TPM2B_PUBLIC *pub;
+	TPM2B_PRIVATE *priv;
+
+
+	while (1) {
+		option_index = 0;
+		c = getopt_long(argc, argv, "n:s:ap:hw:",
+				long_options, &option_index);
+		if (c == -1)
+			break;
+
+		switch (c) {
+			case 'a':
+				auth = malloc(128);
+				break;
+			case 'h':
+				usage(argv[0]);
+				break;
+			case 'n':
+				if (!strcasecmp("sha1", optarg)) {
+					name_alg = TPM_ALG_SHA1;
+					name_alg_size = SHA1_DIGEST_SIZE;
+				} else if (strcasecmp("sha256", optarg)) {
+					/* default, do nothing */
+				} else if (strcasecmp("sha384", optarg)) {
+					name_alg = TPM_ALG_SHA384;
+					name_alg_size = SHA384_DIGEST_SIZE;
+#ifdef TPM_ALG_SHA512
+				} else if (strcasecmp("sha512", optarg)) {
+					name_alg = TPM_ALG_SHA512;
+					name_alg_size = SHA512_DIGEST_SIZE;
+#endif
+				} else {
+					usage(argv[0]);
+				}
+				break;
+			case 'p':
+				parent = strtol(optarg, NULL, 16);
+				break;
+			case's':
+				key_size = atoi(optarg);
+				break;
+			case 'w':
+				wrap = optarg;
+				break;
+			default:
+				usage(argv[0]);
+				break;
+		}
+	}
+
+	filename = argv[argc - 1];
+
+	if (argc < 2)
+		usage(argv[0]);
+
+	if (key_size && wrap) {
+		fprintf(stderr, "key-size and wrap are mutually exclusive\n");
+		usage(argv[0]);
+	} else if (!key_size && !wrap) {
+		/* for internal create, use default key size */
+		key_size = 2048;
+	}
+
+	if (parent && (parent & 0xff000000) != 0x81000000) {
+		fprintf(stderr, "you must specify a persistent parent handle\n");
+		usage(argv[0]);
+	}
+
+	if (auth) {
+		if (EVP_read_pw_string(auth, 128, "Enter TPM key authority: ", 1)) {
+			fprintf(stderr, "Passwords do not match\n");
+			exit(1);
+		}
+	}
+
+	rc = TSS_Create(&tssContext);
+	if (rc) {
+		reason = "TSS_Create";
+		goto out_err;
+	}
+
+	if (parent == 0) {
+		rc = tpm2_load_srk(tssContext, &parent, NULL, NULL);
+		if (rc) {
+			reason = "tpm2_load_srk";
+			goto out_delete;
+		}
+	}
+
+	if (wrap) {
+		Import_In iin;
+		Import_Out iout;
+		EVP_PKEY *pkey;
+
+		/* may be needed to decrypt the key */
+		OpenSSL_add_all_ciphers();
+		pkey = openssl_read_key(wrap);
+		if (!pkey) {
+			reason = "unable to read key";
+			goto out_delete;
+		}
+
+		iin.parentHandle = parent;
+		iin.encryptionKey.t.size = 0;
+		openssl_to_tpm_public(&iin.objectPublic, pkey);
+		/* set random iin.symSeed */
+		iin.inSymSeed.t.size = 0;
+		iin.symmetricAlg.algorithm = TPM_ALG_NULL;
+		wrap_key(&iin.duplicate, auth, pkey);
+		openssl_to_tpm_public(&iin.objectPublic, pkey);
+		rc = TSS_Execute(tssContext,
+				 (RESPONSE_PARAMETERS *)&iout,
+				 (COMMAND_PARAMETERS *)&iin,
+				 NULL,
+				 TPM_CC_Import,
+				 TPM_RS_PW, NULL, 0,
+				 TPM_RH_NULL, NULL, 0,
+				 TPM_RH_NULL, NULL, 0,
+				 TPM_RH_NULL, NULL, 0);
+		if (rc) {
+			reason = "TPM2_Import";
+			goto out_flush;
+		}
+		pub = &iin.objectPublic;
+		priv = &iout.outPrivate;
+	} else {
+		/* create a TPM resident key */
+		Create_In cin;
+		Create_Out cout;
+
+		tpm2_public_template_rsa(&cin.inPublic.publicArea);
+		cin.inPublic.publicArea.objectAttributes.val |=
+			TPMA_OBJECT_SENSITIVEDATAORIGIN;
+		if (auth) {
+			int len = strlen(auth);
+			memcpy(&cin.inSensitive.sensitive.userAuth.b,
+			       auth, len);
+			cin.inSensitive.sensitive.userAuth.b.size = len;
+		} else {
+			cin.inSensitive.sensitive.userAuth.b.size = 0;
+		}
+		cin.inSensitive.sensitive.data.t.size = 0;
+		cin.parentHandle = parent;
+		cin.outsideInfo.t.size = 0;
+		cin.creationPCR.count = 0;
+		cin.inPublic.publicArea.parameters.rsaDetail.keyBits = key_size;
+		cin.inPublic.publicArea.parameters.rsaDetail.exponent = 0;
+		cin.inPublic.publicArea.unique.rsa.t.size = 0;
+
+		rc = TSS_Execute(tssContext,
+				 (RESPONSE_PARAMETERS *)&cout,
+				 (COMMAND_PARAMETERS *)&cin,
+				 NULL,
+				 TPM_CC_Create,
+				 TPM_RS_PW, NULL, 0,
+				 TPM_RH_NULL, NULL, 0,
+				 TPM_RH_NULL, NULL, 0,
+				 TPM_RH_NULL, NULL, 0);
+		if (rc) {
+			reason = "TPM2_Create";
+			goto out_flush;
+		}
+
+		pub = &cout.outPublic;
+		priv = &cout.outPrivate;
+	}
+	tpm2_flush_srk(tssContext);
+	buffer = pubkey;
+	pubkey_len = 0;
+	size = sizeof(pubkey);
+	TSS_TPM2B_PUBLIC_Marshal(pub, &pubkey_len, &buffer, &size);
+	buffer = privkey;
+	privkey_len = 0;
+	size = sizeof(privkey);
+	TSS_TPM2B_PRIVATE_Marshal(priv, &privkey_len, &buffer, &size);
+	openssl_write_tpmfile(filename, pubkey, pubkey_len, privkey, privkey_len, auth == NULL, parent);
+	TSS_Delete(tssContext);
+	exit(0);
+
+ out_flush:
+	tpm2_flush_srk(tssContext);
+ out_delete:
+	TSS_Delete(tssContext);
+ out_err:
+	tpm2_error(rc, reason);
+
+	exit(1);
+}
diff --git a/e_tpm2.c b/e_tpm2.c
new file mode 100644
index 0000000..18e94fe
--- /dev/null
+++ b/e_tpm2.c
@@ -0,0 +1,559 @@
+
+/*
+ * Copyright (C) 2016 James.Bottomley@HansenPartnership.com
+ *
+ * GPLv2
+ *
+ */
+
+#include <stdio.h>
+#include <string.h>
+
+#include <openssl/crypto.h>
+#include <openssl/dso.h>
+#include <openssl/engine.h>
+#include <openssl/evp.h>
+#include <openssl/objects.h>
+#include <openssl/sha.h>
+#include <openssl/bn.h>
+#include <openssl/pem.h>
+#include <openssl/x509.h>
+
+#include <tss2/tss.h>
+#include <tss2/tssutils.h>
+#include <tss2/tssmarshal.h>
+#include <tss2/tssresponsecode.h>
+#include <tss2/Unmarshal_fp.h>
+
+#include "tpm2-asn.h"
+#include "tpm2-common.h"
+
+#define TPM2_ENGINE_EX_DATA_UNINIT		-1
+
+/* structure pointed to by the RSA object's app_data pointer */
+struct rsa_app_data
+{
+	TSS_CONTEXT *tssContext;
+	TPM_HANDLE parent;
+	TPM_HANDLE key;
+	char *auth;
+};
+
+static char *srk_auth;
+
+static int tpm2_engine_init(ENGINE * e)
+{
+	return 1;
+}
+
+static int tpm2_engine_finish(ENGINE * e)
+{
+	return 1;
+}
+
+static int tpm2_create_srk_policy(char *secret)
+{
+	int len;
+
+	if (!secret) {
+		OPENSSL_free(srk_auth);
+		srk_auth = NULL;
+	} else {
+		len = strlen(secret);
+		srk_auth = OPENSSL_malloc(len);
+		strcpy(srk_auth, secret);
+	}
+	return 1;
+}
+
+#define TPM_CMD_PIN ENGINE_CMD_BASE
+
+static int tpm2_engine_ctrl(ENGINE * e, int cmd, long i, void *p, void (*f) ())
+{
+	switch (cmd) {
+		case TPM_CMD_PIN:
+			return tpm2_create_srk_policy(p);
+		default:
+			break;
+	}
+	fprintf(stderr, "tpm2: engine command not implemented\n");
+
+	return 0;
+}
+
+
+#ifndef OPENSSL_NO_RSA
+/* rsa functions */
+static int tpm2_rsa_init(RSA *rsa);
+static int tpm2_rsa_finish(RSA *rsa);
+static int tpm2_rsa_pub_dec(int, const unsigned char *, unsigned char *, RSA *, int);
+static int tpm2_rsa_pub_enc(int, const unsigned char *, unsigned char *, RSA *, int);
+static int tpm2_rsa_priv_dec(int, const unsigned char *, unsigned char *, RSA *, int);
+static int tpm2_rsa_priv_enc(int, const unsigned char *, unsigned char *, RSA *, int);
+//static int tpm2_rsa_sign(int, const unsigned char *, unsigned int, unsigned char *, unsigned int *, const RSA *);
+#endif
+
+/* The definitions for control commands specific to this engine */
+#define TPM2_CMD_PIN		ENGINE_CMD_BASE
+static const ENGINE_CMD_DEFN tpm2_cmd_defns[] = {
+	{TPM2_CMD_PIN,
+	 "PIN",
+	 "Specifies the secret for the SRK (default is plaintext, else set SECRET_MODE)",
+	 ENGINE_CMD_FLAG_STRING},
+	/* end */
+	{0, NULL, NULL, 0}
+};
+
+#ifndef OPENSSL_NO_RSA
+static RSA_METHOD tpm2_rsa = {
+	"TPM2 RSA method",
+	tpm2_rsa_pub_enc,
+	tpm2_rsa_pub_dec,
+	tpm2_rsa_priv_enc,
+	tpm2_rsa_priv_dec,
+	NULL, /* set in tpm2_engine_init */
+	BN_mod_exp_mont,
+	tpm2_rsa_init,
+	tpm2_rsa_finish,
+	(RSA_FLAG_SIGN_VER | RSA_FLAG_NO_BLINDING),
+	NULL,
+	NULL, /* sign */
+	NULL, /* verify */
+	NULL, /* keygen */
+};
+#endif
+
+/* varibles used to get/set CRYPTO_EX_DATA values */
+static int ex_app_data = TPM2_ENGINE_EX_DATA_UNINIT;
+
+static TPM_HANDLE tpm2_load_key_from_rsa(RSA *rsa, TSS_CONTEXT **tssContext, char **auth)
+{
+	struct rsa_app_data *app_data = RSA_get_ex_data(rsa, ex_app_data);
+
+	if (!app_data)
+		return 0;
+
+	*auth = app_data->auth;
+	*tssContext = app_data->tssContext;
+
+	return app_data->key;
+}
+
+static char *tpm2_get_auth(UI_METHOD *ui_method, char *prompt, void *cb_data)
+{
+	UI *ui = UI_new();
+	/* Max auth size is name algorithm hash length, so this
+	 * is way bigger than necessary */
+	char auth[256], *ret = NULL;
+	int len;
+
+	if (ui_method)
+		UI_set_method(ui, ui_method);
+
+	UI_add_user_data(ui, cb_data);
+
+	if (UI_add_input_string(ui, prompt, 0, auth, 0, sizeof(auth)) == 0) {
+		fprintf(stderr, "UI_add_input_string failed\n");
+		goto out;
+	}
+
+	if (UI_process(ui)) {
+		fprintf(stderr, "UI_process failed\n");
+		goto out;
+	}
+
+	len = strlen(auth);
+	ret = OPENSSL_malloc(len + 1);
+	if (!ret)
+		goto out;
+
+	strcpy(ret, auth);
+
+ out:
+	UI_free(ui);
+
+	return ret;
+}
+
+static EVP_PKEY *tpm2_engine_load_key(ENGINE *e, const char *key_id,
+				      UI_METHOD *ui, void *cb_data)
+{
+	Load_In in;
+	Load_Out out;
+	TSS_CONTEXT *tssContext;
+	TPM_RC rc;
+	EVP_PKEY *pkey;
+	RSA *rsa;
+	BIO *bf;
+	TSSLOADABLE *tssl;
+	BYTE *buffer;
+	INT32 size;
+	struct rsa_app_data *app_data;
+	char oid[128];
+	int empty_auth;
+
+	if (!key_id) {
+		fprintf(stderr, "key_id is NULL\n");
+		return NULL;
+	}
+
+	bf = BIO_new_file(key_id, "r");
+	if (!bf) {
+		fprintf(stderr, "File %s does not exist or cannot be read\n", key_id);
+		return NULL;
+	}
+
+	tssl = PEM_read_bio_TSSLOADABLE(bf, NULL, NULL, NULL);
+
+	BIO_free(bf);
+
+	if (!tssl) {
+		fprintf(stderr, "Failed to parse file %s\n", key_id);
+		return NULL;
+	}
+
+	if (OBJ_obj2txt(oid, sizeof(oid), tssl->type, 1) == 0) {
+		fprintf(stderr, "Failed to parse object type\n");
+		goto err;
+	}
+
+	if (strcmp(OID_loadableKey, oid) == 0) {
+		;
+	} else if (strcmp(OID_12Key, oid) == 0) {
+		fprintf(stderr, "TPM1.2 key is not importable by TPM2.0\n");
+		goto err;
+	} else if (strcmp(OID_importableKey, oid) == 0) {
+		fprintf(stderr, "Importable keys currently unsupported\n");
+		goto err;
+	} else {
+		fprintf(stderr, "Unrecognised object type\n");
+		goto err;
+	}
+
+	app_data = OPENSSL_malloc(sizeof(struct rsa_app_data));
+
+	if (!app_data) {
+		fprintf(stderr, "Failed to allocate app_data\n");
+		goto err;
+	}
+
+	rc = TSS_Create(&tssContext);
+	if (rc) {
+		tpm2_error(rc, "TSS_Create");
+		goto err_free;
+	}
+
+	app_data->tssContext = tssContext;
+
+	app_data->parent = 0;
+	if (tssl->parent)
+		app_data->parent = ASN1_INTEGER_get(tssl->parent);
+
+	if (app_data->parent)
+		in.parentHandle = app_data->parent;
+	else
+		tpm2_load_srk(tssContext, &in.parentHandle, srk_auth, NULL);
+
+	empty_auth = tssl->emptyAuth;
+
+	buffer = tssl->privkey->data;
+	size = tssl->privkey->length;
+	TPM2B_PRIVATE_Unmarshal(&in.inPrivate, &buffer, &size);
+	buffer = tssl->pubkey->data;
+	size = tssl->pubkey->length;
+	TPM2B_PUBLIC_Unmarshal(&in.inPublic, &buffer, &size, FALSE);
+
+	/* create the new objects to return */
+	pkey = tpm2_to_openssl_public(&in.inPublic.publicArea);
+	if (!pkey) {
+		fprintf(stderr, "Failed to allocate a new EVP_KEY\n");
+		goto err_free_del;
+	}
+
+	rc = TSS_Execute(tssContext,
+			 (RESPONSE_PARAMETERS *)&out,
+			 (COMMAND_PARAMETERS *)&in,
+			 NULL,
+			 TPM_CC_Load,
+			 TPM_RS_PW, NULL, 0,
+			 TPM_RH_NULL, NULL, 0,
+			 TPM_RH_NULL, NULL, 0,
+			 TPM_RH_NULL, NULL, 0);
+
+	if (rc) {
+		tpm2_error(rc, "TPM2_Load");
+		goto err_free_key;
+	}
+
+	app_data->key = out.objectHandle;
+
+	app_data->auth = NULL;
+	if (empty_auth == 0) {
+		app_data->auth = tpm2_get_auth(ui, "TPM Key Password: ", cb_data);
+		if (!app_data->auth)
+			goto err_unload;
+	}
+
+	TSSLOADABLE_free(tssl);
+	rsa = EVP_PKEY_get1_RSA(pkey);
+	rsa->meth = &tpm2_rsa;
+	/* call our local init function here */
+	rsa->meth->init(rsa);
+
+	RSA_set_ex_data(rsa, ex_app_data, app_data);
+
+	/* release the reference EVP_PKEY_get1_RSA obtained */
+	RSA_free(rsa);
+	return pkey;
+
+ err_unload:
+	tpm2_flush_handle(tssContext, app_data->key);
+ err_free_key:
+	EVP_PKEY_free(pkey);
+ err_free_del:
+	TSS_Delete(tssContext);
+ err_free:
+	OPENSSL_free(app_data);
+	tpm2_flush_srk(tssContext);
+ err:
+	TSSLOADABLE_free(tssl);
+
+	return NULL;
+}
+
+/* Constants used when creating the ENGINE */
+static const char *engine_tpm2_id = "tpm2";
+static const char *engine_tpm2_name = "TPM2 hardware engine support";
+
+/* This internal function is used by ENGINE_tpm() and possibly by the
+ * "dynamic" ENGINE support too */
+static int tpm2_bind_helper(ENGINE * e)
+{
+	if (!ENGINE_set_id(e, engine_tpm2_id) ||
+	    !ENGINE_set_name(e, engine_tpm2_name) ||
+#ifndef OPENSSL_NO_RSA
+	    !ENGINE_set_RSA(e, &tpm2_rsa) ||
+#endif
+	    !ENGINE_set_init_function(e, tpm2_engine_init) ||
+	    !ENGINE_set_finish_function(e, tpm2_engine_finish) ||
+	    !ENGINE_set_ctrl_function(e, tpm2_engine_ctrl) ||
+	    !ENGINE_set_load_pubkey_function(e, tpm2_engine_load_key) ||
+	    !ENGINE_set_load_privkey_function(e, tpm2_engine_load_key) ||
+	    !ENGINE_set_cmd_defns(e, tpm2_cmd_defns))
+		return 0;
+
+	return 1;
+}
+
+
+#ifndef OPENSSL_NO_RSA
+static int tpm2_rsa_init(RSA *rsa)
+{
+	if (ex_app_data == TPM2_ENGINE_EX_DATA_UNINIT)
+		ex_app_data = RSA_get_ex_new_index(0, NULL, NULL, NULL, NULL);
+
+	if (ex_app_data == TPM2_ENGINE_EX_DATA_UNINIT) {
+		fprintf(stderr, "Failed to get memory for external data\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static int tpm2_rsa_finish(RSA *rsa)
+{
+	struct rsa_app_data *app_data = RSA_get_ex_data(rsa, ex_app_data);
+	TSS_CONTEXT *tssContext;
+
+	if (!app_data)
+		return 1;
+
+	tssContext = app_data->tssContext;
+
+	tpm2_flush_handle(tssContext, app_data->key);
+	if (app_data->parent == 0)
+		tpm2_flush_srk(tssContext);
+
+	OPENSSL_free(app_data);
+
+	TSS_Delete(tssContext);
+
+	return 1;
+}
+
+static int tpm2_rsa_pub_dec(int flen,
+			   const unsigned char *from,
+			   unsigned char *to,
+			   RSA *rsa,
+			   int padding)
+{
+	int rv;
+
+	rv = RSA_PKCS1_SSLeay()->rsa_pub_dec(flen, from, to, rsa,
+					     padding);
+	if (rv < 0) {
+		fprintf(stderr, "rsa_pub_dec failed\n");
+		return 0;
+	}
+
+	return rv;
+}
+
+static int tpm2_rsa_priv_dec(int flen,
+			    const unsigned char *from,
+			    unsigned char *to,
+			    RSA *rsa,
+			    int padding)
+{
+	TPM_RC rc;
+	int rv;
+	RSA_Decrypt_In in;
+	RSA_Decrypt_Out out;
+	TSS_CONTEXT *tssContext;
+	char *auth;
+
+	in.keyHandle = tpm2_load_key_from_rsa(rsa, &tssContext, &auth);
+
+	if (in.keyHandle == 0) {
+		rv = RSA_PKCS1_SSLeay()->rsa_priv_dec(flen, from, to, rsa,
+						      padding);
+		if (rv < 0)
+			fprintf(stderr, "rsa_priv_dec failed\n");
+
+		return rv;
+	}
+
+	rv = -1;
+	if (padding != RSA_PKCS1_PADDING) {
+		fprintf(stderr, "Non PKCS1 padding asked for\n");
+		return rv;
+	}
+
+	in.inScheme.scheme = TPM_ALG_RSAES;
+	in.cipherText.t.size = flen;
+	memcpy(in.cipherText.t.buffer, from, flen);
+	in.label.t.size = 0;
+
+	rc = TSS_Execute(tssContext,
+			 (RESPONSE_PARAMETERS *)&out,
+			 (COMMAND_PARAMETERS *)&in,
+			 NULL,
+			 TPM_CC_RSA_Decrypt,
+			 TPM_RS_PW, auth, 0,
+			 TPM_RH_NULL, NULL, 0,
+			 TPM_RH_NULL, NULL, 0,
+			 TPM_RH_NULL, NULL, 0);
+	if (rc) {
+		tpm2_error(rc, "TPM2_RSA_Decrypt");
+		return rv;
+	}
+
+	memcpy(to, out.message.t.buffer,
+	       out.message.t.size);
+
+	rv = out.message.t.size;
+
+	return rv;
+}
+
+static int tpm2_rsa_pub_enc(int flen,
+			   const unsigned char *from,
+			   unsigned char *to,
+			   RSA *rsa,
+			   int padding)
+{
+	int rv;
+
+	rv = RSA_PKCS1_SSLeay()->rsa_pub_enc(flen, from, to, rsa,
+					     padding);
+	if (rv < 0)
+		fprintf(stderr, "rsa_pub_enc failed\n");
+
+	return rv;
+}
+
+static int tpm2_rsa_priv_enc(int flen,
+			    const unsigned char *from,
+			    unsigned char *to,
+			    RSA *rsa,
+			    int padding)
+{
+	TPM_RC rc;
+	int rv, size;
+	RSA_Decrypt_In in;
+	RSA_Decrypt_Out out;
+	TSS_CONTEXT *tssContext;
+	char *auth;
+
+	in.keyHandle = tpm2_load_key_from_rsa(rsa, &tssContext, &auth);
+
+	if (in.keyHandle == 0) {
+		rv = RSA_PKCS1_SSLeay()->rsa_priv_enc(flen, from, to, rsa,
+						      padding);
+		if (rv < 0)
+			fprintf(stderr, "pass through signing failed\n");
+
+		return rv;
+	}
+
+	rv = -1;
+	if (padding != RSA_PKCS1_PADDING) {
+		fprintf(stderr, "Non PKCS1 padding asked for\n");
+		return rv;
+	}
+
+	/* this is slightly paradoxical that we're doing a Decrypt
+	 * operation: the only material difference between decrypt and
+	 * encrypt is where the padding is applied or checked, so if
+	 * you apply your own padding up to the RSA block size and use
+	 * TPM_ALG_NULL, which means no padding check, a decrypt
+	 * operation effectively becomes an encrypt */
+	size = RSA_size(rsa);
+	in.inScheme.scheme = TPM_ALG_NULL;
+	in.cipherText.t.size = size;
+	RSA_padding_add_PKCS1_type_1(in.cipherText.t.buffer, size, from, flen);
+	in.label.t.size = 0;
+
+	rc = TSS_Execute(tssContext,
+			 (RESPONSE_PARAMETERS *)&out,
+			 (COMMAND_PARAMETERS *)&in,
+			 NULL,
+			 TPM_CC_RSA_Decrypt,
+			 TPM_RS_PW, auth, 0,
+			 TPM_RH_NULL, NULL, 0,
+			 TPM_RH_NULL, NULL, 0,
+			 TPM_RH_NULL, NULL, 0);
+
+	if (rc) {
+		tpm2_error(rc, "TPM2_RSA_Decrypt");
+		return rv;
+	}
+
+	memcpy(to, out.message.t.buffer,
+	       out.message.t.size);
+
+	rv = out.message.t.size;
+
+	return rv;
+}
+
+#endif
+
+/* This stuff is needed if this ENGINE is being compiled into a self-contained
+ * shared-library. */
+static int tpm2_bind_fn(ENGINE * e, const char *id)
+{
+	if (id && (strcmp(id, engine_tpm2_id) != 0)) {
+		fprintf(stderr, "Called for id %s != my id %s\n",
+		       id, engine_tpm2_id);
+		return 0;
+	}
+	if (!tpm2_bind_helper(e)) {
+		fprintf(stderr, "tpm2_bind_helper failed\n");
+		return 0;
+	}
+	return 1;
+}
+
+IMPLEMENT_DYNAMIC_CHECK_FN()
+IMPLEMENT_DYNAMIC_BIND_FN(tpm2_bind_fn)
diff --git a/tpm2-asn.h b/tpm2-asn.h
new file mode 100644
index 0000000..2a08e3a
--- /dev/null
+++ b/tpm2-asn.h
@@ -0,0 +1,59 @@
+/* Copyright (C) 2016 James Bottomley <James.Bottomley@HansenPartnership.com>
+ *
+ * GPLv2
+ */
+#ifndef _TPM2_ASN_H
+#define _TPM2_ASN_H
+
+#include <openssl/asn1t.h>
+
+/*
+ * Define the format of a TPM key file.  The current format covers
+ * both TPM1.2 keys as well as symmetrically encrypted private keys
+ * produced by TSS2_Import and the TPM2 format public key which
+ * contains things like the policy but which is cryptographically tied
+ * to the private key.
+ *
+ * TPMKey ::= SEQUENCE {
+ *	type		OBJECT IDENTIFIER
+ *	emptyAuth	[0] EXPLICIT BOOLEAN OPTIONAL
+ *	parent		[1] EXPLICIT INTEGER OPTIONAL
+ *	pubkey		[2] EXPLICIT OCTET STRING OPTIONAL
+ *	privkey		OCTET STRING
+ * }
+ */
+
+typedef struct {
+	ASN1_OBJECT *type;
+	ASN1_BOOLEAN emptyAuth;
+	ASN1_INTEGER *parent;
+	ASN1_OCTET_STRING *pubkey;
+	ASN1_OCTET_STRING *privkey;
+} TSSLOADABLE;
+
+/* the two type oids are in the TCG namespace 2.23.133; we choose an
+ *  unoccupied child (10) for keytype file and two values:
+ *    1 : Key that is directly loadable
+ *    2 : Key that must first be imported then loaded
+ */
+#define OID_12Key		"2.23.133.10.1"
+#define OID_loadableKey		"2.23.133.10.2"
+#define OID_importableKey	"2.23.133.10.3"
+
+ASN1_SEQUENCE(TSSLOADABLE) = {
+	ASN1_SIMPLE(TSSLOADABLE, type, ASN1_OBJECT),
+	ASN1_EXP_OPT(TSSLOADABLE, emptyAuth, ASN1_BOOLEAN, 0),
+	ASN1_EXP_OPT(TSSLOADABLE, parent, ASN1_INTEGER, 1),
+	ASN1_EXP_OPT(TSSLOADABLE, pubkey, ASN1_OCTET_STRING, 2),
+	ASN1_SIMPLE(TSSLOADABLE, privkey, ASN1_OCTET_STRING)
+} ASN1_SEQUENCE_END(TSSLOADABLE)
+
+IMPLEMENT_ASN1_FUNCTIONS(TSSLOADABLE);
+
+/* This is the PEM guard tag */
+#define TSSLOADABLE_PEM_STRING "TSS2 KEY BLOB"
+
+static IMPLEMENT_PEM_write_bio(TSSLOADABLE, TSSLOADABLE, TSSLOADABLE_PEM_STRING, TSSLOADABLE)
+static IMPLEMENT_PEM_read_bio(TSSLOADABLE, TSSLOADABLE, TSSLOADABLE_PEM_STRING, TSSLOADABLE)
+
+#endif
diff --git a/tpm2-common.c b/tpm2-common.c
new file mode 100644
index 0000000..1b6569c
--- /dev/null
+++ b/tpm2-common.c
@@ -0,0 +1,175 @@
+/*
+ * Copyright (C) 2016 James Bottomley <James.Bottomley@HansenPartnership.com>
+ *
+ * GPLv2
+ */
+
+#include <stdio.h>
+
+#include <openssl/evp.h>
+#include <openssl/rsa.h>
+
+#include <tss2/tss.h>
+#include <tss2/tssresponsecode.h>
+
+#include "tpm2-common.h"
+
+void tpm2_error(TPM_RC rc, const char *reason)
+{
+	const char *msg, *submsg, *num;
+
+	fprintf(stderr, "%s failed with %d\n", reason, rc);
+	TSS_ResponseCode_toString(&msg, &submsg, &num, rc);
+	fprintf(stderr, "%s%s%s\n", msg, submsg, num);
+}
+
+
+static TPM_HANDLE hSRK = 0;
+
+TPM_RC tpm2_load_srk(TSS_CONTEXT *tssContext, TPM_HANDLE *h, const char *auth,TPM2B_PUBLIC *pub)
+{
+	static TPM2B_PUBLIC srk_pub;
+	TPM_RC rc;
+	CreatePrimary_In in;
+	CreatePrimary_Out out;
+
+	if (hSRK)
+		goto out;
+
+	/* SPS owner */
+	in.primaryHandle = TPM_RH_OWNER;
+	/* assume no owner password */
+	in.inSensitive.sensitive.userAuth.t.size = 0;
+	/* no sensitive date for storage keys */
+	in.inSensitive.sensitive.data.t.size = 0;
+	/* no outside info */
+	in.outsideInfo.t.size = 0;
+	/* no PCR state */
+	in.creationPCR.count = 0;
+
+	/* public parameters for an RSA2048 key  */
+	in.inPublic.publicArea.type = TPM_ALG_RSA;
+	in.inPublic.publicArea.nameAlg = TPM_ALG_SHA256;
+	in.inPublic.publicArea.objectAttributes.val =
+		TPMA_OBJECT_NODA |
+		TPMA_OBJECT_SENSITIVEDATAORIGIN |
+		TPMA_OBJECT_USERWITHAUTH |
+		TPMA_OBJECT_DECRYPT |
+		TPMA_OBJECT_RESTRICTED;
+	in.inPublic.publicArea.parameters.rsaDetail.symmetric.algorithm = TPM_ALG_AES;
+	in.inPublic.publicArea.parameters.rsaDetail.symmetric.keyBits.aes = 128;
+	in.inPublic.publicArea.parameters.rsaDetail.symmetric.mode.aes = TPM_ALG_CFB;
+	in.inPublic.publicArea.parameters.rsaDetail.scheme.scheme = TPM_ALG_NULL;
+	in.inPublic.publicArea.parameters.rsaDetail.keyBits = 2048;
+	/* means conventional 2^16+1 */
+	in.inPublic.publicArea.parameters.rsaDetail.exponent = 0;
+	in.inPublic.publicArea.unique.rsa.t.size = 0;
+	in.inPublic.publicArea.authPolicy.t.size = 0;
+
+	rc = TSS_Execute(tssContext,
+			 (RESPONSE_PARAMETERS *)&out,
+			 (COMMAND_PARAMETERS *)&in,
+			 NULL,
+			 TPM_CC_CreatePrimary,
+			 TPM_RS_PW, NULL, 0,
+			 TPM_RH_NULL, NULL, 0,
+			 TPM_RH_NULL, NULL, 0,
+			 TPM_RH_NULL, NULL, 0);
+
+	if (rc) {
+		tpm2_error(rc, "TSS_CreatePrimarhy");
+		return rc;
+	}
+
+	hSRK = out.objectHandle;
+	srk_pub = out.outPublic;
+ out:
+	*h = hSRK;
+	if (pub)
+		*pub = srk_pub;
+
+	return 0;
+}
+
+void tpm2_flush_srk(TSS_CONTEXT *tssContext)
+{
+	if (hSRK)
+		tpm2_flush_handle(tssContext, hSRK);
+	hSRK = 0;
+}
+
+void tpm2_flush_handle(TSS_CONTEXT *tssContext, TPM_HANDLE h)
+{
+	FlushContext_In in;
+
+	if (!h)
+		return;
+
+	in.flushHandle = h;
+	TSS_Execute(tssContext, NULL,
+		    (COMMAND_PARAMETERS *)&in,
+		    NULL,
+		    TPM_CC_FlushContext,
+		    TPM_RH_NULL, NULL, 0);
+}
+
+static EVP_PKEY *tpm2_to_openssl_public_rsa(TPMT_PUBLIC *pub)
+{
+	RSA *rsa = RSA_new();
+	EVP_PKEY *pkey;
+	unsigned long exp;
+	BIGNUM *n, *e;
+
+	if (!rsa)
+		return NULL;
+	pkey = EVP_PKEY_new();
+	if (!pkey)
+		goto err_free_rsa;
+	e = BN_new();
+	if (!e)
+		goto err_free_pkey;
+	n = BN_new();
+	if (!n)
+		goto err_free_e;
+	if (pub->parameters.rsaDetail.exponent == 0)
+		exp = 0x10001;
+	else
+		exp = pub->parameters.rsaDetail.exponent;
+	if (!BN_set_word(e, exp))
+		goto err_free;
+	if (!BN_bin2bn(pub->unique.rsa.t.buffer, pub->unique.rsa.t.size, n))
+		goto err_free;
+#if OPENSSL_VERSION_NUMBER < 0x10100000
+	rsa->n = n;
+	rsa->e = e;
+#else
+	RSA_set0_key(rsa, n, e, NULL);
+#endif
+	if (!EVP_PKEY_assign_RSA(pkey, rsa))
+		goto err_free;
+
+	return pkey;
+
+ err_free:
+	BN_free(n);
+ err_free_e:
+	BN_free(e);
+ err_free_pkey:
+	EVP_PKEY_free(pkey);
+ err_free_rsa:
+	RSA_free(rsa);
+
+	return NULL;
+}
+
+EVP_PKEY *tpm2_to_openssl_public(TPMT_PUBLIC *pub)
+{
+	switch (pub->type) {
+	case TPM_ALG_RSA:
+		return tpm2_to_openssl_public_rsa(pub);
+	default:
+		break;
+	}
+	return NULL;
+}
+
diff --git a/tpm2-common.h b/tpm2-common.h
new file mode 100644
index 0000000..abd750b
--- /dev/null
+++ b/tpm2-common.h
@@ -0,0 +1,10 @@
+#ifndef _TPM2_COMMON_H
+#define _TPM2_COMMON_H
+
+void tpm2_error(TPM_RC rc, const char *reason);
+TPM_RC tpm2_load_srk(TSS_CONTEXT *tssContext, TPM_HANDLE *h, const char *auth, TPM2B_PUBLIC *pub);
+void tpm2_flush_handle(TSS_CONTEXT *tssContext, TPM_HANDLE h);
+EVP_PKEY *tpm2_to_openssl_public(TPMT_PUBLIC *pub);
+void tpm2_flush_srk(TSS_CONTEXT *tssContext);
+
+#endif
-- 
2.6.6

-- 
openssl-dev mailing list
To unsubscribe: https://mta.openssl.org/mailman/listinfo/openssl-dev
