From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 4/7] tpm: Redefine the read_log method to
	check for ACPI/OF properties sequentially
Date: Tue, 30 Aug 2016 00:50:16 -0400
Message-ID: <1472532619-22170-5-git-send-email-nayna@linux.vnet.ibm.com>
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

Currently, the difference in read_log method for ACPI/OF based platforms
is handled by defining respective read_log method and handing
them using CONFIG based #ifdef condition in Makefile which is not
the recommended approach.

This patch cleans up the ifdef condition in Makefile by defining
single read_log method which checks for ACPI/OF event log memory in
sequence.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Makefile       | 11 ++---------
 drivers/char/tpm/tpm_acpi.c     |  9 +--------
 drivers/char/tpm/tpm_eventlog.c | 17 +++++++++++++++++
 drivers/char/tpm/tpm_eventlog.h | 18 +++++++++++++++++-
 drivers/char/tpm/tpm_of.c       | 11 +++++------
 5 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 00e48e4..e8c7b4d 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -5,15 +5,8 @@ obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
 	tpm_eventlog.o
 
-tpm-$(CONFIG_ACPI) += tpm_ppi.o
-
-ifdef CONFIG_ACPI
-	tpm-y += tpm_acpi.o
-else
-ifdef CONFIG_OF
-	tpm-y += tpm_of.o
-endif
-endif
+tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
+tpm-$(CONFIG_OF) += tpm_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_TIS_SPI) += tpm_tis_spi.o
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 05b4e8a..a670c4f 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -45,20 +45,13 @@ struct acpi_tcpa {
 };
 
 /* read binary bios log */
-int read_log(struct tpm_chip *chip)
+int read_log_acpi(struct tpm_chip *chip)
 {
 	struct acpi_tcpa *buff;
 	acpi_status status;
 	void __iomem *virt;
 	u64 len, start;
 
-	if (chip->log.bios_event_log != NULL) {
-		printk(KERN_ERR
-		       "%s: ERROR - Eventlog already initialized\n",
-		       __func__);
-		return -EFAULT;
-	}
-
 	/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
 	status = acpi_get_table(ACPI_SIG_TCPA, 1,
 				(struct acpi_table_header **)&buff);
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index d6f2477..f84ce71 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -349,6 +349,23 @@ static int is_bad(void *p)
 	return 0;
 }
 
+int read_log(struct tpm_chip *chip)
+{
+	int rc;
+
+	if (chip->log.bios_event_log != NULL) {
+		dev_dbg(&chip->dev, "%s:ERROR - Eventlog already initialized\n",
+			__func__);
+		return -EFAULT;
+	}
+
+	rc = read_log_acpi(chip);
+	if (rc == 0)
+		return rc;
+	rc = read_log_of(chip);
+	return rc;
+}
+
 void tpm_bios_log_setup(struct tpm_chip *chip)
 {
 	const char *name = dev_name(&chip->dev);
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 6a01d43..0e599ab 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -73,7 +73,23 @@ enum tcpa_pc_event_ids {
 	HOST_TABLE_OF_DEVICES,
 };
 
-int read_log(struct tpm_chip *chip);
+#if defined(CONFIG_ACPI)
+int read_log_acpi(struct tpm_chip *chip);
+#else
+static inline int read_log_acpi(struct tpm_chip *chip)
+{
+	return -1;
+}
+#endif
+
+#if defined(CONFIG_OF)
+int read_log_of(struct tpm_chip *chip);
+#else
+static inline int read_log_of(struct tpm_chip *chip)
+{
+	return -1;
+}
+#endif
 
 void tpm_bios_log_setup(struct tpm_chip *chip);
 void tpm_bios_log_teardown(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 8e77976..5067a86 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -14,23 +14,22 @@
  *
  */
 
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/security.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
-int read_log(struct tpm_chip *chip)
+int read_log_of(struct tpm_chip *chip)
 {
 	struct device_node *np;
 	const u32 *sizep;
 	const u64 *basep;
 
-	if (chip->log.bios_event_log != NULL) {
-		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
-		return -EFAULT;
-	}
-
 	np = of_find_node_by_name(NULL, "vtpm");
 	if (!np) {
 		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
-- 
2.5.0


------------------------------------------------------------------------------
