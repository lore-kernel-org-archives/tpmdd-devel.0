From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/6] tpm: use tpm_buf functions to perform
 a PCR read
Date: Wed, 21 Jun 2017 16:29:36 +0200
Message-ID: <20170621142941.32674-2-roberto.sassu@huawei.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170621142941.32674-1-roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

tpm2_pcr_read() now uses tpm_buf functions to build the TPM command
to read a PCR. Those functions are preferred to passing a tpm2_cmd
structure, as they provide protection against buffer overflow.

Also, tpm2_pcr_read() code has been moved to tpm2_pcr_read_tpm_buf().
Callers have to pass a tpm_buf structure, an algorithm supported by
the TPM and call tpm_buf_destroy(). The algorithm still cannot be
passed to the TPM driver interface. This parameter has been introduced
for determining the digest size of a given algorithm.

Moving tpm2_pcr_read() code to tpm2_pcr_read_tpm_buf() is necessary
because callers of the new function obtain different information from
the output buffer: tpm2_pcr_read() gets the digest, tpm2_do_selftest()
will get the command return code and tpm2_get_pcr_allocation() will get
the digest size.

Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm2-cmd.c | 54 +++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 3a99643..afd1b63 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -231,15 +231,37 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
 	(sizeof(struct tpm_input_header) + \
 	 sizeof(struct tpm2_pcr_read_in))
 
-#define TPM2_PCR_READ_RESP_BODY_SIZE \
-	 sizeof(struct tpm2_pcr_read_out)
-
 static const struct tpm_input_header tpm2_pcrread_header = {
 	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
 	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
 	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
 };
 
+static int tpm2_pcr_read_tpm_buf(struct tpm_chip *chip, int pcr_idx,
+				 enum tpm2_algorithms algo, struct tpm_buf *buf,
+				 char *msg)
+{
+	int rc;
+	u8 pcr_select[TPM2_PCR_SELECT_MIN] = {0};
+
+	if (pcr_idx >= TPM2_PLATFORM_PCR)
+		return -EINVAL;
+
+	rc = tpm_buf_init(buf, TPM2_ST_NO_SESSIONS, TPM2_CC_PCR_READ);
+	if (rc)
+		return rc;
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
@@ -251,29 +273,17 @@ static const struct tpm_input_header tpm2_pcrread_header = {
 int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 {
 	int rc;
-	struct tpm2_cmd cmd;
-	u8 *buf;
-
-	if (pcr_idx >= TPM2_PLATFORM_PCR)
-		return -EINVAL;
-
-	cmd.header.in = tpm2_pcrread_header;
-	cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
-	cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
-	cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
-
-	memset(cmd.params.pcrread_in.pcr_select, 0,
-	       sizeof(cmd.params.pcrread_in.pcr_select));
-	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
+	struct tpm_buf buf;
+	struct tpm2_pcr_read_out *out;
 
-	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
-			      TPM2_PCR_READ_RESP_BODY_SIZE,
-			      0, "attempting to read a pcr value");
+	rc = tpm2_pcr_read_tpm_buf(chip, pcr_idx, TPM2_ALG_SHA1, &buf,
+				   "attempting to read a pcr value");
 	if (rc == 0) {
-		buf = cmd.params.pcrread_out.digest;
-		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
+		out = (struct tpm2_pcr_read_out *)&buf.data[TPM_HEADER_SIZE];
+		memcpy(res_buf, out->digest, TPM_DIGEST_SIZE);
 	}
 
+	tpm_buf_destroy(&buf);
 	return rc;
 }
 
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
