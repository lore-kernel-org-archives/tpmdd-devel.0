From: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND 1/2] tpm-dev-common: Reject too short
 writes
Date: Thu, 24 Aug 2017 10:35:44 +0200
Message-ID: <20170824083545.13280-2-Alexander.Steffen@infineon.com>
References: <20170824083545.13280-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170824083545.13280-1-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
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
index 1d6729b..78fb41d 100644
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
index 2d5466a..a020eca 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -511,7 +511,8 @@ enum tpm_transmit_flags {
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


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
