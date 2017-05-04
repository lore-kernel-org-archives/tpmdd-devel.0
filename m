From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2, RESEND 3/3] tpm: move TPM 1.2 code of tpm_pcr_extend() to tpm1_pcr_extend()
Date: Thu, 4 May 2017 13:16:47 +0200
Message-ID: <20170504111647.9384-1-roberto.sassu@huawei.com>
References: <20170503161911.17606-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170503161911.17606-1-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

In preparation of the modifications to tpm_pcr_extend(), which will
allow callers to supply a digest for each PCR bank of a TPM 2.0,
the TPM 1.2 specific code has been moved to tpm1_pcr_extend().

tpm1_pcr_extend() uses tpm_buf_init() to prepare the command buffer,
which offers protection against buffer overflow. It is called by
tpm_pcr_extend() and tpm_pm_suspend().

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 drivers/char/tpm/tpm-interface.c | 41 +++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 7966d8d..4ed08ab 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -847,6 +847,25 @@ static const struct tpm_input_header pcrextend_header = {
 	.ordinal = cpu_to_be32(TPM_ORD_PCR_EXTEND)
 };
 
+static int tpm1_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash,
+			   char *log_msg)
+{
+	struct tpm_buf buf;
+	int rc;
+
+	rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND, TPM_ORD_PCR_EXTEND);
+	if (rc)
+		return rc;
+
+	tpm_buf_append_u32(&buf, pcr_idx);
+	tpm_buf_append(&buf, hash, TPM_DIGEST_SIZE);
+
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, EXTEND_PCR_RESULT_SIZE,
+			      EXTEND_PCR_RESULT_BODY_SIZE, 0, log_msg);
+	tpm_buf_destroy(&buf);
+	return rc;
+}
+
 /**
  * tpm_pcr_extend - extend pcr value with hash
  * @chip_num:	tpm idx # or AN&
@@ -859,7 +878,6 @@ static const struct tpm_input_header pcrextend_header = {
  */
 int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 {
-	struct tpm_cmd_t cmd;
 	int rc;
 	struct tpm_chip *chip;
 	struct tpm2_digest digest_list[ARRAY_SIZE(chip->active_banks)];
@@ -885,13 +903,8 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 		return rc;
 	}
 
-	cmd.header.in = pcrextend_header;
-	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
-	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
-			      EXTEND_PCR_RESULT_BODY_SIZE, 0,
-			      "attempting extend a PCR value");
-
+	rc = tpm1_pcr_extend(chip, pcr_idx, hash,
+			     "attempting extend a PCR value");
 	tpm_put_ops(chip);
 	return rc;
 }
@@ -1090,15 +1103,9 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 	/* for buggy tpm, flush pcrs with extend to selected dummy */
-	if (tpm_suspend_pcr) {
-		cmd.header.in = pcrextend_header;
-		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
-		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
-		       TPM_DIGEST_SIZE);
-		rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
-				      EXTEND_PCR_RESULT_BODY_SIZE, 0,
-				      "extending dummy pcr before suspend");
-	}
+	if (tpm_suspend_pcr)
+		rc = tpm1_pcr_extend(chip, tpm_suspend_pcr, dummy_hash,
+				     "extending dummy pcr before suspend");
 
 	/* now do the actual savestate */
 	for (try = 0; try < TPM_RETRY; try++) {
-- 
2.9.3

