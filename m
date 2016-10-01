From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 1/2] tpm: define a generic open() method for
	ascii & bios measurements
Date: Sat,  1 Oct 2016 15:41:16 +0300
Message-ID: <1475325678-16573-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1475325678-16573-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1475325678-16573-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

open() method for event log ascii and binary bios measurements file
operations are very similar. This patch refactors the code into a
single open() call by passing seq_operations as i_node->private data.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm_eventlog.c | 59 +++++++++--------------------------------
 1 file changed, 13 insertions(+), 46 deletions(-)

diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index e722886..75e6644 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -7,6 +7,7 @@
  *	Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
  *	Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
  *	Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *	Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
  *
  * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
