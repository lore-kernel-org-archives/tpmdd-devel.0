From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 7/7] tpm2: add session handle context
	saving and restoring to the space code
Date: Thu, 16 Feb 2017 21:25:20 +0200
Message-ID: <20170216192529.25467-8-jarkko.sakkinen@linux.intel.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170216192529.25467-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Sessions are different from transient objects in that their handles
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
 drivers/char/tpm/tpm-chip.c   |   6 +++
 drivers/char/tpm/tpm.h        |   4 +-
 drivers/char/tpm/tpm2-space.c | 105 +++++++++++++++++++++++++++++++++++++++++-
 drivers/char/tpm/tpms-dev.c   |   2 +-
 4 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index c71c353..e8536ab 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -130,6 +130,7 @@ static void tpm_dev_release(struct device *dev)
 
 	kfree(chip->log.bios_event_log);
 	kfree(chip->work_space.context_buf);
+	kfree(chip->work_space.session_buf);
 	kfree(chip);
 }
 
@@ -224,6 +225,11 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
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
index 822ca67..ffee8b5 100644
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
@@ -589,7 +591,7 @@ int tpm2_probe(struct tpm_chip *chip);
 ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip);
 int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
 int tpm2_init_space(struct tpm_space *space);
-void tpm2_del_space(struct tpm_space *space);
+void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space);
 int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 		       u8 *cmd);
 int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index e955548..d36d81e 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -32,18 +32,39 @@ struct tpm2_context {
 	__be16 blob_size;
 } __packed;
 
+static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
+		if (space->session_tbl[i])
+			tpm2_flush_context_cmd(chip, space->session_tbl[i],
+					       TPM_TRANSMIT_UNLOCKED);
+	}
+}
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
+	mutex_lock(&chip->tpm_mutex);
+	tpm2_flush_sessions(chip, space);
+	mutex_unlock(&chip->tpm_mutex);
 	kfree(space->context_buf);
+	kfree(space->session_buf);
 }
 
 static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
@@ -69,6 +90,20 @@ static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
 			 __func__, rc);
 		tpm_buf_destroy(&tbuf);
 		return -EFAULT;
+	} else if (tpm2_rc_value(rc) == TPM2_RC_HANDLE ||
+		   rc == TPM2_RC_REFERENCE_H0) {
+		/*
+		 * TPM_RC_HANDLE means that the session context can't
+		 * be loaded because of an internal counter mismatch
+		 * that makes the TPM think there might have been a
+		 * replay.  This might happen if the context was saved
+		 * and loaded outside the space.
+		 *
+		 * TPM_RC_REFERENCE_H0 means the session has been
+		 * flushed outside the space
+		 */
+		rc = -ENOENT;
+		tpm_buf_destroy(&tbuf);
 	} else if (rc > 0) {
 		dev_warn(&chip->dev, "%s: failed with a TPM error 0x%04X\n",
 			 __func__, rc);
@@ -121,7 +156,6 @@ static int tpm2_save_context(struct tpm_chip *chip, u32 handle, u8 *buf,
 	}
 
 	memcpy(&buf[*offset], &tbuf.data[TPM_HEADER_SIZE], body_size);
-	tpm2_flush_context_cmd(chip, handle, TPM_TRANSMIT_UNLOCKED);
 	*offset += body_size;
 	tpm_buf_destroy(&tbuf);
 	return 0;
@@ -136,6 +170,8 @@ static void tpm2_flush_space(struct tpm_chip *chip)
 		if (space->context_tbl[i] && ~space->context_tbl[i])
 			tpm2_flush_context_cmd(chip, space->context_tbl[i],
 					       TPM_TRANSMIT_UNLOCKED);
+
+	tpm2_flush_sessions(chip, space);
 }
 
 static int tpm2_load_space(struct tpm_chip *chip)
@@ -161,6 +197,28 @@ static int tpm2_load_space(struct tpm_chip *chip)
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
 
@@ -215,7 +273,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 
 	memcpy(&chip->work_space.context_tbl, &space->context_tbl,
 	       sizeof(space->context_tbl));
+	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
+	       sizeof(space->session_tbl));
 	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
+	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
 
 	rc = tpm2_load_space(chip);
 	if (rc) {
@@ -232,6 +293,22 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 	return 0;
 }
 
+static bool tpm2_add_session(struct tpm_chip *chip, u32 handle)
+{
+	struct tpm_space *space = &chip->work_space;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++)
+		if (space->session_tbl[i] == 0)
+			break;
+
+	if (i == ARRAY_SIZE(space->session_tbl))
+		return false;
+
+	space->session_tbl[i] = handle;
+	return true;
+}
+
 static u32 tpm2_map_to_vhandle(struct tpm_space *space, u32 phandle, bool alloc)
 {
 	int i;
@@ -288,6 +365,8 @@ static int tpm2_map_response_header(struct tpm_chip *chip, u32 cc, u8 *rsp,
 		break;
 	case TPM2_HT_HMAC_SESSION:
 	case TPM2_HT_POLICY_SESSION:
+		if (!tpm2_add_session(chip, phandle))
+			goto out_no_slots;
 		break;
 	default:
 		dev_err(&chip->dev, "%s: unknown handle 0x%08X\n",
@@ -388,9 +467,28 @@ static int tpm2_save_space(struct tpm_chip *chip)
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
 
@@ -425,7 +523,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 
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
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
