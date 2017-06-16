From: Josh Zimmerman via tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v6 1/2] tpm: Issue a TPM2_Shutdown for TPM2
 devices.
Date: Fri, 16 Jun 2017 10:25:30 -0700
Message-ID: <20170616172531.28464-1-joshz@google.com>
Reply-To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

If a TPM2 loses power without a TPM2_Shutdown command being issued (a
"disorderly reboot"), it may lose some state that has yet to be
persisted to NVRam, and will increment the DA counter. After the DA
counter gets sufficiently large, the TPM will lock the user out.

NOTE: This only changes behavior on TPM2 devices. Since TPM1 uses sysfs,
and sysfs relies on implicit locking on chip->ops, it is not safe to
allow this code to run in TPM1, or to add sysfs support to TPM2, until
that locking is made explicit.

Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

----
v2:
  - Properly split changes between this and another commit
  - Use proper locking primitive.
  - Fix commenting style
v3:
  - Re-fix commenting style
v4:
  - Update description and tags (Reviewed-by, Cc).
v5:
  - Update documentation.
v6:
  - Call device and/or bus shutdown from tpm_shutdown.
---
 drivers/char/tpm/tpm-chip.c  | 31 +++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-sysfs.c |  3 +++
 2 files changed, 34 insertions(+)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 9dec9f551b83..62691d266f22 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -142,6 +142,36 @@ static void tpm_devs_release(struct device *dev)
 	put_device(&chip->dev);
 }
 
+/**
+ * tpm_shutdown() - prepare the TPM device for loss of power.
+ * @dev: device to which the chip is associated.
+ *
+ * Issues a TPM2_Shutdown command prior to loss of power, as required by the
+ * TPM 2.0 spec.
+ *
+ * XXX: This codepath relies on the fact that sysfs is not enabled for
+ * TPM2: sysfs uses an implicit lock on chip->ops, so this could race if TPM2
+ * has sysfs support enabled before TPM sysfs's implicit locking is fixed.
+ */
+static void tpm_shutdown(struct device *dev)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		down_write(&chip->ops_sem);
+		tpm2_shutdown(chip, TPM_SU_CLEAR);
+		chip->ops = NULL;
+		up_write(&chip->ops_sem);
+	}
+	// Allow bus- and device-specific code to run. Note: since chip->ops
+	// is NULL, more-specific shutdown code will not be able to issue TPM
+	// commands.
+	if (dev->bus->shutdown)
+		dev->bus->shutdown(dev);
+	else if (dev->driver && dev->driver->shutdown)
+		dev->driver->shutdown(dev);
+}
+
 /**
  * tpm_chip_alloc() - allocate a new struct tpm_chip instance
  * @pdev: device to which the chip is associated
@@ -181,6 +211,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	device_initialize(&chip->devs);
 
 	chip->dev.class = tpm_class;
+	chip->dev.class.shutdown = tpm_shutdown;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 55405dbe43fa..59bd0b7b5959 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -294,6 +294,9 @@ static const struct attribute_group tpm_dev_group = {
 
 void tpm_sysfs_add_device(struct tpm_chip *chip)
 {
+	/* XXX: If you wish to remove this restriction, you must first update
+	 * tpm_sysfs to explicitly lock chip->ops.
+	 */
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return;
 
-- 
2.13.1.518.g3df882009-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
