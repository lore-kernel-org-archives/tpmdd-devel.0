From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 3/7] tpm: Validate the eventlog access
	before tpm_bios_log_setup
Date: Tue, 30 Aug 2016 00:50:15 -0400
Message-ID: <1472532619-22170-4-git-send-email-nayna@linux.vnet.ibm.com>
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

Currently, securityfs files for eventlog is created irrespective of
logs properties exist or not i.e. event log base address and
size.

This patch will create ascii and bios measurements file
only if readlog() is successful.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Makefile       | 10 ++++++----
 drivers/char/tpm/tpm-chip.c     | 18 ++++--------------
 drivers/char/tpm/tpm.h          |  4 ++++
 drivers/char/tpm/tpm_acpi.c     | 14 +++++++-------
 drivers/char/tpm/tpm_eventlog.c | 36 ++++++++++++------------------------
 drivers/char/tpm/tpm_eventlog.h | 17 +++--------------
 drivers/char/tpm/tpm_of.c       | 12 ++++++------
 7 files changed, 42 insertions(+), 69 deletions(-)

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index a385fb8..00e48e4 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,14 +2,16 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
+	tpm_eventlog.o
+
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
-	tpm-y += tpm_eventlog.o tpm_acpi.o
+	tpm-y += tpm_acpi.o
 else
-ifdef CONFIG_TCG_IBMVTPM
-	tpm-y += tpm_eventlog.o tpm_of.o
+ifdef CONFIG_OF
+	tpm-y += tpm_of.o
 endif
 endif
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 1cd1238..307130e 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -283,19 +283,9 @@ static int tpm1_chip_register(struct tpm_chip *chip)
 
 	tpm_sysfs_add_device(chip);
 
-	tpm_bios_log_setup(chip);
-
 	return 0;
 }
 
-static void tpm1_chip_unregister(struct tpm_chip *chip)
-{
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return;
-
-	tpm_bios_log_teardown(chip);
-}
-
 static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
 {
 	struct attribute **i;
@@ -369,10 +359,8 @@ int tpm_chip_register(struct tpm_chip *chip)
 	tpm_add_ppi(chip);
 
 	rc = tpm_add_char_device(chip);
-	if (rc) {
-		tpm1_chip_unregister(chip);
+	if (rc)
 		return rc;
-	}
 
 	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
 
@@ -382,6 +370,8 @@ int tpm_chip_register(struct tpm_chip *chip)
 		return rc;
 	}
 
+	tpm_bios_log_setup(chip);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_chip_register);
@@ -406,7 +396,7 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 
 	tpm_del_legacy_sysfs(chip);
 
-	tpm1_chip_unregister(chip);
+	tpm_bios_log_teardown(chip);
 	tpm_del_char_device(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_unregister);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 603a661..032eb7d 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -35,6 +35,8 @@
 #include <linux/cdev.h>
 #include <linux/highmem.h>
 
+#include "tpm_eventlog.h"
+
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
 	TPM_BUFSIZE = 4096,
@@ -156,6 +158,8 @@ struct tpm_chip {
 	struct rw_semaphore ops_sem;
 	const struct tpm_class_ops *ops;
 
+	struct tpm_bios_log log;
+
 	unsigned int flags;
 
 	int dev_num;		/* /dev/tpm# */
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 565a947..05b4e8a 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -45,14 +45,14 @@ struct acpi_tcpa {
 };
 
 /* read binary bios log */
-int read_log(struct tpm_bios_log *log)
+int read_log(struct tpm_chip *chip)
 {
 	struct acpi_tcpa *buff;
 	acpi_status status;
 	void __iomem *virt;
 	u64 len, start;
 
-	if (log->bios_event_log != NULL) {
+	if (chip->log.bios_event_log != NULL) {
 		printk(KERN_ERR
 		       "%s: ERROR - Eventlog already initialized\n",
 		       __func__);
@@ -86,23 +86,23 @@ int read_log(struct tpm_bios_log *log)
 	}
 
 	/* malloc EventLog space */
-	log->bios_event_log = kmalloc(len, GFP_KERNEL);
-	if (!log->bios_event_log) {
+	chip->log.bios_event_log = kmalloc(len, GFP_KERNEL);
+	if (!chip->log.bios_event_log) {
 		printk("%s: ERROR - Not enough  Memory for BIOS measurements\n",
 			__func__);
 		return -ENOMEM;
 	}
 
-	log->bios_event_log_end = log->bios_event_log + len;
+	chip->log.bios_event_log_end = chip->log.bios_event_log + len;
 
 	virt = acpi_os_map_iomem(start, len);
 	if (!virt) {
-		kfree(log->bios_event_log);
+		kfree(chip->log.bios_event_log);
 		printk("%s: ERROR - Unable to map memory\n", __func__);
 		return -EIO;
 	}
 
-	memcpy_fromio(log->bios_event_log, virt, len);
+	memcpy_fromio(chip->log.bios_event_log, virt, len);
 
 	acpi_os_unmap_iomem(virt, len);
 	return 0;
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index 9dd69a7..d6f2477 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -261,14 +261,6 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
 static int tpm_bios_measurements_release(struct inode *inode,
 					 struct file *file)
 {
-	struct seq_file *seq = file->private_data;
-	struct tpm_bios_log *log = seq->private;
-
-	if (log) {
-		kfree(log->bios_event_log);
-		kfree(log);
-	}
-
 	return seq_release(inode, file);
 }
 
@@ -323,34 +315,22 @@ static int tpm_bios_measurements_open(struct inode *inode,
 					    struct file *file)
 {
 	int err;
-	struct tpm_bios_log *log;
 	struct seq_file *seq;
+	struct tpm_chip *chip;
 	const struct seq_operations *seqops =
 	(const struct seq_operations *)inode->i_private;
 
-	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
-	if (!log)
-		return -ENOMEM;
-
-	err = read_log(log);
-	if (err)
-		goto out_free;
+	chip = (struct tpm_chip
+	*)file->f_path.dentry->d_parent->d_inode->i_private;
 
 	/* now register seq file */
 	err = seq_open(file, seqops);
 	if (!err) {
 		seq = file->private_data;
-		seq->private = log;
-	} else {
-		goto out_free;
+		seq->private = &chip->log;
 	}
 
-out:
 	return err;
-out_free:
-	kfree(log->bios_event_log);
-	kfree(log);
-	goto out;
 }
 
 static const struct file_operations tpm_bios_measurements_ops = {
@@ -372,12 +352,18 @@ static int is_bad(void *p)
 void tpm_bios_log_setup(struct tpm_chip *chip)
 {
 	const char *name = dev_name(&chip->dev);
+	int rc = 0;
+
+	rc = read_log(chip);
+	if (rc < 0)
+		return;
 
 	chip->bios_dir_count = 0;
 	chip->bios_dir[chip->bios_dir_count] = securityfs_create_dir(name,
 	NULL);
 	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
 		goto err;
+	chip->bios_dir[chip->bios_dir_count]->d_inode->i_private = chip;
 	chip->bios_dir_count++;
 
 	chip->bios_dir[chip->bios_dir_count] =
@@ -410,4 +396,6 @@ void tpm_bios_log_teardown(struct tpm_chip *chip)
 
 	for (i = chip->bios_dir_count; i > 0; --i)
 		securityfs_remove(chip->bios_dir[i-1]);
+
+	kfree(chip->log.bios_event_log);
 }
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 67621c9..6a01d43 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -73,20 +73,9 @@ enum tcpa_pc_event_ids {
 	HOST_TABLE_OF_DEVICES,
 };
 
-int read_log(struct tpm_bios_log *log);
+int read_log(struct tpm_chip *chip);
 
-#if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
-	defined(CONFIG_ACPI)
-extern void tpm_bios_log_setup(struct tpm_chip *chip);
-extern void tpm_bios_log_teardown(struct tpm_chip *chip);
-#else
-static inline void tpm_bios_log_setup(struct tpm_chip *chip)
-{
-	chip->bios_dir_count = 0;
-}
-static inline void tpm_bios_log_teardown(struct tpm_chip *chip)
-{
-}
-#endif
+void tpm_bios_log_setup(struct tpm_chip *chip);
+void tpm_bios_log_teardown(struct tpm_chip *chip);
 
 #endif
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 570f30c..8e77976 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -20,13 +20,13 @@
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
-int read_log(struct tpm_bios_log *log)
+int read_log(struct tpm_chip *chip)
 {
 	struct device_node *np;
 	const u32 *sizep;
 	const u64 *basep;
 
-	if (log->bios_event_log != NULL) {
+	if (chip->log.bios_event_log != NULL) {
 		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
 		return -EFAULT;
 	}
@@ -53,17 +53,17 @@ int read_log(struct tpm_bios_log *log)
 		goto cleanup_eio;
 	}
 
-	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
-	if (!log->bios_event_log) {
+	chip->log.bios_event_log = kmalloc(*sizep, GFP_KERNEL);
+	if (!chip->log.bios_event_log) {
 		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
 		       __func__);
 		of_node_put(np);
 		return -ENOMEM;
 	}
 
-	log->bios_event_log_end = log->bios_event_log + *sizep;
+	chip->log.bios_event_log_end = chip->log.bios_event_log + *sizep;
 
-	memcpy(log->bios_event_log, __va(*basep), *sizep);
+	memcpy(chip->log.bios_event_log, __va(*basep), *sizep);
 	of_node_put(np);
 
 	return 0;
-- 
2.5.0


------------------------------------------------------------------------------
