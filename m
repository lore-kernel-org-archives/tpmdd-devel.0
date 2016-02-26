From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix: set continueSession attribute for the unseal operation (resend for stable)
Date: Fri, 26 Feb 2016 11:08:02 +0200
Message-ID: <1456477682-7191-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

It's better to set the continueSession attribute for the unseal
operation so that the session object is not removed as a side-effect
when the operation is successful. Since a user process created the
session, it should be also decide when the session is destroyed.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Fixes: 5beb0c435b ("keys, trusted: seal with a TPM2 authorization policy")
CC: stable@vger.kernel.org
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
