From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RFC 1/4] tpm: migrate struct tpm_buf to struct
	tpm_chip
Date: Mon,  2 Jan 2017 15:22:07 +0200
Message-ID: <20170102132213.22880-2-jarkko.sakkinen@linux.intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170102132213.22880-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Since there is only one thread using TPM chip at a time to transmit data
we can migrate struct tpm_buf to struct tpm_chip. This makes the use of
it more fail safe as the buffer is allocated from heap when the device
is created and not for every transaction.

This is needed characteristic for the resource manager so that we can
minimize the probability of failure for loading, saving and flushings
of TPM contexts.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c |   8 +++
 drivers/char/tpm/tpm.h      |  67 ++++++++++-------------
 drivers/char/tpm/tpm2-cmd.c | 128 ++++++++++++++++++--------------------------
 3 files changed, 87 insertions(+), 116 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index eefdc80..41e518e 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -128,6 +128,7 @@ static void tpm_dev_release(struct device *dev)
 	mutex_unlock(&idr_lock);
 
 	kfree(chip->log.bios_event_log);
+	kfree(chip->tr_buf.data);
 	kfree(chip);
 }
 
@@ -189,6 +190,13 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->cdev.owner = THIS_MODULE;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
+	chip->tr_buf.data = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!chip->tr_buf.data) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	chip->tr_buf.size = TPM_BUFSIZE;
+
 	return chip;
 
 out:
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 1ae9768..c74a663 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -153,6 +153,20 @@ struct tpm_chip_seqops {
 	const struct seq_operations *seqops;
 };
 
+/* A string buffer pointer type for constructing TPM commands. Does not own
+ * the data.
+ */
+
+enum tpm_buf_flags {
+	TPM_BUF_OVERFLOW        = BIT(0),
+};
+
+struct tpm_buf {
+	unsigned int flags;
+	u8 *data;
+	unsigned int size;
+};
+
 struct tpm_chip {
 	struct device dev;
 	struct cdev cdev;
@@ -191,6 +205,8 @@ struct tpm_chip {
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
 #endif /* CONFIG_ACPI */
+
+	struct tpm_buf tr_buf;
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
@@ -387,57 +403,28 @@ struct tpm_cmd_t {
 	tpm_cmd_params	params;
 } __packed;
 
-/* A string buffer type for constructing TPM commands. This is based on the
- * ideas of string buffer code in security/keys/trusted.h but is heap based
- * in order to keep the stack usage minimal.
- */
-
-enum tpm_buf_flags {
-	TPM_BUF_OVERFLOW	= BIT(0),
-};
+/* A string buffer for constructing TPM commands. */
 
-struct tpm_buf {
-	struct page *data_page;
-	unsigned int flags;
-	u8 *data;
-};
-
-static inline int tpm_buf_init(struct tpm_buf *buf, u16 tag, u32 ordinal)
+static inline void tpm_buf_init(struct tpm_buf *buf, u16 tag, u32 ordinal)
 {
-	struct tpm_input_header *head;
-
-	buf->data_page = alloc_page(GFP_HIGHUSER);
-	if (!buf->data_page)
-		return -ENOMEM;
-
-	buf->flags = 0;
-	buf->data = kmap(buf->data_page);
-
-	head = (struct tpm_input_header *) buf->data;
+	struct tpm_input_header *head = (struct tpm_input_header *)buf->data;
 
+	buf->flags &= ~TPM_BUF_OVERFLOW;
 	head->tag = cpu_to_be16(tag);
 	head->length = cpu_to_be32(sizeof(*head));
 	head->ordinal = cpu_to_be32(ordinal);
-
-	return 0;
-}
-
-static inline void tpm_buf_destroy(struct tpm_buf *buf)
-{
-	kunmap(buf->data_page);
-	__free_page(buf->data_page);
 }
 
 static inline u32 tpm_buf_length(struct tpm_buf *buf)
 {
-	struct tpm_input_header *head = (struct tpm_input_header *) buf->data;
+	struct tpm_input_header *head = (struct tpm_input_header *)buf->data;
 
 	return be32_to_cpu(head->length);
 }
 
 static inline u16 tpm_buf_tag(struct tpm_buf *buf)
 {
-	struct tpm_input_header *head = (struct tpm_input_header *) buf->data;
+	struct tpm_input_header *head = (struct tpm_input_header *)buf->data;
 
 	return be16_to_cpu(head->tag);
 }
@@ -446,14 +433,16 @@ static inline void tpm_buf_append(struct tpm_buf *buf,
 				  const unsigned char *new_data,
 				  unsigned int new_len)
 {
-	struct tpm_input_header *head = (struct tpm_input_header *) buf->data;
+
+	struct tpm_input_header *head = (struct tpm_input_header *)buf->data;
+
 	u32 len = tpm_buf_length(buf);
 
 	/* Return silently if overflow has already happened. */
 	if (buf->flags & TPM_BUF_OVERFLOW)
 		return;
 
-	if ((len + new_len) > PAGE_SIZE) {
+	if ((len + new_len) > buf->size) {
 		WARN(1, "tpm_buf: overflow\n");
 		buf->flags |= TPM_BUF_OVERFLOW;
 		return;
@@ -472,14 +461,14 @@ static inline void tpm_buf_append_u16(struct tpm_buf *buf, const u16 value)
 {
 	__be16 value2 = cpu_to_be16(value);
 
-	tpm_buf_append(buf, (u8 *) &value2, 2);
+	tpm_buf_append(buf, (u8 *)&value2, 2);
 }
 
 static inline void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value)
 {
 	__be32 value2 = cpu_to_be32(value);
 
-	tpm_buf_append(buf, (u8 *) &value2, 4);
+	tpm_buf_append(buf, (u8 *)&value2, 4);
 }
 
 extern struct class *tpm_class;
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 6eda239..f0e0807 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -444,7 +444,6 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		      struct trusted_key_options *options)
 {
 	unsigned int blob_len;
-	struct tpm_buf buf;
 	u32 hash;
 	int i;
 	int rc;
@@ -459,73 +458,67 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (i == ARRAY_SIZE(tpm2_hash_map))
 		return -EINVAL;
 
-	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
-	if (rc)
-		return rc;
+	tpm_buf_init(&chip->tr_buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
 
-	tpm_buf_append_u32(&buf, options->keyhandle);
-	tpm2_buf_append_auth(&buf, TPM2_RS_PW,
+	tpm_buf_append_u32(&chip->tr_buf, options->keyhandle);
+	tpm2_buf_append_auth(&chip->tr_buf, TPM2_RS_PW,
 			     NULL /* nonce */, 0,
 			     0 /* session_attributes */,
 			     options->keyauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
 	/* sensitive */
-	tpm_buf_append_u16(&buf, 4 + TPM_DIGEST_SIZE + payload->key_len + 1);
+	tpm_buf_append_u16(&chip->tr_buf,
+			   4 + TPM_DIGEST_SIZE + payload->key_len + 1);
 
-	tpm_buf_append_u16(&buf, TPM_DIGEST_SIZE);
-	tpm_buf_append(&buf, options->blobauth, TPM_DIGEST_SIZE);
-	tpm_buf_append_u16(&buf, payload->key_len + 1);
-	tpm_buf_append(&buf, payload->key, payload->key_len);
-	tpm_buf_append_u8(&buf, payload->migratable);
+	tpm_buf_append_u16(&chip->tr_buf, TPM_DIGEST_SIZE);
+	tpm_buf_append(&chip->tr_buf, options->blobauth, TPM_DIGEST_SIZE);
+	tpm_buf_append_u16(&chip->tr_buf, payload->key_len + 1);
+	tpm_buf_append(&chip->tr_buf, payload->key, payload->key_len);
+	tpm_buf_append_u8(&chip->tr_buf, payload->migratable);
 
 	/* public */
-	tpm_buf_append_u16(&buf, 14 + options->policydigest_len);
-	tpm_buf_append_u16(&buf, TPM2_ALG_KEYEDHASH);
-	tpm_buf_append_u16(&buf, hash);
+	tpm_buf_append_u16(&chip->tr_buf, 14 + options->policydigest_len);
+	tpm_buf_append_u16(&chip->tr_buf, TPM2_ALG_KEYEDHASH);
+	tpm_buf_append_u16(&chip->tr_buf, hash);
 
 	/* policy */
 	if (options->policydigest_len) {
-		tpm_buf_append_u32(&buf, 0);
-		tpm_buf_append_u16(&buf, options->policydigest_len);
-		tpm_buf_append(&buf, options->policydigest,
+		tpm_buf_append_u32(&chip->tr_buf, 0);
+		tpm_buf_append_u16(&chip->tr_buf, options->policydigest_len);
+		tpm_buf_append(&chip->tr_buf, options->policydigest,
 			       options->policydigest_len);
 	} else {
-		tpm_buf_append_u32(&buf, TPM2_OA_USER_WITH_AUTH);
-		tpm_buf_append_u16(&buf, 0);
+		tpm_buf_append_u32(&chip->tr_buf, TPM2_OA_USER_WITH_AUTH);
+		tpm_buf_append_u16(&chip->tr_buf, 0);
 	}
 
 	/* public parameters */
-	tpm_buf_append_u16(&buf, TPM2_ALG_NULL);
-	tpm_buf_append_u16(&buf, 0);
+	tpm_buf_append_u16(&chip->tr_buf, TPM2_ALG_NULL);
+	tpm_buf_append_u16(&chip->tr_buf, 0);
 
 	/* outside info */
-	tpm_buf_append_u16(&buf, 0);
+	tpm_buf_append_u16(&chip->tr_buf, 0);
 
 	/* creation PCR */
-	tpm_buf_append_u32(&buf, 0);
+	tpm_buf_append_u32(&chip->tr_buf, 0);
 
-	if (buf.flags & TPM_BUF_OVERFLOW) {
-		rc = -E2BIG;
-		goto out;
-	}
+	if (chip->tr_buf.flags & TPM_BUF_OVERFLOW)
+		return -E2BIG;
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, "sealing data");
+	rc = tpm_transmit_cmd(chip, &chip->tr_buf, TPM_BUFSIZE, 0,
+			      "sealing data");
 	if (rc)
-		goto out;
+		return rc;
 
-	blob_len = be32_to_cpup((__be32 *) &buf.data[TPM_HEADER_SIZE]);
-	if (blob_len > MAX_BLOB_SIZE) {
-		rc = -E2BIG;
-		goto out;
-	}
+	blob_len = be32_to_cpup((__be32 *)&chip->tr_buf.data[TPM_HEADER_SIZE]);
+	if (blob_len > MAX_BLOB_SIZE)
+		return -E2BIG;
 
-	memcpy(payload->blob, &buf.data[TPM_HEADER_SIZE + 4], blob_len);
+	memcpy(payload->blob, &chip->tr_buf.data[TPM_HEADER_SIZE + 4],
+	       blob_len);
 	payload->blob_len = blob_len;
 
-out:
-	tpm_buf_destroy(&buf);
-
 	if (rc > 0) {
 		if ((rc & TPM2_RC_HASH) == TPM2_RC_HASH)
 			rc = -EINVAL;
@@ -555,7 +548,6 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 			 struct trusted_key_options *options,
 			 u32 *blob_handle, unsigned int flags)
 {
-	struct tpm_buf buf;
 	unsigned int private_len;
 	unsigned int public_len;
 	unsigned int blob_len;
@@ -570,31 +562,25 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (blob_len > payload->blob_len)
 		return -E2BIG;
 
-	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
-	if (rc)
-		return rc;
+	tpm_buf_init(&chip->tr_buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
 
-	tpm_buf_append_u32(&buf, options->keyhandle);
-	tpm2_buf_append_auth(&buf, TPM2_RS_PW,
+	tpm_buf_append_u32(&chip->tr_buf, options->keyhandle);
+	tpm2_buf_append_auth(&chip->tr_buf, TPM2_RS_PW,
 			     NULL /* nonce */, 0,
 			     0 /* session_attributes */,
 			     options->keyauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	tpm_buf_append(&buf, payload->blob, blob_len);
+	tpm_buf_append(&chip->tr_buf, payload->blob, blob_len);
 
-	if (buf.flags & TPM_BUF_OVERFLOW) {
-		rc = -E2BIG;
-		goto out;
-	}
+	if (chip->tr_buf.flags & TPM_BUF_OVERFLOW)
+		return -E2BIG;
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags, "loading blob");
+	rc = tpm_transmit_cmd(chip, &chip->tr_buf, TPM_BUFSIZE, flags,
+			      "loading blob");
 	if (!rc)
 		*blob_handle = be32_to_cpup(
-			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
-
-out:
-	tpm_buf_destroy(&buf);
+			(__be32 *)&chip->tr_buf.data[TPM_HEADER_SIZE]);
 
 	if (rc > 0)
 		rc = -EPERM;
@@ -614,25 +600,16 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 static void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
 				   unsigned int flags)
 {
-	struct tpm_buf buf;
 	int rc;
 
-	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_FLUSH_CONTEXT);
-	if (rc) {
-		dev_warn(&chip->dev, "0x%08x was not flushed, out of memory\n",
-			 handle);
-		return;
-	}
-
-	tpm_buf_append_u32(&buf, handle);
+	tpm_buf_init(&chip->tr_buf, TPM2_ST_NO_SESSIONS, TPM2_CC_FLUSH_CONTEXT);
+	tpm_buf_append_u32(&chip->tr_buf, handle);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags,
+	rc = tpm_transmit_cmd(chip, &chip->tr_buf, TPM_BUFSIZE, flags,
 			      "flushing context");
 	if (rc)
 		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
 			 rc);
-
-	tpm_buf_destroy(&buf);
 }
 
 /**
@@ -653,17 +630,14 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			   struct trusted_key_options *options,
 			   u32 blob_handle, unsigned int flags)
 {
-	struct tpm_buf buf;
 	u16 data_len;
 	u8 *data;
 	int rc;
 
-	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
-	if (rc)
-		return rc;
+	tpm_buf_init(&chip->tr_buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
 
-	tpm_buf_append_u32(&buf, blob_handle);
-	tpm2_buf_append_auth(&buf,
+	tpm_buf_append_u32(&chip->tr_buf, blob_handle);
+	tpm2_buf_append_auth(&chip->tr_buf,
 			     options->policyhandle ?
 			     options->policyhandle : TPM2_RS_PW,
 			     NULL /* nonce */, 0,
@@ -671,21 +645,21 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags, "unsealing");
+	rc = tpm_transmit_cmd(chip, chip->tr_buf.data, TPM_BUFSIZE, flags,
+			      "unsealing");
 	if (rc > 0)
 		rc = -EPERM;
 
 	if (!rc) {
 		data_len = be16_to_cpup(
-			(__be16 *) &buf.data[TPM_HEADER_SIZE + 4]);
-		data = &buf.data[TPM_HEADER_SIZE + 6];
+			(__be16 *)&chip->tr_buf.data[TPM_HEADER_SIZE + 4]);
+		data = &chip->tr_buf.data[TPM_HEADER_SIZE + 6];
 
 		memcpy(payload->key, data, data_len - 1);
 		payload->key_len = data_len - 1;
 		payload->migratable = data[data_len - 1];
 	}
 
-	tpm_buf_destroy(&buf);
 	return rc;
 }
 
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
