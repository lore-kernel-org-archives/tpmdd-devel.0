From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Mon, 11 Apr 2016 18:05:00 -0600
Message-ID: <20160412000500.GC5861@obsidianresearch.com>
References: <1459275554-12915-3-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160407123539.GA17489@intel.com>
	<57068198.6050407@linux.vnet.ibm.com>
	<20160411084358.GB11322@intel.com>
	<20160411181403.GB371@obsidianresearch.com>
	<201604111933.u3BJXErj001305@d03av03.boulder.ibm.com>
	<20160411202811.GA3663@obsidianresearch.com>
	<201604112030.u3BKUeJQ017181@d01av04.pok.ibm.com>
	<20160411205718.GC3663@obsidianresearch.com>
	<201604112213.u3BMD3i5028908@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201604112213.u3BMD3i5028908-nNA/7dmquNI+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Mon, Apr 11, 2016 at 06:12:57PM -0400, Stefan Berger wrote:
>    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 04/11/2016
>    04:57:18 PM:
>    >
>    > On Mon, Apr 11, 2016 at 04:30:34PM -0400, Stefan Berger wrote:
>    >
>    > >    > Doesn't matter, just dev_set_drvdata right after the chip is
>    > >    > allocated, just like vtpm does already for chip->priv.
>    > >    We don't have a dev at this point.
>    >
>    > Eh? If you have a chip you have a dev.

>    Ok. I would nevertheless like to reduce the churn in the series where I
>    would post next a v10.
>    I am using chip->dev.platform_data = proxy_dev to store the proxy_dev.
>    Here's the current v10:
>    https://github.com/stefanberger/linux/commits/vtpm-driver.v10

The *correct* thing for vtpm_proxy.c is to replace this:

+	dev_set_drvdata(&chip->dev, chip);
+	chip->dev.platform_data = proxy_dev;

With:

+	dev_set_drvdata(&chip->dev, proxy_dev);

[and replace all the dev_get_platdata with dev_get_drvdata]

The use of platdata is an ugly hack.

The entire point of the patch I sent earlier was to allow the original
TPM_CHIP_FLAG_VIRTUAL patch (later versions which moved the
dev_set_drvdata out of tpm_sys.c and into vtpm_proxy.c are
nonsensical) to entirely drop the dev_set_drvdata, clearing the way
for vtpm_proxy.c to use the correct approach above.

Here is an update of the idea patch I sent earlier, I realized the
ordering was wrong. This probably almost works actually. If you and
Christophe can finish it up the issue can be settled quickly.

Stick it before the TPM_CHIP_FLAG_VIRTUAL patch and throw away most of
that patch. Just add two flag checks into tpm_add/del_legacy_sysfs()

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 2642cca05cac..657a010c6c02 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -275,14 +275,10 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 
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
 
@@ -296,8 +292,50 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
 
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
+
+	sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
 
-	tpm_sysfs_del_device(chip);
+	for (i = chip->groups[0]->attrs; *i != NULL; ++i)
+		sysfs_remove_link(&chip->dev.parent->kobj, (*i)->name);
+}
+
+/* For compatability with legacy sysfs paths we provide symlinks from the
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
+		&chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
+	if (rc && rc != -ENOENT)
+		goto out_err;
+
+	/* All the names from tpm-sysfs */
+	for (i = chip->groups[0]->attrs; *i != NULL; ++i) {
+		rc = __compat_only_sysfs_link_entry_to_kobj(
+		    &chip->dev.parent->kobj, &chip->dev.kobj, (*i)->name);
+		if (rc)
+			goto out_err;
+	}
+
+	return 0;
+out_err:
+	tpm_del_legacy_sysfs(chip);
+	return rc;
 }
 
 /*
@@ -322,24 +360,20 @@ int tpm_chip_register(struct tpm_chip *chip)
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
 
@@ -361,12 +395,11 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	if (!(chip->flags & TPM_CHIP_FLAG_REGISTERED))
 		return;
 
+	tpm_del_legacy_sysfs(chip);
+
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
 
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
-		sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
-
 	tpm1_chip_unregister(chip);
 	tpm_del_char_device(chip);
 }
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index a7c3473c3421..5f8e419a7c73 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -36,7 +36,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	int i, rc;
 	char *str = buf;
 
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
 	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
@@ -92,7 +92,7 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 	int i, j, num_pcrs;
 	char *str = buf;
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	rc = tpm_getcap(dev, TPM_CAP_PROP_PCR, &cap,
 			"attempting to determine the number of PCRS");
@@ -222,7 +222,7 @@ static DEVICE_ATTR_RO(caps);
 static ssize_t cancel_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 	if (chip == NULL)
 		return 0;
 
@@ -234,7 +234,7 @@ static DEVICE_ATTR_WO(cancel);
 static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	if (chip->duration[TPM_LONG] == 0)
 		return 0;
@@ -251,7 +251,7 @@ static DEVICE_ATTR_RO(durations);
 static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	return sprintf(buf, "%d %d %d %d [%s]\n",
 		       jiffies_to_usecs(chip->timeout_a),
@@ -281,24 +281,12 @@ static const struct attribute_group tpm_dev_group = {
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
index 8bc6fb85fb38..83a231dfe2ed 100644
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
@@ -496,8 +496,7 @@ extern struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
 extern int tpm_chip_register(struct tpm_chip *chip);
 extern void tpm_chip_unregister(struct tpm_chip *chip);
 
-int tpm_sysfs_add_device(struct tpm_chip *chip);
-void tpm_sysfs_del_device(struct tpm_chip *chip);
+void tpm_sysfs_add_device(struct tpm_chip *chip);
 
 int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
