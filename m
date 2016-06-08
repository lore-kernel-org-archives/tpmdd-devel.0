From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 2/4] tpm: Add optional logging of TPM
	command durations
Date: Wed,  8 Jun 2016 16:00:16 -0700
Message-ID: <1465426818-89356-3-git-send-email-eswierk@skyportsystems.com>
References: <1465346740-60120-1-git-send-email-eswierk@skyportsystems.com>
	<1465426818-89356-1-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1465426818-89356-1-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Some TPMs violate their own advertised command durations. This is much
easier to debug with data about how long each command actually takes
to complete. Add debug messages that can be enabled by running

  echo -n 'module tpm +p' >/sys/kernel/debug/dynamic_debug/control

on a kernel configured with DYNAMIC_DEBUG=y.

Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index c50637d..cc1e5bc 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -333,13 +333,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 {
 	ssize_t rc;
 	u32 count, ordinal;
-	unsigned long stop;
+	unsigned long start, stop;
 
 	if (bufsiz > TPM_BUFSIZE)
 		bufsiz = TPM_BUFSIZE;
 
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+	dev_dbg(chip->pdev, "starting command %d count %d\n", ordinal, count);
 	if (count == 0)
 		return -ENODATA;
 	if (count > bufsiz) {
@@ -360,18 +361,24 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	if (chip->vendor.irq)
 		goto out_recv;
 
+	start = jiffies;
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		stop = jiffies + tpm2_calc_ordinal_duration(chip, ordinal);
+		stop = start + tpm2_calc_ordinal_duration(chip, ordinal);
 	else
-		stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
+		stop = start + tpm_calc_ordinal_duration(chip, ordinal);
 	do {
 		u8 status = chip->ops->status(chip);
 		if ((status & chip->ops->req_complete_mask) ==
-		    chip->ops->req_complete_val)
+		    chip->ops->req_complete_val) {
+			dev_dbg(chip->pdev, "completed command %d in %d ms\n",
+				ordinal, jiffies_to_msecs(jiffies - start));
 			goto out_recv;
+		}
 
 		if (chip->ops->req_canceled(chip, status)) {
 			dev_err(chip->pdev, "Operation Canceled\n");
+			dev_dbg(chip->pdev, "canceled command %d after %d ms\n",
+				ordinal, jiffies_to_msecs(jiffies - start));
 			rc = -ECANCELED;
 			goto out;
 		}
@@ -382,6 +389,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 
 	chip->ops->cancel(chip);
 	dev_err(chip->pdev, "Operation Timed out\n");
+	dev_dbg(chip->pdev, "command %d timed out after %d ms\n", ordinal,
+		jiffies_to_msecs(jiffies - start));
 	rc = -ETIME;
 	goto out;
 
-- 
1.9.1


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
