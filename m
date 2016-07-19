From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v3 5/5] tpm: use tpm_pcr_read_dev() in tpm_do_selftest()
Date: Tue, 19 Jul 2016 16:32:49 +0300
Message-ID: <1468935171-7815-6-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1468935171-7815-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1468935171-7815-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Remove ad-hoc protocol message construction and call instead
tpm_pcr_read_dev().

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 35b2722..2db1610e 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -797,7 +797,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 	unsigned int loops;
 	unsigned int delay_msec = 100;
 	unsigned long duration;
-	struct tpm_cmd_t cmd;
+	u8 dummy[TPM_DIGEST_SIZE];
 
 	duration = tpm_calc_ordinal_duration(chip, TPM_ORD_CONTINUE_SELFTEST);
 
@@ -812,9 +812,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 
 	do {
 		/* Attempt to read a PCR value */
-		cmd.header.in = pcrread_header;
-		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
-		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
+		rc = tpm_pcr_read_dev(chip, 0, dummy);
 		/* Some buggy TPMs will not respond to tpm_tis_ready() for
 		 * around 300ms while the self test is ongoing, keep trying
 		 * until the self test duration expires. */
@@ -829,7 +827,6 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		if (rc < TPM_HEADER_SIZE)
 			return -EFAULT;
 
-		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
 			dev_info(&chip->dev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);
-- 
2.7.4

