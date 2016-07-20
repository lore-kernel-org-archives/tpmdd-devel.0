From: Andrey Pronin <apronin@chromium.org>
Subject: [PATCH v2 2/2] tpm_tis_spi: add max xfer size
Date: Tue, 19 Jul 2016 19:34:20 -0700
Message-ID: <c052075083b8975e9e8bea2dfd6223e6a2e57ea6.1468981325.git.apronin@chromium.org>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
 <cover.1468981325.git.apronin@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1468981325.git.apronin@chromium.org>
In-Reply-To: <cover.1468981325.git.apronin@chromium.org>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org> <cover.1468981325.git.apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Christophe Ricard <christophe.ricard@gmail.com>, Andrey Pronin <apronin@chromium.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Reject burstcounts larger than 64 bytes reported by tpm.
SPI Hardware Protocol defined in section 6.4 of TCG PTP
Spec supports up to 64 bytes of data in a transaction.

Signed-off-by: Andrey Pronin <apronin@chromium.org>
---
 drivers/char/tpm/tpm_tis_spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index dbaad9c..b103373 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -206,6 +206,7 @@ static const struct tpm_tis_phy_ops tpm_spi_phy_ops = {
 	.read16 = tpm_tis_spi_read16,
 	.read32 = tpm_tis_spi_read32,
 	.write32 = tpm_tis_spi_write32,
+	.max_xfer_size = MAX_SPI_FRAMESIZE,
 };
 
 static int tpm_tis_spi_probe(struct spi_device *dev)
-- 
2.6.6
