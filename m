From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 07/10] tpm: tpm2_unseal_cmd: check size of
	response before accessing data
Date: Tue, 10 Jan 2017 09:18:17 -0500
Message-ID: <1484057900-17871-7-git-send-email-stefanb@linux.vnet.ibm.com>
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
 drivers/char/tpm/tpm2-cmd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 4bcda2b..f55e876 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -689,6 +689,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	u16 data_len;
 	u8 *data;
 	int rc;
+	u32 rlength;
 
 	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
 	if (rc)
@@ -708,8 +709,19 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 		rc = -EPERM;
 
 	if (!rc) {
+		rlength = be32_to_cpu(((struct tpm2_cmd *)&buf)
+					->header.out.length);
+		if (rlength < TPM_HEADER_SIZE + 4 + 2) {
+			rc = -EFAULT;
+			goto out;
+		}
 		data_len = be16_to_cpup(
 			(__be16 *) &buf.data[TPM_HEADER_SIZE + 4]);
+
+		if (rlength < TPM_HEADER_SIZE + 4 + 2 + data_len) {
+			rc = -EFAULT;
+			goto out;
+		}
 		data = &buf.data[TPM_HEADER_SIZE + 6];
 
 		memcpy(payload->key, data, data_len - 1);
@@ -717,6 +729,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 		payload->migratable = data[data_len - 1];
 	}
 
+out:
 	tpm_buf_destroy(&buf);
 	return rc;
 }
-- 
2.4.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
