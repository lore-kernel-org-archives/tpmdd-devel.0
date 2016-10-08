From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] tmp: use pdev for parent device in
	tpm_chip_alloc
Date: Sun,  9 Oct 2016 00:36:41 +0300
Message-ID: <1475962601-27741-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The tpm stack uses pdev name convention for the parent device.
Fix that also in tpm_chip_alloc().

Fixes: 3897cd9c8d1d ("tpm: Split out the devm stuff from tpmm_chip_alloc")'
Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index e5950131bd90..a017ccd8cc3b 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -140,7 +140,7 @@ static void tpm_dev_release(struct device *dev)
  * Allocates a new struct tpm_chip instance and assigns a free
  * device number for it. Must be paired with put_device(&chip->dev).
  */
-struct tpm_chip *tpm_chip_alloc(struct device *dev,
+struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 				const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
@@ -159,7 +159,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	rc = idr_alloc(&dev_nums_idr, NULL, 0, TPM_NUM_DEVICES, GFP_KERNEL);
 	mutex_unlock(&idr_lock);
 	if (rc < 0) {
-		dev_err(dev, "No available tpm device numbers\n");
+		dev_err(pdev, "No available tpm device numbers\n");
 		kfree(chip);
 		return ERR_PTR(rc);
 	}
@@ -169,7 +169,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 
 	chip->dev.class = tpm_class;
 	chip->dev.release = tpm_dev_release;
-	chip->dev.parent = dev;
+	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
 
 	if (chip->dev_num == 0)
@@ -181,7 +181,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	if (rc)
 		goto out;
 
-	if (!dev)
+	if (!pdev)
 		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
 
 	cdev_init(&chip->cdev, &tpm_fops);
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
