From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 5/5] ima: modify arguments of tpm_pcr_extend()
Date: Fri, 5 May 2017 16:21:52 +0200
Message-ID: <20170505142152.29795-6-roberto.sassu@huawei.com>
References: <20170505142152.29795-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170505142152.29795-1-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

ima_pcr_extend() has been modified to pass the correct arguments
to tpm_pcr_extend(): the pointer of a tpm2_digest structure containing
the template digest and the size of the array (1).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_queue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index d9aa5ab..f628968 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -140,12 +140,14 @@ unsigned long ima_get_binary_runtime_size(void)
 
 static int ima_pcr_extend(const u8 *hash, int pcr)
 {
+	struct tpm2_digest digestarg = {.alg_id = TPM2_ALG_SHA1};
 	int result = 0;
 
 	if (!ima_used_chip)
 		return result;
 
-	result = tpm_pcr_extend(TPM_ANY_NUM, pcr, hash);
+	memcpy(digestarg.digest, hash, IMA_DIGEST_SIZE);
+	result = tpm_pcr_extend(TPM_ANY_NUM, pcr, 1, &digestarg);
 	if (result != 0)
 		pr_err("Error Communicating to TPM chip, result: %d\n", result);
 	return result;
-- 
2.9.3

