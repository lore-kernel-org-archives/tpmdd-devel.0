From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 6/8] tpm: remove printk error messages
Date: Wed, 28 Sep 2016 04:34:40 -0400
Message-ID: <1475051682-23060-7-git-send-email-nayna@linux.vnet.ibm.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1475051682-23060-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

This patch removes the unnecessary messages for failure to allocate
memory. It also replaces pr_err/printk with dev_dbg.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm_acpi.c | 17 +++++------------
 drivers/char/tpm/tpm_of.c   | 26 ++++++++++----------------
 2 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 859bdba..22e42da 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -60,11 +60,8 @@ int read_log_acpi(struct tpm_chip *chip)
 	status = acpi_get_table(ACPI_SIG_TCPA, 1,
 				(struct acpi_table_header **)&buff);
 
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_ERR "%s: ERROR - Could not get TCPA table\n",
-		       __func__);
+	if (ACPI_FAILURE(status))
 		return -EIO;
-	}
 
 	switch(buff->platform_class) {
 	case BIOS_SERVER:
@@ -78,25 +75,21 @@ int read_log_acpi(struct tpm_chip *chip)
 		break;
 	}
 	if (!len) {
-		printk(KERN_ERR "%s: ERROR - TCPA log area empty\n", __func__);
+		dev_dbg(&chip->dev, "%s: ERROR - TCPA log area empty\n",
+			__func__);
 		return -EIO;
 	}
 
 	/* malloc EventLog space */
 	log->bios_event_log = kmalloc(len, GFP_KERNEL);
-	if (!log->bios_event_log) {
-		printk("%s: ERROR - Not enough  Memory for BIOS measurements\n",
-			__func__);
+	if (!log->bios_event_log)
 		return -ENOMEM;
-	}
 
 	log->bios_event_log_end = log->bios_event_log + len;
 
 	virt = acpi_os_map_iomem(start, len);
-	if (!virt) {
-		printk("%s: ERROR - Unable to map memory\n", __func__);
+	if (!virt)
 		goto err;
-	}
 
 	memcpy_fromio(log->bios_event_log, virt, len);
 
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 22b8f81..1464cae 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -31,40 +31,34 @@ int read_log_of(struct tpm_chip *chip)
 	log = &chip->log;
 	if (chip->dev.parent->of_node)
 		np = chip->dev.parent->of_node;
-	if (!np) {
-		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
+	if (!np)
 		return -ENODEV;
-	}
 
 	sizep = of_get_property(np, "linux,sml-size", NULL);
 	if (sizep == NULL) {
-		pr_err("%s: ERROR - SML size not found\n", __func__);
-		goto cleanup_eio;
+		dev_dbg(&chip->dev, "%s: ERROR - SML size not found\n",
+			__func__);
+		return -EIO;
 	}
 	if (*sizep == 0) {
-		pr_err("%s: ERROR - event log area empty\n", __func__);
-		goto cleanup_eio;
+		dev_dbg(&chip->dev, "%s: ERROR - event log area empty\n",
+			__func__);
+		return -EIO;
 	}
 
 	basep = of_get_property(np, "linux,sml-base", NULL);
 	if (basep == NULL) {
-		pr_err("%s: ERROR - SML not found\n", __func__);
-		goto cleanup_eio;
+		dev_dbg(&chip->dev, "%s: ERROR - SML not found\n", __func__);
+		return -EIO;
 	}
 
 	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
-	if (!log->bios_event_log) {
-		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
-		       __func__);
+	if (!log->bios_event_log)
 		return -ENOMEM;
-	}
 
 	log->bios_event_log_end = log->bios_event_log + *sizep;
 
 	memcpy(log->bios_event_log, __va(*basep), *sizep);
 
 	return 0;
-
-cleanup_eio:
-	return -EIO;
 }
-- 
2.5.0


------------------------------------------------------------------------------
