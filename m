From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] hwrng: meson: Fix module autoload for OF registration
Date: Mon, 17 Oct 2016 16:40:14 -0300
Message-ID: <1476733214-19044-1-git-send-email-javier@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Peter Huewe <peterhuewe@gmx.de>, Kevin Hilman <khilman@baylibre.com>, Neil Armstrong <narmstrong@baylibre.com>, tpmdd-devel@lists.sourceforge.net, PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>, Carlo Caione <carlo@caione.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Herbert Xu <herbert@gondor.apana.org.au>, linux-amlogic@lists.infradead.org, Matt Mackall <mpm@selenic.com>, linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

If the driver is built as a module, autoload won't work because the module
alias information is not filled. So user-space can't match the registered
device with the corresponding module.

Export the module alias information using the MODULE_DEVICE_TABLE() macro.

Before this patch:

$ modinfo drivers/char/hw_random/meson-rng.ko | grep alias
alias:          platform:meson-rng

After this patch:

$ modinfo drivers/char/hw_random/meson-rng.ko | grep alias
alias:          platform:meson-rng
alias:          of:N*T*Camlogic,meson-rngC*
alias:          of:N*T*Camlogic,meson-rng

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/char/hw_random/meson-rng.c | 1 +
 drivers/char/tpm/Kconfig           | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index 58bef39f7286..51864a509be7 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -110,6 +110,7 @@ static const struct of_device_id meson_rng_of_match[] = {
 	{ .compatible = "amlogic,meson-rng", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, meson_rng_of_match);
 
 static struct platform_driver meson_rng_driver = {
 	.probe	= meson_rng_probe,
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 9faa0b1e7766..982ed2fe927c 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -32,7 +32,7 @@ config TCG_TIS_CORE
 
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface / TPM 2.0 FIFO Interface"
-	depends on X86
+	depends on X86 || COMPILE_TEST
 	select TCG_TIS_CORE
 	---help---
 	  If you have a TPM security chip that is compliant with the
-- 
2.7.4
