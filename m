From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 1/3] tpm: use CPU native value for TPM_TAG_RQU_COMMAND
Date: Tue, 2 May 2017 14:31:49 +0200
Message-ID: <20170502123151.24354-2-roberto.sassu@huawei.com>
References: <20170502123151.24354-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170502123151.24354-1-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

In the long term, TPM 1.2 functions in the driver interface will be
converted to use tpm_buf_init().

However, tag and ordinals cannot be passed directly to tpm_buf_init(),
because this function performs CPU native to big-endian conversion of these
arguments. Since TPM_TAG_RQU_COMMAND and TPM_ORD_ are already converted,
passing them to the function will undo the previous conversion.

This patch removes the definition of TPM_TAG_RQU_COMMAND in the
tpm driver directory, and uses the CPU native value defined in
include/linux/tpm_command.h.

The conversion of TPM_TAG_RQU_COMMAND is done in the tpm_input_header
declarations.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 drivers/char/tpm/tpm-interface.c | 15 ++++++++-------
 drivers/char/tpm/tpm-sysfs.c     |  3 ++-
 drivers/char/tpm/tpm.h           |  2 --
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index bd2128e..48f5dff 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -30,6 +30,7 @@
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
 #include <linux/pm_runtime.h>
+#include <linux/tpm_command.h>
 
 #include "tpm.h"
 #include "tpm_eventlog.h"
@@ -472,7 +473,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf,
 #define TPM_ORD_GET_RANDOM cpu_to_be32(70)
 
 static const struct tpm_input_header tpm_getcap_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
+	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
 	.length = cpu_to_be32(22),
 	.ordinal = TPM_ORD_GET_CAP
 };
@@ -514,7 +515,7 @@ EXPORT_SYMBOL_GPL(tpm_getcap);
 #define TPM_ST_STATE cpu_to_be16(2)
 #define TPM_ST_DEACTIVATED cpu_to_be16(3)
 static const struct tpm_input_header tpm_startup_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
+	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
 	.length = cpu_to_be32(12),
 	.ordinal = TPM_ORD_STARTUP
 };
@@ -664,7 +665,7 @@ EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 #define CONTINUE_SELFTEST_RESULT_SIZE 10
 
 static const struct tpm_input_header continue_selftest_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
+	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
 	.length = cpu_to_be32(10),
 	.ordinal = cpu_to_be32(TPM_ORD_CONTINUE_SELFTEST),
 };
@@ -691,7 +692,7 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 #define READ_PCR_RESULT_SIZE 30
 #define READ_PCR_RESULT_BODY_SIZE 20
 static const struct tpm_input_header pcrread_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
+	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
 	.length = cpu_to_be32(14),
 	.ordinal = TPM_ORDINAL_PCRREAD
 };
@@ -769,7 +770,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
 #define EXTEND_PCR_RESULT_SIZE 34
 #define EXTEND_PCR_RESULT_BODY_SIZE 20
 static const struct tpm_input_header pcrextend_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
+	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
 	.length = cpu_to_be32(34),
 	.ordinal = TPM_ORD_PCR_EXTEND
 };
@@ -991,7 +992,7 @@ EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
 #define SAVESTATE_RESULT_SIZE 10
 
 static const struct tpm_input_header savestate_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
+	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
 	.length = cpu_to_be32(10),
 	.ordinal = TPM_ORD_SAVESTATE
 };
@@ -1076,7 +1077,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
 #define TPM_GETRANDOM_RESULT_SIZE	18
 static const struct tpm_input_header tpm_getrandom_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
+	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
 	.length = cpu_to_be32(14),
 	.ordinal = TPM_ORD_GET_RANDOM
 };
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 2f596d7..69a0741 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -18,13 +18,14 @@
  *
  */
 #include <linux/device.h>
+#include <linux/tpm_command.h>
 #include "tpm.h"
 
 #define READ_PUBEK_RESULT_SIZE 314
 #define READ_PUBEK_RESULT_MIN_BODY_SIZE (28 + 256)
 #define TPM_ORD_READPUBEK cpu_to_be32(124)
 static const struct tpm_input_header tpm_readpubek_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
+	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
 	.length = cpu_to_be32(30),
 	.ordinal = TPM_ORD_READPUBEK
 };
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4937b56..d88c462 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -215,8 +215,6 @@ struct tpm_output_header {
 	__be32	return_code;
 } __packed;
 
-#define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
-
 struct	stclear_flags_t {
 	__be16	tag;
 	u8	deactivated;
-- 
2.9.3

