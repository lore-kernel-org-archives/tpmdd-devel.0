From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix a race condition in tpm2_unseal_trusted()
Date: Sun, 28 Aug 2016 08:36:52 +0200
Message-ID: <1472366212-8571-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Unseal and load operations should be done as an atomic operation. This
commit introduces unlocked tpm_transmit() so that tpm2_unseal_trusted()
can do the locking by itself.

v2: Introduced an unlocked unseal operation instead of changing locking
    strategy in order to make less intrusive bug fix and thus more
    backportable.

v3: Have also separate __tpm_transmit() that takes 'flags' in order to
    better localize the bug fix and make it easier to backport.

v4: Cleaned up the control flow in tpm2_unseal_trusted. Added the
    missing 'Fixes' line.

v5: Previous versions did not set the enum to any value, so it was set
    to zero. Changed enum to TPM_TRANSMIT_UNLOCKED because it is
    guaranteed to catch such situation. With change the common case
    adds so little clutter that the wrappers do not make sense anymore.

Fixes: 0fe5480303a1 ("keys, trusted: seal/unseal with TPM 2.0 chips")
CC: stable@vger.kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-dev.c       |  2 +-
 drivers/char/tpm/tpm-interface.c | 51 ++++++++++++++++++++++------------------
 drivers/char/tpm/tpm-sysfs.c     |  2 +-
 drivers/char/tpm/tpm.h           | 12 ++++++----
 drivers/char/tpm/tpm2-cmd.c      | 34 ++++++++++++++++-----------
 5 files changed, 58 insertions(+), 43 deletions(-)

diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index f5d4521..912ad30 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -145,7 +145,7 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 		return -EPIPE;
 	}
 	out_size = tpm_transmit(priv->chip, priv->data_buffer,
-				sizeof(priv->data_buffer));
+				sizeof(priv->data_buffer), 0);
 
 	tpm_put_ops(priv->chip);
 	if (out_size < 0) {
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1abe2d7..aef20ee 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -330,8 +330,8 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 /*
  * Internal kernel interface to transmit TPM commands
  */
-ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-		     size_t bufsiz)
+ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
+		     unsigned int flags)
 {
 	ssize_t rc;
 	u32 count, ordinal;
@@ -350,7 +350,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		return -E2BIG;
 	}
 
-	mutex_lock(&chip->tpm_mutex);
+	if (!(flags & TPM_TRANSMIT_UNLOCKED))
+		mutex_lock(&chip->tpm_mutex);
 
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
@@ -393,20 +394,21 @@ out_recv:
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
-	mutex_unlock(&chip->tpm_mutex);
+	if (!(flags & TPM_TRANSMIT_UNLOCKED))
+		mutex_unlock(&chip->tpm_mutex);
 	return rc;
 }
 
 #define TPM_DIGEST_SIZE 20
 #define TPM_RET_CODE_IDX 6
 
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd,
-			 int len, const char *desc)
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
+			 int len, unsigned int flags, const char *desc)
 {
-	struct tpm_output_header *header;
+	const struct tpm_output_header *header;
 	int err;
 
-	len = tpm_transmit(chip, (u8 *) cmd, len);
+	len = tpm_transmit(chip, (const u8 *)cmd, len, flags);
 	if (len <  0)
 		return len;
 	else if (len < TPM_HEADER_SIZE)
@@ -453,7 +455,8 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = subcap_id;
 	}
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, desc);
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
+			      desc);
 	if (!rc)
 		*cap = tpm_cmd.params.getcap_out.cap;
 	return rc;
@@ -469,7 +472,7 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
 
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
 			      "attempting to determine the timeouts");
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
@@ -490,7 +493,7 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 	start_cmd.header.in = tpm_startup_header;
 
 	start_cmd.params.startup_in.startup_type = startup_type;
-	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
+	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
 				"attempting to start the TPM");
 }
 
@@ -521,7 +524,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
+			      NULL);
 
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
@@ -535,7 +539,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
 		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-				  NULL);
+				      0, NULL);
 	}
 	if (rc) {
 		dev_err(&chip->dev,
@@ -596,7 +600,7 @@ duration:
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
 
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
 			      "attempting to determine the durations");
 	if (rc)
 		return rc;
@@ -652,7 +656,7 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	struct tpm_cmd_t cmd;
 
 	cmd.header.in = continue_selftest_header;
-	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE, 0,
 			      "continue selftest");
 	return rc;
 }
@@ -672,7 +676,7 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE, 0,
 			      "attempting to read a pcr value");
 
 	if (rc == 0)
@@ -770,7 +774,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
 			      "attempting extend a PCR value");
 
 	tpm_put_ops(chip);
@@ -809,7 +813,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		/* Attempt to read a PCR value */
 		cmd.header.in = pcrread_header;
 		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
-		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
+		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE, 0);
 		/* Some buggy TPMs will not respond to tpm_tis_ready() for
 		 * around 300ms while the self test is ongoing, keep trying
 		 * until the self test duration expires. */
@@ -879,7 +883,7 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 	if (chip == NULL)
 		return -ENODEV;
 
-	rc = tpm_transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
+	rc = tpm_transmit_cmd(chip, cmd, buflen, 0, "attempting tpm_cmd");
 
 	tpm_put_ops(chip);
 	return rc;
@@ -981,14 +985,15 @@ int tpm_pm_suspend(struct device *dev)
 		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
 		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
 		       TPM_DIGEST_SIZE);
-		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
 				      "extending dummy pcr before suspend");
 	}
 
 	/* now do the actual savestate */
 	for (try = 0; try < TPM_RETRY; try++) {
 		cmd.header.in = savestate_header;
-		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, NULL);
+		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, 0,
+				      NULL);
 
 		/*
 		 * If the TPM indicates that it is too busy to respond to
@@ -1072,8 +1077,8 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
 
 		err = tpm_transmit_cmd(chip, &tpm_cmd,
-				   TPM_GETRANDOM_RESULT_SIZE + num_bytes,
-				   "attempting get random");
+				       TPM_GETRANDOM_RESULT_SIZE + num_bytes,
+				       0, "attempting get random");
 		if (err)
 			break;
 
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index b46cf70..e1f7236 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -39,7 +39,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
-	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
+	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE, 0,
 			       "attempting to read the PUBEK");
 	if (err)
 		goto out;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 3e32d5b..b0585e9 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -476,12 +476,16 @@ extern dev_t tpm_devt;
 extern const struct file_operations tpm_fops;
 extern struct idr dev_nums_idr;
 
+enum tpm_transmit_flags {
+	TPM_TRANSMIT_UNLOCKED	= BIT(0),
+};
+
+ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
+		     unsigned int flags);
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, int len,
+			 unsigned int flags, const char *desc);
 ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
 		   const char *desc);
-ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-		     size_t bufsiz);
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
-			 const char *desc);
 extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
 int tpm1_auto_startup(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 08c7e23..5452ba7 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -282,7 +282,7 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	       sizeof(cmd.params.pcrread_in.pcr_select));
 	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
 			      "attempting to read a pcr value");
 	if (rc == 0) {
 		buf = cmd.params.pcrread_out.digest;
@@ -330,7 +330,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
 	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
 	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
 			      "attempting extend a PCR value");
 
 	return rc;
@@ -376,7 +376,7 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 		cmd.header.in = tpm2_getrandom_header;
 		cmd.params.getrandom_in.size = cpu_to_be16(num_bytes);
 
-		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
 				       "attempting get random");
 		if (err)
 			break;
@@ -512,7 +512,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "sealing data");
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, "sealing data");
 	if (rc)
 		goto out;
 
@@ -576,7 +576,8 @@ static int tpm2_load(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "loading blob");
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_TRANSMIT_UNLOCKED,
+			      "loading blob");
 	if (!rc)
 		*blob_handle = be32_to_cpup(
 			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
@@ -604,7 +605,8 @@ static void tpm2_flush_context(struct tpm_chip *chip, u32 handle)
 
 	tpm_buf_append_u32(&buf, handle);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "flushing context");
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_TRANSMIT_UNLOCKED,
+			      "flushing context");
 	if (rc)
 		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
 			 rc);
@@ -635,7 +637,8 @@ static int tpm2_unseal(struct tpm_chip *chip,
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "unsealing");
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_TRANSMIT_UNLOCKED,
+			      "unsealing");
 	if (rc > 0)
 		rc = -EPERM;
 
@@ -668,14 +671,17 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
 	u32 blob_handle;
 	int rc;
 
+	mutex_lock(&chip->tpm_mutex);
 	rc = tpm2_load(chip, payload, options, &blob_handle);
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = tpm2_unseal(chip, payload, options, blob_handle);
 
 	tpm2_flush_context(chip, blob_handle);
 
+out:
+	mutex_unlock(&chip->tpm_mutex);
 	return rc;
 }
 
@@ -701,7 +707,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(property_id);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), desc);
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, desc);
 	if (!rc)
 		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);
 
@@ -735,7 +741,7 @@ static int tpm2_startup(struct tpm_chip *chip, u16 startup_type)
 	cmd.header.in = tpm2_startup_header;
 
 	cmd.params.startup_in.startup_type = cpu_to_be16(startup_type);
-	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
 				"attempting to start the TPM");
 }
 
@@ -763,7 +769,7 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
 	cmd.header.in = tpm2_shutdown_header;
 	cmd.params.startup_in.startup_type = cpu_to_be16(shutdown_type);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), "stopping the TPM");
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, "stopping the TPM");
 
 	/* In places where shutdown command is sent there's no much we can do
 	 * except print the error code on a system failure.
@@ -828,7 +834,7 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
 	cmd.header.in = tpm2_selftest_header;
 	cmd.params.selftest_in.full_test = full;
 
-	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE,
+	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE, 0,
 			      "continue selftest");
 
 	/* At least some prototype chips seem to give RC_TESTING error
@@ -880,7 +886,7 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 		cmd.params.pcrread_in.pcr_select[1] = 0x00;
 		cmd.params.pcrread_in.pcr_select[2] = 0x00;
 
-		rc = tpm_transmit_cmd(chip, (u8 *) &cmd, sizeof(cmd), NULL);
+		rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, NULL);
 		if (rc < 0)
 			break;
 
@@ -928,7 +934,7 @@ int tpm2_probe(struct tpm_chip *chip)
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit(chip, (const char *) &cmd, sizeof(cmd));
+	rc = tpm_transmit(chip, (const u8 *)&cmd, sizeof(cmd), 0);
 	if (rc <  0)
 		return rc;
 	else if (rc < TPM_HEADER_SIZE)
-- 
2.7.4

