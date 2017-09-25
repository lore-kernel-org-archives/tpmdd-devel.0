From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 1/3] tpm: move PCR read code to static function tpm2_pcr_read_common()
Date: Mon, 25 Sep 2017 13:19:48 +0200
Message-ID: <20170925111950.21511-2-roberto.sassu@huawei.com>
References: <20170925111950.21511-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170925111950.21511-1-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

tpm2_pcr_read() copies the digest stored in a PCR to a buffer provided by
the caller. However, it does not return the digest size, included in the
output from the TPM. Retrieving it would be useful when a TPM algorithm
is not known by the crypto subsystem, which the TPM driver currently
depends upon.

Most of tpm2_pcr_read() code is moved to the static function
tpm2_pcr_read_common(), which writes the output of the PCR read to the
tpm_buf structure passed as input.

tpm2_pcr_read_common() will be called by tpm2_pcr_read(), and by the new
function tpm2_init_active_bank_info(), which will store the identifier
and the digest size of TPM algorithms in the tpm_chip structure.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 drivers/char/tpm/tpm2-cmd.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index e1a41b7..0cad0f6 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -218,6 +218,26 @@ struct tpm2_pcr_read_out {
 	u8	digest[];
 } __packed;
 
+static int tpm2_pcr_read_common(struct tpm_chip *chip, int pcr_idx,
+				enum tpm2_algorithms algo, struct tpm_buf *buf,
+				char *msg)
+{
+	u8 pcr_select[TPM2_PCR_SELECT_MIN] = {0};
+
+	if (pcr_idx >= TPM2_PLATFORM_PCR)
+		return -EINVAL;
+
+	pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
+
+	tpm_buf_append_u32(buf, 1);
+	tpm_buf_append_u16(buf, algo);
+	tpm_buf_append_u8(buf, TPM2_PCR_SELECT_MIN);
+	tpm_buf_append(buf, (const unsigned char *)pcr_select,
+		       sizeof(pcr_select));
+
+	return tpm_transmit_cmd(chip, NULL, buf->data, PAGE_SIZE, 0, 0, msg);
+}
+
 /**
  * tpm2_pcr_read() - read a PCR value
  * @chip:	TPM chip to use.
@@ -231,24 +251,12 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	int rc;
 	struct tpm_buf buf;
 	struct tpm2_pcr_read_out *out;
-	u8 pcr_select[TPM2_PCR_SELECT_MIN] = {0};
-
-	if (pcr_idx >= TPM2_PLATFORM_PCR)
-		return -EINVAL;
 
 	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_PCR_READ);
 	if (rc)
 		return rc;
 
-	pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
-
-	tpm_buf_append_u32(&buf, 1);
-	tpm_buf_append_u16(&buf, TPM2_ALG_SHA1);
-	tpm_buf_append_u8(&buf, TPM2_PCR_SELECT_MIN);
-	tpm_buf_append(&buf, (const unsigned char *)pcr_select,
-		       sizeof(pcr_select));
-
-	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, 0,
+	rc = tpm2_pcr_read_common(chip, pcr_idx, TPM2_ALG_SHA1, &buf,
 			res_buf ? "attempting to read a pcr value" : NULL);
 	if (rc == 0 && res_buf) {
 		out = (struct tpm2_pcr_read_out *)&buf.data[TPM_HEADER_SIZE];
-- 
2.9.3

