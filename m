From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 1/7] tpm: move length validation to
	tpm_transmit()
Date: Thu, 16 Feb 2017 21:25:14 +0200
Message-ID: <20170216192529.25467-2-jarkko.sakkinen@linux.intel.com>
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

Check that the length matches the length reported by the response
header already in tpm_transmit() to improve validation.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index bd2128e..708d356 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -343,6 +343,7 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 		     unsigned int flags)
 {
+	const struct tpm_output_header *header = (void *)buf;
 	ssize_t rc;
 	u32 count, ordinal;
 	unsigned long stop;
@@ -406,9 +407,18 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 
 out_recv:
 	rc = chip->ops->recv(chip, (u8 *) buf, bufsiz);
-	if (rc < 0)
+	if (rc < 0) {
 		dev_err(&chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
+		goto out;
+	} else if (rc < TPM_HEADER_SIZE) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (rc != be32_to_cpu(header->length))
+		goto out;
+
 out:
 	if (chip->dev.parent)
 		pm_runtime_put_sync(chip->dev.parent);
@@ -438,19 +448,13 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf,
 			 size_t bufsiz, size_t min_rsp_body_length,
 			 unsigned int flags, const char *desc)
 {
-	const struct tpm_output_header *header;
+	const struct tpm_output_header *header = buf;
 	int err;
 	ssize_t len;
 
 	len = tpm_transmit(chip, (const u8 *)buf, bufsiz, flags);
 	if (len <  0)
 		return len;
-	else if (len < TPM_HEADER_SIZE)
-		return -EFAULT;
-
-	header = buf;
-	if (len != be32_to_cpu(header->length))
-		return -EFAULT;
 
 	err = be32_to_cpu(header->return_code);
 	if (err != 0 && desc)
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
