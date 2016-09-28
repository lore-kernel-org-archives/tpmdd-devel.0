From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 7/8] tpm: move event log init functions to
	tpm_eventlog_init.c
Date: Wed, 28 Sep 2016 04:34:41 -0400
Message-ID: <1475051682-23060-8-git-send-email-nayna@linux.vnet.ibm.com>
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

The device driver code for the event log has the init functions and
TPM 1.2 parsing logic both defined in same file(tpm_eventlog.c).

Since the initialization functions are common with the TPM 2.0 event
log support, this patch moves the init functions to tpm_eventlog_init.c.

Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Makefile            |   2 +-
 drivers/char/tpm/tpm_eventlog.c      | 130 +----------------------------
 drivers/char/tpm/tpm_eventlog.h      |   3 +
 drivers/char/tpm/tpm_eventlog_init.c | 155 +++++++++++++++++++++++++++++++++++
 4 files changed, 163 insertions(+), 127 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_eventlog_init.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index a05b1eb..1dc2671 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -3,7 +3,7 @@
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
-		tpm_eventlog.o
+		tpm_eventlog.o tpm_eventlog_init.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
 tpm-$(CONFIG_OF) += tpm_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index c327089..2492134 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -11,7 +11,8 @@
  *
  * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
  *
- * Access to the eventlog created by a system's firmware / BIOS
+ * Access to the TPM 1.2 event log created by a system's
+ * firmware / BIOS
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -258,12 +259,6 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
 
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
@@ -297,133 +292,16 @@ static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
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
-	const struct tpm_securityfs_data *sfs_data =
-		(const struct tpm_securityfs_data *)inode->i_private;
-	const struct seq_operations *seqops = sfs_data->seqops;
-
-	/* now register seq file */
-	err = seq_open(file, seqops);
-	if (!err) {
-		seq = file->private_data;
-		seq->private = sfs_data->log;
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
-		dev_dbg(&chip->dev, "%s: ERROR - Eventlog already initialized\n",
-			__func__);
-		return -EFAULT;
-	}
-
-	rc = read_log_acpi(chip);
-	if ((rc == 0) || (rc == -ENOMEM))
-		return rc;
-	rc = read_log_of(chip);
-	return rc;
-
-}
-
-int tpm_bios_log_setup(struct tpm_chip *chip)
-{
-	const char *name = dev_name(&chip->dev);
-	int rc = 0;
-
-	rc = read_log(chip);
-	/*
-	 * read_log failure means event log is not supported except for ENOMEM
-	 */
-	if (rc < 0) {
-		if (rc == -ENOMEM)
-			return rc;
-		else
-			return 0;
-	}
-
-	chip->bios_dir_count = 0;
-	chip->bios_dir[chip->bios_dir_count] =
-		securityfs_create_dir(name, NULL);
-	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
-		goto err;
-	chip->bios_dir_count++;
-
-	chip->bin_sfs_data.log = &chip->log;
-	chip->bin_sfs_data.seqops = &tpm_binary_b_measurments_seqops;
-
-	chip->bios_dir[chip->bios_dir_count] =
-	    securityfs_create_file("binary_bios_measurements",
-				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
-				   (void *)&chip->bin_sfs_data,
-				   &tpm_bios_measurements_ops);
-	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
-		goto err;
-	chip->bios_dir_count++;
-
-	chip->ascii_sfs_data.log = &chip->log;
-	chip->ascii_sfs_data.seqops =  &tpm_ascii_b_measurments_seqops;
-	chip->bios_dir[chip->bios_dir_count] =
-	    securityfs_create_file("ascii_bios_measurements",
-				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
-				   (void *)&chip->ascii_sfs_data,
-				   &tpm_bios_measurements_ops);
-	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
-		goto err;
-	chip->bios_dir_count++;
-
-	return 0;
-
-err:
-	tpm_bios_log_teardown(chip);
-	return -EIO;
-}
-
-void tpm_bios_log_teardown(struct tpm_chip *chip)
-{
-	int i;
-
-	for (i = chip->bios_dir_count; i > 0; --i)
-		securityfs_remove(chip->bios_dir[i-1]);
-	chip->bios_dir_count = i;
-
-	kfree(chip->log.bios_event_log);
-}
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 9e95b7e..ed6ab93 100644
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
index 0000000..c4ac42630
--- /dev/null
+++ b/drivers/char/tpm/tpm_eventlog_init.c
@@ -0,0 +1,155 @@
+/*
+ * Copyright (C) 2005, 2012 IBM Corporation
+ *
+ * Authors:
+ *	Kent Yoder <key-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
+ *	Seiji Munetoh <munetoh-JE5g2YyFxFHQT0dZR+AlfA@public.gmane.org>
+ *	Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *	Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ *	Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *	Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
+ *
+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+ *
+ * Defines common initialization functions to access
+ * firmware event log for TPM 1.2 and TPM 2.0
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
+					 struct file *file)
+{
+	return seq_release(inode, file);
+}
+
+
+static int tpm_bios_measurements_open(struct inode *inode,
+					    struct file *file)
+{
+	int err;
+	struct seq_file *seq;
+	const struct tpm_securityfs_data *sfs_data =
+		(const struct tpm_securityfs_data *)inode->i_private;
+	const struct seq_operations *seqops = sfs_data->seqops;
+
+	/* now register seq file */
+	err = seq_open(file, seqops);
+	if (!err) {
+		seq = file->private_data;
+		seq->private = sfs_data->log;
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
+int tpm_bios_log_setup(struct tpm_chip *chip)
+{
+	const char *name = dev_name(&chip->dev);
+	int rc = 0;
+
+	rc = read_log(chip);
+	/*
+	 * read_log failure means event log is not supported except for ENOMEM
+	 */
+	if (rc < 0) {
+		if (rc == -ENOMEM)
+			return rc;
+		else
+			return 0;
+	}
+
+	chip->bios_dir_count = 0;
+	chip->bios_dir[chip->bios_dir_count] =
+		securityfs_create_dir(name, NULL);
+	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
+		goto err;
+	chip->bios_dir_count++;
+
+	chip->bin_sfs_data.log = &chip->log;
+	chip->bin_sfs_data.seqops = &tpm_binary_b_measurments_seqops;
+
+	chip->bios_dir[chip->bios_dir_count] =
+	    securityfs_create_file("binary_bios_measurements",
+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
+				   (void *)&chip->bin_sfs_data,
+				   &tpm_bios_measurements_ops);
+	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
+		goto err;
+	chip->bios_dir_count++;
+
+	chip->ascii_sfs_data.log = &chip->log;
+	chip->ascii_sfs_data.seqops =  &tpm_ascii_b_measurments_seqops;
+	chip->bios_dir[chip->bios_dir_count] =
+	    securityfs_create_file("ascii_bios_measurements",
+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
+				   (void *)&chip->ascii_sfs_data,
+				   &tpm_bios_measurements_ops);
+	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
+		goto err;
+	chip->bios_dir_count++;
+
+	return 0;
+
+err:
+	tpm_bios_log_teardown(chip);
+	return -EIO;
+}
+
+void tpm_bios_log_teardown(struct tpm_chip *chip)
+{
+	int i;
+
+	for (i = chip->bios_dir_count; i > 0; --i)
+		securityfs_remove(chip->bios_dir[i-1]);
+	chip->bios_dir_count = i;
+
+	kfree(chip->log.bios_event_log);
+}
-- 
2.5.0


------------------------------------------------------------------------------
