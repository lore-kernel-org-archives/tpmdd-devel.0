From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 1/5] Implement tpm_chip_free
Date: Mon,  8 Feb 2016 14:27:04 -0500
Message-ID: <1454959628-30582-2-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1454959628-30582-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Implement the public function tpm_chip_free to undo tpmm_chip_alloc.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 14 ++++++++++----
 drivers/char/tpm/tpm.h      |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index fbd75c5..361cee8 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -59,6 +59,15 @@ struct tpm_chip *tpm_chip_find_get(int chip_num)
 }
 EXPORT_SYMBOL_GPL(tpm_chip_find_get);
 
+void tpm_chip_free(struct tpm_chip *chip)
+{
+	spin_lock(&driver_lock);
+	clear_bit(chip->dev_num, dev_mask);
+	spin_unlock(&driver_lock);
+	kfree(chip);
+}
+EXPORT_SYMBOL_GPL(tpm_chip_free);
+
 /**
  * tpm_dev_release() - free chip memory and the device number
  * @dev: the character device for the TPM chip
@@ -69,10 +78,7 @@ static void tpm_dev_release(struct device *dev)
 {
 	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
 
-	spin_lock(&driver_lock);
-	clear_bit(chip->dev_num, dev_mask);
-	spin_unlock(&driver_lock);
-	kfree(chip);
+	tpm_chip_free(chip);
 }
 
 /**
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index a4257a3..440a167 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -515,6 +515,7 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 struct tpm_chip *tpm_chip_find_get(int chip_num);
 extern struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 				       const struct tpm_class_ops *ops);
+extern void tpm_chip_free(struct tpm_chip *chip);
 extern int tpm_chip_register(struct tpm_chip *chip);
 extern void tpm_chip_unregister(struct tpm_chip *chip);
 
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
