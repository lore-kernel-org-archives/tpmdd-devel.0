From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 3/6] tpm: introduce tpm_pcr_bank_info
 structure with digest_size from TPM
Date: Wed, 21 Jun 2017 16:29:38 +0200
Message-ID: <20170621142941.32674-4-roberto.sassu@huawei.com>
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

This patch introduces the new structure tpm_pcr_bank_info to store
information regarding PCR banks. The next patch will replace the array of
TPM algorithms IDs with an array of the new structure.

tpm_pcr_bank_info contains the TPM algorithm ID, the digest size and,
optionally, the corresponding crypto ID, if a mapping exists. These
information will be used by IMA to calculate the digest of an event
and to provide measurements logs to userspace applications. The new
structure has been defined in include/linux/tpm.h, as it will be passed
to functions outside the TPM driver.

The purpose of this patch is to fix a serious issue in tpm2_pcr_extend():
if the mapping between a TPM algorithm and a crypto algorithm is not
defined, the PCR bank with the unknown algorithm is not extended.
This gives the opportunity to an attacker to reply to remote attestation
requests with a list of fake measurements. Instead, the digest size
is retrieved from the output buffer of a PCR read, without relying
on the crypto subsystem.

Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm.h      | 11 -----------
 drivers/char/tpm/tpm2-cmd.c | 30 ++++++++++++++++++++++++++++++
 include/linux/tpm.h         | 19 +++++++++++++++++++
 3 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 1df0521..62c600d 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -98,17 +98,6 @@ enum tpm2_return_codes {
 	TPM2_RC_REFERENCE_H0	= 0x0910,
 };
 
-enum tpm2_algorithms {
-	TPM2_ALG_ERROR		= 0x0000,
-	TPM2_ALG_SHA1		= 0x0004,
-	TPM2_ALG_KEYEDHASH	= 0x0008,
-	TPM2_ALG_SHA256		= 0x000B,
-	TPM2_ALG_SHA384		= 0x000C,
-	TPM2_ALG_SHA512		= 0x000D,
-	TPM2_ALG_NULL		= 0x0010,
-	TPM2_ALG_SM3_256	= 0x0012,
-};
-
 enum tpm2_command_codes {
 	TPM2_CC_FIRST		= 0x011F,
 	TPM2_CC_SELF_TEST	= 0x0143,
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 6a9fe0d..74a68ea 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -992,6 +992,36 @@ int tpm2_probe(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm2_probe);
 
+static int tpm2_init_pcr_bank_info(struct tpm_chip *chip, u16 alg_id,
+				   struct tpm_pcr_bank_info *active_bank)
+{
+	struct tpm_buf buf;
+	struct tpm2_pcr_read_out *pcrread_out;
+	int rc = 0;
+	int i;
+
+	active_bank->alg_id = alg_id;
+
+	rc = tpm2_pcr_read_tpm_buf(chip, 0, alg_id, &buf, NULL);
+	if (rc)
+		goto out;
+
+	pcrread_out = (struct tpm2_pcr_read_out *)&buf.data[TPM_HEADER_SIZE];
+
+	active_bank->digest_size = be16_to_cpu(pcrread_out->digest_size);
+	active_bank->crypto_id = HASH_ALGO__LAST;
+
+	for (i = 0; i < ARRAY_SIZE(tpm2_hash_map); i++) {
+		if (active_bank->alg_id != tpm2_hash_map[i].tpm_id)
+			continue;
+
+		active_bank->crypto_id = tpm2_hash_map[i].crypto_id;
+	}
+out:
+	tpm_buf_destroy(&buf);
+	return rc;
+}
+
 struct tpm2_pcr_selection {
 	__be16  hash_alg;
 	u8  size_of_select;
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 5a090f5..ff06738 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -22,6 +22,8 @@
 #ifndef __LINUX_TPM_H__
 #define __LINUX_TPM_H__
 
+#include <crypto/hash_info.h>
+
 #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
 
 /*
@@ -37,6 +39,17 @@ enum TPM_OPS_FLAGS {
 	TPM_OPS_AUTO_STARTUP = BIT(0),
 };
 
+enum tpm2_algorithms {
+	TPM2_ALG_ERROR		= 0x0000,
+	TPM2_ALG_SHA1		= 0x0004,
+	TPM2_ALG_KEYEDHASH	= 0x0008,
+	TPM2_ALG_SHA256		= 0x000B,
+	TPM2_ALG_SHA384		= 0x000C,
+	TPM2_ALG_SHA512		= 0x000D,
+	TPM2_ALG_NULL		= 0x0010,
+	TPM2_ALG_SM3_256	= 0x0012,
+};
+
 struct tpm_class_ops {
 	unsigned int flags;
 	const u8 req_complete_mask;
@@ -52,6 +65,12 @@ struct tpm_class_ops {
 	void (*relinquish_locality)(struct tpm_chip *chip, int loc);
 };
 
+struct tpm_pcr_bank_info {
+	enum tpm2_algorithms alg_id;
+	enum hash_algo crypto_id;
+	u32 digest_size;
+};
+
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_is_tpm2(u32 chip_num);
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
