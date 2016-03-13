From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v8 04/10] tpm: Get rid of module locking
Date: Sun, 13 Mar 2016 18:54:34 -0400
Message-ID: <1457909680-14085-5-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1457909680-14085-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1457909680-14085-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Now that the tpm core has strong locking around 'ops' it is possible
to remove a TPM driver, module and all, even while user space still
has things like /dev/tpmX open. For consistency and simplicity, drop
the module locking entirely.

The module lock can be dropped since /dev/tpmX holds the reader lock
on 'ops' while using 'ops' and this prevents the module from un-
registering, which needs the writer lock. Once the module unregistered
the 'ops' cannot be found anymore.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 5793ea1..6636728 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -57,9 +57,6 @@ int tpm_try_get_ops(struct tpm_chip *chip)
 	if (!chip->ops)
 		goto out_lock;
 
-	if (!try_module_get(chip->dev.parent->driver->owner))
-		goto out_lock;
-
 	return 0;
 out_lock:
 	up_read(&chip->ops_sem);
@@ -77,7 +74,6 @@ EXPORT_SYMBOL_GPL(tpm_try_get_ops);
  */
 void tpm_put_ops(struct tpm_chip *chip)
 {
-	module_put(chip->dev.parent->driver->owner);
 	up_read(&chip->ops_sem);
 	put_device(&chip->dev);
 }
@@ -183,7 +179,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 		goto out;
 
 	cdev_init(&chip->cdev, &tpm_fops);
-	chip->cdev.owner = dev->driver->owner;
+	chip->cdev.owner = THIS_MODULE;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
 	rc = devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
-- 
2.4.3


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
