From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/23] TPM: Consolidate tpm_send(),
 transmit_cmd() and tpm_transmit()
Date: Tue, 21 Aug 2018 16:57:36 +0100
Message-ID: <153486705643.13066.12702787911194407998.stgit@warthog.procyon.org.uk>
References: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <153486700916.13066.12870860668352070081.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


---

 drivers/char/tpm/tpm-dev.c       |   17 ++--
 drivers/char/tpm/tpm-interface.c |  171 +++++++++++++++++++-------------------
 drivers/char/tpm/tpm-sysfs.c     |   23 -----
 drivers/char/tpm/tpm.h           |    8 +-
 include/linux/tpm.h              |    7 +-
 security/keys/trusted.c          |   16 ++--
 6 files changed, 117 insertions(+), 125 deletions(-)

diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index d9b774e02a1f..6809c2791276 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -32,7 +32,10 @@ struct file_priv {
 	struct timer_list user_read_timer;      /* user needs to claim result */
 	struct work_struct work;
 
-	u8 data_buffer[TPM_BUFSIZE];
+	union {
+		u8 data_buffer[TPM_BUFSIZE];
+		struct tpm_output_header reply;
+	};
 };
 
 static void user_reader_timeout(unsigned long ptr)
@@ -119,7 +122,7 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 {
 	struct file_priv *priv = file->private_data;
 	size_t in_size = size;
-	ssize_t out_size;
+	long rc;
 
 	/* cannot perform a write until the read has cleared
 	   either via tpm_read or a user_read_timer timeout.
@@ -140,14 +143,14 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 	}
 
 	/* atomic tpm command send and result receive */
-	out_size = tpm_transmit(priv->chip, priv->data_buffer,
-				sizeof(priv->data_buffer));
-	if (out_size < 0) {
+	rc = tpm_send_command(priv->chip, priv->data_buffer,
+			      sizeof(priv->data_buffer), NULL);
+	if (rc < 0) {
 		mutex_unlock(&priv->buffer_mutex);
-		return out_size;
+		return rc;
 	}
 
-	atomic_set(&priv->data_pending, out_size);
+	atomic_set(&priv->data_pending, be32_to_cpu(priv->reply.length));
 	mutex_unlock(&priv->buffer_mutex);
 
 	/* Set a timeout by which the reader must come claim the result */
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 9add6034c252..e90f9d2dfaf2 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -329,13 +329,34 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
-/*
- * Internal kernel interface to transmit TPM commands
+/**
+ * tpm_send_command - Send a command to the TPM and receive the reply
+ * @chip: The TPM to communicate with
+ * @buf: The command and reply buffer
+ * @bufsiz: The maximum amount of space in buffer for the reply
+ * @desc: Info about the command being performed for printing purposes (or NULL)
+ *
+ * This function sends a command to the TPM and then receives the reply.  The
+ * command must be in the buffer on entry, with the length of the command
+ * indicated by the command header in the buffer.
+ *
+ * The reply is read into the buffer, overwriting the command, up to a maximum
+ * length of bufsiz.
+ *
+ * If the TPM reports an error, desc is used to fabricate an error message.
+ *
+ * This function returns 0 on success, a negative kernel error code or a
+ * positive TPM error code on failure.
+ *
+ * In the case that success or a TPM error code is returned, the buffer is
+ * guaranteed to contain at least a valid reply header.  The length of the
+ * reply is contained in the reply header.
  */
-ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-		     size_t bufsiz)
+long tpm_send_command(struct tpm_chip *chip, void *buf, size_t bufsiz,
+		      const char *desc)
 {
-	ssize_t rc;
+	struct tpm_output_header *reply;
+	long rc;
 	u32 count, ordinal;
 	unsigned long stop;
 
@@ -393,29 +414,30 @@ out_recv:
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
 	mutex_unlock(&chip->tpm_mutex);
+	if (rc < 0)
+		return rc;
+
+	/* The transmission apparently worked.  Sanity check the reply and
+	 * extract the return code.
+	 */
+	if (rc < TPM_HEADER_SIZE)
+		return -EIO;
+	reply = buf;
+
+	rc = be32_to_cpu(reply->length);
+	if (rc < TPM_HEADER_SIZE || rc > bufsiz)
+		return -EIO;
+
+	rc = be32_to_cpu(reply->return_code);
+	if (rc < 0 || rc >= 0x1000)
+		return -EIO;
+	if (rc != 0 && desc)
+		dev_err(chip->dev,
+			"A TPM error (%ld) occurred %s\n", rc, desc);
 	return rc;
 }
 
 #define TPM_DIGEST_SIZE 20
-#define TPM_RET_CODE_IDX 6
-
-static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
-			    int len, const char *desc)
-{
-	int err;
-
-	len = tpm_transmit(chip, (u8 *) cmd, len);
-	if (len <  0)
-		return len;
-	else if (len < TPM_HEADER_SIZE)
-		return -EFAULT;
-
-	err = be32_to_cpu(cmd->header.out.return_code);
-	if (err != 0 && desc)
-		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
-
-	return err;
-}
 
 #define TPM_INTERNAL_RESULT_SIZE 200
 
@@ -425,8 +447,8 @@ static const struct tpm_input_header tpm_getcap_header = {
 	.ordinal = cpu_to_be32(TPM_ORD_GET_CAP),
 };
 
-ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
-		   const char *desc)
+long tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
+		const char *desc)
 {
 	struct tpm_cmd_t tpm_cmd;
 	int rc;
@@ -447,7 +469,7 @@ ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = subcap_id;
 	}
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, desc);
+	rc = tpm_send_command(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, desc);
 	if (!rc)
 		*cap = tpm_cmd.params.getcap_out.cap;
 	return rc;
@@ -456,15 +478,14 @@ ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
 void tpm_gen_interrupt(struct tpm_chip *chip)
 {
 	struct	tpm_cmd_t tpm_cmd;
-	ssize_t rc;
 
 	tpm_cmd.header.in = tpm_getcap_header;
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
 
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			"attempting to determine the timeouts");
+	tpm_send_command(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+			 "attempting to determine the timeouts");
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
@@ -477,16 +498,16 @@ static const struct tpm_input_header tpm_startup_header = {
 	.ordinal = cpu_to_be32(TPM_ORD_STARTUP),
 };
 
-static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
+static long tpm_startup(struct tpm_chip *chip, struct tpm_cmd_t *start_cmd,
+			__be16 startup_type)
 {
-	struct tpm_cmd_t start_cmd;
-	start_cmd.header.in = tpm_startup_header;
-	start_cmd.params.startup_in.startup_type = startup_type;
-	return transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
-			    "attempting to start the TPM");
+	start_cmd->header.in = tpm_startup_header;
+	start_cmd->params.startup_in.startup_type = startup_type;
+	return tpm_send_command(chip, start_cmd, TPM_INTERNAL_RESULT_SIZE,
+				"attempting to start the TPM");
 }
 
-int tpm_get_timeouts(struct tpm_chip *chip)
+long tpm_get_timeouts(struct tpm_chip *chip)
 {
 	struct tpm_cmd_t tpm_cmd;
 	unsigned long new_timeout[4];
@@ -498,32 +519,28 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
+	rc = tpm_send_command(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+			      "attempting to determine the timeouts");
 
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
 		   Execute a startup command. */
 		dev_info(chip->dev, "Issuing TPM_STARTUP");
-		if (tpm_startup(chip, TPM_ST_CLEAR))
+		if (tpm_startup(chip, &tpm_cmd, TPM_ST_CLEAR))
 			return rc;
 
 		tpm_cmd.header.in = tpm_getcap_header;
 		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-		rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-				  NULL);
+		rc = tpm_send_command(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+				      "attempting to determine the timeouts");
 	}
-	if (rc) {
-		dev_err(chip->dev,
-			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
-			rc);
+	if (rc)
 		goto duration;
-	}
 
-	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
-	    be32_to_cpu(tpm_cmd.header.out.length)
-	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
+	if (be32_to_cpu(tpm_cmd.header.out.length) !=
+	    sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
 		return -EINVAL;
 
 	old_timeout[0] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.a);
@@ -573,8 +590,8 @@ duration:
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
 
-	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			"attempting to determine the durations");
+	rc = tpm_send_command(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+			      "attempting to determine the durations");
 	if (rc)
 		return rc;
 
@@ -622,15 +639,11 @@ static struct tpm_input_header continue_selftest_header = {
  * Returns 0 on success, < 0 in case of fatal error or a value > 0 representing
  * a TPM error code.
  */
-static int tpm_continue_selftest(struct tpm_chip *chip)
+static int tpm_continue_selftest(struct tpm_chip *chip, struct tpm_cmd_t *cmd)
 {
-	int rc;
-	struct tpm_cmd_t cmd;
-
-	cmd.header.in = continue_selftest_header;
-	rc = transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
-			  "continue selftest");
-	return rc;
+	cmd->header.in = continue_selftest_header;
+	return tpm_send_command(chip, cmd, CONTINUE_SELFTEST_RESULT_SIZE,
+				"continue selftest");
 }
 
 /**
@@ -692,8 +705,8 @@ int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
-			  "attempting to read a pcr value");
+	rc = tpm_send_command(chip, &cmd, READ_PCR_RESULT_SIZE,
+			      "attempting to read a pcr value");
 
 	if (rc == 0)
 		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
@@ -726,8 +739,8 @@ int tpm_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	return transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
-			    "attempting extend a PCR value");
+	return tpm_send_command(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+				"attempting extend a PCR value");
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 
@@ -739,9 +752,9 @@ EXPORT_SYMBOL_GPL(tpm_pcr_extend);
  * Returns 0 on success, < 0 in case of fatal error or a value > 0 representing
  * a TPM error code.
  */
-int tpm_do_selftest(struct tpm_chip *chip)
+long tpm_do_selftest(struct tpm_chip *chip)
 {
-	int rc;
+	long rc;
 	unsigned int loops;
 	unsigned int delay_msec = 100;
 	unsigned long duration;
@@ -751,7 +764,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 
 	loops = jiffies_to_msecs(duration) / delay_msec;
 
-	rc = tpm_continue_selftest(chip);
+	rc = tpm_continue_selftest(chip, &cmd);
 	/* This may fail if there was no TPM driver during a suspend/resume
 	 * cycle; some may return 10 (BAD_ORDINAL), others 28 (FAILEDSELFTEST)
 	 */
@@ -762,7 +775,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		/* Attempt to read a PCR value */
 		cmd.header.in = pcrread_header;
 		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
-		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
+		rc = tpm_send_command(chip, &cmd, READ_PCR_RESULT_SIZE, NULL);
 		/* Some buggy TPMs will not respond to tpm_tis_ready() for
 		 * around 300ms while the self test is ongoing, keep trying
 		 * until the self test duration expires. */
@@ -772,13 +785,9 @@ int tpm_do_selftest(struct tpm_chip *chip)
 			continue;
 		}
 
-		if (rc < TPM_HEADER_SIZE)
-			return -EFAULT;
-
-		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
 			dev_info(chip->dev,
-				 "TPM is disabled/deactivated (0x%X)\n", rc);
+				 "TPM is disabled/deactivated (0x%lX)\n", rc);
 			/* TPM is disabled and/or deactivated; driver can
 			 * proceed and TPM does handle commands for
 			 * suspend/resume correctly
@@ -794,12 +803,6 @@ int tpm_do_selftest(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm_do_selftest);
 
-int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen)
-{
-	return transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
-}
-EXPORT_SYMBOL_GPL(tpm_send);
-
 static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask,
 					bool check_cancel, bool *canceled)
 {
@@ -913,14 +916,14 @@ int tpm_pm_suspend(struct device *dev)
 		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
 		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
 		       TPM_DIGEST_SIZE);
-		rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
-				  "extending dummy pcr before suspend");
+		tpm_send_command(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+				 "extending dummy pcr before suspend");
 	}
 
 	/* now do the actual savestate */
 	for (try = 0; try < TPM_RETRY; try++) {
 		cmd.header.in = savestate_header;
-		rc = transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, NULL);
+		rc = tpm_send_command(chip, &cmd, SAVESTATE_RESULT_SIZE, NULL);
 
 		/*
 		 * If the TPM indicates that it is too busy to respond to
@@ -992,9 +995,9 @@ int tpm_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 		tpm_cmd.header.in = tpm_getrandom_header;
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
 
-		err = transmit_cmd(chip, &tpm_cmd,
-				   TPM_GETRANDOM_RESULT_SIZE + num_bytes,
-				   "attempting get random");
+		err = tpm_send_command(chip, &tpm_cmd,
+				       TPM_GETRANDOM_RESULT_SIZE + num_bytes,
+				       "attempting get random");
 		if (err)
 			break;
 
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index d8da83a1d11c..ad3b01882b15 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -21,25 +21,6 @@
 #include <linux/tpm_command.h>
 #include "tpm.h"
 
-/* XXX for now this helper is duplicated in tpm-interface.c */
-static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
-			    int len, const char *desc)
-{
-	int err;
-
-	len = tpm_transmit(chip, (u8 *) cmd, len);
-	if (len <  0)
-		return len;
-	else if (len < TPM_HEADER_SIZE)
-		return -EFAULT;
-
-	err = be32_to_cpu(cmd->header.out.return_code);
-	if (err != 0 && desc)
-		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
-
-	return err;
-}
-
 #define READ_PUBEK_RESULT_SIZE 314
 static struct tpm_input_header tpm_readpubek_header = {
 	.tag	 = cpu_to_be16(TPM_TAG_RQU_COMMAND),
@@ -58,8 +39,8 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
-	err = transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
-			   "attempting to read the PUBEK");
+	err = tpm_send_command(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
+			       "attempting to read the PUBEK");
 	if (err)
 		goto out;
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 2a1be0ec2fbd..912eba092e62 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -306,13 +306,11 @@ struct tpm_cmd_t {
 	tpm_cmd_params	params;
 } __packed;
 
-ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
+extern long tpm_getcap(struct device *, __be32, cap_t *, const char *);
 
-ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-		     size_t bufsiz);
-extern int tpm_get_timeouts(struct tpm_chip *);
+extern long tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
-extern int tpm_do_selftest(struct tpm_chip *);
+extern long tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
 extern struct tpm_chip* tpm_register_hardware(struct device *,
 					      const struct tpm_class_ops *ops);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index c213e09b7d81..f4e14405f5cf 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -51,7 +51,8 @@ extern void tpm_chip_put(struct tpm_chip *chip);
 
 extern int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
-extern int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen);
+extern long tpm_send_command(struct tpm_chip *chip, void *buf, size_t buflen,
+			     const char *desc);
 extern int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max);
 #else
 static inline struct tpm_chip *tpm_chip_find_get(int chip_num)
@@ -67,7 +68,9 @@ static inline int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 static inline int tpm_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash) {
 	return -ENODEV;
 }
-static inline int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen) {
+static inline long tpm_send_command(struct tpm_chip *chip, void *buf, size_t buflen,
+				    const char *desc)
+{
 	return -ENODEV;
 }
 static inline int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max) {
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index adb0caa5c38d..943c65b53201 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -355,12 +355,12 @@ out:
  * own TPM command packets using the drivers send function.
  */
 static int trusted_tpm_send(struct tpm_chip *chip, unsigned char *cmd,
-			    size_t buflen)
+			    size_t buflen, const char *desc)
 {
 	int rc;
 
 	dump_tpm_buf(cmd);
-	rc = tpm_send(chip, cmd, buflen);
+	rc = tpm_send_command(chip, cmd, buflen, desc);
 	dump_tpm_buf(cmd);
 	if (rc > 0)
 		/* Can't return positive return codes values to keyctl */
@@ -410,7 +410,8 @@ static int osap(struct tpm_chip *chip,
 	store32(tb, handle);
 	storebytes(tb, ononce, TPM_NONCE_SIZE);
 
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
+			       "creating OSAP session");
 	if (ret < 0)
 		return ret;
 
@@ -435,7 +436,8 @@ static int oiap(struct tpm_chip *chip, struct tpm_buf *tb, uint32_t *handle,
 	store16(tb, TPM_TAG_RQU_COMMAND);
 	store32(tb, TPM_OIAP_SIZE);
 	store32(tb, TPM_ORD_OIAP);
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
+			       "creating OIAP session");
 	if (ret < 0)
 		return ret;
 
@@ -544,7 +546,8 @@ static int tpm_seal(struct tpm_chip *chip,
 	store8(tb, cont);
 	storebytes(tb, td->pubauth, SHA1_DIGEST_SIZE);
 
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
+			       "sealing data");
 	if (ret < 0)
 		goto out;
 
@@ -637,7 +640,8 @@ static int tpm_unseal(struct tpm_chip *chip, struct tpm_buf *tb,
 	store8(tb, cont);
 	storebytes(tb, authdata2, SHA1_DIGEST_SIZE);
 
-	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE);
+	ret = trusted_tpm_send(chip, tb->data, MAX_BUF_SIZE,
+			       "unsealing data");
 	if (ret < 0) {
 		pr_info("trusted_key: authhmac failed (%d)\n", ret);
 		return ret;


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
