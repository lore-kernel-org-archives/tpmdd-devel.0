From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: fix tpm_transmit() parameters
Date: Tue,  5 Apr 2016 17:23:41 +0300
Message-ID: <1459866221-20052-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Changed the type of 'buf' from 'const char *' to 'u8*' because the
contents of the 'buf' get modified by the function and to better match
the API in struct tpm_class_ops. Renamed 'bufsize' to 'len' in order to
better match the API in struct tpm_class_ops.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 15 +++++++--------
 drivers/char/tpm/tpm.h           |  3 +--
 drivers/char/tpm/tpm2-cmd.c      |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 316c784..c82f31f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -330,29 +330,28 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 /*
  * Internal kernel interface to transmit TPM commands
  */
-ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-		     size_t bufsiz)
+ssize_t tpm_transmit(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	ssize_t rc;
 	u32 count, ordinal;
 	unsigned long stop;
 
-	if (bufsiz > TPM_BUFSIZE)
-		bufsiz = TPM_BUFSIZE;
+	if (len > TPM_BUFSIZE)
+		len = TPM_BUFSIZE;
 
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)
 		return -ENODATA;
-	if (count > bufsiz) {
+	if (count > len) {
 		dev_err(&chip->dev,
-			"invalid count value %x %zx\n", count, bufsiz);
+			"invalid count value %x %zx\n", count, len);
 		return -E2BIG;
 	}
 
 	mutex_lock(&chip->tpm_mutex);
 
-	rc = chip->ops->send(chip, (u8 *) buf, count);
+	rc = chip->ops->send(chip, buf, count);
 	if (rc < 0) {
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_send: error %zd\n", rc);
@@ -388,7 +387,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	goto out;
 
 out_recv:
-	rc = chip->ops->recv(chip, (u8 *) buf, bufsiz);
+	rc = chip->ops->recv(chip, buf, len);
 	if (rc < 0)
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 154984b..4126b04 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -472,8 +472,7 @@ extern const struct file_operations tpm_fops;
 extern struct idr dev_nums_idr;
 
 ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
-ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-		     size_t bufsiz);
+ssize_t tpm_transmit(struct tpm_chip *chip, u8 *buf, size_t len);
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
 			 const char *desc);
 extern int tpm_get_timeouts(struct tpm_chip *);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 552b3ee..8f47206 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -921,7 +921,7 @@ int tpm2_probe(struct tpm_chip *chip)
 	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
 	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
-	rc = tpm_transmit(chip, (const char *) &cmd, sizeof(cmd));
+	rc = tpm_transmit(chip, (u8 *) &cmd, sizeof(cmd));
 	if (rc <  0)
 		return rc;
 	else if (rc < TPM_HEADER_SIZE)
-- 
2.7.4


------------------------------------------------------------------------------
