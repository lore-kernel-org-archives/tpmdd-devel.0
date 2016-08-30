From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 6/7] tpm: Moves the eventlog init functions
	to tpm_eventlog_init.c
Date: Tue, 30 Aug 2016 00:50:18 -0400
Message-ID: <1472532619-22170-7-git-send-email-nayna@linux.vnet.ibm.com>
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

Eventlog initialization functions are common for TPM1.2 and TPM2.0
Currently, they are defined in tpm_eventlog.c which does parsing of
TPM1.2 specific eventlog.

Since initialization functions are common for TPM2.0 also, have
moved the init functions to tpm_eventlog_init.c.

Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Makefile            |   2 +-
 drivers/char/tpm/tpm_eventlog.c      | 116 +---------------------------
 drivers/char/tpm/tpm_eventlog.h      |   3 +
 drivers/char/tpm/tpm_eventlog_init.c | 143 +++++++++++++++++++++++++++++++++++
 4 files changed, 149 insertions(+), 115 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_eventlog_init.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index e8c7b4d..200b957 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -3,7 +3,7 @@
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
-	tpm_eventlog.o
+	tpm_eventlog.o tpm_eventlog_init.o
 
 tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
 tpm-$(CONFIG_OF) += tpm_of.o
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index f84ce71..3f1aba5 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -258,12 +258,6 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
 
 }
 
-static int tpm_bios_measurements_release(struct inode *inode,
-					 struct file *file)
-{
-	return seq_release(inode, file);
-}
-
 static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
 {
 	int len = 0;
@@ -297,122 +291,16 @@ static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static const struct seq_operations tpm_ascii_b_measurments_seqops = {
+const struct seq_operations tpm_ascii_b_measurments_seqops = {
 	.start = tpm_bios_measurements_start,
 	.next = tpm_bios_measurements_next,
 	.stop = tpm_bios_measurements_stop,
 	.show = tpm_ascii_bios_measurements_show,
 };
 
-static const struct seq_operations tpm_binary_b_measurments_seqops = {
+const struct seq_operations tpm_binary_b_measurments_seqops = {
 	.start = tpm_bios_measurements_start,
 	.next = tpm_bios_measurements_next,
 	.stop = tpm_bios_measurements_stop,
 	.show = tpm_binary_bios_measurements_show,
 };
-
-static int tpm_bios_measurements_open(struct inode *inode,
-					    struct file *file)
-{
-	int err;
-	struct seq_file *seq;
-	struct tpm_chip *chip;
-	const struct seq_operations *seqops =
-	(const struct seq_operations *)inode->i_private;
-
-	chip = (struct tpm_chip
-	*)file->f_path.dentry->d_parent->d_inode->i_private;
-
-	/* now register seq file */
-	err = seq_open(file, seqops);
-	if (!err) {
-		seq = file->private_data;
-		seq->private = &chip->log;
-	}
-
-	return err;
-}
-
-static const struct file_operations tpm_bios_measurements_ops = {
-	.open = tpm_bios_measurements_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = tpm_bios_measurements_release,
-};
-
-static int is_bad(void *p)
-{
-	if (!p)
-		return 1;
-	if (IS_ERR(p) && (PTR_ERR(p) != -ENODEV))
-		return 1;
-	return 0;
-}
-
-int read_log(struct tpm_chip *chip)
-{
-	int rc;
-
-	if (chip->log.bios_event_log != NULL) {
-		dev_dbg(&chip->dev, "%s:ERROR - Eventlog already initialized\n",
-			__func__);
-		return -EFAULT;
-	}
-
-	rc = read_log_acpi(chip);
-	if (rc == 0)
-		return rc;
-	rc = read_log_of(chip);
-	return rc;
-}
-
-void tpm_bios_log_setup(struct tpm_chip *chip)
-{
-	const char *name = dev_name(&chip->dev);
-	int rc = 0;
-
-	rc = read_log(chip);
-	if (rc < 0)
-		return;
-
-	chip->bios_dir_count = 0;
-	chip->bios_dir[chip->bios_dir_count] = securityfs_create_dir(name,
-	NULL);
-	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
-		goto err;
-	chip->bios_dir[chip->bios_dir_count]->d_inode->i_private = chip;
-	chip->bios_dir_count++;
-
-	chip->bios_dir[chip->bios_dir_count] =
-	    securityfs_create_file("binary_bios_measurements",
-				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
-				   (void *)&tpm_binary_b_measurments_seqops,
-				   &tpm_bios_measurements_ops);
-	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
-		goto err;
-	chip->bios_dir_count++;
-
-	chip->bios_dir[chip->bios_dir_count] =
-	    securityfs_create_file("ascii_bios_measurements",
-				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
-				   (void *)&tpm_ascii_b_measurments_seqops,
-				   &tpm_bios_measurements_ops);
-	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
-		goto err;
-	chip->bios_dir_count++;
-
-	return;
-
-err:
-	tpm_bios_log_teardown(chip);
-}
-
-void tpm_bios_log_teardown(struct tpm_chip *chip)
-{
-	int i;
-
-	for (i = chip->bios_dir_count; i > 0; --i)
-		securityfs_remove(chip->bios_dir[i-1]);
-
-	kfree(chip->log.bios_event_log);
-}
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 0e599ab..6a36a9d 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -12,6 +12,9 @@
 #define do_endian_conversion(x) x
 #endif
 
+extern const struct seq_operations tpm_ascii_b_measurments_seqops;
+extern const struct seq_operations tpm_binary_b_measurments_seqops;
+
 enum bios_platform_class {
 	BIOS_CLIENT = 0x00,
 	BIOS_SERVER = 0x01,
diff --git a/drivers/char/tpm/tpm_eventlog_init.c b/drivers/char/tpm/tpm_eventlog_init.c
new file mode 100644
index 0000000..038771a
--- /dev/null
+++ b/drivers/char/tpm/tpm_eventlog_init.c
@@ -0,0 +1,143 @@
+/*
+ * Copyright (C) 2005, 2012 IBM Corporation
+ *
+ * Authors:
+ *	Kent Yoder <key-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
+ *	Seiji Munetoh <munetoh-JE5g2YyFxFHQT0dZR+AlfA@public.gmane.org>
+ *	Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *	Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ *	Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *      Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
+ *
+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+ *
+ * Defines TPM1.2 and TPM2.0 common initialization functions
+ * to access firmware eventlog.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/security.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "tpm.h"
+#include "tpm_eventlog.h"
+
+static int tpm_bios_measurements_release(struct inode *inode,
+					struct file *file)
+{
+	return seq_release(inode, file);
+}
+
+static int tpm_bios_measurements_open(struct inode *inode,
+					    struct file *file)
+{
+	int err;
+	struct seq_file *seq;
+	struct tpm_chip *chip;
+	const struct seq_operations *seqops =
+	(const struct seq_operations *)inode->i_private;
+
+	chip = (struct tpm_chip
+	*)file->f_path.dentry->d_parent->d_inode->i_private;
+
+	/* now register seq file */
+	err = seq_open(file, seqops);
+	if (!err) {
+		seq = file->private_data;
+		seq->private = &chip->log;
+	}
+
+	return err;
+}
+
+static const struct file_operations tpm_bios_measurements_ops = {
+	.open = tpm_bios_measurements_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = tpm_bios_measurements_release,
+};
+
+static int is_bad(void *p)
+{
+	if (!p)
+		return 1;
+	if (IS_ERR(p) && (PTR_ERR(p) != -ENODEV))
+		return 1;
+	return 0;
+}
+
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
+void tpm_bios_log_setup(struct tpm_chip *chip)
+{
+	const char *name = dev_name(&chip->dev);
+	int rc = 0;
+
+	rc = read_log(chip);
+	if (rc < 0)
+		return;
+
+	chip->bios_dir_count = 0;
+	chip->bios_dir[chip->bios_dir_count] = securityfs_create_dir(name,
+	NULL);
+	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
+		goto err;
+	chip->bios_dir[chip->bios_dir_count]->d_inode->i_private = chip;
+	chip->bios_dir_count++;
+
+	chip->bios_dir[chip->bios_dir_count] =
+	    securityfs_create_file("binary_bios_measurements",
+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
+				   (void *)&tpm_binary_b_measurments_seqops,
+				   &tpm_bios_measurements_ops);
+	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
+		goto err;
+	chip->bios_dir_count++;
+
+	chip->bios_dir[chip->bios_dir_count] =
+	    securityfs_create_file("ascii_bios_measurements",
+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
+				   (void *)&tpm_ascii_b_measurments_seqops,
+				   &tpm_bios_measurements_ops);
+	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
+		goto err;
+	chip->bios_dir_count++;
+
+	return;
+
+err:
+	tpm_bios_log_teardown(chip);
+}
+
+void tpm_bios_log_teardown(struct tpm_chip *chip)
+{
+	int i;
+
+	for (i = chip->bios_dir_count; i > 0; --i)
+		securityfs_remove(chip->bios_dir[i-1]);
+
+	kfree(chip->log.bios_event_log);
+}
-- 
2.5.0


------------------------------------------------------------------------------
