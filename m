From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RFC v3 3/5] tpm: infrastructure for TPM spaces
Date: Mon, 16 Jan 2017 15:12:09 +0200
Message-ID: <20170116131215.28930-4-jarkko.sakkinen@linux.intel.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170116131215.28930-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Added ability to tpm_transmit() to supply a TPM space that contains
mapping from virtual handles to physical handles and backing storage for
swapping transient objects. TPM space is isolated from other users of
the TPM.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-chip.c      |   7 +
 drivers/char/tpm/tpm-dev.c       |   2 +-
 drivers/char/tpm/tpm-interface.c |  55 ++++---
 drivers/char/tpm/tpm-sysfs.c     |   2 +-
 drivers/char/tpm/tpm.h           |  21 ++-
 drivers/char/tpm/tpm2-cmd.c      |  36 ++---
 drivers/char/tpm/tpm2-space.c    | 305 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 385 insertions(+), 45 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2-space.c

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
index c406343..993b9ae 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -128,6 +128,7 @@ static void tpm_dev_release(struct device *dev)
 	mutex_unlock(&idr_lock);
 
 	kfree(chip->log.bios_event_log);
+	kfree(chip->work_space.context_buf);
 	kfree(chip);
 }
 
@@ -189,6 +190,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->cdev.owner = THIS_MODULE;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
+	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!chip->work_space.context_buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
 	return chip;
 
 out:
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 912ad30..249eeb0 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -144,7 +144,7 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 		mutex_unlock(&priv->buffer_mutex);
 		return -EPIPE;
 	}
-	out_size = tpm_transmit(priv->chip, priv->data_buffer,
+	out_size = tpm_transmit(priv->chip, NULL, priv->data_buffer,
 				sizeof(priv->data_buffer), 0);
 
 	tpm_put_ops(priv->chip);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index fe863f2..ae85aab 100644
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
+	rc = tpm2_commit_space(chip, space, ordinal, buf, len);
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
@@ -463,14 +474,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
  *     A negative number for system errors (errno).
  *     A positive number for a TPM error.
  */
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
-			 size_t len, size_t min_rx_length,
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
+			 const void *cmd, size_t len, size_t min_rx_length,
 			 unsigned int flags, const char *desc)
 {
 	const struct tpm_output_header *header;
 	int err;
 
-	len = tpm_transmit(chip, (const u8 *)cmd, len, flags);
+	len = tpm_transmit(chip, space, (void *)cmd, len, flags);
 	if (len <  0)
 		return len;
 	else if (len < TPM_HEADER_SIZE)
@@ -525,9 +536,8 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
 	}
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
 			      TPM_HEADER_SIZE + min_cap_length, 0, desc);
-
 	if (!rc)
 		*cap = tpm_cmd.params.getcap_out.cap;
 	return rc;
@@ -550,7 +560,8 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 	start_cmd.header.in = tpm_startup_header;
 
 	start_cmd.params.startup_in.startup_type = startup_type;
-	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
+	return tpm_transmit_cmd(chip, NULL, &start_cmd,
+				TPM_INTERNAL_RESULT_SIZE,
 				TPM_HEADER_SIZE, 0,
 				"attempting to start the TPM");
 }
@@ -696,7 +707,7 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	struct tpm_cmd_t cmd;
 
 	cmd.header.in = continue_selftest_header;
-	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
 			      CONTINUE_SELFTEST_RESULT_SIZE,
 			      0, "continue selftest");
 	return rc;
@@ -717,7 +728,7 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	rc = tpm_transmit_cmd(chip, &cmd,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd,
 			      READ_PCR_RESULT_SIZE,
 			      READ_PCR_RESULT_SIZE, 0,
 			      "attempting to read a pcr value");
@@ -816,7 +827,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
 			      EXTEND_PCR_RESULT_SIZE, 0,
 			      "attempting extend a PCR value");
 
@@ -921,7 +932,7 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 	if (chip == NULL)
 		return -ENODEV;
 
-	rc = tpm_transmit_cmd(chip, cmd, buflen, TPM_HEADER_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, cmd, buflen, TPM_HEADER_SIZE,
 			      0, "attempting tpm_cmd");
 
 	tpm_put_ops(chip);
@@ -1024,15 +1035,15 @@ int tpm_pm_suspend(struct device *dev)
 		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
 		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
 		       TPM_DIGEST_SIZE);
-		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
-				     EXTEND_PCR_RESULT_SIZE, 0,
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
+				      EXTEND_PCR_RESULT_SIZE, 0,
 				      "extending dummy pcr before suspend");
 	}
 
 	/* now do the actual savestate */
 	for (try = 0; try < TPM_RETRY; try++) {
 		cmd.header.in = savestate_header;
-		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE,
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, SAVESTATE_RESULT_SIZE,
 				      SAVESTATE_RESULT_SIZE, 0, NULL);
 
 		/*
@@ -1116,7 +1127,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		tpm_cmd.header.in = tpm_getrandom_header;
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
 
-		err = tpm_transmit_cmd(chip, &tpm_cmd,
+		err = tpm_transmit_cmd(chip, NULL, &tpm_cmd,
 				       TPM_GETRANDOM_RESULT_SIZE + num_bytes,
 				       offsetof(struct tpm_cmd_t,
 				                params.getrandom_out.rng_data),
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index bd0134d..40608105 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -39,7 +39,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
-	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
+	err = tpm_transmit_cmd(chip, NULL, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
 	                       TPM_HEADER_SIZE + 28 + 256,
 			       0, "attempting to read the PUBEK");
 	if (err)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 2661c26..45d997f 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -90,7 +90,9 @@ enum tpm2_structures {
 };
 
 enum tpm2_return_codes {
+	TPM2_RC_SUCCESS		= 0x0000,
 	TPM2_RC_HASH		= 0x0083, /* RC_FMT1 */
+	TPM2_RC_HANDLE		= 0x008B,
 	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
 	TPM2_RC_DISABLED	= 0x0120,
 	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
@@ -114,6 +116,8 @@ enum tpm2_command_codes {
 	TPM2_CC_CREATE		= 0x0153,
 	TPM2_CC_LOAD		= 0x0157,
 	TPM2_CC_UNSEAL		= 0x015E,
+	TPM2_CC_CONTEXT_LOAD	= 0x0161,
+	TPM2_CC_CONTEXT_SAVE	= 0x0162,
 	TPM2_CC_FLUSH_CONTEXT	= 0x0165,
 	TPM2_CC_GET_CAPABILITY	= 0x017A,
 	TPM2_CC_GET_RANDOM	= 0x017B,
@@ -151,6 +155,11 @@ enum tpm2_cc_attrs {
 
 #define TPM_PPI_VERSION_LEN		3
 
+struct tpm_space {
+	u32 context_tbl[14];
+	u8 *context_buf;
+};
+
 enum tpm_chip_flags {
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
 	TPM_CHIP_FLAG_IRQ		= BIT(2),
@@ -202,6 +211,7 @@ struct tpm_chip {
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
 #endif /* CONFIG_ACPI */
 
+	struct tpm_space work_space;
 	u32 nr_commands;
 	u32 *cc_attrs_tbl;
 };
@@ -509,9 +519,10 @@ enum tpm_transmit_flags {
 	TPM_TRANSMIT_UNLOCKED	= BIT(0),
 };
 
-ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
-		     unsigned int flags);
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, size_t len,
+ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
+		     u8 *buf, size_t bufsiz, unsigned int flags);
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
+			 const void *cmd, size_t len,
 			 size_t min_tx_length, unsigned int flags,
 			 const char *desc);
 ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
@@ -567,4 +578,8 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
 bool tpm2_find_cc_attrs(struct tpm_chip *chip, u32 cc, u32 *attrs);
+int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
+		       u32 cc, u8 *buf, size_t bufsiz);
+int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
+		      u32 cc, u8 *buf, size_t bufsiz);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index fd73e2a..e1c1bbd 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -284,8 +284,9 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	       sizeof(cmd.params.pcrread_in.pcr_select));
 	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM2_PCR_READ_OUT_SIZE,
-			      0, "attempting to read a pcr value");
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
+			      TPM2_PCR_READ_OUT_SIZE, 0,
+			      "attempting to read a pcr value");
 	if (rc == 0) {
 		buf = cmd.params.pcrread_out.digest;
 		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
@@ -331,7 +332,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
 	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
 	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE, 0,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), TPM_HEADER_SIZE, 0,
 			      "attempting extend a PCR value");
 
 	return rc;
@@ -377,7 +378,7 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 		cmd.header.in = tpm2_getrandom_header;
 		cmd.params.getrandom_in.size = cpu_to_be16(num_bytes);
 
-		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+		err = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
 				       offsetof(struct tpm2_cmd,
 				                params.getrandom_out.buffer),
 				       0, "attempting get random");
@@ -437,8 +438,8 @@ void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
 
 	tpm_buf_append_u32(&buf, handle);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_HEADER_SIZE, flags,
-			     "flushing context");
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, TPM_HEADER_SIZE,
+			      flags, "flushing context");
 	if (rc)
 		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
 			 rc);
@@ -556,7 +557,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
 	                      TPM_HEADER_SIZE + 4,
 			      0, "sealing data");
 	if (rc)
@@ -641,7 +642,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
 			      TPM_HEADER_SIZE + 4, flags, "loading blob");
 	if (!rc)
 		*blob_handle = be32_to_cpup(
@@ -693,7 +694,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
 			      TPM_HEADER_SIZE + 4 + 2, flags, "unsealing");
 	if (rc > 0)
 		rc = -EPERM;
@@ -770,7 +771,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(property_id);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
 			      TPM2_GET_TPM_PT_OUT_SIZE, 0, desc);
 	if (!rc)
 		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);
@@ -805,7 +806,7 @@ static int tpm2_startup(struct tpm_chip *chip, u16 startup_type)
 	cmd.header.in = tpm2_startup_header;
 
 	cmd.params.startup_in.startup_type = cpu_to_be16(startup_type);
-	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
+	return tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
 				0, "attempting to start the TPM");
 }
 
@@ -834,7 +835,7 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
 	cmd.header.in = tpm2_shutdown_header;
 	cmd.params.startup_in.startup_type = cpu_to_be16(shutdown_type);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
 			      0, "stopping the TPM");
 
 	/* In places where shutdown command is sent there's no much we can do
@@ -898,7 +899,7 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
 	cmd.header.in = tpm2_selftest_header;
 	cmd.params.selftest_in.full_test = full;
 
-	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, TPM2_SELF_TEST_IN_SIZE,
 			      TPM_HEADER_SIZE, 0, "continue selftest");
 
 	/* At least some prototype chips seem to give RC_TESTING error
@@ -949,8 +950,8 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 		cmd.params.pcrread_in.pcr_select[1] = 0x00;
 		cmd.params.pcrread_in.pcr_select[2] = 0x00;
 
-		rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
-				      0, NULL);
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
+				      TPM_HEADER_SIZE, 0, NULL);
 		if (rc < 0)
 			break;
 
@@ -983,7 +984,7 @@ int tpm2_probe(struct tpm_chip *chip)
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
 			      0, NULL);
 	if (rc <  0)
 		return rc;
@@ -1046,7 +1047,8 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 	tpm_buf_append_u32(&buf, TPM2_CC_FIRST);
 	tpm_buf_append_u32(&buf, nr_commands);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_HEADER_SIZE, 0, NULL);
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, TPM_HEADER_SIZE,
+			      0, NULL);
 	if (rc < 0) {
 		tpm_buf_destroy(&buf);
 		goto out;
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
new file mode 100644
index 0000000..3708e70
--- /dev/null
+++ b/drivers/char/tpm/tpm2-space.c
@@ -0,0 +1,305 @@
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
+#include <asm/unaligned.h>
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
+	struct tpm_buf buf;
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
+		rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS,
+				 TPM2_CC_CONTEXT_LOAD);
+		if (rc)
+			return rc;
+
+		ctx = (struct tpm2_context *)&space->context_buf[j];
+		s = sizeof(*ctx) + be16_to_cpu(ctx->blob_size);
+		tpm_buf_append(&buf, &space->context_buf[j], s);
+
+		rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
+				      TPM_HEADER_SIZE + 4,
+				      TPM_TRANSMIT_UNLOCKED, NULL);
+		if (rc) {
+			dev_warn(&chip->dev, "%s: loading failed with %d\n",
+				 __func__, rc);
+			rc = -EFAULT;
+			goto out_err;
+		}
+
+		space->context_tbl[i] =
+			be32_to_cpup((__be32 *)&buf.data[TPM_HEADER_SIZE]);
+
+		j += s;
+
+		tpm_buf_destroy(&buf);
+	}
+
+	return 0;
+
+out_err:
+	tpm_buf_destroy(&buf);
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
+	u32 return_code = get_unaligned_be32((__be32 *)&rsp[6]);
+	int i;
+	int rc;
+
+	if (return_code != TPM2_RC_SUCCESS)
+		return 0;
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
+	struct tpm_buf buf;
+	int i;
+	int j;
+	int rc;
+	u32 s;
+
+	for (i = 0, j = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		if (!(space->context_tbl[i] && ~space->context_tbl[i]))
+			continue;
+
+		rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS,
+				  TPM2_CC_CONTEXT_SAVE);
+		if (rc)
+			return rc;
+
+		tpm_buf_append_u32(&buf, space->context_tbl[i]);
+
+		rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
+				      TPM_HEADER_SIZE, TPM_TRANSMIT_UNLOCKED,
+				      NULL);
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
+		s = tpm_buf_length(&buf) - TPM_HEADER_SIZE;
+		if ((j + s) > PAGE_SIZE) {
+			dev_warn(&chip->dev, "%s: out of backing storage\n",
+				 __func__);
+			rc = -ENOMEM;
+			goto out_err;
+		}
+
+		memcpy(&space->context_buf[j], &buf.data[TPM_HEADER_SIZE], s);
+
+		tpm2_flush_context_cmd(chip, space->context_tbl[i],
+				       TPM_TRANSMIT_UNLOCKED);
+
+		space->context_tbl[i] = ~0;
+
+		j += s;
+
+		tpm_buf_destroy(&buf);
+	}
+
+	return 0;
+out_err:
+	tpm_buf_destroy(&buf);
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
-- 
2.9.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
