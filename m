From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH 2/3] tpm: vtpm_proxy: Implement request_locality
Date: Mon, 17 Apr 2017 11:19:30 -0400
Message-ID: <1492442371-30252-3-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1492442371-30252-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1492442371-30252-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
Cc: jgunthorpe@obsidianresearch.com, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Implement the request_locality function. Accept all localties assuming
that the emulator handling the localities will check for a valid locality.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm_vtpm_proxy.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index be0a268..bf59426 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -371,6 +371,11 @@ static bool vtpm_proxy_tpm_req_canceled(struct tpm_chip  *chip, u8 status)
 	return ret;
 }
 
+static int vtpm_proxy_request_locality(struct tpm_chip *chip, int locality)
+{
+	return locality;
+}
+
 static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
 	.flags = TPM_OPS_AUTO_STARTUP,
 	.recv = vtpm_proxy_tpm_op_recv,
@@ -380,6 +385,7 @@ static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
 	.req_complete_mask = VTPM_PROXY_REQ_COMPLETE_FLAG,
 	.req_complete_val = VTPM_PROXY_REQ_COMPLETE_FLAG,
 	.req_canceled = vtpm_proxy_tpm_req_canceled,
+	.request_locality = vtpm_proxy_request_locality,
 };
 
 /*
-- 
2.4.3

