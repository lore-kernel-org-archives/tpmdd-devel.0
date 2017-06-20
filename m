From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: consolidate the TPM startup code
Date: Tue, 20 Jun 2017 20:13:34 +0200
Message-ID: <20170620181334.28363-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Consolidated all the "manual" TPM startup code to a single function
in order to make code flows a bit cleaner and migrate to tpm_buf.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 67 +++++++++++++++++++++++++---------------
 drivers/char/tpm/tpm.h           |  6 +---
 drivers/char/tpm/tpm2-cmd.c      | 32 +------------------
 3 files changed, 44 insertions(+), 61 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d2b4df6d9894..fbef47d8bd06 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -540,6 +540,47 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
 }
 EXPORT_SYMBOL_GPL(tpm_transmit_cmd);
 
+#define TPM_ORD_STARTUP 153
+#define TPM_ST_CLEAR 1
+
+/**
+ * tpm_startup - turn on the TPM
+ * @chip: TPM chip to use
+ *
+ * Normally the firmware should start the TPM. This function is provided as a
+ * workaround if this does not happen. A legal case for this could be for
+ * example when a TPM emulator is used.
+ *
+ * Return: same as tpm_transmit_cmd()
+ */
+int tpm_startup(struct tpm_chip *chip)
+{
+	struct tpm_buf buf;
+	int rc;
+
+	dev_info(&chip->dev, "starting up the TPM manually\n");
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_STARTUP);
+		if (rc < 0)
+			return rc;
+
+		tpm_buf_append_u32(&buf, TPM2_SU_CLEAR);
+	} else {
+		rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND, TPM_ORD_STARTUP);
+		if (rc < 0)
+			return rc;
+
+		tpm_buf_append_u32(&buf, TPM_ST_CLEAR);
+	}
+
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, 0,
+			      "attempting to start the TPM");
+
+	tpm_buf_destroy(&buf);
+	return rc;
+}
+
 #define TPM_DIGEST_SIZE 20
 #define TPM_RET_CODE_IDX 6
 #define TPM_INTERNAL_RESULT_SIZE 200
@@ -586,27 +627,6 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 }
 EXPORT_SYMBOL_GPL(tpm_getcap);
 
-#define TPM_ORD_STARTUP 153
-#define TPM_ST_CLEAR cpu_to_be16(1)
-#define TPM_ST_STATE cpu_to_be16(2)
-#define TPM_ST_DEACTIVATED cpu_to_be16(3)
-static const struct tpm_input_header tpm_startup_header = {
-	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
-	.length = cpu_to_be32(12),
-	.ordinal = cpu_to_be32(TPM_ORD_STARTUP)
-};
-
-static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
-{
-	struct tpm_cmd_t start_cmd;
-	start_cmd.header.in = tpm_startup_header;
-
-	start_cmd.params.startup_in.startup_type = startup_type;
-	return tpm_transmit_cmd(chip, NULL, &start_cmd,
-				TPM_INTERNAL_RESULT_SIZE, 0,
-				0, "attempting to start the TPM");
-}
-
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
 	cap_t cap;
@@ -636,10 +656,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL,
 			sizeof(cap.timeout));
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
-		/* The TPM is not started, we are the first to talk to it.
-		   Execute a startup command. */
-		dev_info(&chip->dev, "Issuing TPM_STARTUP\n");
-		if (tpm_startup(chip, TPM_ST_CLEAR))
+		if (tpm_startup(chip))
 			return rc;
 
 		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index d9835b31f652..1f9094f03151 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -371,16 +371,11 @@ struct tpm_getrandom_in {
 	__be32 num_bytes;
 } __packed;
 
-struct tpm_startup_in {
-	__be16	startup_type;
-} __packed;
-
 typedef union {
 	struct	tpm_pcrread_in	pcrread_in;
 	struct	tpm_pcrread_out	pcrread_out;
 	struct	tpm_getrandom_in getrandom_in;
 	struct	tpm_getrandom_out getrandom_out;
-	struct tpm_startup_in startup_in;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
@@ -506,6 +501,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
 			 const void *buf, size_t bufsiz,
 			 size_t min_rsp_body_length, unsigned int flags,
 			 const char *desc);
+int tpm_startup(struct tpm_chip *chip);
 ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		   const char *desc, size_t min_cap_length);
 int tpm_get_timeouts(struct tpm_chip *);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 3a9964326279..1962c9b15cd5 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -779,36 +779,6 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 }
 EXPORT_SYMBOL_GPL(tpm2_get_tpm_pt);
 
-#define TPM2_STARTUP_IN_SIZE \
-	(sizeof(struct tpm_input_header) + \
-	 sizeof(struct tpm2_startup_in))
-
-static const struct tpm_input_header tpm2_startup_header = {
-	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
-	.length = cpu_to_be32(TPM2_STARTUP_IN_SIZE),
-	.ordinal = cpu_to_be32(TPM2_CC_STARTUP)
-};
-
-/**
- * tpm2_startup() - send startup command to the TPM chip
- *
- * @chip:		TPM chip to use.
- * @startup_type:	startup type. The value is either
- *			TPM_SU_CLEAR or TPM_SU_STATE.
- *
- * Return: Same as with tpm_transmit_cmd.
- */
-static int tpm2_startup(struct tpm_chip *chip, u16 startup_type)
-{
-	struct tpm2_cmd cmd;
-
-	cmd.header.in = tpm2_startup_header;
-
-	cmd.params.startup_in.startup_type = cpu_to_be16(startup_type);
-	return tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
-				"attempting to start the TPM");
-}
-
 #define TPM2_SHUTDOWN_IN_SIZE \
 	(sizeof(struct tpm_input_header) + \
 	 sizeof(struct tpm2_startup_in))
@@ -1150,7 +1120,7 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 	}
 
 	if (rc == TPM2_RC_INITIALIZE) {
-		rc = tpm2_startup(chip, TPM2_SU_CLEAR);
+		rc = tpm_startup(chip);
 		if (rc)
 			goto out;
 
-- 
2.11.0

