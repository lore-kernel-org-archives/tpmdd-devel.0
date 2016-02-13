From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 1/4] tpm: fix: keep auth session intact after unseal operation
Date: Sat, 13 Feb 2016 15:47:04 +0200
Message-ID: <1455371228-20431-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1455371228-20431-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455371228-20431-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The behavior of policy based unseal operation is not consistent:

* When there is an error in TPM2_Unseal operation, the session object
  stays in the TPM transient memory.
* When the unseal is succesful, the TPM automatically removes the
  session object.

This patch sets the continueSession attribute to keep the session intact
after a successful unseal operation thus making the behavior consistent.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
