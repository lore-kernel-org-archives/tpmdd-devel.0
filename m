From: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] tpm-chip: Export TPM device to user space
 even when startup failed
Date: Tue, 4 Jul 2017 15:56:48 +0200
Message-ID: <20170704135648.7360-3-Alexander.Steffen@infineon.com>
References: <20170704135648.7360-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170704135648.7360-1-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

When one of the commands during the auto_startup sequences does not return
TPM_RC_SUCCESS, tpm_chip_register misleadingly returns ENODEV, even though
a TPM device is definitely present.

An error response during those sequences is indeed unexpected, so to
prevent subsequent errors, the kernel should not make use of the TPM
device. But user space applications still might be able to communicate with
the TPM, so they can be used to further diagnose and/or fix the problem. To
allow this, with this patch the device is still exported to user space,
even if a TPM error code has been received, but the kernel itself will not
be allowed to use the device for anything.

This is not a hypothetical scenario, but there are devices in the wild that
show this behavior. With this fix, those devices can be recovered from
their failed state.

Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index f20fcb7..a4baa56 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -390,7 +390,7 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
  *
  * Creates a character device for the TPM chip and adds sysfs attributes for
  * the device. As the last step this function adds the chip to the list of TPM
- * chips available for in-kernel use.
+ * chips available for in-kernel use, if the TPM startup was successful.
  *
  * This function should be only called after the chip initialization is
  * complete.
@@ -398,6 +398,7 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 int tpm_chip_register(struct tpm_chip *chip)
 {
 	int rc;
+	bool startup_successful = true;
 
 	if (chip->ops->flags & TPM_OPS_AUTO_STARTUP) {
 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
@@ -407,7 +408,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 		if (rc < 0)
 			return rc;
 		else if (rc > 0)
-			return -ENODEV;
+			startup_successful = false;
 	}
 
 	tpm_sysfs_add_device(chip);
@@ -430,10 +431,12 @@ int tpm_chip_register(struct tpm_chip *chip)
 		return rc;
 	}
 
-	/* Make the chip available. */
-	mutex_lock(&idr_lock);
-	idr_replace(&dev_nums_idr, chip, chip->dev_num);
-	mutex_unlock(&idr_lock);
+	if (startup_successful) {
+		/* Make the chip available. */
+		mutex_lock(&idr_lock);
+		idr_replace(&dev_nums_idr, chip, chip->dev_num);
+		mutex_unlock(&idr_lock);
+	}
 
 	return 0;
 }
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
