From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RESEND 3/3] tpm: drop
	tpm1_chip_register(/unregister)
Date: Sat,  1 Oct 2016 22:25:26 +0300
Message-ID: <1475349926-476-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1475349926-476-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1475349926-476-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Check for TPM2 chip in tpm_sysfs_add_device, tpm_bios_log_setup and
tpm_bios_log_teardown in order to make code flow cleaner and to enable
to implement TPM 2.0 support later on. This is partially derived from
the commit by Nayna Jain with the extension that also tpm1_chip_register
is dropped.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c     | 31 +++++--------------------------
 drivers/char/tpm/tpm-sysfs.c    |  3 +++
 drivers/char/tpm/tpm_eventlog.c |  6 ++++++
 3 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index a56b609..eac1f10 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -276,28 +276,6 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 	up_write(&chip->ops_sem);
 }
 
-static int tpm1_chip_register(struct tpm_chip *chip)
-{
-	int rc;
-
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return 0;
-
-	tpm_sysfs_add_device(chip);
-
-	rc = tpm_bios_log_setup(chip);
-
-	return rc;
-}
-
-static void tpm1_chip_unregister(struct tpm_chip *chip)
-{
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return;
-
-	tpm_bios_log_teardown(chip);
-}
-
 static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
 {
 	struct attribute **i;
@@ -364,7 +342,9 @@ int tpm_chip_register(struct tpm_chip *chip)
 			return rc;
 	}
 
-	rc = tpm1_chip_register(chip);
+	tpm_sysfs_add_device(chip);
+
+	rc = tpm_bios_log_setup(chip);
 	if (rc)
 		return rc;
 
@@ -372,7 +352,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 
 	rc = tpm_add_char_device(chip);
 	if (rc) {
-		tpm1_chip_unregister(chip);
+		tpm_bios_log_teardown(chip);
 		return rc;
 	}
 
@@ -407,8 +387,7 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 		return;
 
 	tpm_del_legacy_sysfs(chip);
-
-	tpm1_chip_unregister(chip);
+	tpm_bios_log_teardown(chip);
 	tpm_del_char_device(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_unregister);
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index a76ab4a..1eca5ec 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -284,6 +284,9 @@ static const struct attribute_group tpm_dev_group = {
 
 void tpm_sysfs_add_device(struct tpm_chip *chip)
 {
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return;
+
 	/* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
 	 * is called before ops is null'd and the sysfs core synchronizes this
 	 * removal so that no callbacks are running or can run again
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index f5e1d06..c57b981 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -373,6 +373,9 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 	const char *name = dev_name(&chip->dev);
 	unsigned int cnt;
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return 0;
+
 	cnt = 0;
 	chip->bios_dir[cnt] =
 		securityfs_create_dir(name, NULL);
@@ -410,6 +413,9 @@ void tpm_bios_log_teardown(struct tpm_chip *chip)
 {
 	int i;
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return;
+
 	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
 		if (chip->bios_dir[i])
 			securityfs_remove(chip->bios_dir[i]);
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
