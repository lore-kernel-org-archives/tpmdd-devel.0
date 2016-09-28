From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 4/8] tpm: redefine read_log() to handle
	ACPI/OF at runtime
Date: Wed, 28 Sep 2016 04:34:38 -0400
Message-ID: <1475051682-23060-5-git-send-email-nayna@linux.vnet.ibm.com>
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

Currently, read_log() has two implementations: one for ACPI platforms
and the other for OF platforms. The proper one is selected at compile
time using Kconfig and #ifdef in the Makefile, which is not the
recommended approach.

This patch removes the #ifdef in the Makefile by defining a single
read_log() method, which checks for ACPI/OF event log properties at
runtime.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/Makefile       | 14 ++++----------
 drivers/char/tpm/tpm_acpi.c     |  9 ++-------
 drivers/char/tpm/tpm_eventlog.c | 18 ++++++++++++++++++
 drivers/char/tpm/tpm_eventlog.h | 22 +++++++++++++---------
 drivers/char/tpm/tpm_of.c       |  8 ++------
 5 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index a385fb8..a05b1eb 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,16 +2,10 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
-tpm-$(CONFIG_ACPI) += tpm_ppi.o
-
-ifdef CONFIG_ACPI
-	tpm-y += tpm_eventlog.o tpm_acpi.o
-else
-ifdef CONFIG_TCG_IBMVTPM
-	tpm-y += tpm_eventlog.o tpm_of.o
-endif
-endif
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
+		tpm_eventlog.o
+tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
+tpm-$(CONFIG_OF) += tpm_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_TIS_SPI) += tpm_tis_spi.o
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 4d6c2d7..859bdba 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -6,6 +6,7 @@
  *	Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
  *	Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
  *	Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *	Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
  *
  * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
  *
@@ -45,7 +46,7 @@ struct acpi_tcpa {
 };
 
 /* read binary bios log */
-int read_log(struct tpm_chip *chip)
+int read_log_acpi(struct tpm_chip *chip)
 {
 	struct acpi_tcpa *buff;
 	acpi_status status;
@@ -54,12 +55,6 @@ int read_log(struct tpm_chip *chip)
 	struct tpm_bios_log *log;
 
 	log = &chip->log;
-	if (log->bios_event_log != NULL) {
-		printk(KERN_ERR
-		       "%s: ERROR - Eventlog already initialized\n",
-		       __func__);
-		return -EFAULT;
-	}
 
 	/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
 	status = acpi_get_table(ACPI_SIG_TCPA, 1,
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index a8cd4a1..c327089 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -346,6 +346,24 @@ static int is_bad(void *p)
 	return 0;
 }
 
+int read_log(struct tpm_chip *chip)
+{
+	int rc;
+
+	if (chip->log.bios_event_log != NULL) {
+		dev_dbg(&chip->dev, "%s: ERROR - Eventlog already initialized\n",
+			__func__);
+		return -EFAULT;
+	}
+
+	rc = read_log_acpi(chip);
+	if ((rc == 0) || (rc == -ENOMEM))
+		return rc;
+	rc = read_log_of(chip);
+	return rc;
+
+}
+
 int tpm_bios_log_setup(struct tpm_chip *chip)
 {
 	const char *name = dev_name(&chip->dev);
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 7ea066c..9e95b7e 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -78,20 +78,24 @@ enum tcpa_pc_event_ids {
 	HOST_TABLE_OF_DEVICES,
 };
 
-int read_log(struct tpm_chip *chip);
-
-#if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
-	defined(CONFIG_ACPI)
-extern int tpm_bios_log_setup(struct tpm_chip *chip);
-extern void tpm_bios_log_teardown(struct tpm_chip *chip);
+#if defined(CONFIG_ACPI)
+int read_log_acpi(struct tpm_chip *chip);
 #else
-static inline int tpm_bios_log_setup(struct tpm_chip *chip)
+static inline int read_log_acpi(struct tpm_chip *chip)
 {
-	return 0;
+	return -ENODEV;
 }
-static inline void tpm_bios_log_teardown(struct tpm_chip *chip)
+#endif
+#if defined(CONFIG_OF)
+int read_log_of(struct tpm_chip *chip);
+#else
+static inline int read_log_of(struct tpm_chip *chip)
 {
+	return -ENODEV;
 }
 #endif
 
+int tpm_bios_log_setup(struct tpm_chip *chip);
+void tpm_bios_log_teardown(struct tpm_chip *chip);
+
 #endif
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 68d891a..7c30752 100644
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
@@ -20,7 +21,7 @@
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
-int read_log(struct tpm_chip *chip)
+int read_log_of(struct tpm_chip *chip)
 {
 	struct device_node *np;
 	const u32 *sizep;
@@ -28,11 +29,6 @@ int read_log(struct tpm_chip *chip)
 	struct tpm_bios_log *log;
 
 	log = &chip->log;
-	if (log->bios_event_log != NULL) {
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
