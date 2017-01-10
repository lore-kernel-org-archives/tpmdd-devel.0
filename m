From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 03/10] tpm: tpm2_pcr_read: check size of
	response before accessing data
Date: Tue, 10 Jan 2017 09:18:13 -0500
Message-ID: <1484057900-17871-3-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1484057900-17871-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Check the size of the response before accessing data in the
response packet. This is to avoid accessing data beyond the
end of the response.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm2-cmd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index d302f06..e3f760c 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -248,6 +248,10 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
 	(sizeof(struct tpm_input_header) + \
 	 sizeof(struct tpm2_pcr_read_in))
 
+#define TPM2_PCR_READ_OUT_SIZE \
+	(sizeof(struct tpm_output_header) + \
+	 sizeof(struct tpm2_pcr_read_out))
+
 static const struct tpm_input_header tpm2_pcrread_header = {
 	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
 	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
@@ -282,6 +286,9 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
 			      "attempting to read a pcr value");
+	if (rc == 0 &&
+	    be32_to_cpu(cmd.header.out.length) < TPM2_PCR_READ_OUT_SIZE)
+		return -EFAULT;
 	if (rc == 0) {
 		buf = cmd.params.pcrread_out.digest;
 		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
-- 
2.4.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
