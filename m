From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] tpm: add kdoc for tpm_transmit and
	tpm_transmit_cmd
Date: Wed, 16 Nov 2016 19:03:38 +0200
Message-ID: <1479315821-27349-1-git-send-email-tomas.winkler@intel.com>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Functions tpm_transmit and transmit_cmd are referenced
from other functions kdoc hence deserve documentation.

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index a2688ac2b48f..56c238a6e005 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -328,8 +328,17 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
-/*
- * Internal kernel interface to transmit TPM commands
+/**
+ * tmp_transmit - Internal kernel interface to transmit TPM commands.
+ *
+ * @chip: TPM chip to use
+ * @buf: TPM command buffer
+ * @bufsiz: length of the TPM command buffer
+ * @flags: tpm transmit flags - bitmap
+ *
+ * Return:
+ *     0 when the operation is successful
+ *     A negative number for system errors (errno)
  */
 ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 		     unsigned int flags)
@@ -409,9 +418,21 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	return rc;
 }
 
-#define TPM_DIGEST_SIZE 20
-#define TPM_RET_CODE_IDX 6
-
+/**
+ * tmp_transmit_cmd - send a tpm command to the device
+ *    The function extracts tpm out header return code
+ *
+ * @chip: TPM chip to use
+ * @cmd: TPM command buffer
+ * @len: length of the TPM command
+ * @flags: tpm transmit flags - bitmap
+ * @desc: command description used in the error message
+ *
+ * Return:
+ *     0 when the operation is successful
+ *     A negative number for system errors (errno)
+ *     A positive number for a TPM error.
+ */
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
 			 int len, unsigned int flags, const char *desc)
 {
@@ -434,6 +455,8 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
 	return err;
 }
 
+#define TPM_DIGEST_SIZE 20
+#define TPM_RET_CODE_IDX 6
 #define TPM_INTERNAL_RESULT_SIZE 200
 #define TPM_ORD_GET_CAP cpu_to_be32(101)
 #define TPM_ORD_GET_RANDOM cpu_to_be32(70)
-- 
2.7.4


------------------------------------------------------------------------------
