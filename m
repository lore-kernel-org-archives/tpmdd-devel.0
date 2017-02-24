From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: Use the right clean up after cdev_add completes
Date: Fri, 24 Feb 2017 14:16:07 -0700
Message-ID: <20170224211607.GB28016@obsidianresearch.com>
References: <20170223211914.GA12752@obsidianresearch.com>
 <20170224174354.w5e2v3nxntod72je@intel.com>
 <20170224205949.u63xb5qhqzd7lqtp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170224205949.u63xb5qhqzd7lqtp@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 24, 2017 at 10:59:50PM +0200, Jarkko Sakkinen wrote:
> On Fri, Feb 24, 2017 at 07:43:54PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Feb 23, 2017 at 02:19:14PM -0700, Jason Gunthorpe wrote:
> > > Once cdev_add is done the device node is visible to user space and
> > > could have been opened. Thus we have to go through the locking
> > > process in tpm_del_char_device if device_add fails.
> > > 
> > > Fixes: 2c91ce8523a ("tpm: fix the rollback in tpm_chip_register()")
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > 
> > Pushed.
> 
> It would make easier to merge this with resource manager commits if
> there was instead
> 
> void tpm_chip_shutdown(struct tpm_chip *chip)
> {
> 	/* Make the driver uncallable. */
> 	down_write(&chip->ops_sem);
> 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
> 	chip->ops = NULL;
> 	up_write(&chip->ops_sem);
> }
> 
> And you would call this instead of wiring into tpm_del_char_device.

Hum.. I think this direction in the RM patch would be more
maintainable.. Otherwise tpm_add_char_device has very complicated
error handling.

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index c82acf0a6e7353..444cf2495ef0e0 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -353,18 +353,26 @@ int tpm_chip_register(struct tpm_chip *chip)
 	tpm_add_ppi(chip);
 
 	rc = tpm_add_char_device(chip);
-	if (rc) {
-		tpm_bios_log_teardown(chip);
-		return rc;
-	}
+	if (rc)
+		goto err_add_char;
+
+	rc = tpm_add_rm_char_device(chip);
+	if (rc)
+		goto err_add_rm_char;
 
 	rc = tpm_add_legacy_sysfs(chip);
-	if (rc) {
-		tpm_chip_unregister(chip);
-		return rc;
-	}
+	if (rc)
+		goto err_add_legacy_sysfs;
 
 	return 0;
+
+err_add_legacy_sysfs:
+	tpm_del_rm_char_device(chip);
+err_add_rm_char:
+	tpm_del_char_device(chip, true);
+err_add_char:
+	tpm_bios_log_teardown(chip);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_chip_register);
 
@@ -384,6 +392,7 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
 void tpm_chip_unregister(struct tpm_chip *chip)
 {
 	tpm_del_legacy_sysfs(chip);
+	tpm_del_rm_char_device(chip);
 	tpm_bios_log_teardown(chip);
 	tpm_del_char_device(chip, true);
 }
