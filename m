From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v5 2/2] tpm: vtpm_proxy: Implement request_locality function.
Date: Mon, 15 May 2017 12:51:45 -0400
Message-ID: <1494867105-30722-3-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1494867105-30722-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494867105-30722-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com
Cc: jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Implement the request_locality function. To set the locality on the
backend we define vendor-specific TPM 1.2 and TPM 2 ordinals and send
a command to the backend to set the locality for the next commands.

To avoid recursing into requesting the locality, we set the
TPM_TRASNMIT_RAW flag when calling tpm_trasnmit_cmd. To avoid recursing
into TPM 2 space related commands, we set the space parameter to NULL.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm-interface.c  |  1 +
 drivers/char/tpm/tpm_vtpm_proxy.c | 36 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vtpm_proxy.h   |  4 ++++
 3 files changed, 41 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 2eacda2..876d45f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -537,6 +537,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(tpm_transmit_cmd);
 
 #define TPM_DIGEST_SIZE 20
 #define TPM_RET_CODE_IDX 6
diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 751059d..66024bf 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -371,6 +371,41 @@ static bool vtpm_proxy_tpm_req_canceled(struct tpm_chip  *chip, u8 status)
 	return ret;
 }
 
+static int vtpm_proxy_request_locality(struct tpm_chip *chip, int locality)
+{
+	struct tpm_buf buf;
+	int rc;
+	const struct tpm_output_header *header;
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS,
+				  TPM2_CC_SET_LOCALITY);
+	else
+		rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND,
+				  TPM_ORD_SET_LOCALITY);
+	if (rc)
+		return rc;
+	tpm_buf_append_u8(&buf, locality);
+
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, tpm_buf_length(&buf), 0,
+			      TPM_TRANSMIT_UNLOCKED | TPM_TRANSMIT_RAW,
+			      "attempting to set locality");
+	if (rc < 0) {
+		locality = rc;
+		goto out;
+	}
+
+	header = (const struct tpm_output_header *)buf.data;
+	rc = be32_to_cpu(header->return_code);
+	if (rc)
+		locality = -1;
+
+out:
+	tpm_buf_destroy(&buf);
+
+	return locality;
+}
+
 static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
 	.flags = TPM_OPS_AUTO_STARTUP,
 	.recv = vtpm_proxy_tpm_op_recv,
@@ -380,6 +415,7 @@ static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
 	.req_complete_mask = VTPM_PROXY_REQ_COMPLETE_FLAG,
 	.req_complete_val = VTPM_PROXY_REQ_COMPLETE_FLAG,
 	.req_canceled = vtpm_proxy_tpm_req_canceled,
+	.request_locality = vtpm_proxy_request_locality,
 };
 
 /*
diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
index a69e991..58ac73c 100644
--- a/include/uapi/linux/vtpm_proxy.h
+++ b/include/uapi/linux/vtpm_proxy.h
@@ -46,4 +46,8 @@ struct vtpm_proxy_new_dev {
 
 #define VTPM_PROXY_IOC_NEW_DEV	_IOWR(0xa1, 0x00, struct vtpm_proxy_new_dev)
 
+/* vendor specific commands to set locality */
+#define TPM2_CC_SET_LOCALITY	0x20001000
+#define TPM_ORD_SET_LOCALITY	0x20001000
+
 #endif /* _UAPI_LINUX_VTPM_PROXY_H */
-- 
2.4.3
