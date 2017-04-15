From: Unknown <unknown@unknown.invalid>
Subject: [backport v4.9] tpm_tis: use default timeout value if chip reports it as zero
Date: Sat, 15 Apr 2017 18:26:22 +0300
Message-ID: <20170415152622.14451-1-user@jsakkine-mobl1>
Return-path: <linux-security-module-owner@vger.kernel.org>
From: Jarkko Sakkinen <jsakkine@jsakkine-mobl1>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, stable@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>

Since commit 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for
TPM access") Atmel 3203 TPM on ThinkPad X61S (TPM firmware version 13.9)
no longer works.  The initialization proceeds fine until we get and
start using chip-reported timeouts - and the chip reports C and D
timeouts of zero.

It turns out that until commit 8e54caf407b98e ("tpm: Provide a generic
means to override the chip returned timeouts") we had actually let
default timeout values remain in this case, so let's bring back this
behavior to make chips like Atmel 3203 work again.

Use a common code that was introduced by that commit so a warning is
printed in this case and /sys/class/tpm/tpm*/timeouts correctly says the
timeouts aren't chip-original.

Fixes: 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM access")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
Backport v4.9. Can you test it?
 drivers/char/tpm/tpm-interface.c | 59 ++++++++++++++++++++++------------------
 drivers/char/tpm/tpm_tis.c       |  2 +-
 drivers/char/tpm/tpm_tis_core.c  |  6 ++--
 drivers/char/tpm/tpm_tis_core.h  |  2 +-
 4 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 3a9149cf0110..4c914fe25802 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -489,9 +489,9 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
 	struct tpm_cmd_t tpm_cmd;
-	unsigned long new_timeout[4];
-	unsigned long old_timeout[4];
 	struct duration_t *duration_cap;
+	cap_t cap;
+	unsigned long timeout_old[4], timeout_chip[4], timeout_eff[4];
 	ssize_t rc;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
@@ -537,16 +537,15 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		goto duration;
 	}
 
-	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
-	    be32_to_cpu(tpm_cmd.header.out.length)
-	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
-		return -EINVAL;
-
-	old_timeout[0] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.a);
-	old_timeout[1] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.b);
-	old_timeout[2] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.c);
-	old_timeout[3] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.d);
-	memcpy(new_timeout, old_timeout, sizeof(new_timeout));
+	timeout_old[0] = jiffies_to_usecs(chip->timeout_a);
+	timeout_old[1] = jiffies_to_usecs(chip->timeout_b);
+	timeout_old[2] = jiffies_to_usecs(chip->timeout_c);
+	timeout_old[3] = jiffies_to_usecs(chip->timeout_d);
+	timeout_chip[0] = be32_to_cpu(cap.timeout.a);
+	timeout_chip[1] = be32_to_cpu(cap.timeout.b);
+	timeout_chip[2] = be32_to_cpu(cap.timeout.c);
+	timeout_chip[3] = be32_to_cpu(cap.timeout.d);
+	memcpy(timeout_eff, timeout_chip, sizeof(timeout_eff));
 
 	/*
 	 * Provide ability for vendor overrides of timeout values in case
@@ -554,16 +553,24 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	 */
 	if (chip->ops->update_timeouts != NULL)
 		chip->timeout_adjusted =
-			chip->ops->update_timeouts(chip, new_timeout);
+			chip->ops->update_timeouts(chip, timeout_eff);
 
 	if (!chip->timeout_adjusted) {
-		/* Don't overwrite default if value is 0 */
-		if (new_timeout[0] != 0 && new_timeout[0] < 1000) {
-			int i;
+		/* Restore default if chip reported 0 */
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(timeout_eff); i++) {
+			if (timeout_eff[i])
+				continue;
+
+			timeout_eff[i] = timeout_old[i];
+			chip->timeout_adjusted = true;
+		}
 
+		if (timeout_eff[0] != 0 && timeout_eff[0] < 1000) {
 			/* timeouts in msec rather usec */
-			for (i = 0; i != ARRAY_SIZE(new_timeout); i++)
-				new_timeout[i] *= 1000;
+			for (i = 0; i != ARRAY_SIZE(timeout_eff); i++)
+				timeout_eff[i] *= 1000;
 			chip->timeout_adjusted = true;
 		}
 	}
@@ -572,16 +579,16 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	if (chip->timeout_adjusted) {
 		dev_info(&chip->dev,
 			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->%luus D %lu->%luus\n",
-			 old_timeout[0], new_timeout[0],
-			 old_timeout[1], new_timeout[1],
-			 old_timeout[2], new_timeout[2],
-			 old_timeout[3], new_timeout[3]);
+			 timeout_chip[0], timeout_eff[0],
+			 timeout_chip[1], timeout_eff[1],
+			 timeout_chip[2], timeout_eff[2],
+			 timeout_chip[3], timeout_eff[3]);
 	}
 
-	chip->timeout_a = usecs_to_jiffies(new_timeout[0]);
-	chip->timeout_b = usecs_to_jiffies(new_timeout[1]);
-	chip->timeout_c = usecs_to_jiffies(new_timeout[2]);
-	chip->timeout_d = usecs_to_jiffies(new_timeout[3]);
+	chip->timeout_a = usecs_to_jiffies(timeout_eff[0]);
+	chip->timeout_b = usecs_to_jiffies(timeout_eff[1]);
+	chip->timeout_c = usecs_to_jiffies(timeout_eff[2]);
+	chip->timeout_d = usecs_to_jiffies(timeout_eff[3]);
 
 duration:
 	tpm_cmd.header.in = tpm_getcap_header;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index eaf5730d79eb..a5abcdc9655b 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -157,7 +157,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 		irq = tpm_info->irq;
 
 	if (itpm)
-		phy->priv.flags |= TPM_TIS_ITPM_POSSIBLE;
+		phy->priv.flags |= TPM_TIS_ITPM_WORKAROUND;
 
 	return tpm_tis_core_init(dev, &phy->priv, irq, &tpm_tcg,
 				 acpi_dev_handle);
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index e3bf31b37138..44e0ef479962 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -254,7 +254,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	int rc, status, burstcnt;
 	size_t count = 0;
-	bool itpm = priv->flags & TPM_TIS_ITPM_POSSIBLE;
+	bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
 
 	if (request_locality(chip, 0) < 0)
 		return -EBUSY;
@@ -718,7 +718,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
 		 vendor >> 16, rid);
 
-	if (!(priv->flags & TPM_TIS_ITPM_POSSIBLE)) {
+	if (!(priv->flags & TPM_TIS_ITPM_WORKAROUND)) {
 		probe = probe_itpm(chip);
 		if (probe < 0) {
 			rc = -ENODEV;
@@ -726,7 +726,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		}
 
 		if (!!probe)
-			priv->flags |= TPM_TIS_ITPM_POSSIBLE;
+			priv->flags |= TPM_TIS_ITPM_WORKAROUND;
 	}
 
 	/* Figure out the capabilities */
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 9191aabbf9c2..e2212f021a02 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -80,7 +80,7 @@ enum tis_defaults {
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
 
 enum tpm_tis_flags {
-	TPM_TIS_ITPM_POSSIBLE		= BIT(0),
+	TPM_TIS_ITPM_WORKAROUND		= BIT(0),
 };
 
 struct tpm_tis_data {
-- 
2.11.0

