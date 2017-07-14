From: Josh Zimmerman <joshz@google.com>
Subject: [PATCH v1 4/4] tpm: Issue a TPM2_Shutdown for TPM2 devices.
Date: Fri, 14 Jul 2017 12:58:03 -0700
Message-ID: <20170714195803.7035-5-joshz@google.com>
References: <20170714195803.7035-1-joshz@google.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170714195803.7035-1-joshz@google.com>
Sender: stable-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: Josh Zimmerman <joshz@google.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Backport of d1bd4a792d3961a04e6154118816b00167aad91a upstream.

If a TPM2 loses power without a TPM2_Shutdown command being issued (a
"disorderly reboot"), it may lose some state that has yet to be
persisted to NVRam, and will increment the DA counter. After the DA
counter gets sufficiently large, the TPM will lock the user out.

NOTE: This only changes behavior on TPM2 devices. Since TPM1 uses sysfs,
and sysfs relies on implicit locking on chip->ops, it is not safe to
allow this code to run in TPM1, or to add sysfs support to TPM2, until
that locking is made explicit.
---
 drivers/char/tpm/tpm-chip.c  | 36 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-sysfs.c |  7 +++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index f3a887e4f692..6d56877b2e0a 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -124,6 +124,41 @@ static void tpm_dev_release(struct device *dev)
 	kfree(chip);
 }
 
+
+/**
+ * tpm_class_shutdown() - prepare the TPM device for loss of power.
+ * @dev: device to which the chip is associated.
+ *
+ * Issues a TPM2_Shutdown command prior to loss of power, as required by the
+ * TPM 2.0 spec.
+ * Then, calls bus- and device- specific shutdown code.
+ *
+ * XXX: This codepath relies on the fact that sysfs is not enabled for
+ * TPM2: sysfs uses an implicit lock on chip->ops, so this could race if TPM2
+ * has sysfs support enabled before TPM sysfs's implicit locking is fixed.
+ */
+static int tpm_class_shutdown(struct device *dev)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		down_write(&chip->ops_sem);
+		tpm2_shutdown(chip, TPM2_SU_CLEAR);
+		chip->ops = NULL;
+		up_write(&chip->ops_sem);
+	}
+	/* Allow bus- and device-specific code to run. Note: since chip->ops
+	 * is NULL, more-specific shutdown code will not be able to issue TPM
+	 * commands.
+	 */
+	if (dev->bus && dev->bus->shutdown)
+		dev->bus->shutdown(dev);
+	else if (dev->driver && dev->driver->shutdown)
+		dev->driver->shutdown(dev);
+	return 0;
+}
+
+
 /**
  * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
  * @dev: device to which the chip is associated
@@ -166,6 +201,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	dev_set_drvdata(dev, chip);
 
 	chip->dev.class = tpm_class;
+	chip->dev.class->shutdown = tpm_class_shutdown;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = dev;
 #ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 8af4145d10c7..6a4056a3f7ee 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -284,6 +284,13 @@ static const struct attribute_group tpm_dev_group = {
 int tpm_sysfs_add_device(struct tpm_chip *chip)
 {
 	int err;
+
+	/* XXX: If you wish to remove this restriction, you must first update
+	 * tpm_sysfs to explicitly lock chip->ops.
+	 */
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return 0;
+
 	err = sysfs_create_group(&chip->dev.parent->kobj,
 				 &tpm_dev_group);
 
-- 
2.13.2.932.g7449e964c-goog
