From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 21/23] TPMLIB: Implement call to TPM_LoadKey2
Date: Tue, 21 Aug 2018 16:59:11 +0100
Message-ID: <153486715192.13066.16960521772592007978.stgit@warthog.procyon.org.uk>
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

Implement a function to invoke TPM_LoadKey2

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-library.c |   93 ++++++++++++++++++++++++++++++++++++++++
 include/linux/tpm.h            |    7 +++
 include/linux/tpm_command.h    |    1 
 3 files changed, 101 insertions(+)

diff --git a/drivers/char/tpm/tpm-library.c b/drivers/char/tpm/tpm-library.c
index 3413abeb3635..d279243ccc00 100644
--- a/drivers/char/tpm/tpm-library.c
+++ b/drivers/char/tpm/tpm-library.c
@@ -1017,6 +1017,99 @@ out:
 }
 EXPORT_SYMBOL_GPL(tpm_create_wrap_key);
 
+/**
+ * tpm_load_key2 - Load a key and decrypt it
+ * @chip: The chip to use
+ * @tb: Large scratch buffer for I/O
+ * @parent_type: Type of entity attached to @parent_handle
+ * @parent_handle: TPM-resident key used to encrypt
+ * @parent_auth: Parent authorisation HMAC key
+ * @wrapped_key: The wrapped key
+ * @_key_handle: The TPM's handle on the key
+ *
+ * Have the TPM decrypt a key and load it into its memory.  The TPM then
+ * returns a handle to the key that we can use in other operations.
+ *
+ * AUTH1 is used for sealing key.
+ */
+int tpm_load_key2(struct tpm_chip *chip,
+		  enum tpm_entity_type parent_type,
+		  uint32_t parent_handle,
+		  const unsigned char *parent_auth,
+		  const struct tpm_wrapped_key *wrapped_key,
+		  uint32_t *_key_handle)
+{
+	struct tpm_osapsess sess;
+	struct tpm_digests *td;
+	struct tpm_buf *tb;
+	unsigned char cont;
+	__be32 ordinal_be;
+	int ret;
+
+	kenter("");
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
+	/* Set up the parameters we will be sending */
+	ret = tpm_gen_odd_nonce(chip, &td->ononce);
+	if (ret < 0)
+		goto out;
+
+	/* calculate authorization HMAC value */
+	ordinal_be = cpu_to_be32(TPM_ORD_LOADKEY2);
+	cont = 0;
+	ret = TSS_authhmac(td->pubauth, sess.secret, SHA1_DIGEST_SIZE,
+			   &sess.enonce, &td->ononce, cont,
+			   /* 1S */ sizeof(__be32), &ordinal_be,
+			   /* 2S */ wrapped_key->data_len, wrapped_key->data,
+			   0, NULL);
+	if (ret < 0)
+		goto out;
+
+	/* build and send the TPM request packet */
+	INIT_BUF(tb);
+	store16(tb, TPM_TAG_RQU_AUTH1_COMMAND);
+	store32(tb, TPM_DATA_OFFSET + 4 + wrapped_key->data_len + 45);
+	store32(tb, TPM_ORD_LOADKEY2);
+	store32(tb, parent_handle);
+	store_s(tb, wrapped_key->data, wrapped_key->data_len);
+	store32(tb, sess.handle);
+	store_s(tb, td->ononce.data, TPM_NONCE_SIZE);
+	store_8(tb, cont);
+	store_s(tb, td->pubauth, SHA1_DIGEST_SIZE);
+
+	ret = tpm_send_dump(chip, tb, "loading key");
+	if (ret < 0)
+		goto out;
+
+	/* Check the HMAC in the response */
+	ret = TSS_checkhmac1(tb, ordinal_be, &td->ononce,
+			     sess.secret, SHA1_DIGEST_SIZE,
+			     0, NULL);
+	if (ret < 0)
+		goto out;
+
+	*_key_handle = LOAD32(tb);
+	ret = 0;
+
+out:
+	kfree(tb);
+	kleave(" = %d [%08x]", ret, *_key_handle);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tpm_load_key2);
+
 /**
  * tpm_library_use - Tell the TPM library we want to make use of it
  *
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 0bc954ac8266..2be0decff93b 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -147,4 +147,11 @@ extern int tpm_create_wrap_key(struct tpm_chip *chip,
 			       const unsigned char *usage_auth,
 			       const unsigned char *migration_auth,
 			       struct tpm_wrapped_key **_wrapped_key);
+extern int tpm_load_key2(struct tpm_chip *chip,
+			 enum tpm_entity_type parent_type,
+			 uint32_t parent_handle,
+			 const unsigned char *parent_auth,
+			 const struct tpm_wrapped_key *wrapped_key,
+			 uint32_t *_key_handle);
+
 #endif
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index 0417a3db7e8f..211d4ce75f67 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -23,6 +23,7 @@ enum tpm_ordinal {
 	TPM_ORD_SEAL			= 23,
 	TPM_ORD_UNSEAL			= 24,
 	TPM_ORD_CREATEWRAPKEY		= 31,
+	TPM_ORD_LOADKEY2		= 65,
 	TPM_ORD_GET_RANDOM		= 70,
 	TPM_ORD_CONTINUE_SELFTEST	= 83,
 	TPM_ORD_GET_CAP			= 101,


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
