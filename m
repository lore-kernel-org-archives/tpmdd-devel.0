From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v3 1/2] tpm_tis_core: add optional max xfer
	size check
Date: Wed, 27 Jul 2016 20:49:56 -0700
Message-ID: <1469677797-74304-2-git-send-email-apronin@chromium.org>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
	<1469677797-74304-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1469677797-74304-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1468546745-14646-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
References: <1468546745-14646-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

If tpm reports a bigger burstcnt than allowed by the physical protocol,
set burstcnt to the max allowed value.

In practice, seen in case of xfer issues (e.g. in spi interface case,
lost header causing flow control issues and wrong values returned on read
from TPM_STS). Without catching, causes the physical layer to reject xfer.

Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_core.c | 9 ++++++++-
 drivers/char/tpm/tpm_tis_core.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index f22caf8..7c4fa0c 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -168,8 +168,15 @@ static int get_burstcount(struct tpm_chip *chip)
 			return rc;
 
 		burstcnt = (value >> 8) & 0xFFFF;
-		if (burstcnt)
+		if (burstcnt) {
+			if (priv->phy_ops->max_xfer_size &&
+			    (burstcnt > priv->phy_ops->max_xfer_size)) {
+				dev_warn(&chip->dev,
+					 "Bad burstcnt read: %d\n", burstcnt);
+				burstcnt = priv->phy_ops->max_xfer_size;
+			}
 			return burstcnt;
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
