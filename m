From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v6] tpm: Check size of response before accessing data
Date: Mon, 16 Jan 2017 16:41:11 -0500
Message-ID: <1484602871-20145-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, jarkko.sakkinen@linux.intel.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Make sure that we have not received less bytes than what is indicated
in the header of the TPM response. Also, check the number of bytes in
the response before accessing its data.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---

v6:
 - Fixed comparsion of size_t with negative number in transmit_cmd
 - Added new min_rx_length parameter to documentation
 - Reworked error checking in tpm_transmit_cmd to check for TPM
   error and return that before validating expected minimum size.

v5:
 - Fixed a bug related to tpm_getcap() having to allow to return
   only a header rather than having to receive a full response
---
 drivers/char/tpm/tpm-interface.c | 70 +++++++++++++++++++++++++-----------
 drivers/char/tpm/tpm-sysfs.c     | 29 +++++++++------
 drivers/char/tpm/tpm.h           |  7 ++--
 drivers/char/tpm/tpm2-cmd.c      | 76 +++++++++++++++++++++++++++++-----------
 drivers/char/tpm/tpm_tis_core.c  |  3 +-
 5 files changed, 131 insertions(+), 54 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index fecdd3f..78ec5b7 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -424,7 +424,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
  *
  * @chip: TPM chip to use
  * @cmd: TPM command buffer
- * @len: length of the TPM command
+ * @cmd_length: length of the TPM command
+ * @min_rx_length: minimum expected length of response
  * @flags: tpm transmit flags - bitmap
  * @desc: command description used in the error message
  *
@@ -434,25 +435,34 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
  *     A positive number for a TPM error.
  */
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
-			 int len, unsigned int flags, const char *desc)
+			 size_t cmd_length, size_t min_rx_length,
+			 unsigned int flags, const char *desc)
 {
 	const struct tpm_output_header *header;
 	int err;
+	ssize_t len;
 
-	len = tpm_transmit(chip, (const u8 *)cmd, len, flags);
+	len = tpm_transmit(chip, (const u8 *)cmd, cmd_length, flags);
 	if (len <  0)
 		return len;
 	else if (len < TPM_HEADER_SIZE)
 		return -EFAULT;
 
 	header = cmd;
+	if (len < be32_to_cpu(header->length))
+		return -EFAULT;
 
 	err = be32_to_cpu(header->return_code);
 	if (err != 0 && desc)
 		dev_err(&chip->dev, "A TPM error (%d) occurred %s\n", err,
 			desc);
+	if (err)
+		return err;
 
-	return err;
+	if (be32_to_cpu(header->length) < min_rx_length)
+		return -EFAULT;
+
+	return 0;
 }
 
 #define TPM_DIGEST_SIZE 20
@@ -468,7 +478,7 @@ static const struct tpm_input_header tpm_getcap_header = {
 };
 
 ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
-		   const char *desc)
+		   const char *desc, size_t min_cap_length)
 {
 	struct tpm_cmd_t tpm_cmd;
 	int rc;
@@ -491,8 +501,8 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
 		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
 	}
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
-			      desc);
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+			      TPM_HEADER_SIZE + min_cap_length, 0, desc);
 	if (!rc)
 		*cap = tpm_cmd.params.getcap_out.cap;
 	return rc;
@@ -515,7 +525,8 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 	start_cmd.header.in = tpm_startup_header;
 
 	start_cmd.params.startup_in.startup_type = startup_type;
-	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
+	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
+				TPM_HEADER_SIZE, 0,
 				"attempting to start the TPM");
 }
 
@@ -546,7 +557,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		return 0;
 	}
 
-	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL);
+	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL,
+			sizeof(cap.timeout));
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
 		   Execute a startup command. */
@@ -555,8 +567,10 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 			return rc;
 
 		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
-				"attempting to determine the timeouts");
+				"attempting to determine the timeouts",
+				sizeof(cap.timeout));
 	}
+
 	if (rc) {
 		dev_err(&chip->dev,
 			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
@@ -606,7 +620,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	chip->timeout_d = usecs_to_jiffies(new_timeout[3]);
 
 	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_DURATION, &cap,
-			"attempting to determine the durations");
+			"attempting to determine the durations",
+			sizeof(cap.duration));
 	if (rc)
 		return rc;
 
@@ -657,8 +672,9 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	struct tpm_cmd_t cmd;
 
 	cmd.header.in = continue_selftest_header;
-	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE, 0,
-			      "continue selftest");
+	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
+			      CONTINUE_SELFTEST_RESULT_SIZE,
+			      0, "continue selftest");
 	return rc;
 }
 
@@ -677,7 +693,9 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE, 0,
+	rc = tpm_transmit_cmd(chip, &cmd,
+			      READ_PCR_RESULT_SIZE,
+			      READ_PCR_RESULT_SIZE, 0,
 			      "attempting to read a pcr value");
 
 	if (rc == 0)
@@ -775,7 +793,8 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	cmd.header.in = pcrextend_header;
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
+	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+			      EXTEND_PCR_RESULT_SIZE, 0,
 			      "attempting extend a PCR value");
 
 	tpm_put_ops(chip);
@@ -879,7 +898,8 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 	if (chip == NULL)
 		return -ENODEV;
 
-	rc = tpm_transmit_cmd(chip, cmd, buflen, 0, "attempting tpm_cmd");
+	rc = tpm_transmit_cmd(chip, cmd, buflen, TPM_HEADER_SIZE,
+			      0, "attempting tpm_cmd");
 
 	tpm_put_ops(chip);
 	return rc;
@@ -981,15 +1001,16 @@ int tpm_pm_suspend(struct device *dev)
 		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
 		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
 		       TPM_DIGEST_SIZE);
-		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
+		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+				     EXTEND_PCR_RESULT_SIZE, 0,
 				      "extending dummy pcr before suspend");
 	}
 
 	/* now do the actual savestate */
 	for (try = 0; try < TPM_RETRY; try++) {
 		cmd.header.in = savestate_header;
-		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, 0,
-				      NULL);
+		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE,
+				      SAVESTATE_RESULT_SIZE, 0, NULL);
 
 		/*
 		 * If the TPM indicates that it is too busy to respond to
@@ -1051,7 +1072,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 {
 	struct tpm_chip *chip;
 	struct tpm_cmd_t tpm_cmd;
-	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA);
+	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA), rlength;
 	int err, total = 0, retries = 5;
 	u8 *dest = out;
 
@@ -1074,11 +1095,20 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 
 		err = tpm_transmit_cmd(chip, &tpm_cmd,
 				       TPM_GETRANDOM_RESULT_SIZE + num_bytes,
+				       offsetof(struct tpm_cmd_t,
+						params.getrandom_out.rng_data),
 				       0, "attempting get random");
 		if (err)
 			break;
 
 		recd = be32_to_cpu(tpm_cmd.params.getrandom_out.rng_data_len);
+
+		rlength = be32_to_cpu(tpm_cmd.header.out.length);
+		if (rlength < offsetof(struct tpm_cmd_t,
+				       params.getrandom_out.rng_data) + recd) {
+			total = -EFAULT;
+			break;
+		}
 		memcpy(dest, tpm_cmd.params.getrandom_out.rng_data, recd);
 
 		dest += recd;
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 848ad65..ea1293e 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -39,8 +39,9 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
-	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE, 0,
-			       "attempting to read the PUBEK");
+	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
+			       TPM_HEADER_SIZE + 28 + 256,
+			       0, "attempting to read the PUBEK");
 	if (err)
 		goto out;
 
@@ -95,7 +96,8 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	rc = tpm_getcap(chip, TPM_CAP_PROP_PCR, &cap,
-			"attempting to determine the number of PCRS");
+			"attempting to determine the number of PCRS",
+			sizeof(cap.num_pcrs));
 	if (rc)
 		return 0;
 
@@ -120,7 +122,8 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 
 	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
-			"attempting to determine the permanent enabled state");
+			"attempting to determine the permanent enabled state",
+			sizeof(cap.perm_flags));
 	if (rc)
 		return 0;
 
@@ -136,7 +139,8 @@ static ssize_t active_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 
 	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
-			"attempting to determine the permanent active state");
+			"attempting to determine the permanent active state",
+			sizeof(cap.perm_flags));
 	if (rc)
 		return 0;
 
@@ -152,7 +156,8 @@ static ssize_t owned_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 
 	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_PROP_OWNER, &cap,
-			"attempting to determine the owner state");
+			"attempting to determine the owner state",
+			sizeof(cap.owned));
 	if (rc)
 		return 0;
 
@@ -168,7 +173,8 @@ static ssize_t temp_deactivated_show(struct device *dev,
 	ssize_t rc;
 
 	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_VOL, &cap,
-			"attempting to determine the temporary state");
+			"attempting to determine the temporary state",
+			sizeof(cap.stclear_flags));
 	if (rc)
 		return 0;
 
@@ -186,7 +192,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 	char *str = buf;
 
 	rc = tpm_getcap(chip, TPM_CAP_PROP_MANUFACTURER, &cap,
-			"attempting to determine the manufacturer");
+			"attempting to determine the manufacturer",
+			sizeof(cap.manufacturer_id));
 	if (rc)
 		return 0;
 	str += sprintf(str, "Manufacturer: 0x%x\n",
@@ -194,7 +201,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 
 	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
 	rc = tpm_getcap(chip, TPM_CAP_VERSION_1_2, &cap,
-			"attempting to determine the 1.2 version");
+			"attempting to determine the 1.2 version",
+			sizeof(cap.tpm_version_1_2));
 	if (!rc) {
 		str += sprintf(str,
 			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
@@ -205,7 +213,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 	} else {
 		/* Otherwise just use TPM_STRUCT_VER */
 		rc = tpm_getcap(chip, TPM_CAP_VERSION_1_1, &cap,
-				"attempting to determine the 1.1 version");
+				"attempting to determine the 1.1 version",
+				sizeof(cap.tpm_version));
 		if (rc)
 			return 0;
 		str += sprintf(str,
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 1ae9768..9e81865 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -493,10 +493,11 @@ enum tpm_transmit_flags {
 
 ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 		     unsigned int flags);
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, int len,
-			 unsigned int flags, const char *desc);
+ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, size_t len,
+			 size_t min_tx_length, unsigned int flags,
+			 const char *desc);
 ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
-		   const char *desc);
+		   const char *desc, size_t min_cap_length);
 int tpm_get_timeouts(struct tpm_chip *);
 int tpm1_auto_startup(struct tpm_chip *chip);
 int tpm_do_selftest(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 6eda239..9e8256b 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -248,6 +248,10 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
 	(sizeof(struct tpm_input_header) + \
 	 sizeof(struct tpm2_pcr_read_in))
 
+#define TPM2_PCR_READ_OUT_SIZE \
+	(sizeof(struct tpm_output_header) + \
+	 sizeof(struct tpm2_pcr_read_out))
+
 static const struct tpm_input_header tpm2_pcrread_header = {
 	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
 	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
@@ -280,8 +284,8 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	       sizeof(cmd.params.pcrread_in.pcr_select));
 	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
-			      "attempting to read a pcr value");
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM2_PCR_READ_OUT_SIZE,
+			      0, "attempting to read a pcr value");
 	if (rc == 0) {
 		buf = cmd.params.pcrread_out.digest;
 		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
@@ -327,7 +331,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
 	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
 	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE, 0,
 			      "attempting extend a PCR value");
 
 	return rc;
@@ -356,7 +360,7 @@ static const struct tpm_input_header tpm2_getrandom_header = {
 int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 {
 	struct tpm2_cmd cmd;
-	u32 recd;
+	u32 recd, rlength;
 	u32 num_bytes;
 	int err;
 	int total = 0;
@@ -373,13 +377,19 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 		cmd.header.in = tpm2_getrandom_header;
 		cmd.params.getrandom_in.size = cpu_to_be16(num_bytes);
 
-		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
-				       "attempting get random");
+		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+				       offsetof(struct tpm2_cmd,
+						params.getrandom_out.buffer),
+				       0, "attempting get random");
 		if (err)
 			break;
 
 		recd = min_t(u32, be16_to_cpu(cmd.params.getrandom_out.size),
 			     num_bytes);
+		rlength = be32_to_cpu(cmd.header.out.length);
+		if (rlength < offsetof(struct tpm2_cmd,
+				       params.getrandom_out.buffer) + recd)
+			return -EFAULT;
 		memcpy(dest, cmd.params.getrandom_out.buffer, recd);
 
 		dest += recd;
@@ -394,6 +404,10 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
 	(sizeof(struct tpm_input_header) + \
 	 sizeof(struct tpm2_get_tpm_pt_in))
 
+#define TPM2_GET_TPM_PT_OUT_SIZE \
+	(sizeof(struct tpm_output_header) + \
+	 sizeof(struct tpm2_get_tpm_pt_out))
+
 static const struct tpm_input_header tpm2_get_tpm_pt_header = {
 	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
 	.length = cpu_to_be32(TPM2_GET_TPM_PT_IN_SIZE),
@@ -445,7 +459,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 {
 	unsigned int blob_len;
 	struct tpm_buf buf;
-	u32 hash;
+	u32 hash, rlength;
 	int i;
 	int rc;
 
@@ -510,7 +524,9 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, "sealing data");
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE,
+			      TPM_HEADER_SIZE + 4,
+			      0, "sealing data");
 	if (rc)
 		goto out;
 
@@ -519,6 +535,11 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		rc = -E2BIG;
 		goto out;
 	}
+	rlength = be32_to_cpu(((struct tpm2_cmd *)&buf)->header.out.length);
+	if (rlength < TPM_HEADER_SIZE + 4 + blob_len) {
+		rc = -EFAULT;
+		goto out;
+	}
 
 	memcpy(payload->blob, &buf.data[TPM_HEADER_SIZE + 4], blob_len);
 	payload->blob_len = blob_len;
@@ -588,7 +609,8 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags, "loading blob");
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE,
+			      TPM_HEADER_SIZE + 4, flags, "loading blob");
 	if (!rc)
 		*blob_handle = be32_to_cpup(
 			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
@@ -626,8 +648,8 @@ static void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
 
 	tpm_buf_append_u32(&buf, handle);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags,
-			      "flushing context");
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_HEADER_SIZE,
+			      flags, "flushing context");
 	if (rc)
 		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
 			 rc);
@@ -657,6 +679,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	u16 data_len;
 	u8 *data;
 	int rc;
+	u32 rlength;
 
 	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
 	if (rc)
@@ -671,13 +694,21 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags, "unsealing");
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE,
+			      TPM_HEADER_SIZE + 4 + 2, flags, "unsealing");
 	if (rc > 0)
 		rc = -EPERM;
 
 	if (!rc) {
 		data_len = be16_to_cpup(
 			(__be16 *) &buf.data[TPM_HEADER_SIZE + 4]);
+
+		rlength = be32_to_cpu(((struct tpm2_cmd *)&buf)
+					->header.out.length);
+		if (rlength < TPM_HEADER_SIZE + 4 + 2 + data_len) {
+			rc = -EFAULT;
+			goto out;
+		}
 		data = &buf.data[TPM_HEADER_SIZE + 6];
 
 		memcpy(payload->key, data, data_len - 1);
@@ -685,6 +716,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 		payload->migratable = data[data_len - 1];
 	}
 
+out:
 	tpm_buf_destroy(&buf);
 	return rc;
 }
@@ -739,7 +771,8 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(property_id);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, desc);
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
+			      TPM2_GET_TPM_PT_OUT_SIZE, 0, desc);
 	if (!rc)
 		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);
 
@@ -773,8 +806,8 @@ static int tpm2_startup(struct tpm_chip *chip, u16 startup_type)
 	cmd.header.in = tpm2_startup_header;
 
 	cmd.params.startup_in.startup_type = cpu_to_be16(startup_type);
-	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
-				"attempting to start the TPM");
+	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
+				0, "attempting to start the TPM");
 }
 
 #define TPM2_SHUTDOWN_IN_SIZE \
@@ -802,7 +835,8 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
 	cmd.header.in = tpm2_shutdown_header;
 	cmd.params.startup_in.startup_type = cpu_to_be16(shutdown_type);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, "stopping the TPM");
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
+			      0, "stopping the TPM");
 
 	/* In places where shutdown command is sent there's no much we can do
 	 * except print the error code on a system failure.
@@ -865,8 +899,8 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
 	cmd.header.in = tpm2_selftest_header;
 	cmd.params.selftest_in.full_test = full;
 
-	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE, 0,
-			      "continue selftest");
+	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE,
+			      TPM_HEADER_SIZE, 0, "continue selftest");
 
 	/* At least some prototype chips seem to give RC_TESTING error
 	 * immediately. This is a workaround for that.
@@ -916,7 +950,8 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 		cmd.params.pcrread_in.pcr_select[1] = 0x00;
 		cmd.params.pcrread_in.pcr_select[2] = 0x00;
 
-		rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, NULL);
+		rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
+				      0, NULL);
 		if (rc < 0)
 			break;
 
@@ -949,7 +984,8 @@ int tpm2_probe(struct tpm_chip *chip)
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),  0, NULL);
+	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), TPM_HEADER_SIZE,
+			      0, NULL);
 	if (rc <  0)
 		return rc;
 
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 7993678..025ddb5 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -552,7 +552,8 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
 	else
-		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
+		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc,
+				  0, NULL);
 }
 
 /* Register the IRQ and issue a command that will cause an interrupt. If an
-- 
2.4.3

