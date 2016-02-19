From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 08/11] tpm: Introduce TPM_CHIP_FLAG_VIRTUAL
Date: Fri, 19 Feb 2016 07:42:05 -0500
Message-ID: <1455885728-10315-9-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455885728-10315-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

Introduce TPM_CHIP_FLAG_VIRTUAL to be used when the chip device has no parent
device. Also adapt tpm_chip_alloc so that it can be called with parent device
being NULL.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c  | 10 +++++-----
 drivers/char/tpm/tpm-sysfs.c | 13 +++++++++----
 drivers/char/tpm/tpm.h       |  5 +++--
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 4fd36ba..2585f6a 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -168,9 +168,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = dev;
-#ifdef CONFIG_ACPI
 	chip->dev.groups = chip->groups;
-#endif
 
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
@@ -181,8 +179,10 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	if (err)
 		goto out;
 
+	if (!dev)
+		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
+
 	cdev_init(&chip->cdev, &tpm_fops);
-	chip->cdev.owner = dev->driver->owner;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
 
 	return chip;
@@ -318,7 +318,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 
 	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
 
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+	if (!(chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))) {
 		rc = __compat_only_sysfs_link_entry_to_kobj(
 		    &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
 		if (rc && rc != -ENOENT) {
@@ -359,7 +359,7 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
 	mutex_unlock(&idr_lock);
 
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+	if (!(chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL)))
 		sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
 
 	tpm1_chip_unregister(chip);
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 34e7fc7..127b0e5 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -283,9 +283,13 @@ static const struct attribute_group tpm_dev_group = {
 
 int tpm_sysfs_add_device(struct tpm_chip *chip)
 {
-	int err;
-	err = sysfs_create_group(&chip->dev.parent->kobj,
-				 &tpm_dev_group);
+	int err = 0;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_VIRTUAL))
+		err = sysfs_create_group(&chip->dev.parent->kobj,
+					 &tpm_dev_group);
+	else
+		chip->groups[chip->groups_cnt++] = &tpm_dev_group;
 
 	if (err)
 		dev_err(&chip->dev,
@@ -300,5 +304,6 @@ void tpm_sysfs_del_device(struct tpm_chip *chip)
 	 * synchronizes this removal so that no callbacks are running or can
 	 * run again
 	 */
-	sysfs_remove_group(&chip->dev.parent->kobj, &tpm_dev_group);
+	if (!(chip->flags & TPM_CHIP_FLAG_VIRTUAL))
+		sysfs_remove_group(&chip->dev.parent->kobj, &tpm_dev_group);
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 2ca5fb4..dc50ca6 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -168,6 +168,7 @@ struct tpm_vendor_specific {
 enum tpm_chip_flags {
 	TPM_CHIP_FLAG_REGISTERED	= BIT(0),
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
+	TPM_CHIP_FLAG_VIRTUAL		= BIT(2),
 };
 
 struct tpm_chip {
@@ -193,9 +194,9 @@ struct tpm_chip {
 
 	struct dentry **bios_dir;
 
-#ifdef CONFIG_ACPI
-	const struct attribute_group *groups[2];
+	const struct attribute_group *groups[3];
 	unsigned int groups_cnt;
+#ifdef CONFIG_ACPI
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
 #endif /* CONFIG_ACPI */
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
