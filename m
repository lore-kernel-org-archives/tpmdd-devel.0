From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 5/7] tpm: Replace the
	of_find_node_by_name() with dev of_node property
Date: Tue, 30 Aug 2016 00:50:17 -0400
Message-ID: <1472532619-22170-6-git-send-email-nayna@linux.vnet.ibm.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1472532619-22170-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Using device of_node property is better way to refer to device node
rather than of_find_node_by_name().

Additionally, this patch replaces all currently used pr_err()  with
recommended dev_dbg().

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c |  2 ++
 drivers/char/tpm/tpm_of.c   | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 307130e..a040080 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -171,6 +171,8 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = dev;
 	chip->dev.groups = chip->groups;
+	if (dev->of_node)
+		chip->dev.of_node = chip->dev.parent->of_node;
 
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 5067a86..4e4eed7 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -2,6 +2,7 @@
  * Copyright 2012 IBM Corporation
  *
  * Author: Ashley Lai <ashleydlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *         Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
  *
  * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
  *
@@ -30,44 +31,43 @@ int read_log_of(struct tpm_chip *chip)
 	const u32 *sizep;
 	const u64 *basep;
 
-	np = of_find_node_by_name(NULL, "vtpm");
+	if (chip->dev.of_node)
+		np = chip->dev.of_node;
 	if (!np) {
-		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
+		dev_dbg(&chip->dev, "%s: ERROR - IBMVTPM not supported\n",
+			__func__);
 		return -ENODEV;
 	}
 
 	sizep = of_get_property(np, "linux,sml-size", NULL);
 	if (sizep == NULL) {
-		pr_err("%s: ERROR - SML size not found\n", __func__);
+		dev_dbg(&chip->dev, "%s: ERROR - SML size not found\n",
+			__func__);
 		goto cleanup_eio;
 	}
 	if (*sizep == 0) {
-		pr_err("%s: ERROR - event log area empty\n", __func__);
+		dev_dbg(&chip->dev, "%s: ERROR - event log area empty\n",
+			__func__);
 		goto cleanup_eio;
 	}
 
 	basep = of_get_property(np, "linux,sml-base", NULL);
 	if (basep == NULL) {
-		pr_err("%s: ERROR - SML not found\n", __func__);
+		dev_dbg(&chip->dev, "%s: ERROR - SML not found\n", __func__);
 		goto cleanup_eio;
 	}
 
 	chip->log.bios_event_log = kmalloc(*sizep, GFP_KERNEL);
 	if (!chip->log.bios_event_log) {
-		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
-		       __func__);
-		of_node_put(np);
 		return -ENOMEM;
 	}
 
 	chip->log.bios_event_log_end = chip->log.bios_event_log + *sizep;
 
 	memcpy(chip->log.bios_event_log, __va(*basep), *sizep);
-	of_node_put(np);
 
 	return 0;
 
 cleanup_eio:
-	of_node_put(np);
 	return -EIO;
 }
-- 
2.5.0


------------------------------------------------------------------------------
