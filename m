From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Tue, 12 Apr 2016 11:54:40 -0600
Message-ID: <20160412175439.GB5759@obsidianresearch.com>
References: <57068198.6050407@linux.vnet.ibm.com>
	<20160411084358.GB11322@intel.com>
	<20160411181403.GB371@obsidianresearch.com>
	<201604111933.u3BJXErj001305@d03av03.boulder.ibm.com>
	<20160411202811.GA3663@obsidianresearch.com>
	<201604112030.u3BKUeJQ017181@d01av04.pok.ibm.com>
	<20160411205718.GC3663@obsidianresearch.com>
	<201604112213.u3BMD3i5028908@d03av02.boulder.ibm.com>
	<20160412000500.GC5861@obsidianresearch.com>
	<201604121512.u3CFCULH013445@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201604121512.u3CFCULH013445-8DuMPbUlb4HImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 12, 2016 at 11:18:20AM -0400, Stefan Berger wrote:
>    > Stick it before the TPM_CHIP_FLAG_VIRTUAL patch and throw away most of
>    > that patch. Just add two flag checks into tpm_add/del_legacy_sysfs()

>    Here's the v10 series now. If you want a better text for that patch,
>    please let me know.

Sure. I noticed a few other things, full tidied patch below, thanks for
taking this on.

>    I had to extend it to tpm-interface.c
>    [2]https://github.com/stefanberger/linux/commits/vtpm-driver.v10

Yes, that looks right, thanks

>    The patches pass my test suite and tpm tis seems to also work fine.
>    [3]https://github.com/stefanberger/linux-vtpm-tests

>    > +   rc = __compat_only_sysfs_link_entry_to_kobj(
>    > +      &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
>    > +   if (rc && rc != -ENOENT)
>    > +      goto out_err;
>    I wonder whether it is necessary to goto out_err or not just return rc
>    here?

Correct

Good catch on the tpm_pm_ functions too

>    Also, for tpm0 I now find the following two pcrs entries, as well as
>    all the rest of course:
>    /sys/devices/pnp0/00:05/tpm/tpm0/pcrs
>    /sys/devices/pnp0/00:05/pcrs
>    Is this intentionately?

Yes, the expectation is that the legacy path
'/sys/devices/pnp0/00:05/pcrs' is a symlink to the new path
'/sys/devices/pnp0/00:05/tpm/tpm0/pcrs'

I assume you saw that all the symlinks were working?

The way the tpm core created attributes on the parent device was never
correct, so this finally fixes it. Someday we can drop the legacy
symlinks.

BTW, I just noticed this needs a fix:

+#define VTPM_PROXY_IOC_NEW_DEV   _IOW(0xa1, 0x00, struct vtpm_proxy_new_dev)

Should be _IOWR since the struct is bidirectional

>From b09dd2f8d2c5242102649cd0473f161919af87fd Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Tue, 12 Apr 2016 11:48:21 -0600
Subject: [PATCH] tpm: Remove all uses of drvdata from the TPM Core

The final thing preventing this was the way the sysfs files were
attached to the pdev. Follow the approach developed for ppi and move
the sysfs files to the chip->dev with symlinks from the pdev
for compatibility. Everything in the core now sanely uses container_of
to get the chip.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c      | 73 ++++++++++++++++++++++++++++------------
 drivers/char/tpm/tpm-interface.c |  7 ++--
 drivers/char/tpm/tpm-sysfs.c     | 61 ++++++++++++++-------------------
 drivers/char/tpm/tpm.h           | 10 +++---
 4 files changed, 84 insertions(+), 67 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index f62c8518cd68..018a898de5b0 100644
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
@@ -275,14 +273,10 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 
 static int tpm1_chip_register(struct tpm_chip *chip)
 {
-	int rc;
-
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return 0;
 
-	rc = tpm_sysfs_add_device(chip);
-	if (rc)
-		return rc;
+	tpm_sysfs_add_device(chip);
 
 	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
 
@@ -296,10 +290,50 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
 
 	if (chip->bios_dir)
 		tpm_bios_log_teardown(chip->bios_dir);
+}
+
+static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
+{
+	struct attribute **i;
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return;
 
-	tpm_sysfs_del_device(chip);
+	sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
+
+	for (i = chip->groups[0]->attrs; *i != NULL; ++i)
+		sysfs_remove_link(&chip->dev.parent->kobj, (*i)->name);
 }
 
+/* For compatibility with legacy sysfs paths we provide symlinks from the
+ * parent dev directory to selected names within the tpm chip directory. Old
+ * kernel versions created these files directly under the parent.
+ */
+static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
+{
+	struct attribute **i;
+	int rc;
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return 0;
+
+	rc = __compat_only_sysfs_link_entry_to_kobj(
+		    &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
+	if (rc && rc != -ENOENT)
+		return rc;
+
+	/* All the names from tpm-sysfs */
+	for (i = chip->groups[0]->attrs; *i != NULL; ++i) {
+		rc = __compat_only_sysfs_link_entry_to_kobj(
+		    &chip->dev.parent->kobj, &chip->dev.kobj, (*i)->name);
+		if (rc) {
+			tpm_del_legacy_sysfs(chip);
+			return rc;
+		}
+	}
+
+	return 0;
+}
 /*
  * tpm_chip_register() - create a character device for the TPM chip
  * @chip: TPM chip to use.
@@ -322,24 +356,20 @@ int tpm_chip_register(struct tpm_chip *chip)
 	tpm_add_ppi(chip);
 
 	rc = tpm_add_char_device(chip);
-	if (rc)
-		goto out_err;
+	if (rc) {
+		tpm1_chip_unregister(chip);
+		return rc;
+	}
 
 	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
 
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
-		rc = __compat_only_sysfs_link_entry_to_kobj(
-		    &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
-		if (rc && rc != -ENOENT) {
-			tpm_chip_unregister(chip);
-			return rc;
-		}
+	rc = tpm_add_legacy_sysfs(chip);
+	if (rc) {
+		tpm_chip_unregister(chip);
+		return rc;
 	}
 
 	return 0;
-out_err:
-	tpm1_chip_unregister(chip);
-	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_chip_register);
 
@@ -361,8 +391,7 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	if (!(chip->flags & TPM_CHIP_FLAG_REGISTERED))
 		return;
 
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
-		sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
+	tpm_del_legacy_sysfs(chip);
 
 	tpm1_chip_unregister(chip);
 	tpm_del_char_device(chip);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 7cba092e3069..080dade5e80f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -432,12 +432,11 @@ static const struct tpm_input_header tpm_getcap_header = {
 	.ordinal = TPM_ORD_GET_CAP
 };
 
-ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
+ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
 		   const char *desc)
 {
 	struct tpm_cmd_t tpm_cmd;
 	int rc;
-	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	tpm_cmd.header.in = tpm_getcap_header;
 	if (subcap_id == CAP_VERSION_1_1 || subcap_id == CAP_VERSION_1_2) {
@@ -935,7 +934,7 @@ static struct tpm_input_header savestate_header = {
  */
 int tpm_pm_suspend(struct device *dev)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 	struct tpm_cmd_t cmd;
 	int rc, try;
 
@@ -996,7 +995,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_suspend);
  */
 int tpm_pm_resume(struct device *dev)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	if (chip == NULL)
 		return -ENODEV;
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index a7c3473c3421..b46cf70c8b16 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -36,7 +36,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	int i, rc;
 	char *str = buf;
 
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
 	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
@@ -92,9 +92,9 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 	int i, j, num_pcrs;
 	char *str = buf;
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
-	rc = tpm_getcap(dev, TPM_CAP_PROP_PCR, &cap,
+	rc = tpm_getcap(chip, TPM_CAP_PROP_PCR, &cap,
 			"attempting to determine the number of PCRS");
 	if (rc)
 		return 0;
@@ -119,8 +119,8 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
 	cap_t cap;
 	ssize_t rc;
 
-	rc = tpm_getcap(dev, TPM_CAP_FLAG_PERM, &cap,
-			 "attempting to determine the permanent enabled state");
+	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
+			"attempting to determine the permanent enabled state");
 	if (rc)
 		return 0;
 
@@ -135,8 +135,8 @@ static ssize_t active_show(struct device *dev, struct device_attribute *attr,
 	cap_t cap;
 	ssize_t rc;
 
-	rc = tpm_getcap(dev, TPM_CAP_FLAG_PERM, &cap,
-			 "attempting to determine the permanent active state");
+	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
+			"attempting to determine the permanent active state");
 	if (rc)
 		return 0;
 
@@ -151,8 +151,8 @@ static ssize_t owned_show(struct device *dev, struct device_attribute *attr,
 	cap_t cap;
 	ssize_t rc;
 
-	rc = tpm_getcap(dev, TPM_CAP_PROP_OWNER, &cap,
-			 "attempting to determine the owner state");
+	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_PROP_OWNER, &cap,
+			"attempting to determine the owner state");
 	if (rc)
 		return 0;
 
@@ -167,8 +167,8 @@ static ssize_t temp_deactivated_show(struct device *dev,
 	cap_t cap;
 	ssize_t rc;
 
-	rc = tpm_getcap(dev, TPM_CAP_FLAG_VOL, &cap,
-			 "attempting to determine the temporary state");
+	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_VOL, &cap,
+			"attempting to determine the temporary state");
 	if (rc)
 		return 0;
 
@@ -180,11 +180,12 @@ static DEVICE_ATTR_RO(temp_deactivated);
 static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
+	struct tpm_chip *chip = to_tpm_chip(dev);
 	cap_t cap;
 	ssize_t rc;
 	char *str = buf;
 
-	rc = tpm_getcap(dev, TPM_CAP_PROP_MANUFACTURER, &cap,
+	rc = tpm_getcap(chip, TPM_CAP_PROP_MANUFACTURER, &cap,
 			"attempting to determine the manufacturer");
 	if (rc)
 		return 0;
@@ -192,8 +193,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 		       be32_to_cpu(cap.manufacturer_id));
 
 	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
-	rc = tpm_getcap(dev, CAP_VERSION_1_2, &cap,
-			 "attempting to determine the 1.2 version");
+	rc = tpm_getcap(chip, CAP_VERSION_1_2, &cap,
+			"attempting to determine the 1.2 version");
 	if (!rc) {
 		str += sprintf(str,
 			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
@@ -203,7 +204,7 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 			       cap.tpm_version_1_2.revMinor);
 	} else {
 		/* Otherwise just use TPM_STRUCT_VER */
-		rc = tpm_getcap(dev, CAP_VERSION_1_1, &cap,
+		rc = tpm_getcap(chip, CAP_VERSION_1_1, &cap,
 				"attempting to determine the 1.1 version");
 		if (rc)
 			return 0;
@@ -222,7 +223,7 @@ static DEVICE_ATTR_RO(caps);
 static ssize_t cancel_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 	if (chip == NULL)
 		return 0;
 
@@ -234,7 +235,7 @@ static DEVICE_ATTR_WO(cancel);
 static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	if (chip->duration[TPM_LONG] == 0)
 		return 0;
@@ -251,7 +252,7 @@ static DEVICE_ATTR_RO(durations);
 static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	return sprintf(buf, "%d %d %d %d [%s]\n",
 		       jiffies_to_usecs(chip->timeout_a),
@@ -281,24 +282,12 @@ static const struct attribute_group tpm_dev_group = {
 	.attrs = tpm_dev_attrs,
 };
 
-int tpm_sysfs_add_device(struct tpm_chip *chip)
+void tpm_sysfs_add_device(struct tpm_chip *chip)
 {
-	int err;
-	err = sysfs_create_group(&chip->dev.parent->kobj,
-				 &tpm_dev_group);
-
-	if (err)
-		dev_err(&chip->dev,
-			"failed to create sysfs attributes, %d\n", err);
-	return err;
-}
-
-void tpm_sysfs_del_device(struct tpm_chip *chip)
-{
-	/* The sysfs routines rely on an implicit tpm_try_get_ops, this
-	 * function is called before ops is null'd and the sysfs core
-	 * synchronizes this removal so that no callbacks are running or can
-	 * run again
+	/* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
+	 * is called before ops is null'd and the sysfs core synchronizes this
+	 * removal so that no callbacks are running or can run again
 	 */
-	sysfs_remove_group(&chip->dev.parent->kobj, &tpm_dev_group);
+	WARN_ON(chip->groups_cnt != 0);
+	chip->groups[chip->groups_cnt++] = &tpm_dev_group;
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8bc6fb85fb38..508e8e00c9c1 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -168,9 +168,9 @@ struct tpm_chip {
 
 	struct dentry **bios_dir;
 
-#ifdef CONFIG_ACPI
-	const struct attribute_group *groups[2];
+	const struct attribute_group *groups[3];
 	unsigned int groups_cnt;
+#ifdef CONFIG_ACPI
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
 #endif /* CONFIG_ACPI */
@@ -471,7 +471,8 @@ extern dev_t tpm_devt;
 extern const struct file_operations tpm_fops;
 extern struct idr dev_nums_idr;
 
-ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
+ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
+		   const char *desc);
 ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		     size_t bufsiz);
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
@@ -496,8 +497,7 @@ extern struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
 extern int tpm_chip_register(struct tpm_chip *chip);
 extern void tpm_chip_unregister(struct tpm_chip *chip);
 
-int tpm_sysfs_add_device(struct tpm_chip *chip);
-void tpm_sysfs_del_device(struct tpm_chip *chip);
+void tpm_sysfs_add_device(struct tpm_chip *chip);
 
 int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
