From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 4/7] tpm: infrastructure for TPM spaces
Date: Thu, 16 Feb 2017 21:25:17 +0200
Message-ID: <20170216192529.25467-5-jarkko.sakkinen@linux.intel.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170216192529.25467-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Added an ability to virtualize TPM commands into an isolated context
that we call a TPM space because the word context is already heavily
used in the TPM specification. Both the handle areas and bodies (where
necessary) are virtualized.

The mechanism works by adding a new parameter struct tpm_space to the
tpm_transmit() function. This new structure contains the list of virtual
handles and a buffer of page size (currently) for backing storage.

When tpm_transmit() is called with a struct tpm_space instance it will
execute the following sequence:

1. Take locks.
2. Load transient objects from the backing storage by using ContextLoad
   and map virtual handles to physical handles.
3. Perform the transaction.
4. Save transient objects to backing storage by using ContextSave and
   map resulting physical handle to virtual handle if there is such.

This commit does not implement virtualization support for hmac and
policy sessions.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-chip.c      |   7 +
 drivers/char/tpm/tpm-dev.c       |   2 +-
 drivers/char/tpm/tpm-interface.c |  68 +++---
 drivers/char/tpm/tpm-sysfs.c     |   2 +-
 drivers/char/tpm/tpm.h           |  26 ++-
 drivers/char/tpm/tpm2-cmd.c      |  33 +--
 drivers/char/tpm/tpm2-space.c    | 431 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 520 insertions(+), 51 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2-space.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 3d386a8..8f07fcf 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -3,7 +3,7 @@
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
-		tpm1_eventlog.o tpm2_eventlog.o
+	 tpm1_eventlog.o tpm2_eventlog.o tpm2-space.o
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
index 02a8850..414553b 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -147,7 +147,7 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 		mutex_unlock(&priv->buffer_mutex);
 		return -EPIPE;
 	}
-	out_size = tpm_transmit(priv->chip, priv->data_buffer,
+	out_size = tpm_transmit(priv->chip, NULL, priv->data_buffer,
 				sizeof(priv->data_buffer), 0);
 
 	tpm_put_ops(priv->chip);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 20b1fe3..db5ffe9 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -376,11 +376,12 @@ static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
  *     0 when the operation is successful.
  *     A negative number for system errors (errno).
  */
-ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
-		     unsigned int flags)
+ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
+		     u8 *buf, size_t bufsiz, unsigned int flags)
 {
-	const struct tpm_output_header *header = (void *)buf;
-	ssize_t rc;
+	struct tpm_output_header *header = (void *)buf;
+	int rc;
+	ssize_t len = 0;
 	u32 count, ordinal;
 	unsigned long stop;
 
@@ -406,10 +407,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	if (chip->dev.parent)
 		pm_runtime_get_sync(chip->dev.parent);
 
+	rc = tpm2_prepare_space(chip, space, ordinal, buf);
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
 
@@ -442,18 +447,23 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	goto out;
 
 out_recv:
-	rc = chip->ops->recv(chip, (u8 *) buf, bufsiz);
-	if (rc < 0) {
+	len = chip->ops->recv(chip, (u8 *) buf, bufsiz);
+	if (len < 0) {
 		dev_err(&chip->dev,
-			"tpm_transmit: tpm_recv: error %zd\n", rc);
+			"tpm_transmit: tpm_recv: error %d\n", rc);
+		rc = len;
 		goto out;
-	} else if (rc < TPM_HEADER_SIZE) {
+	} else if (len < TPM_HEADER_SIZE) {
 		rc = -EFAULT;
 		goto out;
 	}
 
-	if (rc != be32_to_cpu(header->length))
+	if (len != be32_to_cpu(header->length)) {
+		rc = -EFAULT;
 		goto out;
+	}
+
+	rc = tpm2_commit_space(chip, space, ordinal, buf, &len);
 
 out:
 	if (chip->dev.parent)
@@ -461,7 +471,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 
 	if (!(flags & TPM_TRANSMIT_UNLOCKED))
 		mutex_unlock(&chip->tpm_mutex);
-	return rc;
+	return rc ? rc : len;
 }
 
 /**
@@ -480,15 +490,16 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
  *     A negative number for system errors (errno).
  *     A positive number for a TPM error.
  */
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf,
-			 size_t bufsiz, size_t min_rsp_body_length,
-			 unsigned int flags, const char *desc)
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
+			 const void *buf, size_t bufsiz,
+			 size_t min_rsp_body_length, unsigned int flags,
+			 const char *desc)
 {
 	const struct tpm_output_header *header = buf;
 	int err;
 	ssize_t len;
 
-	len = tpm_transmit(chip, (const u8 *)buf, bufsiz, flags);
+	len = tpm_transmit(chip, space, (u8 *)buf, bufsiz, flags);
 	if (len <  0)
 		return len;
 
@@ -541,7 +552,7 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
 	}
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
 			      min_cap_length, 0, desc);
 	if (!rc)
 		*cap = tpm_cmd.params.getcap_out.cap;
@@ -565,7 +576,8 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 	start_cmd.header.in = tpm_startup_header;
 
 	start_cmd.params.startup_in.startup_type = startup_type;
-	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
+	return tpm_transmit_cmd(chip, NULL, &start_cmd,
+				TPM_INTERNAL_RESULT_SIZE, 0,
 				0, "attempting to start the TPM");
 }
 
@@ -722,8 +734,8 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	struct tpm_cmd_t cmd;
 
 	cmd.header.in = continue_selftest_header;
-	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE, 0, 0,
-			      "continue selftest");
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
+			      0, 0, "continue selftest");
 	return rc;
 }
 
@@ -743,7 +755,7 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, READ_PCR_RESULT_SIZE,
 			      READ_PCR_RESULT_BODY_SIZE, 0,
 			      "attempting to read a pcr value");
 
@@ -855,7 +867,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
 			      EXTEND_PCR_RESULT_BODY_SIZE, 0,
 			      "attempting extend a PCR value");
 
@@ -960,8 +972,8 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 	if (chip == NULL)
 		return -ENODEV;
 
-	rc = tpm_transmit_cmd(chip, cmd, buflen, 0, 0, "attempting tpm_cmd");
-
+	rc = tpm_transmit_cmd(chip, NULL, cmd, buflen, 0, 0,
+			      "attempting tpm_cmd");
 	tpm_put_ops(chip);
 	return rc;
 }
@@ -1062,16 +1074,16 @@ int tpm_pm_suspend(struct device *dev)
 		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
 		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
 		       TPM_DIGEST_SIZE);
-		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
-				     EXTEND_PCR_RESULT_BODY_SIZE, 0,
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
+				      EXTEND_PCR_RESULT_BODY_SIZE, 0,
 				      "extending dummy pcr before suspend");
 	}
 
 	/* now do the actual savestate */
 	for (try = 0; try < TPM_RETRY; try++) {
 		cmd.header.in = savestate_header;
-		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, 0,
-				      0, NULL);
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, SAVESTATE_RESULT_SIZE,
+				      0, 0, NULL);
 
 		/*
 		 * If the TPM indicates that it is too busy to respond to
@@ -1154,7 +1166,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		tpm_cmd.header.in = tpm_getrandom_header;
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
 
-		err = tpm_transmit_cmd(chip, &tpm_cmd,
+		err = tpm_transmit_cmd(chip, NULL, &tpm_cmd,
 				       TPM_GETRANDOM_RESULT_SIZE + num_bytes,
 				       offsetof(struct tpm_getrandom_out,
 						rng_data),
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 2f596d7..55405db 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -40,7 +40,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
-	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
+	err = tpm_transmit_cmd(chip, NULL, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
 			       READ_PUBEK_RESULT_MIN_BODY_SIZE, 0,
 			       "attempting to read the PUBEK");
 	if (err)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 0ec1cf0..97e48a4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -89,10 +89,13 @@ enum tpm2_structures {
 };
 
 enum tpm2_return_codes {
+	TPM2_RC_SUCCESS		= 0x0000,
 	TPM2_RC_HASH		= 0x0083, /* RC_FMT1 */
+	TPM2_RC_HANDLE		= 0x008B,
 	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
 	TPM2_RC_DISABLED	= 0x0120,
 	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
+	TPM2_RC_REFERENCE_H0	= 0x0910,
 };
 
 enum tpm2_algorithms {
@@ -114,6 +117,7 @@ enum tpm2_command_codes {
 	TPM2_CC_CREATE		= 0x0153,
 	TPM2_CC_LOAD		= 0x0157,
 	TPM2_CC_UNSEAL		= 0x015E,
+	TPM2_CC_CONTEXT_LOAD	= 0x0161,
 	TPM2_CC_CONTEXT_SAVE	= 0x0162,
 	TPM2_CC_FLUSH_CONTEXT	= 0x0165,
 	TPM2_CC_GET_CAPABILITY	= 0x017A,
@@ -128,6 +132,7 @@ enum tpm2_permanent_handles {
 };
 
 enum tpm2_capabilities {
+	TPM2_CAP_HANDLES	= 1,
 	TPM2_CAP_COMMANDS	= 2,
 	TPM2_CAP_PCRS		= 5,
 	TPM2_CAP_TPM_PROPERTIES = 6,
@@ -153,6 +158,11 @@ enum tpm2_cc_attrs {
 
 #define TPM_PPI_VERSION_LEN		3
 
+struct tpm_space {
+	u32 context_tbl[3];
+	u8 *context_buf;
+};
+
 enum tpm_chip_flags {
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
 	TPM_CHIP_FLAG_IRQ		= BIT(2),
@@ -211,6 +221,7 @@ struct tpm_chip {
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
 #endif /* CONFIG_ACPI */
 
+	struct tpm_space work_space;
 	u32 nr_commands;
 	u32 *cc_attrs_tbl;
 };
@@ -507,10 +518,11 @@ enum tpm_transmit_flags {
 	TPM_TRANSMIT_UNLOCKED	= BIT(0),
 };
 
-ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
-		     unsigned int flags);
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf, size_t bufsiz,
-			 size_t min_rsp_body_len, unsigned int flags,
+ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
+		     u8 *buf, size_t bufsiz, unsigned int flags);
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
+			 const void *buf, size_t bufsiz,
+			 size_t min_rsp_body_length, unsigned int flags,
 			 const char *desc);
 ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		   const char *desc, size_t min_cap_length);
@@ -572,4 +584,10 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
 ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip);
 int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
+int tpm2_init_space(struct tpm_space *space);
+void tpm2_del_space(struct tpm_space *space);
+int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
+		       u8 *cmd);
+int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
+		      u32 cc, u8 *buf, size_t *bufsiz);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 897902a..96121b3 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -266,7 +266,7 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	       sizeof(cmd.params.pcrread_in.pcr_select));
 	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
 			      TPM2_PCR_READ_RESP_BODY_SIZE,
 			      0, "attempting to read a pcr value");
 	if (rc == 0) {
@@ -333,7 +333,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
 		}
 	}
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, 0,
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, 0,
 			      "attempting extend a PCR value");
 
 	tpm_buf_destroy(&buf);
@@ -382,7 +382,7 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 		cmd.header.in = tpm2_getrandom_header;
 		cmd.params.getrandom_in.size = cpu_to_be16(num_bytes);
 
-		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+		err = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
 				       offsetof(struct tpm2_get_random_out,
 						buffer),
 				       0, "attempting get random");
@@ -441,7 +441,7 @@ void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
 
 	tpm_buf_append_u32(&buf, handle);
 
-	(void) tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, flags,
+	(void) tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, flags,
 				"flushing context");
 
 	tpm_buf_destroy(&buf);
@@ -557,7 +557,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 4, 0,
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 4, 0,
 			      "sealing data");
 	if (rc)
 		goto out;
@@ -641,7 +641,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 4, flags,
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 4, flags,
 			      "loading blob");
 	if (!rc)
 		*blob_handle = be32_to_cpup(
@@ -693,7 +693,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 6, flags,
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 6, flags,
 			      "unsealing");
 	if (rc > 0)
 		rc = -EPERM;
@@ -770,7 +770,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(property_id);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
 			      TPM2_GET_TPM_PT_OUT_BODY_SIZE, 0, desc);
 	if (!rc)
 		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);
@@ -805,7 +805,7 @@ static int tpm2_startup(struct tpm_chip *chip, u16 startup_type)
 	cmd.header.in = tpm2_startup_header;
 
 	cmd.params.startup_in.startup_type = cpu_to_be16(startup_type);
-	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0,
+	return tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
 				"attempting to start the TPM");
 }
 
@@ -834,7 +834,7 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
 	cmd.header.in = tpm2_shutdown_header;
 	cmd.params.startup_in.startup_type = cpu_to_be16(shutdown_type);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
 			      "stopping the TPM");
 
 	/* In places where shutdown command is sent there's no much we can do
@@ -898,7 +898,7 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
 	cmd.header.in = tpm2_selftest_header;
 	cmd.params.selftest_in.full_test = full;
 
-	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE, 0, 0,
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, TPM2_SELF_TEST_IN_SIZE, 0, 0,
 			      "continue selftest");
 
 	/* At least some prototype chips seem to give RC_TESTING error
@@ -949,7 +949,8 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 		cmd.params.pcrread_in.pcr_select[1] = 0x00;
 		cmd.params.pcrread_in.pcr_select[2] = 0x00;
 
-		rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0, NULL);
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
+				      NULL);
 		if (rc < 0)
 			break;
 
@@ -982,7 +983,7 @@ int tpm2_probe(struct tpm_chip *chip)
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0, NULL);
+	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0, NULL);
 	if (rc <  0)
 		return rc;
 
@@ -1022,8 +1023,8 @@ static int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip)
 	tpm_buf_append_u32(&buf, TPM2_CC_FIRST);
 	tpm_buf_append_u32(&buf, nr_commands);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 9 + 4 * nr_commands,
-			      0, NULL);
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
+			      9 + 4 * nr_commands, 0, NULL);
 	if (rc) {
 		tpm_buf_destroy(&buf);
 		goto out;
@@ -1136,7 +1137,7 @@ ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
 	tpm_buf_append_u32(&buf, 0);
 	tpm_buf_append_u32(&buf, 1);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 9, 0,
+	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 9, 0,
 			      "get tpm pcr allocation");
 	if (rc)
 		goto out;
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
new file mode 100644
index 0000000..e955548
--- /dev/null
+++ b/drivers/char/tpm/tpm2-space.c
@@ -0,0 +1,431 @@
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
+struct tpm2_context {
+	__be64 sequence;
+	__be32 saved_handle;
+	__be32 hierarchy;
+	__be16 blob_size;
+} __packed;
+
+int tpm2_init_space(struct tpm_space *space)
+{
+	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!space->context_buf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void tpm2_del_space(struct tpm_space *space)
+{
+	kfree(space->context_buf);
+}
+
+static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
+			     unsigned int *offset, u32 *handle)
+{
+	struct tpm_buf tbuf;
+	struct tpm2_context *ctx;
+	unsigned int body_size;
+	int rc;
+
+	rc = tpm_buf_init(&tbuf, TPM2_ST_NO_SESSIONS, TPM2_CC_CONTEXT_LOAD);
+	if (rc)
+		return rc;
+
+	ctx = (struct tpm2_context *)&buf[*offset];
+	body_size = sizeof(*ctx) + be16_to_cpu(ctx->blob_size);
+	tpm_buf_append(&tbuf, &buf[*offset], body_size);
+
+	rc = tpm_transmit_cmd(chip, NULL, tbuf.data, PAGE_SIZE, 4,
+			      TPM_TRANSMIT_UNLOCKED, NULL);
+	if (rc < 0) {
+		dev_warn(&chip->dev, "%s: failed with a system error %d\n",
+			 __func__, rc);
+		tpm_buf_destroy(&tbuf);
+		return -EFAULT;
+	} else if (rc > 0) {
+		dev_warn(&chip->dev, "%s: failed with a TPM error 0x%04X\n",
+			 __func__, rc);
+		tpm_buf_destroy(&tbuf);
+		return -EFAULT;
+	}
+
+	*handle = be32_to_cpup((__be32 *)&tbuf.data[TPM_HEADER_SIZE]);
+	*offset += body_size;
+
+	tpm_buf_destroy(&tbuf);
+	return 0;
+}
+
+static int tpm2_save_context(struct tpm_chip *chip, u32 handle, u8 *buf,
+			     unsigned int buf_size, unsigned int *offset)
+{
+	struct tpm_buf tbuf;
+	unsigned int body_size;
+	int rc;
+
+	rc = tpm_buf_init(&tbuf, TPM2_ST_NO_SESSIONS, TPM2_CC_CONTEXT_SAVE);
+	if (rc)
+		return rc;
+
+	tpm_buf_append_u32(&tbuf, handle);
+
+	rc = tpm_transmit_cmd(chip, NULL, tbuf.data, PAGE_SIZE, 0,
+			      TPM_TRANSMIT_UNLOCKED, NULL);
+	if (rc < 0) {
+		dev_warn(&chip->dev, "%s: failed with a system error %d\n",
+			 __func__, rc);
+		tpm_buf_destroy(&tbuf);
+		return -EFAULT;
+	} else if (tpm2_rc_value(rc) == TPM2_RC_REFERENCE_H0) {
+		tpm_buf_destroy(&tbuf);
+		return -ENOENT;
+	} else if (rc) {
+		dev_warn(&chip->dev, "%s: failed with a TPM error 0x%04X\n",
+			 __func__, rc);
+		tpm_buf_destroy(&tbuf);
+		return -EFAULT;
+	}
+
+	body_size = tpm_buf_length(&tbuf) - TPM_HEADER_SIZE;
+	if ((*offset + body_size) > buf_size) {
+		dev_warn(&chip->dev, "%s: out of backing storage\n", __func__);
+		tpm_buf_destroy(&tbuf);
+		return -ENOMEM;
+	}
+
+	memcpy(&buf[*offset], &tbuf.data[TPM_HEADER_SIZE], body_size);
+	tpm2_flush_context_cmd(chip, handle, TPM_TRANSMIT_UNLOCKED);
+	*offset += body_size;
+	tpm_buf_destroy(&tbuf);
+	return 0;
+}
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
+static int tpm2_load_space(struct tpm_chip *chip)
+{
+	struct tpm_space *space = &chip->work_space;
+	unsigned int offset;
+	int i;
+	int rc;
+
+	for (i = 0, offset = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		if (!space->context_tbl[i])
+			continue;
+
+		/* sanity check, should never happen */
+		if (~space->context_tbl[i]) {
+			dev_err(&chip->dev, "context table is inconsistent");
+			return -EFAULT;
+		}
+
+		rc = tpm2_load_context(chip, space->context_buf, &offset,
+				       &space->context_tbl[i]);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static bool tpm2_map_to_phandle(struct tpm_space *space, void *handle)
+{
+	u32 vhandle = be32_to_cpup((__be32 *)handle);
+	u32 phandle;
+	int i;
+
+	i = 0xFFFFFF - (vhandle & 0xFFFFFF);
+	if (i > ARRAY_SIZE(space->context_tbl) || !space->context_tbl[i])
+		return false;
+
+	phandle = space->context_tbl[i];
+	*((__be32 *)handle) = cpu_to_be32(phandle);
+	return true;
+}
+
+static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd)
+{
+	struct tpm_space *space = &chip->work_space;
+	unsigned int nr_handles;
+	u32 attrs;
+	u32 *handle;
+	int i;
+
+	i = tpm2_find_cc(chip, cc);
+	if (i < 0)
+		return -EINVAL;
+
+	attrs = chip->cc_attrs_tbl[i];
+	nr_handles = (attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0);
+
+	handle = (u32 *)&cmd[TPM_HEADER_SIZE];
+	for (i = 0; i < nr_handles; i++, handle++) {
+		if ((be32_to_cpu(*handle) & 0xFF000000) == TPM2_HT_TRANSIENT) {
+			if (!tpm2_map_to_phandle(space, handle))
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
+		       u8 *cmd)
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
+	if (rc) {
+		tpm2_flush_space(chip);
+		return rc;
+	}
+
+	rc = tpm2_map_command(chip, cc, cmd);
+	if (rc) {
+		tpm2_flush_space(chip);
+		return rc;
+	}
+
+	return 0;
+}
+
+static u32 tpm2_map_to_vhandle(struct tpm_space *space, u32 phandle, bool alloc)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		if (alloc) {
+			if (!space->context_tbl[i]) {
+				space->context_tbl[i] = phandle;
+				break;
+			}
+		} else if (space->context_tbl[i] == phandle)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(space->context_tbl))
+		return 0;
+
+	return TPM2_HT_TRANSIENT | (0xFFFFFF - i);
+}
+
+static int tpm2_map_response_header(struct tpm_chip *chip, u32 cc, u8 *rsp,
+				    size_t len)
+{
+	struct tpm_space *space = &chip->work_space;
+	struct tpm_output_header *header = (void *)rsp;
+	u32 phandle;
+	u32 phandle_type;
+	u32 vhandle;
+	u32 attrs;
+	int i;
+
+	if (be32_to_cpu(header->return_code) != TPM2_RC_SUCCESS)
+		return 0;
+
+	i = tpm2_find_cc(chip, cc);
+	/* sanity check, should never happen */
+	if (i < 0)
+		return -EFAULT;
+
+	attrs = chip->cc_attrs_tbl[i];
+	if (!((attrs >> TPM2_CC_ATTR_RHANDLE) & 1))
+		return 0;
+
+	phandle = be32_to_cpup((__be32 *)&rsp[TPM_HEADER_SIZE]);
+	phandle_type = phandle & 0xFF000000;
+
+	switch (phandle_type) {
+	case TPM2_HT_TRANSIENT:
+		vhandle = tpm2_map_to_vhandle(space, phandle, true);
+		if (!vhandle)
+			goto out_no_slots;
+
+		*(__be32 *)&rsp[TPM_HEADER_SIZE] = cpu_to_be32(vhandle);
+		break;
+	case TPM2_HT_HMAC_SESSION:
+	case TPM2_HT_POLICY_SESSION:
+		break;
+	default:
+		dev_err(&chip->dev, "%s: unknown handle 0x%08X\n",
+			__func__, phandle);
+		break;
+	};
+
+	return 0;
+out_no_slots:
+	tpm2_flush_context_cmd(chip, phandle, TPM_TRANSMIT_UNLOCKED);
+	dev_warn(&chip->dev, "%s: out of slots for 0x%08X\n", __func__,
+		 phandle);
+	return -ENOMEM;
+}
+
+struct tpm2_cap_handles {
+	u8 more_data;
+	__be32 capability;
+	__be32 count;
+	__be32 handles[];
+} __packed;
+
+static int tpm2_map_response_body(struct tpm_chip *chip, u32 cc, u8 *rsp,
+				  size_t len)
+{
+	struct tpm_space *space = &chip->work_space;
+	struct tpm_output_header *header = (void *)rsp;
+	struct tpm2_cap_handles *data;
+	u32 phandle;
+	u32 phandle_type;
+	u32 vhandle;
+	int i;
+	int j;
+
+	if (cc != TPM2_CC_GET_CAPABILITY ||
+	    be32_to_cpu(header->return_code) != TPM2_RC_SUCCESS) {
+		return 0;
+	}
+
+	if (len < TPM_HEADER_SIZE + 9)
+		return -EFAULT;
+
+	data = (void *)&rsp[TPM_HEADER_SIZE];
+	if (be32_to_cpu(data->capability) != TPM2_CAP_HANDLES)
+		return 0;
+
+	if (len != TPM_HEADER_SIZE + 9 + 4 * be32_to_cpu(data->count))
+		return -EFAULT;
+
+	for (i = 0, j = 0; i < be32_to_cpu(data->count); i++) {
+		phandle = be32_to_cpup((__be32 *)&data->handles[i]);
+		phandle_type = phandle & 0xFF000000;
+
+		switch (phandle_type) {
+		case TPM2_HT_TRANSIENT:
+			vhandle = tpm2_map_to_vhandle(space, phandle, false);
+			if (!vhandle)
+				break;
+
+			data->handles[j] = cpu_to_be32(vhandle);
+			j++;
+			break;
+		case TPM2_HT_HMAC_SESSION:
+		case TPM2_HT_POLICY_SESSION:
+			data->handles[j] = cpu_to_be32(phandle);
+			j++;
+			break;
+		default:
+			dev_err(&chip->dev, "%s: unknown handle 0x%08X\n",
+				__func__, phandle);
+			break;
+		}
+
+	}
+
+	header->length = cpu_to_be32(TPM_HEADER_SIZE + 9 + 4 * j);
+	data->count = cpu_to_be32(j);
+	return 0;
+}
+
+static int tpm2_save_space(struct tpm_chip *chip)
+{
+	struct tpm_space *space = &chip->work_space;
+	unsigned int offset;
+	int i;
+	int rc;
+
+	for (i = 0, offset = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
+		if (!(space->context_tbl[i] && ~space->context_tbl[i]))
+			continue;
+
+		rc = tpm2_save_context(chip, space->context_tbl[i],
+				       space->context_buf, PAGE_SIZE,
+				       &offset);
+		if (rc == -ENOENT) {
+			space->context_tbl[i] = 0;
+			continue;
+		} else if (rc)
+			return rc;
+
+		space->context_tbl[i] = ~0;
+	}
+
+	return 0;
+}
+
+int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
+		      u32 cc, u8 *buf, size_t *bufsiz)
+{
+	struct tpm_output_header *header = (void *)buf;
+	int rc;
+
+	if (!space)
+		return 0;
+
+	rc = tpm2_map_response_header(chip, cc, buf, *bufsiz);
+	if (rc) {
+		tpm2_flush_space(chip);
+		return rc;
+	}
+
+	rc = tpm2_map_response_body(chip, cc, buf, *bufsiz);
+	if (rc) {
+		tpm2_flush_space(chip);
+		return rc;
+	}
+
+	rc = tpm2_save_space(chip);
+	if (rc) {
+		tpm2_flush_space(chip);
+		return rc;
+	}
+
+	*bufsiz = be32_to_cpu(header->length);
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
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
