From: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Subject: [RESEND][RFC] tpm_tis: broken on TPMs with a static
	burst count
Date: Wed, 4 Jan 2017 18:47:52 +0100
Message-ID: <77221b3a-40b3-f5db-e821-10e258f869dc@maciej.szmigiero.name>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

(Resending as no reply received, this time with CCs to TPM maintainers and
author of the original commit).

Hi all,

Commit 1107d065fdf1 (tpm_tis: Introduce intermediate layer for TPM access)
broke TPM support on ThinkPad X61S (and likely also on other machines which
use TPMs with a static burst count).

It looks like tpm_tis code before this commit had spun on TPM_STS_DATA_AVAIL |
TPM_STS_VALID status bits in the read case and TPM_STS_VALID in the write case
when it got a zero burst count.

I have attached a patch against current code (linux-tpmdd tree) that brings
back this old behavior.
With this patch the TPM works again on X61S.
However, somebody with more TPM experience should comment whether such behavior
was OK or the change brought by commit 1107d065fdf1 was intentional.

Maciej Szmigiero

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 7993678954a2..72d365db7c61 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -188,7 +188,9 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 		if (rc < 0)
 			return rc;
 		burstcnt = get_burstcount(chip);
-		if (burstcnt < 0) {
+		if (burstcnt == -EBUSY)
+			continue;
+		else if (burstcnt < 0) {
 			dev_err(&chip->dev, "Unable to read burstcount\n");
 			return burstcnt;
 		}
@@ -282,18 +284,20 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 
 	while (count < len - 1) {
 		burstcnt = get_burstcount(chip);
-		if (burstcnt < 0) {
+		if (burstcnt < 0 && burstcnt != -EBUSY) {
 			dev_err(&chip->dev, "Unable to read burstcount\n");
 			rc = burstcnt;
 			goto out_err;
+		} else if (burstcnt > 0) {
+			burstcnt = min_t(int, burstcnt, len - count - 1);
+			rc = tpm_tis_write_bytes(priv,
+						 TPM_DATA_FIFO(priv->locality),
+						 burstcnt, buf + count);
+			if (rc < 0)
+				goto out_err;
+
+			count += burstcnt;
 		}
-		burstcnt = min_t(int, burstcnt, len - count - 1);
-		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
-					 burstcnt, buf + count);
-		if (rc < 0)
-			goto out_err;
-
-		count += burstcnt;
 
 		if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 					&priv->int_queue, false) < 0) {

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
