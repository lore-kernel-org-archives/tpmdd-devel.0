From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 1/3] tpm: fix: keep auth session intact after
	unseal operation
Date: Mon, 15 Feb 2016 03:41:04 +0200
Message-ID: <1455500466-11266-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1455500466-11266-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455500466-11266-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The behavior of policy based unseal operation is not consistent:

* When there is an error in TPM2_Unseal operation, the session object
  stays in the TPM transient memory.
* When the unseal is successful, the TPM automatically removes the
  session object.

This patch sets the continueSession attribute to keep the session intact
after a successful unseal operation thus making the behavior consistent.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Fixes: 5beb0c435b ("keys, trusted: seal with a TPM2 authorization policy")
---
 drivers/char/tpm/tpm2-cmd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 66e04b4..b28e4da 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -20,7 +20,11 @@
 #include <keys/trusted-type.h>
 
 enum tpm2_object_attributes {
-	TPM2_ATTR_USER_WITH_AUTH	= BIT(6),
+	TPM2_OA_USER_WITH_AUTH		= BIT(6),
+};
+
+enum tpm2_session_attributes {
+	TPM2_SA_CONTINUE_SESSION	= BIT(0),
 };
 
 struct tpm2_startup_in {
@@ -489,7 +493,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		tpm_buf_append(&buf, options->policydigest,
 			       options->policydigest_len);
 	} else {
-		tpm_buf_append_u32(&buf, TPM2_ATTR_USER_WITH_AUTH);
+		tpm_buf_append_u32(&buf, TPM2_OA_USER_WITH_AUTH);
 		tpm_buf_append_u16(&buf, 0);
 	}
 
@@ -627,7 +631,7 @@ static int tpm2_unseal(struct tpm_chip *chip,
 			     options->policyhandle ?
 			     options->policyhandle : TPM2_RS_PW,
 			     NULL /* nonce */, 0,
-			     0 /* session_attributes */,
+			     TPM2_SA_CONTINUE_SESSION,
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-- 
2.7.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
