From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH] tpm: use test_bit() to check TPM2 flag in eventlog and sysfs code
Date: Mon, 21 Nov 2016 03:03:51 -0500
Message-ID: <1479715431-11983-1-git-send-email-nayna@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

There is change done to introduce atomic bitops to set and test
chip->flags.
This patch fixes tpm_bios_log_setup() and tpm_sysfs_add_device()
to use test_bit() to check for TPM_CHIP_FLAG_TPM2 flag.

Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm-sysfs.c    | 2 +-
 drivers/char/tpm/tpm_eventlog.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 82298e51..9a37c26 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -284,7 +284,7 @@ static const struct attribute_group tpm_dev_group = {
 
 void tpm_sysfs_add_device(struct tpm_chip *chip)
 {
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
 		return;
 
 	/* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index ebec4ac..dede2ec 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -391,7 +391,7 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 	unsigned int cnt;
 	int rc = 0;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (test_bit(TPM_CHIP_FLAG_TPM2, &chip->flags))
 		return 0;
 
 	rc = tpm_read_log(chip);
-- 
2.5.0

