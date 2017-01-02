From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RFC 4/4] tpm: add the infrastructure for TPM
	space for TPM 2.0
Date: Mon,  2 Jan 2017 15:22:10 +0200
Message-ID: <20170102132213.22880-5-jarkko.sakkinen@linux.intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170102132213.22880-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Added a ioctl for creating a TPM space. The space is isolated from the
other users of the TPM. Only a process holding the file with the handle
can access the objects and only objects that are created through that
file handle can be accessed.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-chip.c      |   7 +
 drivers/char/tpm/tpm-dev.c       |  80 ++++++++++-
 drivers/char/tpm/tpm-interface.c |  61 +++++----
 drivers/char/tpm/tpm-sysfs.c     |   2 +-
 drivers/char/tpm/tpm.h           |  22 ++-
 drivers/char/tpm/tpm2-cmd.c      |  30 ++--
 drivers/char/tpm/tpm2-space.c    | 288 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tpm.h         |  23 ++++
 9 files changed, 470 insertions(+), 45 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2-space.c
 create mode 100644 include/uapi/linux/tpm.h

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index a05b1eb..251d0ed 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -3,7 +3,7 @@
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
-		tpm_eventlog.o
+	 tpm_eventlog.o tpm2-space.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
 tpm-$(CONFIG_OF) += tpm_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 41e518e..468af50 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -129,6 +129,7 @@ static void tpm_dev_release(struct device *dev)
 
 	kfree(chip->log.bios_event_log);
 	kfree(chip->tr_buf.data);
+	kfree(chip->work_space.context_buf);
 	kfree(chip);
 }
 
@@ -197,6 +198,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	}
 	chip->tr_buf.size = TPM_BUFSIZE;
 
+	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!chip->work_space.context_buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
 	return chip;
 
 out:
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 912ad30..139638b 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -19,6 +19,7 @@
  */
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <uapi/linux/tpm.h>
 #include "tpm.h"
 
 struct file_priv {
@@ -32,6 +33,8 @@ struct file_priv {
 	struct work_struct work;
 
 	u8 data_buffer[TPM_BUFSIZE];
+	struct tpm_space space;
+	bool has_space;
 };
 
 static void user_reader_timeout(unsigned long ptr)
@@ -115,6 +118,7 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 			 size_t size, loff_t *off)
 {
 	struct file_priv *priv = file->private_data;
+	struct tpm_space *space = NULL;
 	size_t in_size = size;
 	ssize_t out_size;
 
@@ -130,6 +134,9 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 
 	mutex_lock(&priv->buffer_mutex);
 
+	if (priv->has_space)
+		space = &priv->space;
+
 	if (copy_from_user
 	    (priv->data_buffer, (void __user *) buf, in_size)) {
 		mutex_unlock(&priv->buffer_mutex);
@@ -144,7 +151,7 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 		mutex_unlock(&priv->buffer_mutex);
 		return -EPIPE;
 	}
-	out_size = tpm_transmit(priv->chip, priv->data_buffer,
+	out_size = tpm_transmit(priv->chip, space, priv->data_buffer,
 				sizeof(priv->data_buffer), 0);
 
 	tpm_put_ops(priv->chip);
@@ -162,6 +169,65 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 	return in_size;
 }
 
+/**
+ * tpm_ioc_new_space - handler for %SGX_IOC_NEW_SPACE ioctl
+ *
+ * Creates a new TPM space that can hold a set of transient objects. The space
+ * is isolated with virtual handles that are mapped into physical handles by the
+ * driver.
+ */
+static long tpm_ioc_new_space(struct file *file, unsigned int ioctl,
+			      unsigned long arg)
+{
+	struct file_priv *priv = file->private_data;
+	struct tpm_chip *chip = priv->chip;
+	int rc = 0;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&priv->buffer_mutex);
+
+	if (priv->has_space) {
+		rc = -EBUSY;
+		goto out;
+	}
+
+	priv->space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!priv->space.context_buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* The TPM device can be opened again as this file has been moved to a
+	 * TPM handle space.
+	 */
+	priv->has_space = true;
+	clear_bit(0, &chip->is_open);
+out:
+	mutex_unlock(&priv->buffer_mutex);
+	return rc;
+}
+
+static long tpm_ioctl(struct file *file, unsigned int ioctl,
+		      unsigned long arg)
+{
+	switch (ioctl) {
+	case TPM_IOC_NEW_SPACE:
+		return tpm_ioc_new_space(file, ioctl, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+static long tpm_compat_ioctl(struct file *file, unsigned int ioctl,
+			     unsigned long arg)
+{
+	return tpm_ioctl(file, ioctl, arg);
+}
+#endif
+
 /*
  * Called on file close
  */
@@ -169,6 +235,14 @@ static int tpm_release(struct inode *inode, struct file *file)
 {
 	struct file_priv *priv = file->private_data;
 
+	if (tpm_try_get_ops(priv->chip)) {
+		mutex_unlock(&priv->buffer_mutex);
+		return -EPIPE;
+	}
+	if (priv->has_space)
+		kfree(priv->space.context_buf);
+	tpm_put_ops(priv->chip);
+
 	del_singleshot_timer_sync(&priv->user_read_timer);
 	flush_work(&priv->work);
 	file->private_data = NULL;
@@ -184,6 +258,10 @@ const struct file_operations tpm_fops = {
 	.open = tpm_open,
 	.read = tpm_read,
 	.write = tpm_write,
+	.unlocked_ioctl = tpm_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = tpm_compat_ioctl,
+#endif
 	.release = tpm_release,
 };
 
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 0794a5d3..a1ae57e 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -370,10 +370,11 @@ static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
  *     0 when the operation is successful.
  *     A negative number for system errors (errno).
  */
-ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
-		     unsigned int flags)
+ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
+		     u8 *buf, size_t bufsiz, unsigned int flags)
 {
-	ssize_t rc;
+	int rc;
+	ssize_t len = 0;
 	u32 count, ordinal;
 	unsigned long stop;
 
@@ -399,10 +400,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	if (chip->dev.parent)
 		pm_runtime_get_sync(chip->dev.parent);
 
+	rc = tpm2_prepare_space(chip, space, ordinal, buf, bufsiz);
+	if (rc)
+		goto out;
+
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
 		dev_err(&chip->dev,
-			"tpm_transmit: tpm_send: error %zd\n", rc);
+			"tpm_transmit: tpm_send: error %d\n", rc);
 		goto out;
 	}
 
@@ -435,17 +440,23 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	goto out;
 
 out_recv:
-	rc = chip->ops->recv(chip, (u8 *) buf, bufsiz);
-	if (rc < 0)
+	len = chip->ops->recv(chip, (u8 *) buf, bufsiz);
+	if (len < 0) {
 		dev_err(&chip->dev,
-			"tpm_transmit: tpm_recv: error %zd\n", rc);
+			"tpm_transmit: tpm_recv: error %d\n", rc);
+		rc = len;
+		goto out;
+	}
+
+	rc = tpm2_commit_space(chip, space, ordinal, buf, bufsiz);
+
 out:
 	if (chip->dev.parent)
 		pm_runtime_put_sync(chip->dev.parent);
 
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_unlock(&chip->tpm_mutex);
-	return rc;
+	return rc ? rc : len;
 }
 
 /**
@@ -463,13 +474,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
  *     A negative number for system errors (errno).
  *     A positive number for a TPM error.
  */
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
-			 int len, unsigned int flags, const char *desc)
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
+			 void *cmd, int len, unsigned int flags,
+			 const char *desc)
 {
 	const struct tpm_output_header *header;
 	int err;
 
-	len = tpm_transmit(chip, (const u8 *)cmd, len, flags);
+	len = tpm_transmit(chip, space, cmd, len, flags);
 	if (len <  0)
 		return len;
 	else if (len < TPM_HEADER_SIZE)
@@ -521,7 +533,7 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
 	}
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
+	rc = tpm_transmit_cmd(chip, NULL, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
 			      desc);
 	if (!rc)
 		*cap = tpm_cmd.params.getcap_out.cap;
@@ -545,8 +557,9 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 	start_cmd.header.in = tpm_startup_header;
 
 	start_cmd.params.startup_in.startup_type = startup_type;
-	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
-				"attempting to start the TPM");
+	return tpm_transmit_cmd(chip, NULL, &start_cmd,
+				TPM_INTERNAL_RESULT_SIZE,
+				0, "attempting to start the TPM");
 }
 
 int tpm_get_timeouts(struct tpm_chip *chip)
@@ -684,8 +697,8 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	struct tpm_cmd_t cmd;
 
 	cmd.header.in = continue_selftest_header;
-	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE, 0,
-			      "continue selftest");
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
+			      0, "continue selftest");
 	return rc;
 }
 
@@ -704,7 +717,7 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE, 0,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, READ_PCR_RESULT_SIZE, 0,
 			      "attempting to read a pcr value");
 
 	if (rc == 0)
@@ -802,7 +815,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
 			      "attempting extend a PCR value");
 
 	tpm_put_ops(chip);
@@ -906,7 +919,7 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 	if (chip == NULL)
 		return -ENODEV;
 
-	rc = tpm_transmit_cmd(chip, cmd, buflen, 0, "attempting tpm_cmd");
+	rc = tpm_transmit_cmd(chip, NULL, cmd, buflen, 0, "attempting tpm_cmd");
 
 	tpm_put_ops(chip);
 	return rc;
@@ -1008,15 +1021,15 @@ int tpm_pm_suspend(struct device *dev)
 		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
 		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
 		       TPM_DIGEST_SIZE);
-		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
-				      "extending dummy pcr before suspend");
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
+				      0, "extending dummy pcr before suspend");
 	}
 
 	/* now do the actual savestate */
 	for (try = 0; try < TPM_RETRY; try++) {
 		cmd.header.in = savestate_header;
-		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, 0,
-				      NULL);
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, SAVESTATE_RESULT_SIZE,
+				      0, NULL);
 
 		/*
 		 * If the TPM indicates that it is too busy to respond to
@@ -1099,7 +1112,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		tpm_cmd.header.in = tpm_getrandom_header;
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
 
-		err = tpm_transmit_cmd(chip, &tpm_cmd,
+		err = tpm_transmit_cmd(chip, NULL, &tpm_cmd,
 				       TPM_GETRANDOM_RESULT_SIZE + num_bytes,
 				       0, "attempting get random");
 		if (err)
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 848ad65..dd31a00 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -39,7 +39,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
-	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE, 0,
+	err = tpm_transmit_cmd(chip, NULL, &tpm_cmd, READ_PUBEK_RESULT_SIZE, 0,
 			       "attempting to read the PUBEK");
 	if (err)
 		goto out;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index fb02b57..c6171e5 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -91,6 +91,7 @@ enum tpm2_structures {
 
 enum tpm2_return_codes {
 	TPM2_RC_HASH		= 0x0083, /* RC_FMT1 */
+	TPM2_RC_HANDLE		= 0x008B,
 	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
 	TPM2_RC_DISABLED	= 0x0120,
 	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
@@ -114,6 +115,8 @@ enum tpm2_command_codes {
 	TPM2_CC_CREATE		= 0x0153,
 	TPM2_CC_LOAD		= 0x0157,
 	TPM2_CC_UNSEAL		= 0x015E,
+	TPM2_CC_CONTEXT_LOAD	= 0x0161,
+	TPM2_CC_CONTEXT_SAVE	= 0x0162,
 	TPM2_CC_FLUSH_CONTEXT	= 0x0165,
 	TPM2_CC_GET_CAPABILITY	= 0x017A,
 	TPM2_CC_GET_RANDOM	= 0x017B,
@@ -151,6 +154,11 @@ enum tpm2_cc_attrs {
 
 #define TPM_PPI_VERSION_LEN		3
 
+struct tpm_space {
+	u32 context_tbl[14];
+	u8 *context_buf;
+};
+
 enum tpm_chip_flags {
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
 	TPM_CHIP_FLAG_IRQ		= BIT(2),
@@ -217,6 +225,7 @@ struct tpm_chip {
 #endif /* CONFIG_ACPI */
 
 	struct tpm_buf tr_buf;
+	struct tpm_space work_space;
 	u32 nr_commands;
 	u32 *cc_attrs_tbl;
 };
@@ -492,10 +501,11 @@ enum tpm_transmit_flags {
 	TPM_TRANSMIT_UNLOCKED	= BIT(0),
 };
 
-ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
-		     unsigned int flags);
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, int len,
-			 unsigned int flags, const char *desc);
+ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
+		     u8 *buf, size_t bufsiz, unsigned int flags);
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
+			 void *cmd, int len, unsigned int flags,
+			 const char *desc);
 ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		   const char *desc);
 int tpm_get_timeouts(struct tpm_chip *);
@@ -549,4 +559,8 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
 bool tpm2_find_cc_attrs(struct tpm_chip *chip, u32 cc, u32 *attrs);
+int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
+		       u32 cc, u8 *buf, size_t bufsiz);
+int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
+		      u32 cc, u8 *buf, size_t bufsiz);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 311dc8e..abaa355 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -280,7 +280,7 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	       sizeof(cmd.params.pcrread_in.pcr_select));
 	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0,
 			      "attempting to read a pcr value");
 	if (rc == 0) {
 		buf = cmd.params.pcrread_out.digest;
@@ -327,7 +327,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
 	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
 	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0,
 			      "attempting extend a PCR value");
 
 	return rc;
@@ -373,7 +373,7 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 		cmd.header.in = tpm2_getrandom_header;
 		cmd.params.getrandom_in.size = cpu_to_be16(num_bytes);
 
-		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
+		err = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0,
 				       "attempting get random");
 		if (err)
 			break;
@@ -416,7 +416,7 @@ void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
 	tpm_buf_init(&chip->tr_buf, TPM2_ST_NO_SESSIONS, TPM2_CC_FLUSH_CONTEXT);
 	tpm_buf_append_u32(&chip->tr_buf, handle);
 
-	rc = tpm_transmit_cmd(chip, chip->tr_buf.data, TPM_BUFSIZE, flags,
+	rc = tpm_transmit_cmd(chip, NULL, chip->tr_buf.data, TPM_BUFSIZE, flags,
 			      "flushing context");
 	if (rc)
 		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
@@ -529,7 +529,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (chip->tr_buf.flags & TPM_BUF_OVERFLOW)
 		return -E2BIG;
 
-	rc = tpm_transmit_cmd(chip, &chip->tr_buf, TPM_BUFSIZE, 0,
+	rc = tpm_transmit_cmd(chip, NULL, &chip->tr_buf, TPM_BUFSIZE, 0,
 			      "sealing data");
 	if (rc)
 		return rc;
@@ -599,7 +599,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (chip->tr_buf.flags & TPM_BUF_OVERFLOW)
 		return -E2BIG;
 
-	rc = tpm_transmit_cmd(chip, &chip->tr_buf, TPM_BUFSIZE, flags,
+	rc = tpm_transmit_cmd(chip, NULL, &chip->tr_buf, TPM_BUFSIZE, flags,
 			      "loading blob");
 	if (!rc)
 		*blob_handle = be32_to_cpup(
@@ -644,7 +644,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, chip->tr_buf.data, TPM_BUFSIZE, flags,
+	rc = tpm_transmit_cmd(chip, NULL, chip->tr_buf.data, TPM_BUFSIZE, flags,
 			      "unsealing");
 	if (rc > 0)
 		rc = -EPERM;
@@ -712,7 +712,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(property_id);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, desc);
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, desc);
 	if (!rc)
 		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);
 
@@ -746,7 +746,7 @@ static int tpm2_startup(struct tpm_chip *chip, u16 startup_type)
 	cmd.header.in = tpm2_startup_header;
 
 	cmd.params.startup_in.startup_type = cpu_to_be16(startup_type);
-	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
+	return tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0,
 				"attempting to start the TPM");
 }
 
@@ -775,7 +775,8 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
 	cmd.header.in = tpm2_shutdown_header;
 	cmd.params.startup_in.startup_type = cpu_to_be16(shutdown_type);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, "stopping the TPM");
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0,
+			      "stopping the TPM");
 
 	/* In places where shutdown command is sent there's no much we can do
 	 * except print the error code on a system failure.
@@ -838,7 +839,7 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
 	cmd.header.in = tpm2_selftest_header;
 	cmd.params.selftest_in.full_test = full;
 
-	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE, 0,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, TPM2_SELF_TEST_IN_SIZE, 0,
 			      "continue selftest");
 
 	/* At least some prototype chips seem to give RC_TESTING error
@@ -889,7 +890,7 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 		cmd.params.pcrread_in.pcr_select[1] = 0x00;
 		cmd.params.pcrread_in.pcr_select[2] = 0x00;
 
-		rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, NULL);
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, NULL);
 		if (rc < 0)
 			break;
 
@@ -922,7 +923,7 @@ int tpm2_probe(struct tpm_chip *chip)
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),  0, NULL);
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),  0, NULL);
 	if (rc <  0)
 		return rc;
 
@@ -981,7 +982,8 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 	tpm_buf_append_u32(&chip->tr_buf, TPM2_CC_FIRST);
 	tpm_buf_append_u32(&chip->tr_buf, nr_commands);
 
-	rc = tpm_transmit_cmd(chip, chip->tr_buf.data, TPM_BUFSIZE, 0, NULL);
+	rc = tpm_transmit_cmd(chip, NULL, chip->tr_buf.data, TPM_BUFSIZE, 0,
+			      NULL);
 	if (rc < 0)
 		goto out;
 
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
new file mode 100644
index 0000000..12a84e6
--- /dev/null
+++ b/drivers/char/tpm/tpm2-space.c
@@ -0,0 +1,288 @@
+/*
+ * Copyright (C) 2016 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+ *
+ * This file contains TPM2 protocol implementations of the commands
+ * used by the kernel internally.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/gfp.h>
+#include "tpm.h"
+
+enum tpm2_handle_types {
+	TPM2_HT_HMAC_SESSION	= 0x02000000,
+	TPM2_HT_POLICY_SESSION	= 0x03000000,
+	TPM2_HT_TRANSIENT	= 0x80000000,
+};
+
+static void tpm2_flush_space(struct tpm_chip *chip)
+{
+	struct tpm_space *space = &chip->work_space;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++)
+		if (space->context_tbl[i] && ~space->context_tbl[i])
+			tpm2_flush_context_cmd(chip, space->context_tbl[i],
+					       TPM_TRANSMIT_UNLOCKED);
+}
+
+struct tpm2_context {
+	__be64 sequence;
+	__be32 saved_handle;
+	__be32 hierarchy;
+	__be16 blob_size;
+} __packed;
+
+static int tpm2_load_space(struct tpm_chip *chip)
+{
+	struct tpm_space *space = &chip->work_space;
+	struct tpm2_context *ctx;
+	int i;
+	int j;
+	int rc;
+	u32 s;
+
+	for (i = 0, j = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		if (!space->context_tbl[i])
+			continue;
+
+		/* sanity check, should never happen */
+		if (~space->context_tbl[i]) {
+			dev_err(&chip->dev, "context table is inconsistent");
+			return -EFAULT;
+		}
+
+		tpm_buf_init(&chip->tr_buf, TPM2_ST_NO_SESSIONS,
+			     TPM2_CC_CONTEXT_LOAD);
+
+		ctx = (struct tpm2_context *)&space->context_buf[j];
+		s = sizeof(*ctx) + be16_to_cpu(ctx->blob_size);
+		tpm_buf_append(&chip->tr_buf, &space->context_buf[j], s);
+
+		rc = tpm_transmit_cmd(chip, NULL, chip->tr_buf.data, PAGE_SIZE,
+				      TPM_TRANSMIT_UNLOCKED, NULL);
+		if (rc) {
+			dev_warn(&chip->dev, "%s: loading failed with %d\n",
+				 __func__, rc);
+			rc = -EFAULT;
+			goto out_err;
+		}
+
+		space->context_tbl[i] =
+			be32_to_cpup(
+				(__be32 *)&chip->tr_buf.data[TPM_HEADER_SIZE]);
+
+		j += s;
+	}
+
+	return 0;
+
+out_err:
+	tpm2_flush_space(chip);
+	return rc;
+}
+
+static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd, size_t len)
+{
+	struct tpm_space *space = &chip->work_space;
+	unsigned int nr_handles;
+	u32 vhandle;
+	u32 phandle;
+	u32 attrs;
+	int i;
+	int j;
+	int rc;
+
+	if (!tpm2_find_cc_attrs(chip, cc, &attrs)) {
+		rc = -EINVAL;
+		goto out_err;
+	}
+
+	nr_handles = (attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0);
+
+	for (i = 0; i < nr_handles; i++) {
+		vhandle = be32_to_cpup((__be32 *)&cmd[TPM_HEADER_SIZE + 4 * i]);
+		if ((vhandle & 0xFF000000) != TPM2_HT_TRANSIENT)
+			continue;
+
+		j = 0xFFFFFF - (vhandle & 0xFFFFFF);
+		if (j > ARRAY_SIZE(space->context_tbl) ||
+		    !space->context_tbl[j]) {
+			rc = -EINVAL;
+			goto out_err;
+		}
+
+		phandle = space->context_tbl[j];
+		*((__be32 *)&cmd[TPM_HEADER_SIZE + 4 * i]) =
+			cpu_to_be32(phandle);
+	}
+
+	return 0;
+
+out_err:
+	tpm2_flush_space(chip);
+	return rc;
+}
+
+int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
+		       u32 cc, u8 *buf, size_t bufsiz)
+{
+	int rc;
+
+	if (!space)
+		return 0;
+
+	memcpy(&chip->work_space.context_tbl, &space->context_tbl,
+	       sizeof(space->context_tbl));
+	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
+
+	rc = tpm2_load_space(chip);
+	if (rc)
+		return rc;
+
+	rc = tpm2_map_command(chip, cc, buf, bufsiz);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
+{
+	struct tpm_space *space = &chip->work_space;
+	u32 phandle;
+	u32 vhandle;
+	u32 attrs;
+	int i;
+	int rc;
+
+	if (!tpm2_find_cc_attrs(chip, cc, &attrs)) {
+		/* should never happen */
+		dev_err(&chip->dev, "TPM returned a different CC: 0x%04x\n",
+			cc);
+		rc = -EFAULT;
+		goto out_err;
+	}
+
+	if (!((attrs >> TPM2_CC_ATTR_RHANDLE) & 1))
+		return 0;
+
+	phandle = be32_to_cpup((__be32 *)&rsp[TPM_HEADER_SIZE]);
+	if ((phandle & 0xFF000000) != TPM2_HT_TRANSIENT)
+		return 0;
+
+	/* Garbage collect a dead context. */
+	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		if (space->context_tbl[i] == phandle) {
+			space->context_tbl[i] = 0;
+			break;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++)
+		if (!space->context_tbl[i])
+			break;
+
+	if (i == ARRAY_SIZE(space->context_tbl)) {
+		dev_warn(&chip->dev, "%s: out of context slots\n", __func__);
+		tpm2_flush_context_cmd(chip, phandle, TPM_TRANSMIT_UNLOCKED);
+		rc = -ENOMEM;
+		goto out_err;
+	}
+
+	space->context_tbl[i] = phandle;
+	vhandle = TPM2_HT_TRANSIENT | (0xFFFFFF - i);
+	*(__be32 *)&rsp[TPM_HEADER_SIZE] = cpu_to_be32(vhandle);
+
+	return 0;
+
+out_err:
+	tpm2_flush_space(chip);
+	return rc;
+}
+
+static int tpm2_save_space(struct tpm_chip *chip)
+{
+	struct tpm_space *space = &chip->work_space;
+	int i;
+	int j;
+	int rc;
+	u32 s;
+
+	for (i = 0, j = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		if (!(space->context_tbl[i] && ~space->context_tbl[i]))
+			continue;
+
+		tpm_buf_init(&chip->tr_buf, TPM2_ST_NO_SESSIONS,
+			     TPM2_CC_CONTEXT_SAVE);
+		tpm_buf_append_u32(&chip->tr_buf, space->context_tbl[i]);
+
+		rc = tpm_transmit_cmd(chip, NULL, chip->tr_buf.data, PAGE_SIZE,
+				      TPM_TRANSMIT_UNLOCKED, NULL);
+		if ((rc & TPM2_RC_HANDLE) == TPM2_RC_HANDLE) {
+			space->context_tbl[i] = 0;
+			continue;
+		} else if (rc) {
+			dev_warn(&chip->dev, "%s: saving failed with %d\n",
+				 __func__, rc);
+			rc = -EFAULT;
+			goto out_err;
+		}
+
+		s = tpm_buf_length(&chip->tr_buf) - TPM_HEADER_SIZE;
+		if ((j + s) > PAGE_SIZE) {
+			dev_warn(&chip->dev, "%s: out of backing storage\n",
+				 __func__);
+			rc = -ENOMEM;
+			goto out_err;
+		}
+
+		memcpy(&space->context_buf[j],
+		       &chip->tr_buf.data[TPM_HEADER_SIZE], s);
+
+		tpm2_flush_context_cmd(chip, space->context_tbl[i],
+				       TPM_TRANSMIT_UNLOCKED);
+
+		space->context_tbl[i] = ~0;
+
+		j += s;
+	}
+
+	return 0;
+
+out_err:
+	tpm2_flush_space(chip);
+	return rc;
+}
+
+int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
+		      u32 cc, u8 *buf, size_t bufsiz)
+{
+	int rc;
+
+	if (!space)
+		return 0;
+
+	rc = tpm2_map_response(chip, cc, buf, bufsiz);
+	if (rc)
+		return rc;
+
+	rc = tpm2_save_space(chip);
+	if (rc)
+		return rc;
+
+	memcpy(&space->context_tbl, &chip->work_space.context_tbl,
+	       sizeof(space->context_tbl));
+	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
+
+	return 0;
+}
diff --git a/include/uapi/linux/tpm.h b/include/uapi/linux/tpm.h
new file mode 100644
index 0000000..1df5b61
--- /dev/null
+++ b/include/uapi/linux/tpm.h
@@ -0,0 +1,23 @@
+/*
+ * API and definitions for the TPM device driver
+ * Copyright (C) 2016 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#ifndef _UAPI_TPM_H
+#define _UAPI_TPM_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define TPM_IOC_MAGIC 0xa2
+#define TPM_IOC_NEW_SPACE _IO(TPM_IOC_MAGIC, 0x00)
+
+#endif /* _UAPI_TPM_H */
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
