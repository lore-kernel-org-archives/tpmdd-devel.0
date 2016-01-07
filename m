From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: fix checks for policy digest existence
	in tpm2_seal_trusted()
Date: Thu,  7 Jan 2016 08:24:30 +0200
Message-ID: <1452147870-9256-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

In my original patch sealing with policy was done with dynamically
allocated buffer that I changed later into an array so the checks in
tpm2-cmd.c became invalid. This patch fixes the issue.

Fixes: 5beb0c435bdd ("keys, trusted: seal with a TPM2 authorization policy")
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm2-cmd.c | 12 ++++--------
 include/keys/trusted-type.h |  2 +-
 security/keys/trusted.c     | 11 +++++------
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 45a6340..66e04b4 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -478,20 +478,16 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	tpm_buf_append_u8(&buf, payload->migratable);
 
 	/* public */
-	if (options->policydigest)
-		tpm_buf_append_u16(&buf, 14 + options->digest_len);
-	else
-		tpm_buf_append_u16(&buf, 14);
-
+	tpm_buf_append_u16(&buf, 14 + options->policydigest_len);
 	tpm_buf_append_u16(&buf, TPM2_ALG_KEYEDHASH);
 	tpm_buf_append_u16(&buf, hash);
 
 	/* policy */
-	if (options->policydigest) {
+	if (options->policydigest_len) {
 		tpm_buf_append_u32(&buf, 0);
-		tpm_buf_append_u16(&buf, options->digest_len);
+		tpm_buf_append_u16(&buf, options->policydigest_len);
 		tpm_buf_append(&buf, options->policydigest,
-			       options->digest_len);
+			       options->policydigest_len);
 	} else {
 		tpm_buf_append_u32(&buf, TPM2_ATTR_USER_WITH_AUTH);
 		tpm_buf_append_u16(&buf, 0);
diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
index 42cf2d9..4ea7e55 100644
--- a/include/keys/trusted-type.h
+++ b/include/keys/trusted-type.h
@@ -38,7 +38,7 @@ struct trusted_key_options {
 	unsigned char pcrinfo[MAX_PCRINFO_SIZE];
 	int pcrlock;
 	uint32_t hash;
-	uint32_t digest_len;
+	uint32_t policydigest_len;
 	unsigned char policydigest[MAX_DIGEST_SIZE];
 	uint32_t policyhandle;
 };
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index e15baf7..76248d1 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -744,6 +744,7 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 	unsigned long handle;
 	unsigned long lock;
 	unsigned long token_mask = 0;
+	unsigned int digest_len;
 	int i;
 	int tpm2;
 
@@ -752,7 +753,6 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 		return tpm2;
 
 	opt->hash = tpm2 ? HASH_ALGO_SHA256 : HASH_ALGO_SHA1;
-	opt->digest_len = hash_digest_size[opt->hash];
 
 	while ((p = strsep(&c, " \t"))) {
 		if (*p == '\0' || *p == ' ' || *p == '\t')
@@ -812,8 +812,6 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 			for (i = 0; i < HASH_ALGO__LAST; i++) {
 				if (!strcmp(args[0].from, hash_algo_name[i])) {
 					opt->hash = i;
-					opt->digest_len =
-						hash_digest_size[opt->hash];
 					break;
 				}
 			}
@@ -825,13 +823,14 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 			}
 			break;
 		case Opt_policydigest:
-			if (!tpm2 ||
-			    strlen(args[0].from) != (2 * opt->digest_len))
+			digest_len = hash_digest_size[opt->hash];
+			if (!tpm2 || strlen(args[0].from) != (2 * digest_len))
 				return -EINVAL;
 			res = hex2bin(opt->policydigest, args[0].from,
-				      opt->digest_len);
+				      digest_len);
 			if (res < 0)
 				return -EINVAL;
+			opt->policydigest_len = digest_len;
 			break;
 		case Opt_policyhandle:
 			if (!tpm2)
-- 
2.5.0


------------------------------------------------------------------------------
