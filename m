From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v5 1/3] tpm: move event log init functions to tpm_eventlog_init.c
Date: Wed, 23 Nov 2016 12:27:35 -0500
Message-ID: <1479922057-8752-2-git-send-email-nayna@linux.vnet.ibm.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The device driver code for the event log has the init functions and
TPM 1.2 parsing logic both defined in same file(tpm_eventlog.c).

Since the initialization functions are common with the TPM 2.0 event
log support, this patch splits tpm_eventlog.c to have only TPM 1.2
event log parsing logic and moves the init functions into
tpm_eventlog_init.c.

Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
---
 drivers/char/tpm/Makefile            |   2 +-
 drivers/char/tpm/tpm_eventlog.c      | 165 +-----------------------------
 drivers/char/tpm/tpm_eventlog.h      |   3 +
 drivers/char/tpm/tpm_eventlog_init.c | 189 +++++++++++++++++++++++++++++++++++
 4 files changed, 197 insertions(+), 162 deletions(-)
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
index 2a15b86..86f7fe3 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -11,7 +11,8 @@
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
- * Access to the event log created by a system's firmware / BIOS
+ * Access to the TPM 1.2 event log created by a system's
+ * firmware / BIOS
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -260,17 +261,6 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
 
 }
 
-static int tpm_bios_measurements_release(struct inode *inode,
-					 struct file *file)
-{
-	struct seq_file *seq = (struct seq_file *)file->private_data;
-	struct tpm_chip *chip = (struct tpm_chip *)seq->private;
-
-	put_device(&chip->dev);
-
-	return seq_release(inode, file);
-}
-
 static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
 {
 	int len = 0;
@@ -304,163 +294,16 @@ static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static const struct seq_operations tpm_ascii_b_measurements_seqops = {
+const struct seq_operations tpm_ascii_b_measurements_seqops = {
 	.start = tpm_bios_measurements_start,
 	.next = tpm_bios_measurements_next,
 	.stop = tpm_bios_measurements_stop,
 	.show = tpm_ascii_bios_measurements_show,
 };
 
-static const struct seq_operations tpm_binary_b_measurements_seqops = {
+const struct seq_operations tpm_binary_b_measurements_seqops = {
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
-	struct tpm_chip_seqops *chip_seqops;
-	const struct seq_operations *seqops;
-	struct tpm_chip *chip;
-
-	inode_lock(inode);
-	if (!inode->i_private) {
-		inode_unlock(inode);
-		return -ENODEV;
-	}
-	chip_seqops = (struct tpm_chip_seqops *)inode->i_private;
-	seqops = chip_seqops->seqops;
-	chip = chip_seqops->chip;
-	get_device(&chip->dev);
-	inode_unlock(inode);
-
-	/* now register seq file */
-	err = seq_open(file, seqops);
-	if (!err) {
-		seq = file->private_data;
-		seq->private = chip;
-	}
-
-	return err;
-}
-
-static const struct file_operations tpm_bios_measurements_ops = {
-	.owner = THIS_MODULE,
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
-static int tpm_read_log(struct tpm_chip *chip)
-{
-	int rc;
-
-	if (chip->log.bios_event_log != NULL) {
-		dev_dbg(&chip->dev,
-			"%s: ERROR - event log already initialized\n",
-			__func__);
-		return -EFAULT;
-	}
-
-	rc = tpm_read_log_acpi(chip);
-	if (rc != -ENODEV)
-		return rc;
-
-	return tpm_read_log_of(chip);
-}
-
-/*
- * tpm_bios_log_setup() - Read the event log from the firmware
- * @chip: TPM chip to use.
- *
- * If an event log is found then the securityfs files are setup to
- * export it to userspace, otherwise nothing is done.
- *
- * Returns -ENODEV if the firmware has no event log.
- */
-int tpm_bios_log_setup(struct tpm_chip *chip)
-{
-	const char *name = dev_name(&chip->dev);
-	unsigned int cnt;
-	int rc = 0;
-
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return 0;
-
-	rc = tpm_read_log(chip);
-	if (rc)
-		return rc;
-
-	cnt = 0;
-	chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
-	if (is_bad(chip->bios_dir[cnt]))
-		goto err;
-	cnt++;
-
-	chip->bin_log_seqops.chip = chip;
-	chip->bin_log_seqops.seqops = &tpm_binary_b_measurements_seqops;
-
-	chip->bios_dir[cnt] =
-	    securityfs_create_file("binary_bios_measurements",
-				   0440, chip->bios_dir[0],
-				   (void *)&chip->bin_log_seqops,
-				   &tpm_bios_measurements_ops);
-	if (is_bad(chip->bios_dir[cnt]))
-		goto err;
-	cnt++;
-
-	chip->ascii_log_seqops.chip = chip;
-	chip->ascii_log_seqops.seqops = &tpm_ascii_b_measurements_seqops;
-
-	chip->bios_dir[cnt] =
-	    securityfs_create_file("ascii_bios_measurements",
-				   0440, chip->bios_dir[0],
-				   (void *)&chip->ascii_log_seqops,
-				   &tpm_bios_measurements_ops);
-	if (is_bad(chip->bios_dir[cnt]))
-		goto err;
-	cnt++;
-
-	return 0;
-
-err:
-	chip->bios_dir[cnt] = NULL;
-	tpm_bios_log_teardown(chip);
-	return -EIO;
-}
-
-void tpm_bios_log_teardown(struct tpm_chip *chip)
-{
-	int i;
-	struct inode *inode;
-
-	/* securityfs_remove currently doesn't take care of handling sync
-	 * between removal and opening of pseudo files. To handle this, a
-	 * workaround is added by making i_private = NULL here during removal
-	 * and to check it during open(), both within inode_lock()/unlock().
-	 * This design ensures that open() either safely gets kref or fails.
-	 */
-	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
-		if (chip->bios_dir[i]) {
-			inode = d_inode(chip->bios_dir[i]);
-			inode_lock(inode);
-			inode->i_private = NULL;
-			inode_unlock(inode);
-			securityfs_remove(chip->bios_dir[i]);
-		}
-	}
-}
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 1660d74..155467d 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -73,6 +73,9 @@ enum tcpa_pc_event_ids {
 	HOST_TABLE_OF_DEVICES,
 };
 
+extern const struct seq_operations tpm_ascii_b_measurements_seqops;
+extern const struct seq_operations tpm_binary_b_measurements_seqops;
+
 #if defined(CONFIG_ACPI)
 int tpm_read_log_acpi(struct tpm_chip *chip);
 #else
diff --git a/drivers/char/tpm/tpm_eventlog_init.c b/drivers/char/tpm/tpm_eventlog_init.c
new file mode 100644
index 0000000..ae42f46
--- /dev/null
+++ b/drivers/char/tpm/tpm_eventlog_init.c
@@ -0,0 +1,189 @@
+/*
+ * Copyright (C) 2005, 2012 IBM Corporation
+ *
+ * Authors:
+ *	Kent Yoder <key@linux.vnet.ibm.com>
+ *	Seiji Munetoh <munetoh@jp.ibm.com>
+ *	Stefan Berger <stefanb@us.ibm.com>
+ *	Reiner Sailer <sailer@watson.ibm.com>
+ *	Kylene Hall <kjhall@us.ibm.com>
+ *	Nayna Jain <nayna@linux.vnet.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
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
+	struct seq_file *seq = (struct seq_file *)file->private_data;
+	struct tpm_chip *chip = (struct tpm_chip *)seq->private;
+
+	put_device(&chip->dev);
+
+	return seq_release(inode, file);
+}
+
+static int tpm_bios_measurements_open(struct inode *inode,
+					    struct file *file)
+{
+	int err;
+	struct seq_file *seq;
+	struct tpm_chip_seqops *chip_seqops;
+	const struct seq_operations *seqops;
+	struct tpm_chip *chip;
+
+	inode_lock(inode);
+	if (!inode->i_private) {
+		inode_unlock(inode);
+		return -ENODEV;
+	}
+	chip_seqops = (struct tpm_chip_seqops *)inode->i_private;
+	seqops = chip_seqops->seqops;
+	chip = chip_seqops->chip;
+	get_device(&chip->dev);
+	inode_unlock(inode);
+
+	/* now register seq file */
+	err = seq_open(file, seqops);
+	if (!err) {
+		seq = file->private_data;
+		seq->private = chip;
+	}
+
+	return err;
+}
+
+static const struct file_operations tpm_bios_measurements_ops = {
+	.owner = THIS_MODULE,
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
+static int tpm_read_log(struct tpm_chip *chip)
+{
+	int rc;
+
+	if (chip->log.bios_event_log != NULL) {
+		dev_dbg(&chip->dev,
+			"%s: ERROR - event log already initialized\n",
+			__func__);
+		return -EFAULT;
+	}
+
+	rc = tpm_read_log_acpi(chip);
+	if (rc != -ENODEV)
+		return rc;
+
+	return tpm_read_log_of(chip);
+}
+
+/*
+ * tpm_bios_log_setup() - Read the event log from the firmware
+ * @chip: TPM chip to use.
+ *
+ * If an event log is found then the securityfs files are setup to
+ * export it to userspace, otherwise nothing is done.
+ *
+ * Returns -ENODEV if the firmware has no event log.
+ */
+int tpm_bios_log_setup(struct tpm_chip *chip)
+{
+	const char *name = dev_name(&chip->dev);
+	unsigned int cnt;
+	int rc = 0;
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return 0;
+
+	rc = tpm_read_log(chip);
+	if (rc)
+		return rc;
+
+	cnt = 0;
+	chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
+	if (is_bad(chip->bios_dir[cnt]))
+		goto err;
+	cnt++;
+
+	chip->bin_log_seqops.chip = chip;
+	chip->bin_log_seqops.seqops = &tpm_binary_b_measurements_seqops;
+
+	chip->bios_dir[cnt] =
+	    securityfs_create_file("binary_bios_measurements",
+				   0440, chip->bios_dir[0],
+				   (void *)&chip->bin_log_seqops,
+				   &tpm_bios_measurements_ops);
+	if (is_bad(chip->bios_dir[cnt]))
+		goto err;
+	cnt++;
+
+	chip->ascii_log_seqops.chip = chip;
+	chip->ascii_log_seqops.seqops = &tpm_ascii_b_measurements_seqops;
+
+	chip->bios_dir[cnt] =
+	    securityfs_create_file("ascii_bios_measurements",
+				   0440, chip->bios_dir[0],
+				   (void *)&chip->ascii_log_seqops,
+				   &tpm_bios_measurements_ops);
+	if (is_bad(chip->bios_dir[cnt]))
+		goto err;
+	cnt++;
+
+	return 0;
+
+err:
+	chip->bios_dir[cnt] = NULL;
+	tpm_bios_log_teardown(chip);
+	return -EIO;
+}
+
+void tpm_bios_log_teardown(struct tpm_chip *chip)
+{
+	int i;
+	struct inode *inode;
+
+	/* securityfs_remove currently doesn't take care of handling sync
+	 * between removal and opening of pseudo files. To handle this, a
+	 * workaround is added by making i_private = NULL here during removal
+	 * and to check it during open(), both within inode_lock()/unlock().
+	 * This design ensures that open() either safely gets kref or fails.
+	 */
+	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
+		if (chip->bios_dir[i]) {
+			inode = d_inode(chip->bios_dir[i]);
+			inode_lock(inode);
+			inode->i_private = NULL;
+			inode_unlock(inode);
+			securityfs_remove(chip->bios_dir[i]);
+		}
+	}
+}
-- 
2.5.0
