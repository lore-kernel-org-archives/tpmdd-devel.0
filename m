From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Check for error return values from
	get_burstcount.
Date: Thu, 20 Oct 2016 17:21:29 -0700
Message-ID: <20161021002129.GA9464@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

If the TPM we're connecting to uses a static burst count, it will report
a burst count of zero throughout the response read. However, get_burstcount
assumes that a response of zero indicates that the TPM is not ready to
receive more data. In this case, it returns a negative error code, which
is passed on to tpm_tis_{write,read}_bytes as a u16, causing
them to read/write far too many bytes.

This patch checks for negative return codes and bails out from recv_data
and tpm_tis_send_data.
---
 drivers/char/tpm/tpm_tis_core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index e3bf31b..d0301dc 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -186,6 +186,12 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 				 chip->timeout_c,
 				 &priv->read_queue, true) == 0) {
 		burstcnt = min_t(int, get_burstcount(chip), count - size);
+		if (burstcnt < 0) {
+			dev_err(&chip->dev,
+				"Unable to read burstcount in %s:%d (%s)\n",
+				__FILE__, __LINE__, __func__);
+			return rc;
+		}
 
 		rc = tpm_tis_read_bytes(priv, TPM_DATA_FIFO(priv->locality),
 					burstcnt, buf + size);
@@ -272,6 +278,13 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 
 	while (count < len - 1) {
 		burstcnt = min_t(int, get_burstcount(chip), len - count - 1);
+		if (burstcnt < 0) {
+			dev_err(&chip->dev,
+				"Unable to read burstcount in %s:%d (%s)\n",
+				__FILE__, __LINE__, __func__);
+			rc = burstcnt;
+			goto out_err;
+		}
 		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
 					 burstcnt, buf + count);
 		if (rc < 0)
-- 
2.8.0.rc3.226.g39d4020


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
