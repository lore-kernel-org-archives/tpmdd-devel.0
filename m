From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: [PATCH] tpm: add session handles to the save and restore of the
 tpm2 space manager
Date: Fri, 13 Jan 2017 11:24:13 -0800
Message-ID: <1484335453.2527.31.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: open list <linux-kernel@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Session handles are slightly more difficult to manage because any TPM
only has a finite number of allowed handles, even if the session has
been saved; so when you context save a session, you must not flush it
because that would destroy the ability to context load it (you only
flush sessions when you're done with them) and the tpm won't re-use
the handle.  Additionally, sessions can be flushed as part of the
successful execution of a command if the continueSession attribute is
clear, so we have to mark any session we find in the command (using
TPM2_HT_TAG_FOR_FLUSH) so it can be cleared from the space if the
command successfully executes.

Finally, a session may also be cleared by flushing it, so we have to
emulate the TPM2_FlushContext command to see if a session is being
flushed and manually clear it from the space.

We also fully flush all sessions on device close.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index f5c9355..d8e896e 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -400,6 +400,10 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	if (chip->dev.parent)
 		pm_runtime_get_sync(chip->dev.parent);
 
+	rc = tpm2_emulate(chip, space, ordinal, buf, bufsiz);
+	if (rc)
+		goto out;
+
 	rc = tpm2_prepare_space(chip, space, ordinal, buf, bufsiz);
 	if (rc)
 		goto out;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index adf7810..b922652 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -136,7 +136,8 @@ enum tpm2_capabilities {
 };
 
 enum tpm2_properties {
-	TPM_PT_TOTAL_COMMANDS	= 0x0129,
+	TPM_PT_ACTIVE_SESSIONS_MAX	= 0x0111,
+	TPM_PT_TOTAL_COMMANDS		= 0x0129,
 };
 
 enum tpm2_startup_types {
@@ -214,6 +215,8 @@ struct tpm_chip {
 	struct tpm_space *work_space;
 	u32 nr_commands;
 	u32 *cc_attrs_tbl;
+	struct tpm_sessions *sessions;
+	int max_sessions;
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
@@ -583,4 +586,7 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
 		       u32 cc, u8 *buf, size_t bufsiz);
 int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 		      u32 cc, u8 *buf, size_t bufsiz);
+void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space *space);
+int tpm2_emulate(struct tpm_chip *chip, struct tpm_space *space,
+		  u32 cc, u8 *buf, size_t bufsiz);
 #endif
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index 285361e..e8e9f32 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -25,15 +25,29 @@ enum tpm2_handle_types {
 	TPM2_HT_TRANSIENT	= 0x80000000,
 };
 
-static void tpm2_flush_space(struct tpm_chip *chip)
+#define TPM2_HT_TAG_FOR_FLUSH	0xF0000000
+
+void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space *space)
 {
-	struct tpm_space *space = chip->work_space;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++)
-		if (space->context_tbl[i] && ~space->context_tbl[i])
-			tpm2_flush_context_cmd(chip, space->context_tbl[i],
-					       TPM_TRANSMIT_UNLOCKED);
+	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		u32 handle = space->context_tbl[i];
+		u32 handle_type;
+
+		if (handle == 0 || handle == ~0)
+			continue;
+
+		if ((handle & TPM2_HT_TAG_FOR_FLUSH) ==
+		    TPM2_HT_TAG_FOR_FLUSH)
+			handle &= ~TPM2_HT_TAG_FOR_FLUSH;
+
+		handle_type = (handle & 0xFF000000);
+
+		tpm2_flush_context_cmd(chip, handle, TPM_TRANSMIT_UNLOCKED);
+
+		space->context_tbl[i] = 0;
+	}
 }
 
 struct tpm2_context {
@@ -54,15 +68,11 @@ static int tpm2_load_space(struct tpm_chip *chip)
 	u32 s;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		u32 phandle, phandle_type;
+
 		if (!space->context_tbl[i])
 			continue;
 
-		/* sanity check, should never happen */
-		if (~space->context_tbl[i]) {
-			dev_err(&chip->dev, "context table is inconsistent");
-			return -EFAULT;
-		}
-
 		rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS,
 				 TPM2_CC_CONTEXT_LOAD);
 		if (rc)
@@ -80,9 +90,23 @@ static int tpm2_load_space(struct tpm_chip *chip)
 			rc = -EFAULT;
 			goto out_err;
 		}
+		phandle = get_unaligned_be32((__be32 *)&buf.data[TPM_HEADER_SIZE]);
+		phandle_type = (phandle & 0xFF000000);
+		if (phandle_type == TPM2_HT_TRANSIENT &&
+		    space->context_tbl[i] != ~0) {
+			dev_err(&chip->dev, "context table is inconsistent");
+			rc = -EFAULT;
+			goto out_err;
+		}
+		if ((phandle_type == TPM2_HT_HMAC_SESSION ||
+		     phandle_type == TPM2_HT_POLICY_SESSION) &&
+		    space->context_tbl[i] != phandle) {
+			dev_err(&chip->dev, "session handle changed\n");
+			rc = -EFAULT;
+			goto out_err;
+		}
 
-		space->context_tbl[i] =
-			be32_to_cpup((__be32 *)&buf.data[TPM_HEADER_SIZE]);
+		space->context_tbl[i] = phandle;
 
 		j += s;
 
@@ -93,10 +117,85 @@ static int tpm2_load_space(struct tpm_chip *chip)
 
 out_err:
 	tpm_buf_destroy(&buf);
-	tpm2_flush_space(chip);
+	tpm2_flush_space(chip, space);
 	return rc;
 }
 
+static void tpm2_unmap_sessions(struct tpm_chip *chip, u32 rc)
+{
+	struct tpm_space *space = chip->work_space;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		if ((space->context_tbl[i] & TPM2_HT_TAG_FOR_FLUSH) !=
+		    TPM2_HT_TAG_FOR_FLUSH)
+			continue;
+		if (rc == TPM2_RC_SUCCESS)
+			space->context_tbl[i] = 0;
+		else
+			/* for unsuccessful command, keep session */
+			space->context_tbl[i] &= ~TPM2_HT_TAG_FOR_FLUSH;
+	}
+}
+
+static int tpm2_map_sessions(struct tpm_chip *chip, u8 *buf, size_t len,
+			     size_t start)
+{
+	struct tpm_space *space = chip->work_space;
+	u32 size = be32_to_cpup((__be32 *)&buf[start]);
+	int i;
+
+	/* skip over authorizationSize */
+	start += 4;
+
+	if (size > len - start) {
+		dev_err(&chip->dev, "Invalid authorization header size %u\n",
+			size);
+		return -EINVAL;
+	}
+
+	for (i = start; i < start+size; ) {
+		u16 skip;
+		__be32 *handlep;
+		u8 attr;
+		int j;
+		u32 handle_type;
+
+		/* TPMI_SH_AUTH_SESSION */
+		handlep = (__be32 *)&buf[i];
+		handle_type = get_unaligned_be32(handlep) & 0xFF000000;
+		i += 4;
+		/* TPM2B_DIGEST */
+		skip = get_unaligned_be16((__be16 *)&buf[i]);
+		i += skip + sizeof(skip);
+		/* TPMA_SESSION */
+		attr = buf[i++];
+		/* TPM2B_AUTH */
+		skip = get_unaligned_be16((__be16 *)&buf[i]);
+		i += skip + sizeof(skip);
+
+		if (handle_type != TPM2_HT_HMAC_SESSION &&
+		    handle_type != TPM2_HT_POLICY_SESSION)
+			continue;
+
+		j = 0xFFFFFF - (get_unaligned_be32(handlep) & 0xFFFFFF);
+		if (j > ARRAY_SIZE(space->context_tbl) ||
+		    !space->context_tbl[j])
+			return -EINVAL;
+		put_unaligned_be32(space->context_tbl[j], handlep);
+		if ((attr & 1) == 0)
+			/* session is flushed by the command */
+			space->context_tbl[j] |= TPM2_HT_TAG_FOR_FLUSH;
+	}
+
+	if (i != start+size) {
+		dev_err(&chip->dev, "Authorization session overflow\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd, size_t len)
 {
 	struct tpm_space *space = chip->work_space;
@@ -104,6 +203,7 @@ static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd, size_t len)
 	u32 vhandle;
 	u32 phandle;
 	u32 attrs;
+	u16 tag = get_unaligned_be16((__be16 *)cmd);
 	int i;
 	int j;
 	int rc;
@@ -131,11 +231,14 @@ static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd, size_t len)
 		*((__be32 *)&cmd[TPM_HEADER_SIZE + 4 * i]) =
 			cpu_to_be32(phandle);
 	}
+	if (tag == TPM2_ST_SESSIONS)
+		tpm2_map_sessions(chip, cmd, len,
+				  TPM_HEADER_SIZE + 4*nr_handles);
 
 	return 0;
 
 out_err:
-	tpm2_flush_space(chip);
+	tpm2_flush_space(chip, space);
 	return rc;
 }
 
@@ -163,13 +266,17 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
 static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
 {
 	struct tpm_space *space = chip->work_space;
-	u32 phandle;
+	u32 phandle, phandle_type;
 	u32 vhandle;
 	u32 attrs;
 	u32 return_code = get_unaligned_be32((__be32 *)&rsp[6]);
+	u16 tag = get_unaligned_be16((__be16 *)rsp);
 	int i;
 	int rc;
 
+	if (tag == TPM2_ST_SESSIONS)
+		tpm2_unmap_sessions(chip, return_code);
+
 	if (return_code != TPM2_RC_SUCCESS)
 		return 0;
 
@@ -185,7 +292,10 @@ static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
 		return 0;
 
 	phandle = be32_to_cpup((__be32 *)&rsp[TPM_HEADER_SIZE]);
-	if ((phandle & 0xFF000000) != TPM2_HT_TRANSIENT)
+	phandle_type = (phandle & 0xFF000000);
+	if (phandle_type != TPM2_HT_TRANSIENT &&
+	    phandle_type != TPM2_HT_HMAC_SESSION &&
+	    phandle_type != TPM2_HT_POLICY_SESSION)
 		return 0;
 
 	/* Garbage collect a dead context. */
@@ -208,13 +318,13 @@ static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
 	}
 
 	space->context_tbl[i] = phandle;
-	vhandle = TPM2_HT_TRANSIENT | (0xFFFFFF - i);
+	vhandle = phandle_type | (0xFFFFFF - i);
 	*(__be32 *)&rsp[TPM_HEADER_SIZE] = cpu_to_be32(vhandle);
 
 	return 0;
 
 out_err:
-	tpm2_flush_space(chip);
+	tpm2_flush_space(chip, space);
 	return rc;
 }
 
@@ -228,9 +338,20 @@ static int tpm2_save_space(struct tpm_chip *chip)
 	u32 s;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
-		if (!(space->context_tbl[i] && ~space->context_tbl[i]))
+		u32 phandle, phandle_type;
+
+		phandle = space->context_tbl[i];
+
+		if (phandle == 0)
 			continue;
 
+		if (phandle == ~0) {
+			dev_err(&chip->dev, "context table is inconsistent\n");
+			return -EFAULT;
+		}
+
+		phandle_type = (phandle & 0xFF000000);
+
 		rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS,
 				  TPM2_CC_CONTEXT_SAVE);
 		if (rc)
@@ -260,10 +381,11 @@ static int tpm2_save_space(struct tpm_chip *chip)
 
 		memcpy(&space->context_buf[j], &buf.data[TPM_HEADER_SIZE], s);
 
-		tpm2_flush_context_cmd(chip, space->context_tbl[i],
-				       TPM_TRANSMIT_UNLOCKED);
-
-		space->context_tbl[i] = ~0;
+		if (phandle_type == TPM2_HT_TRANSIENT) {
+			tpm2_flush_context_cmd(chip, space->context_tbl[i],
+					       TPM_TRANSMIT_UNLOCKED);
+			space->context_tbl[i] = ~0;
+		}
 
 		j += s;
 
@@ -273,7 +395,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
 	return 0;
 out_err:
 	tpm_buf_destroy(&buf);
-	tpm2_flush_space(chip);
+	tpm2_flush_space(chip, space);
 	return rc;
 }
 
@@ -297,3 +419,60 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 
 	return 0;
 }
+
+/* if a space is active, emulate some commands */
+int tpm2_emulate(struct tpm_chip *chip, struct tpm_space *space,
+		 u32 cc, u8 *buf, size_t bufsiz)
+{
+	int i, j, k;
+	u32 vhandle, handle_type, phandle;
+	struct tpm2_context *ctx;
+	static struct tpm_output_header buf_rc = {
+		.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+		.length = cpu_to_be32(sizeof(struct tpm_output_header)),
+	};
+
+	if (!space)
+		return 0;
+
+	if (cc != TPM2_CC_FLUSH_CONTEXT)
+		return 0;
+	vhandle = get_unaligned_be32((__be32 *)&buf[10]);
+	handle_type = (vhandle & 0xFF000000);
+
+	if (handle_type != TPM2_HT_HMAC_SESSION &&
+	    handle_type != TPM2_HT_POLICY_SESSION &&
+	    handle_type != TPM2_HT_TRANSIENT)
+		/* let the TPM figure out and return the error */
+		return 0;
+
+	buf_rc.return_code = TPM2_RC_HANDLE;
+
+	j = 0xFFFFFF - (vhandle & 0xFFFFFF);
+	if (j > ARRAY_SIZE(space->context_tbl))
+		goto error;
+	phandle = space->context_tbl[j];
+	if (phandle != ~0)
+		goto error;
+
+	for (i = 0, k = 0; i <= j; i++) {
+		ctx = (struct tpm2_context *)&space->context_buf[k];
+
+		if (space->context_tbl[i] == 0)
+			continue;
+
+		k += sizeof(*ctx) + get_unaligned_be16(&ctx->blob_size);
+	}
+	/* move all the contexts up */
+	memcpy(ctx, &space->context_buf[k], PAGE_SIZE - k);
+	space->context_tbl[j] = 0;
+
+	if (handle_type != TPM2_HT_TRANSIENT)
+		tpm2_flush_context_cmd(chip, phandle, TPM_TRANSMIT_UNLOCKED);
+
+	buf_rc.return_code = TPM2_RC_SUCCESS;
+
+ error:
+	memcpy(buf, &buf_rc, sizeof(buf_rc));
+	return sizeof(buf_rc);
+}
diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
index c10b308..3eb5955 100644
--- a/drivers/char/tpm/tpms-dev.c
+++ b/drivers/char/tpm/tpms-dev.c
@@ -36,6 +36,7 @@ static int tpms_release(struct inode *inode, struct file *file)
 	struct file_priv *fpriv = file->private_data;
 	struct tpms_priv *priv = container_of(fpriv, struct tpms_priv, priv);
 
+	tpm2_flush_space(fpriv->chip, &priv->space);
 	tpm_common_release(file, fpriv);
 	kfree(priv);
 

