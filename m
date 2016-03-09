From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6 07/11] tpm: Introduce TPM_CHIP_FLAG_VIRTUAL
Date: Wed,  9 Mar 2016 12:39:26 -0500
Message-ID: <1457545170-30120-8-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1457545170-30120-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

Introduce TPM_CHIP_FLAG_VIRTUAL to be used when the chip device has no
parent device. Also adapt tpm_chip_alloc so that it can be called with
parent device being NULL.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c  |  9 +++++----
 drivers/char/tpm/tpm-sysfs.c | 15 +++++++++++----
 drivers/char/tpm/tpm.h       |  5 +++--
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index f62c851..e4e1fad 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -170,9 +170,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = dev;
-#ifdef CONFIG_ACPI
 	chip->dev.groups = chip->groups;
-#endif
 
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
@@ -183,6 +181,9 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	if (rc)
 		goto out;
 
+	if (!dev)
+		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
+
 	cdev_init(&chip->cdev, &tpm_fops);
 	chip->cdev.owner = THIS_MODULE;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
@@ -327,7 +328,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 
 	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
 
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+	if (!(chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))) {
 		rc = __compat_only_sysfs_link_entry_to_kobj(
 		    &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
 		if (rc && rc != -ENOENT) {
@@ -361,7 +362,7 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	if (!(chip->flags & TPM_CHIP_FLAG_REGISTERED))
 		return;
 
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+	if (!(chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL)))
 		sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
 
 	tpm1_chip_unregister(chip);
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 34e7fc7..9ee0f4d 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -283,9 +283,15 @@ static const struct attribute_group tpm_dev_group = {
 
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
+	else {
+		dev_set_drvdata(&chip->dev, chip);
+		chip->groups[chip->groups_cnt++] = &tpm_dev_group;
+	}
 
 	if (err)
 		dev_err(&chip->dev,
@@ -300,5 +306,6 @@ void tpm_sysfs_del_device(struct tpm_chip *chip)
 	 * synchronizes this removal so that no callbacks are running or can
 	 * run again
 	 */
-	sysfs_remove_group(&chip->dev.parent->kobj, &tpm_dev_group);
+	if (!(chip->flags & TPM_CHIP_FLAG_VIRTUAL))
+		sysfs_remove_group(&chip->dev.parent->kobj, &tpm_dev_group);
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 928b47f..f197eef 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -164,6 +164,7 @@ struct tpm_vendor_specific {
 enum tpm_chip_flags {
 	TPM_CHIP_FLAG_REGISTERED	= BIT(0),
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
+	TPM_CHIP_FLAG_VIRTUAL		= BIT(2),
 };
 
 struct tpm_chip {
@@ -189,9 +190,9 @@ struct tpm_chip {
 
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
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
