From: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND 1/3] tpm-chip: Move idr_replace calls
 to appropriate places
Date: Thu, 24 Aug 2017 10:37:12 +0200
Message-ID: <20170824083714.10016-2-Alexander.Steffen@infineon.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170824083714.10016-1-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

According to the comments, adding/removing the chip from the list should be
the first/last action in (un)register. But currently it is done in a
subfunction in the middle of the process. Moving the code from the
subfunctions to the appropriate places within (un)register ensures that the
code matches the comments.

Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 67ec9d3..a353b7a 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -327,11 +327,6 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 		}
 	}
 
-	/* Make the chip available. */
-	mutex_lock(&idr_lock);
-	idr_replace(&dev_nums_idr, chip, chip->dev_num);
-	mutex_unlock(&idr_lock);
-
 	return rc;
 }
 
@@ -339,11 +334,6 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 {
 	cdev_device_del(&chip->cdev, &chip->dev);
 
-	/* Make the chip unavailable. */
-	mutex_lock(&idr_lock);
-	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
-	mutex_unlock(&idr_lock);
-
 	/* Make the driver uncallable. */
 	down_write(&chip->ops_sem);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
@@ -438,6 +428,11 @@ int tpm_chip_register(struct tpm_chip *chip)
 		return rc;
 	}
 
+	/* Make the chip available. */
+	mutex_lock(&idr_lock);
+	idr_replace(&dev_nums_idr, chip, chip->dev_num);
+	mutex_unlock(&idr_lock);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_chip_register);
@@ -457,6 +452,11 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
  */
 void tpm_chip_unregister(struct tpm_chip *chip)
 {
+	/* Make the chip unavailable. */
+	mutex_lock(&idr_lock);
+	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
+	mutex_unlock(&idr_lock);
+
 	tpm_del_legacy_sysfs(chip);
 	tpm_bios_log_teardown(chip);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
