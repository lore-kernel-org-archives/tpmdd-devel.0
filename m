From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH 05/10] tpm: tpm2_seal_trusted: check size of response before accessing data
Date: Tue, 10 Jan 2017 09:18:15 -0500
Message-ID: <1484057900-17871-5-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Check the size of the response before accessing data in the
response packet. This is to avoid accessing data beyond the
end of the response.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm2-cmd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 1e704a1..57bb774 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -464,7 +464,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 {
 	unsigned int blob_len;
 	struct tpm_buf buf;
-	u32 hash;
+	u32 hash, rlength;
 	int i;
 	int rc;
 
@@ -533,11 +533,21 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (rc)
 		goto out;
 
+	rlength = be32_to_cpu(((struct tpm2_cmd*)&buf)->header.out.length);
+	if (rlength < TPM_HEADER_SIZE + 4) {
+		rc = -EFAULT;
+		goto out;
+	}
+
 	blob_len = be32_to_cpup((__be32 *) &buf.data[TPM_HEADER_SIZE]);
 	if (blob_len > MAX_BLOB_SIZE) {
 		rc = -E2BIG;
 		goto out;
 	}
+	if (rlength < TPM_HEADER_SIZE + 4 + blob_len) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	memcpy(payload->blob, &buf.data[TPM_HEADER_SIZE + 4], blob_len);
 	payload->blob_len = blob_len;
-- 
2.4.3

