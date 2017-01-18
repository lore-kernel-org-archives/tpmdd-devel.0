From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: [PATCH 1/2] tpm2: add session handle isolation to tpm
	spaces
Date: Wed, 18 Jan 2017 10:09:46 -0500
Message-ID: <1484752186.2717.16.camel@HansenPartnership.com>
References: <1484752097.2717.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1484752097.2717.14.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

sessions should be isolated during each instance of a tpm space.  This
means that spaces shouldn't be able to see each other's sessions and
also when a space is closed, all the sessions belonging to it should
be flushed.

This is implemented by adding a session_tbl to the space to track the
created session handles.  Sessions can be flushed either by not
setting the continueSession attribute in the session table or by an
explicit flush.  In the first case we have to mark the session as
being ready to flush and explicitly forget it if the command completes
successfully and in the second case we have to intercept the flush
instruction and clear the session from our table.

Finally, when the device handling the space is closed, we have to send
explicit flushes to all the remaining sessions belonging to the space
to ensure they are cleared out.

Signed-off-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
---
 drivers/char/tpm/tpm.h        |   2 +
 drivers/char/tpm/tpm2-space.c | 178 ++++++++++++++++++++++++++++++++++++++++--
 drivers/char/tpm/tpms-dev.c   |   1 +
 3 files changed, 173 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 3346c48..265b7f5 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -158,6 +158,7 @@ enum tpm2_cc_attrs {
 struct tpm_space {
 	u32 context_tbl[14];
 	u8 *context_buf;
+	u32 session_tbl[6];
 };
 
 enum tpm_chip_flags {
@@ -584,4 +585,5 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
 		       u32 cc, u8 *buf, size_t bufsiz);
 int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 		      u32 cc, u8 *buf, size_t bufsiz);
+void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space *space);
 #endif
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index 3708e70..49048af 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -25,15 +25,83 @@ enum tpm2_handle_types {
 	TPM2_HT_TRANSIENT	= 0x80000000,
 };
 
-static void tpm2_flush_space(struct tpm_chip *chip)
+#define TPM2_HT_TAG_FOR_FLUSH	0xF0000000
+
+static int tpm2_session_find(struct tpm_space *space, u32 handle)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++)
+		if (handle == space->session_tbl[i])
+			break;
+	if (i == ARRAY_SIZE(space->session_tbl))
+		return -1;
+	return i;
+}
+
+static int tpm2_session_add(struct tpm_chip *chip,
+			    struct tpm_space *space, u32 handle)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++)
+		if (space->session_tbl[i] == 0)
+			break;
+	if (i == ARRAY_SIZE(space->session_tbl)) {
+		dev_err(&chip->dev, "out of session slots\n");
+		tpm2_flush_context_cmd(chip, handle, TPM_TRANSMIT_UNLOCKED);
+		return -ENOMEM;
+	}
+
+	space->session_tbl[i] = handle;
+
+	return 0;
+}
+
+/* if a space is active, emulate some commands */
+static int tpm2_intercept(struct tpm_chip *chip, struct tpm_space *space,
+			  u32 cc, u8 *buf, size_t bufsiz)
+{
+	int j;
+	u32 handle, handle_type;
+
+	if (!space)
+		return 0;
+
+	if (cc != TPM2_CC_FLUSH_CONTEXT)
+		return 0;
+	handle = get_unaligned_be32((__be32 *)&buf[10]);
+	handle_type = (handle & 0xFF000000);
+
+	if (handle_type != TPM2_HT_HMAC_SESSION &&
+	    handle_type != TPM2_HT_POLICY_SESSION)
+		/* let the TPM figure out and return the error */
+		return 0;
+
+	j = tpm2_session_find(space, handle);
+	if (j < 0)
+		return -EINVAL;
+
+	space->session_tbl[j] |= TPM2_HT_TAG_FOR_FLUSH;
+
+	return 0;
+}
+
+void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space *space)
 {
-	struct tpm_space *space = &chip->work_space;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++)
 		if (space->context_tbl[i] && ~space->context_tbl[i])
 			tpm2_flush_context_cmd(chip, space->context_tbl[i],
 					       TPM_TRANSMIT_UNLOCKED);
+
+	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
+		space->session_tbl[i] &= ~TPM2_HT_TAG_FOR_FLUSH;
+		if (space->session_tbl[i])
+			tpm2_flush_context_cmd(chip, space->session_tbl[i],
+					       TPM_TRANSMIT_UNLOCKED);
+	}
 }
 
 struct tpm2_context {
@@ -94,10 +162,82 @@ static int tpm2_load_space(struct tpm_chip *chip)
 
 out_err:
 	tpm_buf_destroy(&buf);
-	tpm2_flush_space(chip);
+	tpm2_flush_space(chip, space);
 	return rc;
 }
 
+static void tpm2_unmap_sessions(struct tpm_chip *chip, u32 rc)
+{
+	struct tpm_space *space = &chip->work_space;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
+		if ((space->session_tbl[i] & TPM2_HT_TAG_FOR_FLUSH) !=
+		    TPM2_HT_TAG_FOR_FLUSH)
+			continue;
+		if (rc == TPM2_RC_SUCCESS)
+			space->session_tbl[i] = 0;
+		else
+			/* for unsuccessful command, keep session */
+			space->session_tbl[i] &= ~TPM2_HT_TAG_FOR_FLUSH;
+	}
+}
+
+static int tpm2_map_sessions(struct tpm_chip *chip, u8 *buf, size_t len,
+			     size_t start)
+{
+	struct tpm_space *space = &chip->work_space;
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
+		u8 attr;
+		int j;
+		u32 handle, handle_type;
+
+		/* TPMI_SH_AUTH_SESSION */
+		handle = get_unaligned_be32((__be32 *)&buf[i]);
+		handle_type = handle & 0xFF000000;
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
+		j = tpm2_session_find(space, handle);
+		if (j < 0)
+			return -EINVAL;
+		if ((attr & 1) == 0)
+			/* session is flushed by the command */
+			space->session_tbl[j] |= TPM2_HT_TAG_FOR_FLUSH;
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
 	struct tpm_space *space = &chip->work_space;
@@ -105,6 +245,7 @@ static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd, size_t len)
 	u32 vhandle;
 	u32 phandle;
 	u32 attrs;
+	u16 tag = get_unaligned_be16((__be16 *)cmd);
 	int i;
 	int j;
 	int rc;
@@ -132,11 +273,14 @@ static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd, size_t len)
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
 
@@ -150,8 +294,14 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
 
 	memcpy(&chip->work_space.context_tbl, &space->context_tbl,
 	       sizeof(space->context_tbl));
+	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
+	       sizeof(space->session_tbl));
 	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
 
+	rc = tpm2_intercept(chip, space, cc, buf, bufsiz);
+	if (rc)
+		return rc;
+
 	rc = tpm2_load_space(chip);
 	if (rc)
 		return rc;
@@ -166,13 +316,17 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
 static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
 {
 	struct tpm_space *space = &chip->work_space;
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
 
@@ -188,9 +342,15 @@ static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
 		return 0;
 
 	phandle = be32_to_cpup((__be32 *)&rsp[TPM_HEADER_SIZE]);
-	if ((phandle & 0xFF000000) != TPM2_HT_TRANSIENT)
+	phandle_type = (phandle & 0xFF000000);
+	if (phandle_type != TPM2_HT_TRANSIENT &&
+	    phandle_type != TPM2_HT_HMAC_SESSION &&
+	    phandle_type != TPM2_HT_POLICY_SESSION)
 		return 0;
 
+	if (phandle_type != TPM2_HT_TRANSIENT)
+		return tpm2_session_add(chip, space, phandle);
+
 	/* Garbage collect a dead context. */
 	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
 		if (space->context_tbl[i] == phandle) {
@@ -217,7 +377,7 @@ static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
 	return 0;
 
 out_err:
-	tpm2_flush_space(chip);
+	tpm2_flush_space(chip, space);
 	return rc;
 }
 
@@ -277,7 +437,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
 	return 0;
 out_err:
 	tpm_buf_destroy(&buf);
-	tpm2_flush_space(chip);
+	tpm2_flush_space(chip, space);
 	return rc;
 }
 
@@ -299,6 +459,8 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 
 	memcpy(&space->context_tbl, &chip->work_space.context_tbl,
 	       sizeof(space->context_tbl));
+	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
+	       sizeof(space->session_tbl));
 	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
 
 	return 0;
diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
index 6bb687f..d6e3491 100644
--- a/drivers/char/tpm/tpms-dev.c
+++ b/drivers/char/tpm/tpms-dev.c
@@ -36,6 +36,7 @@ static int tpms_release(struct inode *inode, struct file *file)
 	struct file_priv *fpriv = file->private_data;
 	struct tpms_priv *priv = container_of(fpriv, struct tpms_priv, priv);
 
+	tpm2_flush_space(fpriv->chip, &priv->space);
 	tpm_common_release(file, fpriv);
 	kfree(priv->space.context_buf);
 	kfree(priv);
-- 
2.6.6


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
