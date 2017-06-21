From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 2/6] tpm: use tpm2_pcr_read_tpm_buf() in
 tpm2_do_selftest()
Date: Wed, 21 Jun 2017 16:29:37 +0200
Message-ID: <20170621142941.32674-3-roberto.sassu@huawei.com>
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

tpm2_do_selftest() performs a PCR read during the TPM initialization phase.
This patch replaces the PCR read code with a call to
tpm2_pcr_read_tpm_buf(). tpm2_do_selftest() parses the result of the
TPM command, in order to retrieve the return code.

Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm2-cmd.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index afd1b63..6a9fe0d 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -227,16 +227,6 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
 	TPM_UNDEFINED		/* 18f */
 };
 
-#define TPM2_PCR_READ_IN_SIZE \
-	(sizeof(struct tpm_input_header) + \
-	 sizeof(struct tpm2_pcr_read_in))
-
-static const struct tpm_input_header tpm2_pcrread_header = {
-	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
-	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
-	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
-};
-
 static int tpm2_pcr_read_tpm_buf(struct tpm_chip *chip, int pcr_idx,
 				 enum tpm2_algorithms algo, struct tpm_buf *buf,
 				 char *msg)
@@ -938,7 +928,8 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 	unsigned int loops;
 	unsigned int delay_msec = 100;
 	unsigned long duration;
-	struct tpm2_cmd cmd;
+	struct tpm_buf buf;
+	tpm_cmd_header *header;
 	int i;
 
 	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
@@ -951,20 +942,17 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 
 	for (i = 0; i < loops; i++) {
 		/* Attempt to read a PCR value */
-		cmd.header.in = tpm2_pcrread_header;
-		cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
-		cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
-		cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
-		cmd.params.pcrread_in.pcr_select[0] = 0x01;
-		cmd.params.pcrread_in.pcr_select[1] = 0x00;
-		cmd.params.pcrread_in.pcr_select[2] = 0x00;
-
-		rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
-				      NULL);
+		rc = tpm2_pcr_read_tpm_buf(chip, 0, TPM2_ALG_SHA1, &buf, NULL);
+		if (rc >= 0) {
+			header = (tpm_cmd_header *)buf.data;
+			rc = be32_to_cpu(header->out.return_code);
+		}
+
+		tpm_buf_destroy(&buf);
+
 		if (rc < 0)
 			break;
 
-		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc != TPM2_RC_TESTING)
 			break;
 
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
