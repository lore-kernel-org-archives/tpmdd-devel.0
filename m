From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH] tpm: Fix reference count to main device
Date: Mon, 17 Apr 2017 21:58:26 -0400
Message-ID: <1492480706-6928-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: jgunthorpe@obsidianresearch.com, jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The main device is currently not properly released due to one additional
reference to the 'devs' device which is only released in case of a TPM 2.
So, also get the additional reference only in case of a TPM2.

Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm-chip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index a321bd5..9dec9f5 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -191,9 +191,10 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	/* get extra reference on main device to hold on
 	 * behalf of devs.  This holds the chip structure
 	 * while cdevs is in use.  The corresponding put
-	 * is in the tpm_devs_release
+	 * is in the tpm_devs_release (TPM2 only)
 	 */
-	get_device(&chip->dev);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		get_device(&chip->dev);
 
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
-- 
2.4.3

