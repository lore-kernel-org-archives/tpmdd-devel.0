From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v3 3/3] tpm: vtpm_proxy: Add flag for ioctl to request locality prepended to command
Date: Thu,  4 May 2017 10:56:27 -0400
Message-ID: <1493909787-1848-4-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1493909787-1848-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1493909787-1848-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com
Cc: jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

For some TPM commands it is necessary that a TPM emulator knows the
locality in which the command is executed. To support conveying the
locality to the emulator, we implement a flag
VTPM_PROXY_FLAG_PREPEND_LOCALITY for the vtpm_proxy driver's
VTPM_PROXY_IOC_NEW_DEV ioctl to request that the locality be prepended
to every TPM command. This flag is also set in the
VTPM_PROXY_IOC_GET_SUPT_FLAGS ioctl's flags field to indicate that this
feature is supported in this version of the driver.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm_vtpm_proxy.c | 18 ++++++++++++++----
 include/uapi/linux/vtpm_proxy.h   |  6 ++++--
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 48b9818..e45dd33 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -52,7 +52,8 @@ struct proxy_dev {
 };
 
 /* all supported flags */
-#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2)
+#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2 | \
+			       VTPM_PROXY_FLAG_PREPEND_LOCALITY)
 
 static struct workqueue_struct *workqueue;
 
@@ -78,7 +79,10 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
 {
 	struct proxy_dev *proxy_dev = filp->private_data;
 	size_t len;
-	int sig, rc;
+	int sig;
+	int rc = 0;
+	size_t offset = 0;
+	uint8_t locality;
 
 	sig = wait_event_interruptible(proxy_dev->wq,
 		proxy_dev->req_len != 0 ||
@@ -102,7 +106,13 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
 		return -EIO;
 	}
 
-	rc = copy_to_user(buf, proxy_dev->buffer, len);
+	if (proxy_dev->flags & VTPM_PROXY_FLAG_PREPEND_LOCALITY) {
+		locality = proxy_dev->chip->locality;
+		offset = sizeof(locality);
+		rc = copy_to_user(buf, &locality, offset);
+	}
+	if (!rc)
+		rc = copy_to_user(&buf[offset], proxy_dev->buffer, len);
 	memset(proxy_dev->buffer, 0, len);
 	proxy_dev->req_len = 0;
 
@@ -114,7 +124,7 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
 	if (rc)
 		return -EFAULT;
 
-	return len;
+	return offset + len;
 }
 
 /**
diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
index 83e64e7..ce76f0c 100644
--- a/include/uapi/linux/vtpm_proxy.h
+++ b/include/uapi/linux/vtpm_proxy.h
@@ -21,10 +21,12 @@
 
 /**
  * enum vtpm_proxy_flags - flags for the proxy TPM
- * @VTPM_PROXY_FLAG_TPM2:	the proxy TPM uses TPM 2.0 protocol
+ * @VTPM_PROXY_FLAG_TPM2:		the proxy TPM uses TPM 2.0 protocol
+ * @VTPM_PROXY_FLAG_PREPEND_LOCALITY:	locality byte prepended on each command
  */
 enum vtpm_proxy_flags {
-	VTPM_PROXY_FLAG_TPM2	= 1,
+	VTPM_PROXY_FLAG_TPM2			= 1,
+	VTPM_PROXY_FLAG_PREPEND_LOCALITY	= 2,
 };
 
 /**
-- 
2.4.3

