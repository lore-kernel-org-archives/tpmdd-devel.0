From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH 1/3] tpm: vtpm_proxy: Add ioctl to get supported flags
Date: Mon, 17 Apr 2017 11:19:29 -0400
Message-ID: <1492442371-30252-2-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1492442371-30252-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1492442371-30252-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
Cc: jgunthorpe@obsidianresearch.com, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Add an ioctl to get the supported flags.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm_vtpm_proxy.c | 32 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vtpm_proxy.h   | 11 +++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 751059d..be0a268 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -592,6 +592,36 @@ static long vtpmx_ioc_new_dev(struct file *file, unsigned int ioctl,
 	return 0;
 }
 
+/**
+ * vtpmx_ioc_get_supt_flags - handler for the %VTPM_PROXY_IOC_GET_SUPT_FLAGS
+ *                            ioctl
+ * @file:	/dev/vtpmx
+ * @ioctl:	the ioctl number
+ * @arg:	pointer to the struct vtpmx_proxy_get_supt_flags
+ *
+ * Return the bitfield of supported flags
+ */
+static long vtpmx_ioc_get_supt_flags(struct file *file, unsigned int ioctl,
+				     unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct vtpm_proxy_supt_flags __user *vtpm_supt_flags_p;
+	struct vtpm_proxy_supt_flags flags = {
+		.flags = VTPM_PROXY_FLAGS_ALL,
+	};
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	vtpm_supt_flags_p = argp;
+
+	if (copy_to_user(vtpm_supt_flags_p, &flags,
+			 sizeof(flags)))
+		return -EFAULT;
+
+	return 0;
+}
+
 /*
  * vtpmx_fops_ioctl: ioctl on /dev/vtpmx
  *
@@ -604,6 +634,8 @@ static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
 	switch (ioctl) {
 	case VTPM_PROXY_IOC_NEW_DEV:
 		return vtpmx_ioc_new_dev(f, ioctl, arg);
+	case VTPM_PROXY_IOC_GET_SUPT_FLAGS:
+		return vtpmx_ioc_get_supt_flags(f, ioctl, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
index a69e991..83e64e7 100644
--- a/include/uapi/linux/vtpm_proxy.h
+++ b/include/uapi/linux/vtpm_proxy.h
@@ -44,6 +44,17 @@ struct vtpm_proxy_new_dev {
 	__u32 minor;         /* output */
 };
 
+/**
+ * struct vtpm_proxy_supt_flags - parameter structure for the
+ *                                %VTPM_PROXY_IOC_GET_SUPT_FLAGS ioctl
+ * @flags: flags supported by the vtpm proxy driver
+ */
+struct vtpm_proxy_supt_flags {
+	__u32 flags;         /* output */
+};
+
 #define VTPM_PROXY_IOC_NEW_DEV	_IOWR(0xa1, 0x00, struct vtpm_proxy_new_dev)
+#define VTPM_PROXY_IOC_GET_SUPT_FLAGS \
+				_IOR(0xa1, 0x01, struct vtpm_proxy_supt_flags)
 
 #endif /* _UAPI_LINUX_VTPM_PROXY_H */
-- 
2.4.3

