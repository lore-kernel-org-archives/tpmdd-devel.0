From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RFC v2 2/5] tpm: export tpm2_flush_context_cmd
Date: Thu, 12 Jan 2017 19:46:05 +0200
Message-ID: <20170112174612.9314-3-jarkko.sakkinen@linux.intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170112174612.9314-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm.h      |  2 ++
 drivers/char/tpm/tpm2-cmd.c | 65 ++++++++++++++++++++++-----------------------
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 80fa606..c87c221 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -550,6 +550,8 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
 int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
 int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
+void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
+			    unsigned int flags);
 int tpm2_seal_trusted(struct tpm_chip *chip,
 		      struct trusted_key_payload *payload,
 		      struct trusted_key_options *options);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index c4d25b2..e2b4c75 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -401,6 +401,38 @@ static const struct tpm_input_header tpm2_get_tpm_pt_header = {
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
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags,
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
@@ -603,39 +635,6 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
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
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags,
-			      "flushing context");
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
-- 
2.9.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
