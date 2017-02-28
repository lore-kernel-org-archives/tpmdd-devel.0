From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] tpm: select CONFIG_CRYPTO
Date: Tue, 28 Feb 2017 22:12:55 +0100
Message-ID: <20170228211326.3667625-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, Christophe Ricard <christophe.ricard@gmail.com>, Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

We get a newly introduced harmless warning when CONFIG_CRYPTO is disabled:

warning: (TCG_TPM && TRUSTED_KEYS && IMA) selects CRYPTO_HASH_INFO which has unmet direct dependencies (CRYPTO)

This adds another select to avoid the warning, consistent with other users
of the crypto code.

Fixes: c1f92b4b04ad ("tpm: enhance TPM 2.0 PCR extend to support multiple banks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/tpm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index af985cca413c..d520ac51c11c 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -6,6 +6,7 @@ menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
 	depends on HAS_IOMEM
 	select SECURITYFS
+	select CRYPTO
 	select CRYPTO_HASH_INFO
 	---help---
 	  If you have a TPM security chip in your system, which
-- 
2.9.0
