From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 1/2] tpm: Clean up reading of timeout and
	duration capabilities
Date: Mon, 19 Sep 2016 23:22:08 +0300
Message-ID: <1474316530-17315-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1474316530-17315-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1474316530-17315-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>

Call tpm_getcap() from tpm_get_timeouts() to eliminate redundant
code. Return all errors to the caller rather than swallowing them
(e.g. when tpm_transmit_cmd() returns nonzero).

Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 65 +++++++++++-----------------------------
 1 file changed, 17 insertions(+), 48 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 8de6187..ca6162e 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -488,10 +488,9 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
-	struct tpm_cmd_t tpm_cmd;
+	cap_t cap;
 	unsigned long new_timeout[4];
 	unsigned long old_timeout[4];
-	struct duration_t *duration_cap;
 	ssize_t rc;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
@@ -509,43 +508,25 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		return 0;
 	}
 
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
-			      NULL);
-
+	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
+			"attempting to determine the timeouts");
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
 		   Execute a startup command. */
-		dev_info(&chip->dev, "Issuing TPM_STARTUP");
+		dev_info(&chip->dev, "Issuing TPM_STARTUP\n");
 		if (tpm_startup(chip, TPM_ST_CLEAR))
 			return rc;
 
-		tpm_cmd.header.in = tpm_getcap_header;
-		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-				      0, NULL);
+		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
+				"attempting to determine the timeouts");
 	}
-	if (rc) {
-		dev_err(&chip->dev,
-			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
-			rc);
-		goto duration;
-	}
-
-	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
-	    be32_to_cpu(tpm_cmd.header.out.length)
-	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
-		return -EINVAL;
+	if (rc)
+		return rc;
 
-	old_timeout[0] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.a);
-	old_timeout[1] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.b);
-	old_timeout[2] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.c);
-	old_timeout[3] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.d);
+	old_timeout[0] = be32_to_cpu(cap.timeout.a);
+	old_timeout[1] = be32_to_cpu(cap.timeout.b);
+	old_timeout[2] = be32_to_cpu(cap.timeout.c);
+	old_timeout[3] = be32_to_cpu(cap.timeout.d);
 	memcpy(new_timeout, old_timeout, sizeof(new_timeout));
 
 	/*
@@ -583,29 +564,17 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	chip->timeout_c = usecs_to_jiffies(new_timeout[2]);
 	chip->timeout_d = usecs_to_jiffies(new_timeout[3]);
 
-duration:
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
-
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
-			      "attempting to determine the durations");
+	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_DURATION, &cap,
+			"attempting to determine the durations");
 	if (rc)
 		return rc;
 
-	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
-	    be32_to_cpu(tpm_cmd.header.out.length)
-	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
-		return -EINVAL;
-
-	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
 	chip->duration[TPM_SHORT] =
-	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
+		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_short));
 	chip->duration[TPM_MEDIUM] =
-	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
+		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_medium));
 	chip->duration[TPM_LONG] =
-	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
+		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_long));
 
 	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
 	 * value wrong and apparently reports msecs rather than usecs. So we
-- 
2.7.4


------------------------------------------------------------------------------
