From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2 1/3] tpm: vtpm_proxy: Add ioctl to get
	supported flags
Date: Fri, 28 Apr 2017 09:02:16 -0400
Message-ID: <1493384538-27883-2-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1493384538-27883-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1493384538-27883-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Add an ioctl to get the supported flags.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm_vtpm_proxy.c | 29 +++++++++++++++++++++++++++++
 include/uapi/linux/vtpm_proxy.h   | 11 +++++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 751059d..fb4d207 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -592,6 +592,33 @@ static long vtpmx_ioc_new_dev(struct file *file, unsigned int ioctl,
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
+	struct vtpm_proxy_supt_flags __user *vtpm_supt_flags_p = argp;
+	struct vtpm_proxy_supt_flags flags = {
+		.flags = VTPM_PROXY_FLAGS_ALL,
+	};
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_to_user(vtpm_supt_flags_p, &flags, sizeof(flags)))
+		return -EFAULT;
+
+	return 0;
+}
+
 /*
  * vtpmx_fops_ioctl: ioctl on /dev/vtpmx
  *
@@ -604,6 +631,8 @@ static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
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


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
