From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 10/26] tpm: constify local structures
Date: Sun, 11 Sep 2016 15:05:52 +0200
Message-ID: <1473599168-30561-11-git-send-email-Julia.Lawall@lip6.fr>
References: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

For structure types defined in the same file or local header files, find
top-level static structure declarations that have the following
properties:
1. Never reassigned.
2. Address never taken
3. Not passed to a top-level macro call
4. No pointer or array-typed field passed to a function or stored in a
variable.
Declare structures having all of these properties as const.

Done using Coccinelle.
Based on a suggestion by Joe Perches <joe@perches.com>.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch seems too long for a commit log, but is in the cover
letter.

 drivers/char/tpm/tpm-interface.c |   10 +++++-----
 drivers/char/tpm/tpm-sysfs.c     |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1abe2d7..e84888f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -633,7 +633,7 @@ EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 #define TPM_ORD_CONTINUE_SELFTEST 83
 #define CONTINUE_SELFTEST_RESULT_SIZE 10
 
-static struct tpm_input_header continue_selftest_header = {
+static const struct tpm_input_header continue_selftest_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(10),
 	.ordinal = cpu_to_be32(TPM_ORD_CONTINUE_SELFTEST),
@@ -659,7 +659,7 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 
 #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
 #define READ_PCR_RESULT_SIZE 30
-static struct tpm_input_header pcrread_header = {
+static const struct tpm_input_header pcrread_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(14),
 	.ordinal = TPM_ORDINAL_PCRREAD
@@ -745,7 +745,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
  */
 #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
 #define EXTEND_PCR_RESULT_SIZE 34
-static struct tpm_input_header pcrextend_header = {
+static const struct tpm_input_header pcrextend_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(34),
 	.ordinal = TPM_ORD_PCR_EXTEND
@@ -949,7 +949,7 @@ EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
 #define TPM_ORD_SAVESTATE cpu_to_be32(152)
 #define SAVESTATE_RESULT_SIZE 10
 
-static struct tpm_input_header savestate_header = {
+static const struct tpm_input_header savestate_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(10),
 	.ordinal = TPM_ORD_SAVESTATE
@@ -1032,7 +1032,7 @@ int tpm_pm_resume(struct device *dev)
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
 #define TPM_GETRANDOM_RESULT_SIZE	18
-static struct tpm_input_header tpm_getrandom_header = {
+static const struct tpm_input_header tpm_getrandom_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(14),
 	.ordinal = TPM_ORD_GET_RANDOM
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index b46cf70..26fccad 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -22,7 +22,7 @@
 
 #define READ_PUBEK_RESULT_SIZE 314
 #define TPM_ORD_READPUBEK cpu_to_be32(124)
-static struct tpm_input_header tpm_readpubek_header = {
+static const struct tpm_input_header tpm_readpubek_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(30),
 	.ordinal = TPM_ORD_READPUBEK
