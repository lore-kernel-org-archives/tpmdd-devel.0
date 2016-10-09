From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RFC 1/2] tpm: move TPM 2.0 command and
	response constants to tpm2-cmd.c
Date: Sun,  9 Oct 2016 13:14:15 +0300
Message-ID: <1476008057-2395-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1476008057-2395-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1476008057-2395-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The constans used to construct TPM 2.0 messages are only needed inside
tpm2-cmd.c so it is better to move them there.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm.h      | 42 ------------------------------------------
 drivers/char/tpm/tpm2-cmd.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4d183c9..0fab6d5 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -81,48 +81,6 @@ enum tpm2_const {
 	TPM2_DURATION_LONG	= 2000,
 };
 
-enum tpm2_structures {
-	TPM2_ST_NO_SESSIONS	= 0x8001,
-	TPM2_ST_SESSIONS	= 0x8002,
-};
-
-enum tpm2_return_codes {
-	TPM2_RC_HASH		= 0x0083, /* RC_FMT1 */
-	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
-	TPM2_RC_DISABLED	= 0x0120,
-	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
-};
-
-enum tpm2_algorithms {
-	TPM2_ALG_SHA1		= 0x0004,
-	TPM2_ALG_KEYEDHASH	= 0x0008,
-	TPM2_ALG_SHA256		= 0x000B,
-	TPM2_ALG_SHA384		= 0x000C,
-	TPM2_ALG_SHA512		= 0x000D,
-	TPM2_ALG_NULL		= 0x0010,
-	TPM2_ALG_SM3_256	= 0x0012,
-};
-
-enum tpm2_command_codes {
-	TPM2_CC_FIRST		= 0x011F,
-	TPM2_CC_SELF_TEST	= 0x0143,
-	TPM2_CC_STARTUP		= 0x0144,
-	TPM2_CC_SHUTDOWN	= 0x0145,
-	TPM2_CC_CREATE		= 0x0153,
-	TPM2_CC_LOAD		= 0x0157,
-	TPM2_CC_UNSEAL		= 0x015E,
-	TPM2_CC_FLUSH_CONTEXT	= 0x0165,
-	TPM2_CC_GET_CAPABILITY	= 0x017A,
-	TPM2_CC_GET_RANDOM	= 0x017B,
-	TPM2_CC_PCR_READ	= 0x017E,
-	TPM2_CC_PCR_EXTEND	= 0x0182,
-	TPM2_CC_LAST		= 0x018F,
-};
-
-enum tpm2_permanent_handles {
-	TPM2_RS_PW		= 0x40000009,
-};
-
 enum tpm2_capabilities {
 	TPM2_CAP_TPM_PROPERTIES = 6,
 };
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 7df55d5..2900e18 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -19,6 +19,48 @@
 #include <crypto/hash_info.h>
 #include <keys/trusted-type.h>
 
+enum tpm2_structures {
+	TPM2_ST_NO_SESSIONS	= 0x8001,
+	TPM2_ST_SESSIONS	= 0x8002,
+};
+
+enum tpm2_return_codes {
+	TPM2_RC_HASH		= 0x0083, /* RC_FMT1 */
+	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
+	TPM2_RC_DISABLED	= 0x0120,
+	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
+};
+
+enum tpm2_algorithms {
+	TPM2_ALG_SHA1		= 0x0004,
+	TPM2_ALG_KEYEDHASH	= 0x0008,
+	TPM2_ALG_SHA256		= 0x000B,
+	TPM2_ALG_SHA384		= 0x000C,
+	TPM2_ALG_SHA512		= 0x000D,
+	TPM2_ALG_NULL		= 0x0010,
+	TPM2_ALG_SM3_256	= 0x0012,
+};
+
+enum tpm2_command_codes {
+	TPM2_CC_FIRST		= 0x011F,
+	TPM2_CC_SELF_TEST	= 0x0143,
+	TPM2_CC_STARTUP		= 0x0144,
+	TPM2_CC_SHUTDOWN	= 0x0145,
+	TPM2_CC_CREATE		= 0x0153,
+	TPM2_CC_LOAD		= 0x0157,
+	TPM2_CC_UNSEAL		= 0x015E,
+	TPM2_CC_FLUSH_CONTEXT	= 0x0165,
+	TPM2_CC_GET_CAPABILITY	= 0x017A,
+	TPM2_CC_GET_RANDOM	= 0x017B,
+	TPM2_CC_PCR_READ	= 0x017E,
+	TPM2_CC_PCR_EXTEND	= 0x0182,
+	TPM2_CC_LAST		= 0x018F,
+};
+
+enum tpm2_permanent_handles {
+	TPM2_RS_PW		= 0x40000009,
+};
+
 enum tpm2_object_attributes {
 	TPM2_OA_USER_WITH_AUTH		= BIT(6),
 };
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
