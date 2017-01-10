From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 04/10] tpm: tpm2_get_random: check size of
	response before accessing data
Date: Tue, 10 Jan 2017 09:18:14 -0500
Message-ID: <1484057900-17871-4-git-send-email-stefanb@linux.vnet.ibm.com>
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
 drivers/char/tpm/tpm2-cmd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index e3f760c..1e704a1 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -363,7 +363,7 @@ static const struct tpm_input_header tpm2_getrandom_header = {
 int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 {
 	struct tpm2_cmd cmd;
-	u32 recd;
+	u32 recd, rlength;
 	u32 num_bytes;
 	int err;
 	int total = 0;
@@ -385,8 +385,16 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 		if (err)
 			break;
 
+		rlength = be32_to_cpu(cmd.header.out.length);
+		if (rlength < offsetof(struct tpm2_cmd,
+				       params.getrandom_out.buffer))
+			return -EFAULT;
+
 		recd = min_t(u32, be16_to_cpu(cmd.params.getrandom_out.size),
 			     num_bytes);
+		if (rlength < offsetof(struct tpm2_cmd,
+				       params.getrandom_out.buffer) + recd)
+			return -EFAULT;
 		memcpy(dest, cmd.params.getrandom_out.buffer, recd);
 
 		dest += recd;
-- 
2.4.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
