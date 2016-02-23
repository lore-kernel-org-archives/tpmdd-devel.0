From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 06/12] tpm/st33zp24: Auto-select core module
Date: Tue, 23 Feb 2016 22:25:45 +0100
Message-ID: <1456262751-12096-7-git-send-email-christophe-h.ricard@st.com>
References: <1456262751-12096-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1456262751-12096-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

The core st33zp24 module is useless without either the I2C or the
SPI access module. So hide NFC_ST_NCI and select it automatically
if either TCG_TIS_ST33ZP24_I2C or TCG_TIS_ST33ZP24_SPI is selected.

This avoids presenting TCG_TIS_ST33ZP24 when neither TCG_TIS_ST33ZP24_I2C
nor TCG_TIS_ST33ZP24_SPI can be selected.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/st33zp24/Kconfig | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/Kconfig b/drivers/char/tpm/st33zp24/Kconfig
index 19c0074..e74c6f2 100644
--- a/drivers/char/tpm/st33zp24/Kconfig
+++ b/drivers/char/tpm/st33zp24/Kconfig
@@ -1,6 +1,5 @@
 config TCG_TIS_ST33ZP24
-	tristate "STMicroelectronics TPM Interface Specification 1.2 Interface"
-	depends on GPIOLIB || COMPILE_TEST
+	tristate
 	---help---
 	  STMicroelectronics ST33ZP24 core driver. It implements the core
 	  TPM1.2 logic and hooks into the TPM kernel APIs. Physical layers will
@@ -10,9 +9,9 @@ config TCG_TIS_ST33ZP24
 	  tpm_st33zp24.
 
 config TCG_TIS_ST33ZP24_I2C
-	tristate "TPM 1.2 ST33ZP24 I2C support"
-	depends on TCG_TIS_ST33ZP24
+	tristate "STMicroelectronics TPM Interface Specification 1.2 Interface (I2C)"
 	depends on I2C
+	select TCG_TIS_ST33ZP24
 	---help---
 	  This module adds support for the STMicroelectronics TPM security chip
 	  ST33ZP24 with i2c interface.
@@ -20,9 +19,9 @@ config TCG_TIS_ST33ZP24_I2C
 	  called tpm_st33zp24_i2c.
 
 config TCG_TIS_ST33ZP24_SPI
-	tristate "TPM 1.2 ST33ZP24 SPI support"
-	depends on TCG_TIS_ST33ZP24
+	tristate "STMicroelectronics TPM Interface Specification 1.2 Interface (SPI)"
 	depends on SPI
+	select TCG_TIS_ST33ZP24
 	---help---
 	  This module adds support for the STMicroelectronics TPM security chip
 	  ST33ZP24 with spi interface.
-- 
2.5.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
