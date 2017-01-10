From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH 10/10] tpm: tpm_pcr_read_dev: check size of response before accessing data
Date: Tue, 10 Jan 2017 09:18:20 -0500
Message-ID: <1484057900-17871-10-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Check the size of the response before accessing data in the
response packet. This is to avoid accessing data beyond the
end of the response.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm-interface.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1c04a2d..6b6f099 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -687,7 +687,9 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
 	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE, 0,
 			      "attempting to read a pcr value");
-
+	if (rc == 0 &&
+	    be32_to_cpu(cmd.header.out.length) < READ_PCR_RESULT_SIZE)
+		return -EFAULT;
 	if (rc == 0)
 		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
 		       TPM_DIGEST_SIZE);
-- 
2.4.3

