From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RFC v3 2/5] tpm: export tpm2_flush_context_cmd
Date: Mon, 16 Jan 2017 15:12:08 +0200
Message-ID: <20170116131215.28930-3-jarkko.sakkinen@linux.intel.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm.h      |  2 ++
 drivers/char/tpm/tpm2-cmd.c | 67 ++++++++++++++++++++++-----------------------
 2 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 52d805f..2661c26 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -551,6 +551,8 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
 int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
 int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
+void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
+			    unsigned int flags);
 int tpm2_seal_trusted(struct tpm_chip *chip,
 		      struct trusted_key_payload *payload,
 		      struct trusted_key_options *options);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 3dce7b7..fd73e2a 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -415,6 +415,38 @@ static const struct tpm_input_header tpm2_get_tpm_pt_header = {
 };
 
 /**
+ * tpm2_flush_context_cmd() - execute a TPM2_FlushContext command
+ * @chip: TPM chip to use
+ * @payload: the key data in clear and encrypted form
+ * @options: authentication values and other options
+ *
+ * Return: same as with tpm_transmit_cmd
+ */
+void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
+			    unsigned int flags)
+{
+	struct tpm_buf buf;
+	int rc;
+
+	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_FLUSH_CONTEXT);
+	if (rc) {
+		dev_warn(&chip->dev, "0x%08x was not flushed, out of memory\n",
+			 handle);
+		return;
+	}
+
+	tpm_buf_append_u32(&buf, handle);
+
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_HEADER_SIZE, flags,
+			     "flushing context");
+	if (rc)
+		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
+			 rc);
+
+	tpm_buf_destroy(&buf);
+}
+
+/**
  * tpm_buf_append_auth() - append TPMS_AUTH_COMMAND to the buffer.
  *
  * @buf: an allocated tpm_buf instance
@@ -625,39 +657,6 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 }
 
 /**
- * tpm2_flush_context_cmd() - execute a TPM2_FlushContext command
- *
- * @chip: TPM chip to use
- * @handle: the key data in clear and encrypted form
- * @flags: tpm transmit flags
- *
- * Return: Same as with tpm_transmit_cmd.
- */
-static void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
-				   unsigned int flags)
-{
-	struct tpm_buf buf;
-	int rc;
-
-	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_FLUSH_CONTEXT);
-	if (rc) {
-		dev_warn(&chip->dev, "0x%08x was not flushed, out of memory\n",
-			 handle);
-		return;
-	}
-
-	tpm_buf_append_u32(&buf, handle);
-
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_HEADER_SIZE,
-			      flags, "flushing context");
-	if (rc)
-		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
-			 rc);
-
-	tpm_buf_destroy(&buf);
-}
-
-/**
  * tpm2_unseal_cmd() - execute a TPM2_Unload command
  *
  * @chip: TPM chip to use
@@ -1047,7 +1046,7 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 	tpm_buf_append_u32(&buf, TPM2_CC_FIRST);
 	tpm_buf_append_u32(&buf, nr_commands);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, NULL);
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_HEADER_SIZE, 0, NULL);
 	if (rc < 0) {
 		tpm_buf_destroy(&buf);
 		goto out;
-- 
2.9.3

