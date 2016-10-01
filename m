From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RESEND 1/3] tpm: define a generic open() method for ascii & bios measurements
Date: Sat,  1 Oct 2016 22:25:24 +0300
Message-ID: <1475349926-476-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1475349926-476-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475349926-476-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Nayna Jain <nayna@linux.vnet.ibm.com>

open() method for event log ascii and binary bios measurements file
operations are very similar. This patch refactors the code into a
single open() call by passing seq_operations as i_node->private data.

Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm_eventlog.c | 59 +++++++++--------------------------------
 1 file changed, 13 insertions(+), 46 deletions(-)

diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index e722886..75e6644 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -7,6 +7,7 @@
  *	Stefan Berger <stefanb@us.ibm.com>
  *	Reiner Sailer <sailer@watson.ibm.com>
  *	Kylene Hall <kjhall@us.ibm.com>
+ *	Nayna Jain <nayna@linux.vnet.ibm.com>
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
@@ -318,12 +319,14 @@ static const struct seq_operations tpm_binary_b_measurments_seqops = {
 	.show = tpm_binary_bios_measurements_show,
 };
 
-static int tpm_ascii_bios_measurements_open(struct inode *inode,
+static int tpm_bios_measurements_open(struct inode *inode,
 					    struct file *file)
 {
 	int err;
 	struct tpm_bios_log *log;
 	struct seq_file *seq;
+	const struct seq_operations *seqops =
+		(const struct seq_operations *)inode->i_private;
 
 	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
 	if (!log)
@@ -333,7 +336,7 @@ static int tpm_ascii_bios_measurements_open(struct inode *inode,
 		goto out_free;
 
 	/* now register seq file */
-	err = seq_open(file, &tpm_ascii_b_measurments_seqops);
+	err = seq_open(file, seqops);
 	if (!err) {
 		seq = file->private_data;
 		seq->private = log;
@@ -349,46 +352,8 @@ out_free:
 	goto out;
 }
 
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
+static const struct file_operations tpm_bios_measurements_ops = {
+	.open = tpm_bios_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = tpm_bios_measurements_release,
@@ -413,15 +378,17 @@ struct dentry **tpm_bios_log_setup(const char *name)
 
 	bin_file =
 	    securityfs_create_file("binary_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
-				   &tpm_binary_bios_measurements_ops);
+				   S_IRUSR | S_IRGRP, tpm_dir,
+				   (void *)&tpm_binary_b_measurments_seqops,
+				   &tpm_bios_measurements_ops);
 	if (is_bad(bin_file))
 		goto out_tpm;
 
 	ascii_file =
 	    securityfs_create_file("ascii_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
-				   &tpm_ascii_bios_measurements_ops);
+				   S_IRUSR | S_IRGRP, tpm_dir,
+				   (void *)&tpm_ascii_b_measurments_seqops,
+				   &tpm_bios_measurements_ops);
 	if (is_bad(ascii_file))
 		goto out_bin;
 
-- 
2.7.4
