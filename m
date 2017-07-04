From: Alexander Steffen <Alexander.Steffen@infineon.com>
Subject: [PATCH 1/2] tpm-dev-common: Reject too short writes
Date: Tue, 4 Jul 2017 15:54:18 +0200
Message-ID: <20170704135419.1692-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: Alexander Steffen <Alexander.Steffen@infineon.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

tpm_common_write() in tpm-dev-common.c discards the information how much
data has actually been written to the buffer. Instead, all other code has
to rely on the commandSize field in the TPM command header to figure out
how many valid bytes are supposed to be in the buffer.

But there is nothing that enforces the value in the header to match the
actual buffer contents. So by claiming a larger size in the header than
has been written, stale buffer contents are sent to the TPM. With this
commit, this problem is detected and rejected accordingly.

This should have been fixed with CVE-2011-1161 long ago, but apparently
a correct version of that patch never made it into the kernel.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
---
 drivers/char/tpm/tpm-dev-common.c | 2 +-
 drivers/char/tpm/tpm-interface.c  | 9 ++++++---
 drivers/char/tpm/tpm.h            | 3 ++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index 610638a..c39b581 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -119,7 +119,7 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
 		return -EPIPE;
 	}
 	out_size = tpm_transmit(priv->chip, space, priv->data_buffer,
-				sizeof(priv->data_buffer), 0);
+				sizeof(priv->data_buffer), in_size, 0);
 
 	tpm_put_ops(priv->chip);
 	if (out_size < 0) {
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 3123a6e..a452cd0 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -375,6 +375,7 @@ static bool tpm_validate_command(struct tpm_chip *chip,
  * @chip: TPM chip to use
  * @buf: TPM command buffer
  * @bufsiz: length of the TPM command buffer
+ * @bufvalid: number of valid bytes in the TPM command buffer
  * @flags: tpm transmit flags - bitmap
  *
  * Return:
@@ -382,7 +383,8 @@ static bool tpm_validate_command(struct tpm_chip *chip,
  *     A negative number for system errors (errno).
  */
 ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
-		     u8 *buf, size_t bufsiz, unsigned int flags)
+		     u8 *buf, size_t bufsiz, size_t bufvalid,
+		     unsigned int flags)
 {
 	struct tpm_output_header *header = (void *)buf;
 	int rc;
@@ -401,7 +403,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)
 		return -ENODATA;
-	if (count > bufsiz) {
+	if (count > bufsiz || count > bufvalid) {
 		dev_err(&chip->dev,
 			"invalid count value %x %zx\n", count, bufsiz);
 		return -E2BIG;
@@ -522,7 +524,8 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
 	int err;
 	ssize_t len;
 
-	len = tpm_transmit(chip, space, (u8 *)buf, bufsiz, flags);
+	len = tpm_transmit(chip, space, (u8 *)buf, bufsiz,
+			   be32_to_cpu(header->length), flags);
 	if (len <  0)
 		return len;
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 71d661a..116f2b8 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -509,7 +509,8 @@ enum tpm_transmit_flags {
 };
 
 ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
-		     u8 *buf, size_t bufsiz, unsigned int flags);
+		     u8 *buf, size_t bufsiz, size_t bufvalid,
+		     unsigned int flags);
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
 			 const void *buf, size_t bufsiz,
 			 size_t min_rsp_body_length, unsigned int flags,
-- 
2.7.4
