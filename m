From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v4 1/2] tpm: Refactor tpm_transmit pulling out tpm_transfer function
Date: Wed, 10 May 2017 19:54:21 -0400
Message-ID: <1494460462-29022-2-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1494460462-29022-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494460462-29022-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com
Cc: jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Refactor tpm_transmit and pull out code sending the command
and receiving the response and put this into tpm_transfer.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm-interface.c | 121 +++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 48 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 158c1db..263b6d1 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -370,67 +370,29 @@ static bool tpm_validate_command(struct tpm_chip *chip,
 }
 
 /**
- * tmp_transmit - Internal kernel interface to transmit TPM commands.
+ * tmp_transfer - Send a TPM command to the TPM and receive response
  *
  * @chip: TPM chip to use
  * @buf: TPM command buffer
+ * @count: size of the TPM command
  * @bufsiz: length of the TPM command buffer
- * @flags: tpm transmit flags - bitmap
  *
  * Return:
- *     0 when the operation is successful.
+ *     >0 when the operation is successful; returns response length
  *     A negative number for system errors (errno).
  */
-ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
-		     u8 *buf, size_t bufsiz, unsigned int flags)
+ssize_t tpm_transfer(struct tpm_chip *chip, u8 *buf, u32 count, size_t bufsiz)
 {
-	struct tpm_output_header *header = (void *)buf;
 	int rc;
+	struct tpm_output_header *header = (void *)buf;
+	u32 ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	ssize_t len = 0;
-	u32 count, ordinal;
 	unsigned long stop;
-	bool need_locality;
-
-	if (!tpm_validate_command(chip, space, buf, bufsiz))
-		return -EINVAL;
-
-	if (bufsiz > TPM_BUFSIZE)
-		bufsiz = TPM_BUFSIZE;
-
-	count = be32_to_cpu(*((__be32 *) (buf + 2)));
-	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
-	if (count == 0)
-		return -ENODATA;
-	if (count > bufsiz) {
-		dev_err(&chip->dev,
-			"invalid count value %x %zx\n", count, bufsiz);
-		return -E2BIG;
-	}
-
-	if (!(flags & TPM_TRANSMIT_UNLOCKED))
-		mutex_lock(&chip->tpm_mutex);
-
-	if (chip->dev.parent)
-		pm_runtime_get_sync(chip->dev.parent);
-
-	/* Store the decision as chip->locality will be changed. */
-	need_locality = chip->locality == -1;
-
-	if (need_locality && chip->ops->request_locality)  {
-		rc = chip->ops->request_locality(chip, 0);
-		if (rc < 0)
-			goto out_no_locality;
-		chip->locality = rc;
-	}
-
-	rc = tpm2_prepare_space(chip, space, ordinal, buf);
-	if (rc)
-		goto out;
 
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
 		dev_err(&chip->dev,
-			"tpm_transmit: tpm_send: error %d\n", rc);
+			"tpm_transfer: tpm_send: error %d\n", rc);
 		goto out;
 	}
 
@@ -467,18 +429,81 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	if (len < 0) {
 		rc = len;
 		dev_err(&chip->dev,
-			"tpm_transmit: tpm_recv: error %d\n", rc);
+			"tpm_transfer: tpm_recv: error %d\n", rc);
 		goto out;
 	} else if (len < TPM_HEADER_SIZE) {
 		rc = -EFAULT;
 		goto out;
 	}
 
-	if (len != be32_to_cpu(header->length)) {
+	if (len != be32_to_cpu(header->length))
 		rc = -EFAULT;
-		goto out;
+
+out:
+	return rc ? rc : len;
+}
+EXPORT_SYMBOL_GPL(tpm_transfer);
+
+/**
+ * tmp_transmit - Internal kernel interface to transmit TPM commands.
+ *
+ * @chip: TPM chip to use
+ * @buf: TPM command buffer
+ * @bufsiz: length of the TPM command buffer
+ * @flags: tpm transmit flags - bitmap
+ *
+ * Return:
+ *     0 when the operation is successful.
+ *     A negative number for system errors (errno).
+ */
+ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
+		     u8 *buf, size_t bufsiz, unsigned int flags)
+{
+	int rc;
+	ssize_t len = 0;
+	u32 count, ordinal;
+	bool need_locality;
+
+	if (!tpm_validate_command(chip, space, buf, bufsiz))
+		return -EINVAL;
+
+	if (bufsiz > TPM_BUFSIZE)
+		bufsiz = TPM_BUFSIZE;
+
+	count = be32_to_cpu(*((__be32 *) (buf + 2)));
+	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+	if (count == 0)
+		return -ENODATA;
+	if (count > bufsiz) {
+		dev_err(&chip->dev,
+			"invalid count value %x %zx\n", count, bufsiz);
+		return -E2BIG;
+	}
+
+	if (!(flags & TPM_TRANSMIT_UNLOCKED))
+		mutex_lock(&chip->tpm_mutex);
+
+	if (chip->dev.parent)
+		pm_runtime_get_sync(chip->dev.parent);
+
+	/* Store the decision as chip->locality will be changed. */
+	need_locality = chip->locality == -1;
+
+	if (need_locality && chip->ops->request_locality)  {
+		rc = chip->ops->request_locality(chip, 0);
+		if (rc < 0)
+			goto out_no_locality;
+		chip->locality = rc;
 	}
 
+	rc = tpm2_prepare_space(chip, space, ordinal, buf);
+	if (rc)
+		goto out;
+
+	len = tpm_transfer(chip, buf, count, bufsiz);
+	if (len < 0)
+		goto out;
+
 	rc = tpm2_commit_space(chip, space, ordinal, buf, &len);
 
 out:
-- 
2.4.3
