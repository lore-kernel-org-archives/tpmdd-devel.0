From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 2/2] tpm: self test failure should not cause suspend to fail
Date: Wed, 30 May 2018 23:44:40 +0300
Message-ID: <20180530204440.27299-3-jarkko.sakkinen@linux.intel.com>
References: <20180530204440.27299-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530204440.27299-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Chris Chiu <chiu@endlessm.com>, Daniel Drake <drake@endlessm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Chris Chiu <chiu@endlessm.com>

commit 0803d7befa15cab5717d667a97a66214d2a4c083 upstream

The Acer Acer Veriton X4110G has a TPM device detected as:
  tpm_tis 00:0b: 1.2 TPM (device-id 0xFE, rev-id 71)

After the first S3 suspend, the following error appears during resume:
  tpm tpm0: A TPM error(38) occurred continue selftest

Any following S3 suspend attempts will now fail with this error:
  tpm tpm0: Error (38) sending savestate before suspend
  PM: Device 00:0b failed to suspend: error 38

Error 38 is TPM_ERR_INVALID_POSTINIT which means the TPM is
not in the correct state. This indicates that the platform BIOS
is not sending the usual TPM_Startup command during S3 resume.
>From this point onwards, all TPM commands will fail.

The same issue was previously reported on Foxconn 6150BK8MC and
Sony Vaio TX3.

The platform behaviour seems broken here, but we should not break
suspend/resume because of this.

When the unexpected TPM state is encountered, set a flag to skip the
affected TPM_SaveState command on later suspends.

Cc: stable@vger.kernel.org
Signed-off-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Daniel Drake <drake@endlessm.com>
Link: http://lkml.kernel.org/r/CAB4CAwfSCvj1cudi+MWaB5g2Z67d9DwY1o475YOZD64ma23UiQ@mail.gmail.com
Link: https://lkml.org/lkml/2011/3/28/192
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=591031
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 247dd2b6504a..be0547115d34 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -787,6 +787,10 @@ int tpm_do_selftest(struct tpm_chip *chip)
 	loops = jiffies_to_msecs(duration) / delay_msec;
 
 	rc = tpm_continue_selftest(chip);
+	if (rc == TPM_ERR_INVALID_POSTINIT) {
+		chip->flags |= TPM_CHIP_FLAG_ALWAYS_POWERED;
+		dev_info(&chip->dev, "TPM not ready (%d)\n", rc);
+	}
 	/* This may fail if there was no TPM driver during a suspend/resume
 	 * cycle; some may return 10 (BAD_ORDINAL), others 28 (FAILEDSELFTEST)
 	 */
-- 
2.17.0
