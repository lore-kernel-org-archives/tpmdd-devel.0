From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 2/7] tpm: Replace the dynamically allocated
	bios_dir as struct dentry array.
Date: Tue, 30 Aug 2016 00:50:14 -0400
Message-ID: <1472532619-22170-3-git-send-email-nayna@linux.vnet.ibm.com>
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

bios_dir is defined as struct dentry **bios_dir, which results in
dynamic allocation and possible memory leak. This patch replaces
it with struct dentry array i.e. struct dentry *bios_dir[3]
similar to what is done for sysfs groups.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c     |  5 ++--
 drivers/char/tpm/tpm.h          |  3 ++-
 drivers/char/tpm/tpm_eventlog.c | 60 ++++++++++++++++++-----------------------
 drivers/char/tpm/tpm_eventlog.h | 10 +++----
 4 files changed, 35 insertions(+), 43 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index e595013..1cd1238 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -283,7 +283,7 @@ static int tpm1_chip_register(struct tpm_chip *chip)
 
 	tpm_sysfs_add_device(chip);
 
-	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
+	tpm_bios_log_setup(chip);
 
 	return 0;
 }
@@ -293,8 +293,7 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return;
 
-	if (chip->bios_dir)
-		tpm_bios_log_teardown(chip->bios_dir);
+	tpm_bios_log_teardown(chip);
 }
 
 static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 6e002c4..603a661 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -171,7 +171,8 @@ struct tpm_chip {
 	unsigned long duration[3]; /* jiffies */
 	bool duration_adjusted;
 
-	struct dentry **bios_dir;
+	struct dentry *bios_dir[3];
+	unsigned int bios_dir_count;
 
 	const struct attribute_group *groups[3];
 	unsigned int groups_cnt;
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index b0a4d02..9dd69a7 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -332,7 +332,8 @@ static int tpm_bios_measurements_open(struct inode *inode,
 	if (!log)
 		return -ENOMEM;
 
-	if ((err = read_log(log)))
+	err = read_log(log);
+	if (err)
 		goto out_free;
 
 	/* now register seq file */
@@ -368,54 +369,45 @@ static int is_bad(void *p)
 	return 0;
 }
 
-struct dentry **tpm_bios_log_setup(const char *name)
+void tpm_bios_log_setup(struct tpm_chip *chip)
 {
-	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
+	const char *name = dev_name(&chip->dev);
 
-	tpm_dir = securityfs_create_dir(name, NULL);
-	if (is_bad(tpm_dir))
-		goto out;
+	chip->bios_dir_count = 0;
+	chip->bios_dir[chip->bios_dir_count] = securityfs_create_dir(name,
+	NULL);
+	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
+		goto err;
+	chip->bios_dir_count++;
 
-	bin_file =
+	chip->bios_dir[chip->bios_dir_count] =
 	    securityfs_create_file("binary_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir,
+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
 				   (void *)&tpm_binary_b_measurments_seqops,
 				   &tpm_bios_measurements_ops);
-	if (is_bad(bin_file))
-		goto out_tpm;
+	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
+		goto err;
+	chip->bios_dir_count++;
 
-	ascii_file =
+	chip->bios_dir[chip->bios_dir_count] =
 	    securityfs_create_file("ascii_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir,
+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
 				   (void *)&tpm_ascii_b_measurments_seqops,
 				   &tpm_bios_measurements_ops);
-	if (is_bad(ascii_file))
-		goto out_bin;
+	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
+		goto err;
+	chip->bios_dir_count++;
 
-	ret = kmalloc(3 * sizeof(struct dentry *), GFP_KERNEL);
-	if (!ret)
-		goto out_ascii;
+	return;
 
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
+err:
+	tpm_bios_log_teardown(chip);
 }
 
-void tpm_bios_log_teardown(struct dentry **lst)
+void tpm_bios_log_teardown(struct tpm_chip *chip)
 {
 	int i;
 
-	for (i = 0; i < 3; i++)
-		securityfs_remove(lst[i]);
+	for (i = chip->bios_dir_count; i > 0; --i)
+		securityfs_remove(chip->bios_dir[i-1]);
 }
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 8de62b0..67621c9 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -77,14 +77,14 @@ int read_log(struct tpm_bios_log *log);
 
 #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
 	defined(CONFIG_ACPI)
-extern struct dentry **tpm_bios_log_setup(const char *);
-extern void tpm_bios_log_teardown(struct dentry **);
+extern void tpm_bios_log_setup(struct tpm_chip *chip);
+extern void tpm_bios_log_teardown(struct tpm_chip *chip);
 #else
-static inline struct dentry **tpm_bios_log_setup(const char *name)
+static inline void tpm_bios_log_setup(struct tpm_chip *chip)
 {
-	return NULL;
+	chip->bios_dir_count = 0;
 }
-static inline void tpm_bios_log_teardown(struct dentry **dir)
+static inline void tpm_bios_log_teardown(struct tpm_chip *chip)
 {
 }
 #endif
-- 
2.5.0


------------------------------------------------------------------------------
