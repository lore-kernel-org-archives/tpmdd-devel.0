From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 1/2] TPM2.0: Refactor eventlog init functions
	for TPM1.2 and
Date: Fri, 29 Jul 2016 02:44:38 -0400
Message-ID: <1469774679-25232-2-git-send-email-nayna@linux.vnet.ibm.com>
References: <1469774679-25232-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1469774679-25232-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

Refactored eventlog.c file into tpm_eventlog.c and tpm_eventlog_init.c

Breakdown is:

* tpm_eventlog_init.c : Moved eventlog initialization methods like
to setup securityfs, to open and release seqfile from tpm_eventlog.c
to this file. This is to keep the logic of initialization for TPM1.2
and TPM2.0 in common file.

* tpm_eventlog.c : This file now has only methods specific to parsing
and iterate TPM1.2 entry log formats. It can understand only TPM1.2
and is called by methods in tpm_eventlog_init if identified TPM device
is TPM1.2.

Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Makefile            |   4 +-
 drivers/char/tpm/tpm_eventlog.c      | 156 +----------------------------
 drivers/char/tpm/tpm_eventlog.h      |   3 +
 drivers/char/tpm/tpm_eventlog_init.c | 183 +++++++++++++++++++++++++++++++++++
 4 files changed, 192 insertions(+), 154 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_eventlog_init.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index a385fb8..9136762 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -6,10 +6,10 @@ tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
-	tpm-y += tpm_eventlog.o tpm_acpi.o
+	tpm-y += tpm_eventlog_init.o tpm_eventlog.o tpm_acpi.o
 else
 ifdef CONFIG_TCG_IBMVTPM
-	tpm-y += tpm_eventlog.o tpm_of.o
+	tpm-y += tpm_eventlog_init.o tpm_eventlog.o tpm_of.o
 endif
 endif
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index e722886..b8f22ec 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2005, 2012 IBM Corporation
+ * Copyright (C) 2005, 2012, 2016 IBM Corporation
  *
  * Authors:
  *	Kent Yoder <key-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
@@ -11,6 +11,7 @@
  * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
  *
  * Access to the eventlog created by a system's firmware / BIOS
+ * specific to TPM 1.2.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -257,20 +258,6 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
 
 }
 
-static int tpm_bios_measurements_release(struct inode *inode,
-					 struct file *file)
-{
-	struct seq_file *seq = file->private_data;
-	struct tpm_bios_log *log = seq->private;
-
-	if (log) {
-		kfree(log->bios_event_log);
-		kfree(log);
-	}
-
-	return seq_release(inode, file);
-}
-
 static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
 {
 	int len = 0;
@@ -304,151 +291,16 @@ static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
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
-static int tpm_ascii_bios_measurements_open(struct inode *inode,
-					    struct file *file)
-{
-	int err;
-	struct tpm_bios_log *log;
-	struct seq_file *seq;
-
-	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
-	if (!log)
-		return -ENOMEM;
-
-	if ((err = read_log(log)))
-		goto out_free;
-
-	/* now register seq file */
-	err = seq_open(file, &tpm_ascii_b_measurments_seqops);
-	if (!err) {
-		seq = file->private_data;
-		seq->private = log;
-	} else {
-		goto out_free;
-	}
-
-out:
-	return err;
-out_free:
-	kfree(log->bios_event_log);
-	kfree(log);
-	goto out;
-}
-
-static const struct file_operations tpm_ascii_bios_measurements_ops = {
-	.open = tpm_ascii_bios_measurements_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = tpm_bios_measurements_release,
-};
-
-static int tpm_binary_bios_measurements_open(struct inode *inode,
-					     struct file *file)
-{
-	int err;
-	struct tpm_bios_log *log;
-	struct seq_file *seq;
-
-	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
-	if (!log)
-		return -ENOMEM;
-
-	if ((err = read_log(log)))
-		goto out_free;
-
-	/* now register seq file */
-	err = seq_open(file, &tpm_binary_b_measurments_seqops);
-	if (!err) {
-		seq = file->private_data;
-		seq->private = log;
-	} else {
-		goto out_free;
-	}
-
-out:
-	return err;
-out_free:
-	kfree(log->bios_event_log);
-	kfree(log);
-	goto out;
-}
-
-static const struct file_operations tpm_binary_bios_measurements_ops = {
-	.open = tpm_binary_bios_measurements_open,
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
-struct dentry **tpm_bios_log_setup(const char *name)
-{
-	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
-
-	tpm_dir = securityfs_create_dir(name, NULL);
-	if (is_bad(tpm_dir))
-		goto out;
-
-	bin_file =
-	    securityfs_create_file("binary_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
-				   &tpm_binary_bios_measurements_ops);
-	if (is_bad(bin_file))
-		goto out_tpm;
-
-	ascii_file =
-	    securityfs_create_file("ascii_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
-				   &tpm_ascii_bios_measurements_ops);
-	if (is_bad(ascii_file))
-		goto out_bin;
-
-	ret = kmalloc(3 * sizeof(struct dentry *), GFP_KERNEL);
-	if (!ret)
-		goto out_ascii;
-
-	ret[0] = ascii_file;
-	ret[1] = bin_file;
-	ret[2] = tpm_dir;
-
-	return ret;
-
-out_ascii:
-	securityfs_remove(ascii_file);
-out_bin:
-	securityfs_remove(bin_file);
-out_tpm:
-	securityfs_remove(tpm_dir);
-out:
-	return NULL;
-}
-
-void tpm_bios_log_teardown(struct dentry **lst)
-{
-	int i;
-
-	for (i = 0; i < 3; i++)
-		securityfs_remove(lst[i]);
-}
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 8de62b0..37efac3 100644
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
index 0000000..8153509
--- /dev/null
+++ b/drivers/char/tpm/tpm_eventlog_init.c
@@ -0,0 +1,183 @@
+/*
+ * Copyright (C) 2005, 2012, 2016 IBM Corporation
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
+ * TPM 1.2 and TPM 2.0 common initialization methods to
+ * access the eventlog created by a system's firmware / BIOS.
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
+
+static int tpm_bios_measurements_release(struct inode *inode,
+					 struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct tpm_bios_log *log = seq->private;
+
+	if (log) {
+		kfree(log->bios_event_log);
+		kfree(log);
+	}
+
+	return seq_release(inode, file);
+}
+
+static int tpm_ascii_bios_measurements_open(struct inode *inode,
+					    struct file *file)
+{
+	int err;
+	struct tpm_bios_log *log;
+	struct seq_file *seq;
+
+	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
+	if (!log)
+		return -ENOMEM;
+
+	err = read_log(log);
+	if (err)
+		goto out_free;
+
+	/* now register seq file */
+	err = seq_open(file, &tpm_ascii_b_measurments_seqops);
+	if (!err) {
+		seq = file->private_data;
+		seq->private = log;
+	} else {
+		goto out_free;
+	}
+
+out:
+	return err;
+out_free:
+	kfree(log->bios_event_log);
+	kfree(log);
+	goto out;
+}
+
+static const struct file_operations tpm_ascii_bios_measurements_ops = {
+	.open = tpm_ascii_bios_measurements_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = tpm_bios_measurements_release,
+};
+
+static int tpm_binary_bios_measurements_open(struct inode *inode,
+					     struct file *file)
+{
+	int err;
+	struct tpm_bios_log *log;
+	struct seq_file *seq;
+
+	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
+	if (!log)
+		return -ENOMEM;
+
+	err = read_log(log);
+	if (err)
+		goto out_free;
+
+	/* now register seq file */
+	err = seq_open(file, &tpm_binary_b_measurments_seqops);
+	if (!err) {
+		seq = file->private_data;
+		seq->private = log;
+	} else {
+		goto out_free;
+	}
+
+out:
+	return err;
+out_free:
+	kfree(log->bios_event_log);
+	kfree(log);
+	goto out;
+}
+
+static const struct file_operations tpm_binary_bios_measurements_ops = {
+	.open = tpm_binary_bios_measurements_open,
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
+struct dentry **tpm_bios_log_setup(const char *name)
+{
+	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
+
+	tpm_dir = securityfs_create_dir(name, NULL);
+	if (is_bad(tpm_dir))
+		goto out;
+
+	bin_file =
+	    securityfs_create_file("binary_bios_measurements",
+				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
+				   &tpm_binary_bios_measurements_ops);
+	if (is_bad(bin_file))
+		goto out_tpm;
+
+	ascii_file =
+	    securityfs_create_file("ascii_bios_measurements",
+				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
+				   &tpm_ascii_bios_measurements_ops);
+	if (is_bad(ascii_file))
+		goto out_bin;
+
+	ret = kmalloc(3 * sizeof(struct dentry *), GFP_KERNEL);
+	if (!ret)
+		goto out_ascii;
+
+	ret[0] = ascii_file;
+	ret[1] = bin_file;
+	ret[2] = tpm_dir;
+
+	return ret;
+
+out_ascii:
+	securityfs_remove(ascii_file);
+out_bin:
+	securityfs_remove(bin_file);
+out_tpm:
+	securityfs_remove(tpm_dir);
+out:
+	return NULL;
+}
+
+void tpm_bios_log_teardown(struct dentry **lst)
+{
+	int i;
+
+	for (i = 0; i < 3; i++)
+		securityfs_remove(lst[i]);
+}
-- 
2.5.0


------------------------------------------------------------------------------
