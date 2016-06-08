From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 3/4] tpm: Allow TPM chip drivers to
	override reported command durations
Date: Tue,  7 Jun 2016 17:45:39 -0700
Message-ID: <1465346740-60120-4-git-send-email-eswierk@skyportsystems.com>
References: <1465346740-60120-1-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1465346740-60120-1-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Some TPM chips report bogus command durations in their capabilities,
just as others report incorrect timeouts. Rework tpm_get_timeouts()
to allow chip drivers to override either via a single callback.
Also clean up handling of TPMs that report milliseconds instead of
microseconds.

Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 177 +++++++++++++++++++++------------------
 drivers/char/tpm/tpm_tis.c       |  35 ++------
 include/linux/tpm.h              |   3 +-
 3 files changed, 106 insertions(+), 109 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index cc1e5bc..b8a08bb 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -502,123 +502,138 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 				"attempting to start the TPM");
 }
 
-int tpm_get_timeouts(struct tpm_chip *chip)
+static int tpm_get_cap_prop(struct tpm_chip *chip, __be32 type, int size,
+			    cap_t *cap, char *desc)
 {
 	struct tpm_cmd_t tpm_cmd;
-	unsigned long new_timeout[4];
-	unsigned long old_timeout[4];
-	struct duration_t *duration_cap;
 	ssize_t rc;
 
 	tpm_cmd.header.in = tpm_getcap_header;
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
+	tpm_cmd.params.getcap_in.subcap = type;
 	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
 
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
 		   Execute a startup command. */
-		dev_info(chip->pdev, "Issuing TPM_STARTUP");
+		dev_info(chip->pdev, "Issuing TPM_STARTUP\n");
 		if (tpm_startup(chip, TPM_ST_CLEAR))
 			return rc;
 
 		tpm_cmd.header.in = tpm_getcap_header;
 		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
+		tpm_cmd.params.getcap_in.subcap = type;
 		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
 				  NULL);
 	}
+
 	if (rc) {
 		dev_err(chip->pdev,
-			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
-			rc);
-		goto duration;
+			"Error %zd reading %s\n", rc, desc);
+		return -EINVAL;
 	}
 
 	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
 	    be32_to_cpu(tpm_cmd.header.out.length)
-	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
+	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + size * sizeof(u32)) {
+		dev_err(chip->pdev,
+			"Bad return code or length reading %s\n", desc);
 		return -EINVAL;
-
-	old_timeout[0] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.a);
-	old_timeout[1] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.b);
-	old_timeout[2] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.c);
-	old_timeout[3] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.d);
-	memcpy(new_timeout, old_timeout, sizeof(new_timeout));
-
-	/*
-	 * Provide ability for vendor overrides of timeout values in case
-	 * of misreporting.
-	 */
-	if (chip->ops->update_timeouts != NULL)
-		chip->vendor.timeout_adjusted =
-			chip->ops->update_timeouts(chip, new_timeout);
-
-	if (!chip->vendor.timeout_adjusted) {
-		/* Don't overwrite default if value is 0 */
-		if (new_timeout[0] != 0 && new_timeout[0] < 1000) {
-			int i;
-
-			/* timeouts in msec rather usec */
-			for (i = 0; i != ARRAY_SIZE(new_timeout); i++)
-				new_timeout[i] *= 1000;
-			chip->vendor.timeout_adjusted = true;
-		}
 	}
 
-	/* Report adjusted timeouts */
-	if (chip->vendor.timeout_adjusted) {
-		dev_info(chip->pdev,
-			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->%luus D %lu->%luus\n",
-			 old_timeout[0], new_timeout[0],
-			 old_timeout[1], new_timeout[1],
-			 old_timeout[2], new_timeout[2],
-			 old_timeout[3], new_timeout[3]);
-	}
+	memcpy(cap, &tpm_cmd.params.getcap_out.cap, sizeof(cap_t));
 
-	chip->vendor.timeout_a = usecs_to_jiffies(new_timeout[0]);
-	chip->vendor.timeout_b = usecs_to_jiffies(new_timeout[1]);
-	chip->vendor.timeout_c = usecs_to_jiffies(new_timeout[2]);
-	chip->vendor.timeout_d = usecs_to_jiffies(new_timeout[3]);
+	return 0;
+}
 
-duration:
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
+int tpm_get_timeouts(struct tpm_chip *chip)
+{
+	cap_t cap1, cap2;
+	int rc1, rc2;
+	struct tpm_vendor_specific orig_vendor;
+
+	rc1 = tpm_get_cap_prop(chip, TPM_CAP_PROP_TIS_TIMEOUT, 4, &cap1,
+			       "timeouts");
+	if (rc1 == 0) {
+		be32_to_cpus(&cap1.timeout.a);
+		be32_to_cpus(&cap1.timeout.b);
+		be32_to_cpus(&cap1.timeout.c);
+		be32_to_cpus(&cap1.timeout.d);
+		chip->vendor.timeout_a = usecs_to_jiffies(cap1.timeout.a);
+		chip->vendor.timeout_b = usecs_to_jiffies(cap1.timeout.b);
+		chip->vendor.timeout_c = usecs_to_jiffies(cap1.timeout.c);
+		chip->vendor.timeout_d = usecs_to_jiffies(cap1.timeout.d);
+	}
+	rc2 = tpm_get_cap_prop(chip, TPM_CAP_PROP_TIS_DURATION, 3, &cap2,
+			       "durations");
+	if (rc2 == 0) {
+		be32_to_cpus(&cap2.duration.tpm_short);
+		be32_to_cpus(&cap2.duration.tpm_medium);
+		be32_to_cpus(&cap2.duration.tpm_long);
+		chip->vendor.duration[TPM_SHORT] =
+			usecs_to_jiffies(cap2.duration.tpm_short);
+		chip->vendor.duration[TPM_MEDIUM] =
+			usecs_to_jiffies(cap2.duration.tpm_medium);
+		chip->vendor.duration[TPM_LONG] =
+			usecs_to_jiffies(cap2.duration.tpm_long);
+	}
 
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			      "attempting to determine the durations");
-	if (rc)
-		return rc;
+	memcpy(&orig_vendor, &chip->vendor, sizeof(orig_vendor));
+
+	/* Some TPMs report timeouts in milliseconds rather than
+	   microseconds. Use a value between 1 and 1000 as an
+	   indication that this is the case. */
+	if (rc1 == 0 && cap1.timeout.a > 0 && cap1.timeout.a < 1000) {
+		chip->vendor.timeout_a = msecs_to_jiffies(cap1.timeout.a);
+		chip->vendor.timeout_b = msecs_to_jiffies(cap1.timeout.b);
+		chip->vendor.timeout_c = msecs_to_jiffies(cap1.timeout.c);
+		chip->vendor.timeout_d = msecs_to_jiffies(cap1.timeout.d);
+		chip->vendor.timeout_adjusted = true;
+	}
+	/* Interpret duration values between 1 and 10000 as
+	   milliseconds to deal with TPMs like the Broadcom BCM0102 in
+	   the Dell Latitude D820. */
+	if (rc2 == 0 && cap2.duration.tpm_short > 0 &&
+	    cap2.duration.tpm_short < 10000) {
+		chip->vendor.duration[TPM_SHORT] =
+			msecs_to_jiffies(cap2.duration.tpm_short);
+		chip->vendor.duration[TPM_MEDIUM] =
+			msecs_to_jiffies(cap2.duration.tpm_medium);
+		chip->vendor.duration[TPM_LONG] =
+			msecs_to_jiffies(cap2.duration.tpm_long);
+		chip->vendor.duration_adjusted = true;
+	}
 
-	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
-	    be32_to_cpu(tpm_cmd.header.out.length)
-	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
-		return -EINVAL;
+	if (chip->ops->update_timeouts != NULL)
+		chip->ops->update_timeouts(chip);
 
-	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
-	chip->vendor.duration[TPM_SHORT] =
-	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
-	chip->vendor.duration[TPM_MEDIUM] =
-	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
-	chip->vendor.duration[TPM_LONG] =
-	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
-
-	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
-	 * value wrong and apparently reports msecs rather than usecs. So we
-	 * fix up the resulting too-small TPM_SHORT value to make things work.
-	 * We also scale the TPM_MEDIUM and -_LONG values by 1000.
-	 */
-	if (chip->vendor.duration[TPM_SHORT] < (HZ / 100)) {
-		chip->vendor.duration[TPM_SHORT] = HZ;
-		chip->vendor.duration[TPM_MEDIUM] *= 1000;
-		chip->vendor.duration[TPM_LONG] *= 1000;
-		chip->vendor.duration_adjusted = true;
-		dev_info(chip->pdev, "Adjusting TPM timeout parameters.");
+	if (chip->vendor.timeout_adjusted) {
+		dev_info(chip->pdev,
+			 HW_ERR "Adjusted timeouts: A %u->%uus B %u->%uus"
+			 " C %u->%uus D %u->%uus\n",
+			 jiffies_to_usecs(orig_vendor.timeout_a),
+			 jiffies_to_usecs(chip->vendor.timeout_a),
+			 jiffies_to_usecs(orig_vendor.timeout_b),
+			 jiffies_to_usecs(chip->vendor.timeout_b),
+			 jiffies_to_usecs(orig_vendor.timeout_c),
+			 jiffies_to_usecs(chip->vendor.timeout_c),
+			 jiffies_to_usecs(orig_vendor.timeout_d),
+			 jiffies_to_usecs(chip->vendor.timeout_d));
+	}
+	if (chip->vendor.duration_adjusted) {
+		dev_info(chip->pdev,
+			 HW_ERR "Adjusted durations: short %u->%uus"
+			 " medium %u->%uus long %u->%uus\n",
+			 jiffies_to_usecs(orig_vendor.duration[TPM_SHORT]),
+			 jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
+			 jiffies_to_usecs(orig_vendor.duration[TPM_MEDIUM]),
+			 jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
+			 jiffies_to_usecs(orig_vendor.duration[TPM_LONG]),
+			 jiffies_to_usecs(chip->vendor.duration[TPM_LONG]));
 	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_get_timeouts);
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 088fa86..5c74980 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -475,34 +475,17 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
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
-	int i;
-	u32 did_vid;
-
-	did_vid = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
-
-	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
-		if (vendor_timeout_overrides[i].did_vid != did_vid)
-			continue;
-		memcpy(timeout_cap, vendor_timeout_overrides[i].timeout_us,
-		       sizeof(vendor_timeout_overrides[i].timeout_us));
-		return true;
+	switch (ioread32(chip->vendor.iobase + TPM_DID_VID(0))) {
+	case 0x32041114: /* Atmel 3204 */
+		chip->vendor.timeout_a = TIS_SHORT_TIMEOUT * HZ / 1000;
+		chip->vendor.timeout_b = TIS_LONG_TIMEOUT * HZ / 1000;
+		chip->vendor.timeout_c = TIS_SHORT_TIMEOUT * HZ / 1000;
+		chip->vendor.timeout_d = TIS_SHORT_TIMEOUT * HZ / 1000;
+		chip->vendor.timeout_adjusted = true;
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


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
