From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 4/7] tpm: fix the race condition between
	event log access and chip getting unregistered
Date: Tue, 18 Oct 2016 20:49:42 -0400
Message-ID: <1476838185-24007-5-git-send-email-nayna@linux.vnet.ibm.com>
References: <1476838185-24007-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1476838185-24007-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

Currently, the event log file operations are not serialized with
tpm_chip_unregister(), which can possibly cause a race condition.

This patch fixes the race condition by:
 - moving read_log() from fops to chip register.
 - disallowing event log file operations when chip unregister is in
   progress.
 - guarding event log memory using chip krefs.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c     |  1 +
 drivers/char/tpm/tpm.h          | 11 ++++++
 drivers/char/tpm/tpm_acpi.c     | 12 +++++--
 drivers/char/tpm/tpm_eventlog.c | 80 ++++++++++++++++++++++++++---------------
 drivers/char/tpm/tpm_eventlog.h |  2 +-
 drivers/char/tpm/tpm_of.c       |  4 ++-
 6 files changed, 76 insertions(+), 34 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index eac1f10..813e0d7 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -127,6 +127,7 @@ static void tpm_dev_release(struct device *dev)
 	idr_remove(&dev_nums_idr, chip->dev_num);
 	mutex_unlock(&idr_lock);
 
+	kfree(chip->log.bios_event_log);
 	kfree(chip);
 }
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4c118a4..bfe93e6 100644
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
@@ -146,6 +148,11 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
 };
 
+struct tpm_chip_seqops {
+	struct tpm_chip *chip;
+	const struct seq_operations *seqops;
+};
+
 struct tpm_chip {
 	struct device dev;
 	struct cdev cdev;
@@ -157,6 +164,10 @@ struct tpm_chip {
 	struct rw_semaphore ops_sem;
 	const struct tpm_class_ops *ops;
 
+	struct tpm_bios_log log;
+	struct tpm_chip_seqops bin_log_seqops;
+	struct tpm_chip_seqops ascii_log_seqops;
+
 	unsigned int flags;
 
 	int dev_num;		/* /dev/tpm# */
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 565a947..4d6c2d7 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -45,13 +45,15 @@ struct acpi_tcpa {
 };
 
 /* read binary bios log */
-int read_log(struct tpm_bios_log *log)
+int read_log(struct tpm_chip *chip)
 {
 	struct acpi_tcpa *buff;
 	acpi_status status;
 	void __iomem *virt;
 	u64 len, start;
+	struct tpm_bios_log *log;
 
+	log = &chip->log;
 	if (log->bios_event_log != NULL) {
 		printk(KERN_ERR
 		       "%s: ERROR - Eventlog already initialized\n",
@@ -97,13 +99,17 @@ int read_log(struct tpm_bios_log *log)
 
 	virt = acpi_os_map_iomem(start, len);
 	if (!virt) {
-		kfree(log->bios_event_log);
 		printk("%s: ERROR - Unable to map memory\n", __func__);
-		return -EIO;
+		goto err;
 	}
 
 	memcpy_fromio(log->bios_event_log, virt, len);
 
 	acpi_os_unmap_iomem(virt, len);
 	return 0;
+
+err:
+	kfree(log->bios_event_log);
+	return -EIO;
+
 }
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index 753e92d..bb142f2 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -73,7 +73,8 @@ static const char* tcpa_pc_event_id_strings[] = {
 static void *tpm_bios_measurements_start(struct seq_file *m, loff_t *pos)
 {
 	loff_t i;
-	struct tpm_bios_log *log = m->private;
+	struct tpm_chip *chip = m->private;
+	struct tpm_bios_log *log = &chip->log;
 	void *addr = log->bios_event_log;
 	void *limit = log->bios_event_log_end;
 	struct tcpa_event *event;
@@ -120,7 +121,8 @@ static void *tpm_bios_measurements_next(struct seq_file *m, void *v,
 					loff_t *pos)
 {
 	struct tcpa_event *event = v;
-	struct tpm_bios_log *log = m->private;
+	struct tpm_chip *chip = m->private;
+	struct tpm_bios_log *log = &chip->log;
 	void *limit = log->bios_event_log_end;
 	u32 converted_event_size;
 	u32 converted_event_type;
@@ -261,13 +263,10 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
 static int tpm_bios_measurements_release(struct inode *inode,
 					 struct file *file)
 {
-	struct seq_file *seq = file->private_data;
-	struct tpm_bios_log *log = seq->private;
+	struct seq_file *seq = (struct seq_file *)file->private_data;
+	struct tpm_chip *chip = (struct tpm_chip *)seq->private;
 
-	if (log) {
-		kfree(log->bios_event_log);
-		kfree(log);
-	}
+	put_device(&chip->dev);
 
 	return seq_release(inode, file);
 }
@@ -323,36 +322,34 @@ static int tpm_bios_measurements_open(struct inode *inode,
 					    struct file *file)
 {
 	int err;
-	struct tpm_bios_log *log;
 	struct seq_file *seq;
-	const struct seq_operations *seqops =
-		(const struct seq_operations *)inode->i_private;
-
-	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
-	if (!log)
-		return -ENOMEM;
-
-	if ((err = read_log(log)))
-		goto out_free;
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
 
 	/* now register seq file */
 	err = seq_open(file, seqops);
 	if (!err) {
 		seq = file->private_data;
-		seq->private = log;
-	} else {
-		goto out_free;
+		seq->private = chip;
 	}
 
-out:
+	inode_unlock(inode);
 	return err;
-out_free:
-	kfree(log->bios_event_log);
-	kfree(log);
-	goto out;
 }
 
 static const struct file_operations tpm_bios_measurements_ops = {
+	.owner = THIS_MODULE,
 	.open = tpm_bios_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -372,10 +369,22 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 {
 	const char *name = dev_name(&chip->dev);
 	unsigned int cnt;
+	int rc = 0;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return 0;
 
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
 	cnt = 0;
 	chip->bios_dir[cnt] =
 		securityfs_create_dir(name, NULL);
@@ -383,19 +392,25 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 		goto err;
 	cnt++;
 
+	chip->bin_log_seqops.chip = chip;
+	chip->bin_log_seqops.seqops = &tpm_binary_b_measurments_seqops;
+
 	chip->bios_dir[cnt] =
 	    securityfs_create_file("binary_bios_measurements",
 				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
-				   (void *)&tpm_binary_b_measurments_seqops,
+				   (void *)&chip->bin_log_seqops,
 				   &tpm_bios_measurements_ops);
 	if (is_bad(chip->bios_dir[cnt]))
 		goto err;
 	cnt++;
 
+	chip->ascii_log_seqops.chip = chip;
+	chip->ascii_log_seqops.seqops = &tpm_ascii_b_measurments_seqops;
+
 	chip->bios_dir[cnt] =
 	    securityfs_create_file("ascii_bios_measurements",
 				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
-				   (void *)&tpm_ascii_b_measurments_seqops,
+				   (void *)&chip->ascii_log_seqops,
 				   &tpm_bios_measurements_ops);
 	if (is_bad(chip->bios_dir[cnt]))
 		goto err;
@@ -412,7 +427,14 @@ err:
 void tpm_bios_log_teardown(struct tpm_chip *chip)
 {
 	int i;
+	struct inode *inode;
 
-	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--)
+	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
+		inode = d_inode(chip->bios_dir[i]);
+		inode_lock(inode);
+		inode->i_private = NULL;
+		inode_unlock(inode);
 		securityfs_remove(chip->bios_dir[i]);
+	}
+
 }
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index fd3357e..6df2f8e 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -73,7 +73,7 @@ enum tcpa_pc_event_ids {
 	HOST_TABLE_OF_DEVICES,
 };
 
-int read_log(struct tpm_bios_log *log);
+int read_log(struct tpm_chip *chip);
 
 #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
 	defined(CONFIG_ACPI)
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 570f30c..68d891a 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -20,12 +20,14 @@
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
-int read_log(struct tpm_bios_log *log)
+int read_log(struct tpm_chip *chip)
 {
 	struct device_node *np;
 	const u32 *sizep;
 	const u64 *basep;
+	struct tpm_bios_log *log;
 
+	log = &chip->log;
 	if (log->bios_event_log != NULL) {
 		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
 		return -EFAULT;
-- 
2.5.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
