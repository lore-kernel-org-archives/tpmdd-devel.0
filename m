From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: cleanup tpm_tis_remove()
Date: Thu, 31 Mar 2016 13:11:27 +0300
Message-ID: <1459419087-20487-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Created a local variable for the register in order to clean up
experession where TPM_GLOBAL_INT_ENABLE is cleared. This expression is
horrible to read and makes changing the function uncomfortable because
like easily surpass 80 characters.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 068f021..ce2b984 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -658,15 +658,14 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static void tpm_tis_remove(struct tpm_chip *chip)
 {
+	void __iomem *reg = chip->vendor.iobase +
+		TPM_INT_ENABLE(chip->vendor.locality);
+
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
 
-	iowrite32(~TPM_GLOBAL_INT_ENABLE &
-		  ioread32(chip->vendor.iobase +
-			   TPM_INT_ENABLE(chip->vendor.
-					  locality)),
-		  chip->vendor.iobase +
-		  TPM_INT_ENABLE(chip->vendor.locality));
+	iowrite32(~TPM_GLOBAL_INT_ENABLE & ioread32(reg), reg);
+
 	release_locality(chip, chip->vendor.locality, 1);
 }
 
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
