From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm_crb: fix bad name pointer usage with
	struct resource
Date: Wed, 17 Feb 2016 02:27:54 +0200
Message-ID: <1455668874-13261-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The memory was not zeroed for new_res, which caused
devm_ioremap_resource() not to use dev_name() but instead whatever
garbage was pointed by new_res->name.

The problem crb_check_resource is different. There not zeroing the
name pointer causes use-after-free.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Fixes: 1bd047be37d9 ("tpm_crb: Use devm_ioremap_resource")
---
 drivers/char/tpm/tpm_crb.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 916332c..151689d 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -227,8 +227,10 @@ static int crb_check_resource(struct acpi_resource *ares, void *data)
 	struct crb_priv *priv = data;
 	struct resource res;
 
-	if (acpi_dev_resource_memory(ares, &res))
+	if (acpi_dev_resource_memory(ares, &res)) {
+		res.name = NULL;
 		priv->res = res;
+	}
 
 	return 1;
 }
@@ -236,11 +238,13 @@ static int crb_check_resource(struct acpi_resource *ares, void *data)
 static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
 				 u64 start, u32 size)
 {
-	struct resource new_res = {
-		.start	= start,
-		.end	= start + size - 1,
-		.flags	= IORESOURCE_MEM,
-	};
+	struct resource new_res;
+
+	memset(&new_res, 0, sizeof(new_res));
+
+	new_res.start	= start;
+	new_res.end	= start + size - 1;
+	new_res.flags	= IORESOURCE_MEM;
 
 	/* Detect a 64 bit address on a 32 bit system */
 	if (start != new_res.start)
-- 
2.7.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
