From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v4 3/7] tpm_tis: Do not fall back to a
	hardcoded address for TPM2
Date: Thu,  7 Jan 2016 17:36:22 -0700
Message-ID: <1452213386-21460-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1452213386-21460-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1452213386-21460-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

If the ACPI tables do not declare a memory resource for the TPM2
then do not just fall back to the x86 default base address.

Also be stricter when checking the ancillary TPM2 ACPI data and error
out if any of this data is wrong rather than blindly assuming TPM1.

Fixes: 399235dc6e95 ("tpm, tpm_tis: fix tpm_tis ACPI detection issue with TPM 2.0")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Tested-by: Wilck, Martin <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 48 +++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index fecd27b45fd1..b2b31f5418ca 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -122,39 +122,11 @@ static inline int is_itpm(struct acpi_device *dev)
 {
 	return has_hid(dev, "INTC0102");
 }
-
-static inline int is_fifo(struct acpi_device *dev)
-{
-	struct acpi_table_tpm2 *tbl;
-	acpi_status st;
-
-	/* TPM 1.2 FIFO */
-	if (!has_hid(dev, "MSFT0101"))
-		return 1;
-
-	st = acpi_get_table(ACPI_SIG_TPM2, 1,
-			    (struct acpi_table_header **) &tbl);
-	if (ACPI_FAILURE(st)) {
-		dev_err(&dev->dev, "failed to get TPM2 ACPI table\n");
-		return 0;
-	}
-
-	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
-		return 0;
-
-	/* TPM 2.0 FIFO */
-	return 1;
-}
 #else
 static inline int is_itpm(struct acpi_device *dev)
 {
 	return 0;
 }
-
-static inline int is_fifo(struct acpi_device *dev)
-{
-	return 1;
-}
 #endif
 
 /* Before we attempt to access the TPM we must see that the valid bit is set.
@@ -980,11 +952,21 @@ static int tpm_check_resource(struct acpi_resource *ares, void *data)
 
 static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
 {
+	struct acpi_table_tpm2 *tbl;
+	acpi_status st;
 	struct list_head resources;
-	struct tpm_info tpm_info = tis_default_info;
+	struct tpm_info tpm_info = {};
 	int ret;
 
-	if (!is_fifo(acpi_dev))
+	st = acpi_get_table(ACPI_SIG_TPM2, 1,
+			    (struct acpi_table_header **) &tbl);
+	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
+		dev_err(&acpi_dev->dev,
+			FW_BUG "failed to get TPM2 ACPI table\n");
+		return -EINVAL;
+	}
+
+	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
 		return -ENODEV;
 
 	INIT_LIST_HEAD(&resources);
@@ -996,6 +978,12 @@ static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
 
 	acpi_dev_free_resource_list(&resources);
 
+	if (tpm_info.start == 0 && tpm_info.len == 0) {
+		dev_err(&acpi_dev->dev,
+			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
+		return -EINVAL;
+	}
+
 	if (is_itpm(acpi_dev))
 		itpm = true;
 
-- 
2.1.4


------------------------------------------------------------------------------
