From: Alexander Steffen <Alexander.Steffen@infineon.com>
Subject: [PATCH v3] tpm-dev-common: Reject too short writes
Date: Fri, 8 Sep 2017 17:21:32 +0200
Message-ID: <20170908152132.8728-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Alexander Steffen <Alexander.Steffen@infineon.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

tpm_transmit() does not offer an explicit interface to indicate the number
of valid bytes in the communication buffer. Instead, it relies on the
commandSize field in the TPM header that is encoded within the buffer.
Therefore, ensure that a) enough data has been written to the buffer, so
that the commandSize field is present and b) the commandSize field does not
announce more data than has been written to the buffer.

This should have been fixed with CVE-2011-1161 long ago, but apparently
a correct version of that patch never made it into the kernel.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
---
v2:
- Moved all changes to tpm_common_write in a single patch.
v3:
- Access data copied from user space (priv->data_buffer) instead of user
  space data directly (buf).
- Changed return code to EINVAL.

 drivers/char/tpm/tpm-dev-common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index 610638a..461bf0b 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -110,6 +110,12 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
 		return -EFAULT;
 	}
 
+	if (in_size < 6 ||
+	    in_size < be32_to_cpu(*((__be32 *) (priv->data_buffer + 2)))) {
+		mutex_unlock(&priv->buffer_mutex);
+		return -EINVAL;
+	}
+
 	/* atomic tpm command send and result receive. We only hold the ops
 	 * lock during this period so that the tpm can be unregistered even if
 	 * the char dev is held open.
-- 
2.7.4

