From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/12] tpm/st33zp24/spi: Remove useless use of
	memcpy.
Date: Tue,  9 Feb 2016 10:26:52 +0100
Message-ID: <1455010021-21927-4-git-send-email-christophe-h.ricard@st.com>
References: <1455010021-21927-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455010021-21927-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

An affectation is enough when copying 1 byte. Remove memcpy usage where
possible.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/spi.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index f42c443..08ffbfe 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -110,7 +110,6 @@ static int st33zp24_status_to_errno(u8 code)
 static int st33zp24_spi_send(void *phy_id, u8 tpm_register, u8 *tpm_data,
 			     int tpm_size)
 {
-	u8 data = 0;
 	int total_length = 0, ret = 0;
 	struct st33zp24_spi_phy *phy = phy_id;
 	struct spi_device *dev = phy->spi_device;
@@ -118,12 +117,8 @@ static int st33zp24_spi_send(void *phy_id, u8 tpm_register, u8 *tpm_data,
 	u8 *rx_buf = phy->spi_xfer.rx_buf;
 
 	/* Pre-Header */
-	data = TPM_WRITE_DIRECTION | LOCALITY0;
-	memcpy(tx_buf + total_length, &data, sizeof(data));
-	total_length++;
-	data = tpm_register;
-	memcpy(tx_buf + total_length, &data, sizeof(data));
-	total_length++;
+	tx_buf[total_length++] = TPM_WRITE_DIRECTION | LOCALITY0;
+	tx_buf[total_length++] = tpm_register;
 
 	if (tpm_size > 0 && tpm_register == TPM_DATA_FIFO) {
 		tx_buf[total_length++] = tpm_size >> 8;
@@ -156,7 +151,6 @@ static int st33zp24_spi_send(void *phy_id, u8 tpm_register, u8 *tpm_data,
 static int st33zp24_spi_read8_reg(void *phy_id, u8 tpm_register, u8 *tpm_data,
 				  int tpm_size)
 {
-	u8 data = 0;
 	int total_length = 0, ret;
 	struct st33zp24_spi_phy *phy = phy_id;
 	struct spi_device *dev = phy->spi_device;
@@ -164,12 +158,8 @@ static int st33zp24_spi_read8_reg(void *phy_id, u8 tpm_register, u8 *tpm_data,
 	u8 *rx_buf = phy->spi_xfer.rx_buf;
 
 	/* Pre-Header */
-	data = LOCALITY0;
-	memcpy(tx_buf + total_length, &data, sizeof(data));
-	total_length++;
-	data = tpm_register;
-	memcpy(tx_buf + total_length, &data, sizeof(data));
-	total_length++;
+	tx_buf[total_length++] = LOCALITY0;
+	tx_buf[total_length++] = tpm_register;
 
 	memset(&tx_buf[total_length], TPM_DUMMY_BYTE,
 	       phy->latency + tpm_size);
-- 
2.5.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
