From: Ed Swierk <eswierk@skyportsystems.com>
Subject: [PATCH v9 4/5] tpm: Allow TPM chip drivers to override reported command durations
Date: Wed, 13 Jul 2016 09:19:35 -0700
Message-ID: <1468426776-42762-5-git-send-email-eswierk@skyportsystems.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
 <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, stefanb@us.ibm.com, eswierk@skyportsystems.com
List-Id: tpmdd-devel@lists.sourceforge.net

Some TPM chips report bogus command durations in their capabilities,
just as others report incorrect timeouts. Rework tpm_get_timeouts() to
allow chip drivers to override either via a single callback. Also
clean up handling of TPMs that report milliseconds instead of
microseconds.

Signed-off-by: Ed Swierk <eswierk@skyportsystems.com>
---
 drivers/char/tpm/tpm-interface.c | 148 ++++++++++++++++++++++-----------------
 drivers/char/tpm/tpm_tis_core.c  |  32 +++------
 include/linux/tpm.h              |   3 +-
 3 files changed, 94 insertions(+), 89 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index dc492ee..9dafc25 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -513,10 +513,10 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
-	cap_t cap;
-	unsigned long new_timeout[4];
-	unsigned long old_timeout[4];
-	ssize_t rc;
+	cap_t cap1, cap2;
+	int rc;
+	unsigned long orig_timeout_a, orig_timeout_b, orig_timeout_c,
+		orig_timeout_d, orig_duration[3];
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		/* Fixed timeouts for TPM2 */
@@ -533,7 +533,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		return 0;
 	}
 
-	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
+	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap1,
 			"attempting to determine the timeouts");
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
@@ -542,77 +542,95 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		if (tpm_startup(chip, TPM_ST_CLEAR))
 			return rc;
 
-		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
+		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap1,
 				"attempting to determine the timeouts");
 	}
 	if (rc)
 		return rc;
 
-	old_timeout[0] = be32_to_cpu(cap.timeout.a);
-	old_timeout[1] = be32_to_cpu(cap.timeout.b);
-	old_timeout[2] = be32_to_cpu(cap.timeout.c);
-	old_timeout[3] = be32_to_cpu(cap.timeout.d);
-	memcpy(new_timeout, old_timeout, sizeof(new_timeout));
-
-	/*
-	 * Provide ability for vendor overrides of timeout values in case
-	 * of misreporting.
-	 */
-	if (chip->ops->update_timeouts != NULL)
-		chip->timeout_adjusted =
-			chip->ops->update_timeouts(chip, new_timeout);
-
-	if (!chip->timeout_adjusted) {
-		/* Don't overwrite default if value is 0 */
-		if (new_timeout[0] != 0 && new_timeout[0] < 1000) {
-			int i;
-
-			/* timeouts in msec rather usec */
-			for (i = 0; i != ARRAY_SIZE(new_timeout); i++)
-				new_timeout[i] *= 1000;
-			chip->timeout_adjusted = true;
-		}
-	}
-
-	/* Report adjusted timeouts */
-	if (chip->timeout_adjusted) {
-		dev_info(&chip->dev,
-			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->%luus D %lu->%luus\n",
-			 old_timeout[0], new_timeout[0],
-			 old_timeout[1], new_timeout[1],
-			 old_timeout[2], new_timeout[2],
-			 old_timeout[3], new_timeout[3]);
-	}
-
-	chip->timeout_a = usecs_to_jiffies(new_timeout[0]);
-	chip->timeout_b = usecs_to_jiffies(new_timeout[1]);
-	chip->timeout_c = usecs_to_jiffies(new_timeout[2]);
-	chip->timeout_d = usecs_to_jiffies(new_timeout[3]);
-
-	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_DURATION, &cap,
+	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_DURATION, &cap2,
 			"attempting to determine the durations");
 	if (rc)
 		return rc;
 
-	chip->duration[TPM_SHORT] =
-		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_short));
-	chip->duration[TPM_MEDIUM] =
-		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_medium));
-	chip->duration[TPM_LONG] =
-		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_long));
+	be32_to_cpus(&cap1.timeout.a);
+	be32_to_cpus(&cap1.timeout.b);
+	be32_to_cpus(&cap1.timeout.c);
+	be32_to_cpus(&cap1.timeout.d);
+	chip->timeout_a = usecs_to_jiffies(cap1.timeout.a);
+	chip->timeout_b = usecs_to_jiffies(cap1.timeout.b);
+	chip->timeout_c = usecs_to_jiffies(cap1.timeout.c);
+	chip->timeout_d = usecs_to_jiffies(cap1.timeout.d);
 
-	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
-	 * value wrong and apparently reports msecs rather than usecs. So we
-	 * fix up the resulting too-small TPM_SHORT value to make things work.
-	 * We also scale the TPM_MEDIUM and -_LONG values by 1000.
-	 */
-	if (chip->duration[TPM_SHORT] < (HZ / 100)) {
-		chip->duration[TPM_SHORT] = HZ;
-		chip->duration[TPM_MEDIUM] *= 1000;
-		chip->duration[TPM_LONG] *= 1000;
-		chip->duration_adjusted = true;
-		dev_info(&chip->dev, "Adjusting TPM timeout parameters.");
+	/* Some TPMs report timeouts in milliseconds rather than
+	   microseconds. Use a value between 1 and 1000 as an
+	   indication that this is the case. */
+	if (cap1.timeout.a > 0 && cap1.timeout.a < 1000) {
+		chip->timeout_a = msecs_to_jiffies(cap1.timeout.a);
+		chip->timeout_b = msecs_to_jiffies(cap1.timeout.b);
+		chip->timeout_c = msecs_to_jiffies(cap1.timeout.c);
+		chip->timeout_d = msecs_to_jiffies(cap1.timeout.d);
+		chip->timeout_adjusted = true;
 	}
+
+	be32_to_cpus(&cap2.duration.tpm_short);
+	be32_to_cpus(&cap2.duration.tpm_medium);
+	be32_to_cpus(&cap2.duration.tpm_long);
+	chip->duration[TPM_SHORT] =
+		usecs_to_jiffies(cap2.duration.tpm_short);
+	chip->duration[TPM_MEDIUM] =
+		usecs_to_jiffies(cap2.duration.tpm_medium);
+	chip->duration[TPM_LONG] =
+		usecs_to_jiffies(cap2.duration.tpm_long);
+
+	orig_timeout_a = chip->timeout_a;
+	orig_timeout_b = chip->timeout_b;
+	orig_timeout_c = chip->timeout_c;
+	orig_timeout_d = chip->timeout_d;
+	memcpy(orig_duration, chip->duration, 3 * sizeof(unsigned long));
+
+	/* Interpret duration values between 1 and 10000 as
+	   milliseconds to deal with TPMs like the Broadcom BCM0102 in
+	   the Dell Latitude D820. */
+	if (cap2.duration.tpm_short > 0 && cap2.duration.tpm_short < 10000) {
+		chip->duration[TPM_SHORT] =
+			msecs_to_jiffies(cap2.duration.tpm_short);
+		chip->duration[TPM_MEDIUM] =
+			msecs_to_jiffies(cap2.duration.tpm_medium);
+		chip->duration[TPM_LONG] =
+			msecs_to_jiffies(cap2.duration.tpm_long);
+		chip->duration_adjusted = true;
+	}
+
+	if (chip->ops->update_timeouts != NULL)
+		chip->ops->update_timeouts(chip);
+
+	if (chip->timeout_adjusted) {
+		dev_info(&chip->dev,
+			 HW_ERR "Adjusted timeouts: A %u->%uus B %u->%uus"
+			 " C %u->%uus D %u->%uus\n",
+			 jiffies_to_usecs(orig_timeout_a),
+			 jiffies_to_usecs(chip->timeout_a),
+			 jiffies_to_usecs(orig_timeout_b),
+			 jiffies_to_usecs(chip->timeout_b),
+			 jiffies_to_usecs(orig_timeout_c),
+			 jiffies_to_usecs(chip->timeout_c),
+			 jiffies_to_usecs(orig_timeout_d),
+			 jiffies_to_usecs(chip->timeout_d));
+	}
+
+	if (chip->duration_adjusted) {
+		dev_info(&chip->dev,
+			 HW_ERR "Adjusted durations: short %u->%uus"
+			 " medium %u->%uus long %u->%uus\n",
+			 jiffies_to_usecs(orig_duration[TPM_SHORT]),
+			 jiffies_to_usecs(chip->duration[TPM_SHORT]),
+			 jiffies_to_usecs(orig_duration[TPM_MEDIUM]),
+			 jiffies_to_usecs(chip->duration[TPM_MEDIUM]),
+			 jiffies_to_usecs(orig_duration[TPM_LONG]),
+			 jiffies_to_usecs(chip->duration[TPM_LONG]));
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_get_timeouts);
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index e62fdeb..f013664 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -398,37 +398,25 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	return rc;
 }
 
-struct tis_vendor_timeout_override {
-	u32 did_vid;
-	unsigned long timeout_us[4];
-};
-
-static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
-	/* Atmel 3204 */
-	{ 0x32041114, { (TIS_SHORT_TIMEOUT*1000), (TIS_LONG_TIMEOUT*1000),
-			(TIS_SHORT_TIMEOUT*1000), (TIS_SHORT_TIMEOUT*1000) } },
-};
-
-static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
-				    unsigned long *timeout_cap)
+static void tpm_tis_update_timeouts(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int i, rc;
+	int rc;
 	u32 did_vid;
 
 	rc = tpm_tis_read32(priv, TPM_DID_VID(0), &did_vid);
 	if (rc < 0)
 		return rc;
 
-	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
-		if (vendor_timeout_overrides[i].did_vid != did_vid)
-			continue;
-		memcpy(timeout_cap, vendor_timeout_overrides[i].timeout_us,
-		       sizeof(vendor_timeout_overrides[i].timeout_us));
-		return true;
+	switch (did_vid) {
+	case 0x32041114: /* Atmel 3204 */
+		chip->timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+		chip->timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+		chip->timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+		chip->timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+		chip->timeout_adjusted = true;
+		break;
 	}
-
-	return false;
 }
 
 /*
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 706e63e..2380ebf 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -41,8 +41,7 @@ struct tpm_class_ops {
 	int (*send) (struct tpm_chip *chip, u8 *buf, size_t len);
 	void (*cancel) (struct tpm_chip *chip);
 	u8 (*status) (struct tpm_chip *chip);
-	bool (*update_timeouts)(struct tpm_chip *chip,
-				unsigned long *timeout_cap);
+	void (*update_timeouts)(struct tpm_chip *chip);
 
 };
 
-- 
1.9.1
