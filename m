From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: remove redundant code from self-test
	functions
Date: Wed, 30 Mar 2016 08:37:59 +0300
Message-ID: <1459316279-32532-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Self-test functions construct PCR read calls by ad hoc, which is only a
waste space. Use instead tpm_pcr_read_dev (renamed as tpm1_pcr_read() by
this commit) in tpm_do_selftest and tpm2_pcr_read() in
tpm2_do_selftest() functions in order to remove the duplicate code.

Patch can be tested easily tested by running the a kernel with this
patch compiled in since self-test is done when the a device driver
initializes.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 14 +++++---------
 drivers/char/tpm/tpm2-cmd.c      | 14 ++------------
 2 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 5397b64..0c8140f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2004 IBM Corporation
- * Copyright (C) 2014 Intel Corporation
+ * Copyright (C) 2014, 2016 Intel Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
@@ -666,7 +666,7 @@ static struct tpm_input_header pcrread_header = {
 	.ordinal = TPM_ORDINAL_PCRREAD
 };
 
-int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
+int tpm1_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 {
 	int rc;
 	struct tpm_cmd_t cmd;
@@ -676,7 +676,7 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
 			      "attempting to read a pcr value");
 
-	if (rc == 0)
+	if (rc == 0 && res_buf)
 		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
 		       TPM_DIGEST_SIZE);
 	return rc;
@@ -728,7 +728,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		rc = tpm2_pcr_read(chip, pcr_idx, res_buf);
 	else
-		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
+		rc = tpm1_pcr_read(chip, pcr_idx, res_buf);
 	tpm_put_ops(chip);
 	return rc;
 }
@@ -793,7 +793,6 @@ int tpm_do_selftest(struct tpm_chip *chip)
 	unsigned int loops;
 	unsigned int delay_msec = 100;
 	unsigned long duration;
-	struct tpm_cmd_t cmd;
 
 	duration = tpm_calc_ordinal_duration(chip, TPM_ORD_CONTINUE_SELFTEST);
 
@@ -808,9 +807,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 
 	do {
 		/* Attempt to read a PCR value */
-		cmd.header.in = pcrread_header;
-		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
-		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
+		rc = tpm1_pcr_read(chip, 0, NULL);
 		/* Some buggy TPMs will not respond to tpm_tis_ready() for
 		 * around 300ms while the self test is ongoing, keep trying
 		 * until the self test duration expires. */
@@ -825,7 +822,6 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		if (rc < TPM_HEADER_SIZE)
 			return -EFAULT;
 
-		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
 			dev_info(&chip->dev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 5fc0e7c..afe8d47 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -284,7 +284,7 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
 			      "attempting to read a pcr value");
-	if (rc == 0) {
+	if (rc == 0 && res_buf) {
 		buf = cmd.params.pcrread_out.digest;
 		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
 	}
@@ -861,7 +861,6 @@ int tpm2_do_selftest(struct tpm_chip *chip)
 	unsigned int loops;
 	unsigned int delay_msec = 100;
 	unsigned long duration;
-	struct tpm2_cmd cmd;
 	int i;
 
 	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
@@ -874,19 +873,10 @@ int tpm2_do_selftest(struct tpm_chip *chip)
 
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
-		rc = tpm_transmit_cmd(chip, (u8 *) &cmd, sizeof(cmd), NULL);
+		rc = tpm2_pcr_read(chip, 0, NULL);
 		if (rc < 0)
 			break;
 
-		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc != TPM2_RC_TESTING)
 			break;
 
-- 
2.7.3


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
