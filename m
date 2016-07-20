From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v2 1/2] tpm_tis_core: add optional max xfer
	size check
Date: Tue, 19 Jul 2016 19:34:19 -0700
Message-ID: <faf81974821d1748f671888afffba5721847aa6d.1468981325.git.apronin@chromium.org>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
	<cover.1468981325.git.apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <cover.1468981325.git.apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <cover.1468981325.git.apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
References: <1468546745-14646-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
	<cover.1468981325.git.apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

If tpm reports a bigger burstcnt than allowed by the physical protocol,
re-query the burstcnt and correct, if needed, if still too large.

In practice, seen in case of xfer issues (e.g. in spi interface case,
lost header causing flow control issues and wrong values returned on read
from TPM_STS). Without catching, causes the physical layer to reject xfer,
while is easily preventable by re-querying TPM_STS.

Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_core.c | 18 ++++++++++++++++--
 drivers/char/tpm/tpm_tis_core.h |  1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index d66f51b..ffc1acb 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -158,6 +158,7 @@ static int get_burstcount(struct tpm_chip *chip)
 	unsigned long stop;
 	int burstcnt, rc;
 	u32 value;
+	bool retry_burstcnt = false;
 
 	/* wait for burstcount */
 	/* which timeout value, spec has 2 answers (c & d) */
@@ -168,8 +169,21 @@ static int get_burstcount(struct tpm_chip *chip)
 			return rc;
 
 		burstcnt = (value >> 8) & 0xFFFF;
-		if (burstcnt)
-			return burstcnt;
+		if (burstcnt) {
+			/* If burstcnt is larger than max allowed xfer
+			 * size, retry once - may be a glitch. Return
+			 * max_xfer_size on the 2nd try to avoid being
+			 * stuck forever.
+			 */
+			if ((priv->phy_ops->max_xfer_size == 0) ||
+			    (burstcnt <= priv->phy_ops->max_xfer_size))
+				return burstcnt;
+			if (retry_burstcnt)
+				return priv->phy_ops->max_xfer_size;
+			dev_warn(&chip->dev,
+				 "Bad burstcnt read: %d\n", burstcnt);
+			retry_burstcnt = true;
+		}
 		msleep(TPM_TIMEOUT);
 	} while (time_before(jiffies, stop));
 	return -EBUSY;
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 9191aab..58e8b14 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -102,6 +102,7 @@ struct tpm_tis_phy_ops {
 	int (*read16)(struct tpm_tis_data *data, u32 addr, u16 *result);
 	int (*read32)(struct tpm_tis_data *data, u32 addr, u32 *result);
 	int (*write32)(struct tpm_tis_data *data, u32 addr, u32 src);
+	u16 max_xfer_size;
 };
 
 static inline int tpm_tis_read_bytes(struct tpm_tis_data *data, u32 addr,
-- 
2.6.6


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
