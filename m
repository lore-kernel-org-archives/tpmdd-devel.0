From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 01/12] tpm/st33zp24/spi: Remove
	nbr_dummy_bytes variable usage
Date: Sat, 13 Feb 2016 16:15:24 +0100
Message-ID: <1455376535-9549-2-git-send-email-christophe-h.ricard@st.com>
References: <1455376535-9549-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455376535-9549-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

nbr_dummy_bytes variable could be easily replaced by phy->latency in
st33zp24_spi_send and st33zp24_spi_recv.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/spi.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index f974c94..74c5fcc 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -111,7 +111,7 @@ static int st33zp24_spi_send(void *phy_id, u8 tpm_register, u8 *tpm_data,
 			     int tpm_size)
 {
 	u8 data = 0;
-	int total_length = 0, nbr_dummy_bytes = 0, ret = 0;
+	int total_length = 0, ret = 0;
 	struct st33zp24_spi_phy *phy = phy_id;
 	struct spi_device *dev = phy->spi_device;
 	u8 *tx_buf = (u8 *)phy->spi_xfer.tx_buf;
@@ -133,14 +133,13 @@ static int st33zp24_spi_send(void *phy_id, u8 tpm_register, u8 *tpm_data,
 	memcpy(&tx_buf[total_length], tpm_data, tpm_size);
 	total_length += tpm_size;
 
-	nbr_dummy_bytes = phy->latency;
-	memset(&tx_buf[total_length], TPM_DUMMY_BYTE, nbr_dummy_bytes);
+	memset(&tx_buf[total_length], TPM_DUMMY_BYTE, phy->latency);
 
-	phy->spi_xfer.len = total_length + nbr_dummy_bytes;
+	phy->spi_xfer.len = total_length + phy->latency;
 
 	ret = spi_sync_transfer(dev, &phy->spi_xfer, 1);
 	if (ret == 0)
-		ret = rx_buf[total_length + nbr_dummy_bytes - 1];
+		ret = rx_buf[total_length + phy->latency - 1];
 
 	return st33zp24_status_to_errno(ret);
 } /* st33zp24_spi_send() */
@@ -157,7 +156,7 @@ static int st33zp24_spi_send(void *phy_id, u8 tpm_register, u8 *tpm_data,
 static int read8_reg(void *phy_id, u8 tpm_register, u8 *tpm_data, int tpm_size)
 {
 	u8 data = 0;
-	int total_length = 0, nbr_dummy_bytes, ret;
+	int total_length = 0, ret;
 	struct st33zp24_spi_phy *phy = phy_id;
 	struct spi_device *dev = phy->spi_device;
 	u8 *tx_buf = (u8 *)phy->spi_xfer.tx_buf;
@@ -171,18 +170,17 @@ static int read8_reg(void *phy_id, u8 tpm_register, u8 *tpm_data, int tpm_size)
 	memcpy(tx_buf + total_length, &data, sizeof(data));
 	total_length++;
 
-	nbr_dummy_bytes = phy->latency;
 	memset(&tx_buf[total_length], TPM_DUMMY_BYTE,
-	       nbr_dummy_bytes + tpm_size);
+	       phy->latency + tpm_size);
 
-	phy->spi_xfer.len = total_length + nbr_dummy_bytes + tpm_size;
+	phy->spi_xfer.len = total_length + phy->latency + tpm_size;
 
 	/* header + status byte + size of the data + status byte */
 	ret = spi_sync_transfer(dev, &phy->spi_xfer, 1);
 	if (tpm_size > 0 && ret == 0) {
-		ret = rx_buf[total_length + nbr_dummy_bytes - 1];
+		ret = rx_buf[total_length + phy->latency - 1];
 
-		memcpy(tpm_data, rx_buf + total_length + nbr_dummy_bytes,
+		memcpy(tpm_data, rx_buf + total_length + phy->latency,
 		       tpm_size);
 	}
 
-- 
2.5.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
