From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 2/2] tpm: vtpm_proxy: Implement
	request_locality function.
Date: Wed, 10 May 2017 19:54:22 -0400
Message-ID: <1494460462-29022-3-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1494460462-29022-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1494460462-29022-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Implement the request_locality function. To set the locality on the
backend we define vendor-specific TPM 1.2 and TPM 2 ordinals and send
a command to the backend to set the locality for the next commands.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm.h            |  1 +
 drivers/char/tpm/tpm_vtpm_proxy.c | 34 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/vtpm_proxy.h   |  5 +++++
 3 files changed, 40 insertions(+)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4b4c8de..10f0467 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -527,6 +527,7 @@ enum tpm_transmit_flags {
 	TPM_TRANSMIT_UNLOCKED	= BIT(0),
 };
 
+ssize_t tpm_transfer(struct tpm_chip *chip, u8 *buf, u32 count, size_t bufsiz);
 ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 		     u8 *buf, size_t bufsiz, unsigned int flags);
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 751059d..374c4ff 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -371,6 +371,39 @@ static bool vtpm_proxy_tpm_req_canceled(struct tpm_chip  *chip, u8 status)
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
+	rc = tpm_transfer(chip, buf.data, tpm_buf_length(&buf), PAGE_SIZE);
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
@@ -380,6 +413,7 @@ static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
 	.req_complete_mask = VTPM_PROXY_REQ_COMPLETE_FLAG,
 	.req_complete_val = VTPM_PROXY_REQ_COMPLETE_FLAG,
 	.req_canceled = vtpm_proxy_tpm_req_canceled,
+	.request_locality = vtpm_proxy_request_locality,
 };
 
 /*
diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
index a69e991..6b91c2c 100644
--- a/include/uapi/linux/vtpm_proxy.h
+++ b/include/uapi/linux/vtpm_proxy.h
@@ -46,4 +46,9 @@ struct vtpm_proxy_new_dev {
 
 #define VTPM_PROXY_IOC_NEW_DEV	_IOWR(0xa1, 0x00, struct vtpm_proxy_new_dev)
 
+/* vendor specific commands to set locality */
+#define TPM2_CC_SET_LOCALITY	0x20001000
+#define TPM_ORD_SET_LOCALITY	0x20001000
+
+
 #endif /* _UAPI_LINUX_VTPM_PROXY_H */
-- 
2.4.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
