From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] tpm: fix cacheline alignment for DMA-able
	buffers
Date: Thu, 28 Jul 2016 19:59:13 -0700
Message-ID: <1469761153-85576-1-git-send-email-apronin@chromium.org>
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
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Annotate buffers used in spi transactions as ____cacheline_aligned
to use in DMA transfers.

Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/char/tpm/st33zp24/spi.c | 4 ++--
 drivers/char/tpm/tpm_tis_spi.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index 9f5a011..0e9aad9 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -70,8 +70,8 @@
 struct st33zp24_spi_phy {
 	struct spi_device *spi_device;
 
-	u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE];
-	u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE];
+	u8 tx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline_aligned;
+	u8 rx_buf[ST33ZP24_SPI_BUFFER_SIZE] ____cacheline_aligned;
 
 	int io_lpcpd;
 	int latency;
diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index dbaad9c..58d7758 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -48,8 +48,8 @@ struct tpm_tis_spi_phy {
 	struct tpm_tis_data priv;
 	struct spi_device *spi_device;
 
-	u8 tx_buf[MAX_SPI_FRAMESIZE + 4];
-	u8 rx_buf[MAX_SPI_FRAMESIZE + 4];
+	u8 tx_buf[MAX_SPI_FRAMESIZE + 4] ____cacheline_aligned;
+	u8 rx_buf[MAX_SPI_FRAMESIZE + 4] ____cacheline_aligned;
 };
 
 static inline struct tpm_tis_spi_phy *to_tpm_tis_spi_phy(struct tpm_tis_data *data)
-- 
2.6.6


------------------------------------------------------------------------------
