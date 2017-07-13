From: Josh Zimmerman <joshz@google.com>
Subject: [PATCH v1 2/2] tpm: Issue a TPM2_Shutdown for TPM2 devices.
Date: Wed, 12 Jul 2017 17:41:21 -0700
Message-ID: <20170713004121.21750-3-joshz@google.com>
References: <20170713004121.21750-1-joshz@google.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170713004121.21750-1-joshz@google.com>
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

Signed-off-by: Josh Zimmerman <joshz@google.com>
---
 drivers/char/tpm/tpm-chip.c  | 36 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-sysfs.c |  5 +++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index a017ccd8cc3b..9ff853229957 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -130,6 +130,41 @@ static void tpm_dev_release(struct device *dev)
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
  * tpm_chip_alloc() - allocate a new struct tpm_chip instance
  * @pdev: device to which the chip is associated
@@ -168,6 +203,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	device_initialize(&chip->dev);
 
 	chip->dev.class = tpm_class;
+	chip->dev.class->shutdown = tpm_class_shutdown;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index a76ab4af9fb2..774148db0fac 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -284,6 +284,11 @@ static const struct attribute_group tpm_dev_group = {
 
 void tpm_sysfs_add_device(struct tpm_chip *chip)
 {
+	/* XXX: If you wish to remove this restriction, you must first update
+	 * tpm_sysfs to explicitly lock chip->ops.
+	 */
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return;
 	/* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
 	 * is called before ops is null'd and the sysfs core synchronizes this
 	 * removal so that no callbacks are running or can run again
-- 
2.13.2.932.g7449e964c-goog
