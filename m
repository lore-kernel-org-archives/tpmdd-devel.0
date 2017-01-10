From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 09/10] tpm: tpm_get_random: check size of
	response before accessing data
Date: Tue, 10 Jan 2017 09:18:19 -0500
Message-ID: <1484057900-17871-9-git-send-email-stefanb@linux.vnet.ibm.com>
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
 drivers/char/tpm/tpm-interface.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index f80df9c..1c04a2d 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1059,7 +1059,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 {
 	struct tpm_chip *chip;
 	struct tpm_cmd_t tpm_cmd;
-	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA);
+	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA), rlength;
 	int err, total = 0, retries = 5;
 	u8 *dest = out;
 
@@ -1085,8 +1085,18 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 				       0, "attempting get random");
 		if (err)
 			break;
-
+		rlength = be32_to_cpu(tpm_cmd.header.out.length);
+		if (rlength < offsetof(struct tpm_cmd_t,
+				       params.getrandom_out.rng_data)) {
+			total = -EFAULT;
+			break;
+		}
 		recd = be32_to_cpu(tpm_cmd.params.getrandom_out.rng_data_len);
+		if (rlength < offsetof(struct tpm_cmd_t,
+				       params.getrandom_out.rng_data) + recd) {
+			total = -EFAULT;
+			break;
+		}
 		memcpy(dest, tpm_cmd.params.getrandom_out.rng_data, recd);
 
 		dest += recd;
-- 
2.4.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
