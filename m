From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] tpm: Fix IRQ unwind ordering in TIS
Date: Wed, 27 Apr 2016 10:58:46 -0600
Message-ID: <20160427165846.GA17064@obsidianresearch.com>
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
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The devm for the IRQ was placed on the chip, not the pdev. This can
cause the irq to be still callable after the pdev has been cleaned up
(eg priv kfree'd).

Found by CONFIG_DEBUG_SHIRQ=y

Reported-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Fixes: 233a065e0cd0 ("tpm: Get rid of chip->pdev")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Tested-by:  Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a6b2d460bfc0..d88827046a42 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -387,7 +387,7 @@ static void disable_interrupts(struct tpm_chip *chip)
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
 	iowrite32(intmask,
 		  priv->iobase + TPM_INT_ENABLE(priv->locality));
-	devm_free_irq(&chip->dev, priv->irq, chip);
+	devm_free_irq(chip->dev.parent, priv->irq, chip);
 	priv->irq = 0;
 	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
 }
@@ -604,7 +604,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 	u8 original_int_vec;
 
-	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
+	if (devm_request_irq(chip->dev.parent, irq, tis_int_handler, flags,
 			     dev_name(&chip->dev), chip) != 0) {
 		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
 			 irq);
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
