From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: [PATCH v2 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Fri, 27 Jan 2017 16:32:38 -0800
Message-ID: <1485563558.3229.41.camel@HansenPartnership.com>
References: <1485563481.3229.39.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1485563481.3229.39.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
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

sessions are different from transient objects in that their handles
may not be virtualized (because they're used for some hmac
calculations).  Additionally when a session is context saved, a
vestigial memory remains in the TPM and if it is also flushed, that
will be lost and the session context will refuse to load next time, so
the code is updated to flush only transient objects after a context
save.  Add a separate array (chip->session_tbl) to save and restore
sessions by handle.  Use the failure of a context save or load to
signal that the session has been flushed from the TPM and we can
remove its memory from chip->session_tbl.

Sessions are also isolated during each instance of a tpm space.  This
means that spaces shouldn't be able to see each other's sessions and
is enforced by ensuring that a space user may only refer to sessions
handles that are present in their own chip->session_tbl.  Finally when
a space is closed, all the sessions belonging to it should be flushed
so the handles may be re-used by other spaces.

Note that if we get a session save or load error, all sessions are
effectively flushed.  Even though we restore the session buffer, all
the old sessions will refuse to load after the flush and they'll be
purged from our session memory.  This means that while transient
context handling is still soft in the face of errors, session handling
is hard (any failure of the model means all sessions are lost).

Signed-off-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

---

v2: - add kill space to remove sessions on close
    - update changelog
    - reduce session table to 3 entries
---
 drivers/char/tpm/tpm-chip.c   |   6 +++
 drivers/char/tpm/tpm.h        |   4 +-
 drivers/char/tpm/tpm2-space.c | 112 ++++++++++++++++++++++++++++++++++++++++--
 drivers/char/tpm/tpms-dev.c   |   2 +-
 4 files changed, 118 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index ed4f887..6282ad0 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -130,6 +130,7 @@ static void tpm_dev_release(struct device *dev)
 
 	kfree(chip->log.bios_event_log);
 	kfree(chip->work_space.context_buf);
+	kfree(chip->work_space.session_buf);
 	kfree(chip);
 }
 
@@ -223,6 +224,11 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 		rc = -ENOMEM;
 		goto out;
 	}
+	chip->work_space.session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!chip->work_space.session_buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	return chip;
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index c4b8ec9..10c57b9 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -161,6 +161,8 @@ enum tpm2_cc_attrs {
 struct tpm_space {
 	u32 context_tbl[3];
 	u8 *context_buf;
+	u32 session_tbl[3];
+	u8 *session_buf;
 };
 
 enum tpm_chip_flags {
@@ -583,7 +585,7 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
 int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
 int tpm2_init_space(struct tpm_space *space);
-void tpm2_del_space(struct tpm_space *space);
+void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space);
 int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 		       u8 *cmd);
 int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index d241c2a..2b3d1ad 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -32,18 +32,28 @@ struct tpm2_context {
 	__be16 blob_size;
 } __packed;
 
+static void tpm2_kill_sessions(struct tpm_chip *chip, struct tpm_space *space);
+
 int tpm2_init_space(struct tpm_space *space)
 {
 	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!space->context_buf)
 		return -ENOMEM;
 
+	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (space->session_buf == NULL) {
+		kfree(space->context_buf);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
-void tpm2_del_space(struct tpm_space *space)
+void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space)
 {
+	tpm2_kill_sessions(chip, space);
 	kfree(space->context_buf);
+	kfree(space->session_buf);
 }
 
 static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
@@ -69,6 +79,10 @@ static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
 			 __func__, rc);
 		tpm_buf_destroy(&tbuf);
 		return -EFAULT;
+	} else if (tpm2_rc_value(rc) == TPM2_RC_HANDLE ||
+		   rc == TPM2_RC_REFERENCE_H0) {
+		rc = -ENOENT;
+		tpm_buf_destroy(&tbuf);
 	} else if (rc > 0) {
 		dev_warn(&chip->dev, "%s: failed with a TPM error 0x%04X\n",
 			 __func__, rc);
@@ -121,12 +135,30 @@ static int tpm2_save_context(struct tpm_chip *chip, u32 handle, u8 *buf,
 	}
 
 	memcpy(&buf[*offset], &tbuf.data[TPM_HEADER_SIZE], body_size);
-	tpm2_flush_context_cmd(chip, handle, TPM_TRANSMIT_UNLOCKED);
 	*offset += body_size;
 	tpm_buf_destroy(&tbuf);
 	return 0;
 }
 
+static int tpm2_session_add(struct tpm_chip *chip, u32 handle)
+{
+	struct tpm_space *space = &chip->work_space;
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
 static void tpm2_flush_space(struct tpm_chip *chip)
 {
 	struct tpm_space *space = &chip->work_space;
@@ -136,6 +168,25 @@ static void tpm2_flush_space(struct tpm_chip *chip)
 		if (space->context_tbl[i] && ~space->context_tbl[i])
 			tpm2_flush_context_cmd(chip, space->context_tbl[i],
 					       TPM_TRANSMIT_UNLOCKED);
+
+	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
+		if (space->session_tbl[i])
+			tpm2_flush_context_cmd(chip, space->session_tbl[i],
+					       TPM_TRANSMIT_UNLOCKED);
+	}
+}
+
+static void tpm2_kill_sessions(struct tpm_chip *chip, struct tpm_space *space)
+{
+	int i;
+
+	mutex_lock(&chip->tpm_mutex);
+	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
+		if (space->session_tbl[i])
+			tpm2_flush_context_cmd(chip, space->session_tbl[i],
+					       TPM_TRANSMIT_UNLOCKED);
+	}
+	mutex_unlock(&chip->tpm_mutex);
 }
 
 static int tpm2_load_space(struct tpm_chip *chip)
@@ -161,6 +212,28 @@ static int tpm2_load_space(struct tpm_chip *chip)
 			return rc;
 	}
 
+	for (i = 0, offset = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
+		u32 handle;
+
+		if (!space->session_tbl[i])
+			continue;
+
+		rc = tpm2_load_context(chip, space->session_buf,
+				       &offset, &handle);
+		if (rc == -ENOENT) {
+			/* load failed, just forget session */
+			space->session_tbl[i] = 0;
+		} else if (rc) {
+			tpm2_flush_space(chip);
+			return rc;
+		}
+		if (handle != space->session_tbl[i]) {
+			dev_warn(&chip->dev, "session restored to wrong handle\n");
+			tpm2_flush_space(chip);
+			return -EFAULT;
+		}
+	}
+
 	return 0;
 }
 
@@ -220,7 +293,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 
 	memcpy(&chip->work_space.context_tbl, &space->context_tbl,
 	       sizeof(space->context_tbl));
+	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
+	       sizeof(space->session_tbl));
 	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
+	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
 
 	rc = tpm2_load_space(chip);
 	if (rc) {
@@ -240,7 +316,7 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
 {
 	struct tpm_space *space = &chip->work_space;
-	u32 phandle;
+	u32 phandle, phandle_type;
 	u32 vhandle;
 	u32 attrs;
 	u32 return_code = get_unaligned_be32((__be32 *)&rsp[6]);
@@ -259,9 +335,15 @@ static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
 		return 0;
 
 	phandle = be32_to_cpup((__be32 *)&rsp[TPM_HEADER_SIZE]);
-	if ((phandle & 0xFF000000) != TPM2_HT_TRANSIENT)
+	phandle_type = (phandle & 0xFF000000);
+	if (phandle_type != TPM2_HT_TRANSIENT &&
+	    phandle_type != TPM2_HT_HMAC_SESSION &&
+	    phandle_type != TPM2_HT_POLICY_SESSION)
 		return 0;
 
+	if (phandle_type != TPM2_HT_TRANSIENT)
+		return tpm2_session_add(chip, phandle);
+
 	/* Garbage collect a dead context. */
 	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
 		if (space->context_tbl[i] == phandle) {
@@ -307,9 +389,28 @@ static int tpm2_save_space(struct tpm_chip *chip)
 		} else if (rc)
 			return rc;
 
+		tpm2_flush_context_cmd(chip, space->context_tbl[i],
+				       TPM_TRANSMIT_UNLOCKED);
 		space->context_tbl[i] = ~0;
 	}
 
+	for (i = 0, offset = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
+		if (!space->session_tbl[i])
+			continue;
+
+		rc = tpm2_save_context(chip, space->session_tbl[i],
+				       space->session_buf, PAGE_SIZE,
+				       &offset);
+
+		if (rc == -ENOENT) {
+			/* handle error saving session, just forget it */
+			space->session_tbl[i] = 0;
+		} else if (rc < 0) {
+			tpm2_flush_space(chip);
+			return rc;
+		}
+	}
+
 	return 0;
 }
 
@@ -335,7 +436,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 
 	memcpy(&space->context_tbl, &chip->work_space.context_tbl,
 	       sizeof(space->context_tbl));
+	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
+	       sizeof(space->session_tbl));
 	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
+	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
index 5720885..4c98db8 100644
--- a/drivers/char/tpm/tpms-dev.c
+++ b/drivers/char/tpm/tpms-dev.c
@@ -39,7 +39,7 @@ static int tpms_release(struct inode *inode, struct file *file)
 	struct tpms_priv *priv = container_of(fpriv, struct tpms_priv, priv);
 
 	tpm_common_release(file, fpriv);
-	tpm2_del_space(&priv->space);
+	tpm2_del_space(fpriv->chip, &priv->space);
 	kfree(priv);
 
 	return 0;
-- 
2.6.6


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
