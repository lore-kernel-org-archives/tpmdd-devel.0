From: Jerry Snitselaar <jsnitsel@redhat.com>
Subject: [PATCH] tpm_crb: check for bad response size
Date: Fri, 10 Mar 2017 17:46:04 -0700
Message-ID: <20170311004604.4442-1-jsnitsel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jerry Snitselaar <jsnitsel@redhat.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Make sure size of response buffer is at least 6 bytes, or
we will underflow and pass large size_t to memcpy_fromio().
This was encountered while testing earlier version of
locality patchset.

Fixes: 30fc8d138e912 ("tpm: TPM 2.0 CRB Interface")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
 drivers/char/tpm/tpm_crb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 89dc8a176ff1..cda4f312d1c9 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -236,7 +236,7 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	memcpy_fromio(buf, priv->rsp, 6);
 	expected = be32_to_cpup((__be32 *) &buf[2]);
-	if (expected > count)
+	if (expected > count || expected < 6)
 		return -EIO;
 
 	memcpy_fromio(&buf[6], &priv->rsp[6], expected - 6);
-- 
2.11.0.258.ge05806da9
